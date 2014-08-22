From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/5] cifs: shared-superblock - various routines to search disconnected root dentry
Date: Fri, 22 Aug 2014 17:21:14 -0500
Message-ID: <1408746074-10223-1-git-send-email-spargaonkar@suse.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	shirish <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: shirish <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The disconnected root dentries in a linked list off of superblock
from servers that do not provide uniqueids can be searched by dentries,
inodes, and full paths when time comes to search them for either splicing
(during lookup) or freeing.

Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/dir.c       | 95 +++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 86 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c31ce98..c1047e2 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -205,6 +205,7 @@ extern void cifs_add_pending_open_locked(struct cifs_fid *fid,
 					 struct tcon_link *tlink,
 					 struct cifs_pending_open *open);
 extern void cifs_del_pending_open(struct cifs_pending_open *open);
+extern void cifs_free_rdelem(struct cifs_rdelem *);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 3db0c5f..d835ae2 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -691,6 +691,58 @@ mknod_out:
 	return rc;
 }
 
+struct cifs_rdelem *
+find_rdelem_by_inode(struct inode *rdinode, struct cifs_sb_info * cifs_sb)
+{
+	struct cifs_rdelem *rdelem;
+
+	spin_lock(&cifs_sb->rtdislock);
+	list_for_each_entry(rdelem, &cifs_sb->rtdislist, rdlist) {
+		if (rdelem->rdinode == rdinode) {
+			list_del(&rdelem->rdlist);
+			spin_unlock(&cifs_sb->rtdislock);
+			return rdelem;
+		}
+	}
+	spin_unlock(&cifs_sb->rtdislock);
+	return NULL;
+}
+
+static struct cifs_rdelem *
+find_rdelem_by_dentry(const struct dentry *rdentry,
+			struct cifs_sb_info * cifs_sb)
+{
+	struct cifs_rdelem *rdelem;
+
+	spin_lock(&cifs_sb->rtdislock);
+	list_for_each_entry(rdelem, &cifs_sb->rtdislist, rdlist) {
+		if (rdelem->rdentry == rdentry) {
+			list_del(&rdelem->rdlist);
+			spin_unlock(&cifs_sb->rtdislock);
+			return rdelem;
+		}
+	}
+	spin_unlock(&cifs_sb->rtdislock);
+	return NULL;
+}
+
+void
+find_rdelem_by_path(char *full_path, struct inode **newInode,
+			struct cifs_sb_info * cifs_sb)
+{
+	struct cifs_rdelem *rdelem;
+
+	spin_lock(&cifs_sb->rtdislock);
+	list_for_each_entry(rdelem, &cifs_sb->rtdislist, rdlist) {
+		if (!strcmp(rdelem->rdname, full_path)) {
+			*newInode = ilookup(rdelem->rdinode->i_sb,
+						rdelem->rdinode->i_ino);
+			break;
+		}
+	}
+	spin_unlock(&cifs_sb->rtdislock);
+}
+
 struct dentry *
 cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	    unsigned int flags)
@@ -772,6 +824,35 @@ lookup_out:
 	return ERR_PTR(rc);
 }
 
+static void
+cifs_d_common_releasedelete(const struct dentry *dentry)
+{
+	struct cifs_rdelem *rdelem;
+	struct cifs_sb_info *cifs_sb;
+
+	cifs_sb = CIFS_SB(dentry->d_sb);
+
+	/* disconnected root dentries that did not get spliced */
+	if (IS_ROOT(dentry) && dentry->d_flags & DCACHE_DISCONNECTED) {
+		rdelem = find_rdelem_by_dentry(dentry, cifs_sb);
+		if (rdelem)
+			cifs_free_rdelem(rdelem);
+	}
+}
+
+static int
+cifs_d_delete(const struct dentry *dentry)
+{
+	cifs_d_common_releasedelete(dentry);
+	return 0;
+}
+
+static void
+cifs_d_release(struct dentry *dentry)
+{
+	cifs_d_common_releasedelete(dentry);
+}
+
 static int
 cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
@@ -821,19 +902,11 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 	return 1;
 }
 
-/* static int cifs_d_delete(struct dentry *direntry)
-{
-	int rc = 0;
-
-	cifs_dbg(FYI, "In cifs d_delete, name = %s\n", direntry->d_name.name);
-
-	return rc;
-}     */
-
 const struct dentry_operations cifs_dentry_ops = {
 	.d_revalidate = cifs_d_revalidate,
 	.d_automount = cifs_dfs_d_automount,
-/* d_delete:       cifs_d_delete,      */ /* not needed except for debugging */
+	.d_delete = cifs_d_delete,
+	.d_release = cifs_d_release,
 };
 
 static int cifs_ci_hash(const struct dentry *dentry, struct qstr *q)
@@ -908,4 +981,6 @@ const struct dentry_operations cifs_ci_dentry_ops = {
 	.d_hash = cifs_ci_hash,
 	.d_compare = cifs_ci_compare,
 	.d_automount = cifs_dfs_d_automount,
+	.d_delete = cifs_d_delete,
+	.d_release = cifs_d_release,
 };
-- 
1.8.4.5
