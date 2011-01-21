From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build warning after merge of the cifs tree
Date: Fri, 21 Jan 2011 12:05:24 +1100
Message-ID: <20110121120524.23dcf86d.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Jan_2011_12_05_24_+1100_GjcL2gQO./gwcLLs"
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Signature=_Fri__21_Jan_2011_12_05_24_+1100_GjcL2gQO./gwcLLs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/cifssmb.c: In function 'CIFSSMBEcho':
fs/cifs/cifssmb.c:740: warning: large integer implicitly truncated to unsig=
ned type

Introduced by commit 766fdbb57fdb1e53bc34c431103e95383d7f13ba ("cifs: add
ability to send an echo request").

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Jan_2011_12_05_24_+1100_GjcL2gQO./gwcLLs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNONvUAAoJEDMEi1NhKgbscaMH/3zBhJ22dWbfQms1Yc3o5yLb
cvzKHAcAALzde9zb2MHX1Dtgphzxg/Ud2nHUGmU9sQiOwC4P+RD50YaGu/Dds8uU
0oGO0GFZpHCXIf9QddZ1LsWhStxLSMEWr9pl1+H+6LmTZJ7BXWagPEaxE3k3zXPq
jUbcZ/M60kG21GBMLzpohW2wmFg/xTWBOol1lbEdg2KU4zIIveq6I/Uut3IY1/lX
TOq6BuRiPDi9bkjMIGPME35AtExkYx7IoL5zzmpb2PV988cLLvJlT9/phNyM5qvY
2Bv1zf+8kwAmjcUkxp3OWJLXrTiW171xXfqpj1uBnZrzLPbWkQtgH28ZryT4X3U=
=mcZp
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jan_2011_12_05_24_+1100_GjcL2gQO./gwcLLs--
