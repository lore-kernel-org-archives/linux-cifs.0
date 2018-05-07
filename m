From: Long Li <longli@linuxonhyperv.com>
Subject: [PATCH 4/7] cifs: smbd: Indicate to retry on transport sending failure
Date: Mon,  7 May 2018 15:20:03 -0700
Message-ID: <20180507222006.20781-4-longli@linuxonhyperv.com>
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

Failure to send a packet doesn't mean it's a permanent failure, it can't be
returned to user process. This I/O should be retried or failed based on
server packet response and transport health. This logic is handled by the
upper layer.

Give this decision to upper layer.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b8dd493..74620f5 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -851,7 +851,7 @@ static int smbd_create_header(struct smbd_connection *info,
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		log_outgoing(ERR, "disconnected not sending\n");
-		return -ENOENT;
+		return -EAGAIN;
 	}
 	atomic_dec(&info->send_credits);
 
@@ -977,6 +977,7 @@ static int smbd_post_send(struct smbd_connection *info,
 				wake_up(&info->wait_send_pending);
 		}
 		smbd_disconnect_rdma_connection(info);
+		rc = -EAGAIN;
 	} else
 		/* Reset timer for idle connection after packet is sent */
 		mod_delayed_work(info->workqueue, &info->idle_timer_work,
@@ -2062,7 +2063,7 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
 	int rc;
 
 	if (info->transport_status != SMBD_CONNECTED) {
-		rc = -ENODEV;
+		rc = -EAGAIN;
 		goto done;
 	}
 
-- 
2.7.4
