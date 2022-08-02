Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B334C00140
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 16:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiHBQYP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 12:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiHBQYO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 12:24:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4CC1CFE2
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 09:24:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 88F8A34153;
        Tue,  2 Aug 2022 16:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659457448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9PDLbrfC5syzBc1Oh0c7X26pLpRsDZPGSSlEtCbjwvE=;
        b=cPFzYW5WnVQ1yuKcBO5ESHeU36zIPR6+mBg2kyy9ckLhVWp0YhLNl+OLTghfwHKbuFwkpj
        B9ABNwRIKc9ZAddWzVlnlBI/VXO+xTlEtABMTHDgbUqZG0E0qrsPQ6mvYNI113NMHNnZyS
        KmB7zrvOo0kswBrrkkunjXLU+Ujw9Q4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659457448;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9PDLbrfC5syzBc1Oh0c7X26pLpRsDZPGSSlEtCbjwvE=;
        b=6p3AiWKO95+7HEc6jnHxZuDP0+qbosOH1mCle7BXgZbmzlFY184Q8aF6r91Xnh6X2O11p/
        FNk+0tne6gL7N3CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 79CAF13A8E;
        Tue,  2 Aug 2022 16:24:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QeS5DqdP6WILKAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 02 Aug 2022 16:24:07 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH v2] cifs: distribute some bloat out of cifsfs.{c,h}
Date:   Tue,  2 Aug 2022 13:20:10 -0300
Message-Id: <20220802162009.5688-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Leave cifsfs.{c,h} with crucial code only, while making it easier
to identify what to move/remove from dir/file/inode re: SMB1 split.

Make some of the moved functions/structs static.

Introduce file.h and inode.h, which holds only the necessary
prototypes for their .c counterparts.

Fix a small build warning on ioctl.c when
CONFIG_CIFS_ALLOW_INSECURE_LEGACY is disabled.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2:
- Fix warnings by kernel test robot
- Introduce file.h and inode.h
- Fix ioctl.c build warning (when legacy dialects is disabled)
- Functions that are no longer needed in different objects were made
  static

 fs/cifs/cifsfs.c    | 588 -----------------------------------
 fs/cifs/cifsfs.h    |  50 +--
 fs/cifs/cifsproto.h |   1 -
 fs/cifs/dir.c       | 619 ++-----------------------------------
 fs/cifs/file.c      | 408 +++++++++++++++++++++++-
 fs/cifs/file.h      |  38 +++
 fs/cifs/inode.c     | 738 +++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/inode.h     |  32 ++
 fs/cifs/ioctl.c     |   9 +-
 9 files changed, 1245 insertions(+), 1238 deletions(-)
 create mode 100644 fs/cifs/file.h
 create mode 100644 fs/cifs/inode.h

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index af4c5632490e..dc0c814ca781 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -349,38 +349,6 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return rc;
 }
 
-static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
-{
-	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-	struct TCP_Server_Info *server = tcon->ses->server;
-
-	if (server->ops->fallocate)
-		return server->ops->fallocate(file, tcon, mode, off, len);
-
-	return -EOPNOTSUPP;
-}
-
-static int cifs_permission(struct user_namespace *mnt_userns,
-			   struct inode *inode, int mask)
-{
-	struct cifs_sb_info *cifs_sb;
-
-	cifs_sb = CIFS_SB(inode->i_sb);
-
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) {
-		if ((mask & MAY_EXEC) && !execute_ok(inode))
-			return -EACCES;
-		else
-			return 0;
-	} else /* file mode might have been restricted at mount time
-		on the client (above and beyond ACL on servers) for
-		servers which do not support setting and viewing mode bits,
-		so allowing client to check permissions is useful */
-		return generic_permission(&init_user_ns, inode, mask);
-}
-
-static struct kmem_cache *cifs_inode_cachep;
 static struct kmem_cache *cifs_req_cachep;
 static struct kmem_cache *cifs_mid_cachep;
 static struct kmem_cache *cifs_sm_req_cachep;
@@ -388,59 +356,6 @@ mempool_t *cifs_sm_req_poolp;
 mempool_t *cifs_req_poolp;
 mempool_t *cifs_mid_poolp;
 
-static struct inode *
-cifs_alloc_inode(struct super_block *sb)
-{
-	struct cifsInodeInfo *cifs_inode;
-	cifs_inode = alloc_inode_sb(sb, cifs_inode_cachep, GFP_KERNEL);
-	if (!cifs_inode)
-		return NULL;
-	cifs_inode->cifsAttrs = 0x20;	/* default */
-	cifs_inode->time = 0;
-	/*
-	 * Until the file is open and we have gotten oplock info back from the
-	 * server, can not assume caching of file data or metadata.
-	 */
-	cifs_set_oplock_level(cifs_inode, 0);
-	cifs_inode->flags = 0;
-	spin_lock_init(&cifs_inode->writers_lock);
-	cifs_inode->writers = 0;
-	cifs_inode->netfs.inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
-	cifs_inode->server_eof = 0;
-	cifs_inode->uniqueid = 0;
-	cifs_inode->createtime = 0;
-	cifs_inode->epoch = 0;
-	spin_lock_init(&cifs_inode->open_file_lock);
-	generate_random_uuid(cifs_inode->lease_key);
-
-	/*
-	 * Can not set i_flags here - they get immediately overwritten to zero
-	 * by the VFS.
-	 */
-	/* cifs_inode->netfs.inode.i_flags = S_NOATIME | S_NOCMTIME; */
-	INIT_LIST_HEAD(&cifs_inode->openFileList);
-	INIT_LIST_HEAD(&cifs_inode->llist);
-	INIT_LIST_HEAD(&cifs_inode->deferred_closes);
-	spin_lock_init(&cifs_inode->deferred_lock);
-	return &cifs_inode->netfs.inode;
-}
-
-static void
-cifs_free_inode(struct inode *inode)
-{
-	kmem_cache_free(cifs_inode_cachep, CIFS_I(inode));
-}
-
-static void
-cifs_evict_inode(struct inode *inode)
-{
-	truncate_inode_pages_final(&inode->i_data);
-	if (inode->i_state & I_PINNING_FSCACHE_WB)
-		cifs_fscache_unuse_inode_cookie(inode, true);
-	cifs_fscache_release_inode_cookie(inode);
-	clear_inode(inode);
-}
-
 static void
 cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 {
@@ -767,21 +682,6 @@ static int cifs_show_stats(struct seq_file *s, struct dentry *root)
 }
 #endif
 
