From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] Call echo service immediately after socket reconnect
Date: Thu, 20 Oct 2016 18:33:25 -0700
Message-ID: <CAKywueST_Rk3J-L0nMTfZmxhjMa2xdorqT7=Rx5VS0_0wLtx-g@mail.gmail.com>
References: <1477007544-4656-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477007544-4656-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-10-20 16:52 GMT-07:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Commit 4fcd1813e640 ("Fix reconnect to not defer smb3 session reconnect
> long after socket reconnect") changes the behaviour of the SMB2 echo
> service and causes it to renegotiate after a socket reconnect. However
> under default settings, the echo service could take up to 120 seconds to
> be scheduled.
>
> The patch forces the echo service to be called immediately resulting a
> negotiate call being made immediately on reconnect.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index aab5227..4547aed 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -412,6 +412,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                 }
>         } while (server->tcpStatus == CifsNeedReconnect);
>
> +       if (server->tcpStatus == CifsNeedNegotiate)
> +               mod_delayed_work(cifsiod_wq, &server->echo, 0);
> +
>         return rc;
>  }
>
> @@ -421,17 +424,25 @@ cifs_echo_request(struct work_struct *work)
>         int rc;
>         struct TCP_Server_Info *server = container_of(work,
>                                         struct TCP_Server_Info, echo.work);
> -       unsigned long echo_interval = server->echo_interval;
> +       unsigned long echo_interval;
> +
> +       /*
> +        * If we need to renegotiate, set echo interval to zero to
> +        * immediately call echo service where we can renegotiate.
> +        */
> +       if (server->tcpStatus == CifsNeedNegotiate)
> +               echo_interval = 0;
> +       else
> +               echo_interval = server->echo_interval;
>
>         /*
> -        * We cannot send an echo if it is disabled or until the
> -        * NEGOTIATE_PROTOCOL request is done, which is indicated by
> -        * server->ops->need_neg() == true. Also, no need to ping if
> -        * we got a response recently.
> +        * We cannot send an echo if it is disabled.
> +        * Also, no need to ping if we got a response recently.
>          */
>
>         if (server->tcpStatus == CifsNeedReconnect ||
> -           server->tcpStatus == CifsExiting || server->tcpStatus == CifsNew ||
> +           server->tcpStatus == CifsExiting ||
> +           server->tcpStatus == CifsNew ||
>             (server->ops->can_echo && !server->ops->can_echo(server)) ||
>             time_before(jiffies, server->lstrp + echo_interval - HZ))
>                 goto requeue_echo;
> @@ -442,7 +453,7 @@ cifs_echo_request(struct work_struct *work)
>                          server->hostname);
>
>  requeue_echo:
> -       queue_delayed_work(cifsiod_wq, &server->echo, echo_interval);
> +       queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
>  }
>
>  static bool
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky
