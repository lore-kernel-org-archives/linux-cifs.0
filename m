From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/6] CIFS: Implement cifs_strict_fsync
Date: Tue, 14 Dec 2010 09:49:27 -0500
Message-ID: <20101214094927.4ae8df23@tlielax.poochiereds.net>
References: <1292325060-8828-1-git-send-email-piastryyy@gmail.com>
	<1292325060-8828-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292325060-8828-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Dec 2010 14:10:56 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Invalidate inode mapping if we don't have at least Level II oplock in
> cifs_strict_fsync. Also remove filemap_write_and_wait call from cifs_fsync
> because it is previously called from vfs_fsync_range. Add file operations'
> structures for strict cache mode.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   38 ++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsfs.h |    8 ++++++--
>  fs/cifs/file.c   |   36 ++++++++++++++++++++++++++++--------
>  fs/cifs/inode.c  |    8 ++++++--
>  4 files changed, 78 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 3936aa7..7660133 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -710,6 +710,25 @@ const struct file_operations cifs_file_ops = {
>  	.setlease = cifs_setlease,
>  };
>  
> +const struct file_operations cifs_file_strict_ops = {
> +	.read = do_sync_read,
> +	.write = do_sync_write,
> +	.aio_read = generic_file_aio_read,
> +	.aio_write = cifs_file_aio_write,
> +	.open = cifs_open,
> +	.release = cifs_close,
> +	.lock = cifs_lock,
> +	.fsync = cifs_strict_fsync,
> +	.flush = cifs_flush,
> +	.mmap = cifs_file_mmap,
> +	.splice_read = generic_file_splice_read,
> +	.llseek = cifs_llseek,
> +#ifdef CONFIG_CIFS_POSIX
> +	.unlocked_ioctl	= cifs_ioctl,
> +#endif /* CONFIG_CIFS_POSIX */
> +	.setlease = cifs_setlease,
> +};
> +
>  const struct file_operations cifs_file_direct_ops = {
>  	/* no aio, no readv -
>  	   BB reevaluate whether they can be done with directio, no cache */
> @@ -728,6 +747,7 @@ const struct file_operations cifs_file_direct_ops = {
>  	.llseek = cifs_llseek,
>  	.setlease = cifs_setlease,
>  };
> +
>  const struct file_operations cifs_file_nobrl_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> @@ -746,6 +766,24 @@ const struct file_operations cifs_file_nobrl_ops = {
>  	.setlease = cifs_setlease,
>  };
>  
> +const struct file_operations cifs_file_strict_nobrl_ops = {
> +	.read = do_sync_read,
> +	.write = do_sync_write,
> +	.aio_read = generic_file_aio_read,
> +	.aio_write = cifs_file_aio_write,
> +	.open = cifs_open,
> +	.release = cifs_close,
> +	.fsync = cifs_strict_fsync,
> +	.flush = cifs_flush,
> +	.mmap = cifs_file_mmap,
> +	.splice_read = generic_file_splice_read,
> +	.llseek = cifs_llseek,
> +#ifdef CONFIG_CIFS_POSIX
> +	.unlocked_ioctl	= cifs_ioctl,
> +#endif /* CONFIG_CIFS_POSIX */
> +	.setlease = cifs_setlease,
> +};
> +
>  const struct file_operations cifs_file_direct_nobrl_ops = {
>  	/* no mmap, no aio, no readv -
>  	   BB reevaluate whether they can be done with directio, no cache */
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 897b2b2..8584829 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -61,6 +61,7 @@ extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
>  		       struct dentry *);
>  extern int cifs_revalidate_file(struct file *filp);
>  extern int cifs_revalidate_dentry(struct dentry *);
> +extern void cifs_invalidate_mapping(struct inode *inode);
>  extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
>  extern int cifs_setattr(struct dentry *, struct iattr *);
>  
> @@ -72,8 +73,10 @@ extern const struct inode_operations cifs_dfs_referral_inode_operations;
>  /* Functions related to files and directories */
>  extern const struct file_operations cifs_file_ops;
>  extern const struct file_operations cifs_file_direct_ops; /* if directio mnt */
> -extern const struct file_operations cifs_file_nobrl_ops;
> -extern const struct file_operations cifs_file_direct_nobrl_ops; /* no brlocks */
> +extern const struct file_operations cifs_file_strict_ops; /* if strictio mnt */
> +extern const struct file_operations cifs_file_nobrl_ops; /* no brlocks */
> +extern const struct file_operations cifs_file_direct_nobrl_ops;
> +extern const struct file_operations cifs_file_strict_nobrl_ops;
>  extern int cifs_open(struct inode *inode, struct file *file);
>  extern int cifs_close(struct inode *inode, struct file *file);
>  extern int cifs_closedir(struct inode *inode, struct file *file);
> @@ -83,6 +86,7 @@ extern ssize_t cifs_user_write(struct file *file, const char __user *write_data,
>  			 size_t write_size, loff_t *poffset);
>  extern int cifs_lock(struct file *, int, struct file_lock *);
>  extern int cifs_fsync(struct file *, int);
> +extern int cifs_strict_fsync(struct file *, int);
>  extern int cifs_flush(struct file *, fl_owner_t id);
>  extern int cifs_file_mmap(struct file * , struct vm_area_struct *);
>  extern const struct file_operations cifs_dir_ops;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 60c3f84..4e37cb8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1586,27 +1586,47 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
>  	return rc;
>  }
>  
> -int cifs_fsync(struct file *file, int datasync)
> +int cifs_strict_fsync(struct file *file, int datasync)
>  {
>  	int xid;
>  	int rc = 0;
>  	struct cifsTconInfo *tcon;
>  	struct cifsFileInfo *smbfile = file->private_data;
>  	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>  
>  	xid = GetXid();
>  
>  	cFYI(1, "Sync file - name: %s datasync: 0x%x",
>  		file->f_path.dentry->d_name.name, datasync);
>  
> -	rc = filemap_write_and_wait(inode->i_mapping);
> -	if (rc == 0) {
> -		struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
> +	if (!CIFS_I(inode)->clientCanCacheRead)
> +		cifs_invalidate_mapping(inode);
>  
> -		tcon = tlink_tcon(smbfile->tlink);
> -		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> -			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
> -	}
> +	tcon = tlink_tcon(smbfile->tlink);
> +	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> +		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
> +
> +	FreeXid(xid);
> +	return rc;
> +}
> +
> +int cifs_fsync(struct file *file, int datasync)
> +{
> +	int xid;
> +	int rc = 0;
> +	struct cifsTconInfo *tcon;
> +	struct cifsFileInfo *smbfile = file->private_data;
> +	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> +
> +	xid = GetXid();
> +
> +	cFYI(1, "Sync file - name: %s datasync: 0x%x",
> +		file->f_path.dentry->d_name.name, datasync);
> +
> +	tcon = tlink_tcon(smbfile->tlink);
> +	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
> +		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
>  
>  	FreeXid(xid);
>  	return rc;
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 589f3e3..a8f7cf3 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -44,13 +44,17 @@ static void cifs_set_ops(struct inode *inode, const bool is_dfs_referral)
>  				inode->i_fop = &cifs_file_direct_nobrl_ops;
>  			else
>  				inode->i_fop = &cifs_file_direct_ops;
> +		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) {
> +			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
> +				inode->i_fop = &cifs_file_strict_nobrl_ops;
> +			else
> +				inode->i_fop = &cifs_file_strict_ops;
>  		} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
>  			inode->i_fop = &cifs_file_nobrl_ops;
>  		else { /* not direct, send byte range locks */
>  			inode->i_fop = &cifs_file_ops;
>  		}
>  
> -
>  		/* check if server can support readpages */
>  		if (cifs_sb_master_tcon(cifs_sb)->ses->server->maxBuf <
>  				PAGE_CACHE_SIZE + MAX_CIFS_HDR_SIZE)
> @@ -1679,7 +1683,7 @@ cifs_inode_needs_reval(struct inode *inode)
>  /*
>   * Zap the cache. Called when invalid_mapping flag is set.
>   */
> -static void
> +void
>  cifs_invalidate_mapping(struct inode *inode)
>  {
>  	int rc;

Looks good to me.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
