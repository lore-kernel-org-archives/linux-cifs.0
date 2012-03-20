From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v3 08/10] CIFS: Separate protocol-specific code from cifs_readv_receive code
Date: Tue, 20 Mar 2012 13:00:38 +0300
Message-ID: <1332237640-10145-9-git-send-email-piastry@etersoft.ru>
References: <1332237640-10145-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332237640-10145-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
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
index 34a897e..a403398 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -341,6 +341,18 @@ has_credits(struct TCP_Server_Info *server, int *credits)
 	return num > 0;
 }
 
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
index 15c9b59..db38a40 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -106,7 +106,7 @@ extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
 extern int cifs_set_port(struct sockaddr *addr, const unsigned short int port);
 extern int cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
 				const unsigned short int port);
-extern int map_smb_to_linux_error(struct smb_hdr *smb, bool logErr);
+extern int map_smb_to_linux_error(char *buf, bool logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifs_tcon *, int /* length of
 			    fixed section (word count) in two byte units */);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a7ed01c..c45d445 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1414,8 +1414,7 @@ cifs_readdata_free(struct cifs_readdata *rdata)
 static int
 cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	READ_RSP *rsp = (READ_RSP *)server->smallbuf;
-	unsigned int rfclen = be32_to_cpu(rsp->hdr.smb_buf_length);
+	unsigned int rfclen = get_rfc1002_length(server->smallbuf);
 	int remaining = rfclen + 4 - server->total_read;
 	struct cifs_readdata *rdata = mid->callback_data;
 
@@ -1424,7 +1423,7 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 		length = cifs_read_from_socket(server, server->bigbuf,
 				min_t(unsigned int, remaining,
-					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE));
+					CIFSMaxBufSize + max_header_size()));
 		if (length < 0)
 			return length;
 		server->total_read += length;
@@ -1435,14 +1434,35 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
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
@@ -1455,10 +1475,9 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
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
@@ -1467,7 +1486,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	server->total_read += length;
 
 	/* Was the SMB read successful? */
-	rdata->result = map_smb_to_linux_error(&rsp->hdr, false);
+	rdata->result = map_smb_to_linux_error(buf, false);
 	if (rdata->result != 0) {
 		cFYI(1, "%s: server returned error %d", __func__,
 			rdata->result);
@@ -1475,14 +1494,14 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
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
@@ -1506,7 +1525,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	len = data_offset - server->total_read;
 	if (len > 0) {
 		/* read any junk before data into the rest of smallbuf */
-		rdata->iov[0].iov_base = server->smallbuf + server->total_read;
+		rdata->iov[0].iov_base = buf + server->total_read;
 		rdata->iov[0].iov_len = len;
 		length = cifs_readv_from_socket(server, rdata->iov, 1, len);
 		if (length < 0)
@@ -1515,15 +1534,14 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
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
@@ -1602,11 +1620,11 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
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
index 0949a4f..07cf97e 100644
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
