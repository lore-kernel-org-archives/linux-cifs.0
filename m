From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] cifs: convert booleans in cifsInodeInfo to a flags field
Date: Mon, 31 Mar 2014 13:50:06 -0400
Message-ID: <1396288209-27328-2-git-send-email-jlayton@redhat.com>
References: <1396288209-27328-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396288209-27328-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In later patches, we'll need to have a bitlock, so go ahead and convert
these bools to use atomic bitops instead.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |  3 +--
 fs/cifs/cifsglob.h |  5 +++--
 fs/cifs/file.c     |  4 ++--
 fs/cifs/inode.c    | 19 +++++++++++--------
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 849f6132b327..8a7faf7bd9ee 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -251,8 +251,7 @@ cifs_alloc_inode(struct super_block *sb)
 	 * server, can not assume caching of file data or metadata.
 	 */
 	cifs_set_oplock_level(cifs_inode, 0);
-	cifs_inode->delete_pending = false;
-	cifs_inode->invalid_mapping = false;
+	cifs_inode->flags = 0;
 	cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
 	cifs_inode->server_eof = 0;
 	cifs_inode->uniqueid = 0;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c0f3718b77a8..0d4a1039ac27 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1111,8 +1111,9 @@ struct cifsInodeInfo {
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
 	unsigned int epoch;		/* used to track lease state changes */
-	bool delete_pending;		/* DELETE_ON_CLOSE is set */
-	bool invalid_mapping;		/* pagecache is invalid */
+#define CIFS_INO_DELETE_PENDING		(1)
+#define CIFS_INO_INVALID_MAPPING	(2)
+	unsigned long flags;		/* flags field */
 	unsigned long time;		/* jiffies of last update of inode */
 	u64  server_eof;		/* current file size on server -- protected by i_lock */
 	u64  uniqueid;			/* server inode number */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 834fce759d80..784b17d510fc 100644
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
index a22d667f1069..3e9d8ba21f5c 100644
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
+	if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags));
 		rc = cifs_invalidate_mapping(inode);
 	return rc;
 }
@@ -1857,7 +1860,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 	if (rc)
 		return rc;
 
-	if (CIFS_I(inode)->invalid_mapping)
+	if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags));
 		rc = cifs_invalidate_mapping(inode);
 	return rc;
 }
-- 
1.9.0
