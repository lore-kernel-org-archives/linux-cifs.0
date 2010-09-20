From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/15] cifs: have cifs_new_fileinfo take a tcon arg
Date: Mon, 20 Sep 2010 16:01:36 -0700
Message-ID: <1285023704-2159-8-git-send-email-jlayton@redhat.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To minimize calls to cifs_sb_tcon and to allow for a clear error path if
a tcon can't be acquired.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 ++--
 fs/cifs/dir.c       |   22 ++++++++++++----------
 fs/cifs/file.c      |    4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index be3edd9..be8b5f7 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -107,8 +107,8 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 
 extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
 				__u16 fileHandle, struct file *file,
-				struct vfsmount *mnt, unsigned int oflags,
-				__u32 oplock);
+				struct vfsmount *mnt, struct cifsTconInfo *tcon,
+				unsigned int oflags, __u32 oplock);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
 				int mode, int oflags,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index fe02435..23ec28a 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -131,9 +131,9 @@ cifs_bp_rename_retry:
 }
 
 struct cifsFileInfo *
-cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
-		  struct file *file, struct vfsmount *mnt, unsigned int oflags,
-		  __u32 oplock)
+cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
+		  struct vfsmount *mnt, struct cifsTconInfo *tcon,
+		  unsigned int oflags, __u32 oplock)
 {
 	struct cifsFileInfo *pCifsFile;
 	struct cifsInodeInfo *pCifsInode;
@@ -150,7 +150,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
-	pCifsFile->tcon = cifs_sb_tcon(cifs_sb);
+	pCifsFile->tcon = tcon;
 	mutex_init(&pCifsFile->fh_mutex);
 	mutex_init(&pCifsFile->lock_mutex);
 	INIT_LIST_HEAD(&pCifsFile->llist);
@@ -158,7 +158,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
 
 	write_lock(&GlobalSMBSeslock);
-	list_add(&pCifsFile->tlist, &cifs_sb_tcon(cifs_sb)->openFileList);
+	list_add(&pCifsFile->tlist, &tcon->openFileList);
 	pCifsInode = CIFS_I(newinode);
 	if (pCifsInode) {
 		/* if readable file instance put first in list*/
@@ -191,6 +191,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 	__u32 posix_flags = 0;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_fattr fattr;
+	struct cifsTconInfo *tcon = cifs_sb_tcon(cifs_sb);
 
 	cFYI(1, "posix open %s", full_path);
 
@@ -225,9 +226,9 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
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
@@ -466,7 +467,8 @@ cifs_create_set_dentry:
 		}
 
 		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-					       nd->path.mnt, oflags, oplock);
+					       nd->path.mnt, tcon, oflags,
+						oplock);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -726,7 +728,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			}
 
 			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
-						  nd->path.mnt,
+						  nd->path.mnt, pTcon,
 						  nd->intent.open.flags,
 						  oplock);
 			if (cfile == NULL) {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 634752d..6d44097 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -277,7 +277,7 @@ int cifs_open(struct inode *inode, struct file *file)
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
 							file->f_path.mnt,
-							oflags, oplock);
+							tcon, oflags, oplock);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
 				rc = -ENOMEM;
@@ -370,7 +370,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		goto out;
 
 	pCifsFile = cifs_new_fileinfo(inode, netfid, file, file->f_path.mnt,
-					file->f_flags, oplock);
+					tcon, file->f_flags, oplock);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
1.7.2.3
