From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/15] cifs: don't use vfsmount to pin superblock for oplock breaks
Date: Fri,  8 Oct 2010 13:30:59 -0400
Message-ID: <1286559072-29032-3-git-send-email-jlayton@redhat.com>
References: <1286559072-29032-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286559072-29032-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Filesystems aren't really supposed to do anything with a vfsmount. It's
considered a layering violation since vfsmounts are entirely managed at
the VFS layer.

CIFS currently keeps an active reference to a vfsmount in order to
prevent the superblock vanishing before an oplock break has completed.
What we really want to do instead is to keep sb->s_active high until the
oplock break has completed. This patch borrows the scheme that NFS uses
for handling sillyrenames.

An atomic_t is added to the cifs_sb_info. When it transitions from 0 to
1, an extra reference to the superblock is taken (by bumping the
s_active value). When it transitions from 1 to 0, that reference is
dropped and a the superblock teardown may proceed if there are no more
references to it.

Also, the vfsmount pointer is removed from cifsFileInfo and from
cifs_new_fileinfo, and some bogus forward declarations are removed from
cifsfs.h.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |   18 ++++++++++++++++++
 fs/cifs/cifsfs.h     |    6 ++----
 fs/cifs/cifsglob.h   |    1 -
 fs/cifs/cifsproto.h  |    2 +-
 fs/cifs/dir.c        |   10 +++-------
 fs/cifs/file.c       |    9 ++++-----
 7 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 586ee3d..525ba59 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -48,6 +48,7 @@ struct cifs_sb_info {
 	struct nls_table *local_nls;
 	unsigned int rsize;
 	unsigned int wsize;
+	atomic_t active;
 	uid_t	mnt_uid;
 	gid_t	mnt_gid;
 	mode_t	mnt_file_mode;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1aca2d7..3facf25 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -83,6 +83,24 @@ extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
+void
+cifs_sb_active(struct super_block *sb)
+{
+	struct cifs_sb_info *server = CIFS_SB(sb);
+
+	if (atomic_inc_return(&server->active) == 1)
+		atomic_inc(&sb->s_active);
+}
+
+void
+cifs_sb_deactive(struct super_block *sb)
+{
+	struct cifs_sb_info *server = CIFS_SB(sb);
+
+	if (atomic_dec_and_test(&server->active))
+		deactivate_super(sb);
+}
+
 static int
 cifs_read_super(struct super_block *sb, void *data,
 		const char *devname, int silent)
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 786bdf3..85544bc 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -42,10 +42,8 @@ extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
 /* Functions related to super block operations */
-/* extern const struct super_operations cifs_super_ops;*/
-extern void cifs_read_inode(struct inode *);
-/*extern void cifs_delete_inode(struct inode *);*/  /* BB not needed yet */
-/* extern void cifs_write_inode(struct inode *); */ /* BB not needed yet */
+extern void cifs_sb_active(struct super_block *sb);
+extern void cifs_sb_deactive(struct super_block *sb);
 
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8fa4ccf..1e24ddc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -388,7 +388,6 @@ struct cifsFileInfo {
 	/* lock scope id (0 if none) */
 	struct file *pfile; /* needed for writepage */
 	struct dentry *dentry;
-	struct vfsmount *mnt;
 	struct tcon_link *tlink;
 	struct mutex lock_mutex;
 	struct list_head llist; /* list of byte range locks we have. */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 29a2ee8..7f416ab 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -107,7 +107,7 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 
 extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
 				__u16 fileHandle, struct file *file,
-				struct vfsmount *mnt, struct tcon_link *tlink,
+				struct tcon_link *tlink,
 				unsigned int oflags, __u32 oplock);
 extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6887c41..c205ec9 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -132,8 +132,7 @@ cifs_bp_rename_retry:
 
 struct cifsFileInfo *
 cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
-		  struct vfsmount *mnt, struct tcon_link *tlink,
-		  unsigned int oflags, __u32 oplock)
+		  struct tcon_link *tlink, unsigned int oflags, __u32 oplock)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct cifsFileInfo *pCifsFile;
@@ -147,7 +146,6 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
 	pCifsFile->pid = current->tgid;
 	pCifsFile->uid = current_fsuid();
 	pCifsFile->dentry = dget(dentry);
-	pCifsFile->mnt = mnt;
 	pCifsFile->pfile = file;
 	pCifsFile->invalidHandle = false;
 	pCifsFile->closePend = false;
@@ -485,8 +483,7 @@ cifs_create_set_dentry:
 		}
 
 		pfile_info = cifs_new_fileinfo(newinode, fileHandle, filp,
-						nd->path.mnt, tlink, oflags,
-						oplock);
+						tlink, oflags, oplock);
 		if (pfile_info == NULL) {
 			fput(filp);
 			CIFSSMBClose(xid, tcon, fileHandle);
@@ -760,8 +757,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 			}
 
 			cfile = cifs_new_fileinfo(newInode, fileHandle, filp,
-						  nd->path.mnt, tlink,
-						  nd->intent.open.flags,
+						  tlink, nd->intent.open.flags,
 						  oplock);
 			if (cfile == NULL) {
 				fput(filp);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c302b9c..fd78a35 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -282,7 +282,6 @@ int cifs_open(struct inode *inode, struct file *file)
 			}
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
-							file->f_path.mnt,
 							tlink, oflags, oplock);
 			if (pCifsFile == NULL) {
 				CIFSSMBClose(xid, tcon, netfid);
@@ -375,8 +374,8 @@ int cifs_open(struct inode *inode, struct file *file)
 	if (rc != 0)
 		goto out;
 
-	pCifsFile = cifs_new_fileinfo(inode, netfid, file, file->f_path.mnt,
-					tlink, file->f_flags, oplock);
+	pCifsFile = cifs_new_fileinfo(inode, netfid, file, tlink,
+					file->f_flags, oplock);
 	if (pCifsFile == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -2381,14 +2380,14 @@ void cifs_oplock_break(struct work_struct *work)
 
 void cifs_oplock_break_get(struct cifsFileInfo *cfile)
 {
-	mntget(cfile->mnt);
+	cifs_sb_active(cfile->dentry->d_sb);
 	cifsFileInfo_get(cfile);
 }
 
 void cifs_oplock_break_put(struct cifsFileInfo *cfile)
 {
-	mntput(cfile->mnt);
 	cifsFileInfo_put(cfile);
+	cifs_sb_deactive(cfile->dentry->d_sb);
 }
 
 const struct address_space_operations cifs_addr_ops = {
-- 
1.7.2.3
