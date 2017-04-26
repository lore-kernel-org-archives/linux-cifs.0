From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Do not return number of bytes written for ioctl CIFS_IOC_COPYCHUNK_FILE
Date: Wed, 26 Apr 2017 16:37:53 -0700
Message-ID: <CAKywueQ+sa9d2aTCRkUzuUeeYcEn4++dM2ru2W2t-Dq1yCHvvQ@mail.gmail.com>
References: <20170426161017.19993-1-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170426161017.19993-1-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-04-26 9:10 GMT-07:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> commit 620d8745b35d ("Introduce cifs_copy_file_range()") changes the
> behaviour of the cifs ioctl call CIFS_IOC_COPYCHUNK_FILE. In case of
> successful writes, it now returns the number of bytes written. This
> return value is treated as an error by the xfstest cifs/001. Depending
> on the errno set at that time, this may or may not result in the test
> failing.
>
> The patch fixes this by setting the return value to 0 in case of
> successful writes.
>
> Fixes: commit 620d8745b35d ("Introduce cifs_copy_file_range()")
> Reported-by: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 265c45f..7f4bba5 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -74,7 +74,8 @@ static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
>
>         rc = cifs_file_copychunk_range(xid, src_file.file, 0, dst_file, 0,
>                                         src_inode->i_size, 0);
> -
> +       if (rc > 0)
> +               rc = 0;
>  out_fput:
>         fdput(src_file);
>  out_drop_write:
> --
> 2.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
