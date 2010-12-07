From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
 (try #4)
Date: Tue, 7 Dec 2010 07:29:32 -0500
Message-ID: <20101207072932.6fd6963f@tlielax.poochiereds.net>
References: <1291103671-2983-1-git-send-email-piastryyy@gmail.com>
	<1291103671-2983-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291103671-2983-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Nov 2010 10:54:31 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On strict cache mode if we don't have Exclusive oplock we write a data to
> the server through cifs_user_write. Then if we Level II oplock store it in
> the cache, otherwise - invalidate inode pages affected by this writing.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 46 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 370acdc..df17261 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -611,12 +611,53 @@ static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  				   unsigned long nr_segs, loff_t pos)
>  {
> -	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> -	ssize_t written;
> +	struct inode *inode;
> +	struct cifs_sb_info *cifs_sb;
> +	ssize_t written = 0, retval;
> +	unsigned long i;
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
> +	/*
> +	 * In strict cache mode we need to write the data to the server exactly
> +	 * from the pos to pos+len-1 rather than flush all affected pages
> +	 * because it may cause a error with mandatory locks on these pages but
> +	 * not on the region from pos to ppos+len-1.
> +	 */
> +
> +	for (i = 0; i < nr_segs; i++) {
> +		retval = cifs_user_write(iocb->ki_filp, iov[i].iov_base,
> +					 iov[i].iov_len, &pos);
> +		if (retval < 0) {
> +			written = written ? written : retval;
> +			break;
> +		}
> +
> +		written += retval;
> +	}
> +

Same problem as with the read patch. This is going to mean a bunch of
small writes on the wire just because the application sent you a set of
small iovecs. I think you want to batch those up into smaller set of
writes.

> +	iocb->ki_pos = pos;
> +
> +	if (written > 0)
> +		CIFS_I(inode)->invalid_mapping = true;
>  
> -	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> -	if (!CIFS_I(inode)->clientCanCacheAll)
> -		filemap_fdatawrite(inode->i_mapping);
>  	return written;
>  }
>  


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
