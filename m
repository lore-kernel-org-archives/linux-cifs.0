From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] cifs: make error on lack of a unc= option more explicit
Date: Wed, 21 Nov 2012 19:12:20 +0400
Message-ID: <CAKywueT2CaNfnDh9ZuSt76wEMhgZPw433wKyg-bTvd0x4Kmi_w@mail.gmail.com>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
	<1353087414-32152-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org, almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353087414-32152-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/11/16 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Error out with a clear error message if there is no unc= option. The
> existing code doesn't handle this in a clear fashion, and the check for
> a UNCip option with no UNC string is just plain wrong.
>
> Later, we'll fix the code to not require a unc= option, but for now we
> need this to at least clarify why people are getting errors about DFS
> parsing. With this change we can also get rid of some later NULL pointer
> checks since we know the UNC and UNCip will never be NULL there.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 5c670b9..b9849ac 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1799,6 +1799,11 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                 goto cifs_parse_mount_err;
>         }
>  #endif
> +       if (!vol->UNC) {
> +               cERROR(1, "CIFS mount error: No UNC path (e.g. -o "
> +                       "unc=\\\\192.168.1.100\\public) specified");
> +               goto cifs_parse_mount_err;
> +       }
>
>         if (vol->UNCip == NULL)
>                 vol->UNCip = &vol->UNC[2];
> @@ -2070,17 +2075,6 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>                         rc = -EINVAL;
>                         goto out_err;
>                 }
> -       } else if (volume_info->UNCip) {
> -               /* BB using ip addr as tcp_ses name to connect to the
> -                  DFS root below */
> -               cERROR(1, "Connecting to DFS root not implemented yet");
> -               rc = -EINVAL;
> -               goto out_err;
> -       } else /* which tcp_sess DFS root would we conect to */ {
> -               cERROR(1, "CIFS mount error: No UNC path (e.g. -o "
> -                       "unc=//192.168.1.100/public) specified");
> -               rc = -EINVAL;
> -               goto out_err;
>         }
>
>         /* see if we already have a matching tcp_ses */
> @@ -2736,9 +2730,6 @@ cifs_match_super(struct super_block *sb, void *data)
>
>         volume_info = mnt_data->vol;
>
> -       if (!volume_info->UNCip || !volume_info->UNC)
> -               goto out;
> -
>         rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
>                                 volume_info->UNCip,
>                                 strlen(volume_info->UNCip),
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.
