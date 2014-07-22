From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 05/16] CIFS: Fix wsize usage in writepages
Date: Mon, 21 Jul 2014 21:09:14 -0500
Message-ID: <CADT32eJoCajud-rstYYyrYxbaNV-P3c6Z96WZFGdk-J9dMeZ+g@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-6-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-6-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by; Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> If a server change maximum buffer size for write (wsize) requests
> on reconnect we can fail on repeating with a big size buffer on
> -EAGAIN error in writepages. Fix this by checking wsize all the
> time before repeating request in writepages.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0064d38f..ff4a9c3 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2009,19 +2009,17 @@ wdata_send_pages(struct cifs_writedata *wdata, unsigned int nr_pages,
>                         (loff_t)PAGE_CACHE_SIZE);
>         wdata->bytes = ((nr_pages - 1) * PAGE_CACHE_SIZE) + wdata->tailsz;
>
> -       do {
> -               if (wdata->cfile != NULL)
> -                       cifsFileInfo_put(wdata->cfile);
> -               wdata->cfile = find_writable_file(CIFS_I(mapping->host), false);
> -               if (!wdata->cfile) {
> -                       cifs_dbg(VFS, "No writable handles for inode\n");
> -                       rc = -EBADF;
> -                       break;
> -               }
> +       if (wdata->cfile != NULL)
> +               cifsFileInfo_put(wdata->cfile);
> +       wdata->cfile = find_writable_file(CIFS_I(mapping->host), false);
> +       if (!wdata->cfile) {
> +               cifs_dbg(VFS, "No writable handles for inode\n");
> +               rc = -EBADF;
> +       } else {
>                 wdata->pid = wdata->cfile->pid;
>                 server = tlink_tcon(wdata->cfile->tlink)->ses->server;
>                 rc = server->ops->async_writev(wdata, cifs_writedata_release);
> -       } while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
> +       }
>
>         for (i = 0; i < nr_pages; ++i)
>                 unlock_page(wdata->pages[i]);
> @@ -2058,7 +2056,7 @@ static int cifs_writepages(struct address_space *mapping,
>  retry:
>         while (!done && index <= end) {
>                 unsigned int i, nr_pages, found_pages;
> -               pgoff_t next = 0, tofind;
> +               pgoff_t next = 0, tofind, saved_index = index;
>
>                 tofind = min((cifs_sb->wsize / PAGE_CACHE_SIZE) - 1,
>                                 end - index) + 1;
> @@ -2102,6 +2100,11 @@ retry:
>                 }
>                 kref_put(&wdata->refcount, cifs_writedata_release);
>
> +               if (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN) {
> +                       index = saved_index;
> +                       continue;
> +               }
> +
>                 wbc->nr_to_write -= nr_pages;
>                 if (wbc->nr_to_write <= 0)
>                         done = true;
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
