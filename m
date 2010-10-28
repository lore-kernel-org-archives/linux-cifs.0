From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: convert tlink_tree to a rbtree
Date: Thu, 28 Oct 2010 07:33:39 -0400
Message-ID: <1288265619-20616-3-git-send-email-jlayton@redhat.com>
References: <1288265619-20616-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288265619-20616-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Radix trees are ideal when you want to track a bunch of pointers and
can't embed a tracking structure within the target of those pointers.
The tradeoff is an increase in memory, particularly if the tree is
sparse.

In CIFS, we use the tlink_tree to track tcon_link structs. A tcon_link
can never be in more than one tlink_tree, so there's no impediment to
using a rb_tree here instead of a radix tree.

Convert the new multiuser mount code to use a rb_tree instead. This
should reduce the memory required to manage the tlink_tree.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    4 +-
 fs/cifs/cifsfs.c     |    2 +-
 fs/cifs/cifsglob.h   |    3 +-
 fs/cifs/connect.c    |  177 +++++++++++++++++++++++++++-----------------------
 4 files changed, 101 insertions(+), 85 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 79576da..e9a393c 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -15,7 +15,7 @@
  *   the GNU Lesser General Public License for more details.
  *
  */
-#include <linux/radix-tree.h>
+#include <linux/rbtree.h>
 
 #ifndef _CIFS_FS_SB_H
 #define _CIFS_FS_SB_H
