From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: CIFS mount fails if I ctrl-c a long-running find process (Linux
 mounting Windows share)
Date: Sat, 29 Dec 2012 01:24:36 +0100
Message-ID: <1356740676.4446.21.camel@deadeye.wl.decadent.org.uk>
References: <1355872616.69791.YahooMailNeo@web160302.mail.bf1.yahoo.com>
	 <20121219090322.3999f995@tlielax.poochiereds.net>
	 <1355944553.61735.YahooMailNeo@web160303.mail.bf1.yahoo.com>
	 <1355945432.81847.YahooMailNeo@web160302.mail.bf1.yahoo.com>
	 <20121220093806.537c2496@corrin.poochiereds.net>
	 <20121223091034.5e313ee1@tlielax.poochiereds.net>
	 <20121224091421.63d0df23@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-P+90XekA/XpAnfSaWSQm"
Cc: Tim Perry <tim.perry-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	John Darrah <xyllyx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 695492-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121224091421.63d0df23-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-P+90XekA/XpAnfSaWSQm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-12-24 at 09:14 -0500, Jeff Layton wrote:
> On Sun, 23 Dec 2012 09:10:34 -0500
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
[...]
> > I had a look at the code today and suspect that I know what the problem
> > is. When the kernel goes to send a request, it first signs it and then
> > bumps the sequence numbers that it tracks. If the request doesn't
> > actually make it out onto the wire, like when the task catches a
> > signal, those sequence numbers remain high even though the request
> > didn't go out.
> >=20
> > Here's an untested patch that might help tell whether this is the
> > case. You may want to try it and see if it does. Note that this fix is
> > a bit of a kludge and is not suitable for merging!
> >=20
> > A better fix would involve changing when the sequence number gets
> > bumped in the first place. If this patch seems to help things, then
> > I'll look at coding up that up.
[...]
> I was able to reproduce this, and I don't think the above patch will
> fix it (at least not completely). The problem seems to be that the NT
> cancel command is screwing up the sequence numbers. We'll have to do
> some research to figure out why that's occurring.

Jeff, we got a bug report in Debian which seems to be the same problem:
<http://bugs.debian.org/695492>.  Please cc John Darrah and the bug
address as above.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-P+90XekA/XpAnfSaWSQm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUN44ROe/yOyVhhEJAQr/RhAAv+SRQK8sjpBHlnlKbAjXDcW3qOz+WU50
cUYB6JMUKiwqujSS1Q4DgodKtHLQ4oXT+ZhYpF6St7MAioeJq9vvDEaatHI06LlM
HTKajIn0ZenhGwxeu7eY9dowp+CQUx+Ln1d29YWVShpB4Yw1+vvf50TUd+L7QEUx
AklR0HMkwwqIXk9K7JjZTervEEzGQMt0IAq+ooaziCd7hr3Phao3TeHH/dchEzDv
Jv2IpPoVaQHoywXSD0Z/shvZCL3BQopQysiMndpWiYb8Uo4Hef1CXwlg2l3dNWhB
BuiAGqqvvV1NB/+vDDO/D/RscWyhX3/8YyEfxnxAB/XJCWSl5HalyQeLvXzocyLk
VJ11kpbSMMSQslYs3/yhd/pGjaWp1frzu4btuS3zIkYqNMO/74MZ92a8uxNrEVSH
DWU2DWeE8egl4+48B2lQYiXKOb4vyvycEgUJhAI9ogdtCAh9VPDCXP46zgATib7i
LL53Myn9x7MBjiFGDE3onw/AM5kvNdI2h0ATfOwVlcZ/MMjuCBNtx4c0WOmjCMpl
3/28t7Wn6w3TasoxheExEx5s7GJoXK41lnp5CBefqRzAbLP4zZe4gYjYWTVF7SH1
gyhJleBWZ3MHipDcpSDOCSqGJTBhrj1kxknB5gJ/3fSPZQNVPv/36O41t6IQFUja
tuc0rK5te0Y=
=5KC3
-----END PGP SIGNATURE-----

--=-P+90XekA/XpAnfSaWSQm--
