From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS VFS: Send error in Flush = -9
Date: Wed, 5 Feb 2014 06:00:47 -0500
Message-ID: <20140205060047.6d5f0521@tlielax.poochiereds.net>
References: <loom.20140131T193830-201@post.gmane.org>
	<CADT32e+5whrPysC+8JmNupP1WPS1dT6hbb8O+DrH=SYSpsLk4w@mail.gmail.com>
	<1391592105.31475.YahooMailNeo@web140306.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391592105.31475.YahooMailNeo-GNkJ2jOaCZKvrfWm4H71L5EhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 5 Feb 2014 01:21:45 -0800 (PST)
Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:

> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>=20
> > To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Sent: Friday, January 31, 2014 12:07 PM
> > Subject: Re: CIFS VFS: Send error in Flush =3D -9
> >=20
> > -9 is EBADF.
> >=20
> > If you can send a wireshark trace of traffic between client and ser=
ver
> > that would be helpful.
> >=20
> >=20
> >=20
> > On Fri, Jan 31, 2014 at 1:20 PM, Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wr=
ote:
> >>  Hi there,
> >>=20
> >>  I'm getting lots of CIFS errors in my system log:
> >>=20
> >>  Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send er=
ror
> >> =A0 in Flush =3D -9
> >>  Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send er=
ror
> >> =A0 in Flush =3D -9
> >>  Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send er=
ror
> >> =A0 in Flush =3D -9
>=20
>=20
> Ok, I think I did the wireshark trace correctly. =A0It's attached to =
bug 10417 (https://bugzilla.samba.org/show_bug.cgi?id=3D10417).
>=20
> Thank you!

Ok, I took a look and I'm pretty sure the problem is the long-standing
bug in how the client tried to use virtual circuits. Applying this
patch from mainline kernels should help things:

commit 9ae6cf606a33b0a762798df0fb742848bcc685b5
Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon Sep 16 11:23:45 2013 -0400

    cifs: stop trying to use virtual circuits

Please let us know if it doesn't.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
