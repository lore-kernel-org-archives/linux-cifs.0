From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] CIFS: New read logic
Date: Tue, 2 Nov 2010 11:36:06 -0400
Message-ID: <20101102113606.292e6794@tlielax.poochiereds.net>
References: <AANLkTin6dgy-0SJnaL-aXW1FiaOK-cxKbc+qSe3gW=KR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin6dgy-0SJnaL-aXW1FiaOK-cxKbc+qSe3gW=KR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2 Nov 2010 12:01:54 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Add cifs_file_aio_read to let the client works with strict cache mode.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   34 ++++++++++++++++++++++++++++++++--
>  1 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 75c4eaa..1b44a92 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -569,6 +569,36 @@ cifs_do_mount(struct file_system_type *fs_type,
>  	return dget(sb->s_root);
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
> +		return generic_file_aio_read(iocb, iov, nr_segs, pos);
> +	}
> +

I think checking the validity of the file before doing cache reads is
the right thing to do. The problem is that the default attribute cache
timeout of 1s will make that prohibitively expensive.

We would be issuing a new QFileInfo call every second while reading a
file. If the file is not in cache, then you also have to issue a read
afterward. The cumulative effect will probably be slower than if you
had just issued the read anyway.

Given that we just call generic_file_aio_read today, I suggest just
skipping the revalidation for now. We can revisit that when we're
prepared to deal with the attribute cache timeout more extensively.

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
> @@ -691,7 +721,7 @@ const struct inode_operations cifs_symlink_inode_ops = {
>  const struct file_operations cifs_file_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_file_aio_read,
>  	.aio_write = cifs_file_aio_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
> @@ -728,7 +758,7 @@ const struct file_operations cifs_file_direct_ops = {
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
