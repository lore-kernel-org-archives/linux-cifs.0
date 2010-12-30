From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: simplify SMB header check routine
Date: Thu, 30 Dec 2010 08:36:34 -0500
Message-ID: <1293716194-23140-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/misc.c |   46 ++++++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index b3df037..c1f2a51 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -381,29 +381,31 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 }
 
 static int
-checkSMBhdr(struct smb_hdr *smb, __u16 mid)
+check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 {
-	/* Make sure that this really is an SMB, that it is a response,
-	   and that the message ids match */
-	if ((*(__le32 *) smb->Protocol == cpu_to_le32(0x424d53ff)) &&
-		(mid == smb->Mid)) {
-		if (smb->Flags & SMBFLG_RESPONSE)
-			return 0;
-		else {
-		/* only one valid case where server sends us request */
-			if (smb->Command == SMB_COM_LOCKING_ANDX)
-				return 0;
-			else
-				cERROR(1, "Received Request not response");
-		}
-	} else { /* bad signature or mid */
-		if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff))
-			cERROR(1, "Bad protocol string signature header %x",
-				*(unsigned int *) smb->Protocol);
-		if (mid != smb->Mid)
-			cERROR(1, "Mids do not match");
+	/* does it have the right SMB "signature" ? */
+	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
+		cERROR(1, "Bad protocol string signature header 0x%x",
+			*(unsigned int *)smb->Protocol);
+		return 1;
+	}
+
+	/* Make sure that message ids match */
+	if (mid != smb->Mid) {
+		cERROR(1, "Mids do not match. received=%u expected=%u",
+			smb->Mid, mid);
+		return 1;
 	}
-	cERROR(1, "bad smb detected. The Mid=%d", smb->Mid);
+
+	/* if it's a response then accept */
+	if (smb->Flags & SMBFLG_RESPONSE)
+		return 0;
+
+	/* only one valid case where server sends us request */
+	if (smb->Command == SMB_COM_LOCKING_ANDX)
+		return 0;
+
+	cERROR(1, "Server sent request, not response. mid=%u", smb->Mid);
 	return 1;
 }
 
@@ -448,7 +450,7 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 		return 1;
 	}
 
-	if (checkSMBhdr(smb, mid))
+	if (check_smb_hdr(smb, mid))
 		return 1;
 	clc_len = smbCalcSize_LE(smb);
 
-- 
1.7.3.4
