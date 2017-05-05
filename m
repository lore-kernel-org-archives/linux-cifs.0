From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] CIFS: add misssing SFM mapping for doublequote
Date: Fri, 5 May 2017 05:00:35 +0200
Message-ID: <20170505030035.GA30330@SerNet.DE>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--gatW/ieO32f1wygP
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

please review and apply to current and long-term kernels like 4.9, please.

Bj=F6rn

--LZvS9be/3tNcYl/X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-CIFS-add-misssing-SFM-mapping-for-doublequote.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 7a72fdf400c039218526ac4241efb2db984e1a13 Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Bj=3DC3=3DB6rn=3D20Jacke?=3D <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Date: Fri, 5 May 2017 04:36:16 +0200
Subject: [PATCH] CIFS: add misssing SFM mapping for doublequote

SFM is mapping doublequote to 0xF020

Signed-off-by: Bjoern Jacke <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifs_unicode.c | 6 ++++++
 fs/cifs/cifs_unicode.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 02b071bf..a0b3e7d 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -83,6 +83,9 @@ convert_sfm_char(const __u16 src_char, char *target)
 	case SFM_COLON:
 		*target =3D ':';
 		break;
+	case SFM_DOUBLEQUOTE:
+		*target =3D '"';
+		break;
 	case SFM_ASTERISK:
 		*target =3D '*';
 		break;
@@ -418,6 +421,9 @@ static __le16 convert_to_sfm_char(char src_char, bool e=
nd_of_string)
 	case ':':
 		dest_char =3D cpu_to_le16(SFM_COLON);
 		break;
+	case '"':
+		dest_char =3D cpu_to_le16(SFM_DOUBLEQUOTE);
+		break;
 	case '*':
 		dest_char =3D cpu_to_le16(SFM_ASTERISK);
 		break;
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index 7bfb76e..8a79a34 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -57,6 +57,7 @@
  * not conflict (although almost does) with the mapping above.
  */
=20
+#define SFM_DOUBLEQUOTE ((__u16) 0xF020)
 #define SFM_ASTERISK    ((__u16) 0xF021)
 #define SFM_QUESTION    ((__u16) 0xF025)
 #define SFM_COLON       ((__u16) 0xF022)
--=20
2.7.4


--LZvS9be/3tNcYl/X--

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEAREIAAYFAlkL6tMACgkQdoo0s+hIejn/TwCeNJhSgQQ90fXPzDP5GjbvFl3Q
9YcAnRw2FHHtexMJ8KsCda9P6dWh0Dg0
=RenL
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
