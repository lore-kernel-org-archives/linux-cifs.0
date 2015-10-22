From: Benjamin Coddington <bcodding@redhat.com>
Subject: [PATCH 1/3] locks: introduce locks_lock_inode_wait()
Date: Thu, 22 Oct 2015 11:35:54 -0400
Message-ID: <daf0d3941f34438c1fbdc94a5f3a47c2b22f3ee8.1445524157.git.bcodding@redhat.com>
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

Users of the locks API commonly call either posix_lock_file_wait() or
flock_lock_file_wait() depending upon the lock type.  Add a new function
locks_lock_inode_wait() which will check and call the correct function for
the type of lock passed in.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
---
 fs/locks.c         |   24 ++++++++++++++++++++++++
 include/linux/fs.h |   11 +++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 2a54c80..68b1784 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1876,6 +1876,30 @@ int flock_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 EXPORT_SYMBOL(flock_lock_inode_wait);
 
 /**
+ * locks_lock_inode_wait - Apply a lock to an inode
+ * @inode: inode of the file to apply to
+ * @fl: The lock to be applied
+ *
+ * Apply a POSIX or FLOCK style lock request to an inode.
+ */
+int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl)
+{
+	int res = 0;
+	switch (fl->fl_flags & (FL_POSIX|FL_FLOCK)) {
+		case FL_POSIX:
+			res = posix_lock_inode_wait(inode, fl);
+			break;
+		case FL_FLOCK:
+			res = flock_lock_inode_wait(inode, fl);
+			break;
+		default:
+			BUG();
+	}
+	return res;
+}
+EXPORT_SYMBOL(locks_lock_inode_wait);
+
+/**
  *	sys_flock: - flock() system call.
  *	@fd: the file descriptor to lock.
  *	@cmd: the type of lock to apply.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 72d8a84..2e283b7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1059,6 +1059,7 @@ extern int vfs_test_lock(struct file *, struct file_lock *);
 extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
 extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
 extern int flock_lock_inode_wait(struct inode *inode, struct file_lock *fl);
+extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
 extern void lease_get_mtime(struct inode *, struct timespec *time);
 extern int generic_setlease(struct file *, long, struct file_lock **, void **priv);
@@ -1177,6 +1178,11 @@ static inline int flock_lock_inode_wait(struct inode *inode,
 	return -ENOLCK;
 }
 
+static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
+{
+	return -ENOLCK;
+}
+
 static inline int __break_lease(struct inode *inode, unsigned int mode, unsigned int type)
 {
 	return 0;
@@ -1225,6 +1231,11 @@ static inline int flock_lock_file_wait(struct file *filp, struct file_lock *fl)
 	return flock_lock_inode_wait(file_inode(filp), fl);
 }
 
+static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
+{
+	return locks_lock_inode_wait(file_inode(filp), fl);
+}
+
 struct fasync_struct {
 	spinlock_t		fa_lock;
 	int			magic;
-- 
1.7.1
