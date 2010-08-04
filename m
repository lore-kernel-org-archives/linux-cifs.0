From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/8] cifs: add CIFSCreateMFSymLink() and CIFSQueryMFSymLink() as stubs
Date: Wed,  4 Aug 2010 16:11:43 +0200
Message-ID: <1280931109-22380-3-git-send-email-metze@samba.org>
References: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/link.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 473ca80..2358a5f 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -29,6 +29,24 @@
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
 
+static int
+CIFSCreateMFSymLink(const int xid, struct cifsTconInfo *tcon,
+		    const char *fromName, const char *toName,
+		    const struct nls_table *nls_codepage)
+{
+	int rc = -EOPNOTSUPP;
+	return rc;
+}
+
+static int
+CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
+		   const unsigned char *searchName, char **symlinkinfo,
+		   const struct nls_table *nls_codepage)
+{
+	int rc = -EOPNOTSUPP;
+	return rc;
+}
+
 int
 cifs_hardlink(struct dentry *old_file, struct inode *inode,
 	      struct dentry *direntry)
@@ -130,7 +148,8 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	 * but there doesn't seem to be any harm in allowing the client to
 	 * read them.
 	 */
-	if (!(tcon->ses->capabilities & CAP_UNIX)) {
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	    && !(tcon->ses->capabilities & CAP_UNIX)) {
 		rc = -EACCES;
 		goto out;
 	}
@@ -141,8 +160,12 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 
 	cFYI(1, "Full path: %s inode = 0x%p", full_path, inode);
 
-	rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
-				     cifs_sb->local_nls);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+		rc = CIFSQueryMFSymLink(xid, tcon, full_path, &target_path,
+					cifs_sb->local_nls);
+	else
+		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
+					     cifs_sb->local_nls);
 	kfree(full_path);
 out:
 	if (rc != 0) {
@@ -182,7 +205,10 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 	cFYI(1, "symname is %s", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (pTcon->unix_ext)
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+		rc = CIFSCreateMFSymLink(xid, pTcon, full_path, symname,
+					 cifs_sb->local_nls);
+	else if (pTcon->unix_ext)
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
 					   cifs_sb->local_nls);
 	/* else
-- 
1.7.0.4
