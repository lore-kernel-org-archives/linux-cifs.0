From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/14] cifs: add SMB2_close_init()/SMB2_close_free()
Date: Tue, 13 Feb 2018 15:42:32 +1100
Message-ID: <20180213044234.18364-13-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c   | 48 ++++++++++++++++++++++++++++++++++--------------
 fs/cifs/smb2proto.h |  3 +++
 2 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f264d7605351..bd1ccfb10ec6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2079,44 +2079,63 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
+SMB2_close_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
+		u64 persistent_fid, u64 volatile_fid)
+{
+	struct smb2_close_req *req;
+	struct kvec *iov = rqst->rq_iov;
+	unsigned int total_len;
+	int rc;
+
+	rc = smb2_plain_req_init(SMB2_CLOSE, tcon, (void **) &req, &total_len);
+	if (rc)
+		return rc;
+
+	req->PersistentFileId = persistent_fid;
+	req->VolatileFileId = volatile_fid;
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
+
+	return 0;
+}
+
+void
+SMB2_close_free(struct smb_rqst *rqst) {
+	cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+}
+
+int
 SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	   u64 persistent_fid, u64 volatile_fid)
 {
 	struct smb_rqst rqst;
-	struct smb2_close_req *req;
-	struct smb2_close_rsp *rsp;
+	struct smb2_close_rsp *rsp = NULL;
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
 	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
-	unsigned int total_len;
 
 	cifs_dbg(FYI, "Close\n");
 
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = smb2_plain_req_init(SMB2_CLOSE, tcon, (void **) &req, &total_len);
-	if (rc)
-		return rc;
-
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->PersistentFileId = persistent_fid;
-	req->VolatileFileId = volatile_fid;
-
-	iov[0].iov_base = (char *)req;
-	iov[0].iov_len = total_len;
-
 	memset(&rqst, 0, sizeof(struct smb_rqst));
+	memset(&iov, 0, sizeof(iov));
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 1;
 
+	rc = SMB2_close_init(tcon, &rqst, persistent_fid, volatile_fid);
+	if (rc)
+		goto close_exit;
+
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(req);
 	rsp = (struct smb2_close_rsp *)rsp_iov.iov_base;
 
 	if (rc != 0) {
@@ -2127,6 +2146,7 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	/* BB FIXME - decode close response, update inode for caching */
 
 close_exit:
+	SMB2_close_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 06151df3c316..f31b9f3d060a 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -135,6 +135,9 @@ extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
 		     char **out_data, u32 *plen /* returned data len */);
 extern int SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
+extern int SMB2_close_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
+		      u64 persistent_file_id, u64 volatile_file_id);
+extern void SMB2_close_free(struct smb_rqst *rqst);
 extern int SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon,
 		      u64 persistent_file_id, u64 volatile_file_id);
 extern int SMB2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
-- 
2.13.3
