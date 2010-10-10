From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] CIFS   Handle extended attribute name cifsacl to generate cifs acl blob (try #2)
Date: Sun, 10 Oct 2010 15:31:56 -0500
Message-ID: <1286742716-4467-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Add extended attribute name system.cifsacl

Get/generate cifs/ntfs acl blob and hand over to the invoker however
it wants to parse/process it.

Do get CIFS/NTFS ACL for xattr for attribute system.posix_acl_access


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c   |    2 +-
 fs/cifs/cifsproto.h |    2 ++
 fs/cifs/xattr.c     |   41 ++++++++++++++++++++---------------------
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index c9b4792..bafe774 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -607,7 +607,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 }
 
 /* Retrieve an ACL from the server */
-static struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
+struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *cifs_sb,
 				      struct inode *inode, const char *path,
 				      u32 *pacllen)
 {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 29a2ee8..229156e 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -134,6 +134,8 @@ extern void cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
 			      struct cifs_fattr *fattr, struct inode *inode,
 			      const char *path, const __u16 *pfid);
 extern int mode_to_acl(struct inode *inode, const char *path, __u64);
+extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
+					const char *, u32 *);
 
 extern int cifs_mount(struct super_block *, struct cifs_sb_info *, char *,
 			const char *);
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index a264b74..6899438 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -30,6 +30,7 @@
 
 #define MAX_EA_VALUE_SIZE 65535
 #define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
+#define CIFS_ACL_XATTR "system.cifsacl"
 #define CIFS_XATTR_USER_PREFIX "user."
 #define CIFS_XATTR_SYSTEM_PREFIX "system."
 #define CIFS_XATTR_OS2_PREFIX "os2."
@@ -217,11 +218,13 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 	ssize_t rc = -EOPNOTSUPP;
 #ifdef CONFIG_CIFS_XATTR
 	int xid;
+	u32 acllen;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
 	struct super_block *sb;
 	char *full_path;
+	struct cifs_ntsd *pacl;
 
 	if (direntry == NULL)
 		return -EIO;
@@ -277,27 +280,6 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 				cifs_sb->local_nls,
 				cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
-#ifdef CONFIG_CIFS_EXPERIMENTAL
-		else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
-			__u16 fid;
-			int oplock = 0;
-			struct cifs_ntsd *pacl = NULL;
-			__u32 buflen = 0;
-			if (experimEnabled)
-				rc = CIFSSMBOpen(xid, pTcon, full_path,
-					FILE_OPEN, GENERIC_READ, 0, &fid,
-					&oplock, NULL, cifs_sb->local_nls,
-					cifs_sb->mnt_cifs_flags &
-					CIFS_MOUNT_MAP_SPECIAL_CHR);
-			/* else rc is EOPNOTSUPP from above */
-
-			if (rc == 0) {
-				rc = CIFSSMBGetCIFSACL(xid, pTcon, fid, &pacl,
-						      &buflen);
-				CIFSSMBClose(xid, pTcon, fid);
-			}
-		}
-#endif /* EXPERIMENTAL */
 #else
 		cFYI(1, "query POSIX ACL not supported yet");
 #endif /* CONFIG_CIFS_POSIX */
@@ -313,6 +295,23 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 #else
 		cFYI(1, "query POSIX default ACL not supported yet");
 #endif
+	} else if (strncmp(ea_name, CIFS_ACL_XATTR,
+				strlen(CIFS_ACL_XATTR)) == 0) {
+			pacl = get_cifs_acl(cifs_sb, direntry->d_inode,
+						full_path, &acllen);
+			if (!pacl) {
+				cERROR(1, "get CIFS ACL xattr error");
+				rc = -EIO;
+			} else {
+				if (ea_value) {
+					if (acllen > buf_size)
+						acllen = -ERANGE;
+					else
+						memcpy(ea_value, pacl, acllen);
+				}
+				rc = acllen;
+				kfree(pacl);
+			}
 	} else if (strncmp(ea_name,
 		  CIFS_XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
 		cFYI(1, "Trusted xattr namespace not supported yet");
-- 
1.6.0.2
