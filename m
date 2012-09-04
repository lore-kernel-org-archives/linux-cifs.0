From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Fix endianness conversion
Date: Tue,  4 Sep 2012 15:50:34 +0400
Message-ID: <1346759434-3665-1-git-send-email-pshilovsky@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2pdu.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index c5fbfac..15dc8ee 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -96,7 +96,7 @@
  *
  */
 
-#define SMB2_HEADER_STRUCTURE_SIZE __constant_le16_to_cpu(64)
+#define SMB2_HEADER_STRUCTURE_SIZE __constant_cpu_to_le16(64)
 
 struct smb2_hdr {
 	__be32 smb2_buf_length;	/* big endian on wire */
@@ -140,7 +140,7 @@ struct smb2_pdu {
  *
  */
 
-#define SMB2_ERROR_STRUCTURE_SIZE2 __constant_le16_to_cpu(9)
+#define SMB2_ERROR_STRUCTURE_SIZE2 __constant_cpu_to_le16(9)
 
 struct smb2_err_rsp {
 	struct smb2_hdr hdr;
-- 
1.7.1
