From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH] CIFS: Fix some return values in case of error in
 'crypt_message'
Date: Mon, 12 Jun 2017 23:12:17 +0000
Message-ID: <CY4PR21MB0135BF129DED3C5BC7799C47B6CD0@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <20170611071247.2038-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>,
        "sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170611071247.2038-1-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-06-11 0:12 GMT-07:00 Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org=
>:
> 'rc' is known to be 0 at this point. So if 'init_sg' or 'kzalloc' fails, =
we
> should return -ENOMEM instead.
>
> Also remove a useless 'rc' in a debug message as it is meaningless here.
>
> Fixes: 026e93dc0a3ee ("CIFS: Encrypt SMB3 requests before sending")
> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
> ---
>  fs/cifs/smb2ops.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c58691834eb2..cdcb3d95add8 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1809,7 +1809,8 @@ crypt_message(struct TCP_Server_Info *server, struc=
t smb_rqst *rqst, int enc)
>
>         sg =3D init_sg(rqst, sign);
>         if (!sg) {
> -               cifs_dbg(VFS, "%s: Failed to init sg %d", __func__, rc);
> +               cifs_dbg(VFS, "%s: Failed to init sg", __func__);
> +               rc =3D -ENOMEM;
>                 goto free_req;
>         }
>
> @@ -1817,6 +1818,7 @@ crypt_message(struct TCP_Server_Info *server, struc=
t smb_rqst *rqst, int enc)
>         iv =3D kzalloc(iv_len, GFP_KERNEL);
>         if (!iv) {
>                 cifs_dbg(VFS, "%s: Failed to alloc IV", __func__);
> +               rc =3D -ENOMEM;
>                 goto free_sg;
>         }
>         iv[0] =3D 3;
> --
> 2.11.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for catching this.

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
