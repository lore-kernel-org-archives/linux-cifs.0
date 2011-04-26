From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] cifs: change bleft in decode_unicode_ssetup back to signed type
Date: Tue, 26 Apr 2011 08:03:17 -0400
Message-ID: <1303819401-14789-2-git-send-email-jlayton@redhat.com>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303819401-14789-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The buffer length checks in this function depend on this value being a
signed data type, but 690c522fa converted it to an unsigned type.

Also, eliminate a problem with the null termination check in the same
function. cifs_strndup_from_ucs handles that situation correctly
already, and the existing check could potentially lead to a buffer
overrun since it increments bleft without checking to see whether it
falls off the end of the buffer.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Reported-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index f6728eb..2e2c911 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -276,7 +276,7 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifsSesInfo *ses,
 }
 
 static void
-decode_unicode_ssetup(char **pbcc_area, __u16 bleft, struct cifsSesInfo *ses,
+decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifsSesInfo *ses,
 		      const struct nls_table *nls_cp)
 {
 	int len;
@@ -284,19 +284,6 @@ decode_unicode_ssetup(char **pbcc_area, __u16 bleft, struct cifsSesInfo *ses,
 
 	cFYI(1, "bleft %d", bleft);
 
-	/*
-	 * Windows servers do not always double null terminate their final
-	 * Unicode string. Check to see if there are an uneven number of bytes
-	 * left. If so, then add an extra NULL pad byte to the end of the
-	 * response.
-	 *
-	 * See section 2.7.2 in "Implementing CIFS" for details
-	 */
-	if (bleft % 2) {
-		data[bleft] = 0;
-		++bleft;
-	}
-
 	kfree(ses->serverOS);
 	ses->serverOS = cifs_strndup_from_ucs(data, bleft, true, nls_cp);
 	cFYI(1, "serverOS=%s", ses->serverOS);
-- 
1.7.4.4
