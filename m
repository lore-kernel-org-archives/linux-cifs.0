From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/15] cifs: temporarily rename cifs_sb->tcon to ptcon to catch stragglers
Date: Mon, 20 Sep 2010 16:01:34 -0700
Message-ID: <1285023704-2159-6-git-send-email-jlayton@redhat.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    2 +-
 fs/cifs/cifsglob.h   |    2 +-
 fs/cifs/connect.c    |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 7fde529..ba0afd3 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -39,7 +39,7 @@
 #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
 
 struct cifs_sb_info {
-	struct cifsTconInfo *tcon;	/* primary mount */
+	struct cifsTconInfo *ptcon;	/* primary mount */
 	struct list_head nested_tcon_q;
 	struct nls_table *local_nls;
 	unsigned int rsize;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0bc8677..2f8d279 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -445,7 +445,7 @@ CIFS_SB(struct super_block *sb)
 static inline struct cifsTconInfo *
 cifs_sb_tcon(struct cifs_sb_info *cifs_sb)
 {
-	return cifs_sb->tcon;
+	return cifs_sb->ptcon;
 }
 
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 533ff75..fd9f61f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2749,7 +2749,7 @@ try_mount_again:
 		goto remote_path_check;
 	}
 
-	cifs_sb->tcon = tcon;
+	cifs_sb->ptcon = tcon;
 
 	/* do not care if following two calls succeed - informational */
 	if (!tcon->ipc) {
@@ -3051,7 +3051,7 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	if (cifs_sb_tcon(cifs_sb))
 		cifs_put_tcon(cifs_sb_tcon(cifs_sb));
 
-	cifs_sb->tcon = NULL;
+	cifs_sb->ptcon = NULL;
 	tmp = cifs_sb->prepath;
 	cifs_sb->prepathlen = 0;
 	cifs_sb->prepath = NULL;
-- 
1.7.2.3
