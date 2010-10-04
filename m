From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/14] cifs: eliminate cifsInodeInfo->write_behind_rc
Date: Mon,  4 Oct 2010 13:53:01 -0400
Message-ID: <1286214781-626-15-git-send-email-jlayton@redhat.com>
References: <1286214781-626-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286214781-626-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

write_behind_rc is redundant and just adds complexity to the code. What
we really want to do instead is to use mapping_set_error to reset the
flags on the mapping when we find a writeback error and can't report it
to userspace yet.

For cifs_flush and cifs_fsync, we shouldn't reset the flags since errors
returned there do get reported to userspace.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    1 -
 fs/cifs/cifsglob.h |    1 -
 fs/cifs/file.c     |   31 +++++++------------------------
 fs/cifs/inode.c    |   15 +++++----------
 4 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6e3a69a..8ec650e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -320,7 +320,6 @@ cifs_alloc_inode(struct super_block *sb)
 		return NULL;
 	cifs_inode->cifsAttrs = 0x20;	/* default */
 	cifs_inode->time = 0;
-	cifs_inode->write_behind_rc = 0;
 	/* Until the file is open and we have gotten oplock
 	info back from the server, can not assume caching of
 	file data or metadata */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 06024c5..08187ca 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -415,7 +415,6 @@ struct cifsInodeInfo {
 	struct list_head lockList;
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
 	struct list_head openFileList;
-	int write_behind_rc;
 	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned long time;	/* jiffies of last update/check of inode */
 	bool clientCanCacheRead:1;	/* read oplock */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4298c19..4425a43 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -133,8 +133,7 @@ static inline int cifs_open_inode_helper(struct inode *inode,
 			/* BB no need to lock inode until after invalidate
 			since namei code should already have it locked? */
 			rc = filemap_write_and_wait(inode->i_mapping);
-			if (rc != 0)
-				pCifsInode->write_behind_rc = rc;
+			mapping_set_error(inode->i_mapping, rc);
 		}
 		cFYI(1, "invalidating remote inode since open detected it "
 			 "changed");
@@ -545,8 +544,7 @@ reopen_success:
 	if (pCifsInode) {
 		if (can_flush) {
 			rc = filemap_write_and_wait(inode->i_mapping);
-			if (rc != 0)
-				CIFS_I(inode)->write_behind_rc = rc;
+			mapping_set_error(inode->i_mapping, rc);
 		/* temporarily disable caching while we
 		   go to server to get inode info */
 			pCifsInode->clientCanCacheAll = false;
@@ -1429,12 +1427,7 @@ retry:
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
@@ -1579,10 +1572,8 @@ int cifs_fsync(struct file *file, int datasync)
 
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
@@ -1629,11 +1620,6 @@ int cifs_flush(struct file *file, fl_owner_t id)
 	int rc = 0;
 
 	rc = filemap_write_and_wait(inode->i_mapping);
-	/* reset wb rc if we were able to write out dirty pages */
-	if (!rc) {
-		rc = CIFS_I(inode)->write_behind_rc;
-		CIFS_I(inode)->write_behind_rc = 0;
-	}
 
 	cFYI(1, "Flush inode %p file %p rc %d", inode, file, rc);
 
@@ -2212,7 +2198,7 @@ void cifs_oplock_break(struct work_struct *work)
 						  oplock_break);
 	struct inode *inode = cfile->dentry->d_inode;
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
-	int rc, waitrc = 0;
+	int rc = 0;
 
 	if (inode && S_ISREG(inode->i_mode)) {
 		if (cinode->clientCanCacheRead)
@@ -2221,13 +2207,10 @@ void cifs_oplock_break(struct work_struct *work)
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
index d6db805..c6aa014 100644
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
@@ -1941,10 +1940,8 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
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
@@ -2085,10 +2082,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
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
