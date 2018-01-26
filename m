From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH 1/1] CIFS: zero sensitive data when freeing
Date: Fri, 26 Jan 2018 23:01:35 +0000
Message-ID: <DM5PR2101MB09364133FCF7F1C824A2AE31B6E00@DM5PR2101MB0936.namprd21.prod.outlook.com>
References: <20180125145939.1021-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125145939.1021-1-aaptel-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



2018-01-25 6:59 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> also replaces memset()+kfree() by kzfree().
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |  3 +--
>  fs/cifs/connect.c     |  6 +++---
>  fs/cifs/misc.c        | 14 ++++----------
>  3 files changed, 8 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 68abbb0db608..f2b0a7f124da 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -325,9 +325,8 @@ int calc_lanman_hash(const char *password, const char=
 *cryptkey, bool encrypt,
>  {
>         int i;
>         int rc;
> -       char password_with_pad[CIFS_ENCPWD_SIZE];
> +       char password_with_pad[CIFS_ENCPWD_SIZE] =3D {0};
>
> -       memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
>         if (password)
>                 strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8b5e401f547a..ee2ab86bff5b 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1720,7 +1720,7 @@ cifs_parse_mount_options(const char *mountdata, con=
st char *devname,
>                         tmp_end++;
>                         if (!(tmp_end < end && tmp_end[1] =3D=3D delim)) =
{
>                                 /* No it is not. Set the password to NULL=
 */
> -                               kfree(vol->password);
> +                               kzfree(vol->password);
>                                 vol->password =3D NULL;
>                                 break;
>                         }
> @@ -1758,7 +1758,7 @@ cifs_parse_mount_options(const char *mountdata, con=
st char *devname,
>                                         options =3D end;
>                         }
>
> -                       kfree(vol->password);
> +                       kzfree(vol->password);
>                         /* Now build new password string */
>                         temp_len =3D strlen(value);
>                         vol->password =3D kzalloc(temp_len+1, GFP_KERNEL)=
;
> @@ -4356,7 +4356,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, k=
uid_t fsuid)
>                 reset_cifs_unix_caps(0, tcon, NULL, vol_info);
>  out:
>         kfree(vol_info->username);
> -       kfree(vol_info->password);
> +       kzfree(vol_info->password);
>         kfree(vol_info);
>
>         return tcon;
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index eea93ac15ef0..a0dbced4a45c 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -98,14 +98,11 @@ sesInfoFree(struct cifs_ses *buf_to_free)
>         kfree(buf_to_free->serverOS);
>         kfree(buf_to_free->serverDomain);
>         kfree(buf_to_free->serverNOS);
> -       if (buf_to_free->password) {
> -               memset(buf_to_free->password, 0, strlen(buf_to_free->pass=
word));
> -               kfree(buf_to_free->password);
> -       }
> +       kzfree(buf_to_free->password);
>         kfree(buf_to_free->user_name);
>         kfree(buf_to_free->domainName);
> -       kfree(buf_to_free->auth_key.response);
> -       kfree(buf_to_free);
> +       kzfree(buf_to_free->auth_key.response);
> +       kzfree(buf_to_free);
>  }
>
>  struct cifs_tcon *
> @@ -136,10 +133,7 @@ tconInfoFree(struct cifs_tcon *buf_to_free)
>         }
>         atomic_dec(&tconInfoAllocCount);
>         kfree(buf_to_free->nativeFileSystem);
> -       if (buf_to_free->password) {
> -               memset(buf_to_free->password, 0, strlen(buf_to_free->pass=
word));
> -               kfree(buf_to_free->password);
> -       }
> +       kzfree(buf_to_free->password);
>         kfree(buf_to_free);
>  }
>
> --
> 2.12.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
