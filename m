From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 02/16] CIFS: Separate page processing from writepages
Date: Wed, 9 Jul 2014 08:59:16 -0400
Message-ID: <20140709085916.7df0d45d@tlielax.poochiereds.net>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-3-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-3-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Jun 2014 13:57:39 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 152 +++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 82 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6b6df30..69d1763 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1878,6 +1878,86 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
>  	return rc;
>  }
>  
> +static unsigned int
> +wdata_prepare_pages(struct cifs_writedata *wdata, unsigned int found_pages,
> +		    struct address_space *mapping,
> +		    struct writeback_control *wbc,
> +		    pgoff_t end, pgoff_t *index, pgoff_t *next, bool *done)
> +{
> +	unsigned int nr_pages = 0, i;
> +	struct page *page;
> +
> +	for (i = 0; i < found_pages; i++) {
> +		page = wdata->pages[i];
> +		/*
> +		 * At this point we hold neither mapping->tree_lock nor
> +		 * lock on the page itself: the page may be truncated or
> +		 * invalidated (changing page->mapping to NULL), or even
> +		 * swizzled back from swapper_space to tmpfs file
> +		 * mapping
> +		 */
> +
> +		if (nr_pages == 0)
> +			lock_page(page);
> +		else if (!trylock_page(page))
> +			break;
> +
> +		if (unlikely(page->mapping != mapping)) {
> +			unlock_page(page);
> +			break;
> +		}
> +
> +		if (!wbc->range_cyclic && page->index > end) {
> +			*done = true;
> +			unlock_page(page);
> +			break;
> +		}
> +
> +		if (*next && (page->index != *next)) {
> +			/* Not next consecutive page */
> +			unlock_page(page);
> +			break;
> +		}
> +
> +		if (wbc->sync_mode != WB_SYNC_NONE)
> +			wait_on_page_writeback(page);
> +
> +		if (PageWriteback(page) ||
> +				!clear_page_dirty_for_io(page)) {
> +			unlock_page(page);
> +			break;
> +		}
> +
> +		/*
> +		 * This actually clears the dirty bit in the radix tree.
> +		 * See cifs_writepage() for more commentary.
> +		 */
> +		set_page_writeback(page);
> +		if (page_offset(page) >= i_size_read(mapping->host)) {
> +			*done = true;
> +			unlock_page(page);
> +			end_page_writeback(page);
> +			break;
> +		}
> +
> +		wdata->pages[i] = page;
> +		*next = page->index + 1;
> +		++nr_pages;
> +	}
> +
> +	/* reset index to refind any pages skipped */
> +	if (nr_pages == 0)
> +		*index = wdata->pages[0]->index + 1;
> +
> +	/* put any pages we aren't going to use */
> +	for (i = nr_pages; i < found_pages; i++) {
> +		page_cache_release(wdata->pages[i]);
> +		wdata->pages[i] = NULL;
> +	}
> +
> +	return nr_pages;
> +}
> +
>  static int cifs_writepages(struct address_space *mapping,
>  			   struct writeback_control *wbc)
>  {
> @@ -1886,7 +1966,6 @@ static int cifs_writepages(struct address_space *mapping,
>  	pgoff_t end, index;
>  	struct cifs_writedata *wdata;
>  	struct TCP_Server_Info *server;
> -	struct page *page;
>  	int rc = 0;
>  
>  	/*
> @@ -1944,75 +2023,8 @@ retry:
>  			break;
>  		}
>  
> -		nr_pages = 0;
> -		for (i = 0; i < found_pages; i++) {
> -			page = wdata->pages[i];
> -			/*
> -			 * At this point we hold neither mapping->tree_lock nor
> -			 * lock on the page itself: the page may be truncated or
> -			 * invalidated (changing page->mapping to NULL), or even
> -			 * swizzled back from swapper_space to tmpfs file
> -			 * mapping
> -			 */
> -
> -			if (nr_pages == 0)
> -				lock_page(page);
> -			else if (!trylock_page(page))
> -				break;
> -
> -			if (unlikely(page->mapping != mapping)) {
> -				unlock_page(page);
> -				break;
> -			}
> -
> -			if (!wbc->range_cyclic && page->index > end) {
> -				done = true;
> -				unlock_page(page);
> -				break;
> -			}
> -
> -			if (next && (page->index != next)) {
> -				/* Not next consecutive page */
> -				unlock_page(page);
> -				break;
> -			}
> -
> -			if (wbc->sync_mode != WB_SYNC_NONE)
> -				wait_on_page_writeback(page);
> -
> -			if (PageWriteback(page) ||
> -					!clear_page_dirty_for_io(page)) {
> -				unlock_page(page);
> -				break;
> -			}
> -
> -			/*
> -			 * This actually clears the dirty bit in the radix tree.
> -			 * See cifs_writepage() for more commentary.
> -			 */
> -			set_page_writeback(page);
> -
> -			if (page_offset(page) >= i_size_read(mapping->host)) {
> -				done = true;
> -				unlock_page(page);
> -				end_page_writeback(page);
> -				break;
> -			}
> -
> -			wdata->pages[i] = page;
> -			next = page->index + 1;
> -			++nr_pages;
> -		}
> -
> -		/* reset index to refind any pages skipped */
> -		if (nr_pages == 0)
> -			index = wdata->pages[0]->index + 1;
> -
> -		/* put any pages we aren't going to use */
> -		for (i = nr_pages; i < found_pages; i++) {
> -			page_cache_release(wdata->pages[i]);
> -			wdata->pages[i] = NULL;
> -		}
> +		nr_pages = wdata_prepare_pages(wdata, found_pages, mapping, wbc,
> +					       end, &index, &next, &done);
>  
>  		/* nothing to write? */
>  		if (nr_pages == 0) {

Reviewed-by:
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
