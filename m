From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] cifs: add a cache= option to better describe the
 different cache flavors
Date: Tue, 15 May 2012 13:34:45 -0500
Message-ID: <CAH2r5msGcUSo2JLq=qUvWUfm3ynA18-5dPyZDbMB=F-1=BtXCw@mail.gmail.com>
References: <1335524179-1671-1-git-send-email-jlayton@redhat.com>
	<1335524179-1671-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335524179-1671-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Why is "fsc" (in particular caching of reads, to file, for oplocked
files) mutually exclusive with "strictcache" (write through of
non-oplocked files).

On Fri, Apr 27, 2012 at 5:56 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Currently, we have several mount options that control cifs' cache
> behavior, but those options aren't considered to be mutually exclusiv=
e.
> The result is poorly-defined when someone specifies more than one of
> these options at mont time.
>
> Fix this by adding a new cache=3D mount option that will supercede "f=
sc",
> "strictcache", and "forcedirectio". That will help make it clear that
> these options are mutually exclusive. Also, change the legacy options=
 to
> be mutually exclusive too, to ensure that users don't get surprises.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 74 +++++++++++++++++++++++++++++++++++++++=
+++++++++++--
> =A01 files changed, 71 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f31dc9a..de967dc 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -102,7 +102,7 @@ enum {
> =A0 =A0 =A0 =A0Opt_srcaddr, Opt_prefixpath,
> =A0 =A0 =A0 =A0Opt_iocharset, Opt_sockopt,
> =A0 =A0 =A0 =A0Opt_netbiosname, Opt_servern,
> - =A0 =A0 =A0 Opt_ver, Opt_sec,
> + =A0 =A0 =A0 Opt_ver, Opt_sec, Opt_cache,
>
> =A0 =A0 =A0 =A0/* Mount options to be ignored */
> =A0 =A0 =A0 =A0Opt_ignore,
> @@ -212,6 +212,7 @@ static const match_table_t cifs_mount_option_toke=
ns =3D {
> =A0 =A0 =A0 =A0{ Opt_ver, "vers=3D%s" },
> =A0 =A0 =A0 =A0{ Opt_ver, "version=3D%s" },
> =A0 =A0 =A0 =A0{ Opt_sec, "sec=3D%s" },
> + =A0 =A0 =A0 { Opt_cache, "cache=3D%s" },
>
> =A0 =A0 =A0 =A0{ Opt_ignore, "cred" },
> =A0 =A0 =A0 =A0{ Opt_ignore, "credentials" },
> @@ -258,6 +259,23 @@ static const match_table_t cifs_secflavor_tokens=
 =3D {
> =A0 =A0 =A0 =A0{ Opt_sec_err, NULL }
> =A0};
>
> +/* cache flavors */
> +enum {
> + =A0 =A0 =A0 Opt_cache_fsc,
> + =A0 =A0 =A0 Opt_cache_loose,
> + =A0 =A0 =A0 Opt_cache_strict,
> + =A0 =A0 =A0 Opt_cache_none,
> + =A0 =A0 =A0 Opt_cache_err
> +};
> +
> +static const match_table_t cifs_cacheflavor_tokens =3D {
> + =A0 =A0 =A0 { Opt_cache_fsc, "fsc" },
> + =A0 =A0 =A0 { Opt_cache_loose, "loose" },
> + =A0 =A0 =A0 { Opt_cache_strict, "strict" },
> + =A0 =A0 =A0 { Opt_cache_none, "none" },
> + =A0 =A0 =A0 { Opt_cache_err, NULL }
> +};
> +
> =A0static int ip_connect(struct TCP_Server_Info *server);
> =A0static int generic_ip_connect(struct TCP_Server_Info *server);
> =A0static void tlink_rb_insert(struct rb_root *root, struct tcon_link=
 *new_tlink);
> @@ -1183,6 +1201,42 @@ static int cifs_parse_security_flavors(char *v=
alue,
> =A0}
>
> =A0static int
> +cifs_parse_cache_flavor(char *value, struct smb_vol *vol)
> +{
> + =A0 =A0 =A0 substring_t args[MAX_OPT_ARGS];
> +
> + =A0 =A0 =A0 switch (match_token(value, cifs_cacheflavor_tokens, arg=
s)) {
> + =A0 =A0 =A0 case Opt_cache_fsc:
> +#ifndef CONFIG_CIFS_FSCACHE
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "cache=3Dfsc support requires=
 that the kernel be "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "built with CONFIG_=
CIFS_FSCACHE enabled.");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> +#endif
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->direct_io =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->fsc =3D true;
> + =A0 =A0 =A0 case Opt_cache_loose:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->direct_io =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->fsc =3D false;
> + =A0 =A0 =A0 case Opt_cache_strict:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->direct_io =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->fsc =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case Opt_cache_none:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->direct_io =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->fsc =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "bad cache=3D option: %s", va=
lue);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int
> =A0cifs_parse_mount_options(const char *mountdata, const char *devnam=
e,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_vol *vol)
> =A0{
> @@ -1411,10 +1465,14 @@ cifs_parse_mount_options(const char *mountdat=
a, const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->seal =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_direct:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->direct_io =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->fsc =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->direct_io =3D true=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D fals=
e;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_strictcache:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->fsc =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->direct_io =3D fals=
e;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D true=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_noac:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_WARNING "C=
IFS: Mount option noac not "
> @@ -1428,6 +1486,8 @@ cifs_parse_mount_options(const char *mountdata,=
 const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cifs_parse_mount_=
err;
> =A0#endif
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->fsc =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->direct_io =3D fals=
e;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D fals=
e;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Opt_mfsymlinks:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->mfsymlinks =3D tr=
ue;
> @@ -1835,6 +1895,14 @@ cifs_parse_mount_options(const char *mountdata=
, const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_parse_securit=
y_flavors(string, vol) !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto c=
ifs_parse_mount_err;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case Opt_cache:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 string =3D match_strdup=
(args);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (string =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t_nomem;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_parse_cache_fl=
avor(string, vol) !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ci=
fs_parse_mount_err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * An option we don't =
recognize. Save it off for later
> --
> 1.7.7.6
>



--=20
Thanks,

Steve
