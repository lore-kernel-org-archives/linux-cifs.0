From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH] fs, cifs: convert tcon_link.tl_count from atomic_t to refcount_t
Date: Fri, 20 Oct 2017 13:41:50 +0300
Message-ID: <1508496110-2292-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, sfrench@samba.org,
        samba-technical@lists.samba.org, peterz@infradead.org,
        keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

atomic_t variables are currently used to implement reference
counters with the following properties:
 - counter is initialized to 1 using atomic_set()
 - a resource is freed upon counter reaching zero
 - once counter reaches zero, its further
   increments aren't allowed
 - counter schema uses basic atomic operations
   (set, inc, inc_not_zero, dec_and_test, etc.)

Such atomic variables should be converted to a newly provided
refcount_t type and API that prevents accidental counter overflows
and underflows. This is important since overflows and underflows
can lead to use-after-free situation and be exploitable.

The variable tcon_link.tl_count is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 fs/cifs/cifsglob.h | 5 +++--
 fs/cifs/connect.c  | 8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index de5b2e1..18963bf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -28,6 +28,7 @@
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <linux/scatterlist.h>
+#include <linux/refcount.h>
 #include <uapi/linux/cifs/cifs_mount.h>
 #include "smb2pdu.h"
 
@@ -974,7 +975,7 @@ struct tcon_link {
 #define TCON_LINK_PENDING	1
 #define TCON_LINK_IN_TREE	2
 	unsigned long		tl_time;
-	atomic_t		tl_count;
+	refcount_t		tl_count;
 	struct cifs_tcon	*tl_tcon;
 };
 
@@ -992,7 +993,7 @@ static inline struct tcon_link *
 cifs_get_tlink(struct tcon_link *tlink)
 {
 	if (tlink && !IS_ERR(tlink))
-		atomic_inc(&tlink->tl_count);
+		refcount_inc(&tlink->tl_count);
 	return tlink;
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0bfc228..f861152 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2868,7 +2868,7 @@ cifs_put_tlink(struct tcon_link *tlink)
 	if (!tlink || IS_ERR(tlink))
 		return;
 
-	if (!atomic_dec_and_test(&tlink->tl_count) ||
+	if (!refcount_dec_and_test(&tlink->tl_count) ||
 	    test_bit(TCON_LINK_IN_TREE, &tlink->tl_flags)) {
 		tlink->tl_time = jiffies;
 		return;
@@ -4328,7 +4328,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 		newtlink->tl_tcon = ERR_PTR(-EACCES);
 		set_bit(TCON_LINK_PENDING, &newtlink->tl_flags);
 		set_bit(TCON_LINK_IN_TREE, &newtlink->tl_flags);
-		cifs_get_tlink(newtlink);
+		refcount_set(&newtlink->tl_count, 1);
 
 		spin_lock(&cifs_sb->tlink_tree_lock);
 		/* was one inserted after previous search? */
@@ -4406,11 +4406,11 @@ cifs_prune_tlinks(struct work_struct *work)
 		tlink = rb_entry(tmp, struct tcon_link, tl_rbnode);
 
 		if (test_bit(TCON_LINK_MASTER, &tlink->tl_flags) ||
-		    atomic_read(&tlink->tl_count) != 0 ||
+		    refcount_read(&tlink->tl_count) != 0 ||
 		    time_after(tlink->tl_time + TLINK_IDLE_EXPIRE, jiffies))
 			continue;
 
-		cifs_get_tlink(tlink);
+		refcount_set(&tlink->tl_count, 1);
 		clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
 		rb_erase(tmp, root);
 
-- 
2.7.4
