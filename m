From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/15] cifs: eliminate oflags option from cifs_new_fileinfo
Date: Wed,  6 Oct 2010 15:54:06 -0400
Message-ID: <1286394857-32541-5-git-send-email-jlayton@redhat.com>
References: <1286394857-32541-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286394857-32541-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Eliminate the poor, misunderstood "oflags" option from cifs_new_fileinfo.
The callers mostly pass in the filp->f_flags here, except for one place
that passes in the flags after they've been converted to their SMB_O_*
equivalents.

None of these are correct however since we're checking that value for
the presence of FMODE_READ. Luckily that only affects how the f_list is
ordered.

What we really want here is the file->f_mode. Since we pass in a file
pointer already anyway, just use the f_mode there for this purpose.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/cifs/cifsproto.h |    3 +--
 fs/cifs/dir.c       |    9 ++++-----
 fs/cifs/file.c      |    5 ++---
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7f416ab..bed004c 100644
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
 				int mode, int oflags,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index c205ec9..b399e5b 100644
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
@@ -161,7 +161,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 	pCifsInode = CIFS_I(newinode);
 	if (pCifsInode) {
 		/* if readable file instance put first in list*/
-		if (oflags & FMODE_READ)
+		if (file->f_mode & FMODE_READ)
 			list_add(&pCifsFile->flist, &pCifsInode->openFileList);
 		else
 			list_add_tail(&pCifsFile->flist,
@@ -483,7 +483,7 @@ cifs_create_set_dentry:
 		}
 
 		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-						tlink, oflags, oplock);
+						tlink, oplock);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -757,8 +757,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			}
 
 			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
-						  tlink, nd->intent.open.flags,
-						  oplock);
+						  tlink, oplock);
 			if (cfile == NULL) {
 				fput(filp);
 				CIFSSMBClose(xid, pTcon, fileHandle);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c10f085..e863d80 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -215,7 +215,7 @@ int cifs_open(struct inode *inode, struct file *file)
 			cFYI(1, "posix open succeeded");
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
-							tlink, oflags, oplock);
+							tlink, oplock);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
 				rc = -ENOMEM;
@@ -307,8 +307,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	if (rc != 0)
 		goto out;
 
-	pCifsFile = cifs_new_fileinfo(inode, netfid, file, tlink,
-					file->f_flags, oplock);
+	pCifsFile = cifs_new_fileinfo(inode, netfid, file, tlink, oplock);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;
-- 
1.7.2.3