-static int cifs_write_inode(struct inode *inode, struct writeback_control *wbc)
-{
-	fscache_unpin_writeback(wbc, cifs_inode_cookie(inode));
-	return 0;
-}
-
-static int cifs_drop_inode(struct inode *inode)
-{
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-
-	/* no serverino => unconditional eviction */
-	return !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ||
-		generic_drop_inode(inode);
-}
-
 static const struct super_operations cifs_super_ops = {
 	.statfs = cifs_statfs,
 	.alloc_inode = cifs_alloc_inode,
@@ -789,12 +689,7 @@ static const struct super_operations cifs_super_ops = {
 	.free_inode = cifs_free_inode,
 	.drop_inode	= cifs_drop_inode,
 	.evict_inode	= cifs_evict_inode,
-/*	.show_path	= cifs_show_path, */ /* Would we ever need show path? */
 	.show_devname   = cifs_show_devname,
-/*	.delete_inode	= cifs_delete_inode,  */  /* Do not need above
-	function unless later we add lazy close of inodes or unless the
-	kernel forgets to call us with the same number of releases (closes)
-	as opens */
 	.show_options = cifs_show_options,
 	.umount_begin   = cifs_umount_begin,
 #ifdef CONFIG_CIFS_STATS2
@@ -974,139 +869,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	return root;
 }
 
-
-static ssize_t
-cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
-{
-	ssize_t rc;
-	struct inode *inode = file_inode(iocb->ki_filp);
-
-	if (iocb->ki_flags & IOCB_DIRECT)
-		return cifs_user_readv(iocb, iter);
-
-	rc = cifs_revalidate_mapping(inode);
-	if (rc)
-		return rc;
-
-	return generic_file_read_iter(iocb, iter);
-}
-
-static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
-{
-	struct inode *inode = file_inode(iocb->ki_filp);
-	struct cifsInodeInfo *cinode = CIFS_I(inode);
-	ssize_t written;
-	int rc;
-
-	if (iocb->ki_filp->f_flags & O_DIRECT) {
-		written = cifs_user_writev(iocb, from);
-		if (written > 0 && CIFS_CACHE_READ(cinode)) {
-			cifs_zap_mapping(inode);
-			cifs_dbg(FYI,
-				 "Set no oplock for inode=%p after a write operation\n",
-				 inode);
-			cinode->oplock = 0;
-		}
-		return written;
-	}
-
-	written = cifs_get_writer(cinode);
-	if (written)
-		return written;
-
-	written = generic_file_write_iter(iocb, from);
-
-	if (CIFS_CACHE_WRITE(CIFS_I(inode)))
-		goto out;
-
-	rc = filemap_fdatawrite(inode->i_mapping);
-	if (rc)
-		cifs_dbg(FYI, "cifs_file_write_iter: %d rc on %p inode\n",
-			 rc, inode);
-
-out:
-	cifs_put_writer(cinode);
-	return written;
-}
-
-static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
-{
-	struct cifsFileInfo *cfile = file->private_data;
-	struct cifs_tcon *tcon;
-
-	/*
-	 * whence == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
-	 * the cached file length
-	 */
-	if (whence != SEEK_SET && whence != SEEK_CUR) {
-		int rc;
-		struct inode *inode = file_inode(file);
-
-		/*
-		 * We need to be sure that all dirty pages are written and the
-		 * server has the newest file length.
-		 */
-		if (!CIFS_CACHE_READ(CIFS_I(inode)) && inode->i_mapping &&
-		    inode->i_mapping->nrpages != 0) {
-			rc = filemap_fdatawait(inode->i_mapping);
-			if (rc) {
-				mapping_set_error(inode->i_mapping, rc);
-				return rc;
-			}
-		}
-		/*
-		 * Some applications poll for the file length in this strange
-		 * way so we must seek to end on non-oplocked files by
-		 * setting the revalidate time to zero.
-		 */
-		CIFS_I(inode)->time = 0;
-
-		rc = cifs_revalidate_file_attr(file);
-		if (rc < 0)
-			return (loff_t)rc;
-	}
-	if (cfile && cfile->tlink) {
-		tcon = tlink_tcon(cfile->tlink);
-		if (tcon->ses->server->ops->llseek)
-			return tcon->ses->server->ops->llseek(file, tcon,
-							      offset, whence);
-	}
-	return generic_file_llseek(file, offset, whence);
-}
-
-static int
-cifs_setlease(struct file *file, long arg, struct file_lock **lease, void **priv)
-{
-	/*
-	 * Note that this is called by vfs setlease with i_lock held to
-	 * protect *lease from going away.
-	 */
-	struct inode *inode = file_inode(file);
-	struct cifsFileInfo *cfile = file->private_data;
-
-	if (!(S_ISREG(inode->i_mode)))
-		return -EINVAL;
-
-	/* Check if file is oplocked if this is request for new lease */
-	if (arg == F_UNLCK ||
-	    ((arg == F_RDLCK) && CIFS_CACHE_READ(CIFS_I(inode))) ||
-	    ((arg == F_WRLCK) && CIFS_CACHE_WRITE(CIFS_I(inode))))
-		return generic_setlease(file, arg, lease, priv);
-	else if (tlink_tcon(cfile->tlink)->local_lease &&
-		 !CIFS_CACHE_READ(CIFS_I(inode)))
-		/*
-		 * If the server claims to support oplock on this file, then we
-		 * still need to check oplock even if the local_lease mount
-		 * option is set, but there are servers which do not support
-		 * oplock for which this mount option may be useful if the user
-		 * knows that the file won't be changed on the server by anyone
-		 * else.
-		 */
-		return generic_setlease(file, arg, lease, priv);
-	else
-		return -EAGAIN;
-}
-
 struct file_system_type cifs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "cifs",
@@ -1128,356 +890,6 @@ struct file_system_type smb3_fs_type = {
 MODULE_ALIAS_FS("smb3");
 MODULE_ALIAS("smb3");
 
-const struct inode_operations cifs_dir_inode_ops = {
-	.create = cifs_create,
-	.atomic_open = cifs_atomic_open,
-	.lookup = cifs_lookup,
-	.getattr = cifs_getattr,
-	.unlink = cifs_unlink,
-	.link = cifs_hardlink,
-	.mkdir = cifs_mkdir,
-	.rmdir = cifs_rmdir,
-	.rename = cifs_rename2,
-	.permission = cifs_permission,
-	.setattr = cifs_setattr,
-	.symlink = cifs_symlink,
-	.mknod   = cifs_mknod,
-	.listxattr = cifs_listxattr,
-};
-
-const struct inode_operations cifs_file_inode_ops = {
-	.setattr = cifs_setattr,
-	.getattr = cifs_getattr,
-	.permission = cifs_permission,
-	.listxattr = cifs_listxattr,
-	.fiemap = cifs_fiemap,
-};
-
-const struct inode_operations cifs_symlink_inode_ops = {
-	.get_link = cifs_get_link,
-	.permission = cifs_permission,
-	.listxattr = cifs_listxattr,
-};
-
-static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
-		struct file *dst_file, loff_t destoff, loff_t len,
-		unsigned int remap_flags)
-{
-	struct inode *src_inode = file_inode(src_file);
-	struct inode *target_inode = file_inode(dst_file);
-	struct cifsFileInfo *smb_file_src = src_file->private_data;
-	struct cifsFileInfo *smb_file_target;
-	struct cifs_tcon *target_tcon;
-	unsigned int xid;
-	int rc;
-
-	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
-		return -EINVAL;
-
-	cifs_dbg(FYI, "clone range\n");
-
-	xid = get_xid();
-
-	if (!src_file->private_data || !dst_file->private_data) {
-		rc = -EBADF;
-		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
-		goto out;
-	}
-
-	smb_file_target = dst_file->private_data;
-	target_tcon = tlink_tcon(smb_file_target->tlink);
-
-	/*
-	 * Note: cifs case is easier than btrfs since server responsible for
-	 * checks for proper open modes and file type and if it wants
-	 * server could even support copy of range where source = target
-	 */
-	lock_two_nondirectories(target_inode, src_inode);
-
-	if (len == 0)
-		len = src_inode->i_size - off;
-
-	cifs_dbg(FYI, "about to flush pages\n");
-	/* should we flush first and last page first */
-	truncate_inode_pages_range(&target_inode->i_data, destoff,
-				   PAGE_ALIGN(destoff + len)-1);
-
-	if (target_tcon->ses->server->ops->duplicate_extents)
-		rc = target_tcon->ses->server->ops->duplicate_extents(xid,
-			smb_file_src, smb_file_target, off, len, destoff);
-	else
-		rc = -EOPNOTSUPP;
-
-	/* force revalidate of size and timestamps of target file now
-	   that target is updated on the server */
-	CIFS_I(target_inode)->time = 0;
-	/* although unlocking in the reverse order from locking is not
-	   strictly necessary here it is a little cleaner to be consistent */
-	unlock_two_nondirectories(src_inode, target_inode);
-out:
-	free_xid(xid);
-	return rc < 0 ? rc : len;
-}
-
-ssize_t cifs_file_copychunk_range(unsigned int xid,
-				struct file *src_file, loff_t off,
-				struct file *dst_file, loff_t destoff,
-				size_t len, unsigned int flags)
-{
-	struct inode *src_inode = file_inode(src_file);
-	struct inode *target_inode = file_inode(dst_file);
-	struct cifsFileInfo *smb_file_src;
-	struct cifsFileInfo *smb_file_target;
-	struct cifs_tcon *src_tcon;
-	struct cifs_tcon *target_tcon;
-	ssize_t rc;
-
-	cifs_dbg(FYI, "copychunk range\n");
-
-	if (!src_file->private_data || !dst_file->private_data) {
-		rc = -EBADF;
-		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
-		goto out;
-	}
-
-	rc = -EXDEV;
-	smb_file_target = dst_file->private_data;
-	smb_file_src = src_file->private_data;
-	src_tcon = tlink_tcon(smb_file_src->tlink);
-	target_tcon = tlink_tcon(smb_file_target->tlink);
-
-	if (src_tcon->ses != target_tcon->ses) {
-		cifs_dbg(VFS, "source and target of copy not on same server\n");
-		goto out;
-	}
-
-	rc = -EOPNOTSUPP;
-	if (!target_tcon->ses->server->ops->copychunk_range)
-		goto out;
-
-	/*
-	 * Note: cifs case is easier than btrfs since server responsible for
-	 * checks for proper open modes and file type and if it wants
-	 * server could even support copy of range where source = target
-	 */
-	lock_two_nondirectories(target_inode, src_inode);
-
-	cifs_dbg(FYI, "about to flush pages\n");
-	/* should we flush first and last page first */
-	truncate_inode_pages(&target_inode->i_data, 0);
-
-	rc = file_modified(dst_file);
-	if (!rc)
-		rc = target_tcon->ses->server->ops->copychunk_range(xid,
-			smb_file_src, smb_file_target, off, len, destoff);
-
-	file_accessed(src_file);
-
-	/* force revalidate of size and timestamps of target file now
-	 * that target is updated on the server
-	 */
-	CIFS_I(target_inode)->time = 0;
-	/* although unlocking in the reverse order from locking is not
-	 * strictly necessary here it is a little cleaner to be consistent
-	 */
-	unlock_two_nondirectories(src_inode, target_inode);
-
-out:
-	return rc;
-}
-
-/*
- * Directory operations under CIFS/SMB2/SMB3 are synchronous, so fsync()
- * is a dummy operation.
- */
-static int cifs_dir_fsync(struct file *file, loff_t start, loff_t end, int datasync)
-{
-	cifs_dbg(FYI, "Sync directory - name: %pD datasync: 0x%x\n",
-		 file, datasync);
-
-	return 0;
-}
-
-static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
-				struct file *dst_file, loff_t destoff,
-				size_t len, unsigned int flags)
-{
-	unsigned int xid = get_xid();
-	ssize_t rc;
-	struct cifsFileInfo *cfile = dst_file->private_data;
-
-	if (cfile->swapfile)
-		return -EOPNOTSUPP;
-
-	rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
-					len, flags);
-	free_xid(xid);
-
-	if (rc == -EOPNOTSUPP || rc == -EXDEV)
-		rc = generic_copy_file_range(src_file, off, dst_file,
-					     destoff, len, flags);
-	return rc;
-}
-
-const struct file_operations cifs_file_ops = {
-	.read_iter = cifs_loose_read_iter,
-	.write_iter = cifs_file_write_iter,
-	.open = cifs_open,
-	.release = cifs_close,
-	.lock = cifs_lock,
-	.flock = cifs_flock,
-	.fsync = cifs_fsync,
-	.flush = cifs_flush,
-	.mmap  = cifs_file_mmap,
-	.splice_read = generic_file_splice_read,
-	.splice_write = iter_file_splice_write,
-	.llseek = cifs_llseek,
-	.unlocked_ioctl	= cifs_ioctl,
-	.copy_file_range = cifs_copy_file_range,
-	.remap_file_range = cifs_remap_file_range,
-	.setlease = cifs_setlease,
-	.fallocate = cifs_fallocate,
-};
-
-const struct file_operations cifs_file_strict_ops = {
-	.read_iter = cifs_strict_readv,
-	.write_iter = cifs_strict_writev,
-	.open = cifs_open,
-	.release = cifs_close,
-	.lock = cifs_lock,
-	.flock = cifs_flock,
-	.fsync = cifs_strict_fsync,
-	.flush = cifs_flush,
-	.mmap = cifs_file_strict_mmap,
-	.splice_read = generic_file_splice_read,
-	.splice_write = iter_file_splice_write,
-	.llseek = cifs_llseek,
-	.unlocked_ioctl	= cifs_ioctl,
-	.copy_file_range = cifs_copy_file_range,
-	.remap_file_range = cifs_remap_file_range,
-	.setlease = cifs_setlease,
-	.fallocate = cifs_fallocate,
-};
-
-const struct file_operations cifs_file_direct_ops = {
-	.read_iter = cifs_direct_readv,
-	.write_iter = cifs_direct_writev,
-	.open = cifs_open,
-	.release = cifs_close,
-	.lock = cifs_lock,
-	.flock = cifs_flock,
-	.fsync = cifs_fsync,
-	.flush = cifs_flush,
-	.mmap = cifs_file_mmap,
-	.splice_read = generic_file_splice_read,
-	.splice_write = iter_file_splice_write,
-	.unlocked_ioctl  = cifs_ioctl,
-	.copy_file_range = cifs_copy_file_range,
-	.remap_file_range = cifs_remap_file_range,
-	.llseek = cifs_llseek,
-	.setlease = cifs_setlease,
-	.fallocate = cifs_fallocate,
-};
-
-const struct file_operations cifs_file_nobrl_ops = {
-	.read_iter = cifs_loose_read_iter,
-	.write_iter = cifs_file_write_iter,
-	.open = cifs_open,
-	.release = cifs_close,
-	.fsync = cifs_fsync,
-	.flush = cifs_flush,
-	.mmap  = cifs_file_mmap,
-	.splice_read = generic_file_splice_read,
-	.splice_write = iter_file_splice_write,
-	.llseek = cifs_llseek,
-	.unlocked_ioctl	= cifs_ioctl,
-	.copy_file_range = cifs_copy_file_range,
-	.remap_file_range = cifs_remap_file_range,
-	.setlease = cifs_setlease,
-	.fallocate = cifs_fallocate,
-};
-
-const struct file_operations cifs_file_strict_nobrl_ops = {
-	.read_iter = cifs_strict_readv,
-	.write_iter = cifs_strict_writev,
-	.open = cifs_open,
-	.release = cifs_close,
-	.fsync = cifs_strict_fsync,
-	.flush = cifs_flush,
-	.mmap = cifs_file_strict_mmap,
-	.splice_read = generic_file_splice_read,
-	.splice_write = iter_file_splice_write,
-	.llseek = cifs_llseek,
-	.unlocked_ioctl	= cifs_ioctl,
-	.copy_file_range = cifs_copy_file_range,
-	.remap_file_range = cifs_remap_file_range,
-	.setlease = cifs_setlease,
-	.fallocate = cifs_fallocate,
-};
-
-const struct file_operations cifs_file_direct_nobrl_ops = {
-	.read_iter = cifs_direct_readv,
-	.write_iter = cifs_direct_writev,
-	.open = cifs_open,
-	.release = cifs_close,
-	.fsync = cifs_fsync,
-	.flush = cifs_flush,
-	.mmap = cifs_file_mmap,
-	.splice_read = generic_file_splice_read,
-	.splice_write = iter_file_splice_write,
-	.unlocked_ioctl  = cifs_ioctl,
-	.copy_file_range = cifs_copy_file_range,
-	.remap_file_range = cifs_remap_file_range,
-	.llseek = cifs_llseek,
-	.setlease = cifs_setlease,
-	.fallocate = cifs_fallocate,
-};
-
-const struct file_operations cifs_dir_ops = {
-	.iterate_shared = cifs_readdir,
-	.release = cifs_closedir,
-	.read    = generic_read_dir,
-	.unlocked_ioctl  = cifs_ioctl,
-	.copy_file_range = cifs_copy_file_range,
-	.remap_file_range = cifs_remap_file_range,
-	.llseek = generic_file_llseek,
-	.fsync = cifs_dir_fsync,
-};
-
-static void
-cifs_init_once(void *inode)
-{
-	struct cifsInodeInfo *cifsi = inode;
-
-	inode_init_once(&cifsi->netfs.inode);
-	init_rwsem(&cifsi->lock_sem);
-}
-
-static int __init
-cifs_init_inodecache(void)
-{
-	cifs_inode_cachep = kmem_cache_create("cifs_inode_cache",
-					      sizeof(struct cifsInodeInfo),
-					      0, (SLAB_RECLAIM_ACCOUNT|
-						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
-					      cifs_init_once);
-	if (cifs_inode_cachep == NULL)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void
-cifs_destroy_inodecache(void)
-{
-	/*
-	 * Make sure all delayed rcu free inodes are flushed before we
-	 * destroy cache.
-	 */
-	rcu_barrier();
-	kmem_cache_destroy(cifs_inode_cachep);
-}
-
 static int
 cifs_init_request_bufs(void)
 {
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 81f4c15936d0..a2d64c0ac616 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -10,6 +10,8 @@
 #define _CIFSFS_H
 
 #include <linux/hash.h>
+#include "inode.h"
+#include "file.h"
 
 #define ROOT_I 2
 
@@ -47,29 +49,14 @@ extern void cifs_sb_active(struct super_block *sb);
 extern void cifs_sb_deactive(struct super_block *sb);
 
 /* Functions related to inodes */
-extern const struct inode_operations cifs_dir_inode_ops;
 extern struct inode *cifs_root_iget(struct super_block *);
-extern int cifs_create(struct user_namespace *, struct inode *,
-		       struct dentry *, umode_t, bool excl);
-extern int cifs_atomic_open(struct inode *, struct dentry *,
-			    struct file *, unsigned, umode_t);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
 				  unsigned int);
-extern int cifs_unlink(struct inode *dir, struct dentry *dentry);
 extern int cifs_hardlink(struct dentry *, struct inode *, struct dentry *);
-extern int cifs_mknod(struct user_namespace *, struct inode *, struct dentry *,
-		      umode_t, dev_t);
-extern int cifs_mkdir(struct user_namespace *, struct inode *, struct dentry *,
-		      umode_t);
-extern int cifs_rmdir(struct inode *, struct dentry *);
-extern int cifs_rename2(struct user_namespace *, struct inode *,
-			struct dentry *, struct inode *, struct dentry *,
-			unsigned int);
 extern int cifs_revalidate_file_attr(struct file *filp);
 extern int cifs_revalidate_dentry_attr(struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
 extern int cifs_revalidate_dentry(struct dentry *);
-extern int cifs_invalidate_mapping(struct inode *inode);
 extern int cifs_revalidate_mapping(struct inode *inode);
 extern int cifs_zap_mapping(struct inode *inode);
 extern int cifs_getattr(struct user_namespace *, const struct path *,
@@ -79,34 +66,8 @@ extern int cifs_setattr(struct user_namespace *, struct dentry *,
 extern int cifs_fiemap(struct inode *, struct fiemap_extent_info *, u64 start,
 		       u64 len);
 
-extern const struct inode_operations cifs_file_inode_ops;
-extern const struct inode_operations cifs_symlink_inode_ops;
-extern const struct inode_operations cifs_dfs_referral_inode_operations;
-
-
 /* Functions related to files and directories */
-extern const struct file_operations cifs_file_ops;
-extern const struct file_operations cifs_file_direct_ops; /* if directio mnt */
-extern const struct file_operations cifs_file_strict_ops; /* if strictio mnt */
-extern const struct file_operations cifs_file_nobrl_ops; /* no brlocks */
-extern const struct file_operations cifs_file_direct_nobrl_ops;
-extern const struct file_operations cifs_file_strict_nobrl_ops;
-extern int cifs_open(struct inode *inode, struct file *file);
-extern int cifs_close(struct inode *inode, struct file *file);
 extern int cifs_closedir(struct inode *inode, struct file *file);
-extern ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to);
-extern ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to);
-extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to);
-extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from);
-extern ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from);
-extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from);
-extern int cifs_flock(struct file *pfile, int cmd, struct file_lock *plock);
-extern int cifs_lock(struct file *, int, struct file_lock *);
-extern int cifs_fsync(struct file *, loff_t, loff_t, int);
-extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
-extern int cifs_flush(struct file *, fl_owner_t id);
-extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
-extern int cifs_file_strict_mmap(struct file * , struct vm_area_struct *);
 extern const struct file_operations cifs_dir_ops;
 extern int cifs_dir_open(struct inode *inode, struct file *file);
 extern int cifs_readdir(struct file *file, struct dir_context *ctx);
