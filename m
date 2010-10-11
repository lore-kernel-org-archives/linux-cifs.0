From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/16] cifs: keep dentry reference in cifsFileInfo instead of inode reference
Date: Mon, 11 Oct 2010 15:07:18 -0400
Message-ID: <1286824053-12084-2-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifsFileInfo is a bit problematic. It contains a reference back to the
struct file itself. This makes it difficult for a cifsFileInfo to exist
without a corresponding struct file.

It would be better instead of the cifsFileInfo just held info pertaining
to the open file on the server instead without any back refrences to the
struct file. This would allow it to exist after the filp to which it was
originally attached was closed.

Much of the use of the file pointer in this struct is to get at the
dentry.  Begin divorcing the cifsFileInfo from the struct file by
keeping a reference to the dentry. Since the dentry will have a
reference to the inode, we can eliminate the "pInode" field too and
convert the igrab/iput to dget/dput.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/cifs/cifsglob.h |    4 ++--
 fs/cifs/dir.c      |    3 ++-
 fs/cifs/file.c     |    2 +-
 fs/cifs/misc.c     |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index eef5df1..8fa4ccf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -387,7 +387,7 @@ struct cifsFileInfo {
 	/* BB add lock scope info here if needed */ ;
 	/* lock scope id (0 if none) */
 	struct file *pfile; /* needed for writepage */
-	struct inode *pInode; /* needed for oplock break */
+	struct dentry *dentry;
 	struct vfsmount *mnt;
 	struct tcon_link *tlink;
 	struct mutex lock_mutex;
@@ -412,7 +412,7 @@ static inline void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 {
 	if (atomic_dec_and_test(&cifs_file->count)) {
 		cifs_put_tlink(cifs_file->tlink);
-		iput(cifs_file->pInode);
+		dput(cifs_file->dentry);
 		kfree(cifs_file);
 	}
 }
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index e249b56..6887c41 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -135,6 +135,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 		  struct vfsmount *mnt, struct tcon_link *tlink,
 		  unsigned int oflags, __u32 oplock)
 {
+	struct dentry *dentry = file->f_path.dentry;
 	struct cifsFileInfo *pCifsFile;
 	struct cifsInodeInfo *pCifsInode;
 
@@ -145,7 +146,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 	pCifsFile->netfid = fileHandle;
 	pCifsFile->pid = current->tgid;
 	pCifsFile->uid = current_fsuid();
-	pCifsFile->pInode = igrab(newinode);
+	pCifsFile->dentry = dget(dentry);
 	pCifsFile->mnt = mnt;
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 80856f1..c302b9c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2335,7 +2335,7 @@ void cifs_oplock_break(struct work_struct *work)
 {
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
-	struct inode *inode = cfile->pInode;
+	struct inode *inode = cfile->dentry->d_inode;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	int rc, waitrc = 0;
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 252f276..9bac3e7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -578,7 +578,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				}
 
 				cFYI(1, "file id match, oplock break");
-				pCifsInode = CIFS_I(netfile->pInode);
+				pCifsInode = CIFS_I(netfile->dentry->d_inode);
 				pCifsInode->clientCanCacheAll = false;
 				if (pSMB->OplockLevel == 0)
 					pCifsInode->clientCanCacheRead = false;
-- 
1.7.2.3
