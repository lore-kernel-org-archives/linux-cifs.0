From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 6/7] cifs: smbd: Retry on memory registration failure
Date: Mon,  7 May 2018 15:20:05 -0700
Message-ID: <20180507222006.20781-6-longli@linuxonhyperv.com>
References: <20180507222006.20781-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507222006.20781-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Memory registration failure doesn't mean this I/O has failed, it means the
transport is hitting I/O error or needs reconnect. This error is not from
the server.

Indicate this error to upper layer, and let upper layer decide how to
reconnect and proceed with this I/O.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 09ca098..c72d1fa 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2617,7 +2617,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 				true, need_invalidate);
 		rcu_read_unlock();
 		if (!rdata->mr)
-			return -ENOBUFS;
+			return -EAGAIN;
 
 		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
 		if (need_invalidate)
@@ -2997,7 +2997,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 				false, need_invalidate);
 		rcu_read_unlock();
 		if (!wdata->mr) {
-			rc = -ENOBUFS;
+			rc = -EAGAIN;
 			goto async_writev_out;
 		}
 		req->Length = 0;
-- 
2.7.4
