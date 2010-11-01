From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New read logic
Date: Mon, 1 Nov 2010 13:19:30 -0400
Message-ID: <20101101131930.18d35c34@tlielax.poochiereds.net>
References: <AANLkTimbGk9zKbVBU+Fd-d4XwQdFyEJFzcxi84dVEjQx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimbGk9zKbVBU+Fd-d4XwQdFyEJFzcxi84dVEjQx-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 31 Oct 2010 22:44:13 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Add cifs_file_aio_read to let the client works with strict cache mode.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   34 ++++++++++++++++++++++++++++++++--
>  1 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index e8b9523..21e0f47 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -570,6 +570,36 @@ cifs_get_sb(struct file_system_type *fs_type,
>  	return 0;
>  }
> 
> +static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
> +				   unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode;
> +	struct cifs_sb_info *cifs_sb;
> +	ssize_t read;
> +
> +	inode = iocb->ki_filp->f_path.dentry->d_inode;
> +	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
> +
> +	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0) {
> +		int retval;
> +
> +		retval = cifs_revalidate_file(iocb->ki_filp);
> +		if (retval < 0)
> +			return (loff_t)retval;
> +
		^^^^^^^^^^^^^^
I don't think we can reasonably do the above without some discussion of
increasing the attribute cache timeout. It's currently hardcoded to 1s
in cifs_inode_needs_reval.

Doing a QFileInfo every second in order to see if the file has changed
seems prohibitively expensive. OTOH, streaming reads without ever
checking to see whether it has changed is dangerous. We'll have to try
and strike a balance here.

What may be best is to add a actimeo mount option that sets that value
to something sane (60s?) and allows people to set to whatever they
like. Even better might be a sliding scale like NFS uses -- set the
value to something low (and user-settable) initially and every time we
check it and it hasn't changed, double the timeout up to a maximum
(also settable by user).

> +		return generic_file_aio_read(iocb, iov, nr_segs, pos);
> +	}
> +
> +	if (!CIFS_I(inode)->clientCanCacheRead) {
> +		read = cifs_user_read(iocb->ki_filp, iov->iov_base,
> +				      iov->iov_len, &pos);
> +		iocb->ki_pos = pos;
> +	} else
> +		read = generic_file_aio_read(iocb, iov, nr_segs, pos);
> +
> +	return read;
> +}
> +
>  static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  				   unsigned long nr_segs, loff_t pos)
>  {
> @@ -692,7 +722,7 @@ const struct inode_operations cifs_symlink_inode_ops = {
>  const struct file_operations cifs_file_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_file_aio_read,
>  	.aio_write = cifs_file_aio_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
> @@ -729,7 +759,7 @@ const struct file_operations cifs_file_direct_ops = {
>  const struct file_operations cifs_file_nobrl_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_file_aio_read,
>  	.aio_write = cifs_file_aio_write,
>  	.open = cifs_open,
>  	.release = cifs_close,


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
