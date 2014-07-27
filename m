From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 14/16] CIFS: Fix rsize usage in user read
Date: Sun, 27 Jul 2014 07:37:44 -0500
Message-ID: <CADT32e+QEx3AFc3+456vYqdrm0=B6_4VcWT3E_8NsY2rb6_mfQ@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-15-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-15-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> If a server changes maximum buffer size for read (rsize) requests
> on reconnect we can fail on repeating with a big size buffer on
> -EAGAIN error in user read. Fix this by checking rsize all the
> time before repeating requests.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 45 ++++++++++++++++++++++-----------------------
>  1 file changed, 22 insertions(+), 23 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 7df4e46..bbc3859 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2828,26 +2828,6 @@ cifs_uncached_readdata_release(struct kref *refcount)
>         cifs_readdata_release(refcount);
>  }
>
> -static int
> -cifs_retry_async_readv(struct cifs_readdata *rdata)
> -{
> -       int rc;
> -       struct TCP_Server_Info *server;
> -
> -       server = tlink_tcon(rdata->cfile->tlink)->ses->server;
> -
> -       do {
> -               if (rdata->cfile->invalidHandle) {
> -                       rc = cifs_reopen_file(rdata->cfile, true);
> -                       if (rc != 0)
> -                               continue;
> -               }
> -               rc = server->ops->async_readv(rdata);
> -       } while (rc == -EAGAIN);
> -
> -       return rc;
> -}
> -
>  /**
>   * cifs_readdata_to_iov - copy data from pages in response to an iovec
>   * @rdata:     the readdata response with list of pages holding data
> @@ -2941,6 +2921,9 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>         size_t cur_len;
>         int rc;
>         pid_t pid;
> +       struct TCP_Server_Info *server;
> +
> +       server = tlink_tcon(open_file->tlink)->ses->server;
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>                 pid = open_file->pid;
> @@ -2971,11 +2954,15 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>                 rdata->pagesz = PAGE_SIZE;
>                 rdata->read_into_pages = cifs_uncached_read_into_pages;
>
> -               rc = cifs_retry_async_readv(rdata);
> +               if (!rdata->cfile->invalidHandle ||
> +                   !cifs_reopen_file(rdata->cfile, true))
> +                       rc = server->ops->async_readv(rdata);
>  error:
>                 if (rc) {
>                         kref_put(&rdata->refcount,
>                                  cifs_uncached_readdata_release);
> +                       if (rc == -EAGAIN)
> +                               continue;
>                         break;
>                 }
>
> @@ -3023,8 +3010,8 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
>
>         len = iov_iter_count(to);
>         /* the loop below should proceed in the order of increasing offsets */
> +again:
>         list_for_each_entry_safe(rdata, tmp, &rdata_list, list) {
> -       again:
>                 if (!rc) {
>                         /* FIXME: freezable sleep too? */
>                         rc = wait_for_completion_killable(&rdata->done);
> @@ -3034,7 +3021,19 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
>                                 rc = rdata->result;
>                                 /* resend call if it's a retryable error */
>                                 if (rc == -EAGAIN) {
> -                                       rc = cifs_retry_async_readv(rdata);
> +                                       struct list_head tmp_list;
> +
> +                                       list_del_init(&rdata->list);
> +                                       INIT_LIST_HEAD(&tmp_list);
> +
> +                                       rc = cifs_send_async_read(rdata->offset,
> +                                               rdata->bytes, rdata->cfile,
> +                                               cifs_sb, &tmp_list);
> +
> +                                       list_splice(&tmp_list, &rdata_list);
> +
> +                                       kref_put(&rdata->refcount,
> +                                               cifs_uncached_readdata_release);
>                                         goto again;
>                                 }
>                         } else {
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
