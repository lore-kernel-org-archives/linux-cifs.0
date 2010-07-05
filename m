From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Severe performance issue (Ubuntu 10.04 mounting an XP share)
Date: Mon, 5 Jul 2010 09:04:25 -0400
Message-ID: <20100705090425.05c3f568@corrin.poochiereds.net>
References: <AANLkTilXnPMMoY-54RbO4CUeqP9b-zaM7NZQZQpHH5Gk@mail.gmail.com>
	<20100702141617.46ec65a6@corrin.poochiereds.net>
	<AANLkTim4xY4n2y-jE0FzCAKc6NWK6DZcHx15d2owR-wV@mail.gmail.com>
	<AANLkTimdE4q2q3w0DccJUv_steLH-0kIhgK7_jv6-IMi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimdE4q2q3w0DccJUv_steLH-0kIhgK7_jv6-IMi-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 5 Jul 2010 10:14:29 +0100
James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Sorry I meant this to go to the list rather than solely to Jeff perso=
nally.
>=20
> On 2 July 2010 19:16, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, 2 Jul 2010 16:39:06 +0100
> > James Green <james.mk.green-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Jul =A02 16:14:58 ubuntu kernel: [ 1378.833956] CIFS VFS: No respo=
nse
> >> for cmd 50 mid 11112
> >
> > The client is sending a SMB_COM_TRANSACTION2 and isn't getting a
> > response. You might want to sniff traffic and identify calls that
> > aren't getting responses. If there is some commonality between them
> > then that may point to where the problem is.
>=20
> Jeff,
>=20
> I fear I'm looking for a needle in a haystack, and I've no idea what
> the needle looks like.
>=20
> I ran Wireshark on my XP host and repeatedly ran the phpunit tests ob=
serving:
>=20
> 1. There really is an awful lot of FIND_FIRST2, Pattern: <blah>,
> followed immediately by FIND_FIRST2, Files: <blank>. I assume this to
> be normal.
>=20
> 2. Occassionally and on a random Pattern argumen, a FIND_FIRST2 or
> QUERY_PATH_INFO is followed immediately not by an SMB level response
> but by a TCP "microsoft-ds" ACK. The Len is 0 and all other arguments
> have values.

Can't be certain without seeing the capture, but it sounds like a
"normal" TCP ACK. That means that the server has acknowledged that it
received the packet.

> At this point there may be several seconds of delay
> before SMB re-establishes with a Session Set AndX Request, User:
> \jgreen then a Tree Connect AndX Request for the mount point being
> used.
>=20
> It feels as though the XP host itself is simply not returning a
> response some of the time. Other than changing my password and
> rebooting the whole lot I can't think of anything I might have done.
>=20
> If you have any further tests you'd like me to perform I'll try to
> oblige as this is killing my workflow.
>=20

Yep, sounds like the server just isn't responding here. When that
happens, cifs currently forces a reconnect after the call times out.
Ugly and I believe unnecessary...when the server ACKs the response we
shouldn't force a reconnect just because the server is taking a while
to respond. Right now though we don't change the mid state to show that
the call was successfully sent, so that probably ought to be fixed so
we can deal with that differently.

It's possible that by making the client wait indefinitely, the server
will eventually respond. It's also possible however that the server is
just dropping these calls on the floor for some reason and will never
respond. Hard to say which it is.

Shirish was working recently on fixing the "hard" mount option for
cifs. It might be worth trying out his patches.

Shirish, any thoughts?
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
