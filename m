From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 4/6] CIFS: Separate protocol-specific code from cifs_readv_receive code
Date: Thu,  9 Feb 2012 11:41:27 +0300
Message-ID: <1328776890-4190-4-git-send-email-piastry@etersoft.ru>
References: <1328776890-4190-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328776890-4190-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   12 ++++++++++
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/cifssmb.c   |   58 +++++++++++++++++++++++++++++++++-----------------
 fs/cifs/connect.c   |   12 ----------
 fs/cifs/netmisc.c   |    3 +-
 5 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7894a69..f6e265e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -314,6 +314,18 @@ struct TCP_Server_Info {
 #endif
 };
 
+static inline size_t
+header_size(void)
+{
+	return sizeof(struct smb_hdr);
+}
+
+static inline size_t
+max_header_size(void)
+{
+	return MAX_CIFS_HDR_SIZE;
+}
+
 /*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c0be830..f40b566 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -103,7 +103,7 @@ extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
 extern int cifs_set_port(struct sockaddr *addr, const unsigned short int port);
 extern int cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
 				const unsigned short int port);
-extern int map_smb_to_linux_error(struct smb_hdr *smb, bool logErr);
+extern int map_smb_to_linux_error(char *buf, bool logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifs_tcon *, int /* length of
 			    fixed section (word count) in two byte units */);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 877976a..fae163d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1411,8 +1411,7 @@ cifs_readdata_free(struct cifs_readdata *rdata)
 static int
 cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	READ_RSP *rsp = (READ_RSP *)server->smallbuf;
-	unsigned int rfclen = be32_to_cpu(rsp->hdr.smb_buf_length);
+	unsigned int rfclen = get_rfc1002_length(server->smallbuf);
 	int remaining = rfclen + 4 - server->total_read;
 	struct cifs_readdata *rdata = mid->callback_data;
 
@@ -1421,7 +1420,7 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 		length = cifs_read_from_socket(server, server->bigbuf,
 				min_t(unsigned int, remaining,
-					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE));
+					CIFSMaxBufSize + max_header_size()));
 		if (length < 0)
 			return length;
 		server->total_read += length;
@@ -1432,14 +1431,35 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
+static inline size_t
+read_rsp_size(void)
+{
+	return sizeof(READ_RSP);
+}
+
+static inline unsigned int
+read_data_offset(char *buf)
+{
+	READ_RSP *rsp = (READ_RSP *)buf;
+	return le16_to_cpu(rsp->DataOffset);
+}
+
+static inline unsigned int
+read_data_length(char *buf)
+{
+	READ_RSP *rsp = (READ_RSP *)buf;
+	return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
+	       le16_to_cpu(rsp->DataLength);
+}
+
 static int
 cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length, len;
 	unsigned int data_offset, remaining, data_len;
 	struct cifs_readdata *rdata = mid->callback_data;
-	READ_RSP *rsp = (READ_RSP *)server->smallbuf;
-	unsigned int rfclen = be32_to_cpu(rsp->hdr.smb_buf_length) + 4;
+	char *buf = server->smallbuf;
+	unsigned int buflen = get_rfc1002_length(buf) + 4;
 	u64 eof;
 	pgoff_t eof_index;
 	struct page *page, *tpage;
@@ -1452,10 +1472,9 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * can if there's not enough data. At this point, we've read down to
 	 * the Mid.
 	 */
-	len = min_t(unsigned int, rfclen, sizeof(*rsp)) -
-			sizeof(struct smb_hdr) + 1;
+	len = min_t(unsigned int, buflen, read_rsp_size()) - header_size() + 1;
 
-	rdata->iov[0].iov_base = server->smallbuf + sizeof(struct smb_hdr) - 1;
+	rdata->iov[0].iov_base = buf + header_size() - 1;
 	rdata->iov[0].iov_len = len;
 
 	length = cifs_readv_from_socket(server, rdata->iov, 1, len);
