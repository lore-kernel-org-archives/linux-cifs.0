From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 12/16] CIFS: Fix rsize usage in readpages
Date: Sat, 26 Jul 2014 12:07:35 -0500
Message-ID: <CADT32eKG-UZCaOOxnOa7=p57Ur=8ODMiHHD3cuCcU5Ed3hVBzw@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-13-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-13-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> If a server changes maximum buffer size for read (rsize) requests
> on reconnect we can fail on repeating with a big size buffer on
> -EAGAIN error in readpages. Fix this by checking rsize all the
> time before repeating requests.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 41 ++++++++++++++++++++++++++---------------
>  1 file changed, 26 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index bec48f1..d627918 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3349,6 +3349,8 @@ readpages_get_pages(struct address_space *mapping, struct list_head *page_list,
>         unsigned int expected_index;
>         int rc;
>
> +       INIT_LIST_HEAD(tmplist);
> +
>         page = list_entry(page_list->prev, struct page, lru);
>
>         /*
> @@ -3404,19 +3406,10 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>         struct list_head tmplist;
>         struct cifsFileInfo *open_file = file->private_data;
>         struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> -       unsigned int rsize = cifs_sb->rsize;
> +       struct TCP_Server_Info *server;
>         pid_t pid;
>
>         /*
> -        * Give up immediately if rsize is too small to read an entire page.
> -        * The VFS will fall back to readpage. We should never reach this
> -        * point however since we set ra_pages to 0 when the rsize is smaller
> -        * than a cache page.
> -        */
> -       if (unlikely(rsize < PAGE_CACHE_SIZE))
> -               return 0;
> -
> -       /*
>          * Reads as many pages as possible from fscache. Returns -ENOBUFS
>          * immediately if the cookie is negative
>          *
> @@ -3434,7 +3427,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                 pid = current->tgid;
>
>         rc = 0;
> -       INIT_LIST_HEAD(&tmplist);
> +       server = tlink_tcon(open_file->tlink)->ses->server;
>
>         cifs_dbg(FYI, "%s: file=%p mapping=%p num_pages=%u\n",
>                  __func__, file, mapping, num_pages);
> @@ -3456,8 +3449,17 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                 struct page *page, *tpage;
>                 struct cifs_readdata *rdata;
>
> -               rc = readpages_get_pages(mapping, page_list, rsize, &tmplist,
> -                                        &nr_pages, &offset, &bytes);
> +               /*
> +                * Give up immediately if rsize is too small to read an entire
> +                * page. The VFS will fall back to readpage. We should never
> +                * reach this point however since we set ra_pages to 0 when the
> +                * rsize is smaller than a cache page.
> +                */
> +               if (unlikely(cifs_sb->rsize < PAGE_CACHE_SIZE))
> +                       return 0;
> +
> +               rc = readpages_get_pages(mapping, page_list, cifs_sb->rsize,
> +                                        &tmplist, &nr_pages, &offset, &bytes);
>                 if (rc)
>                         break;
>
> @@ -3487,15 +3489,24 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                         rdata->pages[rdata->nr_pages++] = page;
>                 }
>
> -               rc = cifs_retry_async_readv(rdata);
> -               if (rc != 0) {
> +               if (!rdata->cfile->invalidHandle ||
> +                   !cifs_reopen_file(rdata->cfile, true))
> +                       rc = server->ops->async_readv(rdata);
> +               if (rc) {
>                         for (i = 0; i < rdata->nr_pages; i++) {
>                                 page = rdata->pages[i];
>                                 lru_cache_add_file(page);
>                                 unlock_page(page);
>                                 page_cache_release(page);
> +                               if (rc == -EAGAIN)
> +                                       list_add_tail(&page->lru, &tmplist);
>                         }
>                         kref_put(&rdata->refcount, cifs_readdata_release);
> +                       if (rc == -EAGAIN) {
> +                               /* Re-add pages to the page_list and retry */
> +                               list_splice(&tmplist, page_list);
> +                               continue;
> +                       }
>                         break;
>                 }
>
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