@@ -135,14 +96,7 @@ extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
 # define cifs_listxattr NULL
 #endif
 
-extern ssize_t cifs_file_copychunk_range(unsigned int xid,
-					struct file *src_file, loff_t off,
-					struct file *dst_file, loff_t destoff,
-					size_t len, unsigned int flags);
-
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
-extern void cifs_setsize(struct inode *inode, loff_t offset);
-extern int cifs_truncate_page(struct address_space *mapping, loff_t from);
 
 struct smb3_fs_context;
 extern struct dentry *cifs_smb3_do_mount(struct file_system_type *fs_type,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index de167e3af015..5b4358d5a412 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -78,7 +78,6 @@ extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
 		char **devname);
-/* extern void renew_parental_timestamps(struct dentry *direntry);*/
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 08f7392716e2..36e90c9da385 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -23,17 +23,7 @@
 #include "fs_context.h"
 #include "cifs_ioctl.h"
 #include "fscache.h"
-
-static void
-renew_parental_timestamps(struct dentry *direntry)
-{
-	/* BB check if there is a way to get the kernel to do this or if we
-	   really need this */
-	do {
-		cifs_set_time(direntry, jiffies);
-		direntry = direntry->d_parent;
-	} while (!IS_ROOT(direntry));
-}
+#include "file.h"
 
 char *
 cifs_build_path_to_root(struct smb3_fs_context *ctx, struct cifs_sb_info *cifs_sb,
@@ -135,580 +125,6 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	return s;
 }
 
