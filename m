From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build warning after merge of the cifs tree
Date: Fri, 24 Sep 2010 13:48:41 +1000
Message-ID: <20100924134841.161d18d3.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Sep_2010_13_48_41_+1000_NI0zFPy8anBZZZZo"
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Signature=_Fri__24_Sep_2010_13_48_41_+1000_NI0zFPy8anBZZZZo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/dir.c: In function 'cifs_new_fileinfo':
fs/cifs/dir.c:140: warning: unused variable 'cifs_sb'

Introduced by commit 9a6124e7e18fa30d8693055e6a4526afb4c3fabc ("cifs:
have cifs_new_fileinfo take a tcon arg").

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Sep_2010_13_48_41_+1000_NI0zFPy8anBZZZZo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnB+ZAAoJEDMEi1NhKgbszJoH/1R1TKoqSM+bGlQm4lsmtyuj
G3oI09Npk03pXldQdrVJ0QwH0iKoiSPI98YEPV/sH4qIwJSzwHRjmeFmFcw+Wtwf
RBdab/JEoqy+KQA6pOBSD/Be3SrZdE7R495BvmAORJQJCbY/zLyEF0921yvMKpVi
B908Cz0lFeT+lzFy4QQcM9nRuBC0IppWvYqffi1lRxkbCVLFr0G1efx5YPR/wuD7
g3OyziH1DUnCU/Dw12WjqiPe46uGH6B7tNI58jnu4cV1sFfIiekxdU0qxfr+6uaK
SFbij9Go/ReXorx/5DhfnoI1dcAdzH8r269MGAzDo5J2rDhAfmkVK+RefwrICO8=
=Wu6R
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Sep_2010_13_48_41_+1000_NI0zFPy8anBZZZZo--
