From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix wrong pos argument of cifs_find_lock_conflict
Date: Fri, 14 Feb 2014 14:28:36 -0500
Message-ID: <20140214142836.693db0e0@tlielax.poochiereds.net>
References: <1392370263-10364-1-git-send-email-piastry@etersoft.ru>
	<1392370263-10364-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392370263-10364-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Feb 2014 13:31:03 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> and use generic_file_aio_write rather than __generic_file_aio_write
> in cifs_writev.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Al reported this, so you may want to add:

Reported-by: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

...and cc him.

> ---
>  fs/cifs/file.c |   24 ++++++------------------
>  1 file changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index a7eda8e..d34dc3b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2539,31 +2539,19 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
>  	struct cifsInodeInfo *cinode = CIFS_I(inode);
>  	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
>  	ssize_t rc = -EACCES;
> +	loff_t lock_pos = pos;
>  
> -	BUG_ON(iocb->ki_pos != pos);
> -
> +	if (file->f_flags & O_APPEND)
> +		lock_pos = i_size_read(inode);

Hmm...

I'll note that when we do the i_size_read in generic_write_checks, the
i_mutex is held. It's not held here though -- is that a potential race?
Could the i_size change after you check for locks but before you do the
I/O?

vfs.txt says:

"Adding and removing pages to/from an address_space is protected by the
inode's i_mutex."

That said, I don't have a great feel for how the locking rules work in
this regard...

>  	/*
>  	 * We need to hold the sem to be sure nobody modifies lock list
>  	 * with a brlock that prevents writing.
>  	 */
>  	down_read(&cinode->lock_sem);
> -	if (!cifs_find_lock_conflict(cfile, pos, iov_length(iov, nr_segs),
> +	if (!cifs_find_lock_conflict(cfile, lock_pos, iov_length(iov, nr_segs),
>  				     server->vals->exclusive_lock_type, NULL,
> -				     CIFS_WRITE_OP)) {
> -		mutex_lock(&inode->i_mutex);
> -		rc = __generic_file_aio_write(iocb, iov, nr_segs,
> -					       &iocb->ki_pos);
> -		mutex_unlock(&inode->i_mutex);
> -	}
> -
> -	if (rc > 0) {
> -		ssize_t err;
> -
> -		err = generic_write_sync(file, iocb->ki_pos - rc, rc);
> -		if (err < 0)
> -			rc = err;
> -	}
> -
> +				     CIFS_WRITE_OP))
> +		rc = generic_file_aio_write(iocb, iov, nr_segs, pos);
>  	up_read(&cinode->lock_sem);
>  	return rc;
>  }


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
