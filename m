From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 04/16] CIFS: Separate pages initialization from writepages
Date: Sat, 19 Jul 2014 01:24:27 -0500
Message-ID: <CADT32e+McMW6iz_-3JVVrRq-SnJcgMMEEJe6=x3KR6S8MAkf1Q@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-5-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-5-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This looks correct.

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Fri, Jun 27, 2014 at 4:57 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 56 ++++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 36 insertions(+), 20 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 306c3df..4117da0 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1878,6 +1878,40 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
>         return rc;
>  }
>
> +static struct cifs_writedata *
> +wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
> +                         pgoff_t end, pgoff_t *index,
> +                         unsigned int *found_pages)
> +{
> +       unsigned int nr_pages;
> +       struct page **pages;
> +       struct cifs_writedata *wdata;
> +
> +       wdata = cifs_writedata_alloc((unsigned int)tofind,
> +                                    cifs_writev_complete);
> +       if (!wdata)
> +               return NULL;
> +
> +       /*
> +        * find_get_pages_tag seems to return a max of 256 on each
> +        * iteration, so we must call it several times in order to
> +        * fill the array or the wsize is effectively limited to
> +        * 256 * PAGE_CACHE_SIZE.
> +        */
> +       *found_pages = 0;
> +       pages = wdata->pages;
> +       do {
> +               nr_pages = find_get_pages_tag(mapping, index,
> +                                             PAGECACHE_TAG_DIRTY, tofind,
> +                                             pages);
> +               *found_pages += nr_pages;
> +               tofind -= nr_pages;
> +               pages += nr_pages;
> +       } while (nr_pages && tofind && *index <= end);
> +
> +       return wdata;
> +}
> +
>  static unsigned int
>  wdata_prepare_pages(struct cifs_writedata *wdata, unsigned int found_pages,
>                     struct address_space *mapping,
> @@ -2040,35 +2074,17 @@ retry:
>         while (!done && index <= end) {
>                 unsigned int nr_pages, found_pages;
>                 pgoff_t next = 0, tofind;
> -               struct page **pages;
>
>                 tofind = min((cifs_sb->wsize / PAGE_CACHE_SIZE) - 1,
>                                 end - index) + 1;
>
> -               wdata = cifs_writedata_alloc((unsigned int)tofind,
> -                                            cifs_writev_complete);
> +               wdata = wdata_alloc_and_fillpages(tofind, mapping, end, &index,
> +                                                 &found_pages);
>                 if (!wdata) {
>                         rc = -ENOMEM;
>                         break;
>                 }
>
> -               /*
> -                * find_get_pages_tag seems to return a max of 256 on each
> -                * iteration, so we must call it several times in order to
> -                * fill the array or the wsize is effectively limited to
> -                * 256 * PAGE_CACHE_SIZE.
> -                */
> -               found_pages = 0;
> -               pages = wdata->pages;
> -               do {
> -                       nr_pages = find_get_pages_tag(mapping, &index,
> -                                                       PAGECACHE_TAG_DIRTY,
> -                                                       tofind, pages);
> -                       found_pages += nr_pages;
> -                       tofind -= nr_pages;
> -                       pages += nr_pages;
> -               } while (nr_pages && tofind && index <= end);
> -
>                 if (found_pages == 0) {
>                         kref_put(&wdata->refcount, cifs_writedata_release);
>                         break;
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
