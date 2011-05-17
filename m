From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping
Date: Tue, 17 May 2011 13:56:32 -0400
Message-ID: <20110517135632.08ca8038@tlielax.poochiereds.net>
References: <1304667239-29127-1-git-send-email-shirishp@linux.vnet.ibm.com>
	<20110517120946.7890152b@tlielax.poochiereds.net>
	<BANLkTi=Xjn2AyfmtgXYja0+c3p0WhRiAdA@mail.gmail.com>
	<20110517131437.66de1ee8@tlielax.poochiereds.net>
	<BANLkTinrDemiA5zwm5Eq-BxADmhJq2FNPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinrDemiA5zwm5Eq-BxADmhJq2FNPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 17 May 2011 12:47:35 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, May 17, 2011 at 12:14 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Tue, 17 May 2011 12:01:12 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > [...]
> >
> >> >> +if test $enable_cifsidmap !=3D "no"; then
> >> >> + =C2=A0 =C2=A0 AC_CHECK_HEADERS([keyutils.h], , [
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if test "$enable_cifsidmap" =3D "ye=
s"; then
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_=
ERROR([keyutils.h not found, consider installing keyutils-libs-devel.])
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AC_MSG_=
WARN([keyutils.h not found, consider installing keyutils-libs-devel. Di=
sabling cifs.idmap.])
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 enable_=
cifsidmap=3D"no"
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fi
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ])
> >> >> +fi
> >> >> +
> >> >
> >> > We're already doing a AC_CHECK_HEADERS for keyutils.h -- I don't=
 think
> >> > we want to do it again. Just use the same check for both cifs.up=
call
> >> > and cifs.idmap.
> >>
> >> =C2=A0Could someone build just cifs.idmap and not cifs.upcall?
> >>
> >
> > Sure, I don't see why not.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
> Then would not we need  AC_CHECK_HEADERS for keyutils.h for cifs.idma=
p
> in case cifs.upcall is not being built i.e. do would not we need both
> these checks?
>=20
> if test  ; then
>         AC_CHECK_HEADERS([keyutils.h], , [
>=20
>=20
> if test $enable_cifsidmap !=3D "no"; then
>         AC_CHECK_HEADERS([keyutils.h], , [

No, I think you just want to do a single AC_CHECK_HEADERS under:

    if test $enable_cifsupcall !=3D "no" -o $enable_cifsidmap !=3D "no"

=2E..and then handle both cases correctly.

OTOH, I think autoconf might cache the results of AC_CHECK_HEADERS and
won't re-do the test, so you may be alright without doing that. I'd
verify that by inspecting the log to be sure though.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
