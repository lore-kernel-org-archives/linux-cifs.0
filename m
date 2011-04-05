From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: clean up various nits in unicode routines (try #2)
Date: Tue,  5 Apr 2011 15:02:37 -0400
Message-ID: <1302030157-5486-1-git-send-email-jlayton@redhat.com>
References: <BANLkTino1a1Wr55BCynPGK176Zbm5DPcXw@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTino1a1Wr55BCynPGK176Zbm5DPcXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Minor revision to the original patch. Don't abuse the __le16 variable
on the stack by casting it to wchar_t and handing it off to char2uni.
Declare an actual wchar_t on the stack instead. This fixes a valid
sparse warning.

Fix the spelling of UNI_ASTERISK. Eliminate the unneeded len_remaining
variable in cifsConvertToUCS.

Also, as David Howells points out. We were better off making
cifsConvertToUCS *not* use put_unaligned_le16 since it means that we
can't optimize the mapped characters at compile time. Switch them
instead to use cpu_to_le16, and simply use put_unaligned to set them
in the string.

Reported-and-acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   35 +++++++++++++++++------------------
 fs/cifs/cifs_unicode.h |    2 +-
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 9dd2682..d8e93b0 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -90,7 +90,7 @@ cifs_mapchar(char *target, const __u16 src_char, const struct nls_table *cp,
 	case UNI_COLON:
 		*target = ':';
 		break;
-	case UNI_ASTERIK:
+	case UNI_ASTERISK:
 		*target = '*';
 		break;
 	case UNI_QUESTION:
@@ -264,40 +264,40 @@ cifs_strndup_from_ucs(const char *src, const int maxlen, const bool is_unicode,
  * names are little endian 16 bit Unicode on the wire
  */
 int
-cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
+cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 		 const struct nls_table *cp, int mapChars)
 {
 	int i, j, charlen;
-	int len_remaining = maxlen;
 	char src_char;
-	__u16 temp;
+	__le16 dst_char;
+	wchar_t tmp;
 
 	if (!mapChars)
 		return cifs_strtoUCS(target, source, PATH_MAX, cp);
 
-	for (i = 0, j = 0; i < maxlen; j++) {
+	for (i = 0, j = 0; i < srclen; j++) {
 		src_char = source[i];
 		switch (src_char) {
 		case 0:
-			put_unaligned_le16(0, &target[j]);
+			put_unaligned(0, &target[j]);
 			goto ctoUCS_out;
 		case ':':
-			temp = UNI_COLON;
+			dst_char = cpu_to_le16(UNI_COLON);
 			break;
 		case '*':
-			temp = UNI_ASTERIK;
+			dst_char = cpu_to_le16(UNI_ASTERISK);
 			break;
 		case '?':
-			temp = UNI_QUESTION;
+			dst_char = cpu_to_le16(UNI_QUESTION);
 			break;
 		case '<':
-			temp = UNI_LESSTHAN;
+			dst_char = cpu_to_le16(UNI_LESSTHAN);
 			break;
 		case '>':
-			temp = UNI_GRTRTHAN;
+			dst_char = cpu_to_le16(UNI_GRTRTHAN);
 			break;
 		case '|':
-			temp = UNI_PIPE;
+			dst_char = cpu_to_le16(UNI_PIPE);
 			break;
 		/*
 		 * FIXME: We can not handle remapping backslash (UNI_SLASH)
@@ -305,17 +305,17 @@ cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
 		 * as they use backslash as separator.
 		 */
 		default:
-			charlen = cp->char2uni(source+i, len_remaining,
-						&temp);
+			charlen = cp->char2uni(source + i, srclen - i, &tmp);
+			dst_char = cpu_to_le16(tmp);
+
 			/*
 			 * if no match, use question mark, which at least in
 			 * some cases serves as wild card
 			 */
 			if (charlen < 1) {
-				temp = 0x003f;
+				dst_char = cpu_to_le16(0x003f);
 				charlen = 1;
 			}
-			len_remaining -= charlen;
 			/*
 			 * character may take more than one byte in the source
 			 * string, but will take exactly two bytes in the
@@ -324,9 +324,8 @@ cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
 			i += charlen;
 			continue;
 		}
-		put_unaligned_le16(temp, &target[j]);
+		put_unaligned(dst_char, &target[j]);
 		i++; /* move to next char in source string */
-		len_remaining--;
 	}
 
 ctoUCS_out:
diff --git a/fs/cifs/cifs_unicode.h b/fs/cifs/cifs_unicode.h
index cc9628b..e00f677 100644
--- a/fs/cifs/cifs_unicode.h
+++ b/fs/cifs/cifs_unicode.h
@@ -44,7 +44,7 @@
  * reserved symbols (along with \ and /), otherwise illegal to store
  * in filenames in NTFS
  */
-#define UNI_ASTERIK     (__u16) ('*' + 0xF000)
+#define UNI_ASTERISK    (__u16) ('*' + 0xF000)
 #define UNI_QUESTION    (__u16) ('?' + 0xF000)
 #define UNI_COLON       (__u16) (':' + 0xF000)
 #define UNI_GRTRTHAN    (__u16) ('>' + 0xF000)
-- 
1.7.4
