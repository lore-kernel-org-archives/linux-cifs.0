From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] CIFS: store results of cifs_reopen_file to avoid
 infinite wait
Date: Mon, 10 Apr 2017 10:40:44 -0700
Message-ID: <CAKywueS2ZWOLRNr_9BhpEqz81j_JsM0jzA-ncFeJzLEKYcREpw@mail.gmail.com>
References: <cover.333fa5a2e4d6ba38ce99ad2ef69bf44685343ca0.1491415908.git-series.germano.percossi@citrix.com>
 <3761685e05d2803c5ba1891f9d9004692254da95.1491415908.git-series.germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3761685e05d2803c5ba1891f9d9004692254da95.1491415908.git-series.germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-04-07 4:29 GMT-07:00 Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>:
> This fixes Continuous Availability when errors during
> file reopen are encountered.
>
> cifs_user_readv and cifs_user_writev would wait for ever if
> results of cifs_reopen_file are not stored and for later inspection.
>
> In fact, results are checked and, in case of errors, a chain
> of function calls leading to reads and writes to be scheduled in
> a separate thread is skipped.
> These threads will wake up the corresponding waiters once reads
> and writes are done.
>
> However, given the return value is not stored, when rc is checked
> for errors a previous one (always zero) is inspected instead.
> This leads to pending reads/writes added to the list, making
> cifs_user_readv and cifs_user_writev wait for ever.
>
> Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/file.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index aa3debb..21d4045 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2597,7 +2597,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
>                 wdata->credits = credits;
>
>                 if (!wdata->cfile->invalidHandle ||
> -                   !cifs_reopen_file(wdata->cfile, false))
> +                   !(rc = cifs_reopen_file(wdata->cfile, false)))
>                         rc = server->ops->async_writev(wdata,
>                                         cifs_uncached_writedata_release);
>                 if (rc) {
> @@ -3022,7 +3022,7 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>                 rdata->credits = credits;
>
>                 if (!rdata->cfile->invalidHandle ||
> -                   !cifs_reopen_file(rdata->cfile, true))
> +                   !(rc = cifs_reopen_file(rdata->cfile, true)))
>                         rc = server->ops->async_readv(rdata);
>  error:
>                 if (rc) {
> @@ -3617,7 +3617,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>                 }
>
>                 if (!rdata->cfile->invalidHandle ||
> -                   !cifs_reopen_file(rdata->cfile, true))
> +                   !(rc = cifs_reopen_file(rdata->cfile, true)))
>                         rc = server->ops->async_readv(rdata);
>                 if (rc) {
>                         add_credits_and_wake_if(server, rdata->credits, 0);
> --
> git-series 0.9.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Nice catch! This one should probably go to stable.

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
