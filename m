From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: store pointer to master tlink in superblock
Date: Thu, 28 Oct 2010 07:33:38 -0400
Message-ID: <1288265619-20616-2-git-send-email-jlayton@redhat.com>
References: <1288265619-20616-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288265619-20616-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Instead of keeping a tag on the master tlink in the tree, just keep a
pointer to the master in the superblock. That eliminates the need for
using the radix tree to look up a tagged entry.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    2 +-
 fs/cifs/connect.c    |   18 +++---------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 525ba59..79576da 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -43,8 +43,8 @@
 
 struct cifs_sb_info {
 	struct radix_tree_root tlink_tree;
-#define CIFS_TLINK_MASTER_TAG		0	/* is "master" (mount) tcon */
 	spinlock_t tlink_tree_lock;
+	struct tcon_link *master_tlink;
 	struct nls_table *local_nls;
 	unsigned int rsize;
 	unsigned int wsize;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 469c3dd..364eb96 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2917,11 +2917,11 @@ remote_path_check:
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
 	radix_tree_insert(&cifs_sb->tlink_tree, pSesInfo->linux_uid, tlink);
-	radix_tree_tag_set(&cifs_sb->tlink_tree, pSesInfo->linux_uid,
-			   CIFS_TLINK_MASTER_TAG);
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 	radix_tree_preload_end();
 
+	cifs_sb->master_tlink = tlink;
+
 	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
 				TLINK_IDLE_EXPIRE);
 
@@ -3275,19 +3275,7 @@ out:
 static struct tcon_link *
 cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
 {
-	struct tcon_link *tlink;
-	unsigned int ret;
-
-	spin_lock(&cifs_sb->tlink_tree_lock);
-	ret = radix_tree_gang_lookup_tag(&cifs_sb->tlink_tree, (void **)&tlink,
-					0, 1, CIFS_TLINK_MASTER_TAG);
-	spin_unlock(&cifs_sb->tlink_tree_lock);
-
-	/* the master tcon should always be present */
-	if (ret == 0)
-		BUG();
-
-	return tlink;
+	return cifs_sb->master_tlink;
 }
 
 struct cifsTconInfo *
-- 
1.7.2.3
