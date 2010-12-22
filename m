From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: just ignore extra junk at the end of the SMB
Date: Wed, 22 Dec 2010 08:39:07 -0500
Message-ID: <1293025147-11338-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the server sends us a RFC1001 length that's larger than the SMB,
then there's no reason to get our panties in a bunch and spew printk's,
and there's certainly no reason just ignore the response completely like
we do today. Just ignore the extra stuff on the end.

This fixes:

    https://bugzilla.samba.org/show_bug.cgi?id=7860

Reported-by: Marcus Schopen <marcus-dLPT46B32WUjnolme5KbmQ@public.gmane.org>
Tested-by: Burkhard Obergoeker <burkhard.obergoeker-VYBfkVvgaNUmRHQWxfeBDQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/misc.c |   25 ++++++-------------------
 1 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 43f1028..b3df037 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -465,26 +465,13 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 			if (((4 + len) & 0xFFFF) == (clc_len & 0xFFFF))
 				return 0; /* bcc wrapped */
 		}
-		cFYI(1, "Calculated size %d vs length %d mismatch for mid %d",
+
+		/*
+		 * We allow the server to send us an arbitrary amount of junk
+		 * at the end of the SMB. Just ignore it.
+		 */
+		cFYI(1, "Calculated size %u vs length %u mismatch for mid %u",
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
-					len, smb->Mid);
-			return 1;
-		}
 	}
 	return 0;
 }
-- 
1.7.3.3
