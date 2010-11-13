From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Misc. cleanup in cifsacl handling
Date: Sat, 13 Nov 2010 10:02:18 -0600
Message-ID: <1289664138-16108-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Change the name of function mode_to_acl to mode_to_cifs_acl.

Handle return code in functions mode_to_cifs_acl and 
cifs_acl_to_fattr.

Pass fid to inode helper function which passes it on to
get inode info function so we do not end up opening the
opened file again thus breaking oplocks.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c   |    2 +-
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/file.c      |    7 ++++---
 fs/cifs/inode.c     |   23 ++++++++++++++++-------
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index b54fec0..c6ebea0 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -726,7 +726,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 }
 
 /* Convert mode bits to an ACL so we can update the ACL on the server */
-int mode_to_acl(struct inode *inode, const char *path, __u64 nmode)
+int mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode)
 {
 	int rc = 0;
 	__u32 secdesclen = 0;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index a47ffc2..db961dc 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -133,7 +133,7 @@ extern int cifs_get_inode_info_unix(struct inode **pinode,
 extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      struct cifs_fattr *fattr, struct inode *inode,
 			      const char *path, const __u16 *pfid);
-extern int mode_to_acl(struct inode *inode, const char *path, __u64);
+extern int mode_to_cifs_acl(struct inode *inode, const char *path, __u64);
 extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 					const char *, u32 *);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b857ce5..6e8477e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -106,7 +106,7 @@ static inline int cifs_get_disposition(unsigned int flags)
 
 static inline int cifs_open_inode_helper(struct inode *inode,
 	struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_INFO *buf,
-	char *full_path, int xid)
+	char *full_path, int xid, const __u16 *pfid)
 {
 	struct cifsInodeInfo *pCifsInode = CIFS_I(inode);
 	struct timespec temp;
@@ -144,7 +144,7 @@ client_can_cache:
 					      xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
-					 xid, NULL);
+					 xid, pfid);
 
 	cifs_set_oplock_level(pCifsInode, oplock);
 
@@ -448,7 +448,8 @@ int cifs_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	rc = cifs_open_inode_helper(inode, tcon, oplock, buf, full_path, xid);
+	rc = cifs_open_inode_helper(inode, tcon, oplock, buf, full_path, xid,
+					&netfid);
 	if (rc != 0)
 		goto out;
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ff7d299..35014dc 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -689,8 +689,13 @@ int cifs_get_inode_info(struct inode **pinode,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	/* fill in 0777 bits from ACL */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
-		cFYI(1, "Getting mode bits from ACL");
-		cifs_acl_to_fattr(cifs_sb, &fattr, *pinode, full_path, pfid);
+		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *pinode, full_path,
+						pfid);
+		if (rc) {
+			cFYI(1, "%s: Getting ACL failed with error: %d",
+				__func__, rc);
+			goto cgii_exit;
+		}
 	}
 #endif
 
@@ -2047,7 +2052,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	char *full_path = NULL;
-	int rc = -EACCES;
+	int rc;
 	__u32 dosattr = 0;
 	__u64 mode = NO_CHANGE_64;
 
@@ -2113,11 +2118,15 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	}
 
 	if (attrs->ia_valid & ATTR_MODE) {
-		rc = 0;
 #ifdef CONFIG_CIFS_EXPERIMENTAL
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
-			rc = mode_to_acl(inode, full_path, mode);
-		else
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
+			rc = mode_to_cifs_acl(inode, full_path, mode);
+			if (rc) {
+				cFYI(1, "%s: Setting ACL failed with error: %d",
+					__func__, rc);
+				goto cifs_setattr_exit;
+			}
+		}
 #endif
 		if (((mode & S_IWUGO) == 0) &&
 		    (cifsInode->cifsAttrs & ATTR_READONLY) == 0) {
-- 
1.6.0.2
