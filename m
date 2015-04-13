From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: [PATCH] Fix to convert SURROGATE PAIR filename
Date: Mon, 13 Apr 2015 14:31:30 +0900
Message-ID: <552B54B2.6000102@nttcom.co.jp>
References: <54D1C8EE.2030900@nttcom.co.jp> <CAH2r5ms-qB=MAxsk_CQAaLBcNK0a+c9VkDdZMV4wEXPvBBbQGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------060409080506040906010506"
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms-qB=MAxsk_CQAaLBcNK0a+c9VkDdZMV4wEXPvBBbQGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--------------060409080506040906010506
Content-Type: text/plain; charset="shift_jis"
Content-Transfer-Encoding: 7bit

On 2015/04/07 11:20, Steve French wrote:
> Note build warnings (when running normal sparse checks during compile)
> looks like need to resolve endian errors so that this is sure to work
> in big endian, not just little endian boxes
> 
> e.g.
> 
> make C=1 M=fs/cifs modules CF=-D__CHECK_ENDIAN__
> 
>   CHECK   fs/cifs/cifs_unicode.c
> fs/cifs/cifs_unicode.c:508:34: warning: incorrect type in assignment
> (different base types)
> fs/cifs/cifs_unicode.c:508:34:    expected restricted __le16
> [assigned] [usertype] dst_char
> fs/cifs/cifs_unicode.c:508:34:    got unsigned short [unsigned]
> [short] [usertype] <noident>
> fs/cifs/cifs_unicode.c:517:42: warning: incorrect type in assignment
> (different base types)
> fs/cifs/cifs_unicode.c:517:42:    expected restricted __le16
> [assigned] [usertype] dst_char
> fs/cifs/cifs_unicode.c:517:42:    got unsigned short [unsigned]
> [short] [usertype] <noident>
> fs/cifs/cifs_unicode.c:523:42: warning: incorrect type in assignment
> (different base types)
> fs/cifs/cifs_unicode.c:523:42:    expected restricted __le16
> [assigned] [usertype] dst_char
> fs/cifs/cifs_unicode.c:523:42:    got unsigned short [unsigned]
> [short] [usertype] <noident>
> fs/cifs/cifs_unicode.c:526:42: warning: incorrect type in assignment
> (different base types)
> fs/cifs/cifs_unicode.c:526:42:    expected restricted __le16
> [assigned] [usertype] dst_char
> fs/cifs/cifs_unicode.c:526:42:    got unsigned short [unsigned]
> [short] [usertype] <noident>
> 
> On Wed, Feb 4, 2015 at 1:23 AM, Nakajima Akira
> <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org> wrote:
>> Garbled characters happen by using surrogate pair for filename.
>>   (replace each 1 character to ??)
>>
>> This causes
>> -- inode number duplication (when ?? and ?? exist) .
>> -- can't remove file, directory.
>> -- can't operate under directory.
>> -- auto-remount with noserverino.
>>
>>
>> [Steps to Reproduce]
>> client# touch $(echo -e '\xf0\x9d\x9f\xa3')
>> client# touch $(echo -e '\xf0\x9d\x9f\xa4')
>> client# ls -li
>>   You see same inode number, same filename(=?? and ??) .
>>
>>
>>
>> [BUG description]
>> Some functions do not consider about surrogate pair (and IVS).
>>
>> cifs_utf16_bytes()
>> -- return incorrect length, because of not considering about surrogate pair.
>>    This causes problem about SymbolicLink with surrogate pair filename.
>>
>> cifs_mapchar()
>> -- not considering about surrogate pair.
>>
>> cifs_from_utf16()
>> -- not convert surrogate pair from SMB response (from UTF-16 to UTF-8)
>>    , then ls shows garbled characters.
>>
>> cifsConvertToUTF16()
>> -- not convert surrogate pair when mapchars(SFM/SFU).


I fixed endian bug by using function cpu_to_le16().
But I don't have Big Endian machine.
Could someone check on Big Endian machine?

  I'm trying pearpc(PowerPC Emulator), but pearpc doesn't work.
    (pearpc need yaboot?)

[Procedure]
client# touch `printf '\xf0\x9d\x9f\xa3'`
client# touch `printf '\xf0\x9d\x9f\xa4'`
client# ls -li

--Before patch
You see same inode number, same filename(=?? and ??) .

--After patch
You see correct inode numbers, correct filenames(look like 1 and 2)


>From 4b0db586e09916a88ac2ac7a1714e52c28781ff6 Mon Sep 17 00:00:00 2001
From: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Date: Thu, 9 Apr 2015 17:27:39 +0900
Subject: [PATCH] Fix to convert SURROGATE PAIR

Garbled characters happen by using surrogate pair for filename.
  (replace each 1 character to ??)

[Steps to Reproduce for bug]
client# touch $(echo -e '\xf0\x9d\x9f\xa3')
client# touch $(echo -e '\xf0\x9d\x9f\xa4')
client# ls -li
  You see same inode number, same filename(=?? and ??) .

Fix the bug about these functions do not consider about surrogate pair (and IVS).
cifs_utf16_bytes()
cifs_mapchar()
cifs_from_utf16()
cifsConvertToUTF16()