@@ -42,7 +42,7 @@
 #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
 
 struct cifs_sb_info {
-	struct radix_tree_root tlink_tree;
+	struct rb_root tlink_tree;
 	spinlock_t tlink_tree_lock;
 	struct tcon_link *master_tlink;
 	struct nls_table *local_nls;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 17baeab..c5f136c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -116,7 +116,7 @@ cifs_read_super(struct super_block *sb, void *data,
 		return -ENOMEM;
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
-	INIT_RADIX_TREE(&cifs_sb->tlink_tree, GFP_KERNEL);
+	cifs_sb->tlink_tree = RB_ROOT;
 
 	rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
 	if (rc) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ab94982..4434d5d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -338,7 +338,8 @@ struct cifsTconInfo {
  * "get" on the container.
  */
 struct tcon_link {
-	unsigned long		tl_index;
+	struct rb_node		tl_rbnode;
+	uid_t			tl_uid;
 	unsigned long		tl_flags;
 #define TCON_LINK_MASTER	0
 #define TCON_LINK_PENDING	1
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 364eb96..f02b38b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -116,6 +116,7 @@ struct smb_vol {
 
 static int ipv4_connect(struct TCP_Server_Info *server);
 static int ipv6_connect(struct TCP_Server_Info *server);
+static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
 
 /*
@@ -2903,24 +2904,16 @@ remote_path_check:
 		goto mount_fail_check;
 	}
 
-	tlink->tl_index = pSesInfo->linux_uid;
+	tlink->tl_uid = pSesInfo->linux_uid;
 	tlink->tl_tcon = tcon;
 	tlink->tl_time = jiffies;
 	set_bit(TCON_LINK_MASTER, &tlink->tl_flags);
 	set_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
 
-	rc = radix_tree_preload(GFP_KERNEL);
-	if (rc == -ENOMEM) {
-		kfree(tlink);
-		goto mount_fail_check;
-	}
-
+	cifs_sb->master_tlink = tlink;
 	spin_lock(&cifs_sb->tlink_tree_lock);
-	radix_tree_insert(&cifs_sb->tlink_tree, pSesInfo->linux_uid, tlink);
+	tlink_rb_insert(&cifs_sb->tlink_tree, tlink);
 	spin_unlock(&cifs_sb->tlink_tree_lock);
-	radix_tree_preload_end();
-
-	cifs_sb->master_tlink = tlink;
 
 	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
 				TLINK_IDLE_EXPIRE);
@@ -3110,32 +3103,25 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 int
 cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
 {
-	int i, ret;
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct rb_node *node;
+	struct tcon_link *tlink;
 	char *tmp;
-	struct tcon_link *tlink[8];
-	unsigned long index = 0;
 
 	cancel_delayed_work_sync(&cifs_sb->prune_tlinks);
 
-	do {
-		spin_lock(&cifs_sb->tlink_tree_lock);
-		ret = radix_tree_gang_lookup(&cifs_sb->tlink_tree,
-					     (void **)tlink, index,
-					     ARRAY_SIZE(tlink));
-		/* increment index for next pass */
-		if (ret > 0)
-			index = tlink[ret - 1]->tl_index + 1;
-		for (i = 0; i < ret; i++) {
-			cifs_get_tlink(tlink[i]);
-			clear_bit(TCON_LINK_IN_TREE, &tlink[i]->tl_flags);
-			radix_tree_delete(&cifs_sb->tlink_tree,
-							tlink[i]->tl_index);
-		}
-		spin_unlock(&cifs_sb->tlink_tree_lock);
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	while ((node = rb_first(root))) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		cifs_get_tlink(tlink);
+		clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
+		rb_erase(node, root);
 
-		for (i = 0; i < ret; i++)
-			cifs_put_tlink(tlink[i]);
-	} while (ret != 0);
+		spin_unlock(&cifs_sb->tlink_tree_lock);
+		cifs_put_tlink(tlink);
+		spin_lock(&cifs_sb->tlink_tree_lock);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
 
 	tmp = cifs_sb->prepath;
 	cifs_sb->prepathlen = 0;
@@ -3291,6 +3277,47 @@ cifs_sb_tcon_pending_wait(void *unused)
 	return signal_pending(current) ? -ERESTARTSYS : 0;
 }
 
+/* find and return a tlink with given uid */
+static struct tcon_link *
+tlink_rb_search(struct rb_root *root, uid_t uid)
+{
+	struct rb_node *node = root->rb_node;
+	struct tcon_link *tlink;
+
+	while (node) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+
+		if (tlink->tl_uid > uid)
+			node = node->rb_left;
+		else if (tlink->tl_uid < uid)
+			node = node->rb_right;
+		else
+			return tlink;
+	}
+	return NULL;
+}
+
+/* insert a tcon_link into the tree */
+static void
+tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct tcon_link *tlink;
+
+	while (*new) {
+		tlink = rb_entry(*new, struct tcon_link, tl_rbnode);
+		parent = *new;
+
+		if (tlink->tl_uid > new_tlink->tl_uid)
+			new = &((*new)->rb_left);
+		else
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&new_tlink->tl_rbnode, parent, new);
+	rb_insert_color(&new_tlink->tl_rbnode, root);
+}
+
 /*
  * Find or construct an appropriate tcon given a cifs_sb and the fsuid of the
  * current task.
@@ -3311,14 +3338,14 @@ struct tcon_link *
 cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 {
 	int ret;
-	unsigned long fsuid = (unsigned long) current_fsuid();
+	uid_t fsuid = current_fsuid();
 	struct tcon_link *tlink, *newtlink;
 
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		return cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
 
 	spin_lock(&cifs_sb->tlink_tree_lock);
-	tlink = radix_tree_lookup(&cifs_sb->tlink_tree, fsuid);
+	tlink = tlink_rb_search(&cifs_sb->tlink_tree, fsuid);
 	if (tlink)
 		cifs_get_tlink(tlink);
 	spin_unlock(&cifs_sb->tlink_tree_lock);
@@ -3327,36 +3354,24 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 		newtlink = kzalloc(sizeof(*tlink), GFP_KERNEL);
 		if (newtlink == NULL)
 			return ERR_PTR(-ENOMEM);
-		newtlink->tl_index = fsuid;
+		newtlink->tl_uid = fsuid;
 		newtlink->tl_tcon = ERR_PTR(-EACCES);
 		set_bit(TCON_LINK_PENDING, &newtlink->tl_flags);
 		set_bit(TCON_LINK_IN_TREE, &newtlink->tl_flags);
 		cifs_get_tlink(newtlink);
 
-		ret = radix_tree_preload(GFP_KERNEL);
-		if (ret != 0) {
-			kfree(newtlink);
-			return ERR_PTR(ret);
-		}
-
 		spin_lock(&cifs_sb->tlink_tree_lock);
 		/* was one inserted after previous search? */
-		tlink = radix_tree_lookup(&cifs_sb->tlink_tree, fsuid);
+		tlink = tlink_rb_search(&cifs_sb->tlink_tree, fsuid);
 		if (tlink) {
 			cifs_get_tlink(tlink);
 			spin_unlock(&cifs_sb->tlink_tree_lock);
-			radix_tree_preload_end();
 			kfree(newtlink);
 			goto wait_for_construction;
 		}
-		ret = radix_tree_insert(&cifs_sb->tlink_tree, fsuid, newtlink);
-		spin_unlock(&cifs_sb->tlink_tree_lock);
-		radix_tree_preload_end();
-		if (ret) {
-			kfree(newtlink);
-			return ERR_PTR(ret);
-		}
 		tlink = newtlink;
+		tlink_rb_insert(&cifs_sb->tlink_tree, tlink);
+		spin_unlock(&cifs_sb->tlink_tree_lock);
 	} else {
 wait_for_construction:
 		ret = wait_on_bit(&tlink->tl_flags, TCON_LINK_PENDING,
@@ -3402,39 +3417,39 @@ cifs_prune_tlinks(struct work_struct *work)
 {
 	struct cifs_sb_info *cifs_sb = container_of(work, struct cifs_sb_info,
 						    prune_tlinks.work);
-	struct tcon_link *tlink[8];
-	unsigned long now = jiffies;
-	unsigned long index = 0;
-	int i, ret;
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct rb_node *node = rb_first(root);
+	struct rb_node *tmp;
+	struct tcon_link *tlink;
 
-	do {
-		spin_lock(&cifs_sb->tlink_tree_lock);
-		ret = radix_tree_gang_lookup(&cifs_sb->tlink_tree,
-					     (void **)tlink, index,
-					     ARRAY_SIZE(tlink));
-		/* increment index for next pass */
-		if (ret > 0)
-			index = tlink[ret - 1]->tl_index + 1;
-		for (i = 0; i < ret; i++) {
-			if (test_bit(TCON_LINK_MASTER, &tlink[i]->tl_flags) ||
-			    atomic_read(&tlink[i]->tl_count) != 0 ||
-			    time_after(tlink[i]->tl_time + TLINK_IDLE_EXPIRE,
-				       now)) {
-				tlink[i] = NULL;
-				continue;
-			}
-			cifs_get_tlink(tlink[i]);
-			clear_bit(TCON_LINK_IN_TREE, &tlink[i]->tl_flags);
-			radix_tree_delete(&cifs_sb->tlink_tree,
-					  tlink[i]->tl_index);
-		}
-		spin_unlock(&cifs_sb->tlink_tree_lock);
+	/*
+	 * Because we drop the spinlock in the loop in order to put the tlink
+	 * it's not guarded against removal of links from the tree. The only
+	 * places that remove entries from the tree are this function and
+	 * umounts. Because this function is non-reentrant and is canceled
+	 * before umount can proceed, this is safe.
+	 */
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	node = rb_first(root);
+	while (node != NULL) {
+		tmp = node;
+		node = rb_next(tmp);
+		tlink = rb_entry(tmp, struct tcon_link, tl_rbnode);
+
+		if (test_bit(TCON_LINK_MASTER, &tlink->tl_flags) ||
+		    atomic_read(&tlink->tl_count) != 0 ||
+		    time_after(tlink->tl_time + TLINK_IDLE_EXPIRE, jiffies))
+			continue;
 
-		for (i = 0; i < ret; i++) {
-			if (tlink[i] != NULL)
-				cifs_put_tlink(tlink[i]);
-		}
-	} while (ret != 0);
+		cifs_get_tlink(tlink);
+		clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
+		rb_erase(tmp, root);
+
+		spin_unlock(&cifs_sb->tlink_tree_lock);
+		cifs_put_tlink(tlink);
+		spin_lock(&cifs_sb->tlink_tree_lock);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
 
 	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
 				TLINK_IDLE_EXPIRE);
-- 
1.7.2.3