-/*
- * Don't allow path components longer than the server max.
- * Don't allow the separator character in a path component.
- * The VFS will not allow "/", but "\" is allowed by posix.
- */
-static int
-check_name(struct dentry *direntry, struct cifs_tcon *tcon)
-{
-	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
-	int i;
-
-	if (unlikely(tcon->fsAttrInfo.MaxPathNameComponentLength &&
-		     direntry->d_name.len >
-		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
-		return -ENAMETOOLONG;
-
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
-		for (i = 0; i < direntry->d_name.len; i++) {
-			if (direntry->d_name.name[i] == '\\') {
-				cifs_dbg(FYI, "Invalid file name\n");
-				return -EINVAL;
-			}
-		}
-	}
-	return 0;
-}
-
-
-/* Inode operations in similar order to how they appear in Linux file fs.h */
-
-static int
-cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
-	       struct tcon_link *tlink, unsigned oflags, umode_t mode,
-	       __u32 *oplock, struct cifs_fid *fid)
-{
-	int rc = -ENOENT;
-	int create_options = CREATE_NOT_DIR;
-	int desired_access;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct cifs_tcon *tcon = tlink_tcon(tlink);
-	const char *full_path;
-	void *page = alloc_dentry_path();
-	FILE_ALL_INFO *buf = NULL;
-	struct inode *newinode = NULL;
-	int disposition;
-	struct TCP_Server_Info *server = tcon->ses->server;
-	struct cifs_open_parms oparms;
-
-	*oplock = 0;
-	if (tcon->ses->server->oplocks)
-		*oplock = REQ_OPLOCK;
-
-	full_path = build_path_from_dentry(direntry, page);
-	if (IS_ERR(full_path)) {
-		free_dentry_path(page);
-		return PTR_ERR(full_path);
-	}
-
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
-	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
-			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
-		rc = cifs_posix_open(full_path, &newinode, inode->i_sb, mode,
-				     oflags, oplock, &fid->netfid, xid);
-		switch (rc) {
-		case 0:
-			if (newinode == NULL) {
-				/* query inode info */
-				goto cifs_create_get_file_info;
-			}
-
-			if (S_ISDIR(newinode->i_mode)) {
-				CIFSSMBClose(xid, tcon, fid->netfid);
-				iput(newinode);
-				rc = -EISDIR;
-				goto out;
-			}
-
-			if (!S_ISREG(newinode->i_mode)) {
-				/*
-				 * The server may allow us to open things like
-				 * FIFOs, but the client isn't set up to deal
-				 * with that. If it's not a regular file, just
-				 * close it and proceed as if it were a normal
-				 * lookup.
-				 */
-				CIFSSMBClose(xid, tcon, fid->netfid);
-				goto cifs_create_get_file_info;
-			}
-			/* success, no need to query */
-			goto cifs_create_set_dentry;
-
-		case -ENOENT:
-			goto cifs_create_get_file_info;
-
-		case -EIO:
-		case -EINVAL:
-			/*
-			 * EIO could indicate that (posix open) operation is not
-			 * supported, despite what server claimed in capability
-			 * negotiation.
-			 *
-			 * POSIX open in samba versions 3.3.1 and earlier could
-			 * incorrectly fail with invalid parameter.
-			 */
-			tcon->broken_posix_open = true;
-			break;
-
-		case -EREMOTE:
-		case -EOPNOTSUPP:
-			/*
-			 * EREMOTE indicates DFS junction, which is not handled
-			 * in posix open.  If either that or op not supported
-			 * returned, follow the normal lookup.
-			 */
-			break;
-
-		default:
-			goto out;
-		}
-		/*
-		 * fallthrough to retry, using older open call, this is case
-		 * where server does not support this SMB level, and falsely
-		 * claims capability (also get here for DFS case which should be
-		 * rare for path not covered on files)
-		 */
-	}
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-
-	desired_access = 0;
-	if (OPEN_FMODE(oflags) & FMODE_READ)
-		desired_access |= GENERIC_READ; /* is this too little? */
-	if (OPEN_FMODE(oflags) & FMODE_WRITE)
-		desired_access |= GENERIC_WRITE;
-
-	disposition = FILE_OVERWRITE_IF;
-	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
-		disposition = FILE_CREATE;
-	else if ((oflags & (O_CREAT | O_TRUNC)) == (O_CREAT | O_TRUNC))
-		disposition = FILE_OVERWRITE_IF;
-	else if ((oflags & O_CREAT) == O_CREAT)
-		disposition = FILE_OPEN_IF;
-	else
-		cifs_dbg(FYI, "Create flag not set in create function\n");
-
-	/*
-	 * BB add processing to set equivalent of mode - e.g. via CreateX with
-	 * ACLs
-	 */
-
-	if (!server->ops->open) {
-		rc = -ENOSYS;
-		goto out;
-	}
-
-	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (buf == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	/*
-	 * if we're not using unix extensions, see if we need to set
-	 * ATTR_READONLY on the create call
-	 */
-	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
-		create_options |= CREATE_OPTION_READONLY;
-
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = desired_access;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.disposition = disposition;
-	oparms.path = full_path;
-	oparms.fid = fid;
-	oparms.reconnect = false;
-	oparms.mode = mode;
-	rc = server->ops->open(xid, &oparms, oplock, buf);
-	if (rc) {
-		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
-		goto out;
-	}
-
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	/*
-	 * If Open reported that we actually created a file then we now have to
-	 * set the mode if possible.
-	 */
-	if ((tcon->unix_ext) && (*oplock & CIFS_CREATE_ACTION)) {
-		struct cifs_unix_set_info_args args = {
-				.mode	= mode,
-				.ctime	= NO_CHANGE_64,
-				.atime	= NO_CHANGE_64,
-				.mtime	= NO_CHANGE_64,
-				.device	= 0,
-		};
-
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-			args.uid = current_fsuid();
-			if (inode->i_mode & S_ISGID)
-				args.gid = inode->i_gid;
-			else
-				args.gid = current_fsgid();
-		} else {
-			args.uid = INVALID_UID; /* no change */
-			args.gid = INVALID_GID; /* no change */
-		}
-		CIFSSMBUnixSetFileInfo(xid, tcon, &args, fid->netfid,
-				       current->tgid);
-	} else {
-		/*
-		 * BB implement mode setting via Windows security
-		 * descriptors e.g.
-		 */
-		/* CIFSSMBWinSetPerms(xid,tcon,path,mode,-1,-1,nls);*/
-
-		/* Could set r/o dos attribute if mode & 0222 == 0 */
-	}
-
-cifs_create_get_file_info:
-	/* server might mask mode so we have to query for it */
-	if (tcon->unix_ext)
-		rc = cifs_get_inode_info_unix(&newinode, full_path, inode->i_sb,
-					      xid);
-	else {
-#else
-	{
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-		/* TODO: Add support for calling POSIX query info here, but passing in fid */
-		rc = cifs_get_inode_info(&newinode, full_path, buf, inode->i_sb,
-					 xid, fid);
-		if (newinode) {
-			if (server->ops->set_lease_key)
-				server->ops->set_lease_key(newinode, fid);
-			if ((*oplock & CIFS_CREATE_ACTION) && S_ISREG(newinode->i_mode)) {
-				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
-					newinode->i_mode = mode;
-				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
-					newinode->i_uid = current_fsuid();
-					if (inode->i_mode & S_ISGID)
-						newinode->i_gid = inode->i_gid;
-					else
-						newinode->i_gid = current_fsgid();
-				}
-			}
-		}
-	}
-
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-cifs_create_set_dentry:
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-	if (rc != 0) {
-		cifs_dbg(FYI, "Create worked, get_inode_info failed rc = %d\n",
-			 rc);
-		goto out_err;
-	}
-
-	if (newinode)
-		if (S_ISDIR(newinode->i_mode)) {
-			rc = -EISDIR;
-			goto out_err;
-		}
-
-	d_drop(direntry);
-	d_add(direntry, newinode);
-
-out:
-	kfree(buf);
-	free_dentry_path(page);
-	return rc;
-
-out_err:
-	if (server->ops->close)
-		server->ops->close(xid, tcon, fid);
-	if (newinode)
-		iput(newinode);
-	goto out;
-}
-
-int
-cifs_atomic_open(struct inode *inode, struct dentry *direntry,
-		 struct file *file, unsigned oflags, umode_t mode)
-{
-	int rc;
-	unsigned int xid;
-	struct tcon_link *tlink;
-	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
-	struct cifs_fid fid;
-	struct cifs_pending_open open;
-	__u32 oplock;
-	struct cifsFileInfo *file_info;
-
-	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
-		return -EIO;
-
-	/*
-	 * Posix open is only called (at lookup time) for file create now. For
-	 * opens (rather than creates), because we do not know if it is a file
-	 * or directory yet, and current Samba no longer allows us to do posix
-	 * open on dirs, we could end up wasting an open call on what turns out
-	 * to be a dir. For file opens, we wait to call posix open till
-	 * cifs_open.  It could be added to atomic_open in the future but the
-	 * performance tradeoff of the extra network request when EISDIR or
-	 * EACCES is returned would have to be weighed against the 50% reduction
-	 * in network traffic in the other paths.
-	 */
-	if (!(oflags & O_CREAT)) {
-		struct dentry *res;
-
-		/*
-		 * Check for hashed negative dentry. We have already revalidated
-		 * the dentry and it is fine. No need to perform another lookup.
-		 */
-		if (!d_in_lookup(direntry))
-			return -ENOENT;
-
-		res = cifs_lookup(inode, direntry, 0);
-		if (IS_ERR(res))
-			return PTR_ERR(res);
-
-		return finish_no_open(file, res);
-	}
-
-	xid = get_xid();
-
-	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
-		 inode, direntry, direntry);
-
-	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
-	if (IS_ERR(tlink)) {
-		rc = PTR_ERR(tlink);
-		goto out_free_xid;
-	}
-
-	tcon = tlink_tcon(tlink);
-
-	rc = check_name(direntry, tcon);
-	if (rc)
-		goto out;
-
-	server = tcon->ses->server;
-
-	if (server->ops->new_lease_key)
-		server->ops->new_lease_key(&fid);
-
-	cifs_add_pending_open(&fid, tlink, &open);
-
-	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid);
-
-	if (rc) {
-		cifs_del_pending_open(&open);
-		goto out;
-	}
-
-	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
-		file->f_mode |= FMODE_CREATED;
-
-	rc = finish_open(file, direntry, generic_file_open);
-	if (rc) {
-		if (server->ops->close)
-			server->ops->close(xid, tcon, &fid);
-		cifs_del_pending_open(&open);
-		goto out;
-	}
-
-	if (file->f_flags & O_DIRECT &&
-	    CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
-		if (CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
-			file->f_op = &cifs_file_direct_nobrl_ops;
-		else
-			file->f_op = &cifs_file_direct_ops;
-		}
-
-	file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
-	if (file_info == NULL) {
-		if (server->ops->close)
-			server->ops->close(xid, tcon, &fid);
-		cifs_del_pending_open(&open);
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	fscache_use_cookie(cifs_inode_cookie(file_inode(file)),
-			   file->f_mode & FMODE_WRITE);
-
-out:
-	cifs_put_tlink(tlink);
-out_free_xid:
-	free_xid(xid);
-	return rc;
-}
-
-int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
-		struct dentry *direntry, umode_t mode, bool excl)
-{
-	int rc;
-	unsigned int xid = get_xid();
-	/*
-	 * BB below access is probably too much for mknod to request
-	 *    but we have to do query and setpathinfo so requesting
-	 *    less could fail (unless we want to request getatr and setatr
-	 *    permissions (only).  At least for POSIX we do not have to
-	 *    request so much.
-	 */
-	unsigned oflags = O_EXCL | O_CREAT | O_RDWR;
-	struct tcon_link *tlink;
-	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
-	struct cifs_fid fid;
-	__u32 oplock;
-
-	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
-		 inode, direntry, direntry);
-
-	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
-		return -EIO;
-
-	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
-	rc = PTR_ERR(tlink);
-	if (IS_ERR(tlink))
-		goto out_free_xid;
-
-	tcon = tlink_tcon(tlink);
-	server = tcon->ses->server;
-
-	if (server->ops->new_lease_key)
-		server->ops->new_lease_key(&fid);
-
-	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid);
-	if (!rc && server->ops->close)
-		server->ops->close(xid, tcon, &fid);
-
-	cifs_put_tlink(tlink);
-out_free_xid:
-	free_xid(xid);
-	return rc;
-}
-
-int cifs_mknod(struct user_namespace *mnt_userns, struct inode *inode,
-	       struct dentry *direntry, umode_t mode, dev_t device_number)
-{
-	int rc = -EPERM;
-	unsigned int xid;
-	struct cifs_sb_info *cifs_sb;
-	struct tcon_link *tlink;
-	struct cifs_tcon *tcon;
-	const char *full_path;
-	void *page;
-
-	if (!old_valid_dev(device_number))
-		return -EINVAL;
-
-	cifs_sb = CIFS_SB(inode->i_sb);
-	if (unlikely(cifs_forced_shutdown(cifs_sb)))
-		return -EIO;
-
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
-		return PTR_ERR(tlink);
-
-	page = alloc_dentry_path();
-	tcon = tlink_tcon(tlink);
-	xid = get_xid();
-
-	full_path = build_path_from_dentry(direntry, page);
-	if (IS_ERR(full_path)) {
-		rc = PTR_ERR(full_path);
-		goto mknod_out;
-	}
-
-	rc = tcon->ses->server->ops->make_node(xid, inode, direntry, tcon,
-					       full_path, mode,
-					       device_number);
-
-mknod_out:
-	free_dentry_path(page);
-	free_xid(xid);
-	cifs_put_tlink(tlink);
-	return rc;
-}
-
-struct dentry *
-cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
-	    unsigned int flags)
-{
-	unsigned int xid;
-	int rc = 0; /* to get around spurious gcc warning, set to zero here */
-	struct cifs_sb_info *cifs_sb;
-	struct tcon_link *tlink;
-	struct cifs_tcon *pTcon;
-	struct inode *newInode = NULL;
-	const char *full_path;
-	void *page;
-	int retry_count = 0;
-
-	xid = get_xid();
-
-	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
-		 parent_dir_inode, direntry, direntry);
-
-	/* check whether path exists */
-
-	cifs_sb = CIFS_SB(parent_dir_inode->i_sb);
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink)) {
-		free_xid(xid);
-		return ERR_CAST(tlink);
-	}
-	pTcon = tlink_tcon(tlink);
-
-	rc = check_name(direntry, pTcon);
-	if (unlikely(rc)) {
-		cifs_put_tlink(tlink);
-		free_xid(xid);
-		return ERR_PTR(rc);
-	}
-
-	/* can not grab the rename sem here since it would
-	deadlock in the cases (beginning of sys_rename itself)
-	in which we already have the sb rename sem */
-	page = alloc_dentry_path();
-	full_path = build_path_from_dentry(direntry, page);
-	if (IS_ERR(full_path)) {
-		cifs_put_tlink(tlink);
-		free_xid(xid);
-		free_dentry_path(page);
-		return ERR_CAST(full_path);
-	}
-
-	if (d_really_is_positive(direntry)) {
-		cifs_dbg(FYI, "non-NULL inode in lookup\n");
-	} else {
-		cifs_dbg(FYI, "NULL inode in lookup\n");
-	}
-	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
-		 full_path, d_inode(direntry));
-
-again:
-	if (pTcon->posix_extensions)
-		rc = smb311_posix_get_inode_info(&newInode, full_path, parent_dir_inode->i_sb, xid);
-	else if (pTcon->unix_ext) {
-		rc = cifs_get_inode_info_unix(&newInode, full_path,
-					      parent_dir_inode->i_sb, xid);
-	} else {
-		rc = cifs_get_inode_info(&newInode, full_path, NULL,
-				parent_dir_inode->i_sb, xid, NULL);
-	}
-
-	if (rc == 0) {
-		/* since paths are not looked up by component - the parent
-		   directories are presumed to be good here */
-		renew_parental_timestamps(direntry);
-	} else if (rc == -EAGAIN && retry_count++ < 10) {
-		goto again;
-	} else if (rc == -ENOENT) {
-		cifs_set_time(direntry, jiffies);
-		newInode = NULL;
-	} else {
-		if (rc != -EACCES) {
-			cifs_dbg(FYI, "Unexpected lookup error %d\n", rc);
-			/* We special case check for Access Denied - since that
-			is a common return code */
-		}
-		newInode = ERR_PTR(rc);
-	}
-	free_dentry_path(page);
-	cifs_put_tlink(tlink);
-	free_xid(xid);
-	return d_splice_alias(newInode, direntry);
-}
-
 static int
 cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
