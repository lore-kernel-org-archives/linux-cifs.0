From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 09/16] CIFS: Fix wsize usage in iovec write
Date: Wed, 23 Jul 2014 01:15:25 -0500
Message-ID: <CADT32eLMseQ00gkywk9KdvcCEks7P5k1sBWdFOM+RaR3g1Edpw@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-10-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-10-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> If a server change maximum buffer size for write (wsize) requests
> on reconnect we can fail on repeating with a big size buffer on
> -EAGAIN error in iovec write. Fix this by checking wsize all the
> time before repeating request in iovec write.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c |  4 ----
>  fs/cifs/file.c    | 63 ++++++++++++++++++++++++++++++++++---------------------
>  fs/cifs/smb2pdu.c |  4 ----
>  3 files changed, 39 insertions(+), 32 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index e273ded..784f105 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -196,10 +196,6 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
>         if (rc)
>                 goto out;
>
> -       /*
> -        * FIXME: check if wsize needs updated due to negotiated smb buffer
> -        *        size shrinking
> -        */
>         atomic_inc(&tconInfoReconnectCount);
>
>         /* tell server Unix caps we support */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6660698..c9c4f5a 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2401,28 +2401,6 @@ cifs_uncached_writev_complete(struct work_struct *work)
>         kref_put(&wdata->refcount, cifs_uncached_writedata_release);
>  }
>
> -/* attempt to send write to server, retry on any -EAGAIN errors */
> -static int
> -cifs_uncached_retry_writev(struct cifs_writedata *wdata)
> -{
> -       int rc;
> -       struct TCP_Server_Info *server;
> -
> -       server = tlink_tcon(wdata->cfile->tlink)->ses->server;
> -
> -       do {
> -               if (wdata->cfile->invalidHandle) {
> -                       rc = cifs_reopen_file(wdata->cfile, false);
> -                       if (rc != 0)
> -                               continue;
> -               }
> -               rc = server->ops->async_writev(wdata,
> -                                              cifs_uncached_writedata_release);
> -       } while (rc == -EAGAIN);
> -
> -       return rc;
> -}
> -
>  static int
>  wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *from,
>                       size_t *len, unsigned long *num_pages)
> @@ -2474,13 +2452,19 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
>         size_t cur_len;
>         unsigned long nr_pages, num_pages, i;
>         struct cifs_writedata *wdata;
> +       struct iov_iter saved_from;
> +       loff_t saved_offset = offset;
>         pid_t pid;
> +       struct TCP_Server_Info *server;
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>                 pid = open_file->pid;
>         else
>                 pid = current->tgid;
>
> +       server = tlink_tcon(open_file->tlink)->ses->server;
> +       memcpy(&saved_from, from, sizeof(struct iov_iter));
> +
>         do {
>                 nr_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
>                 wdata = cifs_writedata_alloc(nr_pages,
> @@ -2520,10 +2504,20 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
>                 wdata->bytes = cur_len;
>                 wdata->pagesz = PAGE_SIZE;
>                 wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
> -               rc = cifs_uncached_retry_writev(wdata);
> +
> +               if (!wdata->cfile->invalidHandle ||
> +                   !cifs_reopen_file(wdata->cfile, false))
> +                       rc = server->ops->async_writev(wdata,
> +                                       cifs_uncached_writedata_release);
>                 if (rc) {
>                         kref_put(&wdata->refcount,
>                                  cifs_uncached_writedata_release);
> +                       if (rc == -EAGAIN) {
> +                               memcpy(from, &saved_from,
> +                                      sizeof(struct iov_iter));
> +                               iov_iter_advance(from, offset - saved_offset);
> +                               continue;
> +                       }
>                         break;
>                 }
>
> @@ -2545,6 +2539,7 @@ cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
>         struct cifs_sb_info *cifs_sb;
>         struct cifs_writedata *wdata, *tmp;
>         struct list_head wdata_list;
> +       struct iov_iter saved_from;
>         int rc;
>
>         len = iov_iter_count(from);
> @@ -2565,6 +2560,8 @@ cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
>         if (!tcon->ses->server->ops->async_writev)
>                 return -ENOSYS;
>
> +       memcpy(&saved_from, from, sizeof(struct iov_iter));
> +
>         rc = cifs_write_from_iter(*poffset, len, from, open_file, cifs_sb,
>                                   &wdata_list);
>
> @@ -2596,7 +2593,25 @@ restart_loop:
>
>                         /* resend call if it's a retryable error */
>                         if (rc == -EAGAIN) {
> -                               rc = cifs_uncached_retry_writev(wdata);
> +                               struct list_head tmp_list;
> +                               struct iov_iter tmp_from;
> +
> +                               INIT_LIST_HEAD(&tmp_list);
> +                               list_del_init(&wdata->list);
> +
> +                               memcpy(&tmp_from, &saved_from,
> +                                      sizeof(struct iov_iter));
> +                               iov_iter_advance(&tmp_from,
> +                                                wdata->offset - *poffset);
> +
> +                               rc = cifs_write_from_iter(wdata->offset,
> +                                               wdata->bytes, &tmp_from,
> +                                               open_file, cifs_sb, &tmp_list);
> +
> +                               list_splice(&tmp_list, &wdata_list);

Do we list_splice unconditionally or do we list splice only if e.g.
if (!list_empty(&tmp_list)) i.e. could tmp_list be empty if
cifs_write_from_iter returned with non-zero rc (thus we did not
add a wdata to the list)?


> +
> +                               kref_put(&wdata->refcount,
> +                                        cifs_uncached_writedata_release);
>                                 goto restart_loop;
>                         }
>                 }
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index b0b260d..8f5754a 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -245,10 +245,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
>         if (rc)
>                 goto out;
>         atomic_inc(&tconInfoReconnectCount);
> -       /*
> -        * BB FIXME add code to check if wsize needs update due to negotiated
> -        * smb buffer size shrinking.
> -        */
>  out:
>         /*
>          * Check if handle based operation so we know whether we can continue
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
