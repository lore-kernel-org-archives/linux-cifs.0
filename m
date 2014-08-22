From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/5] cifs: shared-superblock - data structures and functions for disconnected roots noserverino kind shares
Date: Fri, 22 Aug 2014 17:20:59 -0500
Message-ID: <1408746059-10184-1-git-send-email-spargaonkar@suse.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	shirish <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: shirish <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

For servers that do not provide an uniqueid for inode, if we are mounting
using a disconnected root dentry, keep a list of such dentries and other
info in a linked list off of superblock.
They can be searched and spliced within a spinlock or if never spliced,
remembered to be removed.

Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h | 10 ++++++++++
 fs/cifs/cifsfs.c     | 32 ++++++++++++++++++++++++++++++++
 fs/cifs/connect.c    |  3 +++
 3 files changed, 45 insertions(+)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 9409fa1..ecc63af 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -66,5 +66,15 @@ struct cifs_sb_info {
 	struct backing_dev_info bdi;
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
+	struct list_head rtdislist; /* list of disconnected root dentries */
+	spinlock_t rtdislock; /* lock for disconnected root dentry list */
+};
+
+struct cifs_rdelem {
+	int                     rdcount;
+	struct list_head        rdlist;
+	char *                  rdname;
+	struct dentry *		rdentry;
+	struct inode *          rdinode;
 };
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0a4a4d7..4e759f6 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -570,6 +570,38 @@ static const struct super_operations cifs_super_ops = {
 #endif
 };
 
+void
+cifs_free_rdelem(struct cifs_rdelem *rdelem)
+{
+	kfree(rdelem->rdname);
+	kfree(rdelem);
+}
+
+struct cifs_rdelem *
+cifs_alloc_rdelem(char *full_path, struct dentry *rdentry,
+				struct inode *rdinode)
+{
+	struct cifs_rdelem *rdelem;
+
+	rdelem = kmalloc(sizeof(struct cifs_rdelem), GFP_KERNEL);
+	if (!rdelem) {
+		cifs_dbg(FYI, "%s Can't allocate root dentry\n", __func__);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	rdelem->rdname = kstrdup(full_path, GFP_KERNEL);
+	if (!rdelem->rdname) {
+		cifs_dbg(FYI, "%s Can't allocate root dentry name\n", __func__);
+		kfree(rdelem);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	rdelem->rdinode = rdinode;
+	rdelem->rdentry = rdentry;
+
+	return rdelem;
+}
+
 /*
  * Get root dentry from superblock according to prefix path mount option.
  * Return dentry with refcount + 1 on success and NULL otherwise.
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 03ed8a0..2293b9d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3171,6 +3171,9 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
 
+	spin_lock_init(&cifs_sb->rtdislock);
+	INIT_LIST_HEAD(&cifs_sb->rtdislist);
+
 	/*
 	 * Temporarily set r/wsize for matching superblock. If we end up using
 	 * new sb then client will later negotiate it downward if needed.
-- 
1.8.4.5
