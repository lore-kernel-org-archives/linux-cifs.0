From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: allow fsc mount option only if CONFIG_CIFS_FSCACHE
 is set
Date: Mon, 29 Nov 2010 22:05:58 +0530
Message-ID: <4CF3D66E.4060505@suse.de>
References: <1290601147-11392-1-git-send-email-sjayaraman@suse.de>	<1290601147-11392-2-git-send-email-sjayaraman@suse.de>	<AANLkTinysSbT-p=_btJ4YGORDiY5Tz2aT=VagDieUGhY@mail.gmail.com> <AANLkTimWZYcUFRu1JAzdX2u5POL6UGDq=ESXqMPsc+Ly@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimWZYcUFRu1JAzdX2u5POL6UGDq=ESXqMPsc+Ly-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/27/2010 09:21 AM, Steve French wrote:
>=20
>=20
> On Fri, Nov 26, 2010 at 9:50 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> <mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>> wrote:
>=20
>     As an alternative - if fsc is stable and no defects and doesn't
>     increase the code size appreciably ... what are the drawbacks of
>     turning it on unconditionally?
>=20
>=20
> ie always configure it, we still only enable it on a mount when fsc i=
s
> specified on mount
> =EF=BF=BD

I'm not aware of any open issues w.r.t cifs FS-Cache (except the
problems this patchset addresses) but I'm not sure how much testing it
has undergone really (except for me running all my tests with fsc on fo=
r
sometime and a few openSUSE users). The code size is not really much of
a problem.

The strict cache patches accounting for fscache might also provide more
testing ground. So, I think keeping it as non-default atleast for one
more release would be good before we make it as a config default.

Thanks,

>     On Wed, Nov 24, 2010 at 6:19 AM, Suresh Jayaraman
>     <sjayaraman-l3A5Bk7waGM@public.gmane.org <mailto:sjayaraman-l3A5Bk7waGM@public.gmane.org>> wrote:
>=20
>         Currently, it is possible to specify 'fsc' mount option even =
if
>         CONFIG_CIFS_FSCACHE has not been set. The option is being
>         ignored silently
>         while the user fscache functionality to work. Fix this by
>         raising error when
>         the CONFIG option is not set.
>=20
>=20
>         Reported-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>         <mailto:jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>>
>         Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org
>         <mailto:sjayaraman-l3A5Bk7waGM@public.gmane.org>>
>         ---
>         =EF=BF=BDfs/cifs/connect.c | =EF=BF=BD =EF=BF=BD5 +++++
>         =EF=BF=BD1 files changed, 5 insertions(+), 0 deletions(-)
>=20
>         diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>         index 251a17c..32fa4d9 100644
>         --- a/fs/cifs/connect.c
>         +++ b/fs/cifs/connect.c
>         @@ -1352,6 +1352,11 @@ cifs_parse_mount_options(char *options=
,
>         const char *devname,
>         =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD"supported. Instead set "
>         =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD"/proc/fs/cifs/LookupCacheEnabled
>         to 0\n");
>         =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD} else if (strnicmp(data, "fsc", 3) =3D=3D 0) {
>         +#ifndef CONFIG_CIFS_FSCACHE
>         + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD cERROR(1, "FS-Cache =
support needs
>         CONFIG_CIFS_FSCACHE"
>         + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD =EF=BF=BD =EF=BF=BD "kernel config option set");
>         + =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD return 1;
>         +#endif
>         =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDvol->fsc =3D tr=
ue;
>         =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD} else if (strnicmp(data, "mfsymlinks", 10) =3D=3D 0) {
>         =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDvol->mfsymlinks=
 =3D true;
>=20
>=20
>=20
>=20
>     --=20
>     Thanks,
>=20
>     Steve
>=20
>=20
>=20
>=20
> --=20
> Thanks,
>=20
> Steve


--=20
Suresh Jayaraman
