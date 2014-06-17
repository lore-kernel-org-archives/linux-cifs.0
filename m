From: "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] fs/cifs: fix regression in cifs_create_mf_symlink()
Date: Tue, 17 Jun 2014 10:56:40 +0200
Message-ID: <53A002C8.8090702@samba.org>
References: <1402394606-7910-1-git-send-email-bb@sernet.de> <539EF5FD.5000307@samba.org> <CAH2r5mt+r3ab_gxZAYhF=buL3s3rz=dx9yEUyFh20mM9Yg08Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sM8e7f2riKAL7gnJFAxq1pJEk5fAGUX76"
Cc: =?UTF-8?B?QmrDtnJuIEJhdW1iYWNo?= <bb@sernet.de>,
	Steve French <sfrench@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	Pavel Shilovsky <piastryyy@gmail.com>
To: Steve French <smfrench@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mt+r3ab_gxZAYhF=buL3s3rz=dx9yEUyFh20mM9Yg08Ag@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sM8e7f2riKAL7gnJFAxq1pJEk5fAGUX76
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Steve,

> Although I have merged this into cifs-2.6.git for-next, in my testing
> I am also seeing this fail with vers=3D3.0 (and probably 2.0 and 2.1) s=
o
> I would like to fix that too (and mfsymlinks may be at least as
> important there)

Thanks! When can we expect this to be proposed for 3.16 (and stable
3.14/3.15)?

metze


--sM8e7f2riKAL7gnJFAxq1pJEk5fAGUX76
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOgAssACgkQm70gjA5TCD++uQCdE1x35nZppVuyjjgo69ZVZ2jU
rKEAoJ1Q2V5++AQv+G4fTbEotRqpK6wt
=iAqo
-----END PGP SIGNATURE-----

--sM8e7f2riKAL7gnJFAxq1pJEk5fAGUX76--
