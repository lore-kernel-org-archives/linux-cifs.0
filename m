From: Alex Xu <alex_y_xu-FFYn/CNdgSA@public.gmane.org>
Subject: Mounting CIFS with root not accessible - permission denied
Date: Thu, 13 Dec 2012 17:23:29 -0500
Message-ID: <50CA5561.8090405@yahoo.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4065C532F37C268D47EB797A"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4065C532F37C268D47EB797A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Basic explanation: Mounting a SMB share with CIFS fails saying in the
kernel log that it can't traverse up to the root directory if the root
directory is not accessible (in my case with NTFS ACLs), even if
prefixpath is used.

Read a few earlier threads on this that said this was fixed, but it
seems to still be a problem for me on 3.7.0-rc8+.


--------------enig4065C532F37C268D47EB797A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQylVmAAoJEJJZfKWYZ3eUxL4QALHaGjEedXMaH7uYPfmR/URc
Gj3xotCXqbA1D2z2Xbbklj8TL7UhTukdvyHaDKW4pDcO1ISF9rwUPWPj/xU9UjaL
RVQXuVzmcyv6wK0EoEK0xCWksVeLcDrR5MaMZG0BwALa4Mwj0pLdGCZixmAGiNtB
Fb8MD8vGKlrJ81gjzk2WSYiXIlGGRQTLO4yGizPQp9VJhYiCHj2ZRgizwye5XAVA
2R8QdTZJ5m27w7B/Hn0k46fSySXcIoaQbGpKSYDydMg4h+vWwZvvNhwWfjXhAzVv
X1WRH9/DSqgrBLMuIlCBnzIo6yvvB/sYkbe++IPK67r4tF3mvY7YN4jHkHT/QF71
gEuNT5XSuayZjPUiFX83kYfkVDnDnz+sRbSFJrwZRwXih+q1McqD0AYeDpOfOOr5
6LL6CuCksm6tGTw579McN/+5ngf0cf1r4wZBBiGCBR1k2cgg3aLo/KgeOO3fEV7L
Ar0Z1ZDBCxxIEDiPNmerOT4FqONk2A9LJnnEVvCvFYIUq4cxh0MrQdiL9Iox+uaw
lxHsFDEPRLUyKE9IqsI/bkshz5wemEah/eSigkrGt994nkB9KSNfr67fLASbJZ+i
xYn4sxA53iHi8m1pZn6ZNcZpzfNRFPNtdKfpgk1Hm5IcITvtst2gKQhBfXLZqQxu
9eSLwPTgwkxYowWjhHvA
=dORO
-----END PGP SIGNATURE-----

--------------enig4065C532F37C268D47EB797A--
