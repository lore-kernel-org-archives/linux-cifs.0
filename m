From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] CIFS: Fix log messages in packet checking for SMB2
Date: Fri, 17 Aug 2012 18:43:49 +0400
Message-ID: <1345214629-11059-2-git-send-email-pshilovsky@samba.org>
References: <1345214629-11059-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345214629-11059-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2misc.c |   16 +++++++++-------
 fs/cifs/smb2pdu.h  |   10 ++++++----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index a4ff5d5..e4d3b99 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -52,7 +52,8 @@ check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
 			cERROR(1, "Bad protocol string signature header %x",
 				  *(unsigned int *) hdr->ProtocolId);
 		if (mid != hdr->MessageId)
-			cERROR(1, "Mids do not match");
+			cERROR(1, "Mids do not match: %llu and %llu", mid,
+				  hdr->MessageId);
 	}
 	cERROR(1, "Bad SMB detected. The Mid=%llu", hdr->MessageId);
 	return 1;
@@ -107,7 +108,7 @@ smb2_check_message(char *buf, unsigned int length)
 	 * ie Validate the wct via smb2_struct_sizes table above
 	 */
 
-	if (length < 2 + sizeof(struct smb2_hdr)) {
+	if (length < sizeof(struct smb2_pdu)) {
 		if ((length >= sizeof(struct smb2_hdr)) && (hdr->Status != 0)) {
 			pdu->StructureSize2 = 0;
 			/*
@@ -121,15 +122,15 @@ smb2_check_message(char *buf, unsigned int length)
 		return 1;
 	}
 	if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - 4) {
-		cERROR(1, "SMB length greater than maximum, mid=%lld", mid);
+		cERROR(1, "SMB length greater than maximum, mid=%llu", mid);
 		return 1;
 	}
 
 	if (check_smb2_hdr(hdr, mid))
 		return 1;
 
-	if (hdr->StructureSize != SMB2_HEADER_SIZE) {
-		cERROR(1, "Illegal structure size %d",
+	if (hdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
+		cERROR(1, "Illegal structure size %u",
 			  le16_to_cpu(hdr->StructureSize));
 		return 1;
 	}
@@ -161,8 +162,9 @@ smb2_check_message(char *buf, unsigned int length)
 	if (4 + len != clc_len) {
 		cFYI(1, "Calculated size %u length %u mismatch mid %llu",
 			clc_len, 4 + len, mid);
-		if (clc_len == 4 + len + 1) /* BB FIXME (fix samba) */
-			return 0; /* BB workaround Samba 3 bug SessSetup rsp */
+		/* server can return one byte more */
+		if (clc_len == 4 + len + 1)
+			return 0;
 		return 1;
 	}
 	return 0;
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f37a1b4..c5fbfac 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -87,10 +87,6 @@
 
 #define SMB2_PROTO_NUMBER __constant_cpu_to_le32(0x424d53fe)
 
-#define SMB2_HEADER_SIZE __constant_le16_to_cpu(64)
-
-#define SMB2_ERROR_STRUCTURE_SIZE2 __constant_le16_to_cpu(9)
-
 /*
  * SMB2 Header Definition
  *
@@ -99,6 +95,9 @@
  * "PDU" :  "Protocol Data Unit" (ie a network "frame")
  *
  */
+
+#define SMB2_HEADER_STRUCTURE_SIZE __constant_le16_to_cpu(64)
+
 struct smb2_hdr {
 	__be32 smb2_buf_length;	/* big endian on wire */
 				/* length is only two or three bytes - with
@@ -140,6 +139,9 @@ struct smb2_pdu {
  *  command code name for the struct. Note that structures must be packed.
  *
  */
+
+#define SMB2_ERROR_STRUCTURE_SIZE2 __constant_le16_to_cpu(9)
+
 struct smb2_err_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize;
-- 
1.7.1
