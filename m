From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: print error code if smb signature verification fails
Date: Fri, 3 Aug 2012 10:15:29 -0500
Message-ID: <CAH2r5muaEymbw2ggwP6R9AQb+S-3ucY15ZOKJmOX_r=pHzEY1A@mail.gmail.com>
References: <501BC6F3.5050506@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <501BC6F3.5050506-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged after fixing the build problem in the patch (missing trailing
":- presumably due to breaking a long line > 80 characters
incorrectly)

On Fri, Aug 3, 2012 at 7:41 AM, Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> While trying to debug a SMB signature related issue with Windows Servers
> figured out it might be easier to debug if we print the error code from
> cifs_verify_signature(). Also, fix indendation while at it.
>
> Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
> ---
>
>  fs/cifs/cifssmb.c   |   11 ++++++++---
>  fs/cifs/transport.c |    9 ++++++---
>  2 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 074923c..3413042 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1576,9 +1576,14 @@ cifs_readv_callback(struct mid_q_entry *mid)
>                 /* result already set, check signature */
>                 if (server->sec_mode &
>                     (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
> -                       if (cifs_verify_signature(rdata->iov, rdata->nr_iov,
> -                                         server, mid->sequence_number + 1))
> -                               cERROR(1, "Unexpected SMB signature");
> +                       int rc = 0;
> +
> +                       rc = cifs_verify_signature(rdata->iov, rdata->nr_iov,
> +                                                  server,
> +                                                  mid->sequence_number + 1);
> +                       if (rc)
> +                               cERROR(1, "SMB signature verification returned
> +                                      error = %d", rc);
>                 }
>                 /* FIXME: should this be counted toward the initiating task? */
>                 task_io_account_read(rdata->bytes);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 83867ef..5d0778d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -503,13 +503,16 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>         /* convert the length into a more usable form */
>         if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
>                 struct kvec iov;
> +               int rc = 0;
>
>                 iov.iov_base = mid->resp_buf;
>                 iov.iov_len = len;
>                 /* FIXME: add code to kill session */
> -               if (cifs_verify_signature(&iov, 1, server,
> -                                         mid->sequence_number + 1) != 0)
> -                       cERROR(1, "Unexpected SMB signature");
> +               rc = cifs_verify_signature(&iov, 1, server,
> +                                          mid->sequence_number + 1) != 0;
> +               if (rc)
> +                       cERROR(1, "SMB signature verification returned error =
> +                              %d", rc);
>         }
>
>         /* BB special case reconnect tid and uid here? */



-- 
Thanks,

Steve
