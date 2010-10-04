From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/14] cifs: eliminate pfile pointer from cifsFileInfo
Date: Mon,  4 Oct 2010 13:52:55 -0400
Message-ID: <1286214781-626-9-git-send-email-jlayton@redhat.com>
References: <1286214781-626-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286214781-626-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

All the remaining users of cifsFileInfo->pfile just use it to get
at the f_flags/f_mode. Now that we store that separately in the
cifsFileInfo, there's no need to consult the pfile at all from
a cifsFileInfo pointer.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    1 -
 fs/cifs/dir.c      |    1 -
 fs/cifs/file.c     |   11 +++--------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d0ced6e..7e2503f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -386,7 +386,6 @@ struct cifsFileInfo {
 	__u16 netfid;		/* file id from remote */
 	/* BB add lock scope info here if needed */ ;
 	/* lock scope id (0 if none) */
-	struct file *pfile; /* needed for writepage */
 	struct dentry *dentry;
 	unsigned int f_flags;
 	struct tcon_link *tlink;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index fc872c4..5dc8eed 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -148,7 +148,6 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 	pCifsFile->uid = current_fsuid();
 	pCifsFile->dentry = dget(dentry);
 	pCifsFile->f_flags = file->f_flags;
-	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
 	pCifsFile->tlink = cifs_get_tlink(tlink);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a1817ed..f63072c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1082,8 +1082,7 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 			continue;
 		if (fsuid_only && open_file->uid != current_fsuid())
 			continue;
-		if (open_file->pfile && ((open_file->pfile->f_flags & O_RDWR) ||
-		    (open_file->pfile->f_flags & O_RDONLY))) {
+		if (OPEN_FMODE(open_file->f_flags) & FMODE_READ) {
 			if (!open_file->invalidHandle) {
 				/* found a good file */
 				/* lock it so it will not be closed on us */
@@ -1132,9 +1131,7 @@ refind_writable:
 			continue;
 		if (fsuid_only && open_file->uid != current_fsuid())
 			continue;
-		if (open_file->pfile &&
-		    ((open_file->pfile->f_flags & O_RDWR) ||
-		     (open_file->pfile->f_flags & O_WRONLY))) {
+		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			cifsFileInfo_get(open_file);
 
 			if (!open_file->invalidHandle) {
@@ -2098,9 +2095,7 @@ static int is_inode_writable(struct cifsInodeInfo *cifs_inode)
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (open_file->closePend)
 			continue;
-		if (open_file->pfile &&
-		    ((open_file->pfile->f_flags & O_RDWR) ||
-		     (open_file->pfile->f_flags & O_WRONLY))) {
+		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			read_unlock(&GlobalSMBSeslock);
 			return 1;
 		}
-- 
1.7.2.3
