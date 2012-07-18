From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 16/45] CIFS: Move create code use ops struct
Date: Wed, 18 Jul 2012 19:48:32 +0400
Message-ID: <1342626541-29872-17-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/dir.c     |   94 ++++++++++++++++++++++++++++------------------------
 fs/cifs/file.c    |   10 +++---
 fs/cifs/smb1ops.c |    2 +-
 3 files changed, 57 insertions(+), 49 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index eebffaf..7265e5a 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -160,17 +160,18 @@ check_name(struct dentry *direntry)
 static int
 cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	       struct tcon_link *tlink, unsigned oflags, umode_t mode,
-	       __u32 *oplock, __u16 *fileHandle, int *created)
+	       __u32 *oplock, struct cifs_fid *fid, int *created)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
-	int desiredAccess;
+	int desired_access;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_tcon *tcon = tlink_tcon(tlink);
 	char *full_path = NULL;
 	FILE_ALL_INFO *buf = NULL;
 	struct inode *newinode = NULL;
 	int disposition;
+	struct TCP_Server_Info *server = tcon->ses->server;
 
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
@@ -185,8 +186,8 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-		rc = cifs_posix_open(full_path, &newinode,
-			inode->i_sb, mode, oflags, oplock, fileHandle, xid);
+		rc = cifs_posix_open(full_path, &newinode, inode->i_sb, mode,
+				     oflags, oplock, &fid->netfid, xid);
 		switch (rc) {
 		case 0:
 			if (newinode == NULL) {
@@ -202,7 +203,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 				 * close it and proceed as if it were a normal
 				 * lookup.
 				 */
-				CIFSSMBClose(xid, tcon, *fileHandle);
+				CIFSSMBClose(xid, tcon, fid->netfid);
 				goto cifs_create_get_file_info;
 			}
 			/* success, no need to query */
@@ -244,11 +245,11 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 		 */
 	}
 
-	desiredAccess = 0;
+	desired_access = 0;
 	if (OPEN_FMODE(oflags) & FMODE_READ)
-		desiredAccess |= GENERIC_READ; /* is this too little? */
+		desired_access |= GENERIC_READ; /* is this too little? */
 	if (OPEN_FMODE(oflags) & FMODE_WRITE)
-		desiredAccess |= GENERIC_WRITE;
+		desired_access |= GENERIC_WRITE;
 
 	disposition = FILE_OVERWRITE_IF;
 	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
@@ -260,8 +261,15 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	else
 		cFYI(1, "Create flag not set in create function");
 
