From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 06/15] cifs: temporarily rename cifs_sb->tcon to ptcon to catch stragglers
Date: Fri, 20 Aug 2010 15:32:02 -0400
Message-ID: <1282332731-17444-7-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifs_fs_sb.h |    2 +-
 fs/cifs/cifsglob.h   |    2 +-
 fs/cifs/connect.c    |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 9e77145..6302a06 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -38,7 +38,7 @@
 #define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
 
 struct cifs_sb_info {
-	struct cifsTconInfo *tcon;	/* primary mount */
+	struct cifsTconInfo *ptcon;	/* primary mount */
 	struct list_head nested_tcon_q;
 	struct nls_table *local_nls;
 	unsigned int rsize;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5e142aa..9aad04e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -414,7 +414,7 @@ CIFS_SB(struct super_block *sb)
 static inline struct cifsTconInfo *
 cifs_sb_tcon(struct cifs_sb_info *cifs_sb)
 {
-	return cifs_sb->tcon;
+	return cifs_sb->ptcon;
 }
 
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index be6b7a2..6998e50 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2655,7 +2655,7 @@ try_mount_again:
 		goto remote_path_check;
 	}
 
-	cifs_sb->tcon = tcon;
+	cifs_sb->ptcon = tcon;
 
 	/* do not care if following two calls succeed - informational */
 	if (!tcon->ipc) {
@@ -2957,7 +2957,7 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	if (cifs_sb_tcon(cifs_sb))
 		cifs_put_tcon(cifs_sb_tcon(cifs_sb));
 
-	cifs_sb->tcon = NULL;
+	cifs_sb->ptcon = NULL;
 	tmp = cifs_sb->prepath;
 	cifs_sb->prepathlen = 0;
 	cifs_sb->prepath = NULL;
-- 
1.7.2.1

