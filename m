From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 27/45] CIFS: Add readpage support for SMB2
Date: Wed, 18 Jul 2012 19:48:43 +0400
Message-ID: <1342626541-29872-28-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c   |   12 ++++++++++++
 fs/cifs/smb2pdu.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    2 ++
 3 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 74e8bce..4dca13d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -384,6 +384,17 @@ smb2_read_data_length(char *buf)
 	return le32_to_cpu(rsp->DataLength);
 }
 
+
+static int
+smb2_sync_read(const unsigned int xid, struct cifsFileInfo *cfile,
+	       struct cifs_io_parms *parms, unsigned int *bytes_read,
+	       char **buf, int *buf_type)
+{
+	parms->persistent_fid = cfile->fid.persistent_fid;
+	parms->volatile_fid = cfile->fid.volatile_fid;
+	return SMB2_read(xid, parms, bytes_read, buf, buf_type);
+}
+
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
 	.setup_async_request = smb2_setup_async_request,
@@ -426,6 +437,7 @@ struct smb_version_operations smb21_operations = {
 	.flush = smb2_flush_file,
 	.async_readv = smb2_async_readv,
 	.async_writev = smb2_async_writev,
+	.sync_read = smb2_sync_read,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c998fbe..15b9b08 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1328,6 +1328,57 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	return rc;
 }
 
+int
+SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
+	  unsigned int *nbytes, char **buf, int *buf_type)
+{
+	int resp_buftype, rc = -EACCES;
+	struct smb2_read_rsp *rsp = NULL;
+	struct kvec iov[1];
+
+	*nbytes = 0;
+	rc = smb2_new_read_req(iov, io_parms, 0, 0);
+	if (rc)
+		return rc;
+
+	rc = SendReceive2(xid, io_parms->tcon->ses, iov, 1,
+			  &resp_buftype, CIFS_LOG_ERROR);
+
+	rsp = (struct smb2_read_rsp *)iov[0].iov_base;
+
+	if (rsp->hdr.Status == STATUS_END_OF_FILE) {
+		free_rsp_buf(resp_buftype, iov[0].iov_base);
+		return 0;
+	}
+
+	if (rc) {
+		cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
+		cERROR(1, "Send error in read = %d", rc);
+	} else {
+		*nbytes = le32_to_cpu(rsp->DataLength);
+		if ((*nbytes > CIFS_MAX_MSGSIZE) ||
+		    (*nbytes > io_parms->length)) {
+			cFYI(1, "bad length %d for count %d", *nbytes,
+				io_parms->length);
+			rc = -EIO;
+			*nbytes = 0;
+		}
+	}
+
+	if (*buf) {
+		memcpy(*buf, (char *)rsp->hdr.ProtocolId + rsp->DataOffset,
+		       *nbytes);
+		free_rsp_buf(resp_buftype, iov[0].iov_base);
+	} else if (resp_buftype != CIFS_NO_BUFFER) {
+		*buf = iov[0].iov_base;
+		if (resp_buftype == CIFS_SMALL_BUFFER)
+			*buf_type = CIFS_SMALL_BUFFER;
+		else if (resp_buftype == CIFS_LARGE_BUFFER)
+			*buf_type = CIFS_LARGE_BUFFER;
+	}
+	return rc;
+}
+
 /*
  * Check the mid_state and signature on received buffer (if any), and queue the
  * workqueue completion task.
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index ec983be..97e62f3 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -98,6 +98,8 @@ extern int SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
 			    u64 persistent_fid, u64 volatile_fid,
 			    __le64 *uniqueid);
 extern int smb2_async_readv(struct cifs_readdata *rdata);
+extern int SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
+		     unsigned int *nbytes, char **buf, int *buf_type);
 extern int smb2_async_writev(struct cifs_writedata *wdata);
 extern int SMB2_echo(struct TCP_Server_Info *server);
 
-- 
1.7.1
