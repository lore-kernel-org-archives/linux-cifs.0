From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: unbreak TCP session reuse
Date: Tue, 19 Jul 2016 22:14:02 +0300
Message-ID: <CAKywueS2Avvh4g04FvMa4pLYJ11rRCtNpN2+8_gzd5c40Azevw@mail.gmail.com>
References: <1468913145-23353-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
To: Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468913145-23353-1-git-send-email-rabin.vincent-VrBV9hrLPhE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-07-19 10:25 GMT+03:00 Rabin Vincent <rabin.vincent-VrBV9hrLPhE@public.gmane.org>:
> From: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
>
> adfeb3e0 ("cifs: Make echo interval tunable") added a comparison of
> vol->echo_interval to server->echo_interval as a criterium to
> match_server(), but:
>
>  (1) A default value is set for server->echo_interval but not for
>  vol->echo_interval, meaning these can never match if the echo_interval
>  option is not specified.
>
>  (2) vol->echo_interval is in seconds but server->echo_interval is in
>  jiffies, meaning these can never match even if the echo_interval option
>  is specified.
>
> This broke TCP session reuse since match_server() can never return 1.
> Fix it.
>
> Fixes: adfeb3e0 ("cifs: Make echo interval tunable")
> Signed-off-by: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
> ---
>  fs/cifs/connect.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7d2b15c..eb24653 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1228,6 +1228,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>         vol->ops = &smb1_operations;
>         vol->vals = &smb1_values;
>
> +       vol->echo_interval = SMB_ECHO_INTERVAL_DEFAULT;
> +
>         if (!mountdata)
>                 goto cifs_parse_mount_err;
>
> @@ -2049,7 +2051,7 @@ static int match_server(struct TCP_Server_Info *server, struct smb_vol *vol)
>         if (!match_security(server, vol))
>                 return 0;
>
> -       if (server->echo_interval != vol->echo_interval)
> +       if (server->echo_interval != vol->echo_interval * HZ)
>                 return 0;
>
>         return 1;
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good. I applied it and it works as expected.

Reviewed-and-Tested-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky
