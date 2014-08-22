From: shirishpargaonkar@gmail.com
Subject: [PATCH 1/5] cifs: shared-superblock: create a root dentry/inode for EACCES error
Date: Fri, 22 Aug 2014 17:20:46 -0500
Message-ID: <1408746046-10147-1-git-send-email-spargaonkar@suse.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	shirish <shirishpargaonkar@gmail.com>,
	Shirish Pargaonkar <spargaonkar@suse.com>
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: shirish <shirishpargaonkar@gmail.com>

It is possible that an authenticated user has access to a subdirectory being
mounted but does not have access to the share directory at the server to be
mounted on a root directory.
Create an dummy inode with ROOT_I and continue the mount process.

Signed-off-by: Shirish Pargaonkar <spargaonkar@suse.com>
---
 fs/cifs/inode.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 41de393..fd5941b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -889,8 +889,10 @@ inode_has_hashed_dentries(struct inode *inode)
 	spin_lock(&inode->i_lock);
 	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
-			spin_unlock(&inode->i_lock);
-			return true;
+			if (!(dentry->d_flags & DCACHE_DISCONNECTED)) {
+				spin_unlock(&inode->i_lock);
+				return true;
+			}
 		}
 	}
 	spin_unlock(&inode->i_lock);
@@ -942,6 +944,23 @@ retry_iget5_locked:
 	return inode;
 }
 
+void
+fill_phfattr(struct cifs_fattr *cf, struct super_block *sb)
+{
+
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+
+	memset(cf, 0, sizeof(*cf));
+	cf->cf_uniqueid = ROOT_I;
+	cf->cf_nlink = 1;
+	cf->cf_atime = CURRENT_TIME;
+	cf->cf_ctime = CURRENT_TIME;
+	cf->cf_mtime = CURRENT_TIME;
+	cf->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
+	cf->cf_uid = cifs_sb->mnt_uid;
+	cf->cf_gid = cifs_sb->mnt_gid;
+}
+
 /* gets root inode */
 struct inode *cifs_root_iget(struct super_block *sb)
 {
@@ -950,6 +969,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 	struct inode *inode = NULL;
 	long rc;
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct cifs_fattr phfattr;
 
 	xid = get_xid();
 	if (tcon->unix_ext)
@@ -958,8 +978,16 @@ struct inode *cifs_root_iget(struct super_block *sb)
 		rc = cifs_get_inode_info(&inode, "", NULL, sb, xid, NULL);
 
 	if (!inode) {
-		inode = ERR_PTR(rc);
-		goto out;
+		if (rc == -EACCES) {
+			fill_phfattr(&phfattr, sb);
+			inode = cifs_iget(sb, &phfattr);
+			if (inode)
+				rc = 0;
+		}
+		if (rc) {
+			inode = ERR_PTR(rc);
+			goto out;
+		}
 	}
 
 #ifdef CONFIG_CIFS_FSCACHE
-- 
1.8.4.5

