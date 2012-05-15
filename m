From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/8] Support full unicode in uni2char and char2uni
Date: Wed, 16 May 2012 00:59:45 +0200
Message-ID: <4FB2DFE1.10605@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigFF0EC4C88EC3E97B8C736F52"
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
--------------enigFF0EC4C88EC3E97B8C736F52
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This patch extends uni2char and char2uni to full unicode but compensates =
this extension in every user by adding a check that only BMP characters a=
re concerned except the users where wchar_t was used only as intermediary=
 between 2 uni2char and char2uni calls (AFFS and BeFS).

Signed-off-by: Vladimir Serbinenko <phcoder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/affs/namei.c          |    4 ++--
 fs/affs/symlink.c        |    2 +-
 fs/befs/linuxvfs.c       |    2 +-
 fs/cifs/cifs_unicode.c   |    8 ++++----
 fs/fat/dir.c             |   27 +++++++++++++++------------
 fs/fat/namei_vfat.c      |    7 ++++---
 fs/hfs/trans.c           |    4 ++--
 fs/hfsplus/unicode.c     |   10 +++++-----
 fs/jfs/jfs_unicode.c     |    6 ++++--
 fs/ncpfs/ncplib_kernel.c |   16 +++++++++-------
 fs/nls/nls_ascii.c       |    8 ++++++--
 fs/nls/nls_base.c        |    8 ++++++--
 fs/nls/nls_cp1250.c      |    8 ++++++--
 fs/nls/nls_cp1251.c      |    8 ++++++--
 fs/nls/nls_cp1255.c      |    8 ++++++--
 fs/nls/nls_cp437.c       |    8 ++++++--
 fs/nls/nls_cp737.c       |    8 ++++++--
 fs/nls/nls_cp775.c       |    8 ++++++--
 fs/nls/nls_cp850.c       |    8 ++++++--
 fs/nls/nls_cp852.c       |    8 ++++++--
 fs/nls/nls_cp855.c       |    8 ++++++--
 fs/nls/nls_cp857.c       |    8 ++++++--
 fs/nls/nls_cp860.c       |    8 ++++++--
 fs/nls/nls_cp861.c       |    8 ++++++--
 fs/nls/nls_cp862.c       |    8 ++++++--
 fs/nls/nls_cp863.c       |    8 ++++++--
 fs/nls/nls_cp864.c       |    8 ++++++--
 fs/nls/nls_cp865.c       |    8 ++++++--
 fs/nls/nls_cp866.c       |    8 ++++++--
 fs/nls/nls_cp869.c       |    8 ++++++--
 fs/nls/nls_cp874.c       |    8 ++++++--
 fs/nls/nls_cp932.c       |    7 +++++--
 fs/nls/nls_cp936.c       |    7 +++++--
 fs/nls/nls_cp949.c       |    7 +++++--
 fs/nls/nls_cp950.c       |    7 +++++--
 fs/nls/nls_euc-jp.c      |    4 ++--
 fs/nls/nls_iso8859-1.c   |    8 ++++++--
 fs/nls/nls_iso8859-13.c  |    8 ++++++--
 fs/nls/nls_iso8859-14.c  |    8 ++++++--
 fs/nls/nls_iso8859-15.c  |    8 ++++++--
 fs/nls/nls_iso8859-2.c   |    8 ++++++--
 fs/nls/nls_iso8859-3.c   |    8 ++++++--
 fs/nls/nls_iso8859-4.c   |    8 ++++++--
 fs/nls/nls_iso8859-5.c   |    8 ++++++--
 fs/nls/nls_iso8859-6.c   |    8 ++++++--
 fs/nls/nls_iso8859-7.c   |    8 ++++++--
 fs/nls/nls_iso8859-9.c   |    8 ++++++--
 fs/nls/nls_koi8-r.c      |    8 ++++++--
 fs/nls/nls_koi8-ru.c     |    7 +++++--
 fs/nls/nls_koi8-u.c      |    8 ++++++--
 fs/nls/nls_utf8.c        |    7 ++++---
 fs/ntfs/unistr.c         |    6 +++---
 fs/udf/unicode.c         |    4 ++--
 include/linux/nls.h      |    4 ++--
 54 files changed, 289 insertions(+), 129 deletions(-)

