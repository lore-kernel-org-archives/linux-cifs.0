From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v5 08/21] CIFS: SMBD: Upper layer reconnects to SMB Direct session
Date: Wed, 1 Nov 2017 11:04:45 -0700
Message-ID: <CAKywueRMRGhkw1zFh5HEBqV748hoq0DVsjGoVg8ttD22sTsYOQ@mail.gmail.com>
References: <20171018230920.21042-1-longli@exchange.microsoft.com> <20171018230920.21042-9-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171018230920.21042-9-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-10-18 16:09 GMT-07:00 Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> Do a reconnect on SMB Direct when it is used as the connection. Reconnect can
> happen for many reasons and it's mostly the decision of SMB2 upper layer.
>
> Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> ---
>  fs/cifs/connect.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 2c0b34a..8ca3c13 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -406,7 +406,14 @@ cifs_reconnect(struct TCP_Server_Info *server)
>
>                 /* we should try only the port we connected to before */
>                 mutex_lock(&server->srv_mutex);
> +#ifdef CONFIG_CIFS_SMB_DIRECT
> +               if (server->rdma)
> +                       rc = smbd_reconnect(server);
> +               else
> +                       rc = generic_ip_connect(server);

Minor: here and in other similar places we can remove #else part below
and put #endif before else block above.

> +#else
>                 rc = generic_ip_connect(server);
> +#endif
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

--
Best regards,
Pavel Shilovsky
