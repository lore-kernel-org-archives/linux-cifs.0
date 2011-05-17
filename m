From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Create new binary cifs.idmap for sid to
 uid/gid mapping
Date: Tue, 17 May 2011 12:47:35 -0500
Message-ID: <BANLkTinrDemiA5zwm5Eq-BxADmhJq2FNPA@mail.gmail.com>
References: <1304667239-29127-1-git-send-email-shirishp@linux.vnet.ibm.com>
	<20110517120946.7890152b@tlielax.poochiereds.net>
	<BANLkTi=Xjn2AyfmtgXYja0+c3p0WhRiAdA@mail.gmail.com>
	<20110517131437.66de1ee8@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110517131437.66de1ee8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, May 17, 2011 at 12:14 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Tue, 17 May 2011 12:01:12 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> [...]
>
>> >> +if test $enable_cifsidmap !=3D "no"; then
>> >> + =A0 =A0 AC_CHECK_HEADERS([keyutils.h], , [
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test=
 "$enable_cifsidmap" =3D "yes"; then
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_ERROR([keyutils.h not found, consider installing keyuti=
ls-libs-devel.])
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_WARN([keyutils.h not found, consider installing keyutil=
s-libs-devel. Disabling cifs.idmap.])
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 enable_cifsidmap=3D"no"
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ])
>> >> +fi
>> >> +
>> >
>> > We're already doing a AC_CHECK_HEADERS for keyutils.h -- I don't t=
hink
>> > we want to do it again. Just use the same check for both cifs.upca=
ll
>> > and cifs.idmap.
>>
>> =A0Could someone build just cifs.idmap and not cifs.upcall?
>>
>
> Sure, I don't see why not.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Then would not we need  AC_CHECK_HEADERS for keyutils.h for cifs.idmap
in case cifs.upcall is not being built i.e. do would not we need both
these checks?

if test $enable_cifsupcall !=3D "no"; then
        AC_CHECK_HEADERS([keyutils.h], , [


if test $enable_cifsidmap !=3D "no"; then
        AC_CHECK_HEADERS([keyutils.h], , [
