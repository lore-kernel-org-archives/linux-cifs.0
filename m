From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: Signed-off-by missing for commit in the cifs tree
Date: Wed, 1 Aug 2018 20:58:53 +1000
Message-ID: <20180801205853.625673fd@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/JpVYd+rAL6qq=jwAXf74lML"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/JpVYd+rAL6qq=jwAXf74lML
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  e0afb3ebfcf5 ("cifs: add compound_send_recv()")
  1bc941970813 ("cifs: make smb_send_rqst take an array of requests")
  095fe7367830 ("cifs: update init_sg, crypt_message to take an array of rq=
st")

are missing a Signed-off-by from their committers.

--=20
Cheers,
Stephen Rothwell

--Sig_/JpVYd+rAL6qq=jwAXf74lML
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlthkm0ACgkQAVBC80lX
0GweXAf/e2WI3wLhm+WzW9E5aWtL6y0s23Mc/d5OHd+OJbF+UhaoGpZWU7OXrcAZ
yy4hn/+qu+Nh8Q0woY0IJNHMqAGCJ7Wxsx8j2s+G/2GmSqUELhR/8OSkVcG/l+Rd
wZF/8aXnXI7RlX9PLHpPSxtQYJ7qKIY62NStuo/NCmOFwsTdY4lDd4gwege/ZKAU
jMmPQIs0Do/p9vXTWYe7/0NvFty3ZDzDwaNIgUDKPQQCNv35o5vDpbEDyz/I8pjj
z/V08tuR3oma9wyAsE0aeQgqPR3GR4qDh2dX1r1Q9V9HL4Z7BbRsSd1Zo39uYePV
dEZR6/ey17LBMyqxwmuJi+yN0QJuCA==
=8cdZ
-----END PGP SIGNATURE-----

--Sig_/JpVYd+rAL6qq=jwAXf74lML--
