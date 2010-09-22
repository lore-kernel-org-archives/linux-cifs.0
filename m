From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/15] cifs: have find_readable/writable_file filter by fsuid (try #5)
Date: Wed, 22 Sep 2010 14:23:06 -0700
Message-ID: <1285190586-10750-2-git-send-email-jlayton@redhat.com>
References: <1285190586-10750-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285190586-10750-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we implement multiuser mounts, we'll need to filter filehandles
by fsuid. Add a flag for multiuser mounts and code to filter by
fsuid when it's set.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    3 ++-
 fs/cifs/cifsacl.c    |    4 ++--
 fs/cifs/cifsproto.h  |    4 ++--
 fs/cifs/dir.c        |    1 +
 fs/cifs/file.c       |   33 +++++++++++++++++++++++++--------
 fs/cifs/inode.c      |    6 +++---
 6 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index ba0afd3..e04e692 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -37,6 +37,7 @@
 #define CIFS_MOUNT_NOSSYNC      0x4000 /* don't do slow SMBflush on every sync*/
 #define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
 #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
+#define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
 
 struct cifs_sb_info {
 	struct cifsTconInfo *ptcon;	/* primary mount */
@@ -48,7 +49,7 @@ struct cifs_sb_info {
 	gid_t	mnt_gid;
 	mode_t	mnt_file_mode;
 	mode_t	mnt_dir_mode;
-	int     mnt_cifs_flags;
+	unsigned int mnt_cifs_flags;
 	int	prepathlen;
 	char   *prepath; /* relative path under the share to mount to */
 #ifdef CONFIG_CIFS_DFS_UPCALL
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 2647ea4..c9b4792 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -615,7 +615,7 @@ static struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 	struct cifsFileInfo *open_file = NULL;
 
 	if (inode)
-		open_file = find_readable_file(CIFS_I(inode));
+		open_file = find_readable_file(CIFS_I(inode), true);
 	if (!open_file)
 		return get_cifs_acl_by_path(cifs_sb, path, pacllen);
 
@@ -685,7 +685,7 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 
 	cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inode->i_mode);
 
-	open_file = find_readable_file(CIFS_I(inode));
+	open_file = find_readable_file(CIFS_I(inode), true);
 	if (!open_file)
 		return set_cifs_acl_by_path(cifs_sb, path, pnntsd, acllen);
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 18ee991..0e76b20 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -78,9 +78,9 @@ extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
 extern bool is_valid_oplock_break(struct smb_hdr *smb,
 				  struct TCP_Server_Info *);
 extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
-extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *);
+extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
-extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *);
+extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
 #endif
 extern unsigned int smbCalcSize(struct smb_hdr *ptr);
 extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 5adf47f..e249b56 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -144,6 +144,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 
 	pCifsFile->netfid = fileHandle;
 	pCifsFile->pid = current->tgid;
+	pCifsFile->uid = current_fsuid();
 	pCifsFile->pInode = igrab(newinode);
 	pCifsFile->mnt = mnt;
 	pCifsFile->pfile = file;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index feae0b8..211d6ee 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1168,9 +1168,15 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 }
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
-struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode)
+struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
+					bool fsuid_only)
 {
 	struct cifsFileInfo *open_file = NULL;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
+
+	/* only filter by fsuid on multiuser mounts */
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+		fsuid_only = false;
 
 	read_lock(&GlobalSMBSeslock);
 	/* we could simply get the first_list_entry since write-only entries
@@ -1179,6 +1185,8 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode)
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
 		if (open_file->closePend)
 			continue;
+		if (fsuid_only && open_file->uid != current_fsuid())
+			continue;
 		if (open_file->pfile && ((open_file->pfile->f_flags & O_RDWR) ||
 		    (open_file->pfile->f_flags & O_RDONLY))) {
 			if (!open_file->invalidHandle) {
@@ -1198,9 +1206,11 @@ struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode)
 }
 #endif
 
-struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode)
+struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
+					bool fsuid_only)
 {
 	struct cifsFileInfo *open_file;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cifs_inode->vfs_inode.i_sb);
 	bool any_available = false;
 	int rc;
 
@@ -1214,13 +1224,19 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode)
 		return NULL;
 	}
 
+	/* only filter by fsuid on multiuser mounts */
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
+		fsuid_only = false;
+
 	read_lock(&GlobalSMBSeslock);
 refind_writable:
 	list_for_each_entry(open_file, &cifs_inode->openFileList, flist) {
-		if (open_file->closePend ||
-		    (!any_available && open_file->pid != current->tgid))
+		if (open_file->closePend)
+			continue;
+		if (!any_available && open_file->pid != current->tgid)
+			continue;
+		if (fsuid_only && open_file->uid != current_fsuid())
 			continue;
-
 		if (open_file->pfile &&
 		    ((open_file->pfile->f_flags & O_RDWR) ||
 		     (open_file->pfile->f_flags & O_WRONLY))) {
@@ -1315,7 +1331,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	if (mapping->host->i_size - offset < (loff_t)to)
 		to = (unsigned)(mapping->host->i_size - offset);
 
-	open_file = find_writable_file(CIFS_I(mapping->host));
+	open_file = find_writable_file(CIFS_I(mapping->host), false);
 	if (open_file) {
 		bytes_written = cifs_write(open_file->pfile, write_data,
 					   to-from, &offset);
@@ -1388,7 +1404,7 @@ static int cifs_writepages(struct address_space *mapping,
 	 * but it'll at least handle the return. Maybe it should be
 	 * a BUG() instead?
 	 */
-	open_file = find_writable_file(CIFS_I(mapping->host));
+	open_file = find_writable_file(CIFS_I(mapping->host), false);
 	if (!open_file) {
 		kfree(iov);
 		return generic_writepages(mapping, wbc);
@@ -1505,7 +1521,8 @@ retry:
 				break;
 		}
 		if (n_iov) {
-			open_file = find_writable_file(CIFS_I(mapping->host));
+			open_file = find_writable_file(CIFS_I(mapping->host),
+							false);
 			if (!open_file) {
 				cERROR(1, "No writable handles for inode");
 				rc = -EBADF;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cca0d52..dcd0886 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -969,7 +969,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, int xid,
 	/*
 	 * If the file is already open for write, just use that fileid
 	 */
-	open_file = find_writable_file(cifsInode);
+	open_file = find_writable_file(cifsInode, true);
 	if (open_file) {
 		netfid = open_file->netfid;
 		netpid = open_file->pid;
@@ -1819,7 +1819,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	 * writebehind data than the SMB timeout for the SetPathInfo
 	 * request would allow
 	 */
-	open_file = find_writable_file(cifsInode);
+	open_file = find_writable_file(cifsInode, true);
 	if (open_file) {
 		__u16 nfid = open_file->netfid;
 		__u32 npid = open_file->pid;
@@ -1984,7 +1984,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 		args->ctime = NO_CHANGE_64;
 
 	args->device = 0;
-	open_file = find_writable_file(cifsInode);
+	open_file = find_writable_file(cifsInode, true);
 	if (open_file) {
 		u16 nfid = open_file->netfid;
 		u32 npid = open_file->pid;
-- 
1.7.3
