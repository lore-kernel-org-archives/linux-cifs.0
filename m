From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 08/15] cifs: have cifs_new_fileinfo take a tcon arg
Date: Fri, 20 Aug 2010 15:32:04 -0400
Message-ID: <1282332731-17444-9-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

To minimize calls to cifs_sb_tcon and to allow for a clear error path if
a tcon can't be acquired.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsproto.h |    3 ++-
 fs/cifs/dir.c       |   20 +++++++++++---------
 fs/cifs/file.c      |    4 ++--
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1f54508..b7a0e33 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -106,7 +106,8 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 
 extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
 				__u16 fileHandle, struct file *file,
-				struct vfsmount *mnt, unsigned int oflags);
+				struct vfsmount *mnt, struct cifsTconInfo *tcon,
+				unsigned int oflags);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
 				int mode, int oflags,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index bb5505f..110c701 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -131,8 +131,9 @@ cifs_bp_rename_retry:
 }
 
 struct cifsFileInfo *
-cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
-		  struct file *file, struct vfsmount *mnt, unsigned int oflags)
+cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
+		  struct vfsmount *mnt, struct cifsTconInfo *tcon,
+		  unsigned int oflags)
 {
 	int oplock = 0;
 	struct cifsFileInfo *pCifsFile;
@@ -153,7 +154,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
-	pCifsFile->tcon = cifs_sb_tcon(cifs_sb);
+	pCifsFile->tcon = tcon;
 	mutex_init(&pCifsFile->fh_mutex);
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
@@ -161,7 +162,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	write_lock(&GlobalSMBSeslock);
-	list_add(&pCifsFile->tlist, &cifs_sb_tcon(cifs_sb)->openFileList);
+	list_add(&pCifsFile->tlist, &tcon->openFileList);
 	pCifsInode = CIFS_I(newinode);
 	if (pCifsInode) {
 		/* if readable file instance put first in list*/
@@ -194,6 +195,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 	__u32 posix_flags = 0;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_fattr fattr;
+	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
 
 	cFYI(1, "posix open %s", full_path);
 
@@ -228,9 +230,9 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 		posix_flags |= SMB_O_DIRECT;
 
 	mode &= ~current_umask();
-	rc = CIFSPOSIXCreate(xid, cifs_sb_tcon(cifs_sb), posix_flags, mode,
-			pnetfid, presp_data, poplock, full_path,
-			cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+	rc = CIFSPOSIXCreate(xid, tcon, posix_flags, mode, pnetfid, presp_data,
+			     poplock, full_path, cifs_sb->local_nls,
+			     cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc)
 		goto posix_open_ret;
@@ -469,7 +471,7 @@ cifs_create_set_dentry:
 		}
 
 		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-					       nd->path.mnt, oflags);
+					       nd->path.mnt, tcon, oflags);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -729,7 +731,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			}
 
 			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
-						  nd->path.mnt,
+						  nd->path.mnt, pTcon,
 						  nd->intent.open.flags);
 			if (cfile == NULL) {
 				fput(filp);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 30acc6d..a4a0134 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -277,7 +277,7 @@ int cifs_open(struct inode *inode, struct file *file)
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
 							file->f_path.mnt,
-							oflags);
+							tcon, oflags);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
 				rc = -ENOMEM;
@@ -370,7 +370,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		goto out;
 
 	pCifsFile = cifs_new_fileinfo(inode, netfid, file, file->f_path.mnt,
-					file->f_flags);
+				      tcon, file->f_flags);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
1.7.2.1

