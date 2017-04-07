From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] CIFS: reconnect thread reschedule itself
Date: Fri, 7 Apr 2017 12:29:36 +0100
Message-ID: <db6a87eb7372072d4da844ca5b01496d60ed3baa.1491415908.git-series.germano.percossi@citrix.com>
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

In case of error, smb2_reconnect_server reschedule itself
with a delay, to avoid being too aggressive.

Signed-off-by: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index efe167c..17af75a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2177,6 +2177,9 @@ void smb2_reconnect_server(struct work_struct *work)
 	struct cifs_tcon *tcon, *tcon2;
 	struct list_head tmp_list;
 	int tcon_exist = false;
+	int rc;
+	int resched = false;
+
 
 	/* Prevent simultaneous reconnects that can corrupt tcon->rlist list */
 	mutex_lock(&server->reconnect_mutex);
@@ -2204,13 +2207,18 @@ void smb2_reconnect_server(struct work_struct *work)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		if (!smb2_reconnect(SMB2_INTERNAL_CMD, tcon))
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon);
+		if (!rc)
 			cifs_reopen_persistent_handles(tcon);
+		else
+			resched = true;
 		list_del_init(&tcon->rlist);
 		cifs_put_tcon(tcon);
 	}
 
 	cifs_dbg(FYI, "Reconnecting tcons finished\n");
+	if (resched)
+		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
 	mutex_unlock(&server->reconnect_mutex);
 
 	/* now we can safely release srv struct */
-- 
git-series 0.9.1
