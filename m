From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH] cifs: check rsp for NULL before dereferencing in
 SMB2_open
Date: Fri, 8 Sep 2017 01:01:12 +0000
Message-ID: <CY4PR21MB01356781E9457873AE7A8AAAB6950@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <20170908003735.14789-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170908003735.14789-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-09-07 17:37 GMT-07:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> In SMB2_open there are several paths where the SendReceive2
> call will return an error before it sets rsp_iov.iov_base
> thus leaving iov_base uninitialized.
>
> Thus we need to check rsp before we dereference it in
> the call to get_rfc1002_length().
>
> A report of this issue was previously reported in
> http://www.spinics.net/lists/linux-cifs/msg12846.html
>
> RH-bugzilla : 1476151
>
> Version 2 :
> * Lets properly initialize rsp_iov before we use it.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 97edb4d376cd..6e7d145d8b2f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1617,7 +1617,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_=
parms *oparms, __le16 *path,
>         struct cifs_tcon *tcon =3D oparms->tcon;
>         struct cifs_ses *ses =3D tcon->ses;
>         struct kvec iov[4];
> -       struct kvec rsp_iov;
> +       struct kvec rsp_iov =3D {NULL, 0};
>         int resp_buftype;
>         int uni_path_len;
>         __le16 *copy_path =3D NULL;
> @@ -1746,7 +1746,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_=
parms *oparms, __le16 *path,
>
>         if (rc !=3D 0) {
>                 cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
> -               if (err_buf)
> +               if (err_buf && rsp)
>                         *err_buf =3D kmemdup(rsp, get_rfc1002_length(rsp)=
 + 4,
>                                            GFP_KERNEL);
>                 goto creat_exit;
> --
> 2.13.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The patch looks correct. Good candidate for stable, I think.

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>.

Also It seems like we are not checking for the STATUS_STOPPED_ON_SYMLINK er=
ror code in smb2_query_symlink().

--
Best regards,
Pavel Shilovsky
