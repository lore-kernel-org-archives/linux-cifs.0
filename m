From: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/10] fs, hfs: convert hfs_bnode.refcnt from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:12 +0200
Message-ID: <1488451397-3365-6-git-send-email-elena.reshetova@intel.com>
References: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org,
        viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
        eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org,
        john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org,
        Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
        David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488451397-3365-1-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/hfs/bnode.c          | 14 +++++++-------
 fs/hfs/btree.c          |  4 ++--
 fs/hfs/btree.h          |  3 ++-
 fs/hfs/inode.c          |  4 ++--
 fs/hfsplus/bnode.c      | 14 +++++++-------
 fs/hfsplus/btree.c      |  4 ++--
 fs/hfsplus/hfsplus_fs.h |  3 ++-
 fs/hfsplus/inode.c      |  4 ++--
 8 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index d77d844..7b822e4 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -257,7 +257,7 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 	node->tree = tree;
 	node->this = cnid;
 	set_bit(HFS_BNODE_NEW, &node->flags);
-	atomic_set(&node->refcnt, 1);
+	refcount_set(&node->refcnt, 1);
 	hfs_dbg(BNODE_REFS, "new_node(%d:%d): 1\n",
 		node->tree->cnid, node->this);
 	init_waitqueue_head(&node->lock_wq);
@@ -302,7 +302,7 @@ void hfs_bnode_unhash(struct hfs_bnode *node)
 	struct hfs_bnode **p;
 
 	hfs_dbg(BNODE_REFS, "remove_node(%d:%d): %d\n",
-		node->tree->cnid, node->this, atomic_read(&node->refcnt));
+		node->tree->cnid, node->this, refcount_read(&node->refcnt));
 	for (p = &node->tree->node_hash[hfs_bnode_hash(node->this)];
 	     *p && *p != node; p = &(*p)->next_hash)
 		;
@@ -446,10 +446,10 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 void hfs_bnode_get(struct hfs_bnode *node)
 {
 	if (node) {
-		atomic_inc(&node->refcnt);
+		refcount_inc(&node->refcnt);
 		hfs_dbg(BNODE_REFS, "get_node(%d:%d): %d\n",
 			node->tree->cnid, node->this,
-			atomic_read(&node->refcnt));
+			refcount_read(&node->refcnt));
 	}
 }
 
