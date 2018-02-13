From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/14] cifs: update smb2_queryfs() to use compounding
Date: Tue, 13 Feb 2018 15:42:34 +1100
Message-ID: <20180213044234.18364-15-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Change smb2_queryfs() to use a Create/QueryInfo/Close compound request.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   1 -
 fs/cifs/smb2ops.c   | 119 ++++++++++++++++++++++++++++++++++++++++++----------
 fs/cifs/smb2pdu.c   |  70 +++++++++++++++----------------
 fs/cifs/smb2pdu.h   |   1 +
 fs/cifs/smb2proto.h |   5 +++
 fs/cifs/transport.c |   2 +-
 6 files changed, 140 insertions(+), 58 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a5ffcaf4b144..956558eb6a6b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -450,7 +450,6 @@ struct smb_version_operations {
 	enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
 			    enum securityEnum);
 	int (*next_header)(char *);
-	void (*set_next_header)(char *, int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 80462bb3fd03..663ede43dfdf 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1281,15 +1281,64 @@ smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 				 CIFS_CACHE_READ(cinode) ? 1 : 0);
 }
 
+static void
+smb2_set_related(struct smb_rqst *rqst)
+{
+	struct smb2_sync_hdr *shdr;
+
+	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
+	shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
+}
+
+static void
+smb2_set_next_command(struct smb_rqst *rqst)
+{
+	struct smb2_sync_hdr *shdr;
+	unsigned long len = smb2_rqst_len(rqst);
+	static char padding[7] = {0, 0, 0, 0, 0, 0, 0};
+
+	/* SMB headers in a compound are 8 byte aligned. */
+	if (len & 7) {
+		rqst->rq_iov[rqst->rq_nvec].iov_base = padding;
+		rqst->rq_iov[rqst->rq_nvec].iov_len = 8 - (len & 7);
+		rqst->rq_nvec++;
+		len = smb2_rqst_len(rqst);
+	}
+
+	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
+	shdr->NextCommand = cpu_to_le32(len);
+}
+
 static int
 smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	     struct kstatfs *buf)
 {
-	int rc;
+	struct smb2_query_info_rsp *rsp;
+	struct smb2_fs_full_size_info *info = NULL;
+	struct smb_rqst rqst[3];
+	int resp_buftype[3];
+	struct kvec rsp_iov[3];
+	struct kvec open_iov[5]; /* 4 + potential padding. */
+	struct kvec qi_iov[1];
+	struct kvec close_iov[1];
+	struct cifs_ses *ses = tcon->ses;
 	__le16 srch_path = 0; /* Null - open root of share */
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
+	int flags = 0;
+	int rc;
+
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
+	memset(rqst, 0, sizeof(rqst));
+	memset(resp_buftype, 0, sizeof(resp_buftype));
+	memset(rsp_iov, 0, sizeof(rsp_iov));
+
+	memset(&open_iov, 0, sizeof(open_iov));
+	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_nvec = 4;
 
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
@@ -1298,13 +1347,56 @@ smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL);
+	rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, &srch_path);
 	if (rc)
-		return rc;
+		goto qfs_exit;
+	smb2_set_next_command(&rqst[0]);
+
+	memset(&qi_iov, 0, sizeof(qi_iov));
+	rqst[1].rq_iov = qi_iov;
+	rqst[1].rq_nvec = 1;
+
+	rc = SMB2_query_info_init(tcon, &rqst[1], COMPOUND_FID, COMPOUND_FID,
+				  FS_FULL_SIZE_INFORMATION,
+				  SMB2_O_INFO_FILESYSTEM, 0,
+				  sizeof(struct smb2_fs_full_size_info));
+	if (rc)
+		goto qfs_exit;
+	smb2_set_next_command(&rqst[1]);
+	smb2_set_related(&rqst[1]);
+
+	memset(&close_iov, 0, sizeof(close_iov));
+	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_nvec = 1;
+
+	rc = SMB2_close_init(tcon, &rqst[2], COMPOUND_FID, COMPOUND_FID);
+	if (rc)
+		goto qfs_exit;
+	smb2_set_related(&rqst[2]);
+
+	rc = compound_send_recv(xid, ses, flags, 3, rqst,
+				resp_buftype, rsp_iov);
+	if (rc)
+		goto qfs_exit;
+
+	rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	buf->f_type = SMB2_MAGIC_NUMBER;
-	rc = SMB2_QFS_info(xid, tcon, fid.persistent_fid, fid.volatile_fid,
-			   buf);
-	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+	info = (struct smb2_fs_full_size_info *)(
+		le16_to_cpu(rsp->OutputBufferOffset) + (char *)rsp);
+	rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
+			       le32_to_cpu(rsp->OutputBufferLength),
+			       &rsp_iov[1],
+			       sizeof(struct smb2_fs_full_size_info));
+	if (!rc)
+		smb2_copy_fs_info_to_kstatfs(info, buf);
+
+qfs_exit:
+	SMB2_open_free(&rqst[0]);
+	SMB2_query_info_free(&rqst[1]);
+	SMB2_close_free(&rqst[2]);
+	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
+	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
+	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
 	return rc;
 }
 
