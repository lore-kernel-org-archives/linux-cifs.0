From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Sat, 4 Dec 2010 09:22:40 -0500
Message-ID: <20101204092240.4724e1ff@corrin.poochiereds.net>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<4CF9BB65.2010307@samba.org>
	<E1POnFL-00BKg9-JW@intern.SerNet.DE>
	<20101204064452.46ac24c7@tlielax.poochiereds.net>
	<AANLkTinsm=b5Pezzo4m6Jbmq96EcYas4Hsw0nhxfb4m6@mail.gmail.com>
	<20101204080942.42be63da@tlielax.poochiereds.net>
	<AANLkTim45G=pLwznde8S_b=FGCnYyO29Tnokghs0qZ-y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim45G=pLwznde8S_b=FGCnYyO29Tnokghs0qZ-y-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 4 Dec 2010 08:06:46 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Dec 4, 2010 at 7:09 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> > On Sat, 4 Dec 2010 06:25:07 -0600
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Sat, Dec 4, 2010 at 5:44 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wr=
ote:
> >>
> >> > On Sat, 4 Dec 2010 09:13:21 +0100
> >> > Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org> wrote:
> >> >
> >> > > On Fri, Dec 03, 2010 at 09:54:13PM -0600, Christopher R. Herte=
l wrote:
> >> > > > That may seem to be in the "who cares" category, since those=
 old
> >> > transports
> >> > > > are essentially dead (much more dead than NBT, or even NBF).
> >> > =A0Unfortunately,
> >> > > > the code to handle the old transports is still there in Wind=
ows, so
> >> > there
> >> > > > are behaviors -- things like the timeouts you're talking abo=
ut and the
> >> > weird
> >> > > > VC=3D0 shutdown behvior -- that exist because of these old d=
isused
> >> > transports.
> >> > >
> >> > > VC=3D0, how does Windows treat this facing NAT (masquerading)
> >> > > networks? I've done tests in the past where Windows killed
> >> > > valid connections from behind a NAT box when a new client
> >> > > came in.
> >> > >
> >> > > Volker
> >> >
> >> > It seems like the best way to deal with this on the server side =
with
> >> > direct hosted TCP would be to treat VC=3D0 like any other VC num=
ber
> >> > (MS-CIFS says that this is allowed).
> >> >
> >> > Ideally any new connection event from a host however should make=
 the
> >> > server check the validity of any other connection from the same =
host.
> >> > That way you could release resources held by dead connections in=
 case
> >> > the new one is a reconnect and needs to reclaim state.
> >> >
> >> > The question is how to check that validity. Unfortunately, the b=
est you
> >> > can probably do is rely on TCP keepalives.
> >> >
> >> > --
> >> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> > =A0--
> >> > To unsubscribe from this list: send the line "unsubscribe linux-=
cifs" in
> >> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
> >> >
> >>
> >>
> >> Is SMB Echo command the only way to determine whether to reconnect=
 or not?
> >> The assumption here is SMB server is unresponsive.
> >> There could be other circumstances on the server box (or even clie=
nt box)
> >> that are
> >> slowing down the SMB server responses such as slow network, slow n=
etwork
> >> stack,
> >> memory pressure etc.
> >> So server could be fine all along and yet client would ask for rec=
onnection!
> >
> > I think it's the best mechanism that the protocol has. If we aren't
> > going to use SMB echoes to detect an unresponsive server, then what
> > would you suggest? I don't think we can make calls wait indefinitel=
y
> > for a response without a mechanism to determine when the server is =
gone
> > and attempt to reestablish the connection to it.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
> I think we should use smb echo command as a means to let users know t=
he
> state of mount/server and let them decide.
> If smb echo times out, cifs client should just log it and stop at tha=
t and a
> very next request that receives a response (if any does) should log t=
hat server
> is responding.

Could you elaborate a bit?

What do you mean by "let them decide" -- what steps would someone take
if the server stopped responding? Aside from killing the application,
what recourse would they have?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
