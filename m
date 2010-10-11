From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/16] cifs: eliminate oflags option from cifs_new_fileinfo
Date: Mon, 11 Oct 2010 15:07:22 -0400
Message-ID: <1286824053-12084-6-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Eliminate the poor, misunderstood "oflags" option from cifs_new_fileinfo.
The callers mostly pass in the filp->f_flags here.

That's not correct however since we're checking that value for
the presence of FMODE_READ. Luckily that only affects how the f_list is
ordered. What it really wants here is the file->f_mode, but this check
really makes no sense whatsoever. FMODE_READ will be set for O_RDWR or
O_RDONLY opens. So this in effect just moves those to the front of the
list and leaves O_WRONLY at the end.

That might make some sense if more things paid attention to the list
order, but the only thing that does is find_readable_file, which uses
it to stop scanning the list when it hits a write-only one.

Given that the operations while walking that list are so low cost, I
don't think it's worth having to deal with the list order here.

Let's just keep this simple and just put things on the list with
list_add, and eliminate the optimization in find_writable_file.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    3 +--
 fs/cifs/dir.c       |   15 ++++-----------
 fs/cifs/file.c      |    8 +++-----
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4f7edba..781676e 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -107,8 +107,7 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 
 extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
 				__u16 fileHandle, struct file *file,
-				struct tcon_link *tlink,
-				unsigned int oflags, __u32 oplock);
+				struct tcon_link *tlink, __u32 oplock);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
 				int mode, unsigned int f_flags,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 8c1af71..c95e88f 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -132,7 +132,7 @@ cifs_bp_rename_retry:
 
 struct cifsFileInfo *
 cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
-		  struct tcon_link *tlink, unsigned int oflags, __u32 oplock)
+		  struct tcon_link *tlink, __u32 oplock)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct cifsFileInfo *pCifsFile;
@@ -160,13 +160,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
 	pCifsInode = CIFS_I(newinode);
 	if (pCifsInode) {
-		/* if readable file instance put first in list*/
-		if (oflags & FMODE_READ)
-			list_add(&pCifsFile->flist, &pCifsInode->openFileList);
-		else
-			list_add_tail(&pCifsFile->flist,
-				      &pCifsInode->openFileList);
-
+		list_add(&pCifsFile->flist, &pCifsInode->openFileList);
 		if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
 			pCifsInode->clientCanCacheAll = true;
 			pCifsInode->clientCanCacheRead = true;
@@ -396,7 +390,7 @@ cifs_create_set_dentry:
 		}
 
 		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-						tlink, oflags, oplock);
+						tlink, oplock);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -670,8 +664,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			}
 
 			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
-						  tlink, nd->intent.open.flags,
-						  oplock);
+						  tlink, oplock);
 			if (cfile == NULL) {
 				fput(filp);
 				CIFSSMBClose(xid, pTcon, fileHandle);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b1ca6a4..66d977b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -273,7 +273,7 @@ int cifs_open(struct inode *inode, struct file *file)
 			cFYI(1, "posix open succeeded");
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
-							tlink, oflags, oplock);
+							tlink, oplock);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
 				rc = -ENOMEM;
@@ -365,8 +365,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	if (rc != 0)
 		goto out;
 
-	pCifsFile = cifs_new_fileinfo(inode, netfid, file, tlink,
-					file->f_flags, oplock);
+	pCifsFile = cifs_new_fileinfo(inode, netfid, file, tlink, oplock);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -1193,8 +1192,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 			} /* else might as well continue, and look for
 			     another, or simply have the caller reopen it
 			     again rather than trying to fix this handle */
-		} else /* write only file */
-			break; /* write only files are last so must be done */
+		}
 	}
 	read_unlock(&GlobalSMBSeslock);
 	return NULL;
-- 
1.7.2.3