@@ -462,9 +462,9 @@ void hfs_bnode_put(struct hfs_bnode *node)
 
 		hfs_dbg(BNODE_REFS, "put_node(%d:%d): %d\n",
 			node->tree->cnid, node->this,
-			atomic_read(&node->refcnt));
-		BUG_ON(!atomic_read(&node->refcnt));
-		if (!atomic_dec_and_lock(&node->refcnt, &tree->hash_lock))
+			refcount_read(&node->refcnt));
+		BUG_ON(!refcount_read(&node->refcnt));
+		if (!refcount_dec_and_lock(&node->refcnt, &tree->hash_lock))
 			return;
 		for (i = 0; i < tree->pages_per_bnode; i++) {
 			if (!node->page[i])
diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 37cdd95..5758e5e 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -144,10 +144,10 @@ void hfs_btree_close(struct hfs_btree *tree)
 	for (i = 0; i < NODE_HASH_SIZE; i++) {
 		while ((node = tree->node_hash[i])) {
 			tree->node_hash[i] = node->next_hash;
-			if (atomic_read(&node->refcnt))
+			if (refcount_read(&node->refcnt))
 				pr_err("node %d:%d still has %d user(s)!\n",
 				       node->tree->cnid, node->this,
-				       atomic_read(&node->refcnt));
+				       refcount_read(&node->refcnt));
 			hfs_bnode_free(node);
 			tree->node_hash_cnt--;
 		}
diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
index f6bd266..99b5fd3 100644
--- a/fs/hfs/btree.h
+++ b/fs/hfs/btree.h
@@ -6,6 +6,7 @@
  * (C) 2003 Ardis Technologies <roman-2GSx/RAVpKG1Z/+hSey0Gg@public.gmane.org>
  */
 
+#include <linux/refcount.h>
 #include "hfs_fs.h"
 
 typedef int (*btree_keycmp)(const btree_key *, const btree_key *);
@@ -57,7 +58,7 @@ struct hfs_bnode {
 	struct hfs_bnode *next_hash;
 	unsigned long flags;
 	wait_queue_head_t lock_wq;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	unsigned int page_offset;
 	struct page *page[0];
 };
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index f776acf..8ac61e4 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -98,7 +98,7 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 		node = hfs_bnode_findhash(tree, nidx);
 		if (!node)
 			;
-		else if (atomic_read(&node->refcnt))
+		else if (refcount_read(&node->refcnt))
 			res = 0;
 		if (res && node) {
 			hfs_bnode_unhash(node);
@@ -113,7 +113,7 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 			node = hfs_bnode_findhash(tree, nidx++);
 			if (!node)
 				continue;
-			if (atomic_read(&node->refcnt)) {
+			if (refcount_read(&node->refcnt)) {
 				res = 0;
 				break;
 			}
diff --git a/fs/hfsplus/bnode.c b/fs/hfsplus/bnode.c
index ce014ce..9abaf14 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -422,7 +422,7 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 	node->tree = tree;
 	node->this = cnid;
 	set_bit(HFS_BNODE_NEW, &node->flags);
-	atomic_set(&node->refcnt, 1);
+	refcount_set(&node->refcnt, 1);
 	hfs_dbg(BNODE_REFS, "new_node(%d:%d): 1\n",
 		node->tree->cnid, node->this);
 	init_waitqueue_head(&node->lock_wq);
@@ -468,7 +468,7 @@ void hfs_bnode_unhash(struct hfs_bnode *node)
 	struct hfs_bnode **p;
 
 	hfs_dbg(BNODE_REFS, "remove_node(%d:%d): %d\n",
-		node->tree->cnid, node->this, atomic_read(&node->refcnt));
+		node->tree->cnid, node->this, refcount_read(&node->refcnt));
 	for (p = &node->tree->node_hash[hfs_bnode_hash(node->this)];
 	     *p && *p != node; p = &(*p)->next_hash)
 		;
@@ -614,10 +614,10 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 void hfs_bnode_get(struct hfs_bnode *node)
 {
 	if (node) {
-		atomic_inc(&node->refcnt);
+		refcount_inc(&node->refcnt);
 		hfs_dbg(BNODE_REFS, "get_node(%d:%d): %d\n",
 			node->tree->cnid, node->this,
-			atomic_read(&node->refcnt));
+			refcount_read(&node->refcnt));
 	}
 }
 
@@ -630,9 +630,9 @@ void hfs_bnode_put(struct hfs_bnode *node)
 
 		hfs_dbg(BNODE_REFS, "put_node(%d:%d): %d\n",
 			node->tree->cnid, node->this,
-			atomic_read(&node->refcnt));
-		BUG_ON(!atomic_read(&node->refcnt));
-		if (!atomic_dec_and_lock(&node->refcnt, &tree->hash_lock))
+			refcount_read(&node->refcnt));
+		BUG_ON(!refcount_read(&node->refcnt));
+		if (!refcount_dec_and_lock(&node->refcnt, &tree->hash_lock))
 			return;
 		for (i = 0; i < tree->pages_per_bnode; i++) {
 			if (!node->page[i])
diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index d9d1a36..0823dca 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -265,11 +265,11 @@ void hfs_btree_close(struct hfs_btree *tree)
 	for (i = 0; i < NODE_HASH_SIZE; i++) {
 		while ((node = tree->node_hash[i])) {
 			tree->node_hash[i] = node->next_hash;
-			if (atomic_read(&node->refcnt))
+			if (refcount_read(&node->refcnt))
 				pr_crit("node %d:%d "
 						"still has %d user(s)!\n",
 					node->tree->cnid, node->this,
-					atomic_read(&node->refcnt));
+					refcount_read(&node->refcnt));
 			hfs_bnode_free(node);
 			tree->node_hash_cnt--;
 		}
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index a3f03b2..a895715 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
+#include <linux/refcount.h>
 #include "hfsplus_raw.h"
 
 #define DBG_BNODE_REFS	0x00000001
@@ -115,7 +116,7 @@ struct hfs_bnode {
 	struct hfs_bnode *next_hash;
 	unsigned long flags;
 	wait_queue_head_t lock_wq;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	unsigned int page_offset;
 	struct page *page[0];
 };
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 2e796f8..d1fbb4d 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -94,7 +94,7 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 		node = hfs_bnode_findhash(tree, nidx);
 		if (!node)
 			;
-		else if (atomic_read(&node->refcnt))
+		else if (refcount_read(&node->refcnt))
 			res = 0;
 		if (res && node) {
 			hfs_bnode_unhash(node);
@@ -110,7 +110,7 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 			node = hfs_bnode_findhash(tree, nidx++);
 			if (!node)
 				continue;
-			if (atomic_read(&node->refcnt)) {
+			if (refcount_read(&node->refcnt)) {
 				res = 0;
 				break;
 			}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
