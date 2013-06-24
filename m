From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: error fetching the cifs tree
Date: Tue, 25 Jun 2013 09:51:14 +1000
Message-ID: <20130625095114.78375db24240f27af94a086f@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Jun_2013_09_51_14_+1000_J1vFalXaNJ6Yi8zI"
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Signature=_Tue__25_Jun_2013_09_51_14_+1000_J1vFalXaNJ6Yi8zI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Attempting to fetch the cifs tree
(git://git.samba.org/sfrench/cifs-2.6.git#for-next) produces this error:

fatal: Couldn't find remote ref refs/heads/for-next

I am using whatever I have previously fetched.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Jun_2013_09_51_14_+1000_J1vFalXaNJ6Yi8zI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyNtyAAoJEECxmPOUX5FEcwsP/Ak0DGydHW+PtCi5bavlqhtz
xpbXoYDW60l9vIvCE3I8owmOlmGrVd1m0e0Wp7hi9ooaHoQoYEPSCAOE44m5C0wV
Shh8L1iegdZmeYG+F+n/5AEW5wJUOvBcttFMryggnhVWRbc/o5ZW3+vTYmgu9iA2
hAE+pYMzCcRRIvVXYJxyjEYzCdcJlfJwjIMTmvtfbEdbeXc/ynXEi8M/3qMraDUg
QlUn2gZ7mLeecrDYi3N506hBCLV68P45UFSH1txX6FETahZGZhPvRUxMcAvWISeP
bY13JUUSWI+DTr9nbJAdyFY8JPuUfXxC/yPBljXVMXD6hi6LcRLOsVhKOcess9Ky
u40dqurCw4oOKmwimfV3PQtUdTN5UlB5CayKeFwHItFPxDRPCUuth8uz8H2vPAyr
7jfkWAHEVzK4DVc6sXCmKXGjh/hHUXz/gZ94zsHcn/jAzFSHVbpj8g5Pyfq1saDH
OkPL1Wfi7PSleickia0rO0rSs2QOazIKANJPk+ssk4uNpIJWytMOtL7wzeP+ZTw4
DYLce4C4ANOgFkxqzsNEqvpLUJ3TkpyrYYx3p+hBKDkJJMIwcwy5uc26IeTM5hni
6Pnq/6boUhAVUa/ec9RHLH2NYb4ccLKCpJKqh+LrpBfIlMG07e/uMNrD51ywjzY8
E+/FgOuh+cMJwie9EX2Y
=YGT8
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Jun_2013_09_51_14_+1000_J1vFalXaNJ6Yi8zI--
