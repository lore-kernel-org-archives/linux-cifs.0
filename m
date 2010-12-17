From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/18] cifs: remove code for setting timeouts on requests
Date: Fri, 17 Dec 2010 10:08:15 -0500
Message-ID: <1292598497-29796-17-git-send-email-jlayton@redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since we don't time out individual requests anymore, remove the code
that we used to use for setting timeouts on different requests.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    9 +++------
 fs/cifs/cifssmb.c   |    8 ++++----
 fs/cifs/connect.c   |    2 +-
 fs/cifs/file.c      |   44 +++++++-------------------------------------
 fs/cifs/sess.c      |    2 +-
 fs/cifs/transport.c |    2 +-
 6 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 64d69f9..d96f186 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -636,12 +636,9 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   CIFS_IOVEC            4    /* array of response buffers */
 
 /* Type of Request to SendReceive2 */
-#define   CIFS_STD_OP	        0    /* normal request timeout */
-#define   CIFS_LONG_OP          1    /* long op (up to 45 sec, oplock time) */
-#define   CIFS_VLONG_OP         2    /* sloow op - can take up to 180 seconds */
-#define   CIFS_BLOCKING_OP      4    /* operation can block */
-#define   CIFS_ASYNC_OP         8    /* do not wait for response */
-#define   CIFS_TIMEOUT_MASK 0x00F    /* only one of 5 above set in req */
+#define   CIFS_BLOCKING_OP      1    /* operation can block */
+#define   CIFS_ASYNC_OP         2    /* do not wait for response */
+#define   CIFS_TIMEOUT_MASK 0x003    /* only one of above set in req */
 #define   CIFS_LOG_ERROR    0x010    /* log NT STATUS if non-zero */
 #define   CIFS_LARGE_BUF_OP 0x020    /* large request buffer */
 #define   CIFS_NO_RESP      0x040    /* no response buffer required */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index fc8145f..606deba 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1240,7 +1240,7 @@ OldOpenRetry:
 	pSMB->ByteCount = cpu_to_le16(count);
 	/* long_op set to 1 to allow for oplock break timeouts */
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-			(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP);
+			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_opens);
 	if (rc) {
 		cFYI(1, "Error in Open = %d", rc);
@@ -1353,7 +1353,7 @@ openRetry:
 	pSMB->ByteCount = cpu_to_le16(count);
 	/* long_op set to 1 to allow for oplock break timeouts */
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-			(struct smb_hdr *)pSMBr, &bytes_returned, CIFS_LONG_OP);
+			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->num_opens);
 	if (rc) {
 		cFYI(1, "Error in Open = %d", rc);
@@ -1435,7 +1435,7 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
 	iov[0].iov_base = (char *)pSMB;
 	iov[0].iov_len = pSMB->hdr.smb_buf_length + 4;
 	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovecs */,
-			 &resp_buf_type, CIFS_STD_OP | CIFS_LOG_ERROR);
+			 &resp_buf_type, CIFS_LOG_ERROR);
 	cifs_stats_inc(&tcon->num_reads);
 	pSMBr = (READ_RSP *)iov[0].iov_base;
 	if (rc) {
@@ -3030,7 +3030,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 	iov[0].iov_len = pSMB->hdr.smb_buf_length + 4;
 
 	rc = SendReceive2(xid, tcon->ses, iov, 1 /* num iovec */, &buf_type,
-			 CIFS_STD_OP);
+			 0);
 	cifs_stats_inc(&tcon->num_acl_get);
 	if (rc) {
 		cFYI(1, "Send error in QuerySecDesc = %d", rc);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2ad3c67..0c257d6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3024,7 +3024,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 	pSMB->ByteCount = cpu_to_le16(count);
 
 	rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
-			 CIFS_STD_OP);
+			 0);
 
 	/* above now done in SendReceive */
 	if ((rc == 0) && (tcon != NULL)) {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 400c948..0490f53 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -839,29 +839,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 	return rc;
 }
 
-/*
- * Set the timeout on write requests past EOF. For some servers (Windows)
- * these calls can be very long.
- *
- * If we're writing >10M past the EOF we give a 180s timeout. Anything less
- * than that gets a 45s timeout. Writes not past EOF get 15s timeouts.
- * The 10M cutoff is totally arbitrary. A better scheme for this would be
- * welcome if someone wants to suggest one.
- *
- * We may be able to do a better job with this if there were some way to
- * declare that a file should be sparse.
- */
-static int
-cifs_write_timeout(struct cifsInodeInfo *cifsi, loff_t offset)
-{
-	if (offset <= cifsi->server_eof)
-		return CIFS_STD_OP;
-	else if (offset > (cifsi->server_eof + (10 * 1024 * 1024)))
-		return CIFS_VLONG_OP;
-	else
-		return CIFS_LONG_OP;
-}
-
 /* update the file size (if needed) after a write */
 static void
 cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
