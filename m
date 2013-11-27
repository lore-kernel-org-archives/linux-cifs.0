From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 8/8 v2] cifs: Add support for readlink on dfs shares under posix extensions
Date: Wed, 27 Nov 2013 13:27:15 +0000
Message-ID: <1385558835-7990-1-git-send-email-sprabhu@redhat.com>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385399395-19217-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When using posix extensions, dfs shares in the dfs root show up as
symlinks resulting in userland tools such as 'ls' calling readlink() on
these shares. Since these are dfs shares, readlink fails with -EREMOTE.

With added support for dfs shares on readlink when using unix
extensions, we call GET_DFS_REFERRAL to obtain the DFS referral and
return the first node returned.

The dfs share in the dfs root is now displayed in the following manner.
$ ls -l /mnt
total 0
lrwxrwxrwx. 1 root root 19 Nov  6 09:47 test -> \vm140-31\test

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb1ops.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 988fddb7..abd2cc9 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -908,6 +908,33 @@ cifs_mand_lock(const unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
 }
 
 static int
+cifs_unix_dfs_readlink(const unsigned int xid, struct cifs_tcon *tcon,
+		       const unsigned char *searchName, char **symlinkinfo,
+		       const struct nls_table *nls_codepage)
+{
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	int rc;
+	unsigned int num_referrals = 0;
+	struct dfs_info3_param *referrals = NULL;
+
+	rc = get_dfs_path(xid, tcon->ses, searchName, nls_codepage,
+			  &num_referrals, &referrals, 0);
+
+	if (!rc && num_referrals > 0) {
+		*symlinkinfo = kstrndup(referrals->node_name,
+					strlen(referrals->node_name),
+					GFP_KERNEL);
+		if (!*symlinkinfo)
+			rc = -ENOMEM;
+		free_dfs_info_array(referrals, num_referrals);
+	}
+	return rc;
+#else /* No DFS support */
+	return -EREMOTE;
+#endif
+}
+
+static int
 cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 		   const char *full_path, char **target_path,
 		   struct cifs_sb_info *cifs_sb)
@@ -922,6 +949,11 @@ cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	if (cap_unix(tcon->ses)) {
 		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, target_path,
 					     cifs_sb->local_nls);
+		if (rc == -EREMOTE)
+			rc = cifs_unix_dfs_readlink(xid, tcon, full_path,
+						    target_path,
+						    cifs_sb->local_nls);
+
 		goto out;
 	}
 
-- 
1.8.3.1
