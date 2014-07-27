From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 13/16] CIFS: Separate page reading from user read
Date: Sun, 27 Jul 2014 07:21:14 -0500
Message-ID: <CADT32eLcQGqRDhvXzWLf7yperr+CHPZG5sB_up8XUyDJGKiTKA@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-14-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-14-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 69 ++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 41 insertions(+), 28 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d627918..7df4e46 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2932,43 +2932,23 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
>         return total_read > 0 && result != -EAGAIN ? total_read : result;
>  }
>
> -ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
> +static int
> +cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
> +                    struct cifs_sb_info *cifs_sb, struct list_head *rdata_list)
>  {
> -       struct file *file = iocb->ki_filp;
> -       ssize_t rc;
> -       size_t len, cur_len;
> -       ssize_t total_read = 0;
> -       loff_t offset = iocb->ki_pos;
> +       struct cifs_readdata *rdata;
>         unsigned int npages;
> -       struct cifs_sb_info *cifs_sb;
> -       struct cifs_tcon *tcon;
> -       struct cifsFileInfo *open_file;
> -       struct cifs_readdata *rdata, *tmp;
> -       struct list_head rdata_list;
> +       size_t cur_len;
> +       int rc;
>         pid_t pid;
>
> -       len = iov_iter_count(to);
> -       if (!len)
> -               return 0;
> -
> -       INIT_LIST_HEAD(&rdata_list);
> -       cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> -       open_file = file->private_data;
> -       tcon = tlink_tcon(open_file->tlink);
> -
> -       if (!tcon->ses->server->ops->async_readv)
> -               return -ENOSYS;
> -
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>                 pid = open_file->pid;
>         else
>                 pid = current->tgid;
>
> -       if ((file->f_flags & O_ACCMODE) == O_WRONLY)
> -               cifs_dbg(FYI, "attempting read on write only file instance\n");
> -
>         do {
> -               cur_len = min_t(const size_t, len - total_read, cifs_sb->rsize);
> +               cur_len = min_t(const size_t, len, cifs_sb->rsize);
>                 npages = DIV_ROUND_UP(cur_len, PAGE_SIZE);
>
>                 /* allocate a readdata struct */
> @@ -2999,11 +2979,44 @@ error:
>                         break;
>                 }
>
> -               list_add_tail(&rdata->list, &rdata_list);
> +               list_add_tail(&rdata->list, rdata_list);
>                 offset += cur_len;
>                 len -= cur_len;
>         } while (len > 0);
>
> +       return rc;
> +}
> +
> +ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
> +{
> +       struct file *file = iocb->ki_filp;
> +       ssize_t rc;
> +       size_t len;
> +       ssize_t total_read = 0;
> +       loff_t offset = iocb->ki_pos;
> +       struct cifs_sb_info *cifs_sb;
> +       struct cifs_tcon *tcon;
> +       struct cifsFileInfo *open_file;
> +       struct cifs_readdata *rdata, *tmp;
> +       struct list_head rdata_list;
> +
> +       len = iov_iter_count(to);
> +       if (!len)
> +               return 0;
> +
> +       INIT_LIST_HEAD(&rdata_list);
> +       cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> +       open_file = file->private_data;
> +       tcon = tlink_tcon(open_file->tlink);
> +
> +       if (!tcon->ses->server->ops->async_readv)
> +               return -ENOSYS;
> +
> +       if ((file->f_flags & O_ACCMODE) == O_WRONLY)
> +               cifs_dbg(FYI, "attempting read on write only file instance\n");
> +
> +       rc = cifs_send_async_read(offset, len, open_file, cifs_sb, &rdata_list);
> +
>         /* if at least one read request send succeeded, then reset rc */
>         if (!list_empty(&rdata_list))
>                 rc = 0;
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
