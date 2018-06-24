From: Tom Talpey <tom@talpey.com>
Subject: Re: [Patch v2 13/15] CIFS: Add support for direct I/O read
Date: Sat, 23 Jun 2018 22:39:44 -0400
Message-ID: <c8d8b852-b621-4f83-b127-535a10c0538d@talpey.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
 <20180530194807.31657-14-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-14-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



On 5/30/2018 3:48 PM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> Implement the function for direct I/O read. It doesn't support AIO, which
> will be implemented in a follow up patch.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>   fs/cifs/cifsfs.h |   1 +
>   fs/cifs/file.c   | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 150 insertions(+)
> 
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 5f02318..7fba9aa 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -102,6 +102,7 @@ extern int cifs_open(struct inode *inode, struct file *file);
>   extern int cifs_close(struct inode *inode, struct file *file);
>   extern int cifs_closedir(struct inode *inode, struct file *file);
>   extern ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to);
> +extern ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to);
>   extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to);
>   extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from);
>   extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 87eece6..e6e6f24 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2955,6 +2955,18 @@ cifs_read_allocate_pages(struct cifs_readdata *rdata, unsigned int nr_pages)
>   	return rc;
>   }
>   
> +static void cifs_direct_readdata_release(struct kref *refcount)
> +{
> +	struct cifs_readdata *rdata = container_of(refcount,
> +					struct cifs_readdata, refcount);
> +	unsigned int i;
> +
> +	for (i = 0; i < rdata->nr_pages; i++)
> +		put_page(rdata->pages[i]);
> +
> +	cifs_readdata_release(refcount);
> +}
> +
>   static void
>   cifs_uncached_readdata_release(struct kref *refcount)
>   {
> @@ -3267,6 +3279,143 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
>   		complete(&ctx->done);
>   }
>   
> +static void cifs_direct_readv_complete(struct work_struct *work)
> +{
> +	struct cifs_readdata *rdata =
> +		container_of(work, struct cifs_readdata, work);
> +
> +	complete(&rdata->done);
> +	kref_put(&rdata->refcount, cifs_direct_readdata_release);
> +}
> +
> +ssize_t cifs_direct_readv(struct kiocb *iocb, struct iov_iter *to)
> +{
> +	size_t len, cur_len, start;
> +	unsigned int npages, rsize, credits;
> +	struct file *file;
> +	struct cifs_sb_info *cifs_sb;
> +	struct cifsFileInfo *cfile;
> +	struct cifs_tcon *tcon;
> +	struct page **pagevec;
> +	ssize_t rc, total_read = 0;
> +	struct TCP_Server_Info *server;
> +	loff_t offset = iocb->ki_pos;
> +	pid_t pid;
> +	struct cifs_readdata *rdata;
> +
> +	/*
> +	 * iov_iter_get_pages_alloc() doesn't work with ITER_KVEC,
> +	 * fall back to data copy read path
> +	 */
> +	if (to->type & ITER_KVEC) {
> +		cifs_dbg(FYI, "use non-direct cifs_user_readv for kvec I/O\n");
> +		return cifs_user_readv(iocb, to);
> +	}
> +
> +	len = iov_iter_count(to);
> +	if (!len)
> +		return 0;
> +
> +	file = iocb->ki_filp;
> +	cifs_sb = CIFS_FILE_SB(file);
> +	cfile = file->private_data;
> +	tcon = tlink_tcon(cfile->tlink);
> +	server = tcon->ses->server;
> +
> +	if (!server->ops->async_readv)
> +		return -ENOSYS;
> +
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> +		pid = cfile->pid;
> +	else
> +		pid = current->tgid;
> +
> +	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
> +		cifs_dbg(FYI, "attempting read on write only file instance\n");

Confusing. Maybe "attempting read on write-only filehandle"?

> +
> +	do {
> +		rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
> +					&rsize, &credits);
> +		if (rc)
> +			break;
> +
> +		cur_len = min_t(const size_t, len, rsize);
> +
> +		rc = iov_iter_get_pages_alloc(to, &pagevec, cur_len, &start);
> +		if (rc < 0) {
> +			cifs_dbg(VFS,
> +				"couldn't get user pages (rc=%zd) iter type %d"
> +				" iov_offset %lu count %lu\n",
> +				rc, to->type, to->iov_offset, to->count);
> +			dump_stack();
> +			break;
> +		}
> +
> +		rdata = cifs_readdata_direct_alloc(
> +				pagevec, cifs_direct_readv_complete);
> +		if (!rdata) {
> +			add_credits_and_wake_if(server, credits, 0);
> +			rc = -ENOMEM;
> +			break;
> +		}
> +
> +		npages = (rc + start + PAGE_SIZE-1) / PAGE_SIZE;
> +		rdata->nr_pages = npages;
> +		rdata->page_offset = start;
> +		rdata->pagesz = PAGE_SIZE;
> +		rdata->tailsz = npages > 1 ?
> +				rc-(PAGE_SIZE-start)-(npages-2)*PAGE_SIZE :
> +				rc;

This expression makes my head hurt. Surely it can be simplified, or
expressed in a clearer way.

> +		cur_len = rc;
> +
> +		rdata->cfile = cifsFileInfo_get(cfile);
> +		rdata->offset = offset;
> +		rdata->bytes = rc;
> +		rdata->pid = pid;
> +		rdata->read_into_pages = cifs_uncached_read_into_pages;
> +		rdata->copy_into_pages = cifs_uncached_copy_into_pages;
> +		rdata->credits = credits;
> +
> +		rc = 0;
> +		if (rdata->cfile->invalidHandle)
> +			rc = cifs_reopen_file(rdata->cfile, true);
> +
> +		if (!rc)
> +			rc = server->ops->async_readv(rdata);
> +
> +		if (rc) {

This whole rc thing is messy. Initializing to zero, setting only in
one case, then testing the result, then setting it again, is twisted.
I actually think a goto or two would read much more clearly.

> +			add_credits_and_wake_if(server, rdata->credits, 0);
> +			kref_put(&rdata->refcount,
> +				 cifs_direct_readdata_release);
> +			if (rc == -EAGAIN)
> +				continue;
> +			break;

It's worth a comment here that this either breaks or continues the
entire do {} while (); and btw when it breaks it does *not* return "rc".
Again, maybe a goto instead of a break?

> +		}
> +
> +		wait_for_completion(&rdata->done);
> +		rc = rdata->result;
> +		if (rc) {
> +			kref_put(
> +				&rdata->refcount,
> +				cifs_direct_readdata_release);
> +			if (rc == -EAGAIN)
> +				continue;
> +			break;

Ditto.

> +		}
> +
> +		total_read += rdata->got_bytes;
> +		kref_put(&rdata->refcount, cifs_direct_readdata_release);
> +
> +		iov_iter_advance(to, cur_len);
> +		len -= cur_len;
> +		offset += cur_len;
> +	} while (len);
> +
> +	iocb->ki_pos += total_read;
> +
> +	return total_read;
> +}
> +
>   ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
>   {
>   	struct file *file = iocb->ki_filp;
> 