-	/* BB add processing to set equivalent of mode - e.g. via CreateX with
-	   ACLs */
+	/*
+	 * BB add processing to set equivalent of mode - e.g. via CreateX with
+	 * ACLs
+	 */
+
+	if (!server->ops->open) {
+		rc = -ENOSYS;
+		goto out;
+	}
 
 	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (buf == NULL) {
@@ -279,28 +287,18 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
-	if (tcon->ses->capabilities & CAP_NT_SMBS)
-		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
-			 desiredAccess, create_options,
-			 fileHandle, oplock, buf, cifs_sb->local_nls,
-			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	else
-		rc = -EIO; /* no NT SMB support fall into legacy open below */
-
-	if (rc == -EIO) {
-		/* old server, retry the open legacy style */
-		rc = SMBLegacyOpen(xid, tcon, full_path, disposition,
-			desiredAccess, create_options,
-			fileHandle, oplock, buf, cifs_sb->local_nls,
-			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	}
+	rc = server->ops->open(xid, tcon, full_path, disposition,
+			       desired_access, create_options, fid, oplock,
+			       buf, cifs_sb);
 	if (rc) {
 		cFYI(1, "cifs_create returned 0x%x", rc);
 		goto out;
 	}
 
-	/* If Open reported that we actually created a file
-	   then we now have to set the mode if possible */
+	/*
+	 * If Open reported that we actually created a file then we now have to
+	 * set the mode if possible.
+	 */
 	if ((tcon->unix_ext) && (*oplock & CIFS_CREATE_ACTION)) {
 		struct cifs_unix_set_info_args args = {
 				.mode	= mode,
@@ -321,11 +319,13 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 			args.uid = NO_CHANGE_64;
 			args.gid = NO_CHANGE_64;
 		}
-		CIFSSMBUnixSetFileInfo(xid, tcon, &args, *fileHandle,
-					current->tgid);
+		CIFSSMBUnixSetFileInfo(xid, tcon, &args, fid->netfid,
+				       current->tgid);
 	} else {
-		/* BB implement mode setting via Windows security
-		   descriptors e.g. */
+		/*
+		 * BB implement mode setting via Windows security
+		 * descriptors e.g.
+		 */
 		/* CIFSSMBWinSetPerms(xid,tcon,path,mode,-1,-1,nls);*/
 
 		/* Could set r/o dos attribute if mode & 0222 == 0 */
@@ -334,11 +334,11 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 cifs_create_get_file_info:
 	/* server might mask mode so we have to query for it */
 	if (tcon->unix_ext)
-		rc = cifs_get_inode_info_unix(&newinode, full_path,
-					      inode->i_sb, xid);
+		rc = cifs_get_inode_info_unix(&newinode, full_path, inode->i_sb,
+					      xid);
 	else {
-		rc = cifs_get_inode_info(&newinode, full_path, buf,
-					 inode->i_sb, xid, fileHandle);
+		rc = cifs_get_inode_info(&newinode, full_path, buf, inode->i_sb,
+					 xid, &fid->netfid);
 		if (newinode) {
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
 				newinode->i_mode = mode;
@@ -364,7 +364,7 @@ cifs_create_set_dentry:
 	/* ENOENT for create?  How weird... */
 	rc = -ENOENT;
 	if (!newinode) {
-		CIFSSMBClose(xid, tcon, *fileHandle);
+		CIFSSMBClose(xid, tcon, fid->netfid);
 		goto out;
 	}
 	rc = 0;
@@ -384,6 +384,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	unsigned int xid;
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct cifs_fid fid;
 	__u32 oplock;
 	struct cifsFileInfo *file_info;
@@ -421,22 +422,25 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		goto out_free_xid;
 
 	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
 
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid.netfid, opened);
+			    &oplock, &fid, opened);
 
 	if (rc)
 		goto out;
 
 	rc = finish_open(file, direntry, generic_file_open, opened);
 	if (rc) {
-		CIFSSMBClose(xid, tcon, fid.netfid);
+		if (server->ops->close)
+			server->ops->close(xid, tcon, &fid);
 		goto out;
 	}
 
 	file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
 	if (file_info == NULL) {
-		CIFSSMBClose(xid, tcon, fid.netfid);
+		if (server->ops->close)
+			server->ops->close(xid, tcon, &fid);
 		rc = -ENOMEM;
 	}
 
@@ -461,7 +465,9 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	 */
 	unsigned oflags = O_EXCL | O_CREAT | O_RDWR;
 	struct tcon_link *tlink;
-	__u16 fileHandle;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+	struct cifs_fid fid;
 	__u32 oplock;
 	int created = FILE_CREATED;
 
@@ -474,9 +480,11 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 		goto out_free_xid;
 
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fileHandle, &created);
-	if (!rc)
-		CIFSSMBClose(xid, tlink_tcon(tlink), fileHandle);
+			    &oplock, &fid, &created);
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+	if (!rc && server->ops->close)
+		server->ops->close(xid, tcon, &fid);
 
 	cifs_put_tlink(tlink);
 out_free_xid:
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b18b36a..e11a58a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -303,13 +303,13 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	if (list_empty(&cifsi->openFileList)) {
 		cFYI(1, "closing last open instance for inode %p",
 			cifs_file->dentry->d_inode);
-
-		/* in strict cache mode we need invalidate mapping on the last
-		   close  because it may cause a error when we open this file
-		   again and get at least level II oplock */
+		/*
+		 * In strict cache mode we need invalidate mapping on the last
+		 * close  because it may cause a error when we open this file
+		 * again and get at least level II oplock.
+		 */
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
 			CIFS_I(inode)->invalid_mapping = true;
-
 		cifs_set_oplock_level(cifsi, 0);
 	}
 	spin_unlock(&cifs_file_list_lock);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index cbbc122..dd64754 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -622,7 +622,7 @@ cifs_open_file(const unsigned int xid, struct cifs_tcon *tcon, const char *path,
 {
 	if (!(tcon->ses->capabilities & CAP_NT_SMBS))
 		return SMBLegacyOpen(xid, tcon, path, disposition,
-				     desired_access, CREATE_NOT_DIR,
+				     desired_access, create_options,
 				     &fid->netfid, oplock, buf,
 				     cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
 						& CIFS_MOUNT_MAP_SPECIAL_CHR);
-- 
1.7.1
