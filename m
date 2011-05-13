From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs: fix cifsConvertToUCS() for the mapchars case
Date: Fri, 13 May 2011 05:32:35 +0200
Message-ID: <1305257555-20656-2-git-send-email-metze@samba.org>
References: <1305257555-20656-1-git-send-email-metze@samba.org>
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305257555-20656-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit "cifs: fix unaligned accesses in cifsConvertToUCS"
(84cdf74e8096a10dd6acbb870dd404b92f07a756) does multiple steps
in just one commit (moving the function and changing it without testing).

put_unaligned_le16(temp, &target[j]); is never called for any codepoint
the goes via the 'default' switch statement. As a result we put
just zero (or maybe uninitialized) bytes into the target buffer,

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index fc0fd4f..b1ff0bd 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -276,6 +276,7 @@ cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
 		return cifs_strtoUCS(target, source, PATH_MAX, cp);
 
 	for (i = 0, j = 0; i < maxlen; j++) {
+		charlen = 1;
 		src_char = source[i];
 		switch (src_char) {
 		case 0:
@@ -315,18 +316,17 @@ cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
 				temp = 0x003f;
 				charlen = 1;
 			}
-			len_remaining -= charlen;
-			/*
-			 * character may take more than one byte in the source
-			 * string, but will take exactly two bytes in the
-			 * target string
-			 */
-			i += charlen;
-			continue;
+			break;
 		}
+		/*
+		 * character may take more than one byte in the source
+		 * string, but will take exactly two bytes in the
+		 * target string
+		 */
 		put_unaligned_le16(temp, &target[j]);
-		i++; /* move to next char in source string */
-		len_remaining--;
+		/* move to next char in source string */
+		i += charlen;
+		len_remaining -= charlen;
 	}
 
 ctoUCS_out:
-- 
1.7.0.4
