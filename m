From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix error handling in cifs_readv_complete
Date: Fri, 21 Oct 2011 09:59:57 -0400
Message-ID: <20111021095957.44183d58@tlielax.poochiereds.net>
References: <1319177644-2551-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319177644-2551-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 21 Oct 2011 10:14:04 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> In cifs_readv_receive we don't update rdata->result to error value
> after kmap'ing a page. We should kunmap the page in the no error
> case only.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 949e121..5c81cd4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1667,9 +1667,9 @@ cifs_readv_complete(struct work_struct *work)
>  	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
>  		list_del(&page->lru);
>  		lru_cache_add_file(page);
> -		kunmap(page);
>  
>  		if (rdata->result == 0) {
> +			kunmap(page);
>  			flush_dcache_page(page);
>  			SetPageUptodate(page);
>  		}

Forehead slap...

Correct. We only kmap the page if the rdata->result == 0. We do need to
unconditionally unlock the page though.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
