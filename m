From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/16] cifs: clean up checkSMB
Date: Mon, 29 Aug 2011 07:16:49 -0400
Message-ID: <1314616624-5362-2-git-send-email-jlayton@redhat.com>
References: <1314616624-5362-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314616624-5362-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The variable names in this function are so ambiguous that it's very
difficult to know what it's doing. Rename them to make it a bit more
clear.

Also, remove a redundant length check. cifsd checks to make sure that
the rfclen isn't larger than the maximum frame size when it does the
receive.

Finally, change checkSMB to return a real error code (-EIO) when
it finds an error. That will help simplify some coming changes in the
callers.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/misc.c |   51 +++++++++++++++++++++++++--------------------------
 1 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 7c16933..4a1801b 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -420,19 +420,22 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 }
 
 int
-checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
+checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int total_read)
 {
-	__u32 len = be32_to_cpu(smb->smb_buf_length);
+	__u32 rfclen = be32_to_cpu(smb->smb_buf_length);
 	__u32 clc_len;  /* calculated length */
-	cFYI(0, "checkSMB Length: 0x%x, smb_buf_length: 0x%x", length, len);
+	cFYI(0, "checkSMB Length: 0x%x, smb_buf_length: 0x%x",
+		total_read, rfclen);
 
-	if (length < 2 + sizeof(struct smb_hdr)) {
-		if ((length >= sizeof(struct smb_hdr) - 1)
+	/* is this frame too small to even get to a BCC? */
+	if (total_read < 2 + sizeof(struct smb_hdr)) {
+		if ((total_read >= sizeof(struct smb_hdr) - 1)
 			    && (smb->Status.CifsError != 0)) {
+			/* it's an error return */
 			smb->WordCount = 0;
 			/* some error cases do not return wct and bcc */
 			return 0;
-		} else if ((length == sizeof(struct smb_hdr) + 1) &&
+		} else if ((total_read == sizeof(struct smb_hdr) + 1) &&
 				(smb->WordCount == 0)) {
 			char *tmp = (char *)smb;
 			/* Need to work around a bug in two servers here */
@@ -452,39 +455,35 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 		} else {
 			cERROR(1, "Length less than smb header size");
 		}
-		return 1;
-	}
-	if (len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, "smb length greater than MaxBufSize, mid=%d",
-				   smb->Mid);
-		return 1;
+		return -EIO;
 	}
 
+	/* otherwise, there is enough to get to the BCC */
 	if (check_smb_hdr(smb, mid))
-		return 1;
+		return -EIO;
 	clc_len = smbCalcSize(smb);
 
-	if (4 + len != length) {
+	if (4 + rfclen != total_read) {
 		cERROR(1, "Length read does not match RFC1001 length %d",
-			   len);
-		return 1;
+				rfclen);
+		return -EIO;
 	}
 
-	if (4 + len != clc_len) {
+	if (4 + rfclen != clc_len) {
 		/* check if bcc wrapped around for large read responses */
-		if ((len > 64 * 1024) && (len > clc_len)) {
+		if ((rfclen > 64 * 1024) && (rfclen > clc_len)) {
 			/* check if lengths match mod 64K */
-			if (((4 + len) & 0xFFFF) == (clc_len & 0xFFFF))
+			if (((4 + rfclen) & 0xFFFF) == (clc_len & 0xFFFF))
 				return 0; /* bcc wrapped */
 		}
 		cFYI(1, "Calculated size %u vs length %u mismatch for mid=%u",
-				clc_len, 4 + len, smb->Mid);
+				clc_len, 4 + rfclen, smb->Mid);
 
-		if (4 + len < clc_len) {
+		if (4 + rfclen < clc_len) {
 			cERROR(1, "RFC1001 size %u smaller than SMB for mid=%u",
-					len, smb->Mid);
-			return 1;
-		} else if (len > clc_len + 512) {
+					rfclen, smb->Mid);
+			return -EIO;
+		} else if (rfclen > clc_len + 512) {
 			/*
 			 * Some servers (Windows XP in particular) send more
 			 * data than the lengths in the SMB packet would
@@ -495,8 +494,8 @@ checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int length)
 			 * data to 512 bytes.
 			 */
 			cERROR(1, "RFC1001 size %u more than 512 bytes larger "
-				  "than SMB for mid=%u", len, smb->Mid);
-			return 1;
+				  "than SMB for mid=%u", rfclen, smb->Mid);
+			return -EIO;
 		}
 	}
 	return 0;
-- 
1.7.6