@@ -1464,7 +1483,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	server->total_read += length;
 
 	/* Was the SMB read successful? */
-	rdata->result = map_smb_to_linux_error(&rsp->hdr, false);
+	rdata->result = map_smb_to_linux_error(buf, false);
 	if (rdata->result != 0) {
 		cFYI(1, "%s: server returned error %d", __func__,
 			rdata->result);
@@ -1472,14 +1491,14 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* Is there enough to get to the rest of the READ_RSP header? */
-	if (server->total_read < sizeof(READ_RSP)) {
+	if (server->total_read < read_rsp_size()) {
 		cFYI(1, "%s: server returned short header. got=%u expected=%zu",
-			__func__, server->total_read, sizeof(READ_RSP));
+			__func__, server->total_read, read_rsp_size());
 		rdata->result = -EIO;
 		return cifs_readv_discard(server, mid);
 	}
 
-	data_offset = le16_to_cpu(rsp->DataOffset) + 4;
+	data_offset = read_data_offset(buf) + 4;
 	if (data_offset < server->total_read) {
 		/*
 		 * win2k8 sometimes sends an offset of 0 when the read
@@ -1503,7 +1522,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	len = data_offset - server->total_read;
 	if (len > 0) {
 		/* read any junk before data into the rest of smallbuf */
-		rdata->iov[0].iov_base = server->smallbuf + server->total_read;
+		rdata->iov[0].iov_base = buf + server->total_read;
 		rdata->iov[0].iov_len = len;
 		length = cifs_readv_from_socket(server, rdata->iov, 1, len);
 		if (length < 0)
@@ -1512,15 +1531,14 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* set up first iov for signature check */
-	rdata->iov[0].iov_base = server->smallbuf;
+	rdata->iov[0].iov_base = buf;
 	rdata->iov[0].iov_len = server->total_read;
 	cFYI(1, "0: iov_base=%p iov_len=%zu",
 		rdata->iov[0].iov_base, rdata->iov[0].iov_len);
 
 	/* how much data is in the response? */
-	data_len = le16_to_cpu(rsp->DataLengthHigh) << 16;
-	data_len += le16_to_cpu(rsp->DataLength);
-	if (data_offset + data_len > rfclen) {
+	data_len = read_data_length(buf);
+	if (data_offset + data_len > buflen) {
 		/* data_len is corrupt -- discard frame */
 		rdata->result = -EIO;
 		return cifs_readv_discard(server, mid);
@@ -1599,11 +1617,11 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	rdata->bytes = length;
 
-	cFYI(1, "total_read=%u rfclen=%u remaining=%u", server->total_read,
-		rfclen, remaining);
+	cFYI(1, "total_read=%u buflen=%u remaining=%u", server->total_read,
+		buflen, remaining);
 
 	/* discard anything left over */
-	if (server->total_read < rfclen)
+	if (server->total_read < buflen)
 		return cifs_readv_discard(server, mid);
 
 	dequeue_mid(mid, false);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 57e956d..a8d34a5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -338,18 +338,6 @@ requeue_echo:
 	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
 }
 
-static inline size_t
-header_size(void)
-{
-	return sizeof(struct smb_hdr);
-}
-
-static inline size_t
-max_header_size(void)
-{
-	return MAX_CIFS_HDR_SIZE;
-}
-
 static bool
 allocate_buffers(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 73e47e8..dd23a32 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -836,8 +836,9 @@ ntstatus_to_dos(__u32 ntstatus, __u8 *eclass, __u16 *ecode)
 }
 
 int
-map_smb_to_linux_error(struct smb_hdr *smb, bool logErr)
+map_smb_to_linux_error(char *buf, bool logErr)
 {
+	struct smb_hdr *smb = (struct smb_hdr *)buf;
 	unsigned int i;
 	int rc = -EIO;	/* if transport error smb error may not be set */
 	__u8 smberrclass;
-- 
1.7.1
