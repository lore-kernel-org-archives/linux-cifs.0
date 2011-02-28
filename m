From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Allow nfsd over cifs
Date: Mon, 28 Feb 2011 15:52:41 -0600
Message-ID: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Define structure cifs_fid to span 64 bits of inode ids.
Allow nfsd over cifs.
Add export ops encode_fh and fh_to_dentry.
Add a function to find inodes off of a superblock, using only id.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    4 +-
 fs/cifs/cifsfs.h    |    4 +-
 fs/cifs/cifsglob.h  |    5 ++++
 fs/cifs/cifsproto.h |    2 +
 fs/cifs/dir.c       |   16 +++++--------
 fs/cifs/export.c    |   58 +++++++++++++++++++++++++++++++++++++-------------
 fs/cifs/inode.c     |   15 ++++++++++++-
 7 files changed, 74 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 13b3999..29ff05c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -187,12 +187,12 @@ cifs_read_super(struct super_block *sb, void *data,
 	else
 		sb->s_d_op = &cifs_dentry_ops;
 
-#ifdef CIFS_NFSD_EXPORT
+#ifdef CONFIG_CIFS_NFSD_EXPORT
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 		cFYI(1, "export ops supported");
 		sb->s_export_op = &cifs_export_ops;
 	}
-#endif /* CIFS_NFSD_EXPORT */
+#endif /* CONFIG_CIFS_NFSD_EXPORT */
 
 	return 0;
 
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 371d021..1d8185d 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -123,9 +123,9 @@ extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
-#ifdef CIFS_NFSD_EXPORT
+#ifdef CONFIG_CIFS_NFSD_EXPORT
 extern const struct export_operations cifs_export_ops;
-#endif /* CIFS_NFSD_EXPORT */
+#endif /* CONFIG_CIFS_NFSD_EXPORT */
 
 #define CIFS_VERSION   "1.71"
 #endif				/* _CIFSFS_H */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e1098c3..c7faac6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -672,6 +672,11 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 	kfree(param);
 }
 
+struct cifs_fid {
+	u64 cino;
+	u64 cpino;
+};
+
 #define   MID_FREE 0
 #define   MID_REQUEST_ALLOCATED 1
 #define   MID_REQUEST_SUBMITTED 2
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index da7a492..0d0afd2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -432,6 +432,8 @@ extern int mdfour(unsigned char *, unsigned char *, int);
 extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
 extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24);
+extern int cifs_find_inode_id(struct inode *, void *);
+extern int cifs_init_inode(struct inode *, void *);
 extern void E_P16(unsigned char *p14, unsigned char *p16);
 extern void E_P24(unsigned char *p21, const unsigned char *c8,
 			unsigned char *p24);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index dd5f229..4e9c38f 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -491,6 +491,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	struct inode *newInode = NULL;
 	char *full_path = NULL;
 	struct file *filp;
+	struct dentry *spdirentry = NULL;
 
 	xid = GetXid();
 
@@ -586,7 +587,9 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 				parent_dir_inode->i_sb, xid, NULL);
 
 	if ((rc == 0) && (newInode != NULL)) {
-		d_add(direntry, newInode);
+		spdirentry = d_splice_alias(newInode, direntry);
+		if (spdirentry)
+			return spdirentry;
 		if (posix_open) {
 			filp = lookup_instantiate_filp(nd, direntry,
 						       generic_file_open);
@@ -631,7 +634,7 @@ lookup_out:
 static int
 cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
-	if (nd->flags & LOOKUP_RCU)
+	if (nd && nd->flags & LOOKUP_RCU)
 		return -ECHILD;
 
 	if (direntry->d_inode) {
@@ -642,18 +645,11 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 	}
 
 	/*
-	 * This may be nfsd (or something), anyway, we can't see the
-	 * intent of this. So, since this can be for creation, drop it.
-	 */
-	if (!nd)
-		return 0;
-
-	/*
 	 * Drop the negative dentry, in order to make sure to use the
 	 * case sensitive name which is specified by user if this is
 	 * for creation.
 	 */
-	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
+	if (nd && !(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
 		if (nd->flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
 			return 0;
 	}
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index 55d87ac..fd8397f 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -44,24 +44,52 @@
 #include "cifsglob.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
+#include "cifsproto.h"
 
-#ifdef CIFS_NFSD_EXPORT
-static struct dentry *cifs_get_parent(struct dentry *dentry)
+#ifdef CONFIG_CIFS_NFSD_EXPORT
+static int cifs_encode_fh(struct dentry *dentry, __u32 *fh, int *lenp,
+				int connectable)
 {
-	/* BB need to add code here eventually to enable export via NFSD */
-	cFYI(1, "get parent for %p", dentry);
-	return ERR_PTR(-EACCES);
+	struct cifs_fid *cfid = (struct cifs_fid *)fh;
+	struct inode *inode = dentry->d_inode;
+
+	cfid->cino = inode->i_ino;
+
+	/*
+	 * There is not a type to send ino32_gen32_parentino32_gen32 to
+	 * accomodate two 64 bit inode numbers. So always return this type.
+	 */
+	return FILEID_INO32_GEN;
 }
 
-const struct export_operations cifs_export_ops = {
-	.get_parent = cifs_get_parent,
-/*	Following five export operations are unneeded so far and can default:
-	.get_dentry =
-	.get_name =
-	.find_exported_dentry =
-	.decode_fh =
-	.encode_fs =  */
-};
+static struct dentry *
+cifs_fh_to_dentry(struct super_block *sb, struct fid *fh,
+			int fh_len, int fh_type)
+{
+	struct cifs_fid *cfid = (struct cifs_fid *)fh;
+	struct inode *inode = NULL;
+	struct cifs_fattr fattr;
+
 
-#endif /* CIFS_NFSD_EXPORT */
+	if (fh_type != FILEID_INO32_GEN && fh_type != FILEID_INO32_GEN_PARENT) {
+		cERROR(1, "%s: Can't handle fh type: %d", __func__, fh_type);
+		return ERR_PTR(-EINVAL);
+	}
 
+	if (!cfid->cino)
+		return ERR_PTR(-ESTALE);
+
+	fattr.cf_uniqueid = cfid->cino;
+	inode = iget5_locked(sb, cfid->cino, cifs_find_inode_id,
+					cifs_init_inode, &fattr);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	return d_obtain_alias(inode);
+}
+
+const struct export_operations cifs_export_ops = {
+	.encode_fh = cifs_encode_fh,
+	.fh_to_dentry = cifs_fh_to_dentry
+};
+#endif /* CONFIG_CIFS_NFSD_EXPORT */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 196ef60..9c86535 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -777,6 +777,19 @@ char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
 	return full_path;
 }
 
+int
+cifs_find_inode_id(struct inode *inode, void *opaque)
+{
+	int rc = 0;
+	struct cifs_fattr *fattr = (struct cifs_fattr *) opaque;
+
+	/* match inode with uniqueid */
+	if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid)
+		rc = 1;
+
+	return rc;
+}
+
 static int
 cifs_find_inode(struct inode *inode, void *opaque)
 {
@@ -801,7 +814,7 @@ cifs_find_inode(struct inode *inode, void *opaque)
 	return 1;
 }
 
-static int
+int
 cifs_init_inode(struct inode *inode, void *opaque)
 {
 	struct cifs_fattr *fattr = (struct cifs_fattr *) opaque;
-- 
1.6.0.2
