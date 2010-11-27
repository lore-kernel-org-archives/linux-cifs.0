From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Misc. cleanup in cifsacl handling [try #4]
Date: Sat, 27 Nov 2010 11:37:26 -0600
Message-ID: <1290879446-12783-1-git-send-email-shirishpargaonkar@gmail.com>
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

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c   |    2 +-
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/inode.c     |   20 +++++++++++++++-----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 91992ab..c15e3ee 100644
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
index 6ed59af..b498731 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -133,7 +133,7 @@ extern int cifs_get_inode_info_unix(struct inode **pinode,
 extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      struct cifs_fattr *fattr, struct inode *inode,
 			      const char *path, const __u16 *pfid);
-extern int mode_to_acl(struct inode *inode, const char *path, __u64);
+extern int mode_to_cifs_acl(struct inode *inode, const char *path, __u64);
 
 extern int cifs_mount(struct super_block *, struct cifs_sb_info *, char *,
 			const char *);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ff7d299..122e065 100644
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
 
@@ -2115,9 +2120,14 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	if (attrs->ia_valid & ATTR_MODE) {
 		rc = 0;
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
+		} else
 #endif
 		if (((mode & S_IWUGO) == 0) &&
 		    (cifsInode->cifsAttrs & ATTR_READONLY) == 0) {
-- 
1.6.0.2
