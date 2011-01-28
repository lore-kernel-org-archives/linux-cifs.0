From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix length checks in checkSMB (try #2)
Date: Fri, 28 Jan 2011 07:24:23 -0500
Message-ID: <1296217463-4584-1-git-send-email-jlayton@redhat.com>
References: <AANLkTimbuWJWAwbmCVVhFub4Y_Yg-QVXoqr96rGhqHd+@mail.gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimbuWJWAwbmCVVhFub4Y_Yg-QVXoqr96rGhqHd+-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The cERROR message in checkSMB when the calculated length doesn't match
the RFC1001 length is incorrect in many cases. It always says that the
RFC1001 length is bigger than the SMB, even when it's actually the
reverse.

Fix the error message to say the reverse of what it does now when the
SMB length goes beyond the end of the received data. Also, clarify the
error message when the RFC length is too big. Finally, clarify the
comments to show that the 512 byte limit on extra data at the end of
the packet is arbitrary.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/misc.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 72e99ec..77dc732 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -467,25 +467,26 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 			if (((4 + len) & 0xFFFF) == (clc_len & 0xFFFF))
 				return 0; /* bcc wrapped */
 		}
-		cFYI(1, "Calculated size %d vs length %d mismatch for mid %d",
+		cFYI(1, "Calculated size %u vs length %u mismatch for mid=%u",
 				clc_len, 4 + len, smb->Mid);
-		/* Windows XP can return a few bytes too much, presumably
-		an illegal pad, at the end of byte range lock responses
-		so we allow for that three byte pad, as long as actual
-		received length is as long or longer than calculated length */
-		/* We have now had to extend this more, since there is a
-		case in which it needs to be bigger still to handle a
-		malformed response to transact2 findfirst from WinXP when
-		access denied is returned and thus bcc and wct are zero
-		but server says length is 0x21 bytes too long as if the server
-		forget to reset the smb rfc1001 length when it reset the
-		wct and bcc to minimum size and drop the t2 parms and data */
-		if ((4+len > clc_len) && (len <= clc_len + 512))
-			return 0;
-		else {
-			cERROR(1, "RFC1001 size %d bigger than SMB for Mid=%d",
+
+		if (4 + len < clc_len) {
+			cERROR(1, "RFC1001 size %u smaller than SMB for mid=%u",
 					len, smb->Mid);
 			return 1;
+		} else if (len > clc_len + 512) {
+			/*
+			 * Some servers (Windows XP in particular) send more
+			 * data than the lengths in the SMB packet would
+			 * indicate on certain calls (byte range locks and
+			 * trans2 find first calls in particular). While the
+			 * client can handle such a frame by ignoring the
+			 * trailing data, we choose limit the amount of extra
+			 * data to 512 bytes.
+			 */
+			cERROR(1, "RFC1001 size %u more than 512 bytes larger "
+				  "than SMB for mid=%u", len, smb->Mid);
+			return 1;
 		}
 	}
 	return 0;
-- 
1.7.3.4
