From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New write logic
Date: Tue, 2 Nov 2010 11:43:50 -0400
Message-ID: <20101102114350.59f41db2@tlielax.poochiereds.net>
References: <AANLkTinegdugrKiMn4rErSyfp-t7HK6pYxumAS5DDiya@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinegdugrKiMn4rErSyfp-t7HK6pYxumAS5DDiya-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2 Nov 2010 12:02:24 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Modify cifs_file_aio_write and cifs_write_end to let the client works with
> strict cache mode.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   35 ++++++++++++++++++++++++++++++-----
>  fs/cifs/file.c   |   14 ++++++++++++--
>  2 files changed, 42 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 1b44a92..e1ecd35 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -602,12 +602,37 @@ static ssize_t cifs_file_aio_read(struct kiocb
> *iocb, const struct iovec *iov,
>  static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  				   unsigned long nr_segs, loff_t pos)
>  {
> -	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> -	ssize_t written;
> +	struct inode *inode;
> +	struct cifs_sb_info *cifs_sb;
> +	ssize_t written, cache_written;
> +	loff_t saved_pos;
> +
> +	inode = iocb->ki_filp->f_path.dentry->d_inode;
> +
> +	if (CIFS_I(inode)->clientCanCacheAll)
> +		return generic_file_aio_write(iocb, iov, nr_segs, pos);
> +
> +	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
> +
> +	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0) {
> +		written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> +		filemap_write_and_wait(inode->i_mapping);
		^^^^^^^^^^^^^^^^^^
		You can't ignore the return code from this. That function
		may return an error if writeback fails. Also, I don't
		see any need to wait on the result in this case. Why
		not just kick off the I/O and return (do a
		filemap_fdatawrite, IOW).

> +		return written;
> +	}
> +
> +	saved_pos = pos;
> +	written = cifs_user_write(iocb->ki_filp, iov->iov_base,
> +				  iov->iov_len, &pos);
> +
> +	if (written > 0) {
> +		cache_written = generic_file_aio_write(iocb, iov,
> +						       nr_segs, saved_pos);
> +		if (cache_written != written)
> +			cERROR(1, "Cache written and server written data "
> +			       "lengths are different");
> +	} else
> +		iocb->ki_pos = pos;
> 
	^^^^^
This seems awfully complicated. Why not just do a
generic_file_aio_write to get this into the cache and then just do a
filemap_write_and_wait and deal with the result?

> -	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> -	if (!CIFS_I(inode)->clientCanCacheAll)
> -		filemap_fdatawrite(inode->i_mapping);
>  	return written;
>  }
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 3970e68..4796748 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1539,7 +1539,11 @@ static int cifs_write_end(struct file *file,
> struct address_space *mapping,
>  			struct page *page, void *fsdata)
>  {
>  	int rc;
> -	struct inode *inode = mapping->host;
> +	struct inode *inode;
> +	struct cifs_sb_info *cifs_sb;
> +
> +	inode = mapping->host;
> +	cifs_sb = CIFS_SB(inode->i_sb);
> 
>  	cFYI(1, "write_end for page %p from pos %lld with %d bytes",
>  		 page, pos, copied);
> @@ -1572,7 +1576,13 @@ static int cifs_write_end(struct file *file,
> struct address_space *mapping,
>  	} else {
>  		rc = copied;
>  		pos += copied;
> -		set_page_dirty(page);
> +		/* if we have strict cache switched on and don't have Exclusive
> +		   oplock for the inode, we don't have to set_page_dirty
> +		   because we flushed the data to the server in
> +		   cifs_file_aio_write before */
> +		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0 ||
> +		    CIFS_I(inode)->clientCanCacheAll)
> +			set_page_dirty(page);
>  	}
> 
>  	if (rc > 0) {


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
