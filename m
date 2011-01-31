From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the cifs tree
Date: Mon, 31 Jan 2011 13:27:43 +1100
Message-ID: <20110131132743.4ae5d4ae.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_13_27_43_+1100_5jSu9=kSHEhSFa=Q"
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
	Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Signature=_Mon__31_Jan_2011_13_27_43_+1100_5jSu9=kSHEhSFa=Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/link.c: In function 'symlink_hash':
fs/cifs/link.c:58: warning: 'rc' may be used uninitialized in this function

and, indeed, it may be ...

Introduced by commit ee2c9258501f83d3ed0fd09ce5df1cec53312cf0 ("cifs:
More crypto cleanup (try #2)").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Jan_2011_13_27_43_+1100_5jSu9=kSHEhSFa=Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRh4fAAoJEDMEi1NhKgbsHcwIAICfmwPfH03PhcCRUicjkRgr
waYx4IWMm8XWej4JYXraCyNvKrm0ROoLTwrTWNUnx71lOUKJlLquRBTJsPeQRG01
JZFOKEZ+Yl4pB9MoKDjks/COEwusJO1rd2p73J1XUgmoxKbNzvK8OigTLvr9vaEJ
SHJUqfcSpob139u1FC2k4137lMVG0qTJ1yFu8X5CdAUt8ua20CydEUWVlJLCKReD
kqWFLVyjWJSE6jEMYM9iTtC0X5OMNkqpo+RE8gUwUGMar78RTEIU0r559obxBk5b
ysE0ajP/27oVAlCscW8ZgNQ1BtsggTHKO+nL5GnpjaAJgPkbE/Iby8pT36YXfrA=
=pDZX
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_13_27_43_+1100_5jSu9=kSHEhSFa=Q--
