From: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH v2] CIFS: don't log STATUS_NOT_FOUND errors for DFS
Date: Tue, 21 Nov 2017 23:51:14 +0000
Message-ID: <CY4PR21MB013584AFCEC42F23FF2B6A5CB6230@CY4PR21MB0135.namprd21.prod.outlook.com>
References: <CAN05THRymsFpZcbXsSQj6=OVd94ZWE1L5a1EQF5-bz8qbG=oFA@mail.gmail.com>
 <20171121134756.25201-1-aaptel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121134756.25201-1-aaptel-IBi9RG/b67k@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



2017-11-21 5:47 GMT-08:00 Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
> cifs.ko makes DFS queries regardless of the type of the server and
> non-DFS servers are common. This often results in superfluous logging of
> non-critical errors.
>
> Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
> ---
> v2: instead of always logging at FYI level, only log non-ENOENT errors
>     at VFS level
>
>  fs/cifs/smb2ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 0dafdbae1f8c..3aa9f46c51e3 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1387,7 +1387,8 @@ smb2_get_dfs_refer(const unsigned int xid, struct c=
ifs_ses *ses,
>         } while (rc =3D=3D -EAGAIN);
>
>         if (rc) {
> -               cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer rc=3D%d\=
n", rc);
> +               if (rc !=3D -ENOENT)
> +                       cifs_dbg(VFS, "ioctl error in smb2_get_dfs_refer =
rc=3D%d\n", rc);
>                 goto out;
>         }
>
> --
> 2.12.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks!

Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

--
Best regards,
Pavel Shilovsky
