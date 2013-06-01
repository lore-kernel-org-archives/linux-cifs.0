From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 03/11] locks: comment cleanups and clarifications
Date: Fri, 31 May 2013 23:07:26 -0400
Message-ID: <1370056054-25449-4-git-send-email-jlayton@redhat.com>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew-Ztpu424NOJ8@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370056054-25449-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/locks.c         |   24 +++++++++++++++++++-----
 include/linux/fs.h |    6 ++++++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index e3140b8..a7d2253 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -150,6 +150,16 @@ static int target_leasetype(struct file_lock *fl)
 int leases_enable = 1;
 int lease_break_time = 45;
 
+/*
+ * The i_flock list is ordered by:
+ *
+ * 1) lock type -- FL_LEASEs first, then FL_FLOCK, and finally FL_POSIX
+ * 2) lock owner
+ * 3) lock range start
+ * 4) lock range end
+ *
+ * Obviously, the last two criteria only matter for POSIX locks.
+ */
 #define for_each_lock(inode, lockp) \
 	for (lockp = &inode->i_flock; *lockp != NULL; lockp = &(*lockp)->fl_next)
 
@@ -806,6 +816,11 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 	}
 
 	lock_flocks();
+	/*
+	 * New lock request. Walk all POSIX locks and look for conflicts. If
+	 * there are any, either return -EAGAIN or put the request on the
+	 * blocker's list of waiters.
+	 */
 	if (request->fl_type != F_UNLCK) {
 		for_each_lock(inode, before) {
 			fl = *before;
@@ -844,7 +859,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		before = &fl->fl_next;
 	}
 
-	/* Process locks with this owner.  */
+	/* Process locks with this owner. */
 	while ((fl = *before) && posix_same_owner(request, fl)) {
 		/* Detect adjacent or overlapping regions (if same lock type)
 		 */
@@ -930,10 +945,9 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 	}
 
 	/*
-	 * The above code only modifies existing locks in case of
-	 * merging or replacing.  If new lock(s) need to be inserted
-	 * all modifications are done bellow this, so it's safe yet to
-	 * bail out.
+	 * The above code only modifies existing locks in case of merging or
+	 * replacing. If new lock(s) need to be inserted all modifications are
+	 * done below this, so it's safe yet to bail out.
 	 */
 	error = -ENOLCK; /* "no luck" */
 	if (right && left == right && !new_fl2)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b9d7816..ae377e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -926,6 +926,12 @@ int locks_in_grace(struct net *);
 /* that will die - we need it for nfs_lock_info */
 #include <linux/nfs_fs_i.h>
 
+/*
+ * struct file_lock represents a generic "file lock". It's used to represent
+ * POSIX byte range locks, BSD (flock) locks, and leases. It's important to
+ * note that the same struct is used to represent both a request for a lock and
+ * the lock itself, but the same object is never used for both.
+ */
 struct file_lock {
 	struct file_lock *fl_next;	/* singly linked list for this inode  */
 	struct list_head fl_link;	/* doubly linked list of all locks */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
