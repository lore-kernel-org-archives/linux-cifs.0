From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 04/10] fs, nilfs: convert nilfs_root.count from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:11 +0200
Message-ID: <1488451397-3365-5-git-send-email-elena.reshetova@intel.com>
References: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com, sfrench@samba.org,
        eparis@parisplace.org, konishi.ryusuke@lab.ntt.co.jp,
        john@johnmccutchan.com, rlove@rlove.org, paul@paul-moore.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/nilfs2/the_nilfs.c | 8 ++++----
 fs/nilfs2/the_nilfs.h | 5 +++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 2dd75bf..afebb50 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -737,7 +737,7 @@ struct nilfs_root *nilfs_lookup_root(struct the_nilfs *nilfs, __u64 cno)
 		} else if (cno > root->cno) {
 			n = n->rb_right;
 		} else {
-			atomic_inc(&root->count);
+			refcount_inc(&root->count);
 			spin_unlock(&nilfs->ns_cptree_lock);
 			return root;
 		}
@@ -776,7 +776,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 		} else if (cno > root->cno) {
 			p = &(*p)->rb_right;
 		} else {
-			atomic_inc(&root->count);
+			refcount_inc(&root->count);
 			spin_unlock(&nilfs->ns_cptree_lock);
 			kfree(new);
 			return root;
@@ -786,7 +786,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 	new->cno = cno;
 	new->ifile = NULL;
 	new->nilfs = nilfs;
-	atomic_set(&new->count, 1);
+	refcount_set(&new->count, 1);
 	atomic64_set(&new->inodes_count, 0);
 	atomic64_set(&new->blocks_count, 0);
 
@@ -806,7 +806,7 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 
 void nilfs_put_root(struct nilfs_root *root)
 {
-	if (atomic_dec_and_test(&root->count)) {
+	if (refcount_dec_and_test(&root->count)) {
 		struct the_nilfs *nilfs = root->nilfs;
 
 		nilfs_sysfs_delete_snapshot_group(root);
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index b305c6f..883d732 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 struct nilfs_sc_info;
 struct nilfs_sysfs_dev_subgroups;
@@ -246,7 +247,7 @@ struct nilfs_root {
 	__u64 cno;
 	struct rb_node rb_node;
 
-	atomic_t count;
+	refcount_t count;
 	struct the_nilfs *nilfs;
 	struct inode *ifile;
 
@@ -299,7 +300,7 @@ void nilfs_swap_super_block(struct the_nilfs *);
 
 static inline void nilfs_get_root(struct nilfs_root *root)
 {
-	atomic_inc(&root->count);
+	refcount_inc(&root->count);
 }
 
 static inline int nilfs_valid_fs(struct the_nilfs *nilfs)
-- 
2.7.4
