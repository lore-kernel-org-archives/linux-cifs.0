From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/16] cifs: eliminate cifsInodeInfo->write_behind_rc
Date: Mon, 11 Oct 2010 15:07:33 -0400
Message-ID: <1286824053-12084-17-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

write_behind_rc is redundant and just adds complexity to the code. What
we really want to do instead is to use mapping_set_error to reset the
flags on the mapping when we find a writeback error and can't report it
to userspace yet.

For cifs_flush and cifs_fsync, we shouldn't reset the flags since errors
returned there do get reported to userspace.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    1 -
 fs/cifs/cifsglob.h |    1 -
 fs/cifs/file.c     |   34 ++++++++--------------------------
 fs/cifs/inode.c    |   15 +++++----------
 4 files changed, 13 insertions(+), 38 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c25e928..6e3e2e8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -323,7 +323,6 @@ cifs_alloc_inode(struct super_block *sb)
 		return NULL;
 	cifs_inode->cifsAttrs = 0x20;	/* default */
 	cifs_inode->time = 0;
-	cifs_inode->write_behind_rc = 0;
 	/* Until the file is open and we have gotten oplock
 	info back from the server, can not assume caching of
 	file data or metadata */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2327dcb..78db6f8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -418,7 +418,6 @@ struct cifsInodeInfo {
 	struct list_head lockList;
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
-	int write_behind_rc;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned long time;	/* jiffies of last update/check of inode */
 	bool clientCanCacheRead:1;	/* read oplock */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7887a39..970c0b6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -131,8 +131,7 @@ static inline int cifs_open_inode_helper(struct inode *inode,
 			/* BB no need to lock inode until after invalidate
 			since namei code should already have it locked? */
 			rc = filemap_write_and_wait(inode->i_mapping);
-			if (rc != 0)
-				pCifsInode->write_behind_rc = rc;
+			mapping_set_error(inode->i_mapping, rc);
 		}
 		cFYI(1, "invalidating remote inode since open detected it "
 			 "changed");
@@ -602,8 +601,7 @@ reopen_success:
 
 	if (can_flush) {
 		rc = filemap_write_and_wait(inode->i_mapping);
-		if (rc != 0)
-			CIFS_I(inode)->write_behind_rc = rc;
+		mapping_set_error(inode->i_mapping, rc);
 
 		pCifsInode->clientCanCacheAll = false;
 		pCifsInode->clientCanCacheRead = false;
@@ -1484,12 +1482,7 @@ retry:
 			if (rc || bytes_written < bytes_to_write) {
 				cERROR(1, "Write2 ret %d, wrote %d",
 					  rc, bytes_written);
-				/* BB what if continued retry is
-				   requested via mount flags? */
-				if (rc == -ENOSPC)
-					set_bit(AS_ENOSPC, &mapping->flags);
-				else
-					set_bit(AS_EIO, &mapping->flags);
+				mapping_set_error(mapping, rc);
 			} else {
 				cifs_stats_bytes_written(tcon, bytes_written);
 			}
@@ -1634,10 +1627,8 @@ int cifs_fsync(struct file *file, int datasync)
 
 	rc = filemap_write_and_wait(inode->i_mapping);
 	if (rc == 0) {
-		rc = CIFS_I(inode)->write_behind_rc;
-		CIFS_I(inode)->write_behind_rc = 0;
 		tcon = tlink_tcon(smbfile->tlink);
-		if (!rc && tcon && smbfile &&
+		if (rc == 0 &&
 		   !(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
 			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
 	}
@@ -1683,14 +1674,8 @@ int cifs_flush(struct file *file, fl_owner_t id)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int rc = 0;
 
-	if (file->f_mode & FMODE_WRITE) {
+	if (file->f_mode & FMODE_WRITE)
 		rc = filemap_write_and_wait(inode->i_mapping);
-		/* reset wb rc if we were able to write out dirty pages */
-		if (!rc) {
-			rc = CIFS_I(inode)->write_behind_rc;
-			CIFS_I(inode)->write_behind_rc = 0;
-		}
-	}
 
 	cFYI(1, "Flush inode %p file %p rc %d", inode, file, rc);
 
@@ -2269,7 +2254,7 @@ void cifs_oplock_break(struct work_struct *work)
 						  oplock_break);
 	struct inode *inode = cfile->dentry->d_inode;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
-	int rc, waitrc = 0;
+	int rc = 0;
 
 	if (inode && S_ISREG(inode->i_mode)) {
 		if (cinode->clientCanCacheRead)
@@ -2278,13 +2263,10 @@ void cifs_oplock_break(struct work_struct *work)
 			break_lease(inode, O_WRONLY);
 		rc = filemap_fdatawrite(inode->i_mapping);
 		if (cinode->clientCanCacheRead == 0) {
-			waitrc = filemap_fdatawait(inode->i_mapping);
+			rc = filemap_fdatawait(inode->i_mapping);
+			mapping_set_error(inode->i_mapping, rc);
 			invalidate_remote_inode(inode);
 		}
-		if (!rc)
-			rc = waitrc;
-		if (rc)
-			cinode->write_behind_rc = rc;
 		cFYI(1, "Oplock flush inode %p rc %d", inode, rc);
 	}
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cfe2339..ed5558b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1688,8 +1688,7 @@ cifs_invalidate_mapping(struct inode *inode)
 	/* write back any cached data */
 	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
 		rc = filemap_write_and_wait(inode->i_mapping);
-		if (rc)
-			cifs_i->write_behind_rc = rc;
+		mapping_set_error(inode->i_mapping, rc);
 	}
 	invalidate_remote_inode(inode);
 	cifs_fscache_reset_inode_cookie(inode);
@@ -1949,10 +1948,8 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	 * the flush returns error?
 	 */
 	rc = filemap_write_and_wait(inode->i_mapping);
-	if (rc != 0) {
-		cifsInode->write_behind_rc = rc;
-		rc = 0;
-	}
+	mapping_set_error(inode->i_mapping, rc);
+	rc = 0;
 
 	if (attrs->ia_valid & ATTR_SIZE) {
 		rc = cifs_set_file_size(inode, attrs, xid, full_path);
@@ -2093,10 +2090,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	 * the flush returns error?
 	 */
 	rc = filemap_write_and_wait(inode->i_mapping);
-	if (rc != 0) {
-		cifsInode->write_behind_rc = rc;
-		rc = 0;
-	}
+	mapping_set_error(inode->i_mapping, rc);
+	rc = 0;
 
 	if (attrs->ia_valid & ATTR_SIZE) {
 		rc = cifs_set_file_size(inode, attrs, xid, full_path);
-- 
1.7.2.3
