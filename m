From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: Avoid returning EBUSY to upper layer VFS
Date: Thu, 6 Dec 2018 02:29:01 -0600
Message-ID: <CAH2r5mvvJ1-vP4o-hBUD04ySD+OvzGr12YcvyFBA9VWOs8gSGQ@mail.gmail.com>
References: <20181206045106.10307-1-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181206045106.10307-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Tentatively pushed to cifs-2.6.git for-next
On Wed, Dec 5, 2018 at 10:52 PM Long Li <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> EBUSY is not handled by VFS, and will be passed to user-mode. This is not
> correct as we need to wait for more credits.
>
> This patch also fixes a bug where rsize or wsize is used uninitialized when
> the call to server->ops->wait_mtu_credits() fails.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/file.c | 31 ++++++-------------------------
>  1 file changed, 6 insertions(+), 25 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 74c33d5..c9bc56b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2541,14 +2541,13 @@ static int
>  cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
>         struct cifs_aio_ctx *ctx)
>  {
> -       int wait_retry = 0;
>         unsigned int wsize, credits;
>         int rc;
>         struct TCP_Server_Info *server =
>                 tlink_tcon(wdata->cfile->tlink)->ses->server;
>
>         /*
> -        * Try to resend this wdata, waiting for credits up to 3 seconds.
> +        * Wait for credits to resend this wdata.
>          * Note: we are attempting to resend the whole wdata not in segments
>          */
>         do {
> @@ -2556,19 +2555,13 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
>                         server, wdata->bytes, &wsize, &credits);
>
>                 if (rc)
> -                       break;
> +                       goto out;
>
>                 if (wsize < wdata->bytes) {
>                         add_credits_and_wake_if(server, credits, 0);
>                         msleep(1000);
> -                       wait_retry++;
>                 }
> -       } while (wsize < wdata->bytes && wait_retry < 3);
> -
> -       if (wsize < wdata->bytes) {
> -               rc = -EBUSY;
> -               goto out;
> -       }
> +       } while (wsize < wdata->bytes);
>
>         rc = -EAGAIN;
>         while (rc == -EAGAIN) {
> @@ -3234,14 +3227,13 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
>                         struct list_head *rdata_list,
>                         struct cifs_aio_ctx *ctx)
>  {
> -       int wait_retry = 0;
>         unsigned int rsize, credits;
>         int rc;
>         struct TCP_Server_Info *server =
>                 tlink_tcon(rdata->cfile->tlink)->ses->server;
>
>         /*
> -        * Try to resend this rdata, waiting for credits up to 3 seconds.
> +        * Wait for credits to resend this rdata.
>          * Note: we are attempting to resend the whole rdata not in segments
>          */
>         do {
> @@ -3249,24 +3241,13 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
>                                                 &rsize, &credits);
>
>                 if (rc)
> -                       break;
> +                       goto out;
>
>                 if (rsize < rdata->bytes) {
>                         add_credits_and_wake_if(server, credits, 0);
>                         msleep(1000);
> -                       wait_retry++;
>                 }
> -       } while (rsize < rdata->bytes && wait_retry < 3);
> -
> -       /*
> -        * If we can't find enough credits to send this rdata
> -        * release the rdata and return failure, this will pass
> -        * whatever I/O amount we have finished to VFS.
> -        */
> -       if (rsize < rdata->bytes) {
> -               rc = -EBUSY;
> -               goto out;
> -       }
> +       } while (rsize < rdata->bytes);
>
>         rc = -EAGAIN;
>         while (rc == -EAGAIN) {
> --
> 2.7.4
>


-- 
Thanks,

Steve