Reported-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Signed-off-by: Nakajima Akira <nakajima.akira-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>

---
 fs/cifs/cifs_unicode.c |  182 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 136 insertions(+), 46 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 0303c67..5a53ac6 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -27,41 +27,6 @@
 #include "cifsglob.h"
 #include "cifs_debug.h"
 
-/*
- * cifs_utf16_bytes - how long will a string be after conversion?
- * @utf16 - pointer to input string
- * @maxbytes - don't go past this many bytes of input string
- * @codepage - destination codepage
- *
- * Walk a utf16le string and return the number of bytes that the string will
- * be after being converted to the given charset, not including any null
- * termination required. Don't walk past maxbytes in the source buffer.
- */
-int
-cifs_utf16_bytes(const __le16 *from, int maxbytes,
-		const struct nls_table *codepage)
-{
-	int i;
-	int charlen, outlen = 0;
-	int maxwords = maxbytes / 2;
-	char tmp[NLS_MAX_CHARSET_SIZE];
-	__u16 ftmp;
-
-	for (i = 0; i < maxwords; i++) {
-		ftmp = get_unaligned_le16(&from[i]);
-		if (ftmp == 0)
-			break;
-
-		charlen = codepage->uni2char(ftmp, tmp, NLS_MAX_CHARSET_SIZE);
-		if (charlen > 0)
-			outlen += charlen;
-		else
-			outlen++;
-	}
-
-	return outlen;
-}
-
 int cifs_remap(struct cifs_sb_info *cifs_sb)
 {
 	int map_type;
@@ -155,10 +120,13 @@ convert_sfm_char(const __u16 src_char, char *target)
  * enough to hold the result of the conversion (at least NLS_MAX_CHARSET_SIZE).
  */
 static int
-cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
+cifs_mapchar(char *target, const __u16 *from, const struct nls_table *cp,
 	     int maptype)
 {
 	int len = 1;
+	__u16 src_char;
+
+	src_char = *from;
 
 	if ((maptype == SFM_MAP_UNI_RSVD) && convert_sfm_char(src_char, target))
 		return len;
@@ -168,10 +136,23 @@ cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
 
 	/* if character not one of seven in special remap set */
 	len = cp->uni2char(src_char, target, NLS_MAX_CHARSET_SIZE);
-	if (len <= 0) {
-		*target = '?';
-		len = 1;
-	}
+	if (len <= 0)
+		goto surrogate_pair;
+
+	return len;
+
+surrogate_pair:
+	/* convert SURROGATE_PAIR and IVS */
+	if (strcmp(cp->charset, "utf8"))
+		goto unknown;
+	len = utf16s_to_utf8s(from, 3, UTF16_LITTLE_ENDIAN, target, 6);
+	if (len <= 0)
+		goto unknown;
+	return len;
+
+unknown:
+	*target = '?';
+	len = 1;
 	return len;
 }
 
@@ -206,7 +187,7 @@ cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 	int nullsize = nls_nullsize(codepage);
 	int fromwords = fromlen / 2;
 	char tmp[NLS_MAX_CHARSET_SIZE];
-	__u16 ftmp;
+	__u16 ftmp[3];		/* ftmp[3] = 3array x 2bytes = 6bytes UTF-16 */
 
 	/*
 	 * because the chars can be of varying widths, we need to take care
@@ -217,9 +198,17 @@ cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 	safelen = tolen - (NLS_MAX_CHARSET_SIZE + nullsize);
 
 	for (i = 0; i < fromwords; i++) {
-		ftmp = get_unaligned_le16(&from[i]);
-		if (ftmp == 0)
+		ftmp[0] = get_unaligned_le16(&from[i]);
+		if (ftmp[0] == 0)
 			break;
+		if (i + 1 < fromwords)
+			ftmp[1] = get_unaligned_le16(&from[i + 1]);
+		else
+			ftmp[1] = 0;
+		if (i + 2 < fromwords)
+			ftmp[2] = get_unaligned_le16(&from[i + 2]);
+		else
+			ftmp[2] = 0;
 
 		/*
 		 * check to see if converting this character might make the
@@ -234,6 +223,17 @@ cifs_from_utf16(char *to, const __le16 *from, int tolen, int fromlen,
 		/* put converted char into 'to' buffer */
 		charlen = cifs_mapchar(&to[outlen], ftmp, codepage, map_type);
 		outlen += charlen;
+
+		/* charlen (=bytes of UTF-8 for 1 character)
+		 * 4bytes UTF-8(surrogate pair) is charlen=4
+		 *   (4bytes UTF-16 code)
+		 * 7-8bytes UTF-8(IVS) is charlen=3+4 or 4+4
+		 *   (2 UTF-8 pairs divided to 2 UTF-16 pairs) */
+		if (charlen == 4)
+			i++;
+		else if (charlen >= 5)
+			/* 5-6bytes UTF-8 */
+			i += 2;
 	}
 
 	/* properly null-terminate string */
