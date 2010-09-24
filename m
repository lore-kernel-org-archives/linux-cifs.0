From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build warning after merge of the cifs tree
Date: Fri, 24 Sep 2010 13:55:31 +1000
Message-ID: <20100924135531.96e5ac72.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Sep_2010_13_55_31_+1000_d3jqRQNbsDsMnVps"
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Signature=_Fri__24_Sep_2010_13_55_31_+1000_d3jqRQNbsDsMnVps
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the irqflags tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/sess.c: In function 'CIFS_SessSetup':
fs/cifs/sess.c:595: warning: unused variable 'blob_len'

Introduced by commit 15f6bdfb9914b0c41848f874719911ba053be931 ("cifs
NTLMv2/NTLMSSP ntlmv2 within ntlmssp autentication code").
CONFIG_CIFS_UPCALL is not set in this build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Sep_2010_13_55_31_+1000_d3jqRQNbsDsMnVps
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnCEzAAoJEDMEi1NhKgbswIUH/32Piz4jPU/U+02C1zsmr1+Y
qxR6qLiPlgs60MbbwpCoIASsDR+1rcby7n1dyVTphpHRIjAWwx6LsGvKLrITZ4Wy
4vP4aPvL2fBxEtZPUZlkivyNgUdAU7+fzYa4pEQyIoraVmX6Xq7GvvwCQYsRJF7j
ZYcu1Zar5DoR5IPkOG5uDbEGDa+dTFooAMisgYK9owybFIpye7QZmC12531Pm4Vu
qmu8jzDa8FwTs4U9CQobdXveImJR1gRuCuypEQRiqOx/zvqmlAPbgJJvLpGUqrdU
dgytTQssDyCJMfzLeYZmYcymnkkg2rqZ+DkQlZovpEwF483pzjz1SvA+uzBqWdI=
=9jLj
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Sep_2010_13_55_31_+1000_d3jqRQNbsDsMnVps--
