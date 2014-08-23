From: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: [PATCH 10/10] locks: update Documentation/filesystems with lease API changes
Date: Sat, 23 Aug 2014 10:41:18 -0400
Message-ID: <1408804878-1331-11-git-send-email-jlayton@primarydata.com>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408804878-1331-1-git-send-email-jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 Documentation/filesystems/Locking | 21 ++++++++++-----------
 Documentation/filesystems/vfs.txt |  7 ++++---
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index f1997e9da61f..9e777f9fc859 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -349,11 +349,7 @@ prototypes:
 locking rules:
 			inode->i_lock	may block
 fl_copy_lock:		yes		no
-fl_release_private:	maybe		maybe[1]
-
-[1]:	->fl_release_private for flock or POSIX locks is currently allowed
-to block. Leases however can still be freed while the i_lock is held and
-so fl_release_private called on a lease should not block.
+fl_release_private:	no		yes
 
 ----------------------- lock_manager_operations ---------------------------
 prototypes:
@@ -362,7 +358,8 @@ prototypes:
 	void (*lm_notify)(struct file_lock *);  /* unblock callback */
 	int (*lm_grant)(struct file_lock *, struct file_lock *, int);
 	void (*lm_break)(struct file_lock *); /* break_lease callback */
-	int (*lm_change)(struct file_lock **, int);
+	int (*lm_change)(struct file_lock **, int, struct list_head *);
+	void (*lm_setup)(struct file_lock *, void **);
 
 locking rules:
 
@@ -373,6 +370,7 @@ lm_notify:		yes		yes			no
 lm_grant:		no		no			no
 lm_break:		yes		no			no
 lm_change		yes		no			no
+lm_setup		yes		no			no
 
 [1]:	->lm_compare_owner and ->lm_owner_key are generally called with
 *an* inode->i_lock held. It may not be the i_lock of the inode
@@ -464,15 +462,12 @@ prototypes:
 			size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *,
 			size_t, unsigned int);
-	int (*setlease)(struct file *, long, struct file_lock **);
+	int (*setlease)(struct file *, long, struct file_lock **, void **);
 	long (*fallocate)(struct file *, int, loff_t, loff_t);
 };
 
 locking rules:
-	All may block except for ->setlease.
-	No VFS locks held on entry except for ->setlease.
-
-->setlease has the file_list_lock held and must not sleep.
+	All may block.
 
 ->llseek() locking has moved from llseek to the individual llseek
 implementations.  If your fs is not using generic_file_llseek, you
@@ -496,6 +491,10 @@ components. And there are other reasons why the current interface is a mess...
 ->read on directories probably must go away - we should just enforce -EISDIR
 in sys_read() and friends.
 
+->setlease operations should call generic_setlease() before or after setting
+the lease within the individual filesystem to record the result of the
+operation
+
 --------------------------- dquot_operations -------------------------------
 prototypes:
 	int (*write_dquot) (struct dquot *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 61d65cc65c54..af9441f32a62 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -826,7 +826,7 @@ struct file_operations {
 	int (*flock) (struct file *, int, struct file_lock *);
 	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
-	int (*setlease)(struct file *, long arg, struct file_lock **);
+	int (*setlease)(struct file *, long arg, struct file_lock **, void **);
 	long (*fallocate)(struct file *, int mode, loff_t offset, loff_t len);
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
@@ -895,8 +895,9 @@ otherwise noted.
   splice_read: called by the VFS to splice data from file to a pipe. This
 	       method is used by the splice(2) system call
 
-  setlease: called by the VFS to set or release a file lock lease.
-	    setlease has the file_lock_lock held and must not sleep.
+  setlease: called by the VFS to set or release a file lock lease. setlease
+	    implementations should call generic_setlease to record or remove
+	    the lease in the inode after setting it
 
   fallocate: called by the VFS to preallocate blocks or punch a hole.
 
-- 
1.9.3
