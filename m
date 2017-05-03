From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] CIFS: fix mapping of SFM_SPACE and SFM_PERIOD
Date: Thu, 4 May 2017 00:06:32 +0200
Message-ID: <20170503220632.GA20285@SerNet.DE>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--GID0FwUMdk1T2AWN
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

please review and apply to current and long-term kernels like 4.9, please.

Bj=F6rn

--xHFwDpU9dbj6ez1V
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-CIFS-fix-mapping-of-SFM_SPACE-and-SFM_PERIOD.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 0bf80f62d2e7e8cc16dbed7d9e6b9ac2fe40df41 Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Bj=3DC3=3DB6rn=3D20Jacke?=3D <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Wed, 3 May 2017 23:47:44 +0200
Subject: [PATCH] CIFS: fix mapping of SFM_SPACE and SFM_PERIOD

- trailing space maps to 0xF028
- trailing period maps to 0xF029

Signed-off-by: Bjoern Jacke <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifs_unicode.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 3d7298c..7bfb76e 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -64,8 +64,8 @@
 #define SFM_LESSTHAN    ((__u16) 0xF023)
 #define SFM_PIPE        ((__u16) 0xF027)
 #define SFM_SLASH       ((__u16) 0xF026)
-#define SFM_PERIOD	((__u16) 0xF028)
-#define SFM_SPACE	((__u16) 0xF029)
+#define SFM_SPACE	((__u16) 0xF028)
+#define SFM_PERIOD	((__u16) 0xF029)
=20
 /*
  * Mapping mechanism to use when one of the seven reserved characters is
--=20
2.7.4


--xHFwDpU9dbj6ez1V--

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEAREIAAYFAlkKVGgACgkQdoo0s+hIejlzZwCgmr5rOQI+5/o65ekAP10a7UKf
bRAAn1kuzUZA6bUnNqbro+g47VvHKMOi
=VU8t
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
