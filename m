From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] CIFS: check if pages is null rather than bv for a failed allocation
Date: Wed, 17 May 2017 13:05:30 -0700
Message-ID: <CAKywueQko2NYXegHaRnXguxfZXnXyqqifCG866YYmO96U7OTwg@mail.gmail.com>
References: <20170517182415.12081-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170517182415.12081-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2017-05-17 11:24 GMT-07:00 Colin King <colin.king@canonical.com>:
> From: Colin Ian King <colin.king@canonical.com>
>
> pages is being allocated however a null check on bv is being used
> to see if the allocation failed. Fix this by checking if pages is
> null.
>
> Detected by CoverityScan, CID#1432974 ("Logically dead code")
>
> Fixes: ccf7f4088af2dd ("CIFS: Add asynchronous context to support kernel AIO")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for catching this!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
