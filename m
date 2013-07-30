From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: set sb->s_d_op before calling d_make_root()
Date: Tue, 30 Jul 2013 11:38:44 -0400
Message-ID: <1375198724-22857-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>,
	Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, the s_root dentry doesn't get its d_op pointer set to
anything. This breaks lookups in the root of case-insensitive mounts
since that relies on having d_hash and d_compare routines that know to
treat the filename as case-insensitive.

cifs.ko has been broken this way for a long time, but commit 1c929cfe6
("switch cifs"), added a cryptic comment which is removed in the patch
below, which makes me wonder if this was done deliberately for some
reason. It's not clear to me why we'd want the s_root not to have d_op
set properly.

It may have something to do with d_automount or d_revalidate on the
root, but my suspicion in looking over the code is that Al was just
trying to preserve the existing behavior when changing this code over to
use s_d_op.

This patch changes it so that we set s_d_op before calling d_make_root
and removes the comment. I tested mounting, accessing and unmounting
several types of shares (including DFS referrals) and everything still
seemed to work OK afterward. I could be missing something however, so
please do let me know if I am.

Reported-by: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4bdd547..85ea98d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -147,18 +147,17 @@ cifs_read_super(struct super_block *sb)
 		goto out_no_root;
 	}
 
+	if (cifs_sb_master_tcon(cifs_sb)->nocase)
+		sb->s_d_op = &cifs_ci_dentry_ops;
+	else
+		sb->s_d_op = &cifs_dentry_ops;
+
 	sb->s_root = d_make_root(inode);
 	if (!sb->s_root) {
 		rc = -ENOMEM;
 		goto out_no_root;
 	}
 
-	/* do that *after* d_make_root() - we want NULL ->d_op for root here */
-	if (cifs_sb_master_tcon(cifs_sb)->nocase)
-		sb->s_d_op = &cifs_ci_dentry_ops;
-	else
-		sb->s_d_op = &cifs_dentry_ops;
-
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 		cifs_dbg(FYI, "export ops supported\n");
-- 
1.8.3.1
