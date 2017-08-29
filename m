From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v3 06/19] CIFS: SMBD: Reconnect to SMBDirect session
Date: Tue, 29 Aug 2017 16:15:29 -0700
Message-ID: <CAKywueT9qYnY1cXwtrc4HgRHMt27+JOJafpFTupwV45nViSQbw@mail.gmail.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com> <20170829192915.26251-7-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829192915.26251-7-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-08-29 12:29 GMT-07:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> Do a reconnect on SMBDirect when it is used as the connection. Reconnect can
> happen for many reasons and it's mostly the decision of upper layer SMB2 not
> SMBDirect.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/connect.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 43b4d54..341a3fd 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -409,7 +409,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
>
>                 /* we should try only the port we connected to before */
>                 mutex_lock(&server->srv_mutex);
> -               rc = generic_ip_connect(server);
> +               if (server->rdma)
> +                       rc = smbd_reconnect(server);
> +               else
> +                       rc = generic_ip_connect(server);
> +
>                 if (rc) {
>                         cifs_dbg(FYI, "reconnect error %d\n", rc);
>                         mutex_unlock(&server->srv_mutex);
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

It is a easier to follow the logic if the definition is introduced
together with using of this function in the existing code. I suggest
to add smbd_reconnect() definition in this patch.
--
Best regards,
Pavel Shilovsky
