From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial: add space in fsc error message
Date: Wed, 8 Jun 2011 11:03:38 -0500
Message-ID: <BANLkTik21on8GxkFtOh8za-oZJa_ijX0bg@mail.gmail.com>
References: <1307532924-10309-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1307532924-10309-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Wed, Jun 8, 2011 at 6:35 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 2b67280..4ec9630 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1391,7 +1391,7 @@ cifs_parse_mount_options(const char *mountdata,=
 const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"/proc=
/fs/cifs/LookupCacheEnabled to 0\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "fsc", 3) =3D=
=3D 0) {
> =A0#ifndef CONFIG_CIFS_FSCACHE
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "FS-Cache sup=
port needs CONFIG_CIFS_FSCACHE"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "FS-Cache sup=
port needs CONFIG_CIFS_FSCACHE "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"k=
ernel config option set");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cifs_parse_mount_=
err;
> =A0#endif
> --
> 1.7.5.2
>
>



--=20
Thanks,

Steve
