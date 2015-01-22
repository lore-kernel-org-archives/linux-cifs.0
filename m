From: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: [PATCH v3 13/13] locks: update comments that refer to inode->i_flock
Date: Thu, 22 Jan 2015 09:27:57 -0500
Message-ID: <1421936877-27529-14-git-send-email-jeff.layton@primarydata.com>
References: <1421936877-27529-1-git-send-email-jeff.layton@primarydata.com>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421936877-27529-1-git-send-email-jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/locks.c         |  2 +-
 include/linux/fs.h | 19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 2fc36b3772a0..4d0d41163a50 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2212,7 +2212,7 @@ again:
 	 */
 	/*
 	 * we need that spin_lock here - it prevents reordering between
-	 * update of inode->i_flock and check for it done in close().
+	 * update of i_flctx->flc_posix and check for it done in close().
 	 * rcu_read_lock() wouldn't do.
 	 */
 	spin_lock(&current->files->file_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f87cb2f03103..ddd2fa7cefd3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -925,12 +925,11 @@ int locks_in_grace(struct net *);
  * FIXME: should we create a separate "struct lock_request" to help distinguish
  * these two uses?
  *
- * The i_flock list is ordered by:
+ * The varous i_flctx lists are ordered by:
  *
- * 1) lock type -- FL_LEASEs first, then FL_FLOCK, and finally FL_POSIX
- * 2) lock owner
- * 3) lock range start
- * 4) lock range end
+ * 1) lock owner
+ * 2) lock range start
+ * 3) lock range end
  *
  * Obviously, the last two criteria only matter for POSIX locks.
  */
@@ -1992,8 +1991,9 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 {
 	/*
 	 * Since this check is lockless, we must ensure that any refcounts
-	 * taken are done before checking inode->i_flock. Otherwise, we could
-	 * end up racing with tasks trying to set a new lease on this file.
+	 * taken are done before checking i_flctx->flc_lease. Otherwise, we
+	 * could end up racing with tasks trying to set a new lease on this
+	 * file.
 	 */
 	smp_mb();
 	if (inode->i_flctx && !list_empty_careful(&inode->i_flctx->flc_lease))
@@ -2005,8 +2005,9 @@ static inline int break_deleg(struct inode *inode, unsigned int mode)
 {
 	/*
 	 * Since this check is lockless, we must ensure that any refcounts
-	 * taken are done before checking inode->i_flock. Otherwise, we could
-	 * end up racing with tasks trying to set a new lease on this file.
+	 * taken are done before checking i_flctx->flc_lease. Otherwise, we
+	 * could end up racing with tasks trying to set a new lease on this
+	 * file.
 	 */
 	smp_mb();
 	if (inode->i_flctx && !list_empty_careful(&inode->i_flctx->flc_lease))
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
