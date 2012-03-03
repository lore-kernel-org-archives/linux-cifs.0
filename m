From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: help - can't stat() cifs file system
Date: Sat, 3 Mar 2012 06:35:58 -0500
Message-ID: <20120303063558.2a1885c3@tlielax.poochiereds.net>
References: <026601ccf8c3$faea9310$f0bfb930$@uw.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: <mchristi-lfcS8c3Mqgg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <026601ccf8c3$faea9310$f0bfb930$@uw.edu>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2 Mar 2012 14:29:44 -0800
"Mark Christiansen" <mchristi-lfcS8c3Mqgg@public.gmane.org> wrote:

> To whom it may concern,
>=20
> I am using linux kernel 2.6.32-220.4.1.el6.x86_64 (RHEL6) and cifs ve=
rsion
> 4.8.1.=C2=A0 Using a mount point (/mnt/tmp), we are able to read/writ=
e to our
> Windows directories.=C2=A0 Occasionally, a user will kill a job that =
is writing
> to these directories.=C2=A0 When this happens, it corrupts the mount =
point
> somehow and we get a permission denied error when we do an =E2=80=9Cl=
s=E2=80=9D.=C2=A0=20
>=20
> If I do an =E2=80=9Clsof=E2=80=9D and grep for the path, I get a =C2=A0=
message:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 WARNING: can=E2=80=99t stat() cifs file system /m=
nt/tmp
>=20
> It seems that if I am able to successfully unmount all of these mount
> points, that I can do a =E2=80=9Cmount =E2=80=93a=E2=80=9D and recove=
r.=C2=A0=20
>=20
> However, how can I avoid this problem in the first place (besides hav=
ing the
> user not kill jobs)?=C2=A0 It seems like this is something a user sho=
uld be able
> to do without bringing down the mount points.
>=20
> Thank you in advance,
>=20
> Mark=20
>=20
>=20

That certainly sounds like a bug, but we'll need to do some work to
track down the cause.

What would be ideal would be for you to open a RH support case so we
could work with you to track down the cause and a reproducer.
Alternately, you could open a bug at bugzilla.redhat.com and work with
it there if you're not able to open cases with our support people. If
you do the latter, be sure to cc me on the bug and I'll see if I can
help.

Thanks,
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
