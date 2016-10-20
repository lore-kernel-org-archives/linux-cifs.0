From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Call echo service immediately after socket reconnect
Date: Thu, 20 Oct 2016 13:30:30 -0700
Message-ID: <CAKywueQ=L5MunfYLGJ6NqBUq5fLbLuM5A7f93Kym+u7sqdm0OQ@mail.gmail.com>
References: <1476969267-22325-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476969267-22325-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-10-20 6:14 GMT-07:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Commit 4fcd1813e640 ("Fix reconnect to not defer smb3 session reconnect
> long after socket reconnect") changes the behaviour of the SMB2 echo
> service and causes it to renegotiate after a socket reconnect. However
> under default settings, the echo service could take up to 120 seconds to
> be scheduled.
>
> The patch forces the echo service to be called immediately resulting a
> negotiate call being made immediately on reconnect.

Looks like a right thing to do. Comments are inlined below:

>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index aab5227..43fd838 100644
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

Suppose we are setting echo_interval to 0 above

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

then we are sending an echo message and re-queue the echo work with
echo_interval==0:

rc = server->ops->echo ? server->ops->echo(server) : -ENOSYS;
....
queue_delayed_work(cifsiod_wq, &server->echo, echo_interval);

Shouldn't we queue the echo work with server->echo_interval (not 0) here?

-- 
Best regards,
Pavel Shilovsky
