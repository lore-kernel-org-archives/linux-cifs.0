From: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: Drop cached dentry if its metadata changed
Date: Mon, 19 Oct 2015 14:23:06 +0100
Message-ID: <1445260986-1886-1-git-send-email-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If a dentry's inode changes, drop the cached dentry to force a full
lookup. This fixes a problem similar to that fixed by
commit 9e6d722f3d91 ("cifs: make new inode cache when file type is
different") where, after a file is renamed on the server, the client
ends up with two dentries (for different files) pointing to the same
inode.

Signed-off-by: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.h    |  2 +-
 fs/cifs/cifsproto.h |  3 ++-
 fs/cifs/dir.c       |  9 +++++----
 fs/cifs/file.c      |  4 ++--
 fs/cifs/inode.c     | 36 +++++++++++++++++++++++++++---------
 fs/cifs/link.c      |  2 +-
 6 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index c3cc160..2c28e43 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -71,7 +71,7 @@ extern int cifs_rmdir(struct inode *, struct dentry *);
 extern int cifs_rename2(struct inode *, struct dentry *, struct inode *,
 			struct dentry *, unsigned int);
 extern int cifs_revalidate_file_attr(struct file *filp);
-extern int cifs_revalidate_dentry_attr(struct dentry *);
+extern int cifs_revalidate_dentry_attr(struct dentry *, bool check_inode_no);
 extern int cifs_revalidate_file(struct file *filp);
 extern int cifs_revalidate_dentry(struct dentry *);
 extern int cifs_invalidate_mapping(struct inode *inode);
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c63fd1d..9410656 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -158,7 +158,8 @@ extern struct inode *cifs_iget(struct super_block *sb,
 
 extern int cifs_get_inode_info(struct inode **inode, const char *full_path,
 			       FILE_ALL_INFO *data, struct super_block *sb,
-			       int xid, const struct cifs_fid *fid);
+			       int xid, const struct cifs_fid *fid,
+			       bool check_inode_no);
 extern int cifs_get_inode_info_unix(struct inode **pinode,
 			const unsigned char *search_path,
 			struct super_block *sb, unsigned int xid);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index c3eb998..d326f04 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -378,7 +378,7 @@ cifs_create_get_file_info:
 					      xid);
 	else {
 		rc = cifs_get_inode_info(&newinode, full_path, buf, inode->i_sb,
-					 xid, fid);
+					 xid, fid, false);
 		if (newinode) {
 			if (server->ops->set_lease_key)
 				server->ops->set_lease_key(newinode, fid);
@@ -757,7 +757,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 					      parent_dir_inode->i_sb, xid);
 	} else {
 		rc = cifs_get_inode_info(&newInode, full_path, NULL,
-				parent_dir_inode->i_sb, xid, NULL);
+				parent_dir_inode->i_sb, xid, NULL, false);
 	}
 
 	if ((rc == 0) && (newInode != NULL)) {
@@ -792,9 +792,10 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 		return -ECHILD;
 
 	if (d_really_is_positive(direntry)) {
-		if (cifs_revalidate_dentry(direntry))
+		if (cifs_revalidate_dentry(direntry)) {
+			d_drop(direntry);
 			return 0;
-		else {
+		} else {
 			/*
 			 * If the inode wasn't known to be a dfs entry when
 			 * the dentry was instantiated, such as when created
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 62203c3..cfa3772 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -243,7 +243,7 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 					      xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
-					 xid, fid);
+					 xid, fid, false);
 
 out:
 	kfree(buf);
@@ -723,7 +723,7 @@ reopen_success:
 						      inode->i_sb, xid);
 		else
 			rc = cifs_get_inode_info(&inode, full_path, NULL,
-						 inode->i_sb, xid, NULL);
+						 inode->i_sb, xid, NULL, false);
 	}
 	/*
 	 * Else we are writing out data to server already and could deadlock if
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6b66dd5..dc7c9c2 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -704,7 +704,7 @@ cgfi_exit:
 int
 cifs_get_inode_info(struct inode **inode, const char *full_path,
 		    FILE_ALL_INFO *data, struct super_block *sb, int xid,
-		    const struct cifs_fid *fid)
+		    const struct cifs_fid *fid, bool check_inode_no)
 {
 	bool validinum = false;
 	__u16 srchflgs;
@@ -814,8 +814,26 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 			}
 		} else
 			fattr.cf_uniqueid = iunique(sb, ROOT_I);
-	} else
-		fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
+	} else {
+		if (check_inode_no &&
+		    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) &&
+		    server->ops->get_srv_inum) {
+			tmprc = server->ops->get_srv_inum(xid,
+				tcon, cifs_sb, full_path,
+				&fattr.cf_uniqueid, data);
+			if (tmprc) {
+				cifs_dbg(FYI, "GetSrvInodeNum rc %d\n",
+					 tmprc);
+				fattr.cf_uniqueid = iunique(sb, ROOT_I);
+				cifs_autodisable_serverino(cifs_sb);
+			} else if (CIFS_I(*inode)->uniqueid !=
+					fattr.cf_uniqueid) {
+				rc = -ESTALE;
+				goto cgii_exit;
+			}
+		} else
+			fattr.cf_uniqueid = CIFS_I(*inode)->uniqueid;
+	}
 
 	/* query for SFU type info if supported and needed */
 	if (fattr.cf_cifsattrs & ATTR_SYSTEM &&
@@ -993,7 +1011,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 		tcon->unix_ext = false;
 	}
 
-	rc = cifs_get_inode_info(&inode, "", NULL, sb, xid, NULL);
+	rc = cifs_get_inode_info(&inode, "", NULL, sb, xid, NULL, false);
 
 iget_no_retry:
 	if (!inode) {
@@ -1349,7 +1367,7 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 					      xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, parent->i_sb,
-					 xid, NULL);
+					 xid, NULL, false);
 
 	if (rc)
 		return rc;
@@ -1887,7 +1905,7 @@ int cifs_revalidate_file_attr(struct file *filp)
 	return rc;
 }
 
-int cifs_revalidate_dentry_attr(struct dentry *dentry)
+int cifs_revalidate_dentry_attr(struct dentry *dentry, bool check_inode_no)
 {
 	unsigned int xid;
 	int rc = 0;
@@ -1919,7 +1937,7 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
-					 xid, NULL);
+					 xid, NULL, check_inode_no);
 
 out:
 	kfree(full_path);
@@ -1945,7 +1963,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 	int rc;
 	struct inode *inode = d_inode(dentry);
 
-	rc = cifs_revalidate_dentry_attr(dentry);
+	rc = cifs_revalidate_dentry_attr(dentry, true);
 	if (rc)
 		return rc;
 
@@ -1973,7 +1991,7 @@ int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		}
 	}
 
-	rc = cifs_revalidate_dentry_attr(dentry);
+	rc = cifs_revalidate_dentry_attr(dentry, false);
 	if (rc)
 		return rc;
 
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index e3548f7..e915ba7 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -727,7 +727,7 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 						      inode->i_sb, xid);
 		else
 			rc = cifs_get_inode_info(&newinode, full_path, NULL,
-						 inode->i_sb, xid, NULL);
+						 inode->i_sb, xid, NULL, false);
 
 		if (rc != 0) {
 			cifs_dbg(FYI, "Create symlink ok, getinodeinfo fail rc = %d\n",
-- 
2.4.3
