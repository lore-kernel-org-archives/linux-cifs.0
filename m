From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 08/16] CIFS: Separate writing from iovec write
Date: Mon, 21 Jul 2014 00:05:06 -0500
Message-ID: <CADT32e+2Z_ryfg8JznJoFt9=4mSU1bVYmeR-+nguXUq1vQVMMg@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
	<1403863073-19526-9-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-9-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 27, 2014 at 4:57 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 79 ++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 47 insertions(+), 32 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index e2a735a..06080e0 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2468,41 +2468,17 @@ wdata_fill_from_iovec(struct cifs_writedata *wdata, struct iov_iter *from,
>         return rc;
>  }
>
> -static ssize_t
> -cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
> +static int
> +cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
> +                    struct cifsFileInfo *open_file,
> +                    struct cifs_sb_info *cifs_sb, struct list_head *wdata_list)
>  {
> +       int rc = 0;
> +       size_t cur_len;
>         unsigned long nr_pages, i;
> -       size_t len, cur_len;
> -       ssize_t total_written = 0;
> -       loff_t offset;
> -       struct cifsFileInfo *open_file;
> -       struct cifs_tcon *tcon;
> -       struct cifs_sb_info *cifs_sb;
> -       struct cifs_writedata *wdata, *tmp;
> -       struct list_head wdata_list;
> -       int rc;
> +       struct cifs_writedata *wdata;
>         pid_t pid;
>
> -       len = iov_iter_count(from);
> -       rc = generic_write_checks(file, poffset, &len, 0);
> -       if (rc)
> -               return rc;
> -
> -       if (!len)
> -               return 0;
> -
> -       iov_iter_truncate(from, len);
> -
> -       INIT_LIST_HEAD(&wdata_list);
> -       cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> -       open_file = file->private_data;
> -       tcon = tlink_tcon(open_file->tlink);
> -
> -       if (!tcon->ses->server->ops->async_writev)
> -               return -ENOSYS;
> -
> -       offset = *poffset;
> -
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
>                 pid = open_file->pid;
>         else
> @@ -2546,11 +2522,50 @@ cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
>                         break;
>                 }
>
> -               list_add_tail(&wdata->list, &wdata_list);
> +               list_add_tail(&wdata->list, wdata_list);
>                 offset += cur_len;
>                 len -= cur_len;
>         } while (len > 0);
>
> +       return rc;
> +}
> +
> +static ssize_t
> +cifs_iovec_write(struct file *file, struct iov_iter *from, loff_t *poffset)
> +{
> +       size_t len;
> +       ssize_t total_written = 0;
> +       loff_t offset;
> +       struct cifsFileInfo *open_file;
> +       struct cifs_tcon *tcon;
> +       struct cifs_sb_info *cifs_sb;
> +       struct cifs_writedata *wdata, *tmp;
> +       struct list_head wdata_list;
> +       int rc;
> +
> +       len = iov_iter_count(from);
> +       rc = generic_write_checks(file, poffset, &len, 0);
> +       if (rc)
> +               return rc;
> +
> +       if (!len)
> +               return 0;
> +
> +       iov_iter_truncate(from, len);
> +
> +       INIT_LIST_HEAD(&wdata_list);
> +       cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
> +       open_file = file->private_data;
> +       tcon = tlink_tcon(open_file->tlink);
> +
> +       if (!tcon->ses->server->ops->async_writev)
> +               return -ENOSYS;
> +
> +       offset = *poffset;

we do not use offset in this function after assignment

> +
> +       rc = cifs_write_from_iter(*poffset, len, from, open_file, cifs_sb,
> +                                 &wdata_list);

and do not act on the value of rc (if ENOMEM) here.

> +
>         /*
>          * If at least one write was successfully sent, then discard any rc
>          * value from the later writes. If the other write succeeds, then
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
