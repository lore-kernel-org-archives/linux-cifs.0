From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/6] CIFS: Make read call work with strict cache mode
 (try #4)
Date: Tue, 7 Dec 2010 07:26:10 -0500
Message-ID: <20101207072610.50c5810a@tlielax.poochiereds.net>
References: <1291103671-2983-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291103671-2983-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Nov 2010 10:54:30 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Add cifs_file_aio_read where we read from the cache if we have at least
> Level II oplock - otherwise read from the server.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   44 ++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 9c37897..370acdc 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -568,6 +568,46 @@ cifs_do_mount(struct file_system_type *fs_type,
>  	return dget(sb->s_root);
>  }
>  
> +static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
> +				  unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode;
> +	struct cifs_sb_info *cifs_sb;
> +	ssize_t read = 0, retval;
> +	unsigned long i;
> +
> +	inode = iocb->ki_filp->f_path.dentry->d_inode;
> +	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
> +
> +	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0 ||
> +	    CIFS_I(inode)->clientCanCacheRead)
> +		return generic_file_aio_read(iocb, iov, nr_segs, pos);
> +
> +	/*
> +	 * In strict cache mode we need to read from the server all the time
> +	 * if we don't have level II oplock because the server can delay mtime
> +	 * change - so we can't make a decision about inode invalidating.
> +	 * And we can also fail with pagereading if there are mandatory locks
> +	 * on pages affected by this read but not on the region from pos to
> +	 * pos+len-1.
> +	 */
> +
> +	for (i = 0; i < nr_segs; i++) {
> +		retval = cifs_user_read(iocb->ki_filp, iov[i].iov_base,
> +					iov[i].iov_len, &pos);
> +		if (retval < 0) {
> +			read = read ? read : retval;
> +			break;
> +		}
> +
> +		read += retval;
> +	}
> +

Hmmm...that looks a little ugly. There is no batching here, so if the
application sends you an array of very small iovecs, then that becomes
a set of very small reads on the wire. I don't think that's what you
want.
 
> +	iocb->ki_pos = pos;
> +
> +	return read;
> +}
> +
>  static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  				   unsigned long nr_segs, loff_t pos)
>  {
> @@ -690,7 +730,7 @@ const struct inode_operations cifs_symlink_inode_ops = {
>  const struct file_operations cifs_file_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_file_aio_read,
>  	.aio_write = cifs_file_aio_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
> @@ -727,7 +767,7 @@ const struct file_operations cifs_file_direct_ops = {
>  const struct file_operations cifs_file_nobrl_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_file_aio_read,
>  	.aio_write = cifs_file_aio_write,
>  	.open = cifs_open,
>  	.release = cifs_close,


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
