From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/15] cifs: implement recurring workqueue job to prune old tcons
Date: Mon, 20 Sep 2010 16:01:44 -0700
Message-ID: <1285023704-2159-16-git-send-email-jlayton@redhat.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285023704-2159-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Create a workqueue job that cleans out unused tlinks. For now, it uses
a hardcoded expire time of 10 minutes. When it's done, the work rearms
itself. On umount, the work is cancelled before tearing down the tlink
tree.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/connect.c    |   58 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index ae027c2..9ffe484 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -59,5 +59,6 @@ struct cifs_sb_info {
 	char   *mountdata; /* mount options received at mount time */
 #endif
 	struct backing_dev_info bdi;
+	struct delayed_work prune_tlinks;
 };
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c980003..9633e89 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -111,11 +111,13 @@ struct smb_vol {
 	struct nls_table *local_nls;
 };
 
+/* FIXME: should these be tunable? */
 #define TLINK_ERROR_EXPIRE	(1 * HZ)
-
+#define TLINK_IDLE_EXPIRE	(600 * HZ)
 
 static int ipv4_connect(struct TCP_Server_Info *server);
 static int ipv6_connect(struct TCP_Server_Info *server);
+static void cifs_prune_tlinks(struct work_struct *work);
 
 /*
  * cifs tcp session reconnection
@@ -2516,6 +2518,8 @@ convert_delimiter(char *path, char delim)
 static void setup_cifs_sb(struct smb_vol *pvolume_info,
 			  struct cifs_sb_info *cifs_sb)
 {
+	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
+
 	if (pvolume_info->rsize > CIFSMaxBufSize) {
 		cERROR(1, "rsize %d too large, using MaxBufSize",
 			pvolume_info->rsize);
@@ -2921,6 +2925,9 @@ remote_path_check:
 	spin_unlock(&cifs_sb->tlink_tree_lock);
 	radix_tree_preload_end();
 
+	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
+				TLINK_IDLE_EXPIRE);
+
 mount_fail_check:
 	/* on error free sesinfo and tcon struct if needed */
 	if (rc) {
@@ -3112,6 +3119,8 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 	struct tcon_link *tlink[8];
 	unsigned long index = 0;
 
+	cancel_delayed_work_sync(&cifs_sb->prune_tlinks);
+
 	do {
 		spin_lock(&cifs_sb->tlink_tree_lock);
 		ret = radix_tree_gang_lookup(&cifs_sb->tlink_tree,
@@ -3387,3 +3396,50 @@ wait_for_construction:
 
 	return tlink;
 }
+
+/*
+ * periodic workqueue job that scans tcon_tree for a superblock and closes
+ * out tcons.
+ */
+static void
+cifs_prune_tlinks(struct work_struct *work)
+{
+	struct cifs_sb_info *cifs_sb = container_of(work, struct cifs_sb_info,
+						    prune_tlinks.work);
+	struct tcon_link *tlink[8];
+	unsigned long now = jiffies;
+	unsigned long index = 0;
+	int i, ret;
+
+	do {
+		spin_lock(&cifs_sb->tlink_tree_lock);
+		ret = radix_tree_gang_lookup(&cifs_sb->tlink_tree,
+					     (void **)tlink, index,
+					     ARRAY_SIZE(tlink));
+		/* increment index for next pass */
+		if (ret > 0)
+			index = tlink[ret - 1]->tl_index + 1;
+		for (i = 0; i < ret; i++) {
+			if (test_bit(TCON_LINK_MASTER, &tlink[i]->tl_flags) ||
+			    atomic_read(&tlink[i]->tl_count) != 0 ||
+			    time_after(tlink[i]->tl_time + TLINK_IDLE_EXPIRE,
+				       now)) {
+				tlink[i] = NULL;
+				continue;
+			}
+			cifs_get_tlink(tlink[i]);
+			clear_bit(TCON_LINK_IN_TREE, &tlink[i]->tl_flags);
+			radix_tree_delete(&cifs_sb->tlink_tree,
+					  tlink[i]->tl_index);
+		}
+		spin_unlock(&cifs_sb->tlink_tree_lock);
+
+		for (i = 0; i < ret; i++) {
+			if (tlink[i] != NULL)
+				cifs_put_tlink(tlink[i]);
+		}
+	} while (ret != 0);
+
+	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
+				TLINK_IDLE_EXPIRE);
+}
-- 
1.7.2.3
