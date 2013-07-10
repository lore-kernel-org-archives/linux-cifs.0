From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 6/8] CIFS: Introduce cifs_open_parms struct
Date: Wed, 10 Jul 2013 13:59:58 +0400
Message-ID: <1373450401-4135-7-git-send-email-pshilovsky@samba.org>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and pass it to the open() call.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   16 +++++++++++++---
 fs/cifs/dir.c       |   13 ++++++++++---
 fs/cifs/file.c      |   26 ++++++++++++++++++++------
 fs/cifs/smb1ops.c   |   29 ++++++++++++++++-------------
 fs/cifs/smb2file.c  |   22 +++++++++++-----------
 fs/cifs/smb2proto.h |    8 +++-----
 6 files changed, 73 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 913e3df..107e657 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -192,6 +192,7 @@ struct cifs_writedata;
 struct cifs_io_parms;
 struct cifs_search_info;
 struct cifsInodeInfo;
+struct cifs_open_parms;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -305,9 +306,8 @@ struct smb_version_operations {
 			       const char *, const char *,
 			       struct cifs_sb_info *);
 	/* open a file for non-posix mounts */
-	int (*open)(const unsigned int, struct cifs_tcon *, const char *, int,
-		    int, int, struct cifs_fid *, __u32 *, FILE_ALL_INFO *,
-		    struct cifs_sb_info *);
+	int (*open)(const unsigned int, struct cifs_open_parms *,
+		    __u32 *, FILE_ALL_INFO *);
 	/* set fid protocol-specific info */
 	void (*set_fid)(struct cifsFileInfo *, struct cifs_fid *, __u32);
 	/* close a file */
@@ -907,6 +907,16 @@ struct cifs_search_info {
 	bool smallBuf:1; /* so we know which buf_release function to call */
 };
 
+struct cifs_open_parms {
+	struct cifs_tcon *tcon;
+	struct cifs_sb_info *cifs_sb;
+	int disposition;
+	int desired_access;
+	int create_options;
+	const char *path;
+	struct cifs_fid *fid;
+};
+
 struct cifs_fid {
 	__u16 netfid;
 #ifdef CONFIG_CIFS_SMB2
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 5699b50..66435c9 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -204,6 +204,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	struct inode *newinode = NULL;
 	int disposition;
 	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_open_parms oparms;
 
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
@@ -319,9 +320,15 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
-	rc = server->ops->open(xid, tcon, full_path, disposition,
-			       desired_access, create_options, fid, oplock,
-			       buf, cifs_sb);
+	oparms.tcon = tcon;
+	oparms.cifs_sb = cifs_sb;
+	oparms.desired_access = desired_access;
+	oparms.create_options = create_options;
+	oparms.disposition = disposition;
+	oparms.path = full_path;
+	oparms.fid = fid;
+
+	rc = server->ops->open(xid, &oparms, oplock, buf);
 	if (rc) {
 		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
 		goto out;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 48b29d2..12a9754 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -183,6 +183,7 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	int create_options = CREATE_NOT_DIR;
 	FILE_ALL_INFO *buf;
 	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_open_parms oparms;
 
 	if (!server->ops->open)
 		return -ENOSYS;
@@ -224,9 +225,15 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
-	rc = server->ops->open(xid, tcon, full_path, disposition,
-			       desired_access, create_options, fid, oplock, buf,
-			       cifs_sb);
+	oparms.tcon = tcon;
+	oparms.cifs_sb = cifs_sb;
+	oparms.desired_access = desired_access;
+	oparms.create_options = create_options;
+	oparms.disposition = disposition;
+	oparms.path = full_path;
+	oparms.fid = fid;
+
+	rc = server->ops->open(xid, &oparms, oplock, buf);
 
 	if (rc)
 		goto out;
@@ -588,6 +595,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	int disposition = FILE_OPEN;
 	int create_options = CREATE_NOT_DIR;
 	struct cifs_fid fid;
+	struct cifs_open_parms oparms;
 
 	xid = get_xid();
 	mutex_lock(&cfile->fh_mutex);
@@ -656,6 +664,14 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &fid);
 
+	oparms.tcon = tcon;
+	oparms.cifs_sb = cifs_sb;
+	oparms.desired_access = desired_access;
+	oparms.create_options = create_options;
+	oparms.disposition = disposition;
+	oparms.path = full_path;
+	oparms.fid = &fid;
+
 	/*
 	 * Can not refresh inode by passing in file_info buf to be returned by
 	 * CIFSSMBOpen and then calling get_inode_info with returned buf since
@@ -663,9 +679,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	 * version of file size can be stale. If we knew for sure that inode was
 	 * not dirty locally we could do this.
 	 */
-	rc = server->ops->open(xid, tcon, full_path, disposition,
-			       desired_access, create_options, &fid, &oplock,
-			       NULL, cifs_sb);
+	rc = server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc) {
 		mutex_unlock(&cfile->fh_mutex);
 		cifs_dbg(FYI, "cifs_reopen returned 0x%x\n", rc);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index e813f04..6457690 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -674,20 +674,23 @@ cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
 }
 
 static int
