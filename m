From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
Date: Tue, 9 Nov 2010 13:10:01 -0500
Message-ID: <20101109131001.56a40c86@corrin.poochiereds.net>
References: <1288945777-9197-1-git-send-email-piastryyy@gmail.com>
	<1288945777-9197-4-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288945777-9197-4-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  5 Nov 2010 11:29:34 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On strict cache mode if we don't have Exclusive oplock we write a data to
> the server through cifs_user_write. Then if we Level II oplock store it in
> the cache, otherwise - invalidate inode pages affected by this writing.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  fs/cifs/file.c   |   14 ++++++++++++--
>  2 files changed, 58 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index bb7f36e..fbcd219 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -596,12 +596,53 @@ static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
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
> +		int rc;
> +
> +		written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> +
> +		rc = filemap_fdatawrite(inode->i_mapping);
> +		if (rc)
> +			cFYI(1, "cifs_file_aio_write: %d rc on %p inode",
> +			     rc, inode);
> +		return written;
> +	}
> +
> +	saved_pos = pos;
> +	written = cifs_user_write(iocb->ki_filp, iov->iov_base,
> +				  iov->iov_len, &pos);
> +
> +	if (written > 0 && CIFS_I(inode)->clientCanCacheRead) {
> +		/* we have data written to the server and at least oplock
> +		   for reading - store the date in the cache */
> +		cache_written = generic_file_aio_write(iocb, iov,
> +						       nr_segs, saved_pos);
> +		if (cache_written != written)
> +			cERROR(1, "Cache written and server written data "
> +			       "lengths are different");
> +		return written;
> +	}
> +
> +	if (written > 0)
> +		invalidate_mapping_pages(inode->i_mapping,
> +					      saved_pos >> PAGE_CACHE_SHIFT,
> +					      (saved_pos+iov->iov_len-1)
> +					      >> PAGE_CACHE_SHIFT);
> +
> +	iocb->ki_pos = pos;
>  
> -	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> -	if (!CIFS_I(inode)->clientCanCacheAll)
> -		filemap_fdatawrite(inode->i_mapping);
>  	return written;
>  }
>  
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b36de2e..85824c0 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1537,7 +1537,11 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
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
> @@ -1570,7 +1574,13 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
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

Is there a potential for a race here? Suppose I have clientCanCacheAll
set, I write to the cache, but before I get to cifs_write_end, an
oplock break is processed and clientCanCacheAll is cleared. Now I have
dirty data in cache but the dirty flag doesn't get set. Does anything
prevent that?

>  	}
>  
>  	if (rc > 0) {