@@ -2751,17 +2843,6 @@ smb2_next_header(char *buf)
 	return le32_to_cpu(hdr->NextCommand);
 }
 
-static void
-smb2_set_next_header(char *buf, int offset)
-{
-	struct smb2_sync_hdr *hdr = (struct smb2_sync_hdr *)buf;
-
-	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM)
-		return;
-
-	hdr->NextCommand = cpu_to_le32(offset);
-}
-
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -2854,7 +2935,6 @@ struct smb_version_operations smb20_operations = {
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
 	.next_header = smb2_next_header,
-	.set_next_header = smb2_set_next_header,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -2950,7 +3030,6 @@ struct smb_version_operations smb21_operations = {
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
 	.next_header = smb2_next_header,
-	.set_next_header = smb2_set_next_header,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -3056,7 +3135,6 @@ struct smb_version_operations smb30_operations = {
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
 	.next_header = smb2_next_header,
-	.set_next_header = smb2_set_next_header,
 };
 
 #ifdef CONFIG_CIFS_SMB311
@@ -3158,7 +3236,6 @@ struct smb_version_operations smb311_operations = {
 	.set_EA = smb2_set_ea,
 #endif /* CIFS_XATTR */
 	.next_header = smb2_next_header,
-	.set_next_header = smb2_set_next_header,
 };
 #endif /* CIFS_SMB311 */
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2fa1b55fe6fa..1938294bf056 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -78,7 +78,7 @@ static const int smb2_req_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 	/* SMB2_OPLOCK_BREAK */ 24 /* BB this is 36 for LEASE_BREAK variant */
 };
 
-static int encryption_required(const struct cifs_tcon *tcon)
+int smb3_encryption_required(const struct cifs_tcon *tcon)
 {
 	if (!tcon)
 		return 0;
@@ -144,7 +144,7 @@ smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
 		shdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
 
 	if (tcon->ses && tcon->ses->server && tcon->ses->server->sign &&
-	    !encryption_required(tcon))
+	    !smb3_encryption_required(tcon))
 		shdr->Flags |= SMB2_FLAGS_SIGNED;
 out:
 	return;
@@ -1286,7 +1286,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 		req->sync_hdr.SessionId = ses->Suid;
 		if (ses->server->sign)
 			req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
-	} else if (encryption_required(tcon))
+	} else if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	iov[0].iov_base = (char *)req;
@@ -1396,7 +1396,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	flags |= CIFS_NO_RESP;
@@ -1839,7 +1839,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	else
 		return -EIO;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
