From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] Revert "CIFS: Fix write after setting a read lock
 for read oplock files"
Date: Tue, 1 Jan 2013 06:29:08 -0500
Message-ID: <20130101062908.12bae108@tlielax.poochiereds.net>
References: <1356537234-11507-1-git-send-email-piastry@etersoft.ru>
	<1356537234-11507-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356537234-11507-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 26 Dec 2012 19:53:52 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> that solution has data races and can end up two identical writes to the
> server: when clientCanCacheAll value can be changed during the execution
> of __generic_file_aio_write.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   |  1 -
>  fs/cifs/cifsglob.h |  1 -
>  fs/cifs/file.c     | 94 ++++++++++++++++++------------------------------------
>  3 files changed, 31 insertions(+), 65 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f653835..de7f916 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -228,7 +228,6 @@ cifs_alloc_inode(struct super_block *sb)
>  	cifs_set_oplock_level(cifs_inode, 0);
>  	cifs_inode->delete_pending = false;
>  	cifs_inode->invalid_mapping = false;
> -	cifs_inode->leave_pages_clean = false;
>  	cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
>  	cifs_inode->server_eof = 0;
>  	cifs_inode->uniqueid = 0;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index aea1eec..dfab450 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1030,7 +1030,6 @@ struct cifsInodeInfo {
>  	bool clientCanCacheAll;		/* read and writebehind oplock */
>  	bool delete_pending;		/* DELETE_ON_CLOSE is set */
>  	bool invalid_mapping;		/* pagecache is invalid */
> -	bool leave_pages_clean;	/* protected by i_mutex, not set pages dirty */
>  	unsigned long time;		/* jiffies of last update of inode */
>  	u64  server_eof;		/* current file size on server -- protected by i_lock */
>  	u64  uniqueid;			/* server inode number */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0a6677b..1b322d0 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2103,15 +2103,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
>  	} else {
>  		rc = copied;
>  		pos += copied;
> -		/*
> -		 * When we use strict cache mode and cifs_strict_writev was run
> -		 * with level II oplock (indicated by leave_pages_clean field of
> -		 * CIFS_I(inode)), we can leave pages clean - cifs_strict_writev
> -		 * sent the data to the server itself.
> -		 */
> -		if (!CIFS_I(inode)->leave_pages_clean ||
> -		    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO))
> -			set_page_dirty(page);
> +		set_page_dirty(page);
>  	}
>  
>  	if (rc > 0) {
> @@ -2462,8 +2454,8 @@ ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
>  }
>  
>  static ssize_t
> -cifs_pagecache_writev(struct kiocb *iocb, const struct iovec *iov,
> -		      unsigned long nr_segs, loff_t pos, bool cache_ex)
> +cifs_writev(struct kiocb *iocb, const struct iovec *iov,
> +	    unsigned long nr_segs, loff_t pos)
>  {
>  	struct file *file = iocb->ki_filp;
>  	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
> @@ -2485,12 +2477,8 @@ cifs_pagecache_writev(struct kiocb *iocb, const struct iovec *iov,
>  				     server->vals->exclusive_lock_type, NULL,
>  				     CIFS_WRITE_OP)) {
>  		mutex_lock(&inode->i_mutex);
> -		if (!cache_ex)
> -			cinode->leave_pages_clean = true;
>  		rc = __generic_file_aio_write(iocb, iov, nr_segs,
> -					      &iocb->ki_pos);
> -		if (!cache_ex)
> -			cinode->leave_pages_clean = false;
> +					       &iocb->ki_pos);
>  		mutex_unlock(&inode->i_mutex);
>  	}
>  
> @@ -2517,62 +2505,42 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>  	struct cifsFileInfo *cfile = (struct cifsFileInfo *)
>  						iocb->ki_filp->private_data;
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> -	ssize_t written, written2;
> +
> +#ifdef CONFIG_CIFS_SMB2
>  	/*
> -	 * We need to store clientCanCacheAll here to prevent race
> -	 * conditions - this value can be changed during an execution
> -	 * of generic_file_aio_write. For CIFS it can be changed from
> -	 * true to false only, but for SMB2 it can be changed both from
> -	 * true to false and vice versa. So, we can end up with a data
> -	 * stored in the cache, not marked dirty and not sent to the
> -	 * server if this value changes its state from false to true
> -	 * after cifs_write_end.
> +	 * If we have an oplock for read and want to write a data to the file
> +	 * we need to store it in the page cache and then push it to the server
> +	 * to be sure the next read will get a valid data.
>  	 */
> -	bool cache_ex = cinode->clientCanCacheAll;
> -	bool cache_read = cinode->clientCanCacheRead;
> -	int rc;
> -	loff_t saved_pos;
> +	if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead) {
> +		ssize_t written;
> +		int rc;
> +
> +		written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> +		rc = filemap_fdatawrite(inode->i_mapping);
> +		if (rc)
> +			return (ssize_t)rc;
>  
> -	if (cache_ex) {
> -		if (cap_unix(tcon->ses) &&
> -		    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
> -		    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(
> -						tcon->fsUnixInfo.Capability)))
> -			return generic_file_aio_write(iocb, iov, nr_segs, pos);
> -		return cifs_pagecache_writev(iocb, iov, nr_segs, pos, cache_ex);
> +		return written;
>  	}
> +#endif
>  
>  	/*
> -	 * For files without exclusive oplock in strict cache mode we need to
> -	 * write the data to the server exactly from the pos to pos+len-1 rather
> -	 * than flush all affected pages because it may cause a error with
> -	 * mandatory locks on these pages but not on the region from pos to
> -	 * ppos+len-1.
> +	 * For non-oplocked files in strict cache mode we need to write the data
> +	 * to the server exactly from the pos to pos+len-1 rather than flush all
> +	 * affected pages because it may cause a error with mandatory locks on
> +	 * these pages but not on the region from pos to ppos+len-1.
>  	 */
> -	written = cifs_user_writev(iocb, iov, nr_segs, pos);
> -	if (!cache_read || written <= 0)
> -		return written;
>  
> -	saved_pos = iocb->ki_pos;
> -	iocb->ki_pos = pos;
> -	/* we have a read oplock - need to store a data in the page cache */
> +	if (!cinode->clientCanCacheAll)
> +		return cifs_user_writev(iocb, iov, nr_segs, pos);
> +
>  	if (cap_unix(tcon->ses) &&
> -	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
> -	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(
> -					tcon->fsUnixInfo.Capability)))
> -		written2 = generic_file_aio_write(iocb, iov, nr_segs, pos);
> -	else
> -		written2 = cifs_pagecache_writev(iocb, iov, nr_segs, pos,
> -						 cache_ex);
> -	/* errors occured during writing - invalidate the page cache */
> -	if (written2 < 0) {
> -		rc = cifs_invalidate_mapping(inode);
> -		if (rc)
> -			written = (ssize_t)rc;
> -		else
> -			iocb->ki_pos = saved_pos;
> -	}
> -	return written;
> +	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
> +	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
> +		return generic_file_aio_write(iocb, iov, nr_segs, pos);
> +
> +	return cifs_writev(iocb, iov, nr_segs, pos);
>  }
>  
>  static struct cifs_readdata *

Straightforward...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
