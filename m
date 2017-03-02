From: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/10] fs, fsnotify: convert fsnotify_group.refcnt from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:15 +0200
Message-ID: <1488451397-3365-9-git-send-email-elena.reshetova@intel.com>
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
 fs/notify/group.c                | 6 +++---
 include/linux/fsnotify_backend.h | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index fbe3cbe..81356c1 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -98,7 +98,7 @@ void fsnotify_destroy_group(struct fsnotify_group *group)
  */
 void fsnotify_get_group(struct fsnotify_group *group)
 {
-	atomic_inc(&group->refcnt);
+	refcount_inc(&group->refcnt);
 }
 
 /*
@@ -106,7 +106,7 @@ void fsnotify_get_group(struct fsnotify_group *group)
  */
 void fsnotify_put_group(struct fsnotify_group *group)
 {
-	if (atomic_dec_and_test(&group->refcnt))
+	if (refcount_dec_and_test(&group->refcnt))
 		fsnotify_final_destroy_group(group);
 }
 
@@ -122,7 +122,7 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 		return ERR_PTR(-ENOMEM);
 
 	/* set to 0 when there a no external references to this group */
-	atomic_set(&group->refcnt, 1);
+	refcount_set(&group->refcnt, 1);
 	atomic_set(&group->num_marks, 0);
 
 	spin_lock_init(&group->notification_lock);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e6e689b..1f7aa16 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
+#include <linux/refcount.h>
 
 /*
  * IN_* from inotfy.h lines up EXACTLY with FS_*, this is so we can easily
@@ -131,7 +132,7 @@ struct fsnotify_group {
 	 * inotify_init() and the refcnt will hit 0 only when that fd has been
 	 * closed.
 	 */
-	atomic_t refcnt;		/* things with interest in this group */
+	refcount_t refcnt;		/* things with interest in this group */
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
