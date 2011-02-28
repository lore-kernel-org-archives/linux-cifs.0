From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #2)
Date: Mon, 28 Feb 2011 13:41:11 -0500
Message-ID: <20110228134111.20c9dffd@corrin.poochiereds.net>
References: <1298629310-4618-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298629310-4618-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 25 Feb 2011 13:21:50 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Use invalidate_inode_pages2 that don't leave pages even if shrink_page_list()
> has a temp ref on them. It prevents a data coherency problem on exclusive
> oplocks opens.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/inode.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 589f3e3..0011e95 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1687,12 +1687,18 @@ cifs_invalidate_mapping(struct inode *inode)
>  
>  	cifs_i->invalid_mapping = false;
>  
> -	/* write back any cached data */
> -	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
> -		rc = filemap_write_and_wait(inode->i_mapping);
> -		mapping_set_error(inode->i_mapping, rc);
> +	if (inode->i_mapping) {
> +		/* write back any cached data */
> +		if (inode->i_mapping->nrpages != 0) {
> +			rc = filemap_write_and_wait(inode->i_mapping);
> +			mapping_set_error(inode->i_mapping, rc);
> +		}
> +		rc = invalidate_inode_pages2(inode->i_mapping);
> +		if (rc)
> +			cERROR(1, "%s: could not invalidate inode %p", __func__,
> +			       inode);
>  	}
> -	invalidate_remote_inode(inode);
> +
>  	cifs_fscache_reset_inode_cookie(inode);
>  }
>  

Looks like a correct change overall. I wonder too whether we need to
make cifs_invalidate_mapping return the error from
invalidate_inode_pages2 and have the callers deal with that
appropriately.

For now, I think we should just keep an eye out for the printk that
you're adding to pop. If we start to see those frequently under some
workloads we can think about what the right approach is.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
