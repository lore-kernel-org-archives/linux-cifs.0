From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC] cifs: revalidate directories instiantiated via FIND_* in order to handle DFS referrals
Date: Tue, 15 Jan 2013 14:01:31 -0500
Message-ID: <1358276491-4835-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We've had a long-standing problem with DFS referral points. CIFS servers
generally try to make them look like directories in FIND_FIRST/NEXT
responses. When you go to try to do a FIND_FIRST on them though, the
server will then (correctly) return STATUS_PATH_NOT_COVERED. Mostly this
manifests as spurious EREMOTE errors back to userland.

This patch attempts to fix this by marking directories that are
discovered via FIND_FIRST/NEXT for revaldiation. When the lookup code
runs across them again, we'll reissue a QPathInfo against them and that
will make it chase the referral properly.

There is some performance penalty involved here and no I haven't
measured it -- it'll be highly dependent upon the workload and contents
of the mounted share. To try and mitigate that though, the code only
marks the inode for revalidation when it's possible to run across a DFS
referral. i.e.: when the kernel has DFS support built in and the share
is "in DFS".

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index cdd6ff4..5fc9b4a 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -128,6 +128,22 @@ out:
 	dput(dentry);
 }
 
+/*
+ * Is it possible that this directory might turn out to be a DFS referral
+ * once we go to try and use it?
+ */
+static bool
+cifs_dfs_is_possible(struct cifs_sb_info *cifs_sb)
+{
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
+	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
+		return true;
+#endif
+	return false;
+}
+
 static void
 cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 {
@@ -137,6 +153,14 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
 	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
 		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
 		fattr->cf_dtype = DT_DIR;
+		/*
+		 * CIFS servers generally make DFS referrals look like
+		 * directories in FIND_* responses. Since there's no way to
+		 * tell the difference, we must revalidate directory inodes
+		 * before trying to use them.
+		 */
+		if (cifs_dfs_is_possible(cifs_sb))
+			fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
 	} else {
 		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
 		fattr->cf_dtype = DT_REG;
-- 
1.7.11.7
