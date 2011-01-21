From: Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Thu, 20 Jan 2011 20:20:50 -0500
Message-ID: <20110120202050.0bc68484@corrin.poochiereds.net>
References: <20110121120524.23dcf86d.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uqCs2g1h2CJkLD0mcJt57XJ"; protocol="application/pgp-signature"
Cc: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Suresh Jayaraman <sjayaraman@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110121120524.23dcf86d.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/uqCs2g1h2CJkLD0mcJt57XJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Jan 2011 12:05:24 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
>=20
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> fs/cifs/cifssmb.c: In function 'CIFSSMBEcho':
> fs/cifs/cifssmb.c:740: warning: large integer implicitly truncated to uns=
igned type
>=20
> Introduced by commit 766fdbb57fdb1e53bc34c431103e95383d7f13ba ("cifs: add
> ability to send an echo request").
>=20

Oh duh -- <forehead slap>...

        smb->hdr.WordCount =3D cpu_to_le16(1);

...and WordCount is u8. I'll send Steve a fix tomorrow...

--=20
Jeff Layton <jlayton@redhat.com>

--Sig_/uqCs2g1h2CJkLD0mcJt57XJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk0433YACgkQojH4PzJJfGU1DwCgh4gQcKxKEaR0IJtG1ta1K6T9
G/oAnRmNToo9dyeev285r08Fc3kLEdBm
=qnSQ
-----END PGP SIGNATURE-----

--Sig_/uqCs2g1h2CJkLD0mcJt57XJ--