@@ -782,19 +198,9 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 	return 1;
 }
 
-/* static int cifs_d_delete(struct dentry *direntry)
-{
-	int rc = 0;
-
-	cifs_dbg(FYI, "In cifs d_delete, name = %pd\n", direntry);
-
-	return rc;
-}     */
-
 const struct dentry_operations cifs_dentry_ops = {
 	.d_revalidate = cifs_d_revalidate,
 	.d_automount = cifs_dfs_d_automount,
-/* d_delete:       cifs_d_delete,      */ /* not needed except for debugging */
 };
 
 static int cifs_ci_hash(const struct dentry *dentry, struct qstr *q)
@@ -870,3 +276,26 @@ const struct dentry_operations cifs_ci_dentry_ops = {
 	.d_compare = cifs_ci_compare,
 	.d_automount = cifs_dfs_d_automount,
 };
+
+/*
+ * Directory operations under CIFS/SMB2/SMB3 are synchronous, so fsync()
+ * is a dummy operation.
+ */
+static int cifs_dir_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	cifs_dbg(FYI, "Sync directory - name: %pD datasync: 0x%x\n",
+		 file, datasync);
+
+	return 0;
+}
+
+const struct file_operations cifs_dir_ops = {
+	.iterate_shared = cifs_readdir,
+	.release = cifs_closedir,
+	.read    = generic_read_dir,
+	.unlocked_ioctl  = cifs_ioctl,
+	.copy_file_range = cifs_copy_file_range,
+	.remap_file_range = cifs_remap_file_range,
+	.llseek = generic_file_llseek,
+	.fsync = cifs_dir_fsync,
+};
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 85f2abcb2795..0ec199824724 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -8,7 +8,6 @@
  *              Jeremy Allison (jra@samba.org)
  *
  */
-#include <linux/fs.h>
 #include <linux/backing-dev.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
@@ -34,6 +33,7 @@
 #include "smbdirect.h"
 #include "fs_context.h"
 #include "cifs_ioctl.h"