diff --git a/fs/affs/namei.c b/fs/affs/namei.c
index 600fa3e..044ae3e 100644
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -399,7 +399,7 @@ affs_symlink(struct inode *dir, struct dentry *dentry=
, const char *symname)
 				break;
 			if (nls_disk && nls_io) {
 				ssize_t len;
-				wchar_t uni;
+				unicode_t uni;
 				len =3D nls_io->char2uni(symname,
 						       symnameend - symname,
 						       &uni);
@@ -531,7 +531,7 @@ static size_t affs_translate_real(u8 *to, const u8 *f=
rom,
 				  struct nls_table *nls_from,
 				  size_t limit, size_t from_len)
 {
-	wchar_t uni;
+	unicode_t uni;
 	size_t i;
 	ssize_t len;
 	size_t to_len =3D limit;
diff --git a/fs/affs/symlink.c b/fs/affs/symlink.c
index be94d01..934e400 100644
--- a/fs/affs/symlink.c
+++ b/fs/affs/symlink.c
@@ -66,7 +66,7 @@ int affs_read_symlink(struct inode *inode, char *link)
 				break;
 			if (nls_disk && nls_io) {
 				ssize_t len;
-				wchar_t uni;
+				unicode_t uni;
 				len =3D nls_disk->char2uni(symname,
 							 symnameend - symname,
 							 &uni);
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index e18da23..66ef58d 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -602,7 +602,7 @@ befs_nls2utf(struct super_block *sb, const char *in,
 {
 	struct nls_table *nls =3D BEFS_SB(sb)->nls;
 	int i, o;
-	wchar_t uni;
+	unicode_t uni;
 	int unilen, utflen;
 	char *result;
 	/* There're nls characters that will translate to 3-chars-wide UTF-8
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index fbb9da9..173916c 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -201,11 +201,11 @@ cifs_strtoUTF16(__le16 *to, const char *from, int l=
en,
 {
 	int charlen;
 	int i;
-	wchar_t wchar_to; /* needed to quiet sparse */
+	unicode_t wchar_to; /* needed to quiet sparse */
=20
 	for (i =3D 0; len && *from; i++, from +=3D charlen, len -=3D charlen) {=

 		charlen =3D codepage->char2uni(from, len, &wchar_to);
-		if (charlen < 1) {
+		if (charlen < 1 || wchar_to > 0xffff) {
 			cERROR(1, "strtoUTF16: char2uni of 0x%x returned %d",
 				*from, charlen);
 			/* A question mark */
@@ -271,7 +271,7 @@ cifsConvertToUTF16(__le16 *target, const char *source=
, int srclen,
 	int i, j, charlen;
 	char src_char;
 	__le16 dst_char;
-	wchar_t tmp;
+	unicode_t tmp;
=20
 	if (!mapChars)
 		return cifs_strtoUTF16(target, source, PATH_MAX, cp);
@@ -314,7 +314,7 @@ cifsConvertToUTF16(__le16 *target, const char *source=
, int srclen,
 			 * if no match, use question mark, which at least in
 			 * some cases serves as wild card
 			 */
-			if (charlen < 1) {
+			if (charlen < 1 || tmp > 0xffff) {
 				dst_char =3D cpu_to_le16(0x003f);
 				charlen =3D 1;
 			}
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index aca191b..9bb16f3 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -187,15 +187,17 @@ static inline int fat_uni_to_x8(struct super_block =
*sb, const wchar_t *uni,
 }
=20
 static inline int
-fat_short2uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *=
uni)
+fat_short2uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *=
wc)
 {
 	int charlen;
+	unicode_t uni;
=20
-	charlen =3D t->char2uni(c, clen, uni);
-	if (charlen < 0) {
-		*uni =3D 0x003f;	/* a question mark */
-		charlen =3D 1;
+	charlen =3D t->char2uni(c, clen, &uni);
+	if (charlen < 0 || uni > 0xffff) {
+		*wc =3D 0x003f;	/* a question mark */
+		return 1;
 	}
+	*wc =3D uni;
 	return charlen;
 }
=20
@@ -203,24 +205,25 @@ static inline int
 fat_short2lower_uni(struct nls_table *t, unsigned char *c, int clen, wch=
ar_t *uni)
 {
 	int charlen;
-	wchar_t wc;
+	unicode_t wc;
=20
 	charlen =3D t->char2uni(c, clen, &wc);
-	if (charlen < 0) {
+	if (charlen < 0 || wc > 0xffff) {
 		*uni =3D 0x003f;	/* a question mark */
-		charlen =3D 1;
+		return 1;
 	} else if (charlen <=3D 1) {
 		unsigned char nc =3D t->charset2lower[*c];
=20
 		if (!nc)
 			nc =3D *c;
=20
-		if ( (charlen =3D t->char2uni(&nc, 1, uni)) < 0) {
+		charlen =3D t->char2uni(&nc, 1, &wc);
+		if (charlen < 0 || wc > 0xffff) {
 			*uni =3D 0x003f;	/* a question mark */
-			charlen =3D 1;
+			return 1;
 		}
-	} else
-		*uni =3D wc;
+	}
+	*uni =3D wc;
=20
 	return charlen;
 }
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 98ae804..6b9caa5 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -550,10 +550,11 @@ xlate_to_uni(const unsigned char *name, int len, un=
signed char *outname,
 				ip +=3D 5;
 				i +=3D 5;
 			} else {
-				charlen =3D nls->char2uni(ip, len - i,
-									(wchar_t *)op);
-				if (charlen < 0)
+				unicode_t t;
+				charlen =3D nls->char2uni(ip, len - i, &t);
+				if (charlen < 0 || t > 0xffff)
 					return -EINVAL;
+				*(wchar_t *)op =3D t;
 				ip +=3D charlen;
 				i +=3D charlen;
 				op +=3D 2;
diff --git a/fs/hfs/trans.c b/fs/hfs/trans.c
index b1ce4c7..0dd0c7b 100644
--- a/fs/hfs/trans.c
+++ b/fs/hfs/trans.c
@@ -45,7 +45,7 @@ int hfs_mac2asc(struct super_block *sb, char *out, cons=
t struct hfs_name *in)
 	dst =3D out;
 	dstlen =3D HFS_MAX_NAMELEN;
 	if (nls_io) {
-		wchar_t ch;
+		unicode_t ch;
=20
 		while (srclen > 0) {
 			if (nls_disk) {
@@ -107,7 +107,7 @@ void hfs_asc2mac(struct super_block *sb, struct hfs_n=
ame *out, struct qstr *in)
 	dst =3D out->name;
 	dstlen =3D HFS_NAMELEN;
 	if (nls_io) {
-		wchar_t ch;
+		unicode_t ch;
=20
 		while (srclen > 0) {
 			size =3D nls_io->char2uni(src, srclen, &ch);
diff --git a/fs/hfsplus/unicode.c b/fs/hfsplus/unicode.c
index a32998f..5b2c8de 100644
--- a/fs/hfsplus/unicode.c
+++ b/fs/hfsplus/unicode.c
@@ -253,10 +253,10 @@ out:
  * Returns the number of ASCII characters corresponding to the unicode c=
har.
  */
 static inline int asc2unichar(struct super_block *sb, const char *astr, =
int len,
-			      wchar_t *uc)
+			      unicode_t *uc)
 {
 	int size =3D HFSPLUS_SB(sb)->nls->char2uni(astr, len, uc);
-	if (size <=3D 0) {
+	if (size <=3D 0 || *uc > 0xffff) {
 		*uc =3D '?';
 		size =3D 1;
 	}
@@ -300,7 +300,7 @@ int hfsplus_asc2uni(struct super_block *sb, struct hf=
splus_unistr *ustr,
 {
 	int size, dsize, decompose;
 	u16 *dstr, outlen =3D 0;
-	wchar_t c;
+	unicode_t c;
=20
 	decompose =3D !test_bit(HFSPLUS_SB_NODECOMPOSE, &HFSPLUS_SB(sb)->flags)=
;
 	while (outlen < HFSPLUS_MAX_STRLEN && len > 0) {
@@ -341,7 +341,7 @@ int hfsplus_hash_dentry(const struct dentry *dentry, =
const struct inode *inode,
 	const u16 *dstr;
 	int casefold, decompose, size, len;
 	unsigned long hash;
-	wchar_t c;
+	unicode_t c;
 	u16 c2;
=20
 	casefold =3D test_bit(HFSPLUS_SB_CASEFOLD, &HFSPLUS_SB(sb)->flags);
@@ -396,7 +396,7 @@ int hfsplus_compare_dentry(const struct dentry *paren=
t,
 	const u16 *dstr1, *dstr2;
 	const char *astr1, *astr2;
 	u16 c1, c2;
-	wchar_t c;
+	unicode_t c;
=20
 	casefold =3D test_bit(HFSPLUS_SB_CASEFOLD, &HFSPLUS_SB(sb)->flags);
 	decompose =3D !test_bit(HFSPLUS_SB_NODECOMPOSE, &HFSPLUS_SB(sb)->flags)=
;
diff --git a/fs/jfs/jfs_unicode.c b/fs/jfs/jfs_unicode.c
index c7de6f5..2d70cf1 100644
--- a/fs/jfs/jfs_unicode.c
+++ b/fs/jfs/jfs_unicode.c
@@ -88,8 +88,10 @@ static int jfs_strtoUCS(wchar_t * to, const unsigned c=
har *from, int len,
 	if (codepage) {
 		for (i =3D 0; len && *from; i++, from +=3D charlen, len -=3D charlen)
 		{
-			charlen =3D codepage->char2uni(from, len, &to[i]);
-			if (charlen < 1) {
+			unicode_t uni;
+			charlen =3D codepage->char2uni(from, len, &uni);
+			to[i] =3D uni;
+			if (charlen < 1 || uni > 0xffff) {
 				jfs_err("jfs_strtoUCS: char2uni returned %d.",
 					charlen);
 				jfs_err("charset =3D %s, char =3D 0x%x",
diff --git a/fs/ncpfs/ncplib_kernel.c b/fs/ncpfs/ncplib_kernel.c
index 981a956..c9f66dc 100644
--- a/fs/ncpfs/ncplib_kernel.c
+++ b/fs/ncpfs/ncplib_kernel.c
@@ -1120,17 +1120,15 @@ ncp__io2vol(struct ncp_server *server, unsigned c=
har *vname, unsigned int *vlen,
=20
 	while (iname < iname_end) {
 		int chl;
-		wchar_t ec;
+		unicode_t ec;
=20
 		if (NCP_IS_FLAG(server, NCP_FLAG_UTF8)) {
 			int k;
-			unicode_t u;
=20
-			k =3D utf8_to_utf32(iname, iname_end - iname, &u);
-			if (k < 0 || u > MAX_WCHAR_T)
+			k =3D utf8_to_utf32(iname, iname_end - iname, &ec);
+			if (k < 0 || ec > MAX_WCHAR_T)
 				return -EINVAL;
 			iname +=3D k;
-			ec =3D u;
 		} else {
 			if (*iname =3D=3D NCP_ESC) {
 				int k;
@@ -1160,6 +1158,9 @@ nospec:;
 			}
 		}
=20
+		if (ec > MAX_WCHAR_T)
+			return -EINVAL;
+
 		/* unitoupper should be here! */
=20
 		chl =3D out->uni2char(ec, vname, vname_end - vname);
@@ -1213,10 +1214,11 @@ ncp__vol2io(struct ncp_server *server, unsigned c=
har *iname, unsigned int *ilen,
 	vname_end =3D vname + vlen;
=20
 	while (vname < vname_end) {
-		wchar_t ec;
+		unicode_t ec;
 		int chl;
=20
-		if ( (chl =3D in->char2uni(vname, vname_end - vname, &ec)) < 0) {
+		chl =3D in->char2uni(vname, vname_end - vname, &ec);
+		if (chl < 0 || ec > 0xffff) {
 			err =3D chl;
 			goto quit;
 		}
diff --git a/fs/nls/nls_ascii.c b/fs/nls/nls_ascii.c
index 7020e94..c15b145 100644
--- a/fs/nls/nls_ascii.c
+++ b/fs/nls/nls_ascii.c
@@ -117,7 +117,7 @@ static const unsigned char charset2upper[256] =3D {
 	0x58, 0x59, 0x5a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, /* 0x78-0x7f */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -126,6 +126,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -134,7 +137,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index fea6bd5..4f6d1ae 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -493,7 +493,7 @@ static const unsigned char charset2upper[256] =3D {
 };
=20
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -502,6 +502,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -510,7 +513,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp1250.c b/fs/nls/nls_cp1250.c
index c8471fe..05d3be1 100644
--- a/fs/nls/nls_cp1250.c
+++ b/fs/nls/nls_cp1250.c
@@ -298,7 +298,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xff, /* 0xf8-0xff */
 	};
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
         const unsigned char *uni2charset;
         unsigned char cl =3D uni & 0x00ff;
@@ -307,6 +307,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
         if (boundlen <=3D 0)
                 return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
         uni2charset =3D page_uni2charset[ch];
         if (uni2charset && uni2charset[cl])
                 out[0] =3D uni2charset[cl];
@@ -315,7 +318,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
         return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
         *uni =3D charset2uni[*rawstring];
         if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp1251.c b/fs/nls/nls_cp1251.c
index 1939b46..b2e5d0a 100644
--- a/fs/nls/nls_cp1251.c
+++ b/fs/nls/nls_cp1251.c
@@ -252,7 +252,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xdf, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -261,6 +261,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -269,7 +272,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp1255.c b/fs/nls/nls_cp1255.c
index 8120ae2..1365831 100644
--- a/fs/nls/nls_cp1255.c
+++ b/fs/nls/nls_cp1255.c
@@ -333,7 +333,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -342,6 +342,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -350,7 +353,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp437.c b/fs/nls/nls_cp437.c
index ff37a46..cf27d0a 100644
--- a/fs/nls/nls_cp437.c
+++ b/fs/nls/nls_cp437.c
@@ -338,7 +338,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -347,6 +347,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -355,7 +358,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp737.c b/fs/nls/nls_cp737.c
index f5576b8..f9fd323 100644
--- a/fs/nls/nls_cp737.c
+++ b/fs/nls/nls_cp737.c
@@ -301,7 +301,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -310,6 +310,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -318,7 +321,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp775.c b/fs/nls/nls_cp775.c
index 4905635..9a9f9cb 100644
--- a/fs/nls/nls_cp775.c
+++ b/fs/nls/nls_cp775.c
@@ -270,7 +270,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -279,6 +279,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -287,7 +290,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp850.c b/fs/nls/nls_cp850.c
index fe5bdad..66f5876 100644
--- a/fs/nls/nls_cp850.c
+++ b/fs/nls/nls_cp850.c
@@ -266,7 +266,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -275,6 +275,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -283,7 +286,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp852.c b/fs/nls/nls_cp852.c
index ceb1c01..3a6a70b 100644
--- a/fs/nls/nls_cp852.c
+++ b/fs/nls/nls_cp852.c
@@ -288,7 +288,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xeb, 0xfc, 0xfc, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -297,6 +297,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -305,7 +308,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp855.c b/fs/nls/nls_cp855.c
index cc7f5fb2..e1875dc 100644
--- a/fs/nls/nls_cp855.c
+++ b/fs/nls/nls_cp855.c
@@ -250,7 +250,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xfa, 0xfa, 0xfc, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -259,6 +259,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -267,7 +270,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp857.c b/fs/nls/nls_cp857.c
index e418e19..33bb390 100644
--- a/fs/nls/nls_cp857.c
+++ b/fs/nls/nls_cp857.c
@@ -252,7 +252,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -261,6 +261,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -269,7 +272,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp860.c b/fs/nls/nls_cp860.c
index a86c97d..375caae 100644
--- a/fs/nls/nls_cp860.c
+++ b/fs/nls/nls_cp860.c
@@ -315,7 +315,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -324,6 +324,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -332,7 +335,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp861.c b/fs/nls/nls_cp861.c
index bd92022..6ca31c1 100644
--- a/fs/nls/nls_cp861.c
+++ b/fs/nls/nls_cp861.c
@@ -338,7 +338,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -347,6 +347,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -355,7 +358,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp862.c b/fs/nls/nls_cp862.c
index e9b68eb..17305cf 100644
--- a/fs/nls/nls_cp862.c
+++ b/fs/nls/nls_cp862.c
@@ -372,7 +372,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -381,6 +381,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -389,7 +392,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp863.c b/fs/nls/nls_cp863.c
index f8a9b07..edcec62 100644
--- a/fs/nls/nls_cp863.c
+++ b/fs/nls/nls_cp863.c
@@ -332,7 +332,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -341,6 +341,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -349,7 +352,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp864.c b/fs/nls/nls_cp864.c
index 8d31f43..8ac66ef 100644
--- a/fs/nls/nls_cp864.c
+++ b/fs/nls/nls_cp864.c
@@ -358,7 +358,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0x00, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -367,6 +367,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -375,7 +378,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp865.c b/fs/nls/nls_cp865.c
index 4bd902f..69ab13d 100644
--- a/fs/nls/nls_cp865.c
+++ b/fs/nls/nls_cp865.c
@@ -338,7 +338,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -347,6 +347,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -355,7 +358,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp866.c b/fs/nls/nls_cp866.c
index bdc7cb3..fcc984a 100644
--- a/fs/nls/nls_cp866.c
+++ b/fs/nls/nls_cp866.c
@@ -256,7 +256,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -265,6 +265,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -273,7 +276,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp869.c b/fs/nls/nls_cp869.c
index 9f283a2..9952629 100644
--- a/fs/nls/nls_cp869.c
+++ b/fs/nls/nls_cp869.c
@@ -266,7 +266,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xd5, 0x96, 0xfc, 0x98, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -275,6 +275,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -283,7 +286,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp874.c b/fs/nls/nls_cp874.c
index 0b3c488..5b4312e 100644
--- a/fs/nls/nls_cp874.c
+++ b/fs/nls/nls_cp874.c
@@ -224,7 +224,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0x00, 0x00, 0x00, 0x00, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -233,6 +233,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -241,7 +244,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_cp932.c b/fs/nls/nls_cp932.c
index 0ffed6f..0b9aa93 100644
--- a/fs/nls/nls_cp932.c
+++ b/fs/nls/nls_cp932.c
@@ -7834,7 +7834,7 @@ static const unsigned char charset2upper[256] =3D {=

 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(const wchar_t uni,
+static int uni2char(const unicode_t uni,
 		    unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
@@ -7844,6 +7844,9 @@ static int uni2char(const wchar_t uni,
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	if (ch =3D=3D 0xFF && 0x61 <=3D cl && cl <=3D 0x9F) {
 		out[0] =3D cl + 0x40;
 		return 1;
@@ -7875,7 +7878,7 @@ static int uni2char(const wchar_t uni,
 }
=20
 static int char2uni(const unsigned char *rawstring, int boundlen,
-		    wchar_t *uni)
+		    unicode_t *uni)
 {
 	unsigned char ch, cl;
 	const wchar_t *charset2uni;
diff --git a/fs/nls/nls_cp936.c b/fs/nls/nls_cp936.c
index 8277030..637f276 100644
--- a/fs/nls/nls_cp936.c
+++ b/fs/nls/nls_cp936.c
@@ -10997,7 +10997,7 @@ static const unsigned char charset2upper[256] =3D=
 {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(const wchar_t uni,
+static int uni2char(const unicode_t uni,
 			unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
@@ -11008,6 +11008,9 @@ static int uni2char(const wchar_t uni,
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	if (uni =3D=3D 0x20ac) {/* Euro symbol.The only exception with a non-as=
cii unicode */
 		out[0] =3D 0x80;
 		return 1;
@@ -11047,7 +11050,7 @@ static int uni2char(const wchar_t uni,
 }
=20
 static int char2uni(const unsigned char *rawstring, int boundlen,
-			wchar_t *uni)
+			unicode_t *uni)
 {
 	unsigned char ch, cl;
 	const wchar_t *charset2uni;
diff --git a/fs/nls/nls_cp949.c b/fs/nls/nls_cp949.c
index 8a7a2fe..4879982 100644
--- a/fs/nls/nls_cp949.c
+++ b/fs/nls/nls_cp949.c
@@ -13858,7 +13858,7 @@ static const unsigned char charset2upper[256] =3D=
 {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(const wchar_t uni,
+static int uni2char(const unicode_t uni,
 			unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
@@ -13870,6 +13870,9 @@ static int uni2char(const wchar_t uni,
 		return -ENAMETOOLONG;
=20
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset) {
 		if (boundlen <=3D 1)
@@ -13890,7 +13893,7 @@ static int uni2char(const wchar_t uni,
 }
=20
 static int char2uni(const unsigned char *rawstring, int boundlen,
-			wchar_t *uni)
+			unicode_t *uni)
 {
 	unsigned char ch, cl;
 	const wchar_t *charset2uni;
diff --git a/fs/nls/nls_cp950.c b/fs/nls/nls_cp950.c
index ef25368..019ae50 100644
--- a/fs/nls/nls_cp950.c
+++ b/fs/nls/nls_cp950.c
@@ -9394,7 +9394,7 @@ static const unsigned char charset2upper[256] =3D {=

 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(const wchar_t uni,
+static int uni2char(const unicode_t uni,
 			unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
@@ -9406,6 +9406,9 @@ static int uni2char(const wchar_t uni,
 		return -ENAMETOOLONG;
=20
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset) {
 		if (boundlen <=3D 1)
@@ -9426,7 +9429,7 @@ static int uni2char(const wchar_t uni,
 }
=20
 static int char2uni(const unsigned char *rawstring, int boundlen,
-			wchar_t *uni)
+			unicode_t *uni)
 {
 	unsigned char ch, cl;
 	const wchar_t *charset2uni;
diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 7424929..2af2c03 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -406,7 +406,7 @@ static inline int sjisnec2sjisibm(unsigned char *sjis=
ibm,
 	return 2;
 }
=20
-static int uni2char(const wchar_t uni,
+static int uni2char(const unicode_t uni,
 		    unsigned char *out, int boundlen)
 {
 	int n;
@@ -477,7 +477,7 @@ static int uni2char(const wchar_t uni,
 }
=20
 static int char2uni(const unsigned char *rawstring, int boundlen,
-		    wchar_t *uni)
+		    unicode_t *uni)
 {
 	unsigned char sjis_temp[2];
 	int euc_offset, n;
diff --git a/fs/nls/nls_iso8859-1.c b/fs/nls/nls_iso8859-1.c
index 7b951bb..b904c26 100644
--- a/fs/nls/nls_iso8859-1.c
+++ b/fs/nls/nls_iso8859-1.c
@@ -208,7 +208,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0x00, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -217,6 +217,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -225,7 +228,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-13.c b/fs/nls/nls_iso8859-13.c
index c4d52ea..357a827 100644
--- a/fs/nls/nls_iso8859-13.c
+++ b/fs/nls/nls_iso8859-13.c
@@ -236,7 +236,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -245,6 +245,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -253,7 +256,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-14.c b/fs/nls/nls_iso8859-14.c
index dc02600..8493956 100644
--- a/fs/nls/nls_iso8859-14.c
+++ b/fs/nls/nls_iso8859-14.c
@@ -292,7 +292,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xaf, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -301,6 +301,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -309,7 +312,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-15.c b/fs/nls/nls_iso8859-15.c
index 3c7dfc8..4495ebf 100644
--- a/fs/nls/nls_iso8859-15.c
+++ b/fs/nls/nls_iso8859-15.c
@@ -258,7 +258,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xbe, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -267,6 +267,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -275,7 +278,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-2.c b/fs/nls/nls_iso8859-2.c
index a2d2197..37c2672 100644
--- a/fs/nls/nls_iso8859-2.c
+++ b/fs/nls/nls_iso8859-2.c
@@ -259,7 +259,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -268,6 +268,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -276,7 +279,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-3.c b/fs/nls/nls_iso8859-3.c
index a61e0da..71cfe3b 100644
--- a/fs/nls/nls_iso8859-3.c
+++ b/fs/nls/nls_iso8859-3.c
@@ -259,7 +259,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -268,6 +268,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -276,7 +279,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-4.c b/fs/nls/nls_iso8859-4.c
index e8ff555..72bbdcd 100644
--- a/fs/nls/nls_iso8859-4.c
+++ b/fs/nls/nls_iso8859-4.c
@@ -259,7 +259,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0xdd, 0xde, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -268,6 +268,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -276,7 +279,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-5.c b/fs/nls/nls_iso8859-5.c
index 4721e89..326d0f8 100644
--- a/fs/nls/nls_iso8859-5.c
+++ b/fs/nls/nls_iso8859-5.c
@@ -223,7 +223,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xfd, 0xae, 0xaf, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -232,6 +232,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -240,7 +243,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-6.c b/fs/nls/nls_iso8859-6.c
index 01a517d..d42b681 100644
--- a/fs/nls/nls_iso8859-6.c
+++ b/fs/nls/nls_iso8859-6.c
@@ -214,7 +214,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf0, 0xf1, 0xf2, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xf0-0xf7 */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -223,6 +223,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -231,7 +234,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-7.c b/fs/nls/nls_iso8859-7.c
index 2d27b93..0f22a64 100644
--- a/fs/nls/nls_iso8859-7.c
+++ b/fs/nls/nls_iso8859-7.c
@@ -268,7 +268,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xbc, 0xbe, 0xbf, 0x00, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -277,6 +277,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -285,7 +288,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_iso8859-9.c b/fs/nls/nls_iso8859-9.c
index 694bf07..86e5dbb 100644
--- a/fs/nls/nls_iso8859-9.c
+++ b/fs/nls/nls_iso8859-9.c
@@ -223,7 +223,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xd8, 0xd9, 0xda, 0xdb, 0xdc, 0x49, 0xde, 0x00, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -232,6 +232,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -240,7 +243,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_koi8-r.c b/fs/nls/nls_koi8-r.c
index 4387531..d51cb5e 100644
--- a/fs/nls/nls_koi8-r.c
+++ b/fs/nls/nls_koi8-r.c
@@ -274,7 +274,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -283,6 +283,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -291,7 +294,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_koi8-ru.c b/fs/nls/nls_koi8-ru.c
index e7bc1d7..7c3f4ba 100644
--- a/fs/nls/nls_koi8-ru.c
+++ b/fs/nls/nls_koi8-ru.c
@@ -13,12 +13,15 @@
=20
 static struct nls_table *p_nls;
=20
-static int uni2char(const wchar_t uni,
+static int uni2char(const unicode_t uni,
 		    unsigned char *out, int boundlen)
 {
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	if ((uni & 0xffaf) =3D=3D 0x040e || (uni & 0xffce) =3D=3D 0x254c) {
 		/* koi8-ru and koi8-u differ only on two characters */
 		if (uni =3D=3D 0x040e)
@@ -37,7 +40,7 @@ static int uni2char(const wchar_t uni,
 }
=20
 static int char2uni(const unsigned char *rawstring, int boundlen,
-		    wchar_t *uni)
+		    unicode_t *uni)
 {
 	int n;
=20
diff --git a/fs/nls/nls_koi8-u.c b/fs/nls/nls_koi8-u.c
index 8c9f029..a177b9d 100644
--- a/fs/nls/nls_koi8-u.c
+++ b/fs/nls/nls_koi8-u.c
@@ -281,7 +281,7 @@ static const unsigned char charset2upper[256] =3D {
 	0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff, /* 0xf8-0xff */
 };
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	const unsigned char *uni2charset;
 	unsigned char cl =3D uni & 0x00ff;
@@ -290,6 +290,9 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	if (boundlen <=3D 0)
 		return -ENAMETOOLONG;
=20
+	if (uni > 0xffff)
+		return -EINVAL;
+
 	uni2charset =3D page_uni2charset[ch];
 	if (uni2charset && uni2charset[cl])
 		out[0] =3D uni2charset[cl];
@@ -298,7 +301,8 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return 1;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	*uni =3D charset2uni[*rawstring];
 	if (*uni =3D=3D 0x0000)
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index 0d60a44..eb6392e 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -11,7 +11,7 @@
=20
 static unsigned char identity[256];
=20
-static int uni2char(wchar_t uni, unsigned char *out, int boundlen)
+static int uni2char(unicode_t uni, unsigned char *out, int boundlen)
 {
 	int n;
=20
@@ -26,13 +26,14 @@ static int uni2char(wchar_t uni, unsigned char *out, =
int boundlen)
 	return n;
 }
=20
-static int char2uni(const unsigned char *rawstring, int boundlen, wchar_=
t *uni)
+static int char2uni(const unsigned char *rawstring, int boundlen,
+		    unicode_t *uni)
 {
 	int n;
 	unicode_t u;
=20
 	n =3D utf8_to_utf32(rawstring, boundlen, &u);
-	if (n < 0 || u > MAX_WCHAR_T) {
+	if (n < 0 || u > 0x10ffff) {
 		*uni =3D 0x003f;	/* ? */
 		return -EINVAL;
 	}
diff --git a/fs/ntfs/unistr.c b/fs/ntfs/unistr.c
index 005ca4b..0d371e7 100644
--- a/fs/ntfs/unistr.c
+++ b/fs/ntfs/unistr.c
@@ -261,7 +261,7 @@ int ntfs_nlstoucs(const ntfs_volume *vol, const char =
*ins,
 {
 	struct nls_table *nls =3D vol->nls_map;
 	ntfschar *ucs;
-	wchar_t wc;
+	unicode_t wc;
 	int i, o, wc_len;
=20
 	/* We do not trust outside sources. */
@@ -271,8 +271,8 @@ int ntfs_nlstoucs(const ntfs_volume *vol, const char =
*ins,
 			for (i =3D o =3D 0; i < ins_len; i +=3D wc_len) {
 				wc_len =3D nls->char2uni(ins + i, ins_len - i,
 						&wc);
-				if (likely(wc_len >=3D 0 &&
-						o < NTFS_MAX_NAME_LEN)) {
+				if (likely(wc_len >=3D 0 && wc <=3D 0xffff
+					   && o < NTFS_MAX_NAME_LEN)) {
 					if (likely(wc)) {
 						ucs[o++] =3D cpu_to_le16(wc);
 						continue;
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 44b815e..9b1b2de 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -298,7 +298,7 @@ static int udf_NLStoCS0(struct nls_table *nls, dstrin=
g *ocu, struct ustr *uni,
 {
 	int len;
 	unsigned i, max_val;
-	uint16_t uni_char;
+	unicode_t uni_char;
 	int u_len;
=20
 	memset(ocu, 0, sizeof(dstring) * length);
@@ -312,7 +312,7 @@ try_again:
 		if (!len)
 			continue;
 		/* Invalid character, deal with it */
-		if (len < 0) {
+		if (len < 0 || uni_char > 0xffff) {
 			len =3D 1;
 			uni_char =3D '?';
 		}
diff --git a/include/linux/nls.h b/include/linux/nls.h
index 5dc635f..c0292dd 100644
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -24,9 +24,9 @@ typedef u32 unicode_t;
 struct nls_table {
 	const char *charset;
 	const char *alias;
-	int (*uni2char) (wchar_t uni, unsigned char *out, int boundlen);
+	int (*uni2char) (unicode_t uni, unsigned char *out, int boundlen);
 	int (*char2uni) (const unsigned char *rawstring, int boundlen,
-			 wchar_t *uni);
+			 unicode_t *uni);
 	const unsigned char *charset2lower;
 	const unsigned char *charset2upper;
 	struct module *owner;
--=20
1.7.10

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko




--------------enigFF0EC4C88EC3E97B8C736F52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y3+EACgkQNak7dOguQgklEgD9FlgexzZqW4ymWgZ1CBPZyHK1
D0Qp1NBXgGcdSfvEBV0BAJYOtyAWxawMBe/R/GoOqSUZlop6DO9xCF/n1XPp0zaG
=Vzxx
-----END PGP SIGNATURE-----

--------------enigFF0EC4C88EC3E97B8C736F52--
