From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: handle guest access errors to Windows shares
Date: Mon, 10 Apr 2017 10:57:26 -0700
Message-ID: <CAKywueT__B6Z=yRMwmECRDW+Pei=Bd0zEatNF9ou3v6kaZ-UQw@mail.gmail.com>
References: <20161129113646.13360-2-mark.syms@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Mark Syms <mark.syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129113646.13360-2-mark.syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-11-29 3:36 GMT-08:00 Mark Syms <mark.syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>:
> Commit 1a967d6c9b39c226be1b45f13acd4d8a5ab3dc44 ("correctly to
> anonymous authentication for the NTLM(v2) authentication") introduces
> a regression in handling errors related to attempting a guest
> connection to a Windows share which requires authentication. This
> should result in a permission denied error but actually causes the
> kernel module to enter a never-ending loop trying to follow a DFS
> referal which doesn't exist.
>
> The base cause of this is the failure now occurs later in the process
> during tree connect and not at the session setup setup and all errors
> in tree connect are interpreted as needing to follow the DFS paths
> which isn't in this case correct. So, check the returned error against
> EACCES and fail if this is returned error.
> ---
>  fs/cifs/connect.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 4547aed..a1737aa 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3651,6 +3651,9 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
>         if (IS_ERR(tcon)) {
>                 rc = PTR_ERR(tcon);
>                 tcon = NULL;
> +               if (rc == -EACCES) {
> +                       goto mount_fail_check;
> +               }
>                 goto remote_path_check;
>         }
>
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