@@ -296,6 +296,46 @@ success:
 }
 
 /*
+ * cifs_utf16_bytes - how long will a string be after conversion?
+ * @utf16 - pointer to input string
+ * @maxbytes - don't go past this many bytes of input string
+ * @codepage - destination codepage
+ *
+ * Walk a utf16le string and return the number of bytes that the string will
+ * be after being converted to the given charset, not including any null
+ * termination required. Don't walk past maxbytes in the source buffer.
+ */
+int
+cifs_utf16_bytes(const __le16 *from, int maxbytes,
+		const struct nls_table *codepage)
+{
+	int i;
+	int charlen, outlen = 0;
+	int maxwords = maxbytes / 2;
+	char tmp[NLS_MAX_CHARSET_SIZE];
+	__u16 ftmp[3];
+
+	for (i = 0; i < maxwords; i++) {
+		ftmp[0] = get_unaligned_le16(&from[i]);
+		if (ftmp[0] == 0)
+			break;
+		if (i + 1 < maxwords)
+			ftmp[1] = get_unaligned_le16(&from[i + 1]);
+		else
+			ftmp[1] = 0;
+		if (i + 2 < maxwords)
+			ftmp[2] = get_unaligned_le16(&from[i + 2]);
+		else
+			ftmp[2] = 0;
+
+		charlen = cifs_mapchar(tmp, ftmp, codepage, NO_MAP_UNI_RSVD);
+		outlen += charlen;
+	}
+
+	return outlen;
+}
+
+/*
  * cifs_strndup_from_utf16 - copy a string from wire format to the local
  * codepage
  * @src - source string
@@ -409,10 +449,15 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 	char src_char;
 	__le16 dst_char;
 	wchar_t tmp;
+	wchar_t *wchar_to;	/* UTF-16 */
+	int ret;
+	unicode_t u;
 
 	if (map_chars == NO_MAP_UNI_RSVD)
 		return cifs_strtoUTF16(target, source, PATH_MAX, cp);
 
+	wchar_to = kzalloc(6, GFP_KERNEL);
+
 	for (i = 0; i < srclen; j++) {
 		src_char = source[i];
 		charlen = 1;
@@ -441,11 +486,55 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 			 * if no match, use question mark, which at least in
 			 * some cases serves as wild card
 			 */
-			if (charlen < 1) {
-				dst_char = cpu_to_le16(0x003f);
-				charlen = 1;
+			if (charlen > 0)
+				goto ctoUTF16;
+
+			/* convert SURROGATE_PAIR */
+			if (strcmp(cp->charset, "utf8") || !wchar_to)
+				goto unknown;
+			if (*(source + i) & 0x80) {
+				charlen = utf8_to_utf32(source + i, 6, &u);
+				if (charlen < 0)
+					goto unknown;
+			} else
+				goto unknown;
+			ret  = utf8s_to_utf16s(source + i, charlen,
+					       UTF16_LITTLE_ENDIAN,
+					       wchar_to, 6);
+			if (ret < 0)
+				goto unknown;
+
+			i += charlen;
+			dst_char = cpu_to_le16(*wchar_to);
+			if (charlen <= 3)
+				/* 1-3bytes UTF-8 to 2bytes UTF-16 */
+				put_unaligned(dst_char, &target[j]);
+			else if (charlen == 4) {
+				/* 4bytes UTF-8(surrogate pair) to 4bytes UTF-16
+				 * 7-8bytes UTF-8(IVS) divided to 2 UTF-16
+				 *   (charlen=3+4 or 4+4) */
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 1));
+				j++;
+				put_unaligned(dst_char, &target[j]);
+			} else if (charlen >= 5) {
+				/* 5-6bytes UTF-8 to 6bytes UTF-16 */
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 1));
+				j++;
+				put_unaligned(dst_char, &target[j]);
+				dst_char = cpu_to_le16(*(wchar_to + 2));
+				j++;
+				put_unaligned(dst_char, &target[j]);
 			}
+			continue;
+
+unknown:
+			dst_char = cpu_to_le16(0x003f);
+			charlen = 1;
 		}
+
+ctoUTF16:
 		/*
 		 * character may take more than one byte in the source string,
 		 * but will take exactly two bytes in the target string
@@ -456,6 +545,7 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 
 ctoUTF16_out:
 	put_unaligned(0, &target[j]); /* Null terminate target unicode string */
+	kfree(wchar_to);
 	return j;
 }
 
-- 
1.7.1




--------------060409080506040906010506
Content-Type: text/plain; charset="Shift_JIS";
	name="0001-Fix-to-convert-SURROGATE-PAIR.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="0001-Fix-to-convert-SURROGATE-PAIR.patch"

