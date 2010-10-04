From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/14] cifs: move cifs_new_fileinfo to file.c
Date: Mon,  4 Oct 2010 13:52:56 -0400
Message-ID: <1286214781-626-10-git-send-email-jlayton@redhat.com>
References: <1286214781-626-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286214781-626-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's currently in dir.c which makes little sense...

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c  |   50 --------------------------------------------------
 fs/cifs/file.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 50 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 5dc8eed..983c483 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -130,56 +130,6 @@ cifs_bp_rename_retry:
 	return full_path;
 }
 
-struct cifsFileInfo *
-cifs_new_fileinfo(__u16 fileHandle, struct file *file,
-		  struct tcon_link *tlink, __u32 oplock)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
-	struct cifsInodeInfo *pCifsInode = CIFS_I(inode);
-	struct cifsFileInfo *pCifsFile;
-
-	pCifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
-	if (pCifsFile == NULL)
-		return pCifsFile;
-
-	pCifsFile->netfid = fileHandle;
-	pCifsFile->pid = current->tgid;
-	pCifsFile->uid = current_fsuid();
-	pCifsFile->dentry = dget(dentry);
-	pCifsFile->f_flags = file->f_flags;
-	pCifsFile->invalidHandle = false;
-	pCifsFile->closePend = false;
-	pCifsFile->tlink = cifs_get_tlink(tlink);
-	mutex_init(&pCifsFile->fh_mutex);
-	mutex_init(&pCifsFile->lock_mutex);
-	INIT_LIST_HEAD(&pCifsFile->llist);
-	atomic_set(&pCifsFile->count, 1);
-	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
-
-	write_lock(&GlobalSMBSeslock);
-	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
-
-	/* if readable file instance put first in list*/
-	if (file->f_mode & FMODE_READ)
-		list_add(&pCifsFile->flist, &pCifsInode->openFileList);
-	else
-		list_add_tail(&pCifsFile->flist, &pCifsInode->openFileList);
-
-	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
-		pCifsInode->clientCanCacheAll = true;
-		pCifsInode->clientCanCacheRead = true;
-		cFYI(1, "Exclusive Oplock inode %p", inode);
-	} else if ((oplock & 0xF) == OPLOCK_READ)
-		pCifsInode->clientCanCacheRead = true;
-
-	write_unlock(&GlobalSMBSeslock);
-
-	file->private_data = pCifsFile;
-
-	return pCifsFile;
-}
-
 int cifs_posix_open(char *full_path, struct inode **pinode,
 			struct super_block *sb, int mode, int oflags,
 			__u32 *poplock, __u16 *pnetfid, int xid)
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f63072c..2804528 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -159,6 +159,54 @@ client_can_cache:
 	return rc;
 }
 
+struct cifsFileInfo *
+cifs_new_fileinfo(__u16 fileHandle, struct file *file,
+		  struct tcon_link *tlink, __u32 oplock)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	struct cifsInodeInfo *pCifsInode = CIFS_I(inode);
+	struct cifsFileInfo *pCifsFile;
+
+	pCifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
+	if (pCifsFile == NULL)
+		return pCifsFile;
+
+	pCifsFile->netfid = fileHandle;
+	pCifsFile->pid = current->tgid;
+	pCifsFile->uid = current_fsuid();
+	pCifsFile->dentry = dget(dentry);
+	pCifsFile->f_flags = file->f_flags;
+	pCifsFile->invalidHandle = false;
+	pCifsFile->closePend = false;
+	pCifsFile->tlink = cifs_get_tlink(tlink);
+	mutex_init(&pCifsFile->fh_mutex);
+	mutex_init(&pCifsFile->lock_mutex);
+	INIT_LIST_HEAD(&pCifsFile->llist);
+	atomic_set(&pCifsFile->count, 1);
+	INIT_WORK(&pCifsFile->oplock_break, cifs_oplock_break);
+
+	write_lock(&GlobalSMBSeslock);
+	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
+
+	/* if readable file instance put first in list*/
+	if (file->f_mode & FMODE_READ)
+		list_add(&pCifsFile->flist, &pCifsInode->openFileList);
+	else
+		list_add_tail(&pCifsFile->flist, &pCifsInode->openFileList);
+
+	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
+		pCifsInode->clientCanCacheAll = true;
+		pCifsInode->clientCanCacheRead = true;
+		cFYI(1, "Exclusive Oplock inode %p", inode);
+	} else if ((oplock & 0xF) == OPLOCK_READ)
+		pCifsInode->clientCanCacheRead = true;
+
+	write_unlock(&GlobalSMBSeslock);
+	file->private_data = pCifsFile;
+	return pCifsFile;
+}
+
 int cifs_open(struct inode *inode, struct file *file)
 {
 	int rc = -EACCES;
-- 
1.7.2.3
