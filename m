From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS endless console spammage in 2.6.38.7
Date: Wed, 1 Jun 2011 14:01:39 -0400
Message-ID: <20110601140139.079287da@tlielax.poochiereds.net>
References: <4DE5385C.1030808@candelatech.com>
	<BANLkTik+Z32vDVjB3_Rt7iPrqpJPJYnpwA@mail.gmail.com>
	<4DE54561.1090906@candelatech.com>
	<20110531164408.178eeebf@tlielax.poochiereds.net>
	<BANLkTinyb=tekDwPLqxuSqyQfrgc8MykCw@mail.gmail.com>
	<4DE55537.5040705@candelatech.com>
	<BANLkTimNgW-Ff_50HeuFqmS7PXXjuLmYVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimNgW-Ff_50HeuFqmS7PXXjuLmYVw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 31 May 2011 15:54:36 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> we will have more info when run with he quick and dirty modified logg=
ing
>=20

I'm not sure what that is, but what may be helpful is to launch a
kernel debugger when this happens, track down the TCP_Server_Info and
see what the state of the socket that hangs off of it is. If it's a
NULL pointer or an already-closed socket, then that may help point the
way to the root cause.

> On Tue, May 31, 2011 at 3:53 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>=
 wrote:
> > On 05/31/2011 01:51 PM, Steve French wrote:
> >>
> >> On Tue, May 31, 2011 at 3:44 PM, Jeff Layton<jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =C2=
=A0wrote:
> >
> >>> Fixing it looks to be anything but trivial. I'm not even quite su=
re how
> >>> to approach it at this point. Suggestions welcome.
> >>
> >> I thought the kernel was more recent than that - how recent is the=
 kernel
> >> here?
> >>
> >> I think something related to cifs_sendv returning ENOTSOCK immedia=
tely
> >> when not reconnected could be related.
> >
> > My kernel is 2.6.38.7, quite recent. =C2=A0We're using the bind-to-=
local-IP
> > features too, but not sure that matters.
> >
> > Ben
> >
> > --
> > Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
> > Candela Technologies Inc =C2=A0http://www.candelatech.com
> >
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