@@ -882,7 +859,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	unsigned int total_written;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
-	int xid, long_op;
+	int xid;
 	struct cifsFileInfo *open_file;
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 
@@ -903,7 +880,6 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 
 	xid = GetXid();
 
-	long_op = cifs_write_timeout(cifsi, *poffset);
 	for (total_written = 0; write_size > total_written;
 	     total_written += bytes_written) {
 		rc = -EAGAIN;
@@ -931,7 +907,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 				min_t(const int, cifs_sb->wsize,
 				      write_size - total_written),
 				*poffset, &bytes_written,
-				NULL, write_data + total_written, long_op);
+				NULL, write_data + total_written, 0);
 		}
 		if (rc || (bytes_written == 0)) {
 			if (total_written)
@@ -944,8 +920,6 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 			cifs_update_eof(cifsi, *poffset, bytes_written);
 			*poffset += bytes_written;
 		}
-		long_op = CIFS_STD_OP; /* subsequent writes fast -
-				    15 seconds is plenty */
 	}
 
 	cifs_stats_bytes_written(pTcon, total_written);
@@ -974,7 +948,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 	unsigned int total_written;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
-	int xid, long_op;
+	int xid;
 	struct dentry *dentry = open_file->dentry;
 	struct cifsInodeInfo *cifsi = CIFS_I(dentry->d_inode);
 
@@ -987,7 +961,6 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 
 	xid = GetXid();
 
-	long_op = cifs_write_timeout(cifsi, *poffset);
 	for (total_written = 0; write_size > total_written;
 	     total_written += bytes_written) {
 		rc = -EAGAIN;
@@ -1017,7 +990,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 				rc = CIFSSMBWrite2(xid, pTcon,
 						open_file->netfid, len,
 						*poffset, &bytes_written,
-						iov, 1, long_op);
+						iov, 1, 0);
 			} else
 				rc = CIFSSMBWrite(xid, pTcon,
 					 open_file->netfid,
@@ -1025,7 +998,7 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 					       write_size - total_written),
 					 *poffset, &bytes_written,
 					 write_data + total_written,
-					 NULL, long_op);
+					 NULL, 0);
 		}
 		if (rc || (bytes_written == 0)) {
 			if (total_written)
@@ -1038,8 +1011,6 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
 			cifs_update_eof(cifsi, *poffset, bytes_written);
 			*poffset += bytes_written;
 		}
-		long_op = CIFS_STD_OP; /* subsequent writes fast -
-				    15 seconds is plenty */
 	}
 
 	cifs_stats_bytes_written(pTcon, total_written);
@@ -1239,7 +1210,7 @@ static int cifs_writepages(struct address_space *mapping,
 	struct pagevec pvec;
 	int rc = 0;
 	int scanned = 0;
-	int xid, long_op;
+	int xid;
 
 	cifs_sb = CIFS_SB(mapping->host->i_sb);
 
@@ -1384,11 +1355,10 @@ retry_write:
 				cERROR(1, "No writable handles for inode");
 				rc = -EBADF;
 			} else {
-				long_op = cifs_write_timeout(cifsi, offset);
 				rc = CIFSSMBWrite2(xid, tcon, open_file->netfid,
 						   bytes_to_write, offset,
 						   &bytes_written, iov, n_iov,
-						   long_op);
+						   0);
 				cifsFileInfo_put(open_file);
 			}
 
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2997533..50b74a5 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -881,7 +881,7 @@ ssetup_ntlmssp_authenticate:
 	BCC_LE(smb_buf) = cpu_to_le16(count);
 
 	rc = SendReceive2(xid, ses, iov, 3 /* num_iovecs */, &resp_buf_type,
-			  CIFS_STD_OP /* not long */ | CIFS_LOG_ERROR);
+			  CIFS_LOG_ERROR);
 	/* SMB request buf freed in SendReceive2 */
 
 	pSMB = (SESSION_SETUP_ANDX *)iov[0].iov_base;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index db29f80..f769047 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -817,7 +817,7 @@ send_lock_cancel(const unsigned int xid, struct cifsTconInfo *tcon,
 	pSMB->hdr.Mid = GetNextMid(ses->server);
 
 	return SendReceive(xid, ses, in_buf, out_buf,
-			&bytes_returned, CIFS_STD_OP);
+			&bytes_returned, 0);
 }
 
 int
-- 
1.7.3.3
