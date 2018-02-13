From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/14] cifs: add SMB2_query_info_[init|free]()
Date: Tue, 13 Feb 2018 15:42:33 +1100
Message-ID: <20180213044234.18364-14-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c   | 70 +++++++++++++++++++++++++++++++++++------------------
 fs/cifs/smb2proto.h |  5 ++++
 2 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bd1ccfb10ec6..2fa1b55fe6fa 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2206,36 +2206,23 @@ validate_and_copy_iov(unsigned int offset, unsigned int buffer_length,
 	return 0;
 }
 
-static int
-query_info(const unsigned int xid, struct cifs_tcon *tcon,
-	   u64 persistent_fid, u64 volatile_fid, u8 info_class, u8 info_type,
-	   u32 additional_info, size_t output_len, size_t min_len, void **data,
-		u32 *dlen)
+
+int
+SMB2_query_info_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
+		     u64 persistent_fid, u64 volatile_fid,
+		     u8 info_class, u8 info_type, u32 additional_info,
+		     size_t output_len)
 {
-	struct smb_rqst rqst;
 	struct smb2_query_info_req *req;
-	struct smb2_query_info_rsp *rsp = NULL;
-	struct kvec iov[2];
-	struct kvec rsp_iov;
-	int rc = 0;
-	int resp_buftype;
-	struct cifs_ses *ses = tcon->ses;
-	int flags = 0;
+	struct kvec *iov = rqst->rq_iov;
 	unsigned int total_len;
-
-	cifs_dbg(FYI, "Query Info\n");
-
-	if (!ses || !(ses->server))
-		return -EIO;
+	int rc;
 
 	rc = smb2_plain_req_init(SMB2_QUERY_INFO, tcon, (void **) &req,
 			     &total_len);
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
 	req->InfoType = info_type;
 	req->FileInfoClass = info_class;
 	req->PersistentFileId = persistent_fid;
@@ -2246,19 +2233,55 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	 * We do not use the input buffer (do not send extra byte)
 	 */
 	req->InputBufferOffset = 0;
-
 	req->OutputBufferLength = cpu_to_le32(output_len);
 
 	iov[0].iov_base = (char *)req;
 	/* 1 for Buffer */
 	iov[0].iov_len = total_len - 1;
 
+	return 0;
+}
+
+void
+SMB2_query_info_free(struct smb_rqst *rqst) {
+	cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+}
+
+static int
+query_info(const unsigned int xid, struct cifs_tcon *tcon,
+	   u64 persistent_fid, u64 volatile_fid, u8 info_class, u8 info_type,
+	   u32 additional_info, size_t output_len, size_t min_len, void **data,
+		u32 *dlen)
+{
+	struct smb_rqst rqst;
+	struct smb2_query_info_rsp *rsp = NULL;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int rc = 0;
+	int resp_buftype;
+	struct cifs_ses *ses = tcon->ses;
+	int flags = 0;
+
+	cifs_dbg(FYI, "Query Info\n");
+
+	if (!ses || !(ses->server))
+		return -EIO;
+
+	if (encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
 	memset(&rqst, 0, sizeof(struct smb_rqst));
+	memset(&iov, 0, sizeof(iov));
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 1;
 
+	rc = SMB2_query_info_init(tcon, &rqst, persistent_fid, volatile_fid,
+				  info_class, info_type, additional_info,
+				  output_len);
+	if (rc)
+		goto qinf_exit;
+
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(req);
 	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
 
 	if (rc) {
@@ -2285,6 +2308,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 				   &rsp_iov, min_len, *data);
 
 qinf_exit:
+	SMB2_query_info_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index f31b9f3d060a..5e6d46548bec 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -147,6 +147,11 @@ extern int SMB2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   struct smb2_file_all_info *data);
+extern int SMB2_query_info_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
+				u64 persistent_fid, u64 volatile_fid,
+				u8 info_class, u8 info_type,
+				u32 additional_info, size_t output_len);
+extern void SMB2_query_info_free(struct smb_rqst *rqst);
 extern int SMB2_query_acl(const unsigned int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   void **data, unsigned int *plen);
-- 
2.13.3
