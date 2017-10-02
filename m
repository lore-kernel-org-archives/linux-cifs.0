From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v4 16/22] CIFS: SMBD: Fix the definition for SMB2_CHANNEL_RDMA_V1_INVALIDATE
Date: Sun,  1 Oct 2017 19:30:24 -0700
Message-ID: <20171002023030.3582-17-longli@exchange.microsoft.com>
References: <20171002023030.3582-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171002023030.3582-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

The channel value for requesting server remote invalidating local memory
registration should be 0x00000002

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 393ed5f..f783a08 100644
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
