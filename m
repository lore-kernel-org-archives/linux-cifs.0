From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch 05/10] vfs: pass data to alloc_inode super operation
Date: Tue, 30 Oct 2012 16:14:39 -0400
Message-ID: <1351628084-29358-8-git-send-email-jmoyer@redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Cc: David Howells <dhowells@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@fusionio.com>,
	Steve French <sfrench@samba.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	ocfs2-devel@oss.oracle.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This patch passes a data pointer along to the alloc_inode
super_operations function.  The value will initially be used by
bdev_alloc_inode to allocate the bdev_inode on the same numa
node as the device to which it is tied.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/afs/super.c         |    5 +++--
 fs/block_dev.c         |   17 +++++++++++++++--
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/inode.c       |    3 ++-
 fs/cifs/cifsfs.c       |    2 +-
 fs/inode.c             |   10 +++++-----
 fs/ocfs2/dlmfs/dlmfs.c |    3 ++-
 fs/ocfs2/super.c       |    5 +++--
 include/linux/fs.h     |    2 +-
 9 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index 4316500..e242661 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -32,7 +32,7 @@ static void afs_i_init_once(void *foo);
 static struct dentry *afs_mount(struct file_system_type *fs_type,
 		      int flags, const char *dev_name, void *data);
 static void afs_kill_super(struct super_block *sb);
-static struct inode *afs_alloc_inode(struct super_block *sb);
+static struct inode *afs_alloc_inode(struct super_block *sb, void *data);
 static void afs_destroy_inode(struct inode *inode);
 static int afs_statfs(struct dentry *dentry, struct kstatfs *buf);
 
@@ -470,7 +470,8 @@ static void afs_i_init_once(void *_vnode)
 /*
  * allocate an AFS inode struct from our slab cache
  */
-static struct inode *afs_alloc_inode(struct super_block *sb)
+static struct inode *afs_alloc_inode(struct super_block *sb,
+				     void * __attribute__((unused))data)
 {
 	struct afs_vnode *vnode;
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index b3c1d3d..c366fb2 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -454,9 +454,22 @@ EXPORT_SYMBOL(blkdev_fsync);
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(bdev_lock);
 static struct kmem_cache * bdev_cachep __read_mostly;
 
-static struct inode *bdev_alloc_inode(struct super_block *sb)
+static struct inode *bdev_alloc_inode(struct super_block *sb, void *data)
 {
-	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
+	struct bdev_inode *ei;
+	int partno;
+	int node;
+
+	if (data) {
+		struct gendisk *disk;
+		dev_t dev = *(dev_t *)data;
+		disk = get_gendisk(dev, &partno);
+		node = disk->node_id;
+		put_disk(disk);
+	} else
+		node = -1;
+	
+	ei = kmem_cache_alloc_node(bdev_cachep, GFP_KERNEL, node);
 	if (!ei)
 		return NULL;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 926c9ff..0736131 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3324,7 +3324,7 @@ int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
 int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc);
 int btrfs_dirty_inode(struct inode *inode);
-struct inode *btrfs_alloc_inode(struct super_block *sb);
+struct inode *btrfs_alloc_inode(struct super_block *sb, void *data);
 void btrfs_destroy_inode(struct inode *inode);
 int btrfs_drop_inode(struct inode *inode);
 int btrfs_init_cachep(void);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85a1e50..d4b42d0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7057,7 +7057,8 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	return err;
 }
 
-struct inode *btrfs_alloc_inode(struct super_block *sb)
+struct inode *btrfs_alloc_inode(struct super_block *sb,
+				void * __attribute__((unused))data)
 {
 	struct btrfs_inode *ei;
 	struct inode *inode;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e7931cc..2e67ed7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -215,7 +215,7 @@ mempool_t *cifs_req_poolp;
 mempool_t *cifs_mid_poolp;
 
 static struct inode *
-cifs_alloc_inode(struct super_block *sb)
+cifs_alloc_inode(struct super_block *sb, void * __attribute__((unused)) data)
 {
 	struct cifsInodeInfo *cifs_inode;
 	cifs_inode = kmem_cache_alloc(cifs_inode_cachep, GFP_KERNEL);
diff --git a/fs/inode.c b/fs/inode.c
index b03c719..bb7e273 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -199,12 +199,12 @@ out:
 }
 EXPORT_SYMBOL(inode_init_always);
 
-static struct inode *alloc_inode(struct super_block *sb)
+static struct inode *alloc_inode(struct super_block *sb, void *data)
 {
 	struct inode *inode;
 
 	if (sb->s_op->alloc_inode)
-		inode = sb->s_op->alloc_inode(sb);
+		inode = sb->s_op->alloc_inode(sb, data);
 	else
 		inode = kmem_cache_alloc(inode_cachep, GFP_KERNEL);
 
@@ -892,7 +892,7 @@ EXPORT_SYMBOL(get_next_ino);
  */
 struct inode *new_inode_pseudo(struct super_block *sb)
 {
-	struct inode *inode = alloc_inode(sb);
+	struct inode *inode = alloc_inode(sb, NULL);
 
 	if (inode) {
 		spin_lock(&inode->i_lock);
@@ -1004,7 +1004,7 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		return inode;
 	}
 
-	inode = alloc_inode(sb);
+	inode = alloc_inode(sb, data);
 	if (inode) {
 		struct inode *old;
 
@@ -1073,7 +1073,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 		return inode;
 	}
 
-	inode = alloc_inode(sb);
+	inode = alloc_inode(sb, NULL);
 	if (inode) {
 		struct inode *old;
 
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 16b712d..a322984 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -340,7 +340,8 @@ static void dlmfs_init_once(void *foo)
 	inode_init_once(&ip->ip_vfs_inode);
 }
 
-static struct inode *dlmfs_alloc_inode(struct super_block *sb)
+static struct inode *dlmfs_alloc_inode(struct super_block *sb,
+				       void *__attribute__((unused)) data)
 {
 	struct dlmfs_inode_private *ip;
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0e91ec2..ada4a81 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -137,7 +137,7 @@ static int ocfs2_get_sector(struct super_block *sb,
 			    struct buffer_head **bh,
 			    int block,
 			    int sect_size);
-static struct inode *ocfs2_alloc_inode(struct super_block *sb);
+static struct inode *ocfs2_alloc_inode(struct super_block *sb, void *data);
 static void ocfs2_destroy_inode(struct inode *inode);
 static int ocfs2_susp_quotas(struct ocfs2_super *osb, int unsuspend);
 static int ocfs2_enable_quotas(struct ocfs2_super *osb);
@@ -554,7 +554,8 @@ static void ocfs2_release_system_inodes(struct ocfs2_super *osb)
 }
 
 /* We're allocating fs objects, use GFP_NOFS */
-static struct inode *ocfs2_alloc_inode(struct super_block *sb)
+static struct inode *ocfs2_alloc_inode(struct super_block *sb,
+				       void *__attribute__((unused))data)
 {
 	struct ocfs2_inode_info *oi;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..240b298 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1595,7 +1595,7 @@ extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *);
 
 struct super_operations {
-   	struct inode *(*alloc_inode)(struct super_block *sb);
+   	struct inode *(*alloc_inode)(struct super_block *sb, void *data);
 	void (*destroy_inode)(struct inode *);
 
    	void (*dirty_inode) (struct inode *, int flags);
-- 
1.7.1
