From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 6/7] cifs: use Minshall+French symlink functions
Date: Thu,  5 Aug 2010 21:50:20 +0200
Message-ID: <1281037821-11479-7-git-send-email-metze@samba.org>
References: <AANLkTimU=0P=qrPeu1KFTPriLfRLo94xHZ5Dy2x0JFrp@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimU=0P=qrPeu1KFTPriLfRLo94xHZ5Dy2x0JFrp-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If configured, Minshall+French Symlinks are used against
all servers. If the server supports UNIX Extensions,
we still create Minshall+French Symlinks on write,
but on read we fallback to UNIX Extension symlinks.

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/inode.c      |    7 +++++++
 fs/cifs/link.c       |   27 +++++++++++++++++++++++----
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 9e77145..7fde529 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -36,6 +36,7 @@
 #define CIFS_MOUNT_NOPOSIXBRL   0x2000 /* mandatory not posix byte range lock */
 #define CIFS_MOUNT_NOSSYNC      0x4000 /* don't do slow SMBflush on every sync*/
 #define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
+#define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
 
 struct cifs_sb_info {
 	struct cifsTconInfo *tcon;	/* primary mount */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index dc4c47a..f4b0207 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -661,6 +661,13 @@ int cifs_get_inode_info(struct inode **pinode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
 		cifs_sfu_mode(&fattr, full_path, cifs_sb, xid);
 
+	/* check for Minshall+French symlinks */
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
+		tmprc = CIFSCheckMFSymlink(&fattr, full_path, cifs_sb, xid);
+		if (tmprc)
+			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
+	}
+
 	if (!*pinode) {
 		*pinode = cifs_iget(sb, &fattr);
 		if (!*pinode)
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 4237901..74660b7 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -397,7 +397,8 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	 * but there doesn't seem to be any harm in allowing the client to
 	 * read them.
 	 */
-	if (!(tcon->ses->capabilities & CAP_UNIX)) {
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+	    && !(tcon->ses->capabilities & CAP_UNIX)) {
 		rc = -EACCES;
 		goto out;
 	}
@@ -408,8 +409,21 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 
 	cFYI(1, "Full path: %s inode = 0x%p", full_path, inode);
 
-	rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
-				     cifs_sb->local_nls);
+	rc = -EACCES;
+	/*
+	 * First try Minshall+French Symlinks, if configured
+	 * and fallback to UNIX Extensions Symlinks.
+	 */
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+		rc = CIFSQueryMFSymLink(xid, tcon, full_path, &target_path,
+					cifs_sb->local_nls,
+					cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (rc != 0)
+		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
+					     cifs_sb->local_nls);
+
 	kfree(full_path);
 out:
 	if (rc != 0) {
@@ -449,7 +463,12 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 	cFYI(1, "symname is %s", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
-	if (pTcon->unix_ext)
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
+		rc = CIFSCreateMFSymLink(xid, pTcon, full_path, symname,
+					 cifs_sb->local_nls,
+					 cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+	else if (pTcon->unix_ext)
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
 					   cifs_sb->local_nls);
 	/* else
-- 
1.7.0.4
