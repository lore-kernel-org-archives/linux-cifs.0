From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] cifs: use the server's MaxMpxCount to determine max
 requests in flight
Date: Fri, 6 May 2011 07:41:45 -0400
Message-ID: <20110506074145.053e09a5@tlielax.poochiereds.net>
References: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
	<1304345069-2441-9-git-send-email-jlayton@redhat.com>
	<BANLkTinJHDQup-QwRNrZF19L_VycUCf1Jw@mail.gmail.com>
	<20110504070955.07d9420f@tlielax.poochiereds.net>
	<BANLkTimbNy+v-B2jzYH1hnEjtaKij5n6_Q@mail.gmail.com>
	<BANLkTikdVm7RU71vYvnkPfpGZxsj2fsj=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikdVm7RU71vYvnkPfpGZxsj2fsj=g@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 6 May 2011 11:01:52 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/5/6 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > Two reserved slots: =C2=A0 =C2=A01 for oplock break, 1 for echo.
>=20
> What's if we need to send oplock break for two files in almost the sa=
me time?
>=20
> > Note that if maxmpx is set to 2 on negotiate, we also have to disab=
le
> > oplock (echo + 1 pending open request would max out our maxmpx)
>=20
> What's if maxmpx is set to 1? According to the link (that I posted
> above) it is a possible situation.
>=20
> Note that now we don't count block locking command, but the spec
> doesn't tell anything about it - so, I think we should count them too=
=2E
>=20

Ditto. The blocking lock code is a mess anyway -- that really needs a
fundamental re-think.

> May be we should drop any exceptions, count all types of requests and
> move to smth like priority queue? In this case we can use three kind
> of lists and put echo requests into the highest priority list - e.g.
> "3", oplock break requests - "2", and all other requests into the
> priority "1" list. Or we can use only one double-linked list and put
> all echo and oplock break requests to the head, and all other request=
s
> - to the tail.
>=20
> Thoughts?
>=20

A priority queue doesn't really help here. What if you already have
maxmpx calls in flight and suddenly need to send an oplock break?
You'll just be stuck.

I think all you really need here is a flag for the slot allocator that
tells whether some calls are allowed to dip into the emergency pool,
and keep a couple of slots in reserve for echoes and oplock breaks like
Steve suggests.

In practice, there's probably no reason to have more than one echo in
flight, and we could modify the echo code not to send one when there's
already one that the server hasn't responded to.

If the server sends back a maxmpx value less than 2 we should probably
fail the mount. Less than 3, and we should disable oplocks.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
