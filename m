From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] CIFS: Implement cifs_strict_readv (try #3)
Date: Mon, 27 Dec 2010 10:35:56 -0500
Message-ID: <20101227103556.20f329d1@tlielax.poochiereds.net>
References: <1293357858-10006-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293357858-10006-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 26 Dec 2010 13:04:17 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Read from the cache if we have at least Level II oplock - otherwise
> read from the server. Add cifs_user_readv to let the client read into
> iovec buffers.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |    4 +-
>  fs/cifs/cifsfs.h |    6 ++-
>  fs/cifs/file.c   |  112 ++++++++++++++++++++++++++++++++++++++---------------
>  3 files changed, 87 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 2b52020..0d6b005 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -714,7 +714,7 @@ const struct file_operations cifs_file_ops = {
>  const struct file_operations cifs_file_strict_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_strict_readv,
>  	.aio_write = cifs_file_aio_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
> @@ -770,7 +770,7 @@ const struct file_operations cifs_file_nobrl_ops = {
>  const struct file_operations cifs_file_strict_nobrl_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
> -	.aio_read = generic_file_aio_read,
> +	.aio_read = cifs_strict_readv,
>  	.aio_write = cifs_file_aio_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 657738f..6ff3ca2 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -81,7 +81,11 @@ extern int cifs_open(struct inode *inode, struct file *file);
>  extern int cifs_close(struct inode *inode, struct file *file);
>  extern int cifs_closedir(struct inode *inode, struct file *file);
>  extern ssize_t cifs_user_read(struct file *file, char __user *read_data,
> -			 size_t read_size, loff_t *poffset);
> +			      size_t read_size, loff_t *poffset);
> +extern ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
> +			       unsigned long nr_segs, loff_t pos);
		^^^^
	this can be static. There are no callers of cifs_user_readv.

> +extern ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
> +				 unsigned long nr_segs, loff_t pos);
>  extern ssize_t cifs_user_write(struct file *file, const char __user *write_data,
>  			 size_t write_size, loff_t *poffset);
>  extern int cifs_lock(struct file *, int, struct file_lock *);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d48723c..c3bc65c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1677,20 +1677,27 @@ int cifs_flush(struct file *file, fl_owner_t id)
>  	return rc;
>  }
>  
> -ssize_t cifs_user_read(struct file *file, char __user *read_data,
> -	size_t read_size, loff_t *poffset)
> +static ssize_t
> +cifs_iovec_read(struct file *file, const struct iovec *iov,
> +		 unsigned long nr_segs, loff_t *poffset)
>  {
> -	int rc = -EACCES;
> -	unsigned int bytes_read = 0;
> -	unsigned int total_read = 0;
> -	unsigned int current_read_size;
> +	int rc;
> +	int xid;
> +	unsigned int total_read, bytes_read = 0;
> +	size_t len, cur_len;
> +	int iov_offset = 0;
>  	struct cifs_sb_info *cifs_sb;
>  	struct cifsTconInfo *pTcon;
> -	int xid;
>  	struct cifsFileInfo *open_file;
> -	char *smb_read_data;
> -	char __user *current_offset;
>  	struct smb_com_read_rsp *pSMBr;
> +	char *read_data;
> +
> +	if (!nr_segs)
> +		return 0;
> +
> +	len = iov_length(iov, nr_segs);
> +	if (!len)
> +		return 0;
>  
>  	xid = GetXid();
>  	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> @@ -1700,19 +1707,18 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
>  		FreeXid(xid);
>  		return rc;
>  	}
> +
>  	open_file = file->private_data;
>  	pTcon = tlink_tcon(open_file->tlink);
>  
>  	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
>  		cFYI(1, "attempting read on write only file instance");
>  
> -	for (total_read = 0, current_offset = read_data;
> -	     read_size > total_read;
> -	     total_read += bytes_read, current_offset += bytes_read) {
> -		current_read_size = min_t(const int, read_size - total_read,
> -					  cifs_sb->rsize);
> +	for (total_read = 0; total_read < len; total_read += bytes_read) {
> +		cur_len = min_t(const size_t, len - total_read, cifs_sb->rsize);
>  		rc = -EAGAIN;
> -		smb_read_data = NULL;
> +		read_data = NULL;
> +
>  		while (rc == -EAGAIN) {
>  			int buf_type = CIFS_NO_BUFFER;
>  			if (open_file->invalidHandle) {
> @@ -1720,27 +1726,25 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
>  				if (rc != 0)
>  					break;
>  			}
> -			rc = CIFSSMBRead(xid, pTcon,
> -					 open_file->netfid,
> -					 current_read_size, *poffset,
> -					 &bytes_read, &smb_read_data,
> -					 &buf_type);
> -			pSMBr = (struct smb_com_read_rsp *)smb_read_data;
> -			if (smb_read_data) {
> -				if (copy_to_user(current_offset,
> -						smb_read_data +
> -						4 /* RFC1001 length field */ +
> -						le16_to_cpu(pSMBr->DataOffset),
> -						bytes_read))
> +			rc = CIFSSMBRead(xid, pTcon, open_file->netfid,
> +					 cur_len, *poffset, &bytes_read,
> +					 &read_data, &buf_type);
> +			pSMBr = (struct smb_com_read_rsp *)read_data;
> +			if (read_data) {
> +				char *data_offset = read_data + 4 +
> +						le16_to_cpu(pSMBr->DataOffset);
> +				if (memcpy_toiovecend(iov, data_offset,
> +						      iov_offset, bytes_read))
					^^^^^
			Much better. It's always better to use existing
			infrastructure.

>  					rc = -EFAULT;
> -
>  				if (buf_type == CIFS_SMALL_BUFFER)
> -					cifs_small_buf_release(smb_read_data);
> +					cifs_small_buf_release(read_data);
>  				else if (buf_type == CIFS_LARGE_BUFFER)
> -					cifs_buf_release(smb_read_data);
> -				smb_read_data = NULL;
> +					cifs_buf_release(read_data);
> +				read_data = NULL;
> +				iov_offset += bytes_read;
>  			}
>  		}
> +
>  		if (rc || (bytes_read == 0)) {
>  			if (total_read) {
>  				break;
> @@ -1753,13 +1757,57 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
>  			*poffset += bytes_read;
>  		}
>  	}
> +
>  	FreeXid(xid);
>  	return total_read;
>  }
>  
> +ssize_t cifs_user_read(struct file *file, char __user *read_data,
> +		       size_t read_size, loff_t *poffset)
> +{
> +	struct iovec iov;
> +	iov.iov_base = read_data;
> +	iov.iov_len = read_size;
> +
> +	return cifs_iovec_read(file, &iov, 1, poffset);
> +}
> +
> +ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
> +			unsigned long nr_segs, loff_t pos)
> +{
> +	ssize_t read;
> +
> +	read = cifs_iovec_read(iocb->ki_filp, iov, nr_segs, &pos);
> +	if (read > 0)
> +		iocb->ki_pos = pos;
> +
> +	return read;
> +}
> +

Again, I'd make the above static. If you do that, the compiler will
likely just inline the function into the only caller below.

> +ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
> +			  unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode;
> +
> +	inode = iocb->ki_filp->f_path.dentry->d_inode;
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
> +	return cifs_user_readv(iocb, iov, nr_segs, pos);
> +}
>  
>  static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
> -	loff_t *poffset)
> +			 loff_t *poffset)
>  {
>  	int rc = -EACCES;
>  	unsigned int bytes_read = 0;


Nice work. Other than making that function static, this looks good to
me, so you can add my Reviewed-by once that's been fixed...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
