From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: check if pages is null rather than bv for a failed allocation
Date: Wed, 21 Jun 2017 11:59:38 -0500
Message-ID: <CAH2r5mvmyaGrDUB38kndWBCGHHVvL4fj6pnwJK=VKVpB294xyw@mail.gmail.com>
References: <20170517182415.12081-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        kernel-janitors <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170517182415.12081-1-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

meged into cifs-2.6.git for-next

On Wed, May 17, 2017 at 1:24 PM, Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>
> pages is being allocated however a null check on bv is being used
> to see if the allocation failed. Fix this by checking if pages is
> null.
>
> Detected by CoverityScan, CID#1432974 ("Logically dead code")
>
> Fixes: ccf7f4088af2dd ("CIFS: Add asynchronous context to support kernel AIO")
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  fs/cifs/misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index b08531977daa..3b147dc6af63 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -810,7 +810,7 @@ setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw)
>
>         if (!pages) {
>                 pages = vmalloc(max_pages * sizeof(struct page *));
> -               if (!bv) {
> +               if (!pages) {
>                         kvfree(bv);
>                         return -ENOMEM;
>                 }
> --
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
