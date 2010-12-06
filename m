From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: allow calling cifs_build_path_to_root on incomplete cifs_sb
Date: Mon,  6 Dec 2010 07:15:03 -0500
Message-ID: <1291637703-10989-1-git-send-email-jlayton@redhat.com>
References: <20101206070846.1f2c35d4@tlielax.poochiereds.net>
Cc: robbert-C1IQQP51G3M@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206070846.1f2c35d4-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible that cifs_mount will call cifs_build_path_to_root on a
newly instantiated cifs_sb. In that case, it's likely that the
master_tlink pointer has not yet been instantiated.

Fix this by having cifs_build_path_to_root take a cifsTconInfo pointer
as well, and have the caller pass that in.

Reported-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    3 ++-
 fs/cifs/connect.c   |    2 +-
 fs/cifs/inode.c     |    6 +++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f4cc34f..4e65b67 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -54,7 +54,8 @@ do {								\
 	     __func__, curr_xid, (int)rc);			\
 } while (0)
 extern char *build_path_from_dentry(struct dentry *);
-extern char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb);
+extern char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
+					struct cifsTconInfo *tcon);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index af7fa78..f2f58e3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2913,7 +2913,7 @@ remote_path_check:
 	/* check if a whole path (including prepath) is not remote */
 	if (!rc && cifs_sb->prepathlen && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
-		full_path = cifs_build_path_to_root(cifs_sb);
+		full_path = cifs_build_path_to_root(cifs_sb, tcon);
 		if (full_path == NULL) {
 			rc = -ENOMEM;
 			goto mount_fail_check;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0c1efbb..0023146 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -729,12 +729,12 @@ static const struct inode_operations cifs_ipc_inode_ops = {
 	.lookup = cifs_lookup,
 };
 
-char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb)
+char *cifs_build_path_to_root(struct cifs_sb_info *cifs_sb,
+				struct cifsTconInfo *tcon)
 {
 	int pplen = cifs_sb->prepathlen;
 	int dfsplen;
 	char *full_path = NULL;
-	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	/* if no prefix path, simply set path to the root of share to "" */
 	if (pplen == 0) {
@@ -881,7 +881,7 @@ struct inode *cifs_root_iget(struct super_block *sb, unsigned long ino)
 	char *full_path;
 	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 
-	full_path = cifs_build_path_to_root(cifs_sb);
+	full_path = cifs_build_path_to_root(cifs_sb, tcon);
 	if (full_path == NULL)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.7.3.2
