From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Set ->should_dirty in cifs_user_readv()
Date: Wed, 21 Jun 2017 12:00:42 -0500
Message-ID: <CAH2r5mujedkOYtT4+2XjvLKBUZdz2OvuGst59Byv9Z6ONbvcEg@mail.gmail.com>
References: <20170505053040.x67a5f4riyba2wqb@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        kernel-janitors <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170505053040.x67a5f4riyba2wqb@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Fri, May 5, 2017 at 12:30 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> The current code causes a static checker warning because ITER_IOVEC is
> zero so the condition is never true.
>
> Fixes: 6685c5e2d1ac ("CIFS: Add asynchronous read support through kernel AIO")
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> I'm assuming this is the correct fix from looking at how ITER_IOVEC is
> normally used.  Please review.
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 6ef78ad838e6..71ba8fa63c41 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3271,7 +3271,7 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
>         if (!is_sync_kiocb(iocb))
>                 ctx->iocb = iocb;
>
> -       if (to->type & ITER_IOVEC)
> +       if (to->type == ITER_IOVEC)
>                 ctx->should_dirty = true;
>
>         rc = setup_aio_ctx_iter(ctx, to, READ);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
