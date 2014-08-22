From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/5] cifs: shared-superblock - splice disconnected dentry
Date: Fri, 22 Aug 2014 17:21:43 -0500
Message-ID: <1408746103-10300-1-git-send-email-spargaonkar@suse.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	shirish <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: shirish <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

splice the dentry during lookup.  In case of servers who do not provide
uniqueids, look in the linked list off of superblock before sending
out a query on the wire and also do a dentry search before splicing
and free the entry in the linked list.

Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/dir.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 57 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d835ae2..b6ebb8c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -691,7 +691,7 @@ mknod_out:
 	return rc;
 }
 
-struct cifs_rdelem *
+static struct cifs_rdelem *
 find_rdelem_by_inode(struct inode *rdinode, struct cifs_sb_info * cifs_sb)
 {
 	struct cifs_rdelem *rdelem;
@@ -726,7 +726,7 @@ find_rdelem_by_dentry(const struct dentry *rdentry,
 	return NULL;
 }
 
-void
+static void
 find_rdelem_by_path(char *full_path, struct inode **newInode,
 			struct cifs_sb_info * cifs_sb)
 {
@@ -754,6 +754,9 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	struct cifs_tcon *pTcon;
 	struct inode *newInode = NULL;
 	char *full_path = NULL;
+	struct dentry *ret = NULL;
+	struct cifs_rdelem *rdelem;
+	struct qstr dname;
 
 	xid = get_xid();
 
@@ -791,20 +794,62 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
 		 full_path, direntry->d_inode);
 
-	if (pTcon->unix_ext) {
-		rc = cifs_get_inode_info_unix(&newInode, full_path,
-					      parent_dir_inode->i_sb, xid);
-	} else {
-		rc = cifs_get_inode_info(&newInode, full_path, NULL,
-				parent_dir_inode->i_sb, xid, NULL);
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+		/*
+		 * Looking for an existing disconnected root dentry if any,
+		 * before sending out a lookup on the wire.
+		 */
+		find_rdelem_by_path(full_path, &newInode, cifs_sb);
 	}
 
+	if (!newInode) {
+		if (pTcon->unix_ext) {
+			rc = cifs_get_inode_info_unix(&newInode, full_path,
+					parent_dir_inode->i_sb, xid);
+		} else
+			rc = cifs_get_inode_info(&newInode, full_path, NULL,
+					parent_dir_inode->i_sb, xid, NULL);
+	}
+	/* else, found an anonymous root dentry with an inode */
+
 	if ((rc == 0) && (newInode != NULL)) {
-		d_add(direntry, newInode);
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
-		renew_parental_timestamps(direntry);
+		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+			dname.name = direntry->d_name.name;
+			dname.len = strlen(direntry->d_name.name) + 1;
+			/*
+			 * Perhaps another lookup beat us to this.
+			 */
+			spin_lock(&cifs_sb->rtdislock);
+			ret = d_lookup(direntry->d_parent, &dname);
+			if (ret && !IS_ERR(ret)) {
+				dput(ret);
+				spin_unlock(&cifs_sb->rtdislock);
+				goto lookup_out;
+			} else
+				ret = d_splice_alias(newInode, direntry);
+			spin_unlock(&cifs_sb->rtdislock);
+		} else
+			ret = d_splice_alias(newInode, direntry);
 
+		if (!ret)
+			renew_parental_timestamps(direntry);
+		else {
+			if (!IS_ERR(ret)) {
+				if (!(cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_SERVER_INUM)) {
+					rdelem =
+					find_rdelem_by_inode(newInode, cifs_sb);
+					if (rdelem)
+						cifs_free_rdelem(rdelem);
+				}
+				renew_parental_timestamps(ret);
+				dput(ret);
+				goto lookup_out;
+			} else
+				rc = PTR_ERR(ret);
+		}
 	} else if (rc == -ENOENT) {
 		rc = 0;
 		direntry->d_time = jiffies;
@@ -816,12 +861,13 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		/* We special case check for Access Denied - since that
 		is a common return code */
 	}
+	ret = ERR_PTR(rc);
 
 lookup_out:
 	kfree(full_path);
 	cifs_put_tlink(tlink);
 	free_xid(xid);
-	return ERR_PTR(rc);
+	return ret;
 }
 
 static void
-- 
1.8.4.5
