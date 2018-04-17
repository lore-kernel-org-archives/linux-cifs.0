From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 1/6] cifs: smbd: Check for iov length on sending the last iov
Date: Mon, 16 Apr 2018 17:49:13 -0700
Message-ID: <20180417004918.29213-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, stable@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When sending the last iov that breaks into smaller buffers to fit the
transfer size, it's necessary to check if this is the last iov.

If this is the latest iov, stop and proceed to send pages.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 90e673c..b5c6c0d 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2197,6 +2197,8 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
 						goto done;
 				}
 				i++;
+				if (i == rqst->rq_nvec)
+					break;
 			}
 			start = i;
 			buflen = 0;
-- 
2.7.4
