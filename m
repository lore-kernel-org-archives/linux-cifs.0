From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Establishing connections in the presence of multi-connect ...
 should we be searching top down not bottom up?
Date: Mon, 20 Aug 2012 12:15:25 -0700
Message-ID: <CACyXjPy4DoZCaZ1GL89BBVkqAcNdgch10-XZh6sq36s+NNUgug@mail.gmail.com>
References: <CACyXjPyWm9SjiuF=nh1UwwsCNPwp_5sXiiVzvUDLnyeVEA-zcQ@mail.gmail.com>
	<20120820070325.1dbc72d3@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120820070325.1dbc72d3-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 20, 2012 at 4:03 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sun, 19 Aug 2012 12:10:02 -0700
>
> Currently, we have a pretty clear hierarchy of objects:
>
>     server->session->tcon
>
> There is no global list of tcons, so you'll need to walk 3 different
> nested sets of lists in order to reverse the search order.
>
> The way I had envisioned implementing this was to add a new
> "connection" object that would hang off the "server" struct (probably
> on a list) and move most of the socket-specific fields into that. Tha=
t
> way a "server" could have multiple "connections".

OK, now I see what you meant before. Currently, the TCP_Server_Info
has connection info embedded in it, and this will have to be broken
out. Since I will need a separate connection structure anyway for
RDMA, I will have to do that anyway, I think.

> An RDMA connection would be slightly different than a socket connecti=
on
> -- either different struct altogether or maybe a unioned with a TCP
> connection. It would get its own set of callbacks and could be
> connected and torn down as necessary.

Yes, I agree.

> Matching a "server" at that point becomes a bit more complex, probabl=
y
> a matter of ensuring that all the connection objects are valid for th=
e
> mount.
>
> Attempting to match the tcon first is probably a reasonable shortcut =
at
> least in some cases however.

I will also give some thought to the bisectability issue.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
