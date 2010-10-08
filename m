From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/15] cifs: eliminate the inode argument from cifs_new_fileinfo
Date: Fri,  8 Oct 2010 13:31:02 -0400
Message-ID: <1286559072-29032-6-git-send-email-jlayton@redhat.com>
References: <1286559072-29032-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286559072-29032-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It already takes a file pointer. The inode associated with that had damn
well better be the same one we're passing in anyway. Thus, there's no
need for a separate argument here.

Also, get rid of the bogus check for a null pCifsInode pointer. The
CIFS_I macro uses container_of(), and that will virtually never return a
NULL pointer anyway.

Finally, move the setting of the canCache* flags outside of the lock.
Other places in the code don't hold that lock when setting it, so I
assume it's not really needed here either.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/cifs/cifsproto.h |    3 +--
 fs/cifs/dir.c       |   30 ++++++++++++++----------------
 fs/cifs/file.c      |    6 +++---
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index bed004c..a2bdfa2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -105,8 +105,7 @@ extern u64 cifs_UnixTimeToNT(struct timespec);
 extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 				      int offset);
 
-extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
-				__u16 fileHandle, struct file *file,
+extern struct cifsFileInfo *cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 				struct tcon_link *tlink, __u32 oplock);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 452c9b5..6c38a41 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -131,12 +131,13 @@ cifs_bp_rename_retry:
 }
 
 struct cifsFileInfo *
-cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
+cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
 {
 	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	struct cifsInodeInfo *pCifsInode = CIFS_I(inode);
 	struct cifsFileInfo *pCifsFile;
-	struct cifsInodeInfo *pCifsInode;
 
 	pCifsFile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
 	if (pCifsFile == NULL)
@@ -158,18 +159,16 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 
 	write_lock(&GlobalSMBSeslock);
 	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
-	pCifsInode = CIFS_I(newinode);
-	if (pCifsInode) {
-		list_add(&pCifsFile->flist, &pCifsInode->openFileList);
-		if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
-			pCifsInode->clientCanCacheAll = true;
-			pCifsInode->clientCanCacheRead = true;
-			cFYI(1, "Exclusive Oplock inode %p", newinode);
-		} else if ((oplock & 0xF) == OPLOCK_READ)
-				pCifsInode->clientCanCacheRead = true;
-	}
+	list_add(&pCifsFile->flist, &pCifsInode->openFileList);
 	write_unlock(&GlobalSMBSeslock);
 
+	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
+		pCifsInode->clientCanCacheAll = true;
+		pCifsInode->clientCanCacheRead = true;
+		cFYI(1, "Exclusive Oplock inode %p", inode);
+	} else if ((oplock & 0xF) == OPLOCK_READ)
+		pCifsInode->clientCanCacheRead = true;
+
 	file->private_data = pCifsFile;
 
 	return pCifsFile;
@@ -476,8 +475,7 @@ cifs_create_set_dentry:
 			goto cifs_create_out;
 		}
 
-		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-						tlink, oplock);
+		pfile_info = cifs_new_fileinfo(fileHandle, filp, tlink, oplock);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -750,8 +748,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 				goto lookup_out;
 			}
 
-			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
-						  tlink, oplock);
+			cfile = cifs_new_fileinfo(fileHandle, filp, tlink,
+						  oplock);
 			if (cfile == NULL) {
 				fput(filp);
 				CIFSSMBClose(xid, pTcon, fileHandle);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e863d80..1edec19 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -214,8 +214,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		if (rc == 0) {
 			cFYI(1, "posix open succeeded");
 
-			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
-							tlink, oplock);
+			pCifsFile = cifs_new_fileinfo(netfid, file, tlink,
+						      oplock);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
 				rc = -ENOMEM;
@@ -307,7 +307,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	if (rc != 0)
 		goto out;
 
-	pCifsFile = cifs_new_fileinfo(inode, netfid, file, tlink, oplock);
+	pCifsFile = cifs_new_fileinfo(netfid, file, tlink, oplock);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
1.7.2.3
