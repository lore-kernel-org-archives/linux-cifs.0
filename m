From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: fix broken oplock handling
Date: Fri, 17 Sep 2010 18:56:39 +0530
Message-ID: <4C936C8F.9050804@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs_new_fileinfo() does not use the 'oplock' value from the callers. Instead,
it sets it to REQ_OPLOCK which seems wrong. We should be using the oplock value
obtained from the Server to set the inode's clientCanCacheAll or
clientCanCacheRead flags. Fix this by passing oplock from the callers to
cifs_new_fileinfo().

This change dates back to commit a6ce4932 (2.6.30-rc3). So, all the affected
versions will need this fix. Please Cc stable once reviewed and accepted.

Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsproto.h |    3 ++-
 fs/cifs/dir.c       |   12 +++++-------
 fs/cifs/file.c      |    4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1d60c65..f110e0e 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -107,7 +107,8 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 
 extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
 				__u16 fileHandle, struct file *file,
-				struct vfsmount *mnt, unsigned int oflags);
+				struct vfsmount *mnt, unsigned int oflags,
+				__u32 oplock);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
 				int mode, int oflags,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f9ed075..0f947bf 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -132,9 +132,9 @@ cifs_bp_rename_retry:
 
 struct cifsFileInfo *
 cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
-		  struct file *file, struct vfsmount *mnt, unsigned int oflags)
+		  struct file *file, struct vfsmount *mnt, unsigned int oflags,
+		  __u32 oplock)
 {
-	int oplock = 0;
 	struct cifsFileInfo *pCifsFile;
 	struct cifsInodeInfo *pCifsInode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(mnt->mnt_sb);
@@ -143,9 +143,6 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle,
 	if (pCifsFile == NULL)
 		return pCifsFile;
 
-	if (oplockEnabled)
-		oplock = REQ_OPLOCK;
-
 	pCifsFile->netfid = fileHandle;
 	pCifsFile->pid = current->tgid;
 	pCifsFile->pInode = igrab(newinode);
@@ -468,7 +465,7 @@ cifs_create_set_dentry:
 		}
 
 		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-					       nd->path.mnt, oflags);
+					       nd->path.mnt, oflags, oplock);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -729,7 +726,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
 						  nd->path.mnt,
-						  nd->intent.open.flags);
+						  nd->intent.open.flags,
+						  oplock);
 			if (cfile == NULL) {
 				fput(filp);
 				CIFSSMBClose(xid, pTcon, fileHandle);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index de748c6..681761c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -277,7 +277,7 @@ int cifs_open(struct inode *inode, struct file *file)
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
 							file->f_path.mnt,
-							oflags);
+							oflags, oplock);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
 				rc = -ENOMEM;
@@ -370,7 +370,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		goto out;
 
 	pCifsFile = cifs_new_fileinfo(inode, netfid, file, file->f_path.mnt,
-					file->f_flags);
+					file->f_flags, oplock);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;
