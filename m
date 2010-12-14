From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] CIFS: Implement cifs_strict_write
Date: Tue, 14 Dec 2010 08:40:53 -0500
Message-ID: <20101214084053.0da711a2@tlielax.poochiereds.net>
References: <1292325060-8828-1-git-send-email-piastryyy@gmail.com>
	<1292325060-8828-4-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292325060-8828-4-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Dec 2010 14:10:58 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> If we don't have Exclusive oplock we write a data to the server through
> cifs_write. Also set invalidate_mapping flag on the inode if we wrote
> something to the server.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c    |   74 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/cifs/cifsproto.h |    3 ++
>  fs/cifs/file.c      |    5 +--
>  3 files changed, 75 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index a218afe..5df0503 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -572,15 +572,81 @@ cifs_do_mount(struct file_system_type *fs_type,
>  	return dget(sb->s_root);
>  }
>  
> +static ssize_t cifs_strict_write(struct kiocb *iocb, const struct iovec *iov,
> +				 unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode;
> +	struct cifs_sb_info *cifs_sb;
> +	ssize_t written = 0;
> +	unsigned long i, len = 0;
> +	char *buf, *offset;
> +
> +	inode = iocb->ki_filp->f_path.dentry->d_inode;
> +
> +	if (CIFS_I(inode)->clientCanCacheAll)
> +		return generic_file_aio_write(iocb, iov, nr_segs, pos);
> +
> +	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
> +
> +	/*
> +	 * In strict cache mode we need to write the data to the server exactly
> +	 * from the pos to pos+len-1 rather than flush all affected pages
> +	 * because it may cause a error with mandatory locks on these pages but
> +	 * not on the region from pos to ppos+len-1.
> +	 */
> +
> +	for (i = 0; i < nr_segs; i++)
> +		len += iov[i].iov_len;
> +
> +	/*
> +	 * BB - optimize the way when signing is disabled. We can drop this
> +	 * extra memory-to-memory copying and use iovec buffers for constructing
> +	 * write request.
> +	 */
> +
> +	buf = kmalloc(len, GFP_KERNEL);
> +

Actually...I thought about another problem here. Suppose an application
does a 100M write. This may fail in that case. It varies by the slab
allocator in use, but there are limits to how large you can kmalloc.
This is especially going to be a problem on 32-bit arches where
GFP_KERNEL memory is more limited.

There are a couple of different solutions, but I think the best one
would be to stitch together individual pages. Walk the iov array first
and figure out how many pages you're going to need, and kmalloc an iov
array that size. Then start allocating pages (preferably using
GFP_HIGHMEM and kmapping them) and then copy the data to them. Stop
when you get to the wsize limit, and issue a CIFSSMBWrite2 call. When
it returns, pick up where you left off and do it again.

> +	for (i = 0, offset = buf; i < nr_segs; i++) {
> +		if (copy_from_user(offset, iov[i].iov_base, iov[i].iov_len)) {
> +			kfree(buf);
> +			return -EFAULT;
> +		}
> +
> +		offset += iov[i].iov_len;
> +	}
> +
> +	written = cifs_write((struct cifsFileInfo *)iocb->ki_filp->private_data,
> +			     buf, len, &pos);
> +	if (written < 0) {
> +		kfree(buf);
> +		return written;
> +	}
> +
> +	iocb->ki_pos = pos;
> +
> +	if (written > 0)
> +		CIFS_I(inode)->invalid_mapping = true;
> +
> +	kfree(buf);
> +	return written;
> +}
> +
>  static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  				   unsigned long nr_segs, loff_t pos)
>  {
>  	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
>  	ssize_t written;
> +	int rc;
>  
>  	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> -	if (!CIFS_I(inode)->clientCanCacheAll)
> -		filemap_fdatawrite(inode->i_mapping);
> +
> +	if (CIFS_I(inode)->clientCanCacheAll)
> +		return written;
> +
> +	rc = filemap_fdatawrite(inode->i_mapping);
> +	if (rc)
> +		cFYI(1, "cifs_file_aio_write: %d rc on %p inode", rc, inode);
> +
>  	return written;
>  }
>  
> @@ -714,7 +780,7 @@ const struct file_operations cifs_file_strict_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
>  	.aio_read = generic_file_aio_read,
> -	.aio_write = cifs_file_aio_write,
> +	.aio_write = cifs_strict_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
>  	.lock = cifs_lock,
> @@ -770,7 +836,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
>  	.aio_read = generic_file_aio_read,
> -	.aio_write = cifs_file_aio_write,
> +	.aio_write = cifs_strict_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
>  	.fsync = cifs_strict_fsync,
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e6d1481..3a337a9 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -79,6 +79,9 @@ extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
>  extern bool is_valid_oplock_break(struct smb_hdr *smb,
>  				  struct TCP_Server_Info *);
>  extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
> +extern ssize_t cifs_write(struct cifsFileInfo *open_file,
> +			  const char *write_data, size_t write_size,
> +			  loff_t *poffset);
>  extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
>  extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
>  extern unsigned int smbCalcSize(struct smb_hdr *ptr);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index dd1e59a..2c848ef 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1026,9 +1026,8 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
>  	return total_written;
>  }
>  
> -static ssize_t cifs_write(struct cifsFileInfo *open_file,
> -			  const char *write_data, size_t write_size,
> -			  loff_t *poffset)
> +ssize_t cifs_write(struct cifsFileInfo *open_file, const char *write_data,
> +		   size_t write_size, loff_t *poffset)
>  {
>  	int rc = 0;
>  	unsigned int bytes_written = 0;


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
