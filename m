From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] cifs: clean up unaligned accesses in cifs_unicode.c
Date: Tue, 18 Jan 2011 15:33:18 -0500
Message-ID: <1295382799-7902-5-git-send-email-jlayton@redhat.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make sure we use get/put_unaligned routines when accessing wide
character strings.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   49 ++++++++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 430f510..8134443 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -44,10 +44,14 @@ cifs_ucs2_bytes(const __le16 *from, int maxbytes,
 	int charlen, outlen = 0;
 	int maxwords = maxbytes / 2;
 	char tmp[NLS_MAX_CHARSET_SIZE];
+	__u16 ftmp;
 
-	for (i = 0; i < maxwords && from[i]; i++) {
-		charlen = codepage->uni2char(le16_to_cpu(from[i]), tmp,
-					     NLS_MAX_CHARSET_SIZE);
+	for (i = 0; i < maxwords; i++) {
+		ftmp = get_unaligned_le16(&from[i]);
+		if (ftmp == 0)
+			break;
+
+		charlen = codepage->uni2char(ftmp, tmp, NLS_MAX_CHARSET_SIZE);
 		if (charlen > 0)
 			outlen += charlen;
 		else
@@ -60,7 +64,7 @@ cifs_ucs2_bytes(const __le16 *from, int maxbytes,
 /*
  * cifs_mapchar - convert a little-endian char to proper char in codepage
  * @target - where converted character should be copied
- * @src_char - 2 byte little-endian source character
+ * @src_char - 2 byte host-endian source character
  * @cp - codepage to which character should be converted
  * @mapchar - should character be mapped according to mapchars mount option?
  *
@@ -69,7 +73,7 @@ cifs_ucs2_bytes(const __le16 *from, int maxbytes,
  * enough to hold the result of the conversion (at least NLS_MAX_CHARSET_SIZE).
  */
 static int
-cifs_mapchar(char *target, const __le16 src_char, const struct nls_table *cp,
+cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
 	     bool mapchar)
 {
 	int len = 1;
@@ -82,7 +86,7 @@ cifs_mapchar(char *target, const __le16 src_char, const struct nls_table *cp,
 	 *     build_path_from_dentry are modified, as they use slash as
 	 *     separator.
 	 */
-	switch (le16_to_cpu(src_char)) {
+	switch (src_char) {
 	case UNI_COLON:
 		*target = ':';
 		break;
@@ -109,8 +113,7 @@ out:
 	return len;
 
 cp_convert:
-	len = cp->uni2char(le16_to_cpu(src_char), target,
-			   NLS_MAX_CHARSET_SIZE);
+	len = cp->uni2char(src_char, target, NLS_MAX_CHARSET_SIZE);
 	if (len <= 0) {
 		*target = '?';
 		len = 1;
@@ -149,6 +152,7 @@ cifs_from_ucs2(char *to, const __le16 *from, int tolen, int fromlen,
 	int nullsize = nls_nullsize(codepage);
 	int fromwords = fromlen / 2;
 	char tmp[NLS_MAX_CHARSET_SIZE];
+	__u16 ftmp;
 
 	/*
 	 * because the chars can be of varying widths, we need to take care
@@ -158,19 +162,23 @@ cifs_from_ucs2(char *to, const __le16 *from, int tolen, int fromlen,
 	 */
 	safelen = tolen - (NLS_MAX_CHARSET_SIZE + nullsize);
 
-	for (i = 0; i < fromwords && from[i]; i++) {
+	for (i = 0; i < fromwords; i++) {
+		ftmp = get_unaligned_le16(&from[i]);
+		if (ftmp == 0)
+			break;
+
 		/*
 		 * check to see if converting this character might make the
 		 * conversion bleed into the null terminator
 		 */
 		if (outlen >= safelen) {
-			charlen = cifs_mapchar(tmp, from[i], codepage, mapchar);
+			charlen = cifs_mapchar(tmp, ftmp, codepage, mapchar);
 			if ((outlen + charlen) > (tolen - nullsize))
 				break;
 		}
 
 		/* put converted char into 'to' buffer */
-		charlen = cifs_mapchar(&to[outlen], from[i], codepage, mapchar);
+		charlen = cifs_mapchar(&to[outlen], ftmp, codepage, mapchar);
 		outlen += charlen;
 	}
 
@@ -193,24 +201,21 @@ cifs_strtoUCS(__le16 *to, const char *from, int len,
 {
 	int charlen;
 	int i;
-	wchar_t *wchar_to = (wchar_t *)to; /* needed to quiet sparse */
+	wchar_t wchar_to; /* needed to quiet sparse */
 
 	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
-
-		/* works for 2.4.0 kernel or later */
-		charlen = codepage->char2uni(from, len, &wchar_to[i]);
+		charlen = codepage->char2uni(from, len, &wchar_to);
 		if (charlen < 1) {
-			cERROR(1, "strtoUCS: char2uni of %d returned %d",
-				(int)*from, charlen);
+			cERROR(1, "strtoUCS: char2uni of 0x%x returned %d",
+				*from, charlen);
 			/* A question mark */
-			to[i] = cpu_to_le16(0x003f);
+			wchar_to = 0x003f;
 			charlen = 1;
-		} else
-			to[i] = cpu_to_le16(wchar_to[i]);
-
+		}
+		put_unaligned_le16(wchar_to, &to[i]);
 	}
 
-	to[i] = 0;
+	put_unaligned_le16(0, &to[i]);
 	return i;
 }
 
-- 
1.7.3.4