-cifs_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
-	       int disposition, int desired_access, int create_options,
-	       struct cifs_fid *fid, __u32 *oplock, FILE_ALL_INFO *buf,
-	       struct cifs_sb_info *cifs_sb)
-{
-	if (!(tcon->ses->capabilities & CAP_NT_SMBS))
-		return SMBLegacyOpen(xid, tcon, path, disposition,
-				     desired_access, create_options,
-				     &fid->netfid, oplock, buf,
-				     cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
+cifs_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
+	       __u32 *oplock, FILE_ALL_INFO *buf)
+{
+	if (!(oparms->tcon->ses->capabilities & CAP_NT_SMBS))
+		return SMBLegacyOpen(xid, oparms->tcon, oparms->path,
+				     oparms->disposition,
+				     oparms->desired_access,
+				     oparms->create_options,
+				     &oparms->fid->netfid, oplock, buf,
+				     oparms->cifs_sb->local_nls,
+				     oparms->cifs_sb->mnt_cifs_flags
 						& CIFS_MOUNT_MAP_SPECIAL_CHR);
-	return CIFSSMBOpen(xid, tcon, path, disposition, desired_access,
-			   create_options, &fid->netfid, oplock, buf,
-			   cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+	return CIFSSMBOpen(xid, oparms->tcon, oparms->path,
+			   oparms->disposition, oparms->desired_access,
+			   oparms->create_options, &oparms->fid->netfid, oplock,
+			   buf, oparms->cifs_sb->local_nls,
+			   oparms->cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 }
 
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 150a9b1..5bab192 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -57,17 +57,16 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 }
 
 int
-smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
-	       int disposition, int desired_access, int create_options,
-	       struct cifs_fid *fid, __u32 *oplock, FILE_ALL_INFO *buf,
-	       struct cifs_sb_info *cifs_sb)
+smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
+	       __u32 *oplock, FILE_ALL_INFO *buf)
 {
 	int rc;
 	__le16 *smb2_path;
 	struct smb2_file_all_info *smb2_data = NULL;
 	__u8 smb2_oplock[17];
+	struct cifs_fid *fid = oparms->fid;
 
-	smb2_path = cifs_convert_path_to_utf16(path, cifs_sb);
+	smb2_path = cifs_convert_path_to_utf16(oparms->path, oparms->cifs_sb);
 	if (smb2_path == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -80,21 +79,22 @@ smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 		goto out;
 	}
 
-	desired_access |= FILE_READ_ATTRIBUTES;
+	oparms->desired_access |= FILE_READ_ATTRIBUTES;
 	*smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
-	if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
+	if (oparms->tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
 		memcpy(smb2_oplock + 1, fid->lease_key, SMB2_LEASE_KEY_SIZE);
 
-	rc = SMB2_open(xid, tcon, smb2_path, &fid->persistent_fid,
-		       &fid->volatile_fid, desired_access, disposition,
-		       create_options, smb2_oplock, smb2_data);
+	rc = SMB2_open(xid, oparms->tcon, smb2_path, &fid->persistent_fid,
+		       &fid->volatile_fid, oparms->desired_access,
+		       oparms->disposition, oparms->create_options, smb2_oplock,
+		       smb2_data);
 	if (rc)
 		goto out;
 
 	if (buf) {
 		/* open response does not have IndexNumber field - get it */
-		rc = SMB2_get_srv_num(xid, tcon, fid->persistent_fid,
+		rc = SMB2_get_srv_num(xid, oparms->tcon, fid->persistent_fid,
 				      fid->volatile_fid,
 				      &smb2_data->IndexNumber);
 		if (rc) {
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index d71a3e2..206efde 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -84,11 +84,9 @@ extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon *tcon,
 				const char *from_name, const char *to_name,
 				struct cifs_sb_info *cifs_sb);
 
-extern int smb2_open_file(const unsigned int xid, struct cifs_tcon *tcon,
-			  const char *full_path, int disposition,
-			  int desired_access, int create_options,
-			  struct cifs_fid *fid, __u32 *oplock,
-			  FILE_ALL_INFO *buf, struct cifs_sb_info *cifs_sb);
+extern int smb2_open_file(const unsigned int xid,
+			  struct cifs_open_parms *oparms,
+			  __u32 *oplock, FILE_ALL_INFO *buf);
 extern void smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 extern int smb2_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
-- 
1.7.10.4
