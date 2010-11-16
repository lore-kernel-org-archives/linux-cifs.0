From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add match_port check during looking for an
 existing connection (try #2)
Date: Tue, 16 Nov 2010 14:21:22 -0500
Message-ID: <20101116142122.37ccb72d@corrin.poochiereds.net>
References: <1289893710-7352-1-git-send-email-piastryyy@gmail.com>
	<1289893710-7352-2-git-send-email-piastryyy@gmail.com>
	<AANLkTinX6o59YD2EAL4ahJoD1PBLNUCF-MXUss9yhZnd@mail.gmail.com>
	<20101116135714.358d6b10@corrin.poochiereds.net>
	<AANLkTimUVphDeWti-mid5jS2g-sF1jDVU7rMuyaPExUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimUVphDeWti-mid5jS2g-sF1jDVU7rMuyaPExUg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 16 Nov 2010 13:02:10 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Nov 16, 2010 at 12:57 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Tue, 16 Nov 2010 12:47:07 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Tue, Nov 16, 2010 at 1:48 AM, Pavel Shilovsky <piastryyy@gmail.=
com> wrote:
> >> > If we have a share mounted by non-standard port and try to mount=
 another share
> >> > on the same host with standard port, we connect to the first sha=
re again -
> >> > that's wrong. This patch fixes this bug.
> >>
> >> The description seems a little strange - can you clarify?
> >>
> >> If we have an existing session with a server (using whatever port)=
, by
> >> default we want to use it (unless the user forces a different port
> >> than the existing connection was made with). =A0If we have a firew=
all
> >> issue and therefore go through a non-standard port (port=3Dsomethi=
ng on
> >> mount), we usually wouldn't want to fork a new connection on a sec=
ond
> >> connection to the same server.
> >>
> >> So if we specify port=3D5000 on a mount and we already have a moun=
t on
> >> port 139, it makes sense that we would want to create a new sessio=
n.
> >> But if you already have a mount on port 5000, and did a mount with=
 no
> >> port specified - why wouldn't you use the existing port? =A0It sav=
es
> >> server, client and network resources.
> >>
> >
> > That doesn't match what the manpage says. It says:
> >
> > =A0 =A0 =A0 port=3Darg
> > =A0 =A0 =A0 =A0 =A0 sets the port number on the server to attempt t=
o contact to
> > =A0 =A0 =A0 =A0 =A0 negotiate CIFS support. If the CIFS server is n=
ot listening on this
> > =A0 =A0 =A0 =A0 =A0 port or if it is not specified, the default por=
ts will be tried
> > =A0 =A0 =A0 =A0 =A0 i.e. port 445 is tried and if no response then =
port 139 is tried.
> >
> >
> > ...which to me says that if you want the new mount to share the soc=
ket
> > already on port 5000, you need to specify port=3D5000 in the mount
> > options. The code doesn't do this today, but I think it probably ou=
ght
> > to conform to the above description, or more accurately, with the
> > manpage update that Pavel proposed.
> >
> > Now, to be pedantic...the code that Pavel proposed still isn't 100%
> > compliant with the description.
>=20
> But I think that the more important question is what the use case is =
-
> ie which is easier and more natural for the user.   The man page need=
s
> update either way.
>=20
> Seems like we want to always use the existing connection if possible.
> The man page comment about using the user specified port (if any) the=
n
> port 445 then port 139 is only for "negotiate" - ie when we haven't
> already negotiated a session with the server.
>=20
>=20

The difference is this -- do you want lack of a port=3D option to mean =
"I
don't care what port I use, so autonegotiate if I don't have one
already", or should it mean "autonegotiate using standard cifs ports"?
The documentation says the latter and I think we ought to try to stick
to the documented behavior as closely as possible.

One problem with saying that lack of a port=3D option means "I don't
care" is that you can end up with entirely different results depending
on what order mounts are done. In your example, depending on the order
that those mounts are done, you'll end up with either one shared
socket, or two. If we go with Pavel's patch, then you'll get the same
result regardless of what order the mounts are done. That seems like a
better outcome to me.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
