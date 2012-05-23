From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 3/5] CIFS: Move protocol specific part from cifs_readv_receive to ops struct
Date: Wed, 23 May 2012 12:06:44 +0400
Message-ID: <1337760406-3015-4-git-send-email-piastry@etersoft.ru>
References: <1337760406-3015-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337760406-3015-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    7 +++++++
 fs/cifs/cifssmb.c  |   34 +++++++---------------------------
 fs/cifs/smb1ops.c  |   19 +++++++++++++++++++
 3 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9ee832d..8251401 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -169,6 +169,12 @@ struct smb_version_operations {
 	/* check response: verify signature, map error */
 	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     bool);
+	/* data offset from read response message */
+	unsigned int (*read_data_offset)(char *);
+	/* data length from read response message */
+	unsigned int (*read_data_length)(char *);
+	/* map smb to linux error */
+	int (*map_error)(char *, bool);
 };
 
 struct smb_version_values {
@@ -179,6 +185,7 @@ struct smb_version_values {
 	__u32		unlock_lock_type;
 	size_t		header_size;
 	size_t		max_header_size;
+	size_t		read_rsp_size;
 };
 
 #define HEADER_SIZE(server) (server->vals->header_size)
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 77463f7..b1f3751 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1411,27 +1411,6 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
-static inline size_t
-read_rsp_size(void)
-{
-	return sizeof(READ_RSP);
-}
-
-static inline unsigned int
-read_data_offset(char *buf)
-{
-	READ_RSP *rsp = (READ_RSP *)buf;
-	return le16_to_cpu(rsp->DataOffset);
-}
-
-static inline unsigned int
-read_data_length(char *buf)
-{
-	READ_RSP *rsp = (READ_RSP *)buf;
-	return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
-	       le16_to_cpu(rsp->DataLength);
-}
-
 static int
 cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
@@ -1449,7 +1428,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * can if there's not enough data. At this point, we've read down to
 	 * the Mid.
 	 */
-	len = min_t(unsigned int, buflen, read_rsp_size()) -
+	len = min_t(unsigned int, buflen, server->vals->read_rsp_size) -
 							HEADER_SIZE(server) + 1;
 
 	rdata->iov[0].iov_base = buf + HEADER_SIZE(server) - 1;
@@ -1461,7 +1440,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	server->total_read += length;
 
 	/* Was the SMB read successful? */
-	rdata->result = map_smb_to_linux_error(buf, false);
+	rdata->result = server->ops->map_error(buf, false);
 	if (rdata->result != 0) {
 		cFYI(1, "%s: server returned error %d", __func__,
 			rdata->result);
@@ -1469,14 +1448,15 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* Is there enough to get to the rest of the READ_RSP header? */
-	if (server->total_read < read_rsp_size()) {
+	if (server->total_read < server->vals->read_rsp_size) {
 		cFYI(1, "%s: server returned short header. got=%u expected=%zu",
-			__func__, server->total_read, read_rsp_size());
+			__func__, server->total_read,
+			server->vals->read_rsp_size);
 		rdata->result = -EIO;
 		return cifs_readv_discard(server, mid);
 	}
 
-	data_offset = read_data_offset(buf) + 4;
+	data_offset = server->ops->read_data_offset(buf) + 4;
 	if (data_offset < server->total_read) {
 		/*
 		 * win2k8 sometimes sends an offset of 0 when the read
@@ -1515,7 +1495,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		rdata->iov[0].iov_base, rdata->iov[0].iov_len);
 
 	/* how much data is in the response? */
-	data_len = read_data_length(buf);
+	data_len = server->ops->read_data_length(buf);
 	if (data_offset + data_len > buflen) {
 		/* data_len is corrupt -- discard frame */
 		rdata->result = -EIO;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 3668e81..daa2ede 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -66,11 +66,29 @@ cifs_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2)
 	return ob1->netfid == ob2->netfid;
 }
 
+static unsigned int
+cifs_read_data_offset(char *buf)
+{
+	READ_RSP *rsp = (READ_RSP *)buf;
+	return le16_to_cpu(rsp->DataOffset);
+}
+
+static unsigned int
+cifs_read_data_length(char *buf)
+{
+	READ_RSP *rsp = (READ_RSP *)buf;
+	return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
+	       le16_to_cpu(rsp->DataLength);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
 	.setup_request = cifs_setup_request,
 	.check_receive = cifs_check_receive,
+	.read_data_offset = cifs_read_data_offset,
+	.read_data_length = cifs_read_data_length,
+	.map_error = map_smb_to_linux_error,
 };
 
 struct smb_version_values smb1_values = {
@@ -81,4 +99,5 @@ struct smb_version_values smb1_values = {
 	.unlock_lock_type = 0,
 	.header_size = sizeof(struct smb_hdr),
 	.max_header_size = MAX_CIFS_HDR_SIZE,
+	.read_rsp_size = sizeof(READ_RSP),
 };
-- 
1.7.1
