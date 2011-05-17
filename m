From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix cifsConvertToUCS() for the mapchars case
Date: Tue, 17 May 2011 15:28:21 -0400
Message-ID: <1305660501-23587-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As Metze pointed out, commit 84cdf74e broke mapchars option:

    Commit "cifs: fix unaligned accesses in cifsConvertToUCS"
    (84cdf74e8096a10dd6acbb870dd404b92f07a756) does multiple steps
    in just one commit (moving the function and changing it without
    testing).

    put_unaligned_le16(temp, &target[j]); is never called for any
    codepoint the goes via the 'default' switch statement. As a result
    we put just zero (or maybe uninitialized) bytes into the target
    buffer.

His proposed patch looks correct, but doesn't apply to the current head
of the tree. This patch should also fix it.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> # .38.x: 581ade4: cifs: clean up various nits in unicode routines (try #2)
Reported-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 23d43cd..1b2e180 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -277,6 +277,7 @@ cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 
 	for (i = 0, j = 0; i < srclen; j++) {
 		src_char = source[i];
+		charlen = 1;
 		switch (src_char) {
 		case 0:
 			put_unaligned(0, &target[j]);
@@ -316,16 +317,13 @@ cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 				dst_char = cpu_to_le16(0x003f);
 				charlen = 1;
 			}
-			/*
-			 * character may take more than one byte in the source
-			 * string, but will take exactly two bytes in the
-			 * target string
-			 */
-			i += charlen;
-			continue;
 		}
+		/*
+		 * character may take more than one byte in the source string,
+		 * but will take exactly two bytes in the target string
+		 */
+		i += charlen;
 		put_unaligned(dst_char, &target[j]);
-		i++; /* move to next char in source string */
 	}
 
 ctoUCS_out:
-- 
1.7.4.4
