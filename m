From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/8] Add some UTF-16 functions for convenience
Date: Wed, 16 May 2012 01:01:34 +0200
Message-ID: <4FB2E04E.6000702@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig3C529468453CE1A58EEAF38E"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	OGAWA Hirofumi <hirofumi-UIVanBePwB70ZhReMnHkpc8NsWr+9BEh@public.gmane.org>,
	Dave Kleikamp <shaggy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Petr Vandrovec <petr-vPk2MGR0e28uaRcfnNAh7A@public.gmane.org>,
	Anton Altaparmakov <anton-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-ntfs-dev-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3C529468453CE1A58EEAF38E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



Signed-off-by: Vladimir Serbinenko <phcoder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/nls/nls_base.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
 fs/nls/nls_utf8.c   |    2 +-
 include/linux/nls.h |    6 +++++
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 4f6d1ae..0c1ad5b 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -171,6 +171,32 @@ int utf8s_to_utf16s(const u8 *s, int inlen, enum utf=
16_endian endian,
 }
 EXPORT_SYMBOL(utf8s_to_utf16s);
=20
+int unicode_to_utf16s(unicode_t u, enum utf16_endian endian,
+		      wchar_t *pwcs, int maxout)
+{
+	u16 *op =3D pwcs;
+
+	op =3D pwcs;
+
+	if (u >=3D PLANE_SIZE) {
+		if (maxout < 2)
+			return -1;
+		u -=3D PLANE_SIZE;
+		put_utf16(op++, SURROGATE_PAIR |
+			  ((u >> 10) & SURROGATE_BITS),
+			  endian);
+		put_utf16(op++, SURROGATE_PAIR |
+			  SURROGATE_LOW |
+			  (u & SURROGATE_BITS),
+			  endian);
+		return 2;
+	} else {
+		put_utf16(op++, u, endian);
+		return 1;
+	}
+}
+EXPORT_SYMBOL(unicode_to_utf16s);
+
 static inline unsigned long get_utf16(unsigned c, enum utf16_endian endi=
an)
 {
 	switch (endian) {
@@ -232,6 +258,43 @@ int utf16s_to_utf8s(const wchar_t *pwcs, int inlen, =
enum utf16_endian endian,
 }
 EXPORT_SYMBOL(utf16s_to_utf8s);
=20
+int utf16s_to_unicode(const wchar_t *pwcs, int inlen, enum utf16_endian =
endian,
+		      unicode_t *uni)
+{
+	unsigned long u, v;
+	const wchar_t *pwcs0 =3D pwcs;
+
+	while (inlen > 0) {
+		u =3D get_utf16(*pwcs, endian);
+		if (!u)
+			break;
+		pwcs++;
+		inlen--;
+		if ((u & SURROGATE_MASK) =3D=3D SURROGATE_PAIR) {
+			if (u & SURROGATE_LOW) {
+				/* Ignore character and move on */
+				continue;
+			}
+			if (inlen <=3D 0)
+				break;
+			v =3D get_utf16(*pwcs, endian);
+			if ((v & SURROGATE_MASK) !=3D SURROGATE_PAIR ||
+			    !(v & SURROGATE_LOW)) {
+				/* Ignore character and move on */
+				continue;
+			}
+			u =3D PLANE_SIZE + ((u & SURROGATE_BITS) << 10)
+				+ (v & SURROGATE_BITS);
+			pwcs++;
+			inlen--;
+		}
+		*uni =3D u;
+		return pwcs - pwcs0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(utf16s_to_unicode);
+
 int register_nls(struct nls_table * nls)
 {
 	struct nls_table ** tmp =3D &tables;
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index eb6392e..a3b3de0 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -37,7 +37,7 @@ static int char2uni(const unsigned char *rawstring, int=
 boundlen,
 		*uni =3D 0x003f;	/* ? */
 		return -EINVAL;
 	}
-	*uni =3D (wchar_t) u;
+	*uni =3D u;
 	return n;
 }
=20
diff --git a/include/linux/nls.h b/include/linux/nls.h
index c0292dd..7de1765 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -50,12 +50,18 @@ extern struct nls_table *load_nls(char *);
 extern void unload_nls(struct nls_table *);
 extern struct nls_table *load_nls_default(void);
=20
+#define MAX_UTF16_PER_UNICODE 2
+
 extern int utf8_to_utf32(const u8 *s, int len, unicode_t *pu);
 extern int utf32_to_utf8(unicode_t u, u8 *s, int maxlen);
 extern int utf8s_to_utf16s(const u8 *s, int len,
 		enum utf16_endian endian, wchar_t *pwcs, int maxlen);
 extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
 		enum utf16_endian endian, u8 *s, int maxlen);
+int unicode_to_utf16s(unicode_t u, enum utf16_endian endian,
+		      wchar_t *pwcs, int maxout);
+int utf16s_to_unicode(const wchar_t *pwcs, int inlen, enum utf16_endian =
endian,
+		      unicode_t *uni);
=20
 static inline unsigned char nls_tolower(struct nls_table *t, unsigned ch=
ar c)
 {
--=20
1.7.10


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko






--------------enig3C529468453CE1A58EEAF38E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y4E8ACgkQNak7dOguQgkYCwEApe22ee6F2h2zx4sPLVt35b8A
CFAi4ZDOgu4R9f0M4uUA/0NT65bZwEJql0YBuYnU876X6VZDTPzo5Wbtag5Ck0u4
=cRtk
-----END PGP SIGNATURE-----

--------------enig3C529468453CE1A58EEAF38E--
