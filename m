From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 1/6] fs/cifs: add smb2 fsctl payloads for DFS resolving
Date: Tue,  8 Nov 2016 17:33:21 +0100
Message-ID: <1478622806-19636-2-git-send-email-aaptel@suse.com>
References: <1478622806-19636-1-git-send-email-aaptel@suse.com>
Cc: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478622806-19636-1-git-send-email-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/smb2pdu.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index fd3709e..a94a1bd 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -681,6 +681,21 @@ struct fsctl_get_integrity_information_rsp {
 /* Integrity flags for above */
 #define FSCTL_INTEGRITY_FLAG_CHECKSUM_ENFORCEMENT_OFF	0x00000001
 
+/* See MS-DFSC 2.2.2 */
+struct fsctl_get_dfs_referral_req {
+	__le16 MaxReferralLevel;
+	__u8 RequestFileName[];
+} __packed;
+
+struct fsctl_get_dfs_referral_rsp {
+	__le16 PathConsumed;
+	__le16 NumberOfReferrals;
+	__le32 ReferralHeaderFlags;
+	__u8 buffer[];
+} __packed;
+
+/* reusing struct dfs_referral_level_3 */
+
 /* See MS-SMB2 2.2.31.3 */
 struct network_resiliency_req {
 	__le32 Timeout;
-- 
2.1.4
