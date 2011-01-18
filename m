From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] cifs: fix unaligned accesses in cifsConvertToUCS
Date: Tue, 18 Jan 2011 15:33:19 -0500
Message-ID: <1295382799-7902-6-git-send-email-jlayton@redhat.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Move cifsConvertToUCS to cifs_unicode.c where all of the other unicode
related functions live. Have it store mapped characters in 'temp' and
then use put_unaligned_le16 to copy it to the target buffer. Also fix
the comments to match kernel coding style.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/misc.c         |   71 --------------------------------------------
 2 files changed, 76 insertions(+), 71 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 8134443..6a5090d 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -257,3 +257,79 @@ cifs_strndup_from_ucs(const char *src, const int maxlen, const bool is_unicode,
 	return dst;
 }
 
+/*
+ * Convert 16 bit Unicode pathname to wire format from string in current code
+ * page. Conversion may involve remapping up the six characters that are
+ * only legal in POSIX-like OS (if they are present in the string). Path
+ * names are little endian 16 bit Unicode on the wire
+ */
+int
+cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
+		 const struct nls_table *cp, int mapChars)
+{
+	int i, j, charlen;
+	int len_remaining = maxlen;
+	char src_char;
+	__u16 temp;
+
+	if (!mapChars)
+		return cifs_strtoUCS(target, source, PATH_MAX, cp);
+
+	for (i = 0, j = 0; i < maxlen; j++) {
+		src_char = source[i];
+		switch (src_char) {
+		case 0:
+			put_unaligned_le16(0, &target[j]);
+			goto ctoUCS_out;
+		case ':':
+			temp = UNI_COLON;
+			break;
+		case '*':
+			temp = UNI_ASTERIK;
+			break;
+		case '?':
+			temp = UNI_QUESTION;
+			break;
+		case '<':
+			temp = UNI_LESSTHAN;
+			break;
+		case '>':
+			temp = UNI_GRTRTHAN;
+			break;
+		case '|':
+			temp = UNI_PIPE;
+			break;
+		/*
+		 * FIXME: We can not handle remapping backslash (UNI_SLASH)
+		 * until all the calls to build_path_from_dentry are modified,
+		 * as they use backslash as separator.
+		 */
+		default:
+			charlen = cp->char2uni(source+i, len_remaining,
+						&temp);
+			/*
+			 * if no match, use question mark, which at least in
+			 * some cases serves as wild card
+			 */
+			if (charlen < 1) {
+				temp = 0x003f;
+				charlen = 1;
+			}
+			len_remaining -= charlen;
+			/*
+			 * character may take more than one byte in the source
+			 * string, but will take exactly two bytes in the
+			 * target string
+			 */
+			i += charlen;
+			continue;
+		}
+		put_unaligned_le16(temp, &target[j]);
+		i++; /* move to next char in source string */
+		len_remaining--;
+	}
+
+ctoUCS_out:
+	return i;
+}
+
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index c1f2a51..2036757 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -626,77 +626,6 @@ dump_smb(struct smb_hdr *smb_buf, int smb_buf_length)
 	return;
 }
 
-/* Convert 16 bit Unicode pathname to wire format from string in current code
-   page.  Conversion may involve remapping up the seven characters that are
-   only legal in POSIX-like OS (if they are present in the string). Path
-   names are little endian 16 bit Unicode on the wire */
-int
-cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
-		 const struct nls_table *cp, int mapChars)
-{
-	int i, j, charlen;
-	int len_remaining = maxlen;
-	char src_char;
-	__u16 temp;
-
-	if (!mapChars)
-		return cifs_strtoUCS(target, source, PATH_MAX, cp);
-
-	for (i = 0, j = 0; i < maxlen; j++) {
-		src_char = source[i];
-		switch (src_char) {
-			case 0:
-				target[j] = 0;
-				goto ctoUCS_out;
-			case ':':
-				target[j] = cpu_to_le16(UNI_COLON);
-				break;
-			case '*':
-				target[j] = cpu_to_le16(UNI_ASTERIK);
-				break;
-			case '?':
-				target[j] = cpu_to_le16(UNI_QUESTION);
-				break;
-			case '<':
-				target[j] = cpu_to_le16(UNI_LESSTHAN);
-				break;
-			case '>':
-				target[j] = cpu_to_le16(UNI_GRTRTHAN);
-				break;
-			case '|':
-				target[j] = cpu_to_le16(UNI_PIPE);
-				break;
-			/* BB We can not handle remapping slash until
-			   all the calls to build_path_from_dentry
-			   are modified, as they use slash as separator BB */
-			/* case '\\':
-				target[j] = cpu_to_le16(UNI_SLASH);
-				break;*/
-			default:
-				charlen = cp->char2uni(source+i,
-					len_remaining, &temp);
-				/* if no match, use question mark, which
-				at least in some cases servers as wild card */
-				if (charlen < 1) {
-					target[j] = cpu_to_le16(0x003f);
-					charlen = 1;
-				} else
-					target[j] = cpu_to_le16(temp);
-				len_remaining -= charlen;
-				/* character may take more than one byte in the
-				   the source string, but will take exactly two
-				   bytes in the target string */
-				i += charlen;
-				continue;
-		}
-		i++; /* move to next char in source string */
-		len_remaining--;
-	}
-
-ctoUCS_out:
-	return i;
-}
-
 void
 cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 {
-- 
1.7.3.4
