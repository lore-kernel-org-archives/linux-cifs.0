From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 6/6] CIFS: Fix write after setting a read lock for
 read oplock files
Date: Fri, 30 Nov 2012 13:59:52 -0500
Message-ID: <20121130135952.32960483@tlielax.poochiereds.net>
References: <1354112625-30315-1-git-send-email-piastry@etersoft.ru>
	<1354112625-30315-7-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354112625-30315-7-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 28 Nov 2012 18:23:45 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> If we have a read oplock and set a read lock in it, we can't write to the
> locked area - so, filemap_fdatawrite may fail with a no information for a
> userspace application even if we request a write to non-locked area. Fix
> this by checking for brlocks, populating the page cache without marking
> affected pages dirty and directly writing to the server.
> 
> Also remove CONFIG_CIFS_SMB2 ifdefs because it's suitable for both CIFS
> and SMB2 protocols.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |   63 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index e7fc39c..5cfed9c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2109,7 +2109,14 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
>  	} else {
>  		rc = copied;
>  		pos += copied;
> -		set_page_dirty(page);
> +		/*
> +		 * If we don't have write oplock and use the strict cache mode,
> +		 * we can leave pages clean - cifs_strict_writev will send a
> +		 * data to the server itself.
> +		 */
> +		if (CIFS_I(inode)->clientCanCacheAll ||
> +		    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO))
> +			set_page_dirty(page);
>  	}
>  
>  	if (rc > 0) {
> @@ -2460,8 +2467,8 @@ ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov,
>  }
>  
>  static ssize_t
> -cifs_writev(struct kiocb *iocb, const struct iovec *iov,
> -	    unsigned long nr_segs, loff_t pos)
> +cifs_pagecache_writev(struct kiocb *iocb, const struct iovec *iov,
> +		      unsigned long nr_segs, loff_t pos)
>  {
>  	struct file *file = iocb->ki_filp;
>  	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
> @@ -2511,25 +2518,26 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>  	struct cifsFileInfo *cfile = (struct cifsFileInfo *)
>  						iocb->ki_filp->private_data;
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> +	ssize_t written;
>  
> -#ifdef CONFIG_CIFS_SMB2
> -	/*
> -	 * If we have an oplock for read and want to write a data to the file
> -	 * we need to store it in the page cache and then push it to the server
> -	 * to be sure the next read will get a valid data.
> -	 */
> -	if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead) {
> -		ssize_t written;
> -		int rc;
> -
> -		written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> -		rc = filemap_fdatawrite(inode->i_mapping);
> -		if (rc)
> -			return (ssize_t)rc;
> -
> -		return written;
> +	/* we have a read oplock - need to store a data in the page cache */
> +	if (cinode->clientCanCacheRead) {
> +		if (cap_unix(tcon->ses) &&
> +		    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
> +		    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(
> +						tcon->fsUnixInfo.Capability)))
> +			written = generic_file_aio_write(iocb, iov, nr_segs,
> +							 pos);
> +		else
> +			written = cifs_pagecache_writev(iocb, iov, nr_segs,
> +							pos);
> +		/*
> +		 * Errors occured during writing or we have read+write oplock -
> +		 * no need to flush to the server.
> +		 */
> +		if (written < 0 || cinode->clientCanCacheAll)
> +			return written;
>  	}
> -#endif
>  
>  	/*
>  	 * For non-oplocked files in strict cache mode we need to write the data
> @@ -2537,16 +2545,11 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>  	 * affected pages because it may cause a error with mandatory locks on
>  	 * these pages but not on the region from pos to ppos+len-1.
>  	 */
> -
> -	if (!cinode->clientCanCacheAll)
> -		return cifs_user_writev(iocb, iov, nr_segs, pos);
> -
> -	if (cap_unix(tcon->ses) &&
> -	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
> -	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
> -		return generic_file_aio_write(iocb, iov, nr_segs, pos);
> -
> -	return cifs_writev(iocb, iov, nr_segs, pos);
> +	written = cifs_user_writev(iocb, iov, nr_segs, pos);
> +	/* need to restore pos if errors occured */
> +	if (written < 0)
> +		iocb->ki_pos = pos;
> +	return written;
>  }
>  
>  static struct cifs_readdata *

Looks reasonable...

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
