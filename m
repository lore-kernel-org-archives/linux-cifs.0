From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 09/10] fs, fsnotify: convert fsnotify_mark.refcnt from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:16 +0200
Message-ID: <1488451397-3365-10-git-send-email-elena.reshetova@intel.com>
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
 fs/notify/inotify/inotify_user.c | 4 ++--
 fs/notify/mark.c                 | 6 +++---
 include/linux/fsnotify_backend.h | 2 +-
 kernel/audit_tree.c              | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 1cf41c6..c878e3c 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -376,7 +376,7 @@ static struct inotify_inode_mark *inotify_idr_find_locked(struct fsnotify_group
 
 		fsnotify_get_mark(fsn_mark);
 		/* One ref for being in the idr, one ref we just took */
-		BUG_ON(atomic_read(&fsn_mark->refcnt) < 2);
+		BUG_ON(refcount_read(&fsn_mark->refcnt) < 2);
 	}
 
 	return i_mark;
@@ -465,7 +465,7 @@ static void inotify_remove_from_idr(struct fsnotify_group *group,
 	 * one ref held by the caller trying to kill us
 	 * one ref grabbed by inotify_idr_find
 	 */
-	if (unlikely(atomic_read(&i_mark->fsn_mark.refcnt) < 3)) {
+	if (unlikely(refcount_read(&i_mark->fsn_mark.refcnt) < 3)) {
 		printk(KERN_ERR "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
 			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
 			i_mark->fsn_mark.group, i_mark->fsn_mark.inode);
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 6043306..5dbe3a0 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -102,12 +102,12 @@ static DECLARE_DELAYED_WORK(reaper_work, fsnotify_mark_destroy_workfn);
 
 void fsnotify_get_mark(struct fsnotify_mark *mark)
 {
-	atomic_inc(&mark->refcnt);
+	refcount_inc(&mark->refcnt);
 }
 
 void fsnotify_put_mark(struct fsnotify_mark *mark)
 {
-	if (atomic_dec_and_test(&mark->refcnt)) {
+	if (refcount_dec_and_test(&mark->refcnt)) {
 		if (mark->group)
 			fsnotify_put_group(mark->group);
 		mark->free_mark(mark);
@@ -518,7 +518,7 @@ void fsnotify_init_mark(struct fsnotify_mark *mark,
 {
 	memset(mark, 0, sizeof(*mark));
 	spin_lock_init(&mark->lock);
-	atomic_set(&mark->refcnt, 1);
+	refcount_set(&mark->refcnt, 1);
 	mark->free_mark = free_mark;
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 1f7aa16..d874f26 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -214,7 +214,7 @@ struct fsnotify_mark {
 	__u32 mask;
 	/* We hold one for presence in g_list. Also one ref for each 'thing'
 	 * in kernel that found and may be using this mark. */
-	atomic_t refcnt;
+	refcount_t refcnt;
 	/* Group this mark is for. Set on mark creation, stable until last ref
 	 * is dropped */
 	struct fsnotify_group *group;
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 7b44195..9f64663 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -973,7 +973,7 @@ static void audit_tree_freeing_mark(struct fsnotify_mark *entry, struct fsnotify
 	 * We are guaranteed to have at least one reference to the mark from
 	 * either the inode or the caller of fsnotify_destroy_mark().
 	 */
-	BUG_ON(atomic_read(&entry->refcnt) < 1);
+	BUG_ON(refcount_read(&entry->refcnt) < 1);
 }
 
 static const struct fsnotify_ops audit_tree_ops = {
-- 
2.7.4
