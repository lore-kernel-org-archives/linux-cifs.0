From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: ensure that uncached writes handle unmapped areas
 correctly
Date: Fri, 14 Feb 2014 14:09:16 -0500
Message-ID: <20140214140916.3ecfea3e@tlielax.poochiereds.net>
References: <1392380435-6903-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392380435-6903-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Feb 2014 07:20:35 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> It's possible for userland to pass down an iovec via writev() that has a
> bogus user pointer in it. If that happens and we're doing an uncached
> write, then we can end up getting less bytes than we expect from the
> call to iov_iter_copy_from_user.
> 
> cifs_iovec_write isn't set up to handle that situation however. It'll
> blindly keep chugging through the page array and not filling those pages
> with anything useful. Worse yet, we'll later end up with a negative
> number in wdata->tailsz, which will confuse the sending routines and
> cause an oops at the very least.
> 
> Fix this by having the copy phase of cifs_iovec_write stop copying data
> in this situation and send the last write as a short one. At the same
> time, we want to avoid sending a zero-length write to the server, so
> break out of the loop and set rc to -EFAULT if that happens. This also
> allows us to handle the case where no address in the iovec is valid.
> 
> [Note: Marking this for stable on v3.4+ kernels, but kernels as old as
>        v2.6.38 may have a similar problem and may need similar fix]
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.4+
> Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> Reported-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/file.c | 37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 03d1f454c713..ae1a4d58e672 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2387,7 +2387,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
>  		 unsigned long nr_segs, loff_t *poffset)
>  {
>  	unsigned long nr_pages, i;
> -	size_t copied, len, cur_len;
> +	size_t bytes, copied, len, cur_len;
>  	ssize_t total_written = 0;
>  	loff_t offset;
>  	struct iov_iter it;
> @@ -2442,14 +2442,45 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
>  
>  		save_len = cur_len;
>  		for (i = 0; i < nr_pages; i++) {
> -			copied = min_t(const size_t, cur_len, PAGE_SIZE);
> +			bytes = min_t(const size_t, cur_len, PAGE_SIZE);
>  			copied = iov_iter_copy_from_user(wdata->pages[i], &it,
> -							 0, copied);
> +							 0, bytes);
>  			cur_len -= copied;
>  			iov_iter_advance(&it, copied);
> +			/*
> +			 * If we didn't copy as much as we expected, then that
> +			 * may mean we trod into an unmapped area. Stop copying
> +			 * at that point. On the next pass through the big
> +			 * loop, we'll likely end up getting a zero-length
> +			 * write and bailing out of it.
> +			 */
> +			if (copied < bytes)
> +				break;
>  		}
>  		cur_len = save_len - cur_len;
>  
> +		/*
> +		 * If we have no data to send, then that probably means that
> +		 * the copy above failed altogether. That's most likely because
> +		 * the address in the iovec was bogus. Set the rc to -EFAULT,
> +		 * free anything we allocated and bail out.
> +		 */
> +		if (!cur_len) {
> +			for (i = 0; i < nr_pages; i++)
> +				put_page(wdata->pages[i]);
> +			kfree(wdata);
> +			rc = -EFAULT;
> +			break;
> +		}
> +
> +		/*
> +		 * i + 1 now represents the number of pages we actually used in
> +		 * the copy phase above. Bring nr_pages down to that, and free
> +		 * any pages that we didn't use.
> +		 */
> +		for ( ; nr_pages > i + 1; nr_pages--)
> +			put_page(wdata->pages[nr_pages - 1]);
> +
>  		wdata->sync_mode = WB_SYNC_ALL;
>  		wdata->nr_pages = nr_pages;
>  		wdata->offset = (__u64)offset;

By the way, I should note that this a fix for CVE-2014-0069. Steve,
mind adding that to the patch description?

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
