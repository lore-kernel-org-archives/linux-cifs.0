From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/11] cifs: add deprecation warning to
 sockopt=TCP_NODELAY option
Date: Wed, 25 Jul 2012 16:31:32 +0400
Message-ID: <CAKywueQzaUjK6Y=aKDOWedLTD91eAGTJttvGhdy11MPin_ZVtA@mail.gmail.com>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
	<1342634346-22818-12-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342634346-22818-12-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Now that we're using TCP_CORK on the socket, there's no value in
> continuting to support this option. Schedule it for removal in 3.8.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 303be53..29d9716 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1830,12 +1830,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         if (string == NULL)
>                                 goto out_nomem;
>
> -                       /*
> -                        * FIXME: since we now cork/uncork the socket while
> -                        *        sending, should we deprecate this option?
> -                        */
> -                       if (strnicmp(string, "TCP_NODELAY", 11) == 0)
> +                       if (strnicmp(string, "TCP_NODELAY", 11) == 0) {
> +                               printk(KERN_WARNING, "CIFS: the "
> +                                       "sockopt=TCP_NODELAY option has been "
> +                                       "deprecated and will be removed "
> +                                       "in 3.8\n");
>                                 vol->sockopt_tcp_nodelay = 1;
> +                       }
>                         break;
>                 case Opt_netbiosname:
>                         string = match_strdup(args);
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.
