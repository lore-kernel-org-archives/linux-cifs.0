From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the cifs tree with Linus' tree
Date: Thu, 14 Jun 2018 09:01:35 +1000
Message-ID: <20180614090135.1d71babb@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mcQV8Nlb9b44/qk3AS7rt9G"; protocol="application/pgp-signature"
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Aurelien Aptel <aaptel@suse.com>
To: Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--Sig_/mcQV8Nlb9b44/qk3AS7rt9G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the cifs tree got a conflict in:

  fs/cifs/transport.c

between commit:

  6da2ec56059c ("treewide: kmalloc() -> kmalloc_array()")

from Linus' tree and commit:

  1560d69e21c6 ("cifs: push rfc1002 generation down the stack")

from the cifs tree.

I fixed it up (the latter removed the code modified by the former) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/mcQV8Nlb9b44/qk3AS7rt9G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlshok8ACgkQAVBC80lX
0GyVVwf/Zu5962r/VKaPnoz1YP+fVgX/pX0ZxnhRduSQzlM02aIo+/TNGPKxy/DJ
s3J3d543a24CIlUaJnbh77m4U1wRLQNWrv0E0ccOx5y1ZHV7s+lR5zighduAbWCH
OThIkScNDKzFOAT0iGi0KS1sl6DVQ5PrS6ToICIODGIx2zBBI4zPcewnSn95PsjH
+QXPebqSFdZthuK9jm9SJ6AHTS3tCif9t+GT5oDvCHft+2USjJM0AwJs+z5PmmTc
4b6inPZ/3sCBoMU3Wc+sTRL0hSZWxpAlLmqRqOfI/jsPn+/PZACwHgu4zPij4a7U
GCuNwTQjSmSlOjo9/zP4mFG0lQHxbg==
=TNAm
-----END PGP SIGNATURE-----

--Sig_/mcQV8Nlb9b44/qk3AS7rt9G--
