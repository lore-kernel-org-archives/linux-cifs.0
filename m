Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D13C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 21:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbiHAVgl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 17:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiHAVgl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 17:36:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AA52E6B6
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 14:36:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 992D937B82;
        Mon,  1 Aug 2022 21:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659389796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=xUpfk5EYjWjtZ9Ed2gzCyYaHCYvmtgO6wCG8kdOPKjk=;
        b=YXY3LnXydSm5dkXy+JvSdHv3FpqP0n2P73n/4YOx6HASjIKlvr+5La1kxCpbhwuy9LcEN8
        QFP1kOQ4k3/ZarcKvwrp5qBwcNCjZHzrR7PeUhJgA/utaadA+MFRxFZmTaKrMxF1mgBFci
        mISkobiv1koOlNHSsGqXJi5wQsduUV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659389796;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=xUpfk5EYjWjtZ9Ed2gzCyYaHCYvmtgO6wCG8kdOPKjk=;
        b=CWRFxFaPVoEgVlhUEh26nN4tE5wsyKwXaoLASh/VuJVAsoSTXOR4nYoW6fv1/zu8Zjk3YV
        pjmrZMD6jpYM+hBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CECCA13AAE;
        Mon,  1 Aug 2022 21:36:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bQ/vI2NH6GJIeQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 01 Aug 2022 21:36:35 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: move some bloat out of cifsfs.c to inode.c/file.c/dir.c
Date:   Mon,  1 Aug 2022 18:36:22 -0300
Message-Id: <20220801213622.18805-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Leave cifsfs.c with crucial code only, while making it easier to
identify what to move/remove from dir/file/inode re: SMB1 split.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsfs.c | 596 +----------------------------------------------
 fs/cifs/dir.c    |  29 +++
 fs/cifs/file.c   | 406 ++++++++++++++++++++++++++++++++
 fs/cifs/inode.c  | 149 ++++++++++++
 4 files changed, 592 insertions(+), 588 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index af4c5632490e..c3c2ae62d222 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -155,6 +155,14 @@ struct workqueue_struct	*cifsoplockd_wq;
 struct workqueue_struct	*deferredclose_wq;
 __u32 cifs_lock_secret;
 
+extern struct inode *cifs_alloc_inode(struct super_block *);
+extern void cifs_free_inode(struct inode *);
+extern void cifs_evict_inode(struct inode *);
+extern int cifs_write_inode(struct inode *, struct writeback_control *);
+extern int cifs_drop_inode(struct inode *);
+extern int cifs_init_inodecache(void) __init;
+extern void cifs_destroy_inodecache(void);
+
 /*
  * Bumps refcount for cifs super block.
  * Note that it should be only called if a referece to VFS super block is
@@ -349,38 +357,6 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
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
@@ -388,59 +364,6 @@ mempool_t *cifs_sm_req_poolp;
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
@@ -767,21 +690,6 @@ static int cifs_show_stats(struct seq_file *s, struct dentry *root)
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
@@ -789,12 +697,7 @@ static const struct super_operations cifs_super_ops = {
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
@@ -974,139 +877,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
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
@@ -1128,356 +898,6 @@ struct file_system_type smb3_fs_type = {
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
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 08f7392716e2..c95532b6ee72 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -24,6 +24,12 @@
 #include "cifs_ioctl.h"
 #include "fscache.h"
 
+
+extern ssize_t cifs_copy_file_range(struct file *, loff_t, struct file *, loff_t,
+				    size_t, unsigned int);
+extern loff_t cifs_remap_file_range(struct file *, loff_t, struct file *,
+				    loff_t, loff_t, unsigned int);
+
 static void
 renew_parental_timestamps(struct dentry *direntry)
 {
@@ -870,3 +876,26 @@ const struct dentry_operations cifs_ci_dentry_ops = {
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
index 85f2abcb2795..6b39ccede67d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
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
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index eeeaba3dec05..bfa7a2561c6b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -26,6 +26,8 @@
 #include "fs_context.h"
 #include "cifs_ioctl.h"
 
+static struct kmem_cache *cifs_inode_cachep;
+
 static void cifs_set_ops(struct inode *inode)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
@@ -3036,6 +3038,25 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
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
@@ -3062,3 +3083,131 @@ cifs_setattr(struct user_namespace *mnt_userns, struct dentry *direntry,
 	/* BB: add cifs_setattr_legacy for really old servers */
 	return rc;
 }
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
+const struct inode_operations cifs_dir_inode_ops = {
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
+const struct inode_operations cifs_file_inode_ops = {
+	.setattr = cifs_setattr,
+	.getattr = cifs_getattr,
+	.permission = cifs_permission,
+	.listxattr = cifs_listxattr,
+	.fiemap = cifs_fiemap,
+};
+
+const struct inode_operations cifs_symlink_inode_ops = {
+	.get_link = cifs_get_link,
+	.permission = cifs_permission,
+	.listxattr = cifs_listxattr,
+};
-- 
2.35.3

