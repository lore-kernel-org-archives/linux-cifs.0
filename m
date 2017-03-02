From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 03/10] fs, proc: convert proc_dir_entry.count from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:10 +0200
Message-ID: <1488451397-3365-4-git-send-email-elena.reshetova@intel.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
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
 fs/proc/generic.c  | 4 ++--
 fs/proc/internal.h | 5 +++--
 fs/proc/root.c     | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index ee27feb..0850766 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -388,7 +388,7 @@ static struct proc_dir_entry *__proc_create(struct proc_dir_entry **parent,
 	ent->mode = mode;
 	ent->nlink = nlink;
 	ent->subdir = RB_ROOT;
-	atomic_set(&ent->count, 1);
+	refcount_set(&ent->count, 1);
 	spin_lock_init(&ent->pde_unload_lock);
 	INIT_LIST_HEAD(&ent->pde_openers);
 	proc_set_user(ent, (*parent)->uid, (*parent)->gid);
@@ -540,7 +540,7 @@ static void free_proc_entry(struct proc_dir_entry *de)
 
 void pde_put(struct proc_dir_entry *pde)
 {
-	if (atomic_dec_and_test(&pde->count))
+	if (refcount_dec_and_test(&pde->count))
 		free_proc_entry(pde);
 }
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index e93cdc6..7b5fa12 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -13,6 +13,7 @@
 #include <linux/proc_ns.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/binfmts.h>
 
 struct ctl_table_header;
@@ -41,7 +42,7 @@ struct proc_dir_entry {
 	struct rb_root subdir;
 	struct rb_node subdir_node;
 	void *data;
-	atomic_t count;		/* use count */
+	refcount_t count;	/* use count */
 	atomic_t in_use;	/* number of callers into module in progress; */
 			/* negative -> it's going away RSN */
 	struct completion *pde_unload_completion;
@@ -175,7 +176,7 @@ extern int proc_readdir_de(struct proc_dir_entry *, struct file *, struct dir_co
 
 static inline struct proc_dir_entry *pde_get(struct proc_dir_entry *pde)
 {
-	atomic_inc(&pde->count);
+	refcount_inc(&pde->count);
 	return pde;
 }
 extern void pde_put(struct proc_dir_entry *);
diff --git a/fs/proc/root.c b/fs/proc/root.c
index fb1955c..882bcb5 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -204,7 +204,7 @@ struct proc_dir_entry proc_root = {
 	.namelen	= 5, 
 	.mode		= S_IFDIR | S_IRUGO | S_IXUGO, 
 	.nlink		= 2, 
-	.count		= ATOMIC_INIT(1),
+	.count		= REFCOUNT_INIT(1),
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
-- 
2.7.4
