From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/14] cifs: create SMB2_open_init()/SMB2_open_free() helpers.
Date: Tue, 13 Feb 2018 15:42:31 +1100
Message-ID: <20180213044234.18364-12-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c   | 131 +++++++++++++++++++++++++++-------------------------
 fs/cifs/smb2proto.h |   4 ++
 2 files changed, 73 insertions(+), 62 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 511c441c6b4f..f264d7605351 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1701,44 +1701,28 @@ alloc_path_with_tree_prefix(__le16 **out_path, int *out_size, int *out_len,
 }
 
 int
-SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
-	  __u8 *oplock, struct smb2_file_all_info *buf,
-	  struct kvec *err_iov)
+SMB2_open_init(struct cifs_tcon *tcon, struct smb_rqst *rqst, __u8 *oplock,
+	       struct cifs_open_parms *oparms, __le16 *path)
 {
-	struct smb_rqst rqst;
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct smb2_create_req *req;
-	struct smb2_create_rsp *rsp;
-	struct TCP_Server_Info *server;
-	struct cifs_tcon *tcon = oparms->tcon;
-	struct cifs_ses *ses = tcon->ses;
-	struct kvec iov[4];
-	struct kvec rsp_iov = {NULL, 0};
-	int resp_buftype;
-	int uni_path_len;
-	__le16 *copy_path = NULL;
-	int copy_size;
-	int rc = 0;
 	unsigned int n_iov = 2;
 	__u32 file_attributes = 0;
-	char *dhc_buf = NULL, *lc_buf = NULL;
-	int flags = 0;
+	int copy_size;
+	int uni_path_len;
 	unsigned int total_len;
-
-	cifs_dbg(FYI, "create/open\n");
-
-	if (ses && (ses->server))
-		server = ses->server;
-	else
-		return -EIO;
+	struct kvec *iov = rqst->rq_iov;
+	__le16 *copy_path;
+	int rc;
 
 	rc = smb2_plain_req_init(SMB2_CREATE, tcon, (void **) &req, &total_len);
+	iov[0].iov_base = (char *)req;
+	/* -1 since last byte is buf[0] which is sent below (path) */
+	iov[0].iov_len = total_len - 1;
 
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
-		flags |= CIFS_TRANSFORM_REQ;
-
 	if (oparms->create_options & CREATE_OPTION_READONLY)
 		file_attributes |= ATTR_READONLY;
 	if (oparms->create_options & CREATE_OPTION_SPECIAL)
@@ -1751,11 +1735,6 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	req->ShareAccess = FILE_SHARE_ALL_LE;
 	req->CreateDisposition = cpu_to_le32(oparms->disposition);
 	req->CreateOptions = cpu_to_le32(oparms->create_options & CREATE_OPTIONS_MASK);
-
-	iov[0].iov_base = (char *)req;
-	/* -1 since last byte is buf[0] which is sent below (path) */
-	iov[0].iov_len = total_len - 1;
-
 	req->NameOffset = cpu_to_le16(sizeof(struct smb2_create_req));
 
 	/* [MS-SMB2] 2.2.13 NameOffset:
@@ -1773,10 +1752,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
 						 &name_len,
 						 tcon->treeName, path);
-		if (rc) {
-			cifs_small_buf_release(req);
+		if (rc)
 			return rc;
-		}
 		req->NameLength = cpu_to_le16(name_len * 2);
 		uni_path_len = copy_size;
 		path = copy_path;
@@ -1784,18 +1761,17 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		uni_path_len = (2 * UniStrnlen((wchar_t *)path, PATH_MAX)) + 2;
 		/* MUST set path len (NameLength) to 0 opening root of share */
 		req->NameLength = cpu_to_le16(uni_path_len - 2);
-		if (uni_path_len % 8 != 0) {
-			copy_size = roundup(uni_path_len, 8);
-			copy_path = kzalloc(copy_size, GFP_KERNEL);
-			if (!copy_path) {
-				cifs_small_buf_release(req);
-				return -ENOMEM;
-			}
-			memcpy((char *)copy_path, (const char *)path,
-			       uni_path_len);
-			uni_path_len = copy_size;
-			path = copy_path;
+		copy_size = uni_path_len;
+		if (copy_size % 8 != 0) {
+			copy_size = roundup(copy_size, 8);
 		}
+		copy_path = kzalloc(copy_size, GFP_KERNEL);
+		if (!copy_path)
+			return -ENOMEM;
+		memcpy((char *)copy_path, (const char *)path,
+		       uni_path_len);
+		uni_path_len = copy_size;
+		path = copy_path;
 	}
 
 	iov[1].iov_len = uni_path_len;
@@ -1809,12 +1785,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		req->RequestedOplockLevel = *oplock;
 	else {
 		rc = add_lease_context(server, iov, &n_iov, oplock);
-		if (rc) {
-			cifs_small_buf_release(req);
-			kfree(copy_path);
+		if (rc)
 			return rc;
-		}
-		lc_buf = iov[n_iov-1].iov_base;
 	}
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
@@ -1828,22 +1800,59 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 		rc = add_durable_context(iov, &n_iov, oparms,
 					tcon->use_persistent);
-		if (rc) {
-			cifs_small_buf_release(req);
-			kfree(copy_path);
-			kfree(lc_buf);
+		if (rc)
 			return rc;
-		}
-		dhc_buf = iov[n_iov-1].iov_base;
 	}
 
+	rqst->rq_nvec = n_iov;
+	return 0;
+}
+
+void
+SMB2_open_free(struct smb_rqst *rqst) {
+	cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+	kfree(rqst->rq_iov[1].iov_base); /* copy_path */
+	kfree(rqst->rq_iov[2].iov_base); /* lc_buf */
+	kfree(rqst->rq_iov[3].iov_base); /* dhc_buf */
+}
+
+int
+SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
+	  __u8 *oplock, struct smb2_file_all_info *buf,
+	  struct kvec *err_iov)
+{
+	struct smb_rqst rqst;
+	struct smb2_create_rsp *rsp = NULL;
+	struct TCP_Server_Info *server;
+	struct cifs_tcon *tcon = oparms->tcon;
+	struct cifs_ses *ses = tcon->ses;
+	struct kvec iov[4];
+	struct kvec rsp_iov = {NULL, 0};
+	int resp_buftype;
+	int rc = 0;
+	int flags = 0;
+
+	cifs_dbg(FYI, "create/open\n");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	if (encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
 	memset(&rqst, 0, sizeof(struct smb_rqst));
+	memset(&iov, 0, sizeof(iov));
 	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_iov;
+	rqst.rq_nvec = 4;
+
+	rc = SMB2_open_init(tcon, &rqst, oplock, oparms, path);
+	if (rc)
+		goto creat_exit;
 
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
 			    &rsp_iov);
-	cifs_small_buf_release(req);
 	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
 
 	if (rc != 0) {
@@ -1872,9 +1881,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	else
 		*oplock = rsp->OplockLevel;
 creat_exit:
-	kfree(copy_path);
-	kfree(lc_buf);
-	kfree(dhc_buf);
+	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index d35e6bfa079d..06151df3c316 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -124,6 +124,10 @@ extern int SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms,
 		     __le16 *path, __u8 *oplock,
 		     struct smb2_file_all_info *buf,
 		     struct kvec *err_iov);
+extern int SMB2_open_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
+			  __u8 *oplock, struct cifs_open_parms *oparms,
+			  __le16 *path);
+extern void SMB2_open_free(struct smb_rqst *rqst);
 extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, u32 opcode,
 		     bool is_fsctl, bool use_ipc,
-- 
2.13.3
