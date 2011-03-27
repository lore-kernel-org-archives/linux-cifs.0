From: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Subject: [PATCH] allow cifs passwords with utf8 characters
Date: Sun, 27 Mar 2011 09:01:44 +0200
Message-ID: <20110327070144.GA3772@osk.mine.nu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I noticed that I could not mount cifs shares when the password contained
utf8-encoded latin1 characters. (But somehow it worked when those latin1
characters were encoded with ISO-8859-1.) So I made some modifications to
assume utf8 passwords rather than raw 8-bit.

Regards,

Oskar Liljeblad (oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org)

PS. This patch is against linux 2.6.35.7. I am not really sure which
version/tree to work with, so please tell me so that I can update the patch
if needed. DS.

--8t9RHnE3ZwKMSgU+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="cifs-utf8-password.diff"

diff -u -p fs/cifs/smbencrypt.c.v0 fs/cifs/smbencrypt.c
--- fs/cifs/smbencrypt.c.v0	2010-09-29 03:09:08.000000000 +0200
+++ fs/cifs/smbencrypt.c	2011-03-27 08:39:20.000000000 +0200
@@ -29,6 +29,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/random.h>
+#include <linux/nls.h>
 #include "cifs_unicode.h"
 #include "cifspdu.h"
 #include "cifsglob.h"
@@ -80,40 +81,6 @@ SMBencrypt(unsigned char *passwd, const
 	memset(p21, 0, 21);
 }
 
-/* Routines for Windows NT MD4 Hash functions. */
-static int
-_my_wcslen(__u16 *str)
-{
-	int len = 0;
-	while (*str++ != 0)
-		len++;
-	return len;
-}
-
-/*
- * Convert a string into an NT UNICODE string.
- * Note that regardless of processor type
- * this must be in intel (little-endian)
- * format.
- */
-
-static int
-_my_mbstowcs(__u16 *dst, const unsigned char *src, int len)
-{	/* BB not a very good conversion routine - change/fix */
-	int i;
-	__u16 val;
-
-	for (i = 0; i < len; i++) {
-		val = *src;
-		SSVAL(dst, 0, val);
-		dst++;
-		src++;
-		if (val == 0)
-			break;
-	}
-	return i;
-}
-
 /*
  * Creates the MD4 Hash of the users password in NT UNICODE.
  */
@@ -126,20 +93,14 @@ E_md4hash(const unsigned char *passwd, u
 
 	/* Password cannot be longer than 128 characters */
 	if (passwd) {
-		len = strlen((char *) passwd);
-		if (len > 128)
-			len = 128;
-
 		/* Password must be converted to NT unicode */
-		_my_mbstowcs(wpwd, passwd, len);
-	} else
+		len = utf8s_to_ucs2(passwd, 128, (wchar_t *) wpwd);
+	} else {
 		len = 0;
-
+        }
 	wpwd[len] = 0;	/* Ensure string is null terminated */
-	/* Calculate length in bytes */
-	len = _my_wcslen(wpwd) * sizeof(__u16);
 
-	mdfour(p16, (unsigned char *) wpwd, len);
+	mdfour(p16, (unsigned char *) wpwd, len * sizeof(__u16));
 	memset(wpwd, 0, 129 * 2);
 }
 
diff -u -p fs/nls/nls_base.c.v0 fs/nls/nls_base.c
--- fs/nls/nls_base.c.v0	2010-09-29 03:09:08.000000000 +0200
+++ fs/nls/nls_base.c	2011-03-27 08:26:35.000000000 +0200
@@ -148,6 +148,32 @@ int utf8s_to_utf16s(const u8 *s, int len
 }
 EXPORT_SYMBOL(utf8s_to_utf16s);
 
+int utf8s_to_ucs2(const u8 *s, int len, wchar_t *pwcs)
+{
+	u16 *op;
+	int size;
+	unicode_t u;
+
+	op = pwcs;
+	while (*s && len > 0) {
+		if (*s & 0x80) {
+			size = utf8_to_utf32(s, len, &u);
+			if (size < 0)
+				return -EINVAL;
+
+			if (u < PLANE_SIZE)
+				*op++ = (wchar_t) u;
+			s += size;
+			len -= size;
+		} else {
+			*op++ = *s++;
+			len--;
+		}
+	}
+	return op - pwcs;
+}
+EXPORT_SYMBOL(utf8s_to_ucs2);
+
 static inline unsigned long get_utf16(unsigned c, enum utf16_endian endian)
 {
 	switch (endian) {

--8t9RHnE3ZwKMSgU+--
