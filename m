From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: rename cifs_readdir_lookup to cifs_prime_dcache and make it void return
Date: Mon,  3 Dec 2012 06:44:37 -0500
Message-ID: <1354535077-21548-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The caller doesn't do anything with the dentry, so there's no point in
holding a reference to it on return. Also cifs_prime_dcache better
describes the actual purpose of the function.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c | 42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 6492092..6002fdc 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -66,18 +66,20 @@ static inline void dump_cifs_file_struct(struct file *file, char *label)
 #endif /* DEBUG2 */
 
 /*
+ * Attempt to preload the dcache with the results from the FIND_FIRST/NEXT
+ *
  * Find the dentry that matches "name". If there isn't one, create one. If it's
  * a negative dentry or the uniqueid changed, then drop it and recreate it.
  */
-static struct dentry *
-cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
+static void
+cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 		    struct cifs_fattr *fattr)
 {
 	struct dentry *dentry, *alias;
 	struct inode *inode;
 	struct super_block *sb = parent->d_inode->i_sb;
 
-	cFYI(1, "For %s", name->name);
+	cFYI(1, "%s: for %s", __func__, name->name);
 
 	if (parent->d_op && parent->d_op->d_hash)
 		parent->d_op->d_hash(parent, parent->d_inode, name);
@@ -87,37 +89,32 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 	dentry = d_lookup(parent, name);
 	if (dentry) {
 		int err;
+
 		inode = dentry->d_inode;
 		/* update inode in place if i_ino didn't change */
 		if (inode && CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
 			cifs_fattr_to_inode(inode, fattr);
-			return dentry;
+			goto out;
 		}
 		err = d_invalidate(dentry);
 		dput(dentry);
 		if (err)
-			return NULL;
+			return;
 	}
 
 	dentry = d_alloc(parent, name);
-	if (dentry == NULL)
-		return NULL;
+	if (!dentry)
+		return;
 
 	inode = cifs_iget(sb, fattr);
-	if (!inode) {
-		dput(dentry);
-		return NULL;
-	}
+	if (!inode)
+		goto out;
 
 	alias = d_materialise_unique(dentry, inode);
-	if (alias != NULL) {
-		dput(dentry);
-		if (IS_ERR(alias))
-			return NULL;
-		dentry = alias;
-	}
-
-	return dentry;
+	if (alias && !IS_ERR(alias))
+		dput(alias);
+out:
+	dput(dentry);
 }
 
 static void
@@ -662,7 +659,6 @@ static int cifs_filldir(char *find_entry, struct file *file, filldir_t filldir,
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_dirent de = { NULL, };
 	struct cifs_fattr fattr;
-	struct dentry *dentry;
 	struct qstr name;
 	int rc = 0;
 	ino_t ino;
@@ -733,13 +729,11 @@ static int cifs_filldir(char *find_entry, struct file *file, filldir_t filldir,
 		 */
 		fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 
-	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
-	dentry = cifs_readdir_lookup(file->f_dentry, &name, &fattr);
+	cifs_prime_dcache(file->f_dentry, &name, &fattr);
 
+	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
 	rc = filldir(dirent, name.name, name.len, file->f_pos, ino,
 		     fattr.cf_dtype);
-
-	dput(dentry);
 	return rc;
 }
 
-- 
1.7.11.7
