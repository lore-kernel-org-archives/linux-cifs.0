From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify invalidate part
Date: Tue, 12 Apr 2011 10:06:16 -0400
Message-ID: <20110412100616.4af653ab@corrin.poochiereds.net>
References: <1302249408-8971-1-git-send-email-piastry@etersoft.ru>
	<1302249408-8971-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302249408-8971-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  8 Apr 2011 11:56:48 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Simplify many places when we call cifs_revalidate/invalidate to make
> it does what it exactly needs.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |    2 +-
>  fs/cifs/cifsfs.h |    4 +-
>  fs/cifs/file.c   |   16 ++++++--
>  fs/cifs/inode.c  |  114 ++++++++++++++++++++++++++++++++++--------------------
>  4 files changed, 88 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index fb6a2ad..7b29274 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -630,7 +630,7 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
>  		   setting the revalidate time to zero */
>  		CIFS_I(file->f_path.dentry->d_inode)->time = 0;
>  
> -		retval = cifs_revalidate_file(file);
> +		retval = cifs_revalidate_file_attr(file);
>  		if (retval < 0)
>  			return (loff_t)retval;
>  	}

This looks good overall, I think. I'll note though that on getattr,
you're writing back data, presumably to make sure that you get a
correct file size from the server.

Here though in llseek, you're not. Isn't an updated file size important
for the llseek case? If not, then why bother refreshing the attributes
at all?

> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index bb64313..d304584 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -59,9 +59,11 @@ extern int cifs_mkdir(struct inode *, struct dentry *, int);
>  extern int cifs_rmdir(struct inode *, struct dentry *);
>  extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
>  		       struct dentry *);
> +extern int cifs_revalidate_file_attr(struct file *filp);
> +extern int cifs_revalidate_dentry_attr(struct dentry *);
>  extern int cifs_revalidate_file(struct file *filp);
>  extern int cifs_revalidate_dentry(struct dentry *);
> -extern void cifs_invalidate_mapping(struct inode *inode);
> +extern int cifs_invalidate_mapping(struct inode *inode);
>  extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
>  extern int cifs_setattr(struct dentry *, struct iattr *);
>  
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 20a95bb..b1ab963 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1442,8 +1442,13 @@ int cifs_strict_fsync(struct file *file, int datasync)
>  	cFYI(1, "Sync file - name: %s datasync: 0x%x",
>  		file->f_path.dentry->d_name.name, datasync);
>  
> -	if (!CIFS_I(inode)->clientCanCacheRead)
> -		cifs_invalidate_mapping(inode);
> +	if (!CIFS_I(inode)->clientCanCacheRead) {
> +		rc = cifs_invalidate_mapping(inode);
> +		if (rc) {
> +			cFYI(1, "rc: %d during invalidate phase", rc);
> +			rc = 0; /* don't care about it in fsync */
> +		}
> +	}
>  
>  	tcon = tlink_tcon(smbfile->tlink);
>  	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> @@ -1928,8 +1933,11 @@ int cifs_file_strict_mmap(struct file *file, struct vm_area_struct *vma)
>  
>  	xid = GetXid();
>  
> -	if (!CIFS_I(inode)->clientCanCacheRead)
> -		cifs_invalidate_mapping(inode);
> +	if (!CIFS_I(inode)->clientCanCacheRead) {
> +		rc = cifs_invalidate_mapping(inode);
> +		if (rc)
> +			return rc;
> +	}
>  
>  	rc = generic_file_mmap(file, vma);
>  	if (rc == 0)
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index adb6324..5f71e11 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1683,18 +1683,15 @@ cifs_inode_needs_reval(struct inode *inode)
>  /*
>   * Zap the cache. Called when invalid_mapping flag is set.
>   */
> -void
> +int
>  cifs_invalidate_mapping(struct inode *inode)
>  {
> -	int rc;
> +	int rc = 0;
>  	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
>  
>  	cifs_i->invalid_mapping = false;
>  
>  	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
> -		/* write back any cached data */
> -		rc = filemap_write_and_wait(inode->i_mapping);
> -		mapping_set_error(inode->i_mapping, rc);
>  		rc = invalidate_inode_pages2(inode->i_mapping);
>  		if (rc) {
>  			cERROR(1, "%s: could not invalidate inode %p", __func__,
> @@ -1704,56 +1701,52 @@ cifs_invalidate_mapping(struct inode *inode)
>  	}
>  
>  	cifs_fscache_reset_inode_cookie(inode);
> +	return rc;
>  }
>  
> -int cifs_revalidate_file(struct file *filp)
> +int cifs_revalidate_file_attr(struct file *filp)
>  {
>  	int rc = 0;
>  	struct inode *inode = filp->f_path.dentry->d_inode;
>  	struct cifsFileInfo *cfile = (struct cifsFileInfo *) filp->private_data;
>  
>  	if (!cifs_inode_needs_reval(inode))
> -		goto check_inval;
> +		return rc;
>  
>  	if (tlink_tcon(cfile->tlink)->unix_ext)
>  		rc = cifs_get_file_info_unix(filp);
>  	else
>  		rc = cifs_get_file_info(filp);
>  
> -check_inval:
> -	if (CIFS_I(inode)->invalid_mapping)
> -		cifs_invalidate_mapping(inode);
> -
>  	return rc;
>  }
>  
> -/* revalidate a dentry's inode attributes */
> -int cifs_revalidate_dentry(struct dentry *dentry)
> +int cifs_revalidate_dentry_attr(struct dentry *dentry)
>  {
>  	int xid;
>  	int rc = 0;
> -	char *full_path = NULL;
>  	struct inode *inode = dentry->d_inode;
>  	struct super_block *sb = dentry->d_sb;
> +	char *full_path = NULL;
>  
>  	if (inode == NULL)
>  		return -ENOENT;
>  
> -	xid = GetXid();
> -
>  	if (!cifs_inode_needs_reval(inode))
> -		goto check_inval;
> +		return rc;
> +
> +	xid = GetXid();
>  
>  	/* can not safely grab the rename sem here if rename calls revalidate
>  	   since that would deadlock */
>  	full_path = build_path_from_dentry(dentry);
>  	if (full_path == NULL) {
>  		rc = -ENOMEM;
> -		goto check_inval;
> +		goto out;
>  	}
>  
> -	cFYI(1, "Revalidate: %s inode 0x%p count %d dentry: 0x%p d_time %ld "
> -		 "jiffies %ld", full_path, inode, inode->i_count.counter,
> +	cFYI(1, "Update attributes: %s inode 0x%p count %d dentry: 0x%p d_time "
> +		 "%ld jiffies %ld", full_path, inode, inode->i_count.counter,
>  		 dentry, dentry->d_time, jiffies);
>  
>  	if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
> @@ -1762,41 +1755,78 @@ int cifs_revalidate_dentry(struct dentry *dentry)
>  		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
>  					 xid, NULL);
>  
> -check_inval:
> -	if (CIFS_I(inode)->invalid_mapping)
> -		cifs_invalidate_mapping(inode);
> -
> +out:
>  	kfree(full_path);
>  	FreeXid(xid);
>  	return rc;
>  }
>  
> +int cifs_revalidate_file(struct file *filp)
> +{
> +	int rc;
> +	struct inode *inode = filp->f_path.dentry->d_inode;
> +
> +	rc = cifs_revalidate_file_attr(filp);
> +	if (rc)
> +		return rc;
> +
> +	if (CIFS_I(inode)->invalid_mapping)
> +		rc = cifs_invalidate_mapping(inode);
> +	return rc;
> +}
> +
> +/* revalidate a dentry's inode attributes */
> +int cifs_revalidate_dentry(struct dentry *dentry)
> +{
> +	int rc;
> +	struct inode *inode = dentry->d_inode;
> +
> +	rc = cifs_revalidate_dentry_attr(dentry);
> +	if (rc)
> +		return rc;
> +
> +	if (CIFS_I(inode)->invalid_mapping)
> +		rc = cifs_invalidate_mapping(inode);
> +	return rc;
> +}
> +
>  int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
>  		 struct kstat *stat)
>  {
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
>  	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
> -	int err = cifs_revalidate_dentry(dentry);
> -
> -	if (!err) {
> -		generic_fillattr(dentry->d_inode, stat);
> -		stat->blksize = CIFS_MAX_MSGSIZE;
> -		stat->ino = CIFS_I(dentry->d_inode)->uniqueid;
> +	struct inode *inode = dentry->d_inode;
> +	int rc;
>  
> -		/*
> -		 * If on a multiuser mount without unix extensions, and the
> -		 * admin hasn't overridden them, set the ownership to the
> -		 * fsuid/fsgid of the current process.
> -		 */
> -		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
> -		    !tcon->unix_ext) {
> -			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
> -				stat->uid = current_fsuid();
> -			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
> -				stat->gid = current_fsgid();
> +	if (inode && inode->i_mapping && inode->i_mapping->nrpages != 0) {
> +		rc = filemap_write_and_wait(inode->i_mapping);
> +		if (rc) {
> +			mapping_set_error(inode->i_mapping, rc);
> +			return rc;
>  		}
>  	}
> -	return err;
> +
> +	rc = cifs_revalidate_dentry_attr(dentry);
> +	if (rc)
> +		return rc;
> +
> +	generic_fillattr(dentry->d_inode, stat);
> +	stat->blksize = CIFS_MAX_MSGSIZE;
> +	stat->ino = CIFS_I(dentry->d_inode)->uniqueid;
> +
> +	/*
> +	 * If on a multiuser mount without unix extensions, and the admin hasn't
> +	 * overridden them, set the ownership to the fsuid/fsgid of the current
> +	 * process.
> +	 */
> +	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
> +	    !tcon->unix_ext) {
> +		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
> +			stat->uid = current_fsuid();
> +		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
> +			stat->gid = current_fsgid();
> +	}
> +	return rc;
>  }
>  
>  static int cifs_truncate_page(struct address_space *mapping, loff_t from)


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
