From: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/10] fs, kernfs: convert kernfs_node.count from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:08 +0200
Message-ID: <1488451397-3365-2-git-send-email-elena.reshetova@intel.com>
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
 fs/kernfs/dir.c        | 12 +++++-------
 include/linux/kernfs.h |  3 ++-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index db5900aaa..2a07de1 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -489,10 +489,8 @@ static void kernfs_drain(struct kernfs_node *kn)
  */
 void kernfs_get(struct kernfs_node *kn)
 {
-	if (kn) {
-		WARN_ON(!atomic_read(&kn->count));
-		atomic_inc(&kn->count);
-	}
+	if (kn)
+		refcount_inc(&kn->count);
 }
 EXPORT_SYMBOL_GPL(kernfs_get);
 
@@ -507,7 +505,7 @@ void kernfs_put(struct kernfs_node *kn)
 	struct kernfs_node *parent;
 	struct kernfs_root *root;
 
-	if (!kn || !atomic_dec_and_test(&kn->count))
+	if (!kn || !refcount_dec_and_test(&kn->count))
 		return;
 	root = kernfs_root(kn);
  repeat:
@@ -538,7 +536,7 @@ void kernfs_put(struct kernfs_node *kn)
 
 	kn = parent;
 	if (kn) {
-		if (atomic_dec_and_test(&kn->count))
+		if (refcount_dec_and_test(&kn->count))
 			goto repeat;
 	} else {
 		/* just released the root kn, free @root too */
@@ -635,7 +633,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 		goto err_out2;
 	kn->ino = ret;
 
-	atomic_set(&kn->count, 1);
+	refcount_set(&kn->count, 1);
 	atomic_set(&kn->active, KN_DEACTIVATED_BIAS);
 	RB_CLEAR_NODE(&kn->rb);
 
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index a9b11b8..baabbaf 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -15,6 +15,7 @@
 #include <linux/lockdep.h>
 #include <linux/rbtree.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/wait.h>
 
 struct file;
@@ -105,7 +106,7 @@ struct kernfs_elem_attr {
  * active reference.
  */
 struct kernfs_node {
-	atomic_t		count;
+	refcount_t		count;
 	atomic_t		active;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
