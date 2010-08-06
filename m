From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [Stable-review] [26/34] CIFS: Fix compile error with __init in
 cifs_init_dns_resolver() definition
Date: Fri, 06 Aug 2010 21:53:17 +0100
Message-ID: <1281127997.7543.0.camel@localhost>
References: <20100806185836.185076461@clark.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HdqI9Ra+QyVbtxm/pOoR"
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, stable-review-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
To: Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100806185836.185076461-TaY/TdSKy6PN0uC3ymp8PA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-HdqI9Ra+QyVbtxm/pOoR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-08-06 at 11:57 -0700, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>  [stable] [PATCH 2.6.32/stable] CIFS: Fix compile error with __init in ci=
fs_init_dns_resolver() definition
>=20
> From: Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
>=20
> An allmodconfig compile on ppc64 with 2.6.32.17 currently gives this erro=
r
>=20
> fs/cifs/dns_resolve.h:27: error: expected '=3D', ',', ';', 'asm' or '__at=
tribute__' before 'cifs_init_dns_resolver'
>=20
> This adds the correct header file to fix this.
[...]

Why <linux/module.h> and not <linux/init.h>?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-HdqI9Ra+QyVbtxm/pOoR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATFx2N+e/yOyVhhEJAQJgORAAkD0UIKGbPHr8hi/UxxfwIo7SmM3Wkd7V
EyfGVZkQUu7YYm5XRyaCoZtqwv2sXE1OeZfw5PZwGQSimOMeo68y5q6PlaKg0yKy
V8Ofh0GYsoA2j7pSZGr36ek6Zhj5l0a91nNMpinejVNImE1EyOj7vzQMA6D91sSO
MyZTgch0n9K0kT1EPYpZ9k9xOfCEicTVle/PlgQ7KPpLYkG5Nhz2RnJOHzyI9QJ7
EQL/fhtoaoCX9S2vFyAb3IsfgvyvW3mBrC5elFvLG5hl3x/xQYP9ssM4KZq3idGS
JOCoJPzjr4/eXlje1Q4D23jX+n/tt4aVRbmqKFxWT3wepvV9QmeXF5FKWQfACrr8
v4bCaDtImc51jxy90JqbrLEUJLlBf0/QAwAYkcw3Lxq2ONGz6E62lOPG1nioxg9w
AQe/8U6CnPFSDCH/UsV9vCefm40tCXBn6iy6Yzl0eXBSiWn9jVUKQ2NgSaQMknbL
b2LtP6Hsgb+cK7UZ062/4XIbKksItr1T5yAhoa7mkExKwaHX7AkGK2dw5dp6Utm4
FtIwZXW+H3zFbwzn6JC+T+0w4s/66mbib7CoJ+Y1zd0JRicCOFQDV6gDOt7E3ot/
FBxx9ZwAOxXcRGYT4NhVjiydXwUf2gbMfi187/Bey3AgH8OfOptkimw1oGy2dJ4+
2Ox+HsOpvyg=
=AFPT
-----END PGP SIGNATURE-----

--=-HdqI9Ra+QyVbtxm/pOoR--
