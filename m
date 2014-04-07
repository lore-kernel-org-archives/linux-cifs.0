From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cifs-utils PATCH] autoconf: allow PAM security install
 directory to be configurable
Date: Mon, 7 Apr 2014 14:37:34 -0400
Message-ID: <20140407143734.04133bb5@tlielax.poochiereds.net>
References: <1396449058-13663-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lars-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396449058-13663-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  2 Apr 2014 10:30:58 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> From: Lars M=FCller <lars-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>=20
> Allow the pam module install directory to be set at build time.
>=20
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  Makefile.am  | 2 --
>  configure.ac | 6 ++++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/Makefile.am b/Makefile.am
> index a3fb413743b5..92da8b19dd5b 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -92,8 +92,6 @@ idmapwb.8: idmapwb.8.in
>  endif
> =20
>  if CONFIG_PAM
> -pamdir =3D $(libdir)/security
> -
>  pam_PROGRAMS =3D pam_cifscreds.so
> =20
>  pam_cifscreds.so: pam_cifscreds.c cifskey.c resolve_host.c util.c
> diff --git a/configure.ac b/configure.ac
> index 6cd8558a138a..43aa55c60053 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -58,6 +58,12 @@ AC_ARG_WITH(idmap-plugin,
>  AC_DEFINE_UNQUOTED(IDMAP_PLUGIN_PATH, "$pluginpath", [Location of pl=
ugin that ID mapping infrastructure should use. (usually a symlink to r=
eal plugin)])
>  AC_SUBST([pluginpath])
> =20
> +AC_ARG_WITH(pamdir,
> +	[AC_HELP_STRING([--with-pamdir=3DDIR],[Where to install the PAM mod=
ule @<:@default=3D$(libdir)/security@:>@])],
> +	pamdir=3D$withval,
> +	pamdir=3D"\$(libdir)/security")
> +AC_SUBST([pamdir])
> +
>  # check for ROOTSBINDIR environment var
>  if test -z $ROOTSBINDIR; then
>  	ROOTSBINDIR=3D"/sbin"


Merged...
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