@@ -1938,7 +1938,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 			 req->sync_hdr.TreeId, ses->ipc_tid);
 		req->sync_hdr.TreeId = ses->ipc_tid;
 	}
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	req->CtlCode = cpu_to_le32(opcode);
@@ -2123,7 +2123,7 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
@@ -2151,9 +2151,9 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-static int
-validate_iov(unsigned int offset, unsigned int buffer_length,
-	     struct kvec *iov, unsigned int min_buf_size)
+int
+smb2_validate_iov(unsigned int offset, unsigned int buffer_length,
+		  struct kvec *iov, unsigned int min_buf_size)
 {
 	unsigned int smb_len = iov->iov_len;
 	char *end_of_smb = smb_len + (char *)iov->iov_base;
@@ -2197,7 +2197,7 @@ validate_and_copy_iov(unsigned int offset, unsigned int buffer_length,
 	if (!data)
 		return -EINVAL;
 
-	rc = validate_iov(offset, buffer_length, iov, minbufsize);
+	rc = smb2_validate_iov(offset, buffer_length, iov, minbufsize);
 	if (rc)
 		return rc;
 
@@ -2267,7 +2267,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
@@ -2497,7 +2497,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	req->PersistentFileId = persistent_fid;
@@ -2681,7 +2681,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 		return rc;
 	}
 
-	if (encryption_required(io_parms.tcon))
+	if (smb3_encryption_required(io_parms.tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	rdata->iov[0].iov_base = buf;
@@ -2733,7 +2733,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (rc)
 		return rc;
 
-	if (encryption_required(io_parms->tcon))
+	if (smb3_encryption_required(io_parms->tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	iov[0].iov_base = (char *)req;
@@ -2858,7 +2858,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 		goto async_writev_out;
 	}
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	shdr = (struct smb2_sync_hdr *)req;
@@ -2947,7 +2947,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (io_parms->tcon->ses->server == NULL)
 		return -ECONNABORTED;
 
-	if (encryption_required(io_parms->tcon))
+	if (smb3_encryption_required(io_parms->tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	req->sync_hdr.ProcessId = cpu_to_le32(io_parms->pid);
@@ -3062,7 +3062,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	switch (srch_inf->info_level) {
@@ -3125,9 +3125,9 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qdir_exit;
 	}
 
-	rc = validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
-			  le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
-			  info_buf_size);
+	rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
+			       le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
+			       info_buf_size);
 	if (rc)
 		goto qdir_exit;
 
@@ -3198,7 +3198,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	req->sync_hdr.ProcessId = cpu_to_le32(pid);
@@ -3398,7 +3398,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	req->VolatileFid = volatile_fid;
@@ -3426,9 +3426,9 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-static void
-copy_fs_info_to_kstatfs(struct smb2_fs_full_size_info *pfs_inf,
-			struct kstatfs *kst)
+void
+smb2_copy_fs_info_to_kstatfs(struct smb2_fs_full_size_info *pfs_inf,
+			     struct kstatfs *kst)
 {
 	kst->f_bsize = le32_to_cpu(pfs_inf->BytesPerSector) *
 			  le32_to_cpu(pfs_inf->SectorsPerAllocationUnit);
@@ -3491,7 +3491,7 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
@@ -3508,11 +3508,11 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	info = (struct smb2_fs_full_size_info *)(
 		le16_to_cpu(rsp->OutputBufferOffset) + (char *)rsp);
-	rc = validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
-			  le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
-			  sizeof(struct smb2_fs_full_size_info));
+	rc = smb2_validate_iov(le16_to_cpu(rsp->OutputBufferOffset),
+			       le32_to_cpu(rsp->OutputBufferLength), &rsp_iov,
+			       sizeof(struct smb2_fs_full_size_info));
 	if (!rc)
-		copy_fs_info_to_kstatfs(info, fsdata);
+		smb2_copy_fs_info_to_kstatfs(info, fsdata);
 
 qfsinf_exit:
 	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
@@ -3552,7 +3552,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
@@ -3569,7 +3569,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rsp_len = le32_to_cpu(rsp->OutputBufferLength);
 	offset = le16_to_cpu(rsp->OutputBufferOffset);
-	rc = validate_iov(offset, rsp_len, &rsp_iov, min_len);
+	rc = smb2_validate_iov(offset, rsp_len, &rsp_iov, min_len);
 	if (rc)
 		goto qfsattr_exit;
 
@@ -3614,7 +3614,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	req->sync_hdr.ProcessId = cpu_to_le32(pid);
@@ -3684,7 +3684,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	if (rc)
 		return rc;
 
-	if (encryption_required(tcon))
+	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	req->sync_hdr.CreditRequest = cpu_to_le16(1);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 91fd17f5c2eb..2ab187202e71 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -152,6 +152,7 @@ struct smb2_transform_hdr {
  *  command code name for the struct. Note that structures must be packed.
  *
  */
+#define COMPOUND_FID 0xffffffffffffffff
 
 #define SMB2_ERROR_STRUCTURE_SIZE2 cpu_to_le16(9)
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 5e6d46548bec..d59c628a232a 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -217,4 +217,9 @@ extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
 extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
 extern int smb3_encryption_required(const struct cifs_tcon *tcon);
+extern int smb2_validate_iov(unsigned int offset, unsigned int buffer_length,
+			     struct kvec *iov, unsigned int min_buf_size);
+extern void smb2_copy_fs_info_to_kstatfs(struct smb2_fs_full_size_info *pfs_inf,
+					 struct kstatfs *kst);
+extern unsigned long smb2_rqst_len(struct smb_rqst *rqst);
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index d810d4af33ad..676fc5261fbf 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -199,7 +199,7 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 	return 0;
 }
 
-static unsigned long
+unsigned long
 smb2_rqst_len(struct smb_rqst *rqst)
 {
 	unsigned int i;
-- 
2.13.3
