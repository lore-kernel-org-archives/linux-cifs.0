From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 46/50] CIFS: Add statfs support for SMB2
Date: Fri, 20 Jan 2012 12:35:07 +0400
Message-ID: <1327048511-2342-46-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   52 ++++++++++++++++----------
 fs/cifs/smb2glob.h  |    2 +
 fs/cifs/smb2pdu.c   |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   19 ++++++++++
 fs/cifs/smb2proto.h |    5 +++
 5 files changed, 158 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c59a5b2..40b64da 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -164,31 +164,14 @@ static void cifs_kill_sb(struct super_block *sb)
 	cifs_umount(cifs_sb);
 }
 
-static int
-cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
+static void
+cifs_queryfs(int xid, struct cifs_tcon *tcon, struct kstatfs *buf)
 {
-	struct super_block *sb = dentry->d_sb;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	int rc = -EOPNOTSUPP;
-	int xid;
-
-	xid = GetXid();
 
 	buf->f_type = CIFS_MAGIC_NUMBER;
 
 	/*
-	 * PATH_MAX may be too long - it would presumably be total path,
-	 * but note that some servers (includinng Samba 3) have a shorter
-	 * maximum path.
-	 *
-	 * Instead could get the real value via SMB_QUERY_FS_ATTRIBUTE_INFO.
-	 */
-	buf->f_namelen = PATH_MAX;
-	buf->f_files = 0;	/* undefined */
-	buf->f_ffree = 0;	/* unlimited */
-
-	/*
 	 * We could add a second check for a QFS Unix capability bit
 	 */
 	if ((tcon->ses->capabilities & CAP_UNIX) &&
@@ -209,8 +192,37 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 */
 	if (rc)
 		rc = SMBOldQFSInfo(xid, tcon, buf);
+}
+
+static int
+cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	int xid;
+
+	xid = GetXid();
+
+	/*
+	 * PATH_MAX may be too long - it would presumably be total path,
+	 * but note that some servers (includinng Samba 3) have a shorter
+	 * maximum path.
+	 *
+	 * Instead could get the real value via SMB_QUERY_FS_ATTRIBUTE_INFO.
+	 */
+	buf->f_namelen = PATH_MAX;
+	buf->f_files = 0;	/* undefined */
+	buf->f_ffree = 0;	/* unlimited */
+
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->ses->server->is_smb2)
+		smb2_open_queryfs_close(xid, tcon, buf);
+	else
+#endif
+		cifs_queryfs(xid, tcon, buf);
 
-	FreeXid(xid);
+	_FreeXid(xid);
 	return 0;
 }
 
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index a6b8826..16ed042 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -22,6 +22,8 @@
 #ifndef _SMB2_GLOB_H
 #define _SMB2_GLOB_H
 