+#include "file.h"
 
 /*
  * Mark as invalid, all open files on tree connections since they
@@ -5228,6 +5228,298 @@ static bool cifs_dirty_folio(struct address_space *mapping, struct folio *folio)
 #define cifs_dirty_folio filemap_dirty_folio
 #endif
 
+static ssize_t
+cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	ssize_t rc;
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (iocb->ki_flags & IOCB_DIRECT)
+		return cifs_user_readv(iocb, iter);
+
+	rc = cifs_revalidate_mapping(inode);
+	if (rc)
+		return rc;
+
+	return generic_file_read_iter(iocb, iter);
+}
+
+static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	ssize_t written;
+	int rc;
+
+	if (iocb->ki_filp->f_flags & O_DIRECT) {
+		written = cifs_user_writev(iocb, from);
+		if (written > 0 && CIFS_CACHE_READ(cinode)) {
+			cifs_zap_mapping(inode);
+			cifs_dbg(FYI,
+				 "Set no oplock for inode=%p after a write operation\n",
+				 inode);
+			cinode->oplock = 0;
+		}
+		return written;
+	}
+
+	written = cifs_get_writer(cinode);
+	if (written)
+		return written;
+
+	written = generic_file_write_iter(iocb, from);
+
+	if (CIFS_CACHE_WRITE(CIFS_I(inode)))
+		goto out;
+
+	rc = filemap_fdatawrite(inode->i_mapping);
+	if (rc)
+		cifs_dbg(FYI, "cifs_file_write_iter: %d rc on %p inode\n",
+			 rc, inode);
+
+out:
+	cifs_put_writer(cinode);
+	return written;
+}
+
+static loff_t cifs_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct cifsFileInfo *cfile = file->private_data;
+	struct cifs_tcon *tcon;
+
+	/*
+	 * whence == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
+	 * the cached file length
+	 */
+	if (whence != SEEK_SET && whence != SEEK_CUR) {
+		int rc;
+		struct inode *inode = file_inode(file);
+
+		/*
+		 * We need to be sure that all dirty pages are written and the
+		 * server has the newest file length.
+		 */
+		if (!CIFS_CACHE_READ(CIFS_I(inode)) && inode->i_mapping &&
+		    inode->i_mapping->nrpages != 0) {
+			rc = filemap_fdatawait(inode->i_mapping);
+			if (rc) {
+				mapping_set_error(inode->i_mapping, rc);
+				return rc;
+			}
+		}
+		/*
+		 * Some applications poll for the file length in this strange
+		 * way so we must seek to end on non-oplocked files by
+		 * setting the revalidate time to zero.
+		 */
+		CIFS_I(inode)->time = 0;
+
+		rc = cifs_revalidate_file_attr(file);
+		if (rc < 0)
+			return (loff_t)rc;
+	}
+	if (cfile && cfile->tlink) {
+		tcon = tlink_tcon(cfile->tlink);
+		if (tcon->ses->server->ops->llseek)
+			return tcon->ses->server->ops->llseek(file, tcon,
+							      offset, whence);
+	}
+	return generic_file_llseek(file, offset, whence);
+}
+
+static int
+cifs_setlease(struct file *file, long arg, struct file_lock **lease, void **priv)
+{
+	/*
+	 * Note that this is called by vfs setlease with i_lock held to
+	 * protect *lease from going away.
+	 */
+	struct inode *inode = file_inode(file);
+	struct cifsFileInfo *cfile = file->private_data;
+
+	if (!(S_ISREG(inode->i_mode)))
+		return -EINVAL;
+
+	/* Check if file is oplocked if this is request for new lease */
+	if (arg == F_UNLCK ||
+	    ((arg == F_RDLCK) && CIFS_CACHE_READ(CIFS_I(inode))) ||
+	    ((arg == F_WRLCK) && CIFS_CACHE_WRITE(CIFS_I(inode))))
+		return generic_setlease(file, arg, lease, priv);
+	else if (tlink_tcon(cfile->tlink)->local_lease &&
+		 !CIFS_CACHE_READ(CIFS_I(inode)))
+		/*
+		 * If the server claims to support oplock on this file, then we
+		 * still need to check oplock even if the local_lease mount
+		 * option is set, but there are servers which do not support
+		 * oplock for which this mount option may be useful if the user
+		 * knows that the file won't be changed on the server by anyone
+		 * else.
+		 */
+		return generic_setlease(file, arg, lease, priv);
+	else
+		return -EAGAIN;
+}
+
+static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+
+	if (server->ops->fallocate)
+		return server->ops->fallocate(file, tcon, mode, off, len);
+
+	return -EOPNOTSUPP;
+}
+
+loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
+			     struct file *dst_file, loff_t destoff, loff_t len,
+			     unsigned int remap_flags)
+{
+	struct inode *src_inode = file_inode(src_file);
+	struct inode *target_inode = file_inode(dst_file);
+	struct cifsFileInfo *smb_file_src = src_file->private_data;
+	struct cifsFileInfo *smb_file_target;
+	struct cifs_tcon *target_tcon;
+	unsigned int xid;
+	int rc;
+
+	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
+		return -EINVAL;
+
+	cifs_dbg(FYI, "clone range\n");
+
+	xid = get_xid();
+
+	if (!src_file->private_data || !dst_file->private_data) {
+		rc = -EBADF;
+		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
+		goto out;
+	}
+
+	smb_file_target = dst_file->private_data;
+	target_tcon = tlink_tcon(smb_file_target->tlink);
+
+	/*
+	 * Note: cifs case is easier than btrfs since server responsible for
+	 * checks for proper open modes and file type and if it wants
+	 * server could even support copy of range where source = target
+	 */
+	lock_two_nondirectories(target_inode, src_inode);
+
+	if (len == 0)
+		len = src_inode->i_size - off;
+
+	cifs_dbg(FYI, "about to flush pages\n");
+	/* should we flush first and last page first */
+	truncate_inode_pages_range(&target_inode->i_data, destoff,
+				   PAGE_ALIGN(destoff + len)-1);
+
+	if (target_tcon->ses->server->ops->duplicate_extents)
+		rc = target_tcon->ses->server->ops->duplicate_extents(xid,
+			smb_file_src, smb_file_target, off, len, destoff);
+	else
+		rc = -EOPNOTSUPP;
+
+	/* force revalidate of size and timestamps of target file now
+	   that target is updated on the server */
+	CIFS_I(target_inode)->time = 0;
+	/* although unlocking in the reverse order from locking is not
+	   strictly necessary here it is a little cleaner to be consistent */
+	unlock_two_nondirectories(src_inode, target_inode);
+out:
+	free_xid(xid);
+	return rc < 0 ? rc : len;
+}
+
+ssize_t cifs_file_copychunk_range(unsigned int xid,
+				struct file *src_file, loff_t off,
+				struct file *dst_file, loff_t destoff,
+				size_t len, unsigned int flags)
+{
+	struct inode *src_inode = file_inode(src_file);
+	struct inode *target_inode = file_inode(dst_file);
+	struct cifsFileInfo *smb_file_src;
+	struct cifsFileInfo *smb_file_target;
+	struct cifs_tcon *src_tcon;
+	struct cifs_tcon *target_tcon;
+	ssize_t rc;
+
+	cifs_dbg(FYI, "copychunk range\n");
+
+	if (!src_file->private_data || !dst_file->private_data) {
+		rc = -EBADF;
+		cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
+		goto out;
+	}
+
+	rc = -EXDEV;
+	smb_file_target = dst_file->private_data;
+	smb_file_src = src_file->private_data;
+	src_tcon = tlink_tcon(smb_file_src->tlink);
+	target_tcon = tlink_tcon(smb_file_target->tlink);
+
+	if (src_tcon->ses != target_tcon->ses) {
+		cifs_dbg(VFS, "source and target of copy not on same server\n");
+		goto out;
+	}
+
+	rc = -EOPNOTSUPP;
+	if (!target_tcon->ses->server->ops->copychunk_range)
+		goto out;
+
+	/*
+	 * Note: cifs case is easier than btrfs since server responsible for
+	 * checks for proper open modes and file type and if it wants
+	 * server could even support copy of range where source = target
+	 */
+	lock_two_nondirectories(target_inode, src_inode);
+
+	cifs_dbg(FYI, "about to flush pages\n");
+	/* should we flush first and last page first */
+	truncate_inode_pages(&target_inode->i_data, 0);
+
+	rc = file_modified(dst_file);
+	if (!rc)
+		rc = target_tcon->ses->server->ops->copychunk_range(xid,
+			smb_file_src, smb_file_target, off, len, destoff);
+
+	file_accessed(src_file);
+
+	/* force revalidate of size and timestamps of target file now
+	 * that target is updated on the server
+	 */
+	CIFS_I(target_inode)->time = 0;
+	/* although unlocking in the reverse order from locking is not
+	 * strictly necessary here it is a little cleaner to be consistent
+	 */
+	unlock_two_nondirectories(src_inode, target_inode);
+
+out:
+	return rc;
+}
+
+ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
+			     struct file *dst_file, loff_t destoff,
+			     size_t len, unsigned int flags)
+{
+	unsigned int xid = get_xid();
+	ssize_t rc;
+	struct cifsFileInfo *cfile = dst_file->private_data;
+
+	if (cfile->swapfile)
+		return -EOPNOTSUPP;
+
+	rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
+					len, flags);
+	free_xid(xid);
+
+	if (rc == -EOPNOTSUPP || rc == -EXDEV)
+		rc = generic_copy_file_range(src_file, off, dst_file,
+					     destoff, len, flags);
+	return rc;
+}
+
 const struct address_space_operations cifs_addr_ops = {
 	.read_folio = cifs_read_folio,
 	.readahead = cifs_readahead,
@@ -5265,3 +5557,117 @@ const struct address_space_operations cifs_addr_ops_smallbuf = {
 	.invalidate_folio = cifs_invalidate_folio,
 	.launder_folio = cifs_launder_folio,
 };
+
+const struct file_operations cifs_file_ops = {
+	.read_iter = cifs_loose_read_iter,
+	.write_iter = cifs_file_write_iter,
+	.open = cifs_open,
+	.release = cifs_close,
+	.lock = cifs_lock,
+	.flock = cifs_flock,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap  = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
+	.llseek = cifs_llseek,
+	.unlocked_ioctl	= cifs_ioctl,
+	.copy_file_range = cifs_copy_file_range,
+	.remap_file_range = cifs_remap_file_range,
+	.setlease = cifs_setlease,
+	.fallocate = cifs_fallocate,
+};
+
+const struct file_operations cifs_file_strict_ops = {
+	.read_iter = cifs_strict_readv,
+	.write_iter = cifs_strict_writev,
+	.open = cifs_open,
+	.release = cifs_close,
+	.lock = cifs_lock,
+	.flock = cifs_flock,
+	.fsync = cifs_strict_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_strict_mmap,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
+	.llseek = cifs_llseek,
+	.unlocked_ioctl	= cifs_ioctl,
+	.copy_file_range = cifs_copy_file_range,
+	.remap_file_range = cifs_remap_file_range,
+	.setlease = cifs_setlease,
+	.fallocate = cifs_fallocate,
+};
+
+const struct file_operations cifs_file_direct_ops = {
+	.read_iter = cifs_direct_readv,
+	.write_iter = cifs_direct_writev,
+	.open = cifs_open,
+	.release = cifs_close,
+	.lock = cifs_lock,
+	.flock = cifs_flock,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
+	.unlocked_ioctl  = cifs_ioctl,
+	.copy_file_range = cifs_copy_file_range,
+	.remap_file_range = cifs_remap_file_range,
+	.llseek = cifs_llseek,
+	.setlease = cifs_setlease,
+	.fallocate = cifs_fallocate,
+};
+
+const struct file_operations cifs_file_nobrl_ops = {
+	.read_iter = cifs_loose_read_iter,
+	.write_iter = cifs_file_write_iter,
+	.open = cifs_open,
+	.release = cifs_close,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap  = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
+	.llseek = cifs_llseek,
+	.unlocked_ioctl	= cifs_ioctl,
+	.copy_file_range = cifs_copy_file_range,
+	.remap_file_range = cifs_remap_file_range,
+	.setlease = cifs_setlease,
+	.fallocate = cifs_fallocate,
+};
+
+const struct file_operations cifs_file_strict_nobrl_ops = {
+	.read_iter = cifs_strict_readv,
+	.write_iter = cifs_strict_writev,
+	.open = cifs_open,
+	.release = cifs_close,
+	.fsync = cifs_strict_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_strict_mmap,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
+	.llseek = cifs_llseek,
+	.unlocked_ioctl	= cifs_ioctl,
+	.copy_file_range = cifs_copy_file_range,
+	.remap_file_range = cifs_remap_file_range,
+	.setlease = cifs_setlease,
+	.fallocate = cifs_fallocate,
+};
+
+const struct file_operations cifs_file_direct_nobrl_ops = {
+	.read_iter = cifs_direct_readv,
+	.write_iter = cifs_direct_writev,
+	.open = cifs_open,
+	.release = cifs_close,
+	.fsync = cifs_fsync,
+	.flush = cifs_flush,
+	.mmap = cifs_file_mmap,
+	.splice_read = generic_file_splice_read,
+	.splice_write = iter_file_splice_write,
+	.unlocked_ioctl  = cifs_ioctl,
+	.copy_file_range = cifs_copy_file_range,
+	.remap_file_range = cifs_remap_file_range,
+	.llseek = cifs_llseek,
+	.setlease = cifs_setlease,
+	.fallocate = cifs_fallocate,
+};
diff --git a/fs/cifs/file.h b/fs/cifs/file.h
new file mode 100644
index 000000000000..943dfa512f41
--- /dev/null
+++ b/fs/cifs/file.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Routines related to file operations
+ */
+#ifndef _CIFS_FILE_H
+#define _CIFS_FILE_H
+
+extern const struct file_operations cifs_file_ops;
+extern const struct file_operations cifs_file_direct_ops; /* if directio mnt */
+extern const struct file_operations cifs_file_strict_ops; /* if strictio mnt */
+extern const struct file_operations cifs_file_nobrl_ops;
+extern const struct file_operations cifs_file_strict_nobrl_ops;
+extern const struct file_operations cifs_file_direct_nobrl_ops;
+
+extern loff_t cifs_remap_file_range(struct file *, loff_t, struct file *,
+				    loff_t, loff_t, unsigned int);
+extern ssize_t cifs_copy_file_range(struct file *, loff_t, struct file *,
+				    loff_t, size_t, unsigned int);
+extern ssize_t cifs_file_copychunk_range(unsigned int, struct file *, loff_t,
+					 struct file *, loff_t, size_t,
+					 unsigned int);
+
+int cifs_open(struct inode *, struct file *);
+int cifs_close(struct inode *, struct file *);
+int cifs_flock(struct file *, int, struct file_lock *);
+int cifs_lock(struct file *, int, struct file_lock *);
+int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
+int cifs_fsync(struct file *, loff_t, loff_t, int);
+int cifs_flush(struct file *, fl_owner_t);
+ssize_t cifs_direct_writev(struct kiocb *, struct iov_iter *);
+ssize_t cifs_user_writev(struct kiocb *, struct iov_iter *);
+ssize_t cifs_strict_writev(struct kiocb *, struct iov_iter *);
+ssize_t cifs_direct_readv(struct kiocb *, struct iov_iter *);
+ssize_t cifs_user_readv(struct kiocb *, struct iov_iter *);
+ssize_t cifs_strict_readv(struct kiocb *, struct iov_iter *);
+int cifs_file_strict_mmap(struct file *, struct vm_area_struct *);
+int cifs_file_mmap(struct file *, struct vm_area_struct *);
+#endif /* _CIFS_FILE_H */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index eeeaba3dec05..9c20e09cf00f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -25,7 +25,51 @@
 #include "fscache.h"
 #include "fs_context.h"
 #include "cifs_ioctl.h"
+#include "inode.h"
 
+extern const struct inode_operations cifs_dfs_referral_inode_operations;
+
+static struct kmem_cache *cifs_inode_cachep;
+
+static void renew_parental_timestamps(struct dentry *direntry)
+{
+	/* BB check if there is a way to get the kernel to do this or if we
+	   really need this */
+	do {
+		cifs_set_time(direntry, jiffies);
+		direntry = direntry->d_parent;
+	} while (!IS_ROOT(direntry));
+}
+
+/*
+ * Don't allow path components longer than the server max.
+ * Don't allow the separator character in a path component.
+ * The VFS will not allow "/", but "\" is allowed by posix.
+ */
+static int check_name(struct dentry *direntry, struct cifs_tcon *tcon)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
+	int i;
+
+	if (unlikely(tcon->fsAttrInfo.MaxPathNameComponentLength &&
+		     direntry->d_name.len >
+		     le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength)))
+		return -ENAMETOOLONG;
+
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
+		for (i = 0; i < direntry->d_name.len; i++) {
+			if (direntry->d_name.name[i] == '\\') {
+				cifs_dbg(FYI, "Invalid file name\n");
+				return -EINVAL;
+			}
+		}
+	}
+	return 0;
+}
+
+static const struct inode_operations cifs_file_inode_ops;
+static const struct inode_operations cifs_dir_inode_ops;
+static const struct inode_operations cifs_symlink_inode_ops;
 static void cifs_set_ops(struct inode *inode)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
@@ -654,7 +698,6 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_posix_qinfo *
 		fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
 }
 
-
 /* Fill a cifs_fattr struct with info from FILE_ALL_INFO */
 static void
 cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
@@ -1231,7 +1274,6 @@ smb311_posix_get_inode_info(struct inode **inode,
 	return rc;
 }
 
-
 static const struct inode_operations cifs_ipc_inode_ops = {
 	.lookup = cifs_lookup,
 };
@@ -3036,6 +3078,25 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 	return rc;
 }
 
+static int cifs_permission(struct user_namespace *mnt_userns,
+			   struct inode *inode, int mask)
+{
+	struct cifs_sb_info *cifs_sb;
+
+	cifs_sb = CIFS_SB(inode->i_sb);
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) {
+		if ((mask & MAY_EXEC) && !execute_ok(inode))
+			return -EACCES;
+		else
+			return 0;
+	} else /* file mode might have been restricted at mount time
+		on the client (above and beyond ACL on servers) for
+		servers which do not support setting and viewing mode bits,
+		so allowing client to check permissions is useful */
+		return generic_permission(&init_user_ns, inode, mask);
+}
+
 int
 cifs_setattr(struct user_namespace *mnt_userns, struct dentry *direntry,
 	     struct iattr *attrs)
@@ -3062,3 +3123,676 @@ cifs_setattr(struct user_namespace *mnt_userns, struct dentry *direntry,
 	/* BB: add cifs_setattr_legacy for really old servers */
 	return rc;
 }
