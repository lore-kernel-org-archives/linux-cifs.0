From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] CIFS: Implement cifs_strict_read
Date: Tue, 14 Dec 2010 09:46:50 -0500
Message-ID: <20101214094650.451bc6d0@tlielax.poochiereds.net>
References: <1292325060-8828-1-git-send-email-piastryyy@gmail.com>
	<1292325060-8828-5-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292325060-8828-5-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Dec 2010 14:10:59 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Read from the cache if we have at least Level II oplock - otherwise
> read from the server. Add cifs_user_readv to let the client read into
> several buffers.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   43 +++++++++++++++++++++++++++++-
>  fs/cifs/cifsfs.h |    5 +++-
>  fs/cifs/file.c   |   76 ++++++++++++++++++++++++++++++++++++++++++++++-------
>  3 files changed, 111 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 5df0503..a47b8af 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -572,6 +572,45 @@ cifs_do_mount(struct file_system_type *fs_type,
>  	return dget(sb->s_root);
>  }
>  
> +static ssize_t cifs_strict_read(struct kiocb *iocb, const struct iovec *iov,
> +				unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode;
> +	struct cifs_sb_info *cifs_sb;
> +	ssize_t read = 0;
> +	unsigned long i, len = 0;
> +
> +	if (!nr_segs)
> +		return read;
> +
> +	inode = iocb->ki_filp->f_path.dentry->d_inode;
> +	cifs_sb = CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
> +
> +	if (CIFS_I(inode)->clientCanCacheRead)
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
> +	for (i = 0; i < nr_segs; i++)
> +		len += iov[i].iov_len;
> +
> +
> +	read = cifs_user_readv(iocb->ki_filp, iov, nr_segs, len, &pos);
> +	if (read < 0)
> +		return read;
> +
> +	iocb->ki_pos = pos;
> +
> +	return read;
> +}
> +
>  static ssize_t cifs_strict_write(struct kiocb *iocb, const struct iovec *iov,
>  				 unsigned long nr_segs, loff_t pos)
>  {
> @@ -779,7 +818,7 @@ const struct file_operations cifs_file_ops = {
>  const struct file_operations cifs_file_strict_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_strict_read,
>  	.aio_write = cifs_strict_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
> @@ -835,7 +874,7 @@ const struct file_operations cifs_file_nobrl_ops = {
>  const struct file_operations cifs_file_strict_nobrl_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_strict_read,
>  	.aio_write = cifs_strict_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 657738f..a6bea06 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -81,7 +81,10 @@ extern int cifs_open(struct inode *inode, struct file *file);
>  extern int cifs_close(struct inode *inode, struct file *file);
>  extern int cifs_closedir(struct inode *inode, struct file *file);
>  extern ssize_t cifs_user_read(struct file *file, char __user *read_data,
> -			 size_t read_size, loff_t *poffset);
> +			      size_t read_size, loff_t *poffset);
> +extern ssize_t cifs_user_readv(struct file *file, const struct iovec *iov,
> +			       unsigned long nr_segs, size_t len,
> +			       loff_t *poffset);
>  extern ssize_t cifs_user_write(struct file *file, const char __user *write_data,
>  			 size_t write_size, loff_t *poffset);
>  extern int cifs_lock(struct file *, int, struct file_lock *);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 2c848ef..9238a2f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1676,8 +1676,40 @@ int cifs_flush(struct file *file, fl_owner_t id)
>  	return rc;
>  }
>  
> -ssize_t cifs_user_read(struct file *file, char __user *read_data,
> -	size_t read_size, loff_t *poffset)
> +static int
> +cifs_fill_iov(const struct iovec *iov, unsigned long nr_segs,
> +	      unsigned long *last_len, unsigned long *last_ind, char *data,
> +	      size_t datalen)
> +{
> +	const struct iovec *ciov;
> +	unsigned long cur_len;
> +
> +	while (datalen) {
> +		cur_len = min_t(unsigned long, datalen,
> +					      *last_len);
> +		ciov = &iov[*last_ind];
> +
> +		if (copy_to_user(ciov->iov_base + (ciov->iov_len - *last_len),
> +				 data, cur_len))
> +			return -EFAULT;
> +
> +		datalen -= cur_len;
> +		data += cur_len;
> +
> +		*last_len -= cur_len;
> +		if (*last_len == 0) {
> +			(*last_ind)++;
> +			*last_len = iov[*last_ind].iov_len;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t
> +cifs_generic_user_read(struct file *file, char __user *read_data,
> +		       size_t read_size, loff_t *poffset,
> +		       const struct iovec *iov, unsigned long nr_segs)
>  {
>  	int rc = -EACCES;
>  	unsigned int bytes_read = 0;
> @@ -1690,6 +1722,11 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
>  	char *smb_read_data;
>  	char __user *current_offset;
>  	struct smb_com_read_rsp *pSMBr;
> +	unsigned long last_len = 0, last_ind = 0;
> +
> +	/* if vectored - set last_len value */
> +	if (!read_data && nr_segs > 0)
> +		last_len = iov->iov_len;
>  
	^^^^
cifs_user_read can just be the trivial case of cifs_user_readv. It just
has a nr_segs of 1.

Rather than do this, it would probably be cleaner to just drop the
"read_data" and "read_size" parms from this function. Then make
cifs_user_read a wrapper around the cifs_user_readv that declares a
single iovec and passes in nr_segs of 1.

See smb_send and smb_sendv for an example of what I mean.


>  	xid = GetXid();
>  	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> @@ -1707,7 +1744,8 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
>  
>  	for (total_read = 0, current_offset = read_data;
>  	     read_size > total_read;
> -	     total_read += bytes_read, current_offset += bytes_read) {
> +	     total_read += bytes_read,
> +	     current_offset += read_data ? bytes_read : 0) {
>  		current_read_size = min_t(const int, read_size - total_read,
>  					  cifs_sb->rsize);
>  		rc = -EAGAIN;
> @@ -1726,12 +1764,18 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
>  					 &buf_type);
>  			pSMBr = (struct smb_com_read_rsp *)smb_read_data;
>  			if (smb_read_data) {
> -				if (copy_to_user(current_offset,
> -						smb_read_data +
> -						4 /* RFC1001 length field */ +
> -						le16_to_cpu(pSMBr->DataOffset),
> -						bytes_read))
> -					rc = -EFAULT;
> +				char *data_offset = smb_read_data + 4 +
> +						le16_to_cpu(pSMBr->DataOffset);
> +				if (read_data) {
> +					if (copy_to_user(current_offset,
> +						data_offset, bytes_read))
> +						rc = -EFAULT;
> +				} else {
> +					if (cifs_fill_iov(iov, nr_segs,
> +						&last_len, &last_ind,
> +						data_offset, bytes_read))
> +						rc = -EFAULT;
> +				}
>  
>  				if (buf_type == CIFS_SMALL_BUFFER)
>  					cifs_small_buf_release(smb_read_data);
> @@ -1756,9 +1800,21 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
>  	return total_read;
>  }
>  
> +ssize_t cifs_user_read(struct file *file, char __user *read_data,
> +		       size_t read_size, loff_t *poffset)
> +{
> +	return cifs_generic_user_read(file, read_data, read_size, poffset, NULL,
> +				      0);
> +}
> +
> +ssize_t cifs_user_readv(struct file *file, const struct iovec *iov,
> +			unsigned long nr_segs, size_t len, loff_t *poffset)
> +{
> +	return cifs_generic_user_read(file, NULL, len, poffset, iov, nr_segs);
> +}
>  
>  static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
> -	loff_t *poffset)
> +			 loff_t *poffset)
>  {
>  	int rc = -EACCES;
>  	unsigned int bytes_read = 0;


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
