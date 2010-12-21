From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/6] CIFS: Implement cifs_strict_write (try #2)
Date: Tue, 21 Dec 2010 14:09:41 -0500
Message-ID: <20101221140941.17fd3ece@tlielax.poochiereds.net>
References: <1292590154-4768-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292590154-4768-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Dec 2010 15:49:14 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> If we don't have Exclusive oplock we write a data to the server through
> CISSMBWrite2. Also set invalidate_mapping flag on the inode if we wrote
> something to the server.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c    |  228 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/cifs/cifsproto.h |    2 +
>  fs/cifs/file.c      |    2 +-
>  3 files changed, 227 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index bcb4d2c..fb50883 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -606,15 +606,235 @@ static ssize_t cifs_strict_read(struct kiocb *iocb, const struct iovec *iov,
>  	return read;
>  }
>  
> +/* Assume that dest points to memory area that is enough for source data */
> +static int cifs_copy_iovs(struct kvec *dst, const struct iovec **source,
> +			  unsigned long *lastlen, unsigned long len)
> +{
> +	const struct iovec *src = *source;
> +	unsigned long dst_lastlen, src_lastlen;
> +	unsigned long cur_len;
> +
> +	dst_lastlen = dst->iov_len;
> +	src_lastlen = *lastlen;
> +
> +	while (len > 0) {
> +		cur_len = min_t(unsigned long, dst_lastlen, src_lastlen);
> +		cur_len = min_t(unsigned long, cur_len, len);
> +
> +		if (copy_from_user(dst->iov_base + dst->iov_len - dst_lastlen,
> +				   src->iov_base + src->iov_len - src_lastlen,
> +				   cur_len))
> +			return -EFAULT;
> +
> +		dst_lastlen -= cur_len;
> +		if (!dst_lastlen) {
> +			dst++;
> +			dst_lastlen = dst->iov_len;
> +		}
> +
> +		src_lastlen -= cur_len;
> +		if (!src_lastlen) {
> +			src++;
> +			src_lastlen = src->iov_len;
> +		}
> +
> +		len -= cur_len;
> +	}
> +
> +	/* update length of the last element in dest */
> +	if (dst_lastlen)
> +		dst->iov_len -= dst_lastlen;
> +
> +	/* save offset and length of the last element in source */
> +	*lastlen = src_lastlen;
> +	*source = src;
> +
> +	return 0;
> +}
> +
> +static int
> +cifs_strict_write_helper(struct page ***ppages, struct kvec **pto_send,
					^^^^
				Wow, a triple pointer? Ugly...

> +			 unsigned long num_pages)
> +{
> +	int rc = 0;
> +	unsigned long i;
> +	struct page **pages;
> +	struct kvec *to_send;
> +
> +	*ppages = kmalloc(sizeof(struct pages *)*num_pages, GFP_KERNEL);
> +	if (!ppages)
> +		return -ENOMEM;
> +
> +	*pto_send = kmalloc(sizeof(struct kvec)*(num_pages + 1),
> +			  GFP_KERNEL);
> +	if (!pto_send) {
> +		kfree(ppages);
> +		return -ENOMEM;
> +	}
> +
> +	pages = *ppages;
> +	to_send = *pto_send;
> +
> +	for (i = 0; i < num_pages; i++) {
> +		pages[i] = alloc_page(__GFP_HIGHMEM);
> +		if (!pages[i]) {
> +			/*
> +			 * save number of pages we have already allocated and
> +			 * return with ENOMEM error
> +			 */
> +			num_pages = i;
> +			rc = -ENOMEM;
> +			goto error;
> +		}
> +		to_send[i+1].iov_base = kmap(pages[i]);
> +		to_send[i+1].iov_len = PAGE_CACHE_SIZE;

				^^^^^^^^^^^
			kmap space is limited on 32-bit architectures.
			You really want to limit the amount of pages
			that you have simultaneously mapped.

			What's going to happen if someone passes down a
			massive write this way? I expect that it would
			fail badly.

			I think that you really only want to allocate
			the memory needed to perform just the write
			that you're getting ready to perform, and then
			free it when that's done.

> +	}
> +
> +	return rc;
> +
> +error:
> +	for (i = 0; i < num_pages; i++) {
> +		kunmap(pages[i]);
> +		put_page(pages[i]);
> +	}
> +	kfree(to_send);
> +	kfree(pages);
> +	return rc;
> +}
> +

Instead of rolling your own functions for this, might it be better to
try and use the iov_iter infrastructure? Look at what
generic_perform_write does, IOW. This situation is a little different,
but there are similarities.

> +static ssize_t cifs_strict_write(struct kiocb *iocb, const struct iovec *iov,
> +				 unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode;
> +	struct cifs_sb_info *cifs_sb;
> +	ssize_t written = 0, total_written = 0;
> +	unsigned long i, num_pages, cur_numpages;
> +	unsigned long len, cur_len, last_len;
> +	struct kvec *to_send;
> +	const struct iovec *offset;
> +	struct page **pages;
> +	struct cifsFileInfo *open_file;
> +	struct cifsTconInfo *pTcon;
> +	int xid, rc;
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
> +	len = 0;
> +	for (i = 0; i < nr_segs; i++)
> +		len += iov[i].iov_len;
> +
> +	if (!len)
> +		return 0;
> +
> +	/*
> +	 * BB - optimize the way when signing is disabled. We can drop this
> +	 * extra memory-to-memory copying and use iovec buffers for constructing
> +	 * write request.
> +	 */
> +
> +	xid = GetXid();
> +	open_file = iocb->ki_filp->private_data;
> +	pTcon = tlink_tcon(open_file->tlink);
> +
> +	/* calculate number of pages we need for process this write */
> +	cur_len = min_t(unsigned long, len, cifs_sb->wsize);
> +	num_pages = cur_len / PAGE_CACHE_SIZE;
> +	if (cur_len % PAGE_CACHE_SIZE)
> +		num_pages++;
> +
> +	rc = cifs_strict_write_helper(&pages, &to_send, num_pages);
> +	if (rc) {
> +		total_written = rc;
> +		goto error;
> +	}
> +
> +	last_len = iov->iov_len;
> +	offset = iov;
> +	cur_numpages = num_pages;
> +
> +	do {
> +		rc = cifs_copy_iovs(to_send+1, &offset, &last_len, cur_len);
> +		if (rc) {
> +			total_written = -EFAULT;
> +			goto exit;
> +		}
> +
> +		do {
> +			rc = CIFSSMBWrite2(xid, pTcon, open_file->netfid,
> +					   cur_len, pos, &written, to_send,
> +					   cur_numpages, 0);
> +		} while (rc == -EAGAIN);
> +
> +		if (written) {
> +			len -= written;
> +			total_written += written;
> +			cifs_update_eof(CIFS_I(inode), pos, written);
> +			pos += written;
> +		} else if (rc < 0) {
> +			if (!total_written)
> +				total_written = rc;
> +			goto exit;
> +		}
> +
> +		/* get length and number of kvecs of the next write */
> +		cur_len = min_t(unsigned long, len, cifs_sb->wsize);
> +		cur_numpages = cur_len / PAGE_CACHE_SIZE;
> +		if (cur_len % PAGE_CACHE_SIZE)
> +			cur_numpages++;
> +	} while (len > 0);
> +
> +exit:
> +	if (total_written > 0) {
> +		CIFS_I(inode)->invalid_mapping = true;
> +		iocb->ki_pos += total_written;
> +		spin_lock(&inode->i_lock);
> +		if (pos > inode->i_size)
> +			i_size_write(inode, pos);
> +		spin_unlock(&inode->i_lock);
> +	}
> +
> +	cifs_stats_bytes_written(pTcon, total_written);
> +	mark_inode_dirty_sync(inode);
> +
> +	for (i = 0; i < num_pages; i++) {
> +		kunmap(pages[i]);
> +		put_page(pages[i]);
> +	}
> +	kfree(to_send);
> +	kfree(pages);
> +error:
> +	FreeXid(xid);
> +	return total_written;
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
> @@ -748,7 +968,7 @@ const struct file_operations cifs_file_strict_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
>  	.aio_read = cifs_strict_read,
> -	.aio_write = cifs_file_aio_write,
> +	.aio_write = cifs_strict_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
>  	.lock = cifs_lock,
> @@ -804,7 +1024,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
>  	.read = do_sync_read,
>  	.write = do_sync_write,
>  	.aio_read = cifs_strict_read,
> -	.aio_write = cifs_file_aio_write,
> +	.aio_write = cifs_strict_write,
>  	.open = cifs_open,
>  	.release = cifs_close,
>  	.fsync = cifs_strict_fsync,
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e6d1481..e7d6c24 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -79,6 +79,8 @@ extern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length);
>  extern bool is_valid_oplock_break(struct smb_hdr *smb,
>  				  struct TCP_Server_Info *);
>  extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
> +extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
> +			    unsigned int bytes_written);
>  extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
>  extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
>  extern unsigned int smbCalcSize(struct smb_hdr *ptr);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index bc53e9e..8260f53 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -924,7 +924,7 @@ cifs_write_timeout(struct cifsInodeInfo *cifsi, loff_t offset)
>  }
>  
>  /* update the file size (if needed) after a write */
> -static void
> +void
>  cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
>  		      unsigned int bytes_written)
>  {


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