+#define SMB2_MAGIC_NUMBER 0xFE534D42
+
 /*
  *****************************************************************
  * Constants go here
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 30aba71..91e0bb1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2101,3 +2101,103 @@ SMB2_lease_break(const int xid, struct cifs_tcon *tcon, __u8 *lease_key,
 
 	return rc;
 }
+
+static void
+copy_fs_info_to_kstatfs(struct smb2_fs_full_size_info *pfs_inf,
+			struct kstatfs *kst)
+{
+	kst->f_bsize = le32_to_cpu(pfs_inf->BytesPerSector) *
+			  le32_to_cpu(pfs_inf->SectorsPerAllocationUnit);
+	kst->f_blocks = le64_to_cpu(pfs_inf->TotalAllocationUnits);
+	kst->f_bfree  = le64_to_cpu(pfs_inf->ActualAvailableAllocationUnits);
+	kst->f_bavail = le64_to_cpu(pfs_inf->CallerAvailableAllocationUnits);
+	return;
+}
+
+static int build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon,
+			      int level, int outbuf_len,
+			      u64 persistent_fid, u64 volatile_fid)
+{
+	int rc;
+	struct smb2_query_info_req *pSMB2;
+
+	cFYI(1, "Query FSInfo level %d", level);
+
+	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	pSMB2->InfoType = SMB2_O_INFO_FILESYSTEM;
+	pSMB2->FileInfoClass = level;
+	pSMB2->PersistentFileId = persistent_fid;
+	pSMB2->VolatileFileId = volatile_fid;
+	pSMB2->InputBufferOffset = cpu_to_le16(
+		sizeof(struct smb2_query_info_req) - 1 /* pad */
+		- 4 /* RFC1001 len */);
+	pSMB2->OutputBufferLength = cpu_to_le32(
+		outbuf_len + sizeof(struct smb2_query_info_rsp) - 1 - 4);
+
+	iov->iov_base = (char *)pSMB2;
+	iov->iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4;
+	return 0;
+}
+
+int SMB2_QFS_info(const int xid, struct cifs_tcon *tcon,
+		  u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdat)
+{
+	struct smb2_query_info_rsp *pSMB2r = NULL;
+	struct kvec iov;
+	int rc = 0;
+	int resp_buftype;
+	int status;
+	struct cifs_ses *ses = tcon->ses;
+	struct smb2_fs_full_size_info *psize_inf = NULL;
+
+	rc = build_qfs_info_req(&iov, tcon, FS_FULL_SIZE_INFORMATION,
+				sizeof(struct smb2_fs_full_size_info),
+				persistent_fid, volatile_fid);
+	if (rc)
+		return rc;
+
+	rc = smb2_sendrcv2(xid, ses, &iov, 1, &resp_buftype /* ret */, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	cFYI(1, "qfsinfo buftype %d rc %d status %d", resp_buftype, rc, status);
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2QUERY_INFO);
+		goto qinf_exit;
+	}
+	pSMB2r = (struct smb2_query_info_rsp *)iov.iov_base;
+
+	psize_inf = (struct smb2_fs_full_size_info *)(4 /* RFC1001 len */ +
+		le16_to_cpu(pSMB2r->OutputBufferOffset) + (char *)&pSMB2r->hdr);
+	rc = validate_buf(le16_to_cpu(pSMB2r->OutputBufferOffset),
+			  le32_to_cpu(pSMB2r->OutputBufferLength),
+			  &pSMB2r->hdr, sizeof(struct smb2_fs_full_size_info));
+	if (!rc)
+		copy_fs_info_to_kstatfs(psize_inf, fsdat);
+
+qinf_exit:
+	free_rsp_buf(resp_buftype, iov.iov_base);
+	return rc;
+}
+
+void
+smb2_open_queryfs_close(int xid, struct cifs_tcon *tcon, struct kstatfs *buf)
+{
+	int rc;
+	u64 persist_fid, volatile_fid;
+	__le16 srch_path = 0; /* Null - open root of share */
+	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+
+	rc = SMB2_open(xid, tcon, &srch_path, &persist_fid, &volatile_fid,
+			FILE_READ_ATTRIBUTES, FILE_OPEN, 0, 0, &oplock);
+	if (!rc) {
+		buf->f_type = SMB2_MAGIC_NUMBER;
+		SMB2_QFS_info(xid, tcon, persist_fid, volatile_fid,
+					  buf);
+		SMB2_close(xid, tcon, persist_fid, volatile_fid);
+	}
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 9ec9a29..20aba30 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -672,6 +672,25 @@ struct smb2_lease_ack {
  *	BB consider moving to a different header
  */
 
+/* File System Information Classes */
+#define FS_VOLUME_INFORMATION		1 /* Query */
+#define FS_LABEL_INFORMATION		2 /* Set */
+#define FS_SIZE_INFORMATION		3 /* Query */
+#define FS_DEVICE_INFORMATION		4 /* Query */
+#define FS_ATTRIBUTE_INFORMATION	5 /* Query */
+#define FS_CONTROL_INFORMATION		6 /* Query, Set */
+#define FS_FULL_SIZE_INFORMATION	7 /* Query */
+#define FS_OBJECT_ID_INFORMATION	8 /* Query, Set */
+#define FS_DRIVER_PATH_INFORMATION	9 /* Query */
+
+struct smb2_fs_full_size_info {
+	__le64 TotalAllocationUnits;
+	__le64 CallerAvailableAllocationUnits;
+	__le64 ActualAvailableAllocationUnits;
+	__le32 SectorsPerAllocationUnit;
+	__le32 BytesPerSector;
+} __packed;
+
 /* partial list of QUERY INFO levels */
 #define FILE_DIRECTORY_INFORMATION	1
 #define FILE_FULL_DIRECTORY_INFORMATION 2
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index b3af93c..bbdc47e 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -91,6 +91,8 @@ extern int smb2_open_op_close(int xid, struct cifs_tcon *tcon, __le16 *path,
 			      __u32 desired_access, __u32 create_disposition,
 			      __u32 file_attributes, __u32 create_options,
 			      void *data, int command);
+extern void smb2_open_queryfs_close(int xid, struct cifs_tcon *tcon,
+				    struct kstatfs *buf);
 extern void smb2_set_ops(struct inode *inode);
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
@@ -186,5 +188,8 @@ extern int SMB2_oplock_break(const int xid, struct cifs_tcon *tcon,
 			     const __u8 oplock_level);
 extern int SMB2_lease_break(const int xid, struct cifs_tcon *tcon,
 			    __u8 *lease_key, const __le32 lease_state);
+extern int SMB2_QFS_info(const int xid, struct cifs_tcon *tcon,
+			 u64 persistent_file_id, u64 volatile_file_id,
+			 struct kstatfs *FSData);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
