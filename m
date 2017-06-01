From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] CIFS: add SFM mapping for 0x01-0x1F
Date: Thu, 1 Jun 2017 11:00:06 +0200
Message-ID: <20170601090006.GA21508@SerNet.DE>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--Pd0ReVV5GZGQvF3a
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

attached patch adds more missing mappings for the 0x01-0x1f range. Please
review, if you're fine with it, considere it also for stable.

Bj=F6rn

--6c2NcOVqGQ03X4Wi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-cifs-add-SFM-mapping-for-0x1-0x20.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a97720c26db2ee77d4e798e3d383fcb6a348bd29 Mon Sep 17 00:00:00 2001
=46rom: =3D?UTF-8?q?Bj=3DC3=3DB6rn=3D20Jacke?=3D <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date: Wed, 31 May 2017 22:48:41 +0200
Subject: [PATCH] cifs: add SFM mapping for 0x01-0x1F

0x1-0x1F has to be mapped to 0xF001-0xF01F

Signed-off-by: Bjoern Jacke <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifs_unicode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index a0b3e7d..e0445e2 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -79,6 +79,10 @@ convert_sfu_char(const __u16 src_char, char *target)
 static bool
 convert_sfm_char(const __u16 src_char, char *target)
 {
+	if (src_char >=3D 0xF001 && src_char <=3D 0xF01F) {
+		*target =3D src_char - 0xF000;
+		return true;
+	}
 	switch (src_char) {
 	case SFM_COLON:
 		*target =3D ':';
@@ -417,6 +421,10 @@ static __le16 convert_to_sfm_char(char src_char, bool =
end_of_string)
 {
 	__le16 dest_char;
=20
+	if (src_char >=3D 0x01 && src_char <=3D 0x1F) {
+		dest_char =3D cpu_to_le16(src_char + 0xF000);
+		return dest_char;
+	}
 	switch (src_char) {
 	case ':':
 		dest_char =3D cpu_to_le16(SFM_COLON);
--=20
2.7.4


--6c2NcOVqGQ03X4Wi--

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEAREIAAYFAlkv15YACgkQdoo0s+hIejnqhgCeKUqClws9DJmOHfcrTvAG5DFt
rqAAn1kToX6XNQdJdlPg432QQQVYYF9V
=Of3n
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
