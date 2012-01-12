From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] cifs: integer overflow in parse_dacl()
Date: Thu, 12 Jan 2012 10:06:17 +0300
Message-ID: <20120112070617.GQ3644@mwanda>
References: <20120111074627.GA4519@elgon.mountain>
 <CADT32eLVwQT9V67BX8TkjVHDnQoYS7OqA_-xbnjY57ZXO3EfsA@mail.gmail.com>
 <CAH2r5muDQUL=0HcoFHH3QvP7C2pyy0=S9ESFBcm=qOYg3ESdxQ@mail.gmail.com>
 <20120111132053.467e8cae@tlielax.poochiereds.net>
 <CAH2r5msciOkxvxTrQrN9mKKCiJvM_anmxU7sag_TGk92LoKEwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vIXBmblrD40XNCy4"
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msciOkxvxTrQrN9mKKCiJvM_anmxU7sag_TGk92LoKEwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--vIXBmblrD40XNCy4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 11, 2012 at 12:31:34PM -0600, Steve French wrote:
> We could calculate max_aces based on a minimum sized ace and maximum
> smb frame size (which would be 64K presumably for Windows for
> non-Writes, but larger for Samba), but not sure if it is worth the
> trouble unless you find a path where we would parse beyond end of
> frame,

This was a static checker test and I haven't tried to exploit it.
You guys are more familiar with the code obviously and you've lost
me with the talk about max_aces.  I don't see that anywhere in the
code...

$ grep max_aces fs/cifs/ -iR | wc -l
0

regards,
dan carpenter



--vIXBmblrD40XNCy4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPDoZpAAoJEOnZkXI/YHqRgzkP/RIJUmVsDXkf0/GCatUcLkyf
Woxy/dUjZXi95iB3VsrN8CuyLlNAkMnDT2yVEL8pxT1txcA+RFyLW2YmGfbCRcD0
XwVSkhYFZdruTkY1CoxFQ62aMtJWZ0CJXSRj7ylKsofgo5L77hkj1/NqvJ5sJ+DK
ZUOoFIncQoUDI3ggiZzPL5h9fd3XLEqPoPejxOFFZRd3HmX3+uIoaGjbloL4ToMq
m+ChPd6SbMoyzGyMOWsFVMv3UYxTPBQ3dM38SHsdZfU9svCZlLEZDkkUBM0TjdmJ
ILLc6dyUu7DYWGZTIKqqc4/R4knABpwrPgTxJdTgbOnfDeiTW7jOAzWmGiIwCge7
ICqC8jyYVgWN96nNM0sg3Sn8I3Ye5L5MT/BlSx+ysz4PjTiAaVN8TdkMwX+s2YDE
000n5NSWTej9FfobNWGEt34BzOzt1Wo/aAcJpwa16rSRwwgkuNlBMRBih3VtxDdy
pNaRAGQfrWtkBB7UJTOqVO1Eqe0oGVN6Gyq8RI2UnIPFEO2tSyOGE3jRQhEZGiSo
/c4pvqxRuXT+kQBHk1E1Huw6fmWpUwT2C1YhljOrPf7WJLbF3IEXD/7UqHkA+MYe
mq1zbAa+IFgrhyCwMd0dSUDFE9qdHtDZyobnrF30srzT9d8Je3RVRxuiCm8aluBh
lExRrYpHH+wo0ytNGk9F
=7YLy
-----END PGP SIGNATURE-----

--vIXBmblrD40XNCy4--
