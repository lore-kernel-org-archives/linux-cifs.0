From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH] fs: convert super_block.s_active from atomic_t to refcount_t
Date: Wed, 29 Nov 2017 13:17:57 +0200
Message-ID: <1511954277-13477-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        lustre-devel@lists.lustre.org, peterz@infradead.org,
        keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
To: viro@zeniv.linux.org.uk
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

The variable super_block.s_active is used as pure reference counter.
Convert it to refcount_t and fix up the operations.

**Important note for maintainers:

Some functions from refcount_t API defined in lib/refcount.c
have different memory ordering guarantees than their atomic
counterparts.
The full comparison can be seen in
https://lkml.org/lkml/2017/11/15/57 and it is hopefully soon
in state to be merged to the documentation tree.
Normally the differences should not matter since refcount_t provides
enough guarantees to satisfy the refcounting use cases, but in
some rare cases it might matter.
Please double check that you don't have some undocumented
memory guarantees for this variable usage.

For the super_block.s_active it might make a difference
in following places:
 - kernfs_pin_sb(): increment in refcount_inc_not_zero() only
   guarantees control dependency on success vs. fully ordered
   atomic counterpart. However the operation is perfomed under
   mutex_lock(), so this case should be ok.
 - proc_sys_prune_dcache(): increment in refcount_inc_not_zero()
   only guarantees control dependency on success vs. fully ordered
   atomic counterpart. However the operation is perfomed under
   rcu_read_lock(), so this case should be ok.
 - nfs_sb_active() and grab_super(): increment in
   refcount_inc_not_zero() only guarantees control dependency
   on success vs. fully ordered atomic counterpart.
 - deactivate_locked_super(): decrement in refcount_dec_and_test() only
   provides RELEASE ordering and control dependency on success
   vs. fully ordered atomic counterpart
 - nfs_sb_active() and deactivate_locked_super(): decrement in
   refcount_dec() only provides RELEASE ordering vs. fully unordered
   atomic counterpart. Since the change is for better, it should not
   matter for these cases.
 - deactivate_super(): decrement in refcount_dec_not_one() only
   provides RELEASE ordering and control dependency on success
   vs. fully ordered on success atomic atomic_add_unless(&var, -1, 1).

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: David Windsor <dwindsor@gmail.com>
Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c |  2 +-
 fs/cifs/cifsfs.c                                |  2 +-
 fs/devpts/inode.c                               |  2 +-
 fs/gfs2/super.c                                 |  2 +-
 fs/kernfs/mount.c                               |  2 +-
 fs/namespace.c                                  |  4 ++--
 fs/nfs/super.c                                  |  4 ++--
 fs/proc/proc_sysctl.c                           |  2 +-
 fs/super.c                                      | 10 +++++-----
 include/linux/fs.h                              |  3 ++-
 10 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 8666f1e..6cc1526 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1991,7 +1991,7 @@ void ll_umount_begin(struct super_block *sb)
 	struct l_wait_info lwi;
 
 	CDEBUG(D_VFSTRACE, "VFS Op: superblock %p count %d active %d\n", sb,
-	       sb->s_count, atomic_read(&sb->s_active));
+	       sb->s_count, refcount_read(&sb->s_active));
 
 	obd = class_exp2obd(sbi->ll_md_exp);
 	if (!obd) {
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 2cbd0c9..95d965e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -101,7 +101,7 @@ cifs_sb_active(struct super_block *sb)
 	struct cifs_sb_info *server = CIFS_SB(sb);
 
 	if (atomic_inc_return(&server->active) == 1)
-		atomic_inc(&sb->s_active);
+		refcount_inc(&sb->s_active);
 }
 
 void
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 7eae33f..2544e2c 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -197,7 +197,7 @@ struct pts_fs_info *devpts_acquire(struct file *filp)
 	 * pty code needs to hold extra references in case of last /dev/tty close
 	 */
 	sb = path.mnt->mnt_sb;
-	atomic_inc(&sb->s_active);
+	refcount_inc(&sb->s_active);
 	result = DEVPTS_SB(sb);
 
 out:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d81d46e..cf29290 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -957,7 +957,7 @@ void gfs2_freeze_func(struct work_struct *work)
 	struct gfs2_sbd *sdp = container_of(work, struct gfs2_sbd, sd_freeze_work);
 	struct super_block *sb = sdp->sd_vfs;
 
