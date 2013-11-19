From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Allow mounts for paths for restricted intermediate paths
Date: Tue, 19 Nov 2013 10:33:33 -0600
Message-ID: <1384878813-7413-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Allow cifs mounts for a prefixpath with intermediate paths without access,
so as to continue with the shared superblock model.

For the intermediate path entries that do not allow access, create "placeholder"
inodes and instantiate dentries with those inodes.
If and when such a path entry becomes accessible it is filled with correct
info.

Reference: Samba bugzilla 6950

Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

---
 fs/cifs/cifsfs.c    | 17 +++++++++++++++--
 fs/cifs/cifsproto.h |  3 +++
 fs/cifs/inode.c     | 16 ++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 849f613..bce185c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -584,6 +584,9 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 	char *full_path = NULL;
 	char *s, *p;
 	char sep;
+	struct inode *dir, *phinode;
+	struct dentry *child;
+	struct cifs_fattr phfattr;
 
 	full_path = cifs_build_path_to_root(vol, cifs_sb,
 					    cifs_sb_master_tcon(cifs_sb));
@@ -592,13 +595,13 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 
 	cifs_dbg(FYI, "Get root dentry for %s\n", full_path);
 
+	fill_phfattr(&phfattr, sb);
 	sep = CIFS_DIR_SEP(cifs_sb);
 	dentry = dget(sb->s_root);
 	p = s = full_path;
 
 	do {
-		struct inode *dir = dentry->d_inode;
-		struct dentry *child;
+		dir = dentry->d_inode;
 
 		if (!dir) {
 			dput(dentry);
@@ -626,6 +629,16 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 		mutex_unlock(&dir->i_mutex);
 		dput(dentry);
 		dentry = child;
+		if (!IS_ERR(dentry)) {
+			if (*s) {
+				/* EACCESS on an intermediate dir */
+				if (!dentry->d_inode) {
+					phinode = cifs_iget(sb, &phfattr);
+					if (phinode)
+						d_instantiate(dentry, phinode);
+				}
+			}
+		}
 	} while (!IS_ERR(dentry));
 	kfree(full_path);
 	return dentry;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index aa33976..9a84e5c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -498,4 +498,7 @@ void cifs_writedata_release(struct kref *refcount);
 int open_query_close_cifs_symlink(const unsigned char *path, char *pbuf,
 			unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
 			unsigned int xid);
+
+extern void fill_phfattr(struct cifs_fattr *, struct super_block *);
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 36f9ebb..4f5a09a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -322,6 +322,22 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 	fattr->cf_flags |= CIFS_FATTR_DFS_REFERRAL;
 }
 
+void
+fill_phfattr(struct cifs_fattr *cf, struct super_block *sb)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+
+	memset(cf, 0, sizeof(*cf));
+	cf->cf_uniqueid = iunique(sb, ROOT_I);
+	cf->cf_nlink = 1;
+	cf->cf_atime = CURRENT_TIME;
+	cf->cf_ctime = CURRENT_TIME;
+	cf->cf_mtime = CURRENT_TIME;
+	cf->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
+	cf->cf_uid = cifs_sb->mnt_uid;
+	cf->cf_gid = cifs_sb->mnt_gid;
+}
+
 static int
 cifs_get_file_info_unix(struct file *filp)
 {
-- 
1.8.3.2