RnJvbSA0YjBkYjU4NmUwOTkxNmE4OGFjMmFjN2ExNzE0ZTUyYzI4NzgxZmY2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBOYWthamltYSBBa2lyYSA8bmFrYWppbWEuYWtpcmFA
bnR0Y29tLmNvLmpwPgpEYXRlOiBUaHUsIDkgQXByIDIwMTUgMTc6Mjc6MzkgKzA5MDAKU3Vi
amVjdDogW1BBVENIXSBGaXggdG8gY29udmVydCBTVVJST0dBVEUgUEFJUgoKR2FyYmxlZCBj
aGFyYWN0ZXJzIGhhcHBlbiBieSB1c2luZyBzdXJyb2dhdGUgcGFpciBmb3IgZmlsZW5hbWUu
CiAgKHJlcGxhY2UgZWFjaCAxIGNoYXJhY3RlciB0byA/PykKCltTdGVwcyB0byBSZXByb2R1
Y2UgZm9yIGJ1Z10KY2xpZW50IyB0b3VjaCAkKGVjaG8gLWUgJ1x4ZjBceDlkXHg5Zlx4YTMn
KQpjbGllbnQjIHRvdWNoICQoZWNobyAtZSAnXHhmMFx4OWRceDlmXHhhNCcpCmNsaWVudCMg
bHMgLWxpCiAgWW91IHNlZSBzYW1lIGlub2RlIG51bWJlciwgc2FtZSBmaWxlbmFtZSg9Pz8g
YW5kID8/KSAuCgpGaXggdGhlIGJ1ZyBhYm91dCB0aGVzZSBmdW5jdGlvbnMgZG8gbm90IGNv
bnNpZGVyIGFib3V0IHN1cnJvZ2F0ZSBwYWlyIChhbmQgSVZTKS4KY2lmc191dGYxNl9ieXRl
cygpCmNpZnNfbWFwY2hhcigpCmNpZnNfZnJvbV91dGYxNigpCmNpZnNDb252ZXJ0VG9VVEYx
NigpCgoKUmVwb3J0ZWQtYnk6IE5ha2FqaW1hIEFraXJhIDxuYWthamltYS5ha2lyYUBudHRj
b20uY28uanA+ClNpZ25lZC1vZmYtYnk6IE5ha2FqaW1hIEFraXJhIDxuYWthamltYS5ha2ly
YUBudHRjb20uY28uanA+CgotLS0KIGZzL2NpZnMvY2lmc191bmljb2RlLmMgfCAgMTgyICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLQogMSBmaWxl
cyBjaGFuZ2VkLCAxMzYgaW5zZXJ0aW9ucygrKSwgNDYgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9jaWZzX3VuaWNvZGUuYyBiL2ZzL2NpZnMvY2lmc191bmljb2RlLmMK
aW5kZXggMDMwM2M2Ny4uNWE1M2FjNiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX3VuaWNv
ZGUuYworKysgYi9mcy9jaWZzL2NpZnNfdW5pY29kZS5jCkBAIC0yNyw0MSArMjcsNiBAQAog
I2luY2x1ZGUgImNpZnNnbG9iLmgiCiAjaW5jbHVkZSAiY2lmc19kZWJ1Zy5oIgogCi0vKgot
ICogY2lmc191dGYxNl9ieXRlcyAtIGhvdyBsb25nIHdpbGwgYSBzdHJpbmcgYmUgYWZ0ZXIg
Y29udmVyc2lvbj8KLSAqIEB1dGYxNiAtIHBvaW50ZXIgdG8gaW5wdXQgc3RyaW5nCi0gKiBA
bWF4Ynl0ZXMgLSBkb24ndCBnbyBwYXN0IHRoaXMgbWFueSBieXRlcyBvZiBpbnB1dCBzdHJp
bmcKLSAqIEBjb2RlcGFnZSAtIGRlc3RpbmF0aW9uIGNvZGVwYWdlCi0gKgotICogV2FsayBh
IHV0ZjE2bGUgc3RyaW5nIGFuZCByZXR1cm4gdGhlIG51bWJlciBvZiBieXRlcyB0aGF0IHRo
ZSBzdHJpbmcgd2lsbAotICogYmUgYWZ0ZXIgYmVpbmcgY29udmVydGVkIHRvIHRoZSBnaXZl
biBjaGFyc2V0LCBub3QgaW5jbHVkaW5nIGFueSBudWxsCi0gKiB0ZXJtaW5hdGlvbiByZXF1
aXJlZC4gRG9uJ3Qgd2FsayBwYXN0IG1heGJ5dGVzIGluIHRoZSBzb3VyY2UgYnVmZmVyLgot
ICovCi1pbnQKLWNpZnNfdXRmMTZfYnl0ZXMoY29uc3QgX19sZTE2ICpmcm9tLCBpbnQgbWF4
Ynl0ZXMsCi0JCWNvbnN0IHN0cnVjdCBubHNfdGFibGUgKmNvZGVwYWdlKQotewotCWludCBp
OwotCWludCBjaGFybGVuLCBvdXRsZW4gPSAwOwotCWludCBtYXh3b3JkcyA9IG1heGJ5dGVz
IC8gMjsKLQljaGFyIHRtcFtOTFNfTUFYX0NIQVJTRVRfU0laRV07Ci0JX191MTYgZnRtcDsK
LQotCWZvciAoaSA9IDA7IGkgPCBtYXh3b3JkczsgaSsrKSB7Ci0JCWZ0bXAgPSBnZXRfdW5h
bGlnbmVkX2xlMTYoJmZyb21baV0pOwotCQlpZiAoZnRtcCA9PSAwKQotCQkJYnJlYWs7Ci0K
LQkJY2hhcmxlbiA9IGNvZGVwYWdlLT51bmkyY2hhcihmdG1wLCB0bXAsIE5MU19NQVhfQ0hB
UlNFVF9TSVpFKTsKLQkJaWYgKGNoYXJsZW4gPiAwKQotCQkJb3V0bGVuICs9IGNoYXJsZW47
Ci0JCWVsc2UKLQkJCW91dGxlbisrOwotCX0KLQotCXJldHVybiBvdXRsZW47Ci19Ci0KIGlu
dCBjaWZzX3JlbWFwKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IpCiB7CiAJaW50IG1h
cF90eXBlOwpAQCAtMTU1LDEwICsxMjAsMTMgQEAgY29udmVydF9zZm1fY2hhcihjb25zdCBf
X3UxNiBzcmNfY2hhciwgY2hhciAqdGFyZ2V0KQogICogZW5vdWdoIHRvIGhvbGQgdGhlIHJl
c3VsdCBvZiB0aGUgY29udmVyc2lvbiAoYXQgbGVhc3QgTkxTX01BWF9DSEFSU0VUX1NJWkUp
LgogICovCiBzdGF0aWMgaW50Ci1jaWZzX21hcGNoYXIoY2hhciAqdGFyZ2V0LCBjb25zdCBf
X3UxNiBzcmNfY2hhciwgY29uc3Qgc3RydWN0IG5sc190YWJsZSAqY3AsCitjaWZzX21hcGNo
YXIoY2hhciAqdGFyZ2V0LCBjb25zdCBfX3UxNiAqZnJvbSwgY29uc3Qgc3RydWN0IG5sc190
YWJsZSAqY3AsCiAJICAgICBpbnQgbWFwdHlwZSkKIHsKIAlpbnQgbGVuID0gMTsKKwlfX3Ux
NiBzcmNfY2hhcjsKKworCXNyY19jaGFyID0gKmZyb207CiAKIAlpZiAoKG1hcHR5cGUgPT0g
U0ZNX01BUF9VTklfUlNWRCkgJiYgY29udmVydF9zZm1fY2hhcihzcmNfY2hhciwgdGFyZ2V0
KSkKIAkJcmV0dXJuIGxlbjsKQEAgLTE2OCwxMCArMTM2LDIzIEBAIGNpZnNfbWFwY2hhcihj
aGFyICp0YXJnZXQsIGNvbnN0IF9fdTE2IHNyY19jaGFyLCBjb25zdCBzdHJ1Y3QgbmxzX3Rh
YmxlICpjcCwKIAogCS8qIGlmIGNoYXJhY3RlciBub3Qgb25lIG9mIHNldmVuIGluIHNwZWNp
YWwgcmVtYXAgc2V0ICovCiAJbGVuID0gY3AtPnVuaTJjaGFyKHNyY19jaGFyLCB0YXJnZXQs
IE5MU19NQVhfQ0hBUlNFVF9TSVpFKTsKLQlpZiAobGVuIDw9IDApIHsKLQkJKnRhcmdldCA9
ICc/JzsKLQkJbGVuID0gMTsKLQl9CisJaWYgKGxlbiA8PSAwKQorCQlnb3RvIHN1cnJvZ2F0
ZV9wYWlyOworCisJcmV0dXJuIGxlbjsKKworc3Vycm9nYXRlX3BhaXI6CisJLyogY29udmVy
dCBTVVJST0dBVEVfUEFJUiBhbmQgSVZTICovCisJaWYgKHN0cmNtcChjcC0+Y2hhcnNldCwg
InV0ZjgiKSkKKwkJZ290byB1bmtub3duOworCWxlbiA9IHV0ZjE2c190b191dGY4cyhmcm9t
LCAzLCBVVEYxNl9MSVRUTEVfRU5ESUFOLCB0YXJnZXQsIDYpOworCWlmIChsZW4gPD0gMCkK
KwkJZ290byB1bmtub3duOworCXJldHVybiBsZW47CisKK3Vua25vd246CisJKnRhcmdldCA9
ICc/JzsKKwlsZW4gPSAxOwogCXJldHVybiBsZW47CiB9CiAKQEAgLTIwNiw3ICsxODcsNyBA
QCBjaWZzX2Zyb21fdXRmMTYoY2hhciAqdG8sIGNvbnN0IF9fbGUxNiAqZnJvbSwgaW50IHRv
bGVuLCBpbnQgZnJvbWxlbiwKIAlpbnQgbnVsbHNpemUgPSBubHNfbnVsbHNpemUoY29kZXBh
Z2UpOwogCWludCBmcm9td29yZHMgPSBmcm9tbGVuIC8gMjsKIAljaGFyIHRtcFtOTFNfTUFY
X0NIQVJTRVRfU0laRV07Ci0JX191MTYgZnRtcDsKKwlfX3UxNiBmdG1wWzNdOwkJLyogZnRt
cFszXSA9IDNhcnJheSB4IDJieXRlcyA9IDZieXRlcyBVVEYtMTYgKi8KIAogCS8qCiAJICog
YmVjYXVzZSB0aGUgY2hhcnMgY2FuIGJlIG9mIHZhcnlpbmcgd2lkdGhzLCB3ZSBuZWVkIHRv
IHRha2UgY2FyZQpAQCAtMjE3LDkgKzE5OCwxNyBAQCBjaWZzX2Zyb21fdXRmMTYoY2hhciAq
dG8sIGNvbnN0IF9fbGUxNiAqZnJvbSwgaW50IHRvbGVuLCBpbnQgZnJvbWxlbiwKIAlzYWZl
bGVuID0gdG9sZW4gLSAoTkxTX01BWF9DSEFSU0VUX1NJWkUgKyBudWxsc2l6ZSk7CiAKIAlm
b3IgKGkgPSAwOyBpIDwgZnJvbXdvcmRzOyBpKyspIHsKLQkJZnRtcCA9IGdldF91bmFsaWdu
ZWRfbGUxNigmZnJvbVtpXSk7Ci0JCWlmIChmdG1wID09IDApCisJCWZ0bXBbMF0gPSBnZXRf
dW5hbGlnbmVkX2xlMTYoJmZyb21baV0pOworCQlpZiAoZnRtcFswXSA9PSAwKQogCQkJYnJl
YWs7CisJCWlmIChpICsgMSA8IGZyb213b3JkcykKKwkJCWZ0bXBbMV0gPSBnZXRfdW5hbGln
bmVkX2xlMTYoJmZyb21baSArIDFdKTsKKwkJZWxzZQorCQkJZnRtcFsxXSA9IDA7CisJCWlm
IChpICsgMiA8IGZyb213b3JkcykKKwkJCWZ0bXBbMl0gPSBnZXRfdW5hbGlnbmVkX2xlMTYo
JmZyb21baSArIDJdKTsKKwkJZWxzZQorCQkJZnRtcFsyXSA9IDA7CiAKIAkJLyoKIAkJICog
Y2hlY2sgdG8gc2VlIGlmIGNvbnZlcnRpbmcgdGhpcyBjaGFyYWN0ZXIgbWlnaHQgbWFrZSB0
aGUKQEAgLTIzNCw2ICsyMjMsMTcgQEAgY2lmc19mcm9tX3V0ZjE2KGNoYXIgKnRvLCBjb25z
dCBfX2xlMTYgKmZyb20sIGludCB0b2xlbiwgaW50IGZyb21sZW4sCiAJCS8qIHB1dCBjb252
ZXJ0ZWQgY2hhciBpbnRvICd0bycgYnVmZmVyICovCiAJCWNoYXJsZW4gPSBjaWZzX21hcGNo
YXIoJnRvW291dGxlbl0sIGZ0bXAsIGNvZGVwYWdlLCBtYXBfdHlwZSk7CiAJCW91dGxlbiAr
PSBjaGFybGVuOworCisJCS8qIGNoYXJsZW4gKD1ieXRlcyBvZiBVVEYtOCBmb3IgMSBjaGFy
YWN0ZXIpCisJCSAqIDRieXRlcyBVVEYtOChzdXJyb2dhdGUgcGFpcikgaXMgY2hhcmxlbj00
CisJCSAqICAgKDRieXRlcyBVVEYtMTYgY29kZSkKKwkJICogNy04Ynl0ZXMgVVRGLTgoSVZT
KSBpcyBjaGFybGVuPTMrNCBvciA0KzQKKwkJICogICAoMiBVVEYtOCBwYWlycyBkaXZpZGVk
IHRvIDIgVVRGLTE2IHBhaXJzKSAqLworCQlpZiAoY2hhcmxlbiA9PSA0KQorCQkJaSsrOwor
CQllbHNlIGlmIChjaGFybGVuID49IDUpCisJCQkvKiA1LTZieXRlcyBVVEYtOCAqLworCQkJ
aSArPSAyOwogCX0KIAogCS8qIHByb3Blcmx5IG51bGwtdGVybWluYXRlIHN0cmluZyAqLwpA
QCAtMjk2LDYgKzI5Niw0NiBAQCBzdWNjZXNzOgogfQogCiAvKgorICogY2lmc191dGYxNl9i
eXRlcyAtIGhvdyBsb25nIHdpbGwgYSBzdHJpbmcgYmUgYWZ0ZXIgY29udmVyc2lvbj8KKyAq
IEB1dGYxNiAtIHBvaW50ZXIgdG8gaW5wdXQgc3RyaW5nCisgKiBAbWF4Ynl0ZXMgLSBkb24n
dCBnbyBwYXN0IHRoaXMgbWFueSBieXRlcyBvZiBpbnB1dCBzdHJpbmcKKyAqIEBjb2RlcGFn
ZSAtIGRlc3RpbmF0aW9uIGNvZGVwYWdlCisgKgorICogV2FsayBhIHV0ZjE2bGUgc3RyaW5n
IGFuZCByZXR1cm4gdGhlIG51bWJlciBvZiBieXRlcyB0aGF0IHRoZSBzdHJpbmcgd2lsbAor
ICogYmUgYWZ0ZXIgYmVpbmcgY29udmVydGVkIHRvIHRoZSBnaXZlbiBjaGFyc2V0LCBub3Qg
aW5jbHVkaW5nIGFueSBudWxsCisgKiB0ZXJtaW5hdGlvbiByZXF1aXJlZC4gRG9uJ3Qgd2Fs
ayBwYXN0IG1heGJ5dGVzIGluIHRoZSBzb3VyY2UgYnVmZmVyLgorICovCitpbnQKK2NpZnNf
dXRmMTZfYnl0ZXMoY29uc3QgX19sZTE2ICpmcm9tLCBpbnQgbWF4Ynl0ZXMsCisJCWNvbnN0
IHN0cnVjdCBubHNfdGFibGUgKmNvZGVwYWdlKQoreworCWludCBpOworCWludCBjaGFybGVu
LCBvdXRsZW4gPSAwOworCWludCBtYXh3b3JkcyA9IG1heGJ5dGVzIC8gMjsKKwljaGFyIHRt
cFtOTFNfTUFYX0NIQVJTRVRfU0laRV07CisJX191MTYgZnRtcFszXTsKKworCWZvciAoaSA9
IDA7IGkgPCBtYXh3b3JkczsgaSsrKSB7CisJCWZ0bXBbMF0gPSBnZXRfdW5hbGlnbmVkX2xl
MTYoJmZyb21baV0pOworCQlpZiAoZnRtcFswXSA9PSAwKQorCQkJYnJlYWs7CisJCWlmIChp
ICsgMSA8IG1heHdvcmRzKQorCQkJZnRtcFsxXSA9IGdldF91bmFsaWduZWRfbGUxNigmZnJv
bVtpICsgMV0pOworCQllbHNlCisJCQlmdG1wWzFdID0gMDsKKwkJaWYgKGkgKyAyIDwgbWF4
d29yZHMpCisJCQlmdG1wWzJdID0gZ2V0X3VuYWxpZ25lZF9sZTE2KCZmcm9tW2kgKyAyXSk7
CisJCWVsc2UKKwkJCWZ0bXBbMl0gPSAwOworCisJCWNoYXJsZW4gPSBjaWZzX21hcGNoYXIo
dG1wLCBmdG1wLCBjb2RlcGFnZSwgTk9fTUFQX1VOSV9SU1ZEKTsKKwkJb3V0bGVuICs9IGNo
YXJsZW47CisJfQorCisJcmV0dXJuIG91dGxlbjsKK30KKworLyoKICAqIGNpZnNfc3RybmR1
cF9mcm9tX3V0ZjE2IC0gY29weSBhIHN0cmluZyBmcm9tIHdpcmUgZm9ybWF0IHRvIHRoZSBs
b2NhbAogICogY29kZXBhZ2UKICAqIEBzcmMgLSBzb3VyY2Ugc3RyaW5nCkBAIC00MDksMTAg
KzQ0OSwxNSBAQCBjaWZzQ29udmVydFRvVVRGMTYoX19sZTE2ICp0YXJnZXQsIGNvbnN0IGNo
YXIgKnNvdXJjZSwgaW50IHNyY2xlbiwKIAljaGFyIHNyY19jaGFyOwogCV9fbGUxNiBkc3Rf
Y2hhcjsKIAl3Y2hhcl90IHRtcDsKKwl3Y2hhcl90ICp3Y2hhcl90bzsJLyogVVRGLTE2ICov
CisJaW50IHJldDsKKwl1bmljb2RlX3QgdTsKIAogCWlmIChtYXBfY2hhcnMgPT0gTk9fTUFQ
X1VOSV9SU1ZEKQogCQlyZXR1cm4gY2lmc19zdHJ0b1VURjE2KHRhcmdldCwgc291cmNlLCBQ
QVRIX01BWCwgY3ApOwogCisJd2NoYXJfdG8gPSBremFsbG9jKDYsIEdGUF9LRVJORUwpOwor
CiAJZm9yIChpID0gMDsgaSA8IHNyY2xlbjsgaisrKSB7CiAJCXNyY19jaGFyID0gc291cmNl
W2ldOwogCQljaGFybGVuID0gMTsKQEAgLTQ0MSwxMSArNDg2LDU1IEBAIGNpZnNDb252ZXJ0
VG9VVEYxNihfX2xlMTYgKnRhcmdldCwgY29uc3QgY2hhciAqc291cmNlLCBpbnQgc3JjbGVu
LAogCQkJICogaWYgbm8gbWF0Y2gsIHVzZSBxdWVzdGlvbiBtYXJrLCB3aGljaCBhdCBsZWFz
dCBpbgogCQkJICogc29tZSBjYXNlcyBzZXJ2ZXMgYXMgd2lsZCBjYXJkCiAJCQkgKi8KLQkJ
CWlmIChjaGFybGVuIDwgMSkgewotCQkJCWRzdF9jaGFyID0gY3B1X3RvX2xlMTYoMHgwMDNm
KTsKLQkJCQljaGFybGVuID0gMTsKKwkJCWlmIChjaGFybGVuID4gMCkKKwkJCQlnb3RvIGN0
b1VURjE2OworCisJCQkvKiBjb252ZXJ0IFNVUlJPR0FURV9QQUlSICovCisJCQlpZiAoc3Ry
Y21wKGNwLT5jaGFyc2V0LCAidXRmOCIpIHx8ICF3Y2hhcl90bykKKwkJCQlnb3RvIHVua25v
d247CisJCQlpZiAoKihzb3VyY2UgKyBpKSAmIDB4ODApIHsKKwkJCQljaGFybGVuID0gdXRm
OF90b191dGYzMihzb3VyY2UgKyBpLCA2LCAmdSk7CisJCQkJaWYgKGNoYXJsZW4gPCAwKQor
CQkJCQlnb3RvIHVua25vd247CisJCQl9IGVsc2UKKwkJCQlnb3RvIHVua25vd247CisJCQly
ZXQgID0gdXRmOHNfdG9fdXRmMTZzKHNvdXJjZSArIGksIGNoYXJsZW4sCisJCQkJCSAgICAg
ICBVVEYxNl9MSVRUTEVfRU5ESUFOLAorCQkJCQkgICAgICAgd2NoYXJfdG8sIDYpOworCQkJ
aWYgKHJldCA8IDApCisJCQkJZ290byB1bmtub3duOworCisJCQlpICs9IGNoYXJsZW47CisJ
CQlkc3RfY2hhciA9IGNwdV90b19sZTE2KCp3Y2hhcl90byk7CisJCQlpZiAoY2hhcmxlbiA8
PSAzKQorCQkJCS8qIDEtM2J5dGVzIFVURi04IHRvIDJieXRlcyBVVEYtMTYgKi8KKwkJCQlw
dXRfdW5hbGlnbmVkKGRzdF9jaGFyLCAmdGFyZ2V0W2pdKTsKKwkJCWVsc2UgaWYgKGNoYXJs
ZW4gPT0gNCkgeworCQkJCS8qIDRieXRlcyBVVEYtOChzdXJyb2dhdGUgcGFpcikgdG8gNGJ5
dGVzIFVURi0xNgorCQkJCSAqIDctOGJ5dGVzIFVURi04KElWUykgZGl2aWRlZCB0byAyIFVU
Ri0xNgorCQkJCSAqICAgKGNoYXJsZW49Mys0IG9yIDQrNCkgKi8KKwkJCQlwdXRfdW5hbGln
bmVkKGRzdF9jaGFyLCAmdGFyZ2V0W2pdKTsKKwkJCQlkc3RfY2hhciA9IGNwdV90b19sZTE2
KCood2NoYXJfdG8gKyAxKSk7CisJCQkJaisrOworCQkJCXB1dF91bmFsaWduZWQoZHN0X2No
YXIsICZ0YXJnZXRbal0pOworCQkJfSBlbHNlIGlmIChjaGFybGVuID49IDUpIHsKKwkJCQkv
KiA1LTZieXRlcyBVVEYtOCB0byA2Ynl0ZXMgVVRGLTE2ICovCisJCQkJcHV0X3VuYWxpZ25l
ZChkc3RfY2hhciwgJnRhcmdldFtqXSk7CisJCQkJZHN0X2NoYXIgPSBjcHVfdG9fbGUxNigq
KHdjaGFyX3RvICsgMSkpOworCQkJCWorKzsKKwkJCQlwdXRfdW5hbGlnbmVkKGRzdF9jaGFy
LCAmdGFyZ2V0W2pdKTsKKwkJCQlkc3RfY2hhciA9IGNwdV90b19sZTE2KCood2NoYXJfdG8g
KyAyKSk7CisJCQkJaisrOworCQkJCXB1dF91bmFsaWduZWQoZHN0X2NoYXIsICZ0YXJnZXRb
al0pOwogCQkJfQorCQkJY29udGludWU7CisKK3Vua25vd246CisJCQlkc3RfY2hhciA9IGNw
dV90b19sZTE2KDB4MDAzZik7CisJCQljaGFybGVuID0gMTsKIAkJfQorCitjdG9VVEYxNjoK
IAkJLyoKIAkJICogY2hhcmFjdGVyIG1heSB0YWtlIG1vcmUgdGhhbiBvbmUgYnl0ZSBpbiB0
aGUgc291cmNlIHN0cmluZywKIAkJICogYnV0IHdpbGwgdGFrZSBleGFjdGx5IHR3byBieXRl
cyBpbiB0aGUgdGFyZ2V0IHN0cmluZwpAQCAtNDU2LDYgKzU0NSw3IEBAIGNpZnNDb252ZXJ0
VG9VVEYxNihfX2xlMTYgKnRhcmdldCwgY29uc3QgY2hhciAqc291cmNlLCBpbnQgc3JjbGVu
LAogCiBjdG9VVEYxNl9vdXQ6CiAJcHV0X3VuYWxpZ25lZCgwLCAmdGFyZ2V0W2pdKTsgLyog
TnVsbCB0ZXJtaW5hdGUgdGFyZ2V0IHVuaWNvZGUgc3RyaW5nICovCisJa2ZyZWUod2NoYXJf
dG8pOwogCXJldHVybiBqOwogfQogCi0tIAoxLjcuMQoK
--------------060409080506040906010506--
