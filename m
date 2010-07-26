From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: map NT_STATUS_ERROR_WRITE_PROTECTED to -EROFS
Date: Mon, 26 Jul 2010 09:37:52 -0500
Message-ID: <AANLkTi=gCrDmgoS7M81zh=oa9hVj77-VPOwB0X+dV2MF@mail.gmail.com>
References: <1280154598-29628-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280154598-29628-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 26, 2010 at 9:29 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Seems like a more sensible mapping than -EIO.

I agree.  Also helps common case of Samba exporting read only shares by=
 default.

> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/netmisc.c | =A0 =A01 +
> =A0fs/cifs/smberr.h =A0| =A0 =A01 +
> =A02 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 3489468..c6721ee 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -61,6 +61,7 @@ static const struct smb_to_posix_error mapping_tabl=
e_ERRDOS[] =3D {
> =A0 =A0 =A0 =A0{ERRremcd, -EACCES},
> =A0 =A0 =A0 =A0{ERRdiffdevice, -EXDEV},
> =A0 =A0 =A0 =A0{ERRnofiles, -ENOENT},
> + =A0 =A0 =A0 {ERRwriteprot, -EROFS},
> =A0 =A0 =A0 =A0{ERRbadshare, -ETXTBSY},
> =A0 =A0 =A0 =A0{ERRlock, -EACCES},
> =A0 =A0 =A0 =A0{ERRunsup, -EINVAL},
> diff --git a/fs/cifs/smberr.h b/fs/cifs/smberr.h
> index c5084d2..7f16cb8 100644
> --- a/fs/cifs/smberr.h
> +++ b/fs/cifs/smberr.h
> @@ -76,6 +76,7 @@
> =A0#define ERRnofiles =A0 =A0 =A0 =A0 =A0 =A0 18 =A0 =A0 =A0/* A File=
 Search command can find no
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 more files matching the specified
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 criteria. */
> +#define ERRwriteprot =A0 =A0 =A0 =A0 =A0 19 =A0 =A0 =A0/* media is w=
rite protected */
> =A0#define ERRgeneral =A0 =A0 =A0 =A0 =A0 =A0 31
> =A0#define ERRbadshare =A0 =A0 =A0 =A0 =A0 =A032 =A0 =A0 =A0/* The sh=
aring mode specified for an
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 Open conflicts with existing FIDs on
> --
> 1.7.1.1
>
>



--=20
Thanks,

Steve