+
+/* Inode operations in similar order to how they appear in Linux file fs.h */
+
+static int
+cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
+	       struct tcon_link *tlink, unsigned oflags, umode_t mode,
+	       __u32 *oplock, struct cifs_fid *fid)
+{
+	int rc = -ENOENT;
+	int create_options = CREATE_NOT_DIR;
+	int desired_access;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_tcon *tcon = tlink_tcon(tlink);
+	const char *full_path;
+	void *page = alloc_dentry_path();
+	FILE_ALL_INFO *buf = NULL;
+	struct inode *newinode = NULL;
+	int disposition;
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_open_parms oparms;
+
+	*oplock = 0;
+	if (tcon->ses->server->oplocks)
+		*oplock = REQ_OPLOCK;
+
+	full_path = build_path_from_dentry(direntry, page);
+	if (IS_ERR(full_path)) {
+		free_dentry_path(page);
+		return PTR_ERR(full_path);
+	}
+
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
+	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
+	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
+			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
+		rc = cifs_posix_open(full_path, &newinode, inode->i_sb, mode,
+				     oflags, oplock, &fid->netfid, xid);
+		switch (rc) {
+		case 0:
+			if (newinode == NULL) {
+				/* query inode info */
+				goto cifs_create_get_file_info;
+			}
+
+			if (S_ISDIR(newinode->i_mode)) {
+				CIFSSMBClose(xid, tcon, fid->netfid);
+				iput(newinode);
+				rc = -EISDIR;
+				goto out;
+			}
+
+			if (!S_ISREG(newinode->i_mode)) {
+				/*
+				 * The server may allow us to open things like
+				 * FIFOs, but the client isn't set up to deal
+				 * with that. If it's not a regular file, just
+				 * close it and proceed as if it were a normal
+				 * lookup.
+				 */
+				CIFSSMBClose(xid, tcon, fid->netfid);
+				goto cifs_create_get_file_info;
+			}
+			/* success, no need to query */
+			goto cifs_create_set_dentry;
+
+		case -ENOENT:
+			goto cifs_create_get_file_info;
+
+		case -EIO:
+		case -EINVAL:
+			/*
+			 * EIO could indicate that (posix open) operation is not
+			 * supported, despite what server claimed in capability
+			 * negotiation.
+			 *
+			 * POSIX open in samba versions 3.3.1 and earlier could
+			 * incorrectly fail with invalid parameter.
+			 */
+			tcon->broken_posix_open = true;
+			break;
+
+		case -EREMOTE:
+		case -EOPNOTSUPP:
+			/*
+			 * EREMOTE indicates DFS junction, which is not handled
+			 * in posix open.  If either that or op not supported
+			 * returned, follow the normal lookup.
+			 */
+			break;
+
+		default:
+			goto out;
+		}
+		/*
+		 * fallthrough to retry, using older open call, this is case
+		 * where server does not support this SMB level, and falsely
+		 * claims capability (also get here for DFS case which should be
+		 * rare for path not covered on files)
+		 */
+	}
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+
+	desired_access = 0;
+	if (OPEN_FMODE(oflags) & FMODE_READ)
+		desired_access |= GENERIC_READ; /* is this too little? */
+	if (OPEN_FMODE(oflags) & FMODE_WRITE)
+		desired_access |= GENERIC_WRITE;
+
+	disposition = FILE_OVERWRITE_IF;
+	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+		disposition = FILE_CREATE;
+	else if ((oflags & (O_CREAT | O_TRUNC)) == (O_CREAT | O_TRUNC))
+		disposition = FILE_OVERWRITE_IF;
+	else if ((oflags & O_CREAT) == O_CREAT)
+		disposition = FILE_OPEN_IF;
+	else
+		cifs_dbg(FYI, "Create flag not set in create function\n");
+
+	/*
+	 * BB add processing to set equivalent of mode - e.g. via CreateX with
+	 * ACLs
+	 */
+
+	if (!server->ops->open) {
+		rc = -ENOSYS;
+		goto out;
+	}
+
+	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	if (buf == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * if we're not using unix extensions, see if we need to set
+	 * ATTR_READONLY on the create call
+	 */
+	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
+		create_options |= CREATE_OPTION_READONLY;
+
+	oparms.tcon = tcon;
+	oparms.cifs_sb = cifs_sb;
+	oparms.desired_access = desired_access;
+	oparms.create_options = cifs_create_options(cifs_sb, create_options);
+	oparms.disposition = disposition;
+	oparms.path = full_path;
+	oparms.fid = fid;
+	oparms.reconnect = false;
+	oparms.mode = mode;
+	rc = server->ops->open(xid, &oparms, oplock, buf);
+	if (rc) {
+		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
+		goto out;
+	}
+
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
+	/*
+	 * If Open reported that we actually created a file then we now have to
+	 * set the mode if possible.
+	 */
+	if ((tcon->unix_ext) && (*oplock & CIFS_CREATE_ACTION)) {
+		struct cifs_unix_set_info_args args = {
+				.mode	= mode,
+				.ctime	= NO_CHANGE_64,
+				.atime	= NO_CHANGE_64,
+				.mtime	= NO_CHANGE_64,
+				.device	= 0,
+		};
+
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+			args.uid = current_fsuid();
+			if (inode->i_mode & S_ISGID)
+				args.gid = inode->i_gid;
+			else
+				args.gid = current_fsgid();
+		} else {
+			args.uid = INVALID_UID; /* no change */
+			args.gid = INVALID_GID; /* no change */
+		}
+		CIFSSMBUnixSetFileInfo(xid, tcon, &args, fid->netfid,
+				       current->tgid);
+	} else {
+		/*
+		 * BB implement mode setting via Windows security
+		 * descriptors e.g.
+		 */
+		/* CIFSSMBWinSetPerms(xid,tcon,path,mode,-1,-1,nls);*/
+
+		/* Could set r/o dos attribute if mode & 0222 == 0 */
+	}
+
+cifs_create_get_file_info:
+	/* server might mask mode so we have to query for it */
+	if (tcon->unix_ext)
+		rc = cifs_get_inode_info_unix(&newinode, full_path, inode->i_sb,
+					      xid);
+	else {
+#else
+	{
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+		/* TODO: Add support for calling POSIX query info here, but passing in fid */
+		rc = cifs_get_inode_info(&newinode, full_path, buf, inode->i_sb,
+					 xid, fid);
+		if (newinode) {
+			if (server->ops->set_lease_key)
+				server->ops->set_lease_key(newinode, fid);
+			if ((*oplock & CIFS_CREATE_ACTION) && S_ISREG(newinode->i_mode)) {
+				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
+					newinode->i_mode = mode;
+				if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID) {
+					newinode->i_uid = current_fsuid();
+					if (inode->i_mode & S_ISGID)
+						newinode->i_gid = inode->i_gid;
+					else
+						newinode->i_gid = current_fsgid();
+				}
+			}
+		}
+	}
+
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
+cifs_create_set_dentry:
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+	if (rc != 0) {
+		cifs_dbg(FYI, "Create worked, get_inode_info failed rc = %d\n",
+			 rc);
+		goto out_err;
+	}
+
+	if (newinode)
+		if (S_ISDIR(newinode->i_mode)) {
+			rc = -EISDIR;
+			goto out_err;
+		}
+
+	d_drop(direntry);
+	d_add(direntry, newinode);
+
+out:
+	kfree(buf);
+	free_dentry_path(page);
+	return rc;
+
+out_err:
+	if (server->ops->close)
+		server->ops->close(xid, tcon, fid);
+	if (newinode)
+		iput(newinode);
+	goto out;
+}
+
+int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
+		struct dentry *direntry, umode_t mode, bool excl)
+{
+	int rc;
+	unsigned int xid = get_xid();
+	/*
+	 * BB below access is probably too much for mknod to request
+	 *    but we have to do query and setpathinfo so requesting
+	 *    less could fail (unless we want to request getatr and setatr
+	 *    permissions (only).  At least for POSIX we do not have to
+	 *    request so much.
+	 */
+	unsigned oflags = O_EXCL | O_CREAT | O_RDWR;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+	struct cifs_fid fid;
+	__u32 oplock;
+
+	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
+		 inode, direntry, direntry);
+
+	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
+		return -EIO;
+
+	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
+	rc = PTR_ERR(tlink);
+	if (IS_ERR(tlink))
+		goto out_free_xid;
+
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+
+	if (server->ops->new_lease_key)
+		server->ops->new_lease_key(&fid);
+
+	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
+			    &oplock, &fid);
+	if (!rc && server->ops->close)
+		server->ops->close(xid, tcon, &fid);
+
+	cifs_put_tlink(tlink);
+out_free_xid:
+	free_xid(xid);
+	return rc;
+}
+
+static int cifs_mknod(struct user_namespace *mnt_userns, struct inode *inode,
+		      struct dentry *direntry, umode_t mode, dev_t device_number)
+{
+	int rc = -EPERM;
+	unsigned int xid;
+	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	const char *full_path;
+	void *page;
+
+	if (!old_valid_dev(device_number))
+		return -EINVAL;
+
+	cifs_sb = CIFS_SB(inode->i_sb);
+	if (unlikely(cifs_forced_shutdown(cifs_sb)))
+		return -EIO;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+
+	page = alloc_dentry_path();
+	tcon = tlink_tcon(tlink);
+	xid = get_xid();
+
+	full_path = build_path_from_dentry(direntry, page);
+	if (IS_ERR(full_path)) {
+		rc = PTR_ERR(full_path);
+		goto mknod_out;
+	}
+
+	rc = tcon->ses->server->ops->make_node(xid, inode, direntry, tcon,
+					       full_path, mode,
+					       device_number);
+
+mknod_out:
+	free_dentry_path(page);
+	free_xid(xid);
+	cifs_put_tlink(tlink);
+	return rc;
+}
+
+int cifs_atomic_open(struct inode *inode, struct dentry *direntry,
+		     struct file *file, unsigned oflags, umode_t mode)
+{
+	int rc;
+	unsigned int xid;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+	struct cifs_fid fid;
+	struct cifs_pending_open open;
+	__u32 oplock;
+	struct cifsFileInfo *file_info;
+
+	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
+		return -EIO;
+
+	/*
+	 * Posix open is only called (at lookup time) for file create now. For
+	 * opens (rather than creates), because we do not know if it is a file
+	 * or directory yet, and current Samba no longer allows us to do posix
+	 * open on dirs, we could end up wasting an open call on what turns out
+	 * to be a dir. For file opens, we wait to call posix open till
+	 * cifs_open.  It could be added to atomic_open in the future but the
+	 * performance tradeoff of the extra network request when EISDIR or
+	 * EACCES is returned would have to be weighed against the 50% reduction
+	 * in network traffic in the other paths.
+	 */
+	if (!(oflags & O_CREAT)) {
+		struct dentry *res;
+
+		/*
+		 * Check for hashed negative dentry. We have already revalidated
+		 * the dentry and it is fine. No need to perform another lookup.
+		 */
+		if (!d_in_lookup(direntry))
+			return -ENOENT;
+
+		res = cifs_lookup(inode, direntry, 0);
+		if (IS_ERR(res))
+			return PTR_ERR(res);
+
+		return finish_no_open(file, res);
+	}
+
+	xid = get_xid();
+
+	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
+		 inode, direntry, direntry);
+
+	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
+	if (IS_ERR(tlink)) {
+		rc = PTR_ERR(tlink);
+		goto out_free_xid;
+	}
+
+	tcon = tlink_tcon(tlink);
+
+	rc = check_name(direntry, tcon);
+	if (rc)
+		goto out;
+
+	server = tcon->ses->server;
+
+	if (server->ops->new_lease_key)
+		server->ops->new_lease_key(&fid);
+
+	cifs_add_pending_open(&fid, tlink, &open);
+
+	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
+			    &oplock, &fid);
+
+	if (rc) {
+		cifs_del_pending_open(&open);
+		goto out;
+	}
+
+	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+		file->f_mode |= FMODE_CREATED;
+
+	rc = finish_open(file, direntry, generic_file_open);
+	if (rc) {
+		if (server->ops->close)
+			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
+		goto out;
+	}
+
+	if (file->f_flags & O_DIRECT &&
+	    CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
+		if (CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
+			file->f_op = &cifs_file_direct_nobrl_ops;
+		else
+			file->f_op = &cifs_file_direct_ops;
+		}
+
+	file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
+	if (file_info == NULL) {
+		if (server->ops->close)
+			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	fscache_use_cookie(cifs_inode_cookie(file_inode(file)),
+			   file->f_mode & FMODE_WRITE);
+
+out:
+	cifs_put_tlink(tlink);
+out_free_xid:
+	free_xid(xid);
+	return rc;
+}
+
+struct dentry *
+cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
+	    unsigned int flags)
+{
+	unsigned int xid;
+	int rc = 0; /* to get around spurious gcc warning, set to zero here */
+	struct cifs_sb_info *cifs_sb;
+	struct tcon_link *tlink;
+	struct cifs_tcon *pTcon;
+	struct inode *newInode = NULL;
+	const char *full_path;
+	void *page;
+	int retry_count = 0;
+
+	xid = get_xid();
+
+	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
+		 parent_dir_inode, direntry, direntry);
+
+	/* check whether path exists */
+
+	cifs_sb = CIFS_SB(parent_dir_inode->i_sb);
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink)) {
+		free_xid(xid);
+		return ERR_CAST(tlink);
+	}
+	pTcon = tlink_tcon(tlink);
+
+	rc = check_name(direntry, pTcon);
+	if (unlikely(rc)) {
+		cifs_put_tlink(tlink);
+		free_xid(xid);
+		return ERR_PTR(rc);
+	}
+
+	/* can not grab the rename sem here since it would
+	deadlock in the cases (beginning of sys_rename itself)
+	in which we already have the sb rename sem */
+	page = alloc_dentry_path();
+	full_path = build_path_from_dentry(direntry, page);
+	if (IS_ERR(full_path)) {
+		cifs_put_tlink(tlink);
+		free_xid(xid);
+		free_dentry_path(page);
+		return ERR_CAST(full_path);
+	}
+
+	if (d_really_is_positive(direntry)) {
+		cifs_dbg(FYI, "non-NULL inode in lookup\n");
+	} else {
+		cifs_dbg(FYI, "NULL inode in lookup\n");
+	}
+	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
+		 full_path, d_inode(direntry));
+
+again:
+	if (pTcon->posix_extensions)
+		rc = smb311_posix_get_inode_info(&newInode, full_path, parent_dir_inode->i_sb, xid);
+	else if (pTcon->unix_ext) {
+		rc = cifs_get_inode_info_unix(&newInode, full_path,
+					      parent_dir_inode->i_sb, xid);
+	} else {
+		rc = cifs_get_inode_info(&newInode, full_path, NULL,
+				parent_dir_inode->i_sb, xid, NULL);
+	}
+
+	if (rc == 0) {
+		/* since paths are not looked up by component - the parent
+		   directories are presumed to be good here */
+		renew_parental_timestamps(direntry);
+	} else if (rc == -EAGAIN && retry_count++ < 10) {
+		goto again;
+	} else if (rc == -ENOENT) {
+		cifs_set_time(direntry, jiffies);
+		newInode = NULL;
+	} else {
+		if (rc != -EACCES) {
+			cifs_dbg(FYI, "Unexpected lookup error %d\n", rc);
+			/* We special case check for Access Denied - since that
+			is a common return code */
+		}
+		newInode = ERR_PTR(rc);
+	}
+	free_dentry_path(page);
+	cifs_put_tlink(tlink);
+	free_xid(xid);
+	return d_splice_alias(newInode, direntry);
+}
+
+struct inode *cifs_alloc_inode(struct super_block *sb)
+{
+	struct cifsInodeInfo *cifs_inode;
+	cifs_inode = alloc_inode_sb(sb, cifs_inode_cachep, GFP_KERNEL);
+	if (!cifs_inode)
+		return NULL;
+	cifs_inode->cifsAttrs = 0x20;	/* default */
+	cifs_inode->time = 0;
+	/*
+	 * Until the file is open and we have gotten oplock info back from the
+	 * server, can not assume caching of file data or metadata.
+	 */
+	cifs_set_oplock_level(cifs_inode, 0);
+	cifs_inode->flags = 0;
+	spin_lock_init(&cifs_inode->writers_lock);
+	cifs_inode->writers = 0;
+	cifs_inode->netfs.inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
+	cifs_inode->server_eof = 0;
+	cifs_inode->uniqueid = 0;
+	cifs_inode->createtime = 0;
+	cifs_inode->epoch = 0;
+	spin_lock_init(&cifs_inode->open_file_lock);
+	generate_random_uuid(cifs_inode->lease_key);
+
+	/*
+	 * Can not set i_flags here - they get immediately overwritten to zero
+	 * by the VFS.
+	 */
+	/* cifs_inode->netfs.inode.i_flags = S_NOATIME | S_NOCMTIME; */
+	INIT_LIST_HEAD(&cifs_inode->openFileList);
+	INIT_LIST_HEAD(&cifs_inode->llist);
+	INIT_LIST_HEAD(&cifs_inode->deferred_closes);
+	spin_lock_init(&cifs_inode->deferred_lock);
+	return &cifs_inode->netfs.inode;
+}
+
+void cifs_free_inode(struct inode *inode)
+{
+	kmem_cache_free(cifs_inode_cachep, CIFS_I(inode));
+}
+
+void cifs_evict_inode(struct inode *inode)
+{
+	truncate_inode_pages_final(&inode->i_data);
+	if (inode->i_state & I_PINNING_FSCACHE_WB)
+		cifs_fscache_unuse_inode_cookie(inode, true);
+	cifs_fscache_release_inode_cookie(inode);
+	clear_inode(inode);
+}
+
+int cifs_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	fscache_unpin_writeback(wbc, cifs_inode_cookie(inode));
+	return 0;
+}
+
+int cifs_drop_inode(struct inode *inode)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+
+	/* no serverino => unconditional eviction */
+	return !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) ||
+		generic_drop_inode(inode);
+}
+
+static void
+cifs_init_once(void *inode)
+{
+	struct cifsInodeInfo *cifsi = inode;
+
+	inode_init_once(&cifsi->netfs.inode);
+	init_rwsem(&cifsi->lock_sem);
+}
+
+int __init cifs_init_inodecache(void)
+{
+	cifs_inode_cachep = kmem_cache_create("cifs_inode_cache",
+					      sizeof(struct cifsInodeInfo),
+					      0, (SLAB_RECLAIM_ACCOUNT|
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
+					      cifs_init_once);
+	if (cifs_inode_cachep == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void cifs_destroy_inodecache(void)
+{
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy cache.
+	 */
+	rcu_barrier();
+	kmem_cache_destroy(cifs_inode_cachep);
+}
+
+static const struct inode_operations cifs_dir_inode_ops = {
+	.create = cifs_create,
+	.atomic_open = cifs_atomic_open,
+	.lookup = cifs_lookup,
+	.getattr = cifs_getattr,
+	.unlink = cifs_unlink,
+	.link = cifs_hardlink,
+	.mkdir = cifs_mkdir,
+	.rmdir = cifs_rmdir,
+	.rename = cifs_rename2,
+	.permission = cifs_permission,
+	.setattr = cifs_setattr,
+	.symlink = cifs_symlink,
+	.mknod   = cifs_mknod,
+	.listxattr = cifs_listxattr,
+};
+
+static const struct inode_operations cifs_file_inode_ops = {
+	.setattr = cifs_setattr,
+	.getattr = cifs_getattr,
+	.permission = cifs_permission,
+	.listxattr = cifs_listxattr,
+	.fiemap = cifs_fiemap,
+};
+
+static const struct inode_operations cifs_symlink_inode_ops = {
+	.get_link = cifs_get_link,
+	.permission = cifs_permission,
+	.listxattr = cifs_listxattr,
+};
diff --git a/fs/cifs/inode.h b/fs/cifs/inode.h
new file mode 100644
index 000000000000..5fe93ae79232
--- /dev/null
+++ b/fs/cifs/inode.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Routines related to inode operations
+ */
+#ifndef _CIFS_INODE_H
+#define _CIFS_INODE_H
+#include <linux/fs.h>
+
+extern void cifs_setsize(struct inode *, loff_t);
+extern int cifs_truncate_page(struct address_space *, loff_t);
+
+extern struct inode *cifs_alloc_inode(struct super_block *);
+extern void cifs_free_inode(struct inode *);
+extern void cifs_evict_inode(struct inode *);
+extern int cifs_write_inode(struct inode *, struct writeback_control *);
+extern int cifs_drop_inode(struct inode *);
+extern int __init cifs_init_inodecache(void);
+extern void cifs_destroy_inodecache(void);
+
+extern int cifs_unlink(struct inode *, struct dentry *);
+extern int cifs_mkdir(struct user_namespace *, struct inode *, struct dentry *,
+		      umode_t);
+extern int cifs_rmdir(struct inode *, struct dentry *);
+
+int cifs_rename2(struct user_namespace *, struct inode *, struct dentry *,
+		 struct inode *, struct dentry *, unsigned int);
+int cifs_invalidate_mapping(struct inode *);
+int cifs_create(struct user_namespace *, struct inode *, struct dentry *,
+		umode_t, bool);
+int cifs_atomic_open(struct inode *, struct dentry *, struct file *,
+		     unsigned, umode_t);
+#endif /* _CIFS_INODE_H */
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index b6e6e5d6c8dd..3bdc07900713 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -13,6 +13,7 @@
 #include <linux/mount.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
+#include <linux/btrfs.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -21,7 +22,7 @@
 #include "cifs_ioctl.h"
 #include "smb2proto.h"
 #include "smb2glob.h"
-#include <linux/btrfs.h>
+#include "file.h"
 
 static long cifs_ioctl_query_info(unsigned int xid, struct file *filep,
 				  unsigned long p)
@@ -321,7 +322,9 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb;
 	__u64	ExtAttrBits = 0;
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	__u64   caps;
+#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 	xid = get_xid();
 
@@ -330,10 +333,10 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 		case FS_IOC_GETFLAGS:
 			if (pSMBFile == NULL)
 				break;
-			tcon = tlink_tcon(pSMBFile->tlink);
-			caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
 #ifdef CONFIG_CIFS_POSIX
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
+			tcon = tlink_tcon(pSMBFile->tlink);
+			caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
 			if (CIFS_UNIX_EXTATTR_CAP & caps) {
 				__u64	ExtAttrMask = 0;
 				rc = CIFSGetExtAttr(xid, tcon,
-- 
2.35.3

