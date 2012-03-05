From: "CHRU IT Administrator" <chruit-lfcS8c3Mqgg@public.gmane.org>
Subject: RE: help - can't stat() cifs file system
Date: Mon, 5 Mar 2012 09:39:12 -0800
Message-ID: <02ea01ccfaf6$e1af6990$a50e3cb0$@uw.edu>
References: <026601ccf8c3$faea9310$f0bfb930$@uw.edu> <20120303063558.2a1885c3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "'Jeff Layton'" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120303063558.2a1885c3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Language: en-us
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,

Since I don't have RedHat support, I opened a bug through bugzilla.redh=
at.com.  The bug number is 800082.  I see that it was assigned to you. =
=20

Thank you for future correspondence while troubleshooting this bug.  I =
can coordinate with the end user experiencing this bug, if you think it=
 is helpful for reproduction.  Also, if you need log files, etc, I am h=
appy to pass them along.=20

Best regards,

Mark Christiansen
University of Washington
Cardiovascular Health Research Unit
(206) 287-2768





-----Original Message-----
=46rom: Jeff Layton [mailto:jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]=20
Sent: Saturday, March 03, 2012 3:36 AM
To: mchristi-lfcS8c3Mqgg@public.gmane.org
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: help - can't stat() cifs file system

On Fri, 2 Mar 2012 14:29:44 -0800
"Mark Christiansen" <mchristi-lfcS8c3Mqgg@public.gmane.org> wrote:

> To whom it may concern,
>=20
> I am using linux kernel 2.6.32-220.4.1.el6.x86_64 (RHEL6) and cifs=20
> version 4.8.1.  Using a mount point (/mnt/tmp), we are able to=20
> read/write to our Windows directories.  Occasionally, a user will kil=
l=20
> a job that is writing to these directories.  When this happens, it=20
> corrupts the mount point somehow and we get a permission denied error=
 when we do an =E2=80=9Cls=E2=80=9D.
>=20
> If I do an =E2=80=9Clsof=E2=80=9D and grep for the path, I get a  mes=
sage:
>=20
>                 WARNING: can=E2=80=99t stat() cifs file system /mnt/t=
mp
>=20
> It seems that if I am able to successfully unmount all of these mount=
=20
> points, that I can do a =E2=80=9Cmount =E2=80=93a=E2=80=9D and recove=
r.
>=20
> However, how can I avoid this problem in the first place (besides=20
> having the user not kill jobs)?  It seems like this is something a=20
> user should be able to do without bringing down the mount points.
>=20
> Thank you in advance,
>=20
> Mark
>=20
>=20

That certainly sounds like a bug, but we'll need to do some work to tra=
ck down the cause.

What would be ideal would be for you to open a RH support case so we co=
uld work with you to track down the cause and a reproducer.
Alternately, you could open a bug at bugzilla.redhat.com and work with =
it there if you're not able to open cases with our support people. If y=
ou do the latter, be sure to cc me on the bug and I'll see if I can hel=
p.

Thanks,
--
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
