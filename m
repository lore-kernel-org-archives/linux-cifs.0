From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4] cifs: Do not modify mid entry after submitting I/O in cifs_call_async
Date: Thu, 29 Jun 2017 10:56:08 -0500
Message-ID: <CAH2r5muWvG-6mo=s+35CLJi7BeGoLm-5uP+OZz_2Hkm9G=kG_w@mail.gmail.com>
References: <1498690555-8454-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498690555-8454-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Wed, Jun 28, 2017 at 5:55 PM, Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org> wrote:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> In cifs_call_async, server may respond as soon as I/O is submitted. Because
> mid entry is freed on the return path, it should not be modified after I/O
> is submitted.
>
> cifs_save_when_sent modifies the sent timestamp in mid entry, and should not
> be called after I/O. Call it before I/O.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/transport.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 47a125e..7efbab0 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -536,11 +536,14 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
>         list_add_tail(&mid->qhead, &server->pending_mid_q);
>         spin_unlock(&GlobalMid_Lock);
>
> -
> +       /*
> +        * Need to store the time in mid before calling I/O. For call_async,
> +        * I/O response may come back and free the mid entry on another thread.
> +        */
> +       cifs_save_when_sent(mid);
>         cifs_in_send_inc(server);
>         rc = smb_send_rqst(server, rqst, flags);
>         cifs_in_send_dec(server);
> -       cifs_save_when_sent(mid);
>
>         if (rc < 0) {
>                 server->sequence_number -= 2;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
