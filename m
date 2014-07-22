From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 07/16] CIFS: Separate filling pages from iovec write
Date: Mon, 21 Jul 2014 21:40:15 -0500
Message-ID: <CADT32eJiRAyAzdm37o5rrwFtm9H+LMbOUDUwLKd9qwUQmEtdEQ@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-8-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-8-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks correct (fixing the return value from the function
wdata_fill_from_iovec())

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 84 ++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 50 insertions(+), 34 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index ff4a9c3..f96f61c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2423,11 +2423,53 @@ cifs_uncached_retry_writev(struct cifs_writedata *wdata)
>         return rc;
>  }
>
> +static int
> +wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *from,
> +                     size_t *len, unsigned long *num_pages)
> +{
> +       size_t save_len, copied, bytes, cur_len = *len;
> +       unsigned long i, nr_pages = *num_pages;
> +
> +       save_len = cur_len;
> +       for (i = 0; i < nr_pages; i++) {
> +               bytes = min_t(const size_t, cur_len, PAGE_SIZE);
> +               copied = copy_page_from_iter(wdata->pages[i], 0, bytes, from);
> +               cur_len -= copied;
> +               /*
> +                * If we didn't copy as much as we expected, then that
> +                * may mean we trod into an unmapped area. Stop copying
> +                * at that point. On the next pass through the big
> +                * loop, we'll likely end up getting a zero-length
> +                * write and bailing out of it.
> +                */
> +               if (copied < bytes)
> +                       break;
> +       }
> +       cur_len = save_len - cur_len;
> +       *len = cur_len;
> +
> +       /*
> +        * If we have no data to send, then that probably means that
> +        * the copy above failed altogether. That's most likely because
> +        * the address in the iovec was bogus. Return -EFAULT and let
> +        * the caller free anything we allocated and bail out.
> +        */
> +       if (!cur_len)
> +               return -EFAULT;
> +
> +       /*
> +        * i + 1 now represents the number of pages we actually used in
> +        * the copy phase above.
> +        */
> +       *num_pages = i + 1;
> +       return 0;
> +}
> +
>  static ssize_t
>  cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
>  {
> -       unsigned long nr_pages, i;
> -       size_t bytes, copied, len, cur_len;
> +       unsigned long nr_pages, num_pages, i;
> +       size_t len, cur_len;
>         ssize_t total_written = 0;
>         loff_t offset;
>         struct cifsFileInfo *open_file;
> @@ -2464,8 +2506,6 @@ cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
>                 pid = current->tgid;
>
>         do {
> -               size_t save_len;
> -
>                 nr_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
>                 wdata = cifs_writedata_alloc(nr_pages,
>                                              cifs_uncached_writev_complete);
> @@ -2480,44 +2520,20 @@ cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
>                         break;
>                 }
>
> -               save_len = cur_len;
> -               for (i = 0; i < nr_pages; i++) {
> -                       bytes = min_t(size_t, cur_len, PAGE_SIZE);
> -                       copied = copy_page_from_iter(wdata->pages[i], 0, bytes,
> -                                                    from);
> -                       cur_len -= copied;
> -                       /*
> -                        * If we didn't copy as much as we expected, then that
> -                        * may mean we trod into an unmapped area. Stop copying
> -                        * at that point. On the next pass through the big
> -                        * loop, we'll likely end up getting a zero-length
> -                        * write and bailing out of it.
> -                        */
> -                       if (copied < bytes)
> -                               break;
> -               }
> -               cur_len = save_len - cur_len;
> -
> -               /*
> -                * If we have no data to send, then that probably means that
> -                * the copy above failed altogether. That's most likely because
> -                * the address in the iovec was bogus. Set the rc to -EFAULT,
> -                * free anything we allocated and bail out.
> -                */
> -               if (!cur_len) {
> +               num_pages = nr_pages;
> +               rc = wdata_fill_from_iovec(wdata, from, &cur_len, &num_pages);
> +               if (rc) {
>                         for (i = 0; i < nr_pages; i++)
>                                 put_page(wdata->pages[i]);
>                         kfree(wdata);
> -                       rc = -EFAULT;
>                         break;
>                 }
>
>                 /*
> -                * i + 1 now represents the number of pages we actually used in
> -                * the copy phase above. Bring nr_pages down to that, and free
> -                * any pages that we didn't use.
> +                * Bring nr_pages down to the number of pages we actually used,
> +                * and free any pages that we didn't use.
>                  */
> -               for ( ; nr_pages > i + 1; nr_pages--)
> +               for ( ; nr_pages > num_pages; nr_pages--)
>                         put_page(wdata->pages[nr_pages - 1]);
>
>                 wdata->sync_mode = WB_SYNC_ALL;
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
