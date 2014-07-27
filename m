From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 15/16] CIFS: Fix rsize usage for sync read
Date: Sun, 27 Jul 2014 07:49:44 -0500
Message-ID: <CADT32eJjCNKeWJW4_sgftsv94GL8qv_GMJMcPu1TB1pek6jqcQ@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-16-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405957558-18476-16-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

On Mon, Jul 21, 2014 at 10:45 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> If a server changes maximum buffer size for read requests (rsize)
> on reconnect we can fail on repeating with a big size buffer on
> -EAGAIN error in cifs_read. Fix this by checking rsize all the
> time before repeating requests.
>
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index bbc3859..00b2a25 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3148,18 +3148,19 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
>
>         for (total_read = 0, cur_offset = read_data; read_size > total_read;
>              total_read += bytes_read, cur_offset += bytes_read) {
> -               current_read_size = min_t(uint, read_size - total_read, rsize);
> -               /*
> -                * For windows me and 9x we do not want to request more than it
> -                * negotiated since it will refuse the read then.
> -                */
> -               if ((tcon->ses) && !(tcon->ses->capabilities &
> +               do {
> +                       current_read_size = min_t(uint, read_size - total_read,
> +                                                 rsize);
> +                       /*
> +                        * For windows me and 9x we do not want to request more
> +                        * than it negotiated since it will refuse the read
> +                        * then.
> +                        */
> +                       if ((tcon->ses) && !(tcon->ses->capabilities &
>                                 tcon->ses->server->vals->cap_large_files)) {
> -                       current_read_size = min_t(uint, current_read_size,
> -                                       CIFSMaxBufSize);
> -               }
> -               rc = -EAGAIN;
> -               while (rc == -EAGAIN) {
> +                               current_read_size = min_t(uint,
> +                                       current_read_size, CIFSMaxBufSize);
> +                       }
>                         if (open_file->invalidHandle) {
>                                 rc = cifs_reopen_file(open_file, true);
>                                 if (rc != 0)
> @@ -3172,7 +3173,8 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
>                         rc = server->ops->sync_read(xid, open_file, &io_parms,
>                                                     &bytes_read, &cur_offset,
>                                                     &buf_type);
> -               }
> +               } while (rc == -EAGAIN);
> +
>                 if (rc || (bytes_read == 0)) {
>                         if (total_read) {
>                                 break;
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
