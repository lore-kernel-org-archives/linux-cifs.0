From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 20/31] fs/cifs: use kmemdup rather than duplicating its
 implementation
Date: Fri, 07 Aug 2015 09:59:26 +0200
Message-ID: <1438934377-4922-21-git-send-email-a.hajda@samsung.com>
References: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The patch was generated using fixed coccinelle semantic patch
scripts/coccinelle/api/memdup.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2014320

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 fs/cifs/smb2pdu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 070fb2a..2d6b72f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1394,14 +1394,13 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		goto ioctl_exit;
 	}
 
-	*out_data = kmalloc(*plen, GFP_KERNEL);
+	*out_data = kmemdup(rsp->hdr.ProtocolId + le32_to_cpu(rsp->OutputOffset),
+			    *plen, GFP_KERNEL);
 	if (*out_data == NULL) {
 		rc = -ENOMEM;
 		goto ioctl_exit;
 	}
 
-	memcpy(*out_data, rsp->hdr.ProtocolId + le32_to_cpu(rsp->OutputOffset),
-	       *plen);
 ioctl_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
-- 
1.9.1
