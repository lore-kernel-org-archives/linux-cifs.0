From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v3 12/19] CIFS: SMBD: Fix the definition for SMB2_CHANNEL_RDMA_V1_INVALIDATE
Date: Tue, 29 Aug 2017 12:29:08 -0700
Message-ID: <20170829192915.26251-13-longli@exchange.microsoft.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829192915.26251-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

The channel value for requesting server remote invalidating local memory
registration should be 0x00000002

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2pdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 18700fd..0417a36 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -832,7 +832,7 @@ struct smb2_flush_rsp {
 /* Channel field for read and write: exactly one of following flags can be set*/
 #define SMB2_CHANNEL_NONE		0x00000000
 #define SMB2_CHANNEL_RDMA_V1		0x00000001 /* SMB3 or later */
-#define SMB2_CHANNEL_RDMA_V1_INVALIDATE 0x00000001 /* SMB3.02 or later */
+#define SMB2_CHANNEL_RDMA_V1_INVALIDATE 0x00000002 /* SMB3.02 or later */
 
 /* SMB2 read request without RFC1001 length at the beginning */
 struct smb2_read_plain_req {
-- 
2.7.4
