From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] CIFS: Add asynchronous read support through kernel
 AIO
Date: Sat, 25 Mar 2017 11:12:04 -0400
Message-ID: <1490454724.2665.1.camel@redhat.com>
References: <1486768678-36802-1-git-send-email-pshilov@microsoft.com>
         <1486768678-36802-2-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486768678-36802-2-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2017-02-10 at 15:17 -0800, Pavel Shilovsky wrote:
> Currently the code doesn't recognize asynchronous calls passed
> by io_submit() and processes all calls synchronously. This is not
> what kernel AIO expects. This patch improves this for reading
> by introducing new async context that keeps track of all issued i/o
> requests and moving a response collecting procedure to a separate
> thread. This allows to return to the caller immediately for
> asynchronous calls and call the iocb->ki_complete() once all requests
> are completed. For synchronous calls the current thread simply
> waits until all requests are completed.
> 
> This improves reading performance of single threaded applications
> with increasing of i/o queue depth size.
> 
> Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

I would really, really appreciate seeing this patch broken up into
smaller, logical changes. It's very difficult to 
 
> ---
>  fs/cifs/cifsglob.h |  18 ++++
>  fs/cifs/file.c     | 273 +++++++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 252 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f9a9a12..80771ca 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1109,6 +1109,23 @@ struct cifs_io_parms {
>  	struct cifs_tcon *tcon;
>  };
>  
> +struct cifs_aio_ctx {
> +	struct kref		refcount;
> +	struct list_head	list;
> +	struct mutex		aio_mutex;
> +	struct completion	done;
> +	struct iov_iter		iter;
> +	struct kiocb		*iocb;
> +	struct cifsFileInfo	*cfile;
> +	struct page		**pages;
^^^
Nothing uses the above pointer.

> +	struct bio_vec		*bv;
> +	unsigned int		npages;
> +	ssize_t			rc;
> +	unsigned int		len;
> +	unsigned int		total_len;
> +	bool			should_dirty;
> +};
> +
>  struct cifs_readdata;
>  
>  /* asynchronous read support */
> @@ -1118,6 +1135,7 @@ struct cifs_readdata {
>  	struct completion		done;
>  	struct cifsFileInfo		*cfile;
>  	struct address_space		*mapping;
> +	struct cifs_aio_ctx		*ctx;
>  	__u64				offset;
>  	unsigned int			bytes;
>  	unsigned int			got_bytes;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 98dc842..6ceeed2 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -33,6 +33,7 @@
>  #include <linux/mount.h>
>  #include <linux/slab.h>
>  #include <linux/swap.h>
> +#include <linux/vmalloc.h>
>  #include <asm/div64.h>
>  #include "cifsfs.h"
>  #include "cifspdu.h"
> @@ -2410,6 +2411,108 @@ int cifs_flush(struct file *file, fl_owner_t id)
>  	return rc;
>  }
>  
> +static inline struct cifs_aio_ctx *
> +cifs_aio_ctx_alloc(void)
> +{
> +	struct cifs_aio_ctx *ctx;
> +
> +	ctx = kzalloc(sizeof(struct cifs_aio_ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return NULL;
> +
> +	INIT_LIST_HEAD(&ctx->list);
> +	mutex_init(&ctx->aio_mutex);
> +	init_completion(&ctx->done);
> +	kref_init(&ctx->refcount);
> +	return ctx;
> +}
> +
> +static inline void
> +cifs_aio_ctx_release(struct kref *refcount)
> +{
> +	struct cifs_aio_ctx *ctx = container_of(refcount,
> +					struct cifs_aio_ctx, refcount);
> +
> +	cifsFileInfo_put(ctx->cfile);
> +	kvfree(ctx->bv);
> +	kfree(ctx);
> +}
> +
> +static int
> +setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw)
> +{
> +	ssize_t rc;
> +	unsigned int cur_npages;
> +	unsigned int npages = 0;
> +	unsigned int i;
> +	size_t len;
> +	size_t count = iov_iter_count(iter);
> +	unsigned int saved_len;
> +	size_t start;
> +	unsigned int max_pages = iov_iter_npages(iter, INT_MAX);
> +	struct page **pages;
> +	struct bio_vec *bv;
> +
> +	if (iter->type & ITER_KVEC) {
> +		memcpy(&ctx->iter, iter, sizeof(struct iov_iter));
> +		ctx->len = count;
> +		iov_iter_advance(iter, count);
> +		return 0;
> +	}
> +
> +	bv = kmalloc_array(max_pages, sizeof(struct bio_vec), GFP_KERNEL);
> +	if (!bv) {
> +		bv = vmalloc(max_pages * sizeof(struct bio_vec));
> +		if (!bv)
> +			return -ENOMEM;
> +	}
> +
> +	saved_len = count;
> +
> +	while (count && npages < max_pages) {
> +		rc = iov_iter_get_pages_alloc(iter, &pages, count, &start);

It would be more efficient to allocate a page array of the max length,
and then reuse that array in each call to iov_iter_get_pages --
especially if contiguous memory is tight and you end up having to use
vmalloc.

Also, just a heads up that I sent a patch a couple of months ago to
rework the above function to generate longer page arrays when possible,
but Al didn't care for it. He's supposedly going to rework the above
function into something that grabs a pile of pages and issues a callback
to each of them. Once that goes in, you may want to rework this code to
use that instead.

> +		if (rc < 0) {
> +			cifs_dbg(VFS, "couldn't get user pages (rc=%zd)\n", rc);
> +			break;
> +		}
> +

> +		if (rc > count) {
> +			cifs_dbg(VFS, "get pages rc=%zd more than %zu\n", rc,
> +				 count);
> +			break;
> +		}
> +
> +		iov_iter_advance(iter, rc);
> +		count -= rc;
> +		rc += start;
> +		cur_npages = (rc + PAGE_SIZE - 1) / PAGE_SIZE;

cur_npages = DIV_ROUND_UP(rc, PAGE_SIZE);

> +
> +		if (npages + cur_npages > max_pages) {
> +			cifs_dbg(VFS, "out of vec array capacity (%u vs %u)\n",
> +				 npages + cur_npages, max_pages);
> +			break;
> +		}
> +
> +		for (i = 0; i < cur_npages; i++) {
> +			len = rc > PAGE_SIZE ? PAGE_SIZE : rc;
> +			bv[npages + i].bv_page = pages[i];
> +			bv[npages + i].bv_offset = start;
> +			bv[npages + i].bv_len = len - start;
> +			rc -= len;
> +			start = 0;
> +		}
> +
> +		npages += cur_npages;
> +		kvfree(pages);
> +	}
> +
> +	ctx->bv = bv;
> +	ctx->len = saved_len - count;
> +	ctx->npages = npages;
> +	iov_iter_bvec(&ctx->iter, ITER_BVEC | rw, ctx->bv, npages, ctx->len);
> +	return 0;
> +}
> +
>  static int
>  cifs_write_allocate_pages(struct page **pages, unsigned long num_pages)
>  {
> @@ -2859,6 +2962,7 @@ cifs_uncached_readdata_release(struct kref *refcount)
>  					struct cifs_readdata, refcount);
>  	unsigned int i;
>  
> +	kref_put(&rdata->ctx->refcount, cifs_aio_ctx_release);
>  	for (i = 0; i < rdata->nr_pages; i++) {
>  		put_page(rdata->pages[i]);
>  		rdata->pages[i] = NULL;
> @@ -2900,6 +3004,8 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, struct iov_iter *iter)
>  	return remaining ? -EFAULT : 0;
>  }
>  
> +static void collect_uncached_read_data(struct cifs_aio_ctx *ctx);
> +
>  static void
>  cifs_uncached_readv_complete(struct work_struct *work)
>  {
> @@ -2907,6 +3013,8 @@ cifs_uncached_readv_complete(struct work_struct *work)
>  						struct cifs_readdata, work);
>  
>  	complete(&rdata->done);
> +	collect_uncached_read_data(rdata->ctx);
> +	/* the below call can possibly free the last ref to aio ctx */
>  	kref_put(&rdata->refcount, cifs_uncached_readdata_release);
>  }
>  
> @@ -2973,7 +3081,8 @@ cifs_uncached_copy_into_pages(struct TCP_Server_Info *server,
>  
>  static int
>  cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
> -		     struct cifs_sb_info *cifs_sb, struct list_head *rdata_list)
> +		     struct cifs_sb_info *cifs_sb, struct list_head *rdata_list,
> +		     struct cifs_aio_ctx *ctx)
>  {
>  	struct cifs_readdata *rdata;
>  	unsigned int npages, rsize, credits;
> @@ -3020,6 +3129,8 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>  		rdata->read_into_pages = cifs_uncached_read_into_pages;
>  		rdata->copy_into_pages = cifs_uncached_copy_into_pages;
>  		rdata->credits = credits;
> +		rdata->ctx = ctx;
> +		kref_get(&ctx->refcount);
>  
>  		if (!rdata->cfile->invalidHandle ||
>  		    !cifs_reopen_file(rdata->cfile, true))
> @@ -3042,50 +3153,37 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>  	return rc;
>  }
>  
> -ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
> +static void
> +collect_uncached_read_data(struct cifs_aio_ctx *ctx)
>  {
> -	struct file *file = iocb->ki_filp;
> -	ssize_t rc;
> -	size_t len;
> -	ssize_t total_read = 0;
> -	loff_t offset = iocb->ki_pos;
> +	struct cifs_readdata *rdata, *tmp;
> +	struct iov_iter *to = &ctx->iter;
>  	struct cifs_sb_info *cifs_sb;
>  	struct cifs_tcon *tcon;
> -	struct cifsFileInfo *open_file;
> -	struct cifs_readdata *rdata, *tmp;
> -	struct list_head rdata_list;
> -
> -	len = iov_iter_count(to);
> -	if (!len)
> -		return 0;
> -
> -	INIT_LIST_HEAD(&rdata_list);
> -	cifs_sb = CIFS_FILE_SB(file);
> -	open_file = file->private_data;
> -	tcon = tlink_tcon(open_file->tlink);
> -
> -	if (!tcon->ses->server->ops->async_readv)
> -		return -ENOSYS;
> +	unsigned int i;
> +	int rc;
>  
> -	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
> -		cifs_dbg(FYI, "attempting read on write only file instance\n");
> +	tcon = tlink_tcon(ctx->cfile->tlink);
> +	cifs_sb = CIFS_SB(ctx->cfile->dentry->d_sb);
>  
> -	rc = cifs_send_async_read(offset, len, open_file, cifs_sb, &rdata_list);
> +	mutex_lock(&ctx->aio_mutex);
>  
> -	/* if at least one read request send succeeded, then reset rc */
> -	if (!list_empty(&rdata_list))
> -		rc = 0;
> +	if (list_empty(&ctx->list)) {
> +		mutex_unlock(&ctx->aio_mutex);
> +		return;
> +	}
>  
> -	len = iov_iter_count(to);
> +	rc = ctx->rc;
>  	/* the loop below should proceed in the order of increasing offsets */
>  again:
> -	list_for_each_entry_safe(rdata, tmp, &rdata_list, list) {
> +	list_for_each_entry_safe(rdata, tmp, &ctx->list, list) {
>  		if (!rc) {
> -			/* FIXME: freezable sleep too? */
> -			rc = wait_for_completion_killable(&rdata->done);
> -			if (rc)
> -				rc = -EINTR;
> -			else if (rdata->result == -EAGAIN) {
> +			if (!try_wait_for_completion(&rdata->done)) {
> +				mutex_unlock(&ctx->aio_mutex);
> +				return;
> +			}
> +
> +			if (rdata->result == -EAGAIN) {
>  				/* resend call if it's a retryable error */
>  				struct list_head tmp_list;
>  				unsigned int got_bytes = rdata->got_bytes;
> @@ -3111,9 +3209,9 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
>  						rdata->offset + got_bytes,
>  						rdata->bytes - got_bytes,
>  						rdata->cfile, cifs_sb,
> -						&tmp_list);
> +						&tmp_list, ctx);
>  
> -				list_splice(&tmp_list, &rdata_list);
> +				list_splice(&tmp_list, &ctx->list);
>  
>  				kref_put(&rdata->refcount,
>  					 cifs_uncached_readdata_release);
> @@ -3131,14 +3229,111 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
>  		kref_put(&rdata->refcount, cifs_uncached_readdata_release);
>  	}
>  
> -	total_read = len - iov_iter_count(to);
> +	for (i = 0; i < ctx->npages; i++) {
> +		if (ctx->should_dirty)
> +			set_page_dirty(ctx->bv[i].bv_page);
> +		put_page(ctx->bv[i].bv_page);
> +	}
> +
> +	ctx->total_len = ctx->len - iov_iter_count(to);
>  
> -	cifs_stats_bytes_read(tcon, total_read);
> +	cifs_stats_bytes_read(tcon, ctx->total_len);
>  
>  	/* mask nodata case */
>  	if (rc == -ENODATA)
>  		rc = 0;
>  
> +	ctx->rc = (rc == 0) ? ctx->total_len : rc;
> +
> +	mutex_unlock(&ctx->aio_mutex);
> +
> +	if (ctx->iocb && ctx->iocb->ki_complete)
> +		ctx->iocb->ki_complete(ctx->iocb, ctx->rc, 0);
> +	else
> +		complete(&ctx->done);
> +}
> +
> +ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
> +{
> +	struct file *file = iocb->ki_filp;
> +	ssize_t rc;
> +	size_t len;
> +	ssize_t total_read = 0;
> +	loff_t offset = iocb->ki_pos;
> +	struct cifs_sb_info *cifs_sb;
> +	struct cifs_tcon *tcon;
> +	struct cifsFileInfo *cfile;
> +	struct cifs_aio_ctx *ctx;
> +
> +	len = iov_iter_count(to);
> +	if (!len)
> +		return 0;
> +
> +	cifs_sb = CIFS_FILE_SB(file);
> +	cfile = file->private_data;
> +	tcon = tlink_tcon(cfile->tlink);
> +
> +	if (!tcon->ses->server->ops->async_readv)
> +		return -ENOSYS;
> +
> +	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
> +		cifs_dbg(FYI, "attempting read on write only file instance\n");
> +
> +	ctx = cifs_aio_ctx_alloc();
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->cfile = cifsFileInfo_get(cfile);
> +
> +	if (!is_sync_kiocb(iocb))
> +		ctx->iocb = iocb;
> +
> +	if (to->type & ITER_IOVEC)
> +		ctx->should_dirty = true;
> +
> +	rc = setup_aio_ctx_iter(ctx, to, READ);
> +	if (rc) {
> +		kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +		return rc;
> +	}
> +
> +	len = ctx->len;
> +
> +	/* grab a lock here due to read response handlers can access ctx */
> +	mutex_lock(&ctx->aio_mutex);
> +
> +	rc = cifs_send_async_read(offset, len, cfile, cifs_sb, &ctx->list, ctx);
> +
> +	/* if at least one read request send succeeded, then reset rc */
> +	if (!list_empty(&ctx->list))
> +		rc = 0;
> +
> +	mutex_unlock(&ctx->aio_mutex);
> +
> +	if (rc) {
> +		kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +		return rc;
> +	}
> +
> +	if (!is_sync_kiocb(iocb)) {
> +		kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +		return -EIOCBQUEUED;
> +	}
> +
> +	/* FIXME: freezable sleep too? */

I think you can remove the above comment, and this should probably be a
TASK_INTERRUPTIBLE sleep.

> +	rc = wait_for_completion_killable(&ctx->done);
> +	if (rc) {
> +		mutex_lock(&ctx->aio_mutex);
> +		ctx->rc = rc = -EINTR;
> +		total_read = ctx->total_len;
> +		mutex_unlock(&ctx->aio_mutex);
> +	} else {
> +		rc = ctx->rc;
> +		total_read = ctx->total_len;
> +	}
> +
> +	kref_put(&ctx->refcount, cifs_aio_ctx_release);
> +
>  	if (total_read) {
>  		iocb->ki_pos += total_read;
>  		return total_read;

Other than the above, this looks pretty reasonable. Nice work!
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
