From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/4] CIFS: queue 'reconnect' thread with a delay
Date: Fri, 7 Apr 2017 12:29:35 +0100
Message-ID: <e5001a2225ed3d175befd7203f06fdcf5b8a087d.1491415908.git-series.germano.percossi@citrix.com>
References: <cover.333fa5a2e4d6ba38ce99ad2ef69bf44685343ca0.1491415908.git-series.germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.333fa5a2e4d6ba38ce99ad2ef69bf44685343ca0.1491415908.git-series.germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

All the other threads are queue with a delay, no reason
why this one need to be so aggressive.

Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7446496..efe167c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -258,7 +258,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 		goto out;
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
-		queue_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
 
 	atomic_inc(&tconInfoReconnectCount);
 out:
@@ -2231,7 +2231,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 
 	if (server->tcpStatus == CifsNeedNegotiate) {
 		/* No need to send echo on newly established connections */
-		queue_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
 		return rc;
 	}
 
-- 
git-series 0.9.1
