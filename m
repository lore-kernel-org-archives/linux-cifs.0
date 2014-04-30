From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH v2 1/4] cifs: convert booleans in cifsInodeInfo to a flags field
Date: Wed, 30 Apr 2014 09:31:45 -0400
Message-ID: <1398864708-18185-2-git-send-email-jlayton@poochiereds.net>
References: <1398864708-18185-1-git-send-email-jlayton@poochiereds.net>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398864708-18185-1-git-send-email-jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In later patches, we'll need to have a bitlock, so go ahead and convert
these bools to use atomic bitops instead.

Also, clean up the initialization of the flags field. There's no need
to unset each bit individually just after it was zeroed on allocation.

Signed-off-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
---
 fs/cifs/cifsfs.c   |  6 +-----
 fs/cifs/cifsglob.h |  6 +++---
 fs/cifs/file.c     |  4 ++--
 fs/cifs/inode.c    | 19 +++++++++++--------
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5be1f997ecde..3ef0299ed43e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -251,11 +251,7 @@ cifs_alloc_inode(struct super_block *sb)
 	 * server, can not assume caching of file data or metadata.
 	 */
 	cifs_set_oplock_level(cifs_inode, 0);
-	cifs_inode->delete_pending = false;
-	cifs_inode->invalid_mapping = false;
-	clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cifs_inode->flags);
-	clear_bit(CIFS_INODE_PENDING_WRITERS, &cifs_inode->flags);
-	clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2, &cifs_inode->flags);
+	cifs_inode->flags = 0;
 	spin_lock_init(&cifs_inode->writers_lock);
 	cifs_inode->writers = 0;
 	cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 30f6e9251a4a..69da55b750e7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1113,12 +1113,12 @@ struct cifsInodeInfo {
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
 	unsigned int epoch;		/* used to track lease state changes */
-	bool delete_pending;		/* DELETE_ON_CLOSE is set */
-	bool invalid_mapping;		/* pagecache is invalid */
-	unsigned long flags;
 #define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
 #define CIFS_INODE_PENDING_WRITERS	  (1) /* Writes in progress */
 #define CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2 (2) /* Downgrade oplock to L2 */
+#define CIFS_INO_DELETE_PENDING		  (3) /* delete pending on server */
+#define CIFS_INO_INVALID_MAPPING	  (4) /* pagecache is invalid */
+	unsigned long flags;
 	spinlock_t writers_lock;
 	unsigned int writers;		/* Number of writers on this inode */
 	unsigned long time;		/* jiffies of last update of inode */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5ed03e0b8b40..c8a570e87900 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -392,7 +392,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 		 * again and get at least level II oplock.
 		 */
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
-			CIFS_I(inode)->invalid_mapping = true;
+			set_bit(CIFS_INO_INVALID_MAPPING, &cifsi->flags);
 		cifs_set_oplock_level(cifsi, 0);
 	}
 	spin_unlock(&cifs_file_list_lock);
@@ -2562,7 +2562,7 @@ ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
 
 	written = cifs_iovec_write(iocb->ki_filp, iov, nr_segs, &pos);
 	if (written > 0) {
-		CIFS_I(inode)->invalid_mapping = true;
+		set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags);
 		iocb->ki_pos = pos;
 	}
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a22d667f1069..fa9ef8d902b5 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -117,7 +117,7 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 
 	cifs_dbg(FYI, "%s: invalidating inode %llu mapping\n",
 		 __func__, cifs_i->uniqueid);
-	cifs_i->invalid_mapping = true;
+	set_bit(CIFS_INO_INVALID_MAPPING, &cifs_i->flags);
 }
 
 /*
@@ -177,7 +177,10 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 	else
 		cifs_i->time = jiffies;
 
-	cifs_i->delete_pending = fattr->cf_flags & CIFS_FATTR_DELETE_PENDING;
+	if (fattr->cf_flags & CIFS_FATTR_DELETE_PENDING)
+		set_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags);
+	else
+		clear_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags);
 
 	cifs_i->server_eof = fattr->cf_eof;
 	/*
@@ -1121,7 +1124,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	}
 
 	/* try to set DELETE_ON_CLOSE */
-	if (!cifsInode->delete_pending) {
+	if (!test_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags)) {
 		rc = CIFSSMBSetFileDisposition(xid, tcon, true, fid.netfid,
 					       current->tgid);
 		/*
@@ -1138,7 +1141,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 			rc = -EBUSY;
 			goto undo_rename;
 		}
-		cifsInode->delete_pending = true;
+		set_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags);
 	}
 
 out_close:
@@ -1761,14 +1764,14 @@ cifs_invalidate_mapping(struct inode *inode)
 	int rc = 0;
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 
-	cifs_i->invalid_mapping = false;
+	clear_bit(CIFS_INO_INVALID_MAPPING, &cifs_i->flags);
 
 	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
 		rc = invalidate_inode_pages2(inode->i_mapping);
 		if (rc) {
 			cifs_dbg(VFS, "%s: could not invalidate inode %p\n",
 				 __func__, inode);
-			cifs_i->invalid_mapping = true;
+			set_bit(CIFS_INO_INVALID_MAPPING, &cifs_i->flags);
 		}
 	}
 
@@ -1842,7 +1845,7 @@ int cifs_revalidate_file(struct file *filp)
 	if (rc)
 		return rc;
 
-	if (CIFS_I(inode)->invalid_mapping)
+	if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags))
 		rc = cifs_invalidate_mapping(inode);
 	return rc;
 }
@@ -1857,7 +1860,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 	if (rc)
 		return rc;
 
-	if (CIFS_I(inode)->invalid_mapping)
+	if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags))
 		rc = cifs_invalidate_mapping(inode);
 	return rc;
 }
-- 
1.9.0
