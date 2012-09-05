From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: cleanups for cifs_mkdir_qinfo
Date: Wed,  5 Sep 2012 09:57:28 -0400
Message-ID: <1346853448-13322-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Rename inode pointers for better clarity. Move the d_instantiate call to
the end of the function to prevent other tasks from seeing it before
we've finished constructing it. Since we should have exclusive access to
the inode at this point, remove the spinlock around i_nlink update.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c | 51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index da4dd71..fd6551b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1176,34 +1176,33 @@ unlink_out:
 }
 
 static int
-cifs_mkdir_qinfo(struct inode *inode, struct dentry *dentry, umode_t mode,
+cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 		 const char *full_path, struct cifs_sb_info *cifs_sb,
 		 struct cifs_tcon *tcon, const unsigned int xid)
 {
 	int rc = 0;
-	struct inode *newinode = NULL;
+	struct inode *inode = NULL;
 
 	if (tcon->unix_ext)
-		rc = cifs_get_inode_info_unix(&newinode, full_path, inode->i_sb,
+		rc = cifs_get_inode_info_unix(&inode, full_path, parent->i_sb,
 					      xid);
 	else
-		rc = cifs_get_inode_info(&newinode, full_path, NULL,
-					 inode->i_sb, xid, NULL);
+		rc = cifs_get_inode_info(&inode, full_path, NULL, parent->i_sb,
+					 xid, NULL);
+
 	if (rc)
 		return rc;
 
-	d_instantiate(dentry, newinode);
 	/*
 	 * setting nlink not necessary except in cases where we failed to get it
-	 * from the server or was set bogus
+	 * from the server or was set bogus. Also, since this is a brand new
+	 * inode, no need to grab the i_lock before setting the i_nlink.
 	 */
-	spin_lock(&dentry->d_inode->i_lock);
-	if ((dentry->d_inode) && (dentry->d_inode->i_nlink < 2))
-		set_nlink(dentry->d_inode, 2);
-	spin_unlock(&dentry->d_inode->i_lock);
+	if (inode->i_nlink < 2)
+		set_nlink(inode, 2);
 	mode &= ~current_umask();
 	/* must turn on setgid bit if parent dir has it */
-	if (inode->i_mode & S_ISGID)
+	if (parent->i_mode & S_ISGID)
 		mode |= S_ISGID;
 
 	if (tcon->unix_ext) {
@@ -1216,8 +1215,8 @@ cifs_mkdir_qinfo(struct inode *inode, struct dentry *dentry, umode_t mode,
 		};
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
 			args.uid = (__u64)current_fsuid();
-			if (inode->i_mode & S_ISGID)
-				args.gid = (__u64)inode->i_gid;
+			if (parent->i_mode & S_ISGID)
+				args.gid = (__u64)parent->i_gid;
 			else
 				args.gid = (__u64)current_fsgid();
 		} else {
@@ -1232,22 +1231,20 @@ cifs_mkdir_qinfo(struct inode *inode, struct dentry *dentry, umode_t mode,
 		struct TCP_Server_Info *server = tcon->ses->server;
 		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
 		    (mode & S_IWUGO) == 0 && server->ops->mkdir_setinfo)
-			server->ops->mkdir_setinfo(newinode, full_path, cifs_sb,
+			server->ops->mkdir_setinfo(inode, full_path, cifs_sb,
 						   tcon, xid);
-		if (dentry->d_inode) {
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
-				dentry->d_inode->i_mode = (mode | S_IFDIR);
-
-			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-				dentry->d_inode->i_uid = current_fsuid();
-				if (inode->i_mode & S_ISGID)
-					dentry->d_inode->i_gid = inode->i_gid;
-				else
-					dentry->d_inode->i_gid =
-								current_fsgid();
-			}
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+			inode->i_mode = (mode | S_IFDIR);
+
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+			inode->i_uid = current_fsuid();
+			if (inode->i_mode & S_ISGID)
+				inode->i_gid = parent->i_gid;
+			else
+				inode->i_gid = current_fsgid();
 		}
 	}
+	d_instantiate(dentry, inode);
 	return rc;
 }
 
-- 
1.7.11.4