-	atomic_inc(&sb->s_active);
+	refcount_inc(&sb->s_active);
 	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, 0,
 				   &freeze_gh);
 	if (error) {
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index 26dd9a5..ab6a5b5 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -390,7 +390,7 @@ struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns)
 	list_for_each_entry(info, &root->supers, node) {
 		if (info->ns == ns) {
 			sb = info->sb;
-			if (!atomic_inc_not_zero(&info->sb->s_active))
+			if (!refcount_inc_not_zero(&info->sb->s_active))
 				sb = ERR_PTR(-EINVAL);
 			break;
 		}
diff --git a/fs/namespace.c b/fs/namespace.c
index ce63218..848e9b0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1112,7 +1112,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	    (!(flag & CL_EXPIRE) || list_empty(&old->mnt_expire)))
 		mnt->mnt.mnt_flags |= MNT_LOCKED;
 
-	atomic_inc(&sb->s_active);
+	refcount_inc(&sb->s_active);
 	mnt->mnt.mnt_sb = sb;
 	mnt->mnt.mnt_root = dget(root);
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
@@ -3022,7 +3022,7 @@ struct dentry *mount_subtree(struct vfsmount *mnt, const char *name)
 
 	/* trade a vfsmount reference for active sb one */
 	s = path.mnt->mnt_sb;
-	atomic_inc(&s->s_active);
+	refcount_inc(&s->s_active);
 	mntput(path.mnt);
 	/* lock the sucker */
 	down_write(&s->s_umount);
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 79e2021..318675b 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -412,10 +412,10 @@ bool nfs_sb_active(struct super_block *sb)
 {
 	struct nfs_server *server = NFS_SB(sb);
 
-	if (!atomic_inc_not_zero(&sb->s_active))
+	if (!refcount_inc_not_zero(&sb->s_active))
 		return false;
 	if (atomic_inc_return(&server->active) != 1)
-		atomic_dec(&sb->s_active);
+		refcount_dec(&sb->s_active);
 	return true;
 }
 EXPORT_SYMBOL_GPL(nfs_sb_active);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index c5cbbdf..f00f8d2 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -281,7 +281,7 @@ static void proc_sys_prune_dcache(struct ctl_table_header *head)
 
 		inode = &ei->vfs_inode;
 		sb = inode->i_sb;
-		if (!atomic_inc_not_zero(&sb->s_active))
+		if (!refcount_inc_not_zero(&sb->s_active))
 			continue;
 		inode = igrab(inode);
 		rcu_read_unlock();
diff --git a/fs/super.c b/fs/super.c
index d4e33e8..c7062ec 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -238,7 +238,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	 */
 	down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING);
 	s->s_count = 1;
-	atomic_set(&s->s_active, 1);
+	refcount_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
 	init_rwsem(&s->s_dquot.dqio_sem);
@@ -307,7 +307,7 @@ static void put_super(struct super_block *sb)
 void deactivate_locked_super(struct super_block *s)
 {
 	struct file_system_type *fs = s->s_type;
-	if (atomic_dec_and_test(&s->s_active)) {
+	if (refcount_dec_and_test(&s->s_active)) {
 		cleancache_invalidate_fs(s);
 		unregister_shrinker(&s->s_shrink);
 		fs->kill_sb(s);
@@ -339,7 +339,7 @@ EXPORT_SYMBOL(deactivate_locked_super);
  */
 void deactivate_super(struct super_block *s)
 {
-        if (!atomic_add_unless(&s->s_active, -1, 1)) {
+	if (!refcount_dec_not_one(&s->s_active)) {
 		down_write(&s->s_umount);
 		deactivate_locked_super(s);
 	}
@@ -365,7 +365,7 @@ static int grab_super(struct super_block *s) __releases(sb_lock)
 	s->s_count++;
 	spin_unlock(&sb_lock);
 	down_write(&s->s_umount);
-	if ((s->s_flags & SB_BORN) && atomic_inc_not_zero(&s->s_active)) {
+	if ((s->s_flags & SB_BORN) && refcount_inc_not_zero(&s->s_active)) {
 		put_super(s);
 		return 1;
 	}
@@ -1424,7 +1424,7 @@ int freeze_super(struct super_block *sb)
 {
 	int ret;
 
-	atomic_inc(&sb->s_active);
+	refcount_inc(&sb->s_active);
 	down_write(&sb->s_umount);
 	if (sb->s_writers.frozen != SB_UNFROZEN) {
 		deactivate_locked_super(sb);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bbd92da..ff4a2b7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -35,6 +35,7 @@
 #include <linux/delayed_call.h>
 #include <linux/uuid.h>
 #include <linux/errseq.h>
+#include <linux/refcount.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1351,7 +1352,7 @@ struct super_block {
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;
 	int			s_count;
-	atomic_t		s_active;
+	refcount_t		s_active;
 #ifdef CONFIG_SECURITY
 	void                    *s_security;
 #endif
-- 
2.7.4
