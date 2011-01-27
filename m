From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix length checks in checkSMB
Date: Thu, 27 Jan 2011 07:45:05 -0500
Message-ID: <1296132305-21872-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The cERROR message in checkSMB when the calculated length doesn't match
the RFC1001 length is incorrect in many cases. It always says that the
RFC1001 length is bigger than the SMB, even when it's actually the
reverse.

Fix the error message to say the reverse of what it does now and remove
the arbitrary check when an RFC1001 length is larger than the SMB.
There's no reason to reject those packets since we can just ignore the
junk that's hanging off the end.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/misc.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 72e99ec..959d629 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -467,23 +467,10 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
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
+		if (4+len < clc_len) {
+			cERROR(1, "RFC1001 size %d smaller than SMB for mid=%u",
 					len, smb->Mid);
 			return 1;
 		}
-- 
1.7.3.4
