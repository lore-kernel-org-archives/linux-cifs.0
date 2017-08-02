From: Long Li <longli@exchange.microsoft.com>
Subject: [[PATCH v1] 08/37] [CIFS] SMBD: Define packet format for SMBD data transfer message
Date: Wed,  2 Aug 2017 13:10:19 -0700
Message-ID: <1501704648-20159-9-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Define the packet format for a SMBD data packet with payload

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsrdma.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 78ce2bf..ed0ff54 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -78,6 +78,21 @@ enum smbd_message_type {
 	SMBD_TRANSFER_DATA,
 };
 
+#define SMB_DIRECT_RESPONSE_REQUESTED 0x0001
+
+// SMBD data transfer packet with payload [MS-SMBD] 2.2.3
+struct smbd_data_transfer {
+	__le16 credits_requested;
+	__le16 credits_granted;
+	__le16 flags;
+	__le16 reserved;
+	__le32 remaining_data_length;
+	__le32 data_offset;
+	__le32 data_length;
+	__le32 padding;
+	char buffer[0];
+} __packed;
+
 // The context for a SMBD response
 struct cifs_rdma_response {
 	struct cifs_rdma_info *info;
-- 
2.7.4
