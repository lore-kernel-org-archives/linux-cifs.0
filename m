From: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: [PATCH 01/10] locks: close potential race in lease_get_mtime
Date: Sat, 23 Aug 2014 10:41:09 -0400
Message-ID: <1408804878-1331-2-git-send-email-jlayton@primarydata.com>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408804878-1331-1-git-send-email-jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

lease_get_mtime is called without the i_lock held, so there's no
guarantee about the stability of the list. Between the time when we
assign "flock" and then dereference it to check whether it's a lease
and for write, the lease could be freed.

Ensure that that doesn't occur by taking the i_lock before trying
to check the lease.

Cc: J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/locks.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index d7e15a256f8f..58ce8897f2e4 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1456,8 +1456,18 @@ EXPORT_SYMBOL(__break_lease);
  */
 void lease_get_mtime(struct inode *inode, struct timespec *time)
 {
-	struct file_lock *flock = inode->i_flock;
-	if (flock && IS_LEASE(flock) && (flock->fl_type == F_WRLCK))
+	bool has_lease = false;
+	struct file_lock *flock;
+
+	if (inode->i_flock) {
+		spin_lock(&inode->i_lock);
+		flock = inode->i_flock;
+		if (flock && IS_LEASE(flock) && (flock->fl_type == F_WRLCK))
+			has_lease = true;
+		spin_unlock(&inode->i_lock);
+	}
+
+	if (has_lease)
 		*time = current_fs_time(inode->i_sb);
 	else
 		*time = inode->i_mtime;
-- 
1.9.3
