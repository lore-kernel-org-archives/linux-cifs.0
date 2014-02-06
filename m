From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS VFS: Send error in Flush = -9
Date: Thu, 6 Feb 2014 12:03:17 -0500
Message-ID: <20140206120317.091f6318@tlielax.poochiereds.net>
References: <loom.20140131T193830-201@post.gmane.org>
	<CADT32e+5whrPysC+8JmNupP1WPS1dT6hbb8O+DrH=SYSpsLk4w@mail.gmail.com>
	<1391592105.31475.YahooMailNeo@web140306.mail.bf1.yahoo.com>
	<20140205060047.6d5f0521@tlielax.poochiereds.net>
	<1391625916.17421.YahooMailNeo@web140302.mail.bf1.yahoo.com>
	<20140205135818.293a113f@corrin.poochiereds.net>
	<1391652130.90245.YahooMailNeo@web140306.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391652130.90245.YahooMailNeo-GNkJ2jOaCZKvrfWm4H71L5EhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 5 Feb 2014 18:02:10 -0800 (PST)
Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:

> Hi guys,
>=20
> I installed a 3.12.9 kernel, but the "Send error in Flush =3D -9" err=
ors still appear in quantity. =A0Any other ideas?
>=20
> Thanks,
>=20
> Jeff
>=20

(cc'ing linux-cifs -- sorry, I don't do private support unless you're
 paying me ;)

What would be best is to reopen the bug and attach a new capture if
you're still seeing the problem. Are there multiple machines involved
that are connecting through any sort of NAT? If so, then they'll all
need the same patch...

>=20
> ----- Original Message -----
> > From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Sent: Wednesday, February 5, 2014 10:58 AM
> > Subject: Re: CIFS VFS: Send error in Flush =3D -9
> >=20
> > On Wed, 5 Feb 2014 10:45:16 -0800 (PST)
> > Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> >=20
> >>  Hi Jeff,
> >>=20
> >>  Thanks for your reply! =A0What you said makes sense to me. =A0I'd=
 like to=20
> > apply the patch but after researching kernel patches for a couple h=
ours I=20
> > realize that I'm in over my head. =A0I have no problem attempting i=
t, but I=20
> > can't figure out how to tell if my current kernel contains it alrea=
dy or how=20
> > to install it (and any needed prerequisites). =A0My Xubuntu install=
ation is at=20
> > "Ubuntu 3.11.0-15.25-generic 3.11.10".
> >>=20
> >>  You're obviously super busy, but can you suggest a link with rele=
vant=20
> > instructions to follow? =A0There are hundreds of different kernel g=
uides out there=20
> > dating back over a decade.
> >>=20
> >>  Thanks again!
> >>=20
> >>  Jeff
> >>=20
> >=20
> > I'm pretty sure that patch went into mainline in v3.12, so it's lik=
ely
> > your v3.11 kernel doesn't have it. The trivial way to get it would =
be
> > to just move to a v3.12 kernel.
> >=20
> > If that's not possible you'll probably just need to get the sources=
 for
> > your kernel apply the patch to it and build it (I assume it should =
just
> > apply directly with little or no merge conflicts)...or talk the ubu=
ntu
> > folks into doing it for you.
> >=20
> > Good luck!
> >=20
> >=20
> >>=20
> >>  ----- Original Message -----
> >>  > From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>  > To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> >>  > Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Shirish Pargaonkar=
=20
> > <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>  > Sent: Wednesday, February 5, 2014 3:00 AM
> >>  > Subject: Re: CIFS VFS: Send error in Flush =3D -9
> >>  >=20
> >>  > On Wed, 5 Feb 2014 01:21:45 -0800 (PST)
> >>  >=20
> >>  > Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> >>  >=20
> >>  >>=A0 > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>  >>=20
> >>  >>=A0 > To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> >>  >>=A0 > Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> >>  >>=A0 > Sent: Friday, January 31, 2014 12:07 PM
> >>  >>=A0 > Subject: Re: CIFS VFS: Send error in Flush =3D -9
> >>  >>=A0 >=20
> >>  >>=A0 > -9 is EBADF.
> >>  >>=A0 >=20
> >>  >>=A0 > If you can send a wireshark trace of traffic between clie=
nt=20
> > and server
> >>  >>=A0 > that would be helpful.
> >>  >>=A0 >=20
> >>  >>=A0 >=20
> >>  >>=A0 >=20
> >>  >>=A0 > On Fri, Jan 31, 2014 at 1:20 PM, Jeff Berman=20
> > <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>=20
> >>  > wrote:
> >>  >>=A0 >>=A0 Hi there,
> >>  >>=A0 >>=20
> >>  >>=A0 >>=A0 I'm getting lots of CIFS errors in my system log:
> >>  >>=A0 >>=20
> >>  >>=A0 >>=A0 Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS=20
> > VFS: Send=20
> >>  > error
> >>  >>=A0 >> =A0 in Flush =3D -9
> >>  >>=A0 >>=A0 Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS=20
> > VFS: Send=20
> >>  > error
> >>  >>=A0 >> =A0 in Flush =3D -9
> >>  >>=A0 >>=A0 Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS=20
> > VFS: Send=20
> >>  > error
> >>  >>=A0 >> =A0 in Flush =3D -9
> >>  >>=20
> >>  >>=20
> >>  >>=A0 Ok, I think I did the wireshark trace correctly. =A0It's=20
> > attached to bug=20
> >>  > 10417 (https://bugzilla.samba.org/show_bug.cgi?id=3D10417).
> >>  >>=20
> >>  >>=A0 Thank you!
> >>  >=20
> >>  > Ok, I took a look and I'm pretty sure the problem is the=20
> > long-standing
> >>  > bug in how the client tried to use virtual circuits. Applying t=
his
> >>  > patch from mainline kernels should help things:
> >>  >=20
> >>  > commit 9ae6cf606a33b0a762798df0fb742848bcc685b5
> >>  > Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>  > Date:=A0=A0 Mon Sep 16 11:23:45 2013 -0400
> >>  >=20
> >>  > =A0 =A0 cifs: stop trying to use virtual circuits
> >>  >=20
> >>  > Please let us know if it doesn't.
> >=20
> >>  >=20
> >>  > --=20
> >>  > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> >>  >>=20
> >>  >=20
> >=20
> >=20
> > --=20
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
