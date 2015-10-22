From: Benjamin Coddington <bcodding@redhat.com>
Subject: [PATCH 3/3] locks: cleanup posix_lock_inode_wait and
 flock_lock_inode_wait
Date: Thu, 22 Oct 2015 11:35:56 -0400
Message-ID: <ded792d8fdcba562a1c74fd14fefcb387debc4b1.1445524157.git.bcodding@redhat.com>
References: <cover.1445524157.git.bcodding@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Latchesar Ionkov <lucho@ionkov.net>, linux-fsdevel@vger.kernel.org,
 Trond Myklebust <trond.myklebust@primarydata.com>, devel@driverdev.osuosl.org,
 Yan Zheng <zyan@redhat.com>, cluster-devel@redhat.com,
 Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Christoph Hellwig <hch@infradead.org>, fuse-devel@lists.sourceforge.net,
 Christine Caulfield <ccaulfie@redhat.com>,
 v9fs-developer@lists.sourceforge.net, Ilya Dryomov <idryomov@gmail.com>,
 linux-cifs@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
 Mark Fasheh <mfasheh@suse.com>, Oleg Drokin <oleg.drokin@intel.com>,
 Julia Lawall <Julia.Lawall@lip6.fr>, David Teigland <teigland@redhat.com>,
 Joel Becker <jlbec@evilplan.org>, ceph-devel@vger.kernel.org,
 Abdul Hussain <habdul@visteon.com>, Steven Whitehouse <swhiteho@redhat.com>,
 linux-nfs@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
 Greg K
To: Jeff Layton <jlayton@poochiereds.net>,
 "J. Bruce Fields" <bfields@fieldses.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <cover.1445524157.git.bcodding@redhat.com>
In-Reply-To: <cover.1445524157.git.bcodding@redhat.com>
References: <cover.1445524157.git.bcodding@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-cifs.vger.kernel.org

All callers use locks_lock_inode_wait() instead.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
---
 fs/locks.c         |    5 +----
 include/linux/fs.h |   24 ------------------------
 2 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 94d50d3..b6f3c92 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1167,8 +1167,7 @@ EXPORT_SYMBOL(posix_lock_file);
  * @inode: inode of file to which lock request should be applied
  * @fl: The lock to be applied
  *
- * Variant of posix_lock_file_wait that does not take a filp, and so can be
- * used after the filp has already been torn down.
+ * Apply a POSIX style lock request to an inode.
  */
 int posix_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 {
@@ -1187,7 +1186,6 @@ int posix_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 	}
 	return error;
 }
-EXPORT_SYMBOL(posix_lock_inode_wait);
 
 /**
  * locks_mandatory_locked - Check for an active lock
@@ -1873,7 +1871,6 @@ int flock_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 	}
 	return error;
 }
-EXPORT_SYMBOL(flock_lock_inode_wait);
 
 /**
  * locks_lock_inode_wait - Apply a lock to an inode
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2e283b7..05b07c9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1053,12 +1053,10 @@ extern void locks_remove_file(struct file *);
 extern void locks_release_private(struct file_lock *);
 extern void posix_test_lock(struct file *, struct file_lock *);
 extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
-extern int posix_lock_inode_wait(struct inode *, struct file_lock *);
 extern int posix_unblock_lock(struct file_lock *);
 extern int vfs_test_lock(struct file *, struct file_lock *);
 extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
 extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
-extern int flock_lock_inode_wait(struct inode *inode, struct file_lock *fl);
 extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
 extern void lease_get_mtime(struct inode *, struct timespec *time);
@@ -1145,12 +1143,6 @@ static inline int posix_lock_file(struct file *filp, struct file_lock *fl,
 	return -ENOLCK;
 }
 
-static inline int posix_lock_inode_wait(struct inode *inode,
-					struct file_lock *fl)
-{
-	return -ENOLCK;
-}
-
 static inline int posix_unblock_lock(struct file_lock *waiter)
 {
 	return -ENOENT;
@@ -1172,12 +1164,6 @@ static inline int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 	return 0;
 }
 
-static inline int flock_lock_inode_wait(struct inode *inode,
-					struct file_lock *request)
-{
-	return -ENOLCK;
-}
-
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
 {
 	return -ENOLCK;
@@ -1221,16 +1207,6 @@ static inline struct inode *file_inode(const struct file *f)
 	return f->f_inode;
 }
 
-static inline int posix_lock_file_wait(struct file *filp, struct file_lock *fl)
-{
-	return posix_lock_inode_wait(file_inode(filp), fl);
-}
-
-static inline int flock_lock_file_wait(struct file *filp, struct file_lock *fl)
-{
-	return flock_lock_inode_wait(file_inode(filp), fl);
-}
-
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
 {
 	return locks_lock_inode_wait(file_inode(filp), fl);
-- 
1.7.1
