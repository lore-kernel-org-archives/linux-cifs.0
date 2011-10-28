From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 11/53] CIFS: Add sync_smb2_mid_result
Date: Fri, 28 Oct 2011 23:54:22 +0400
Message-ID: <1319831704-3572-12-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

Previously CIFS added a function, sync_mid_result,
to better handle certain error conditions.
This patch adds the equivalent for SMB2 mids (the
functions are used by smb2_sendrcv2
which is added in the next patch)

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2transport.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 59aa1c0..2ca9943 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -244,6 +244,64 @@ smb2_mid_entry_free(struct smb2_mid_entry *mid_entry)
 	mempool_free(mid_entry, smb2_mid_poolp);
 }
 
+/* This is similar to cifs's wait_for_response but obviously for smb2 mids */
+static int
+wait_for_smb2_response(struct TCP_Server_Info *server,
+			struct smb2_mid_entry *midq)
+{
+	int error;
+
+	error = wait_event_killable(server->response_q,
+				    midq->mid_state != MID_REQUEST_SUBMITTED);
+	if (error < 0)
+		return -ERESTARTSYS;
+
+	return 0;
+}
+
+/* This is similar to cifs's sync_mid_result but for smb2 mids */
+static int
+sync_smb2_mid_result(struct smb2_mid_entry *mid, struct TCP_Server_Info *server)
+{
+	int rc = 0;
+
+	cFYI(1, "%s: cmd=%d mid=%lld state=%d", __func__,
+		le16_to_cpu(mid->command), mid->mid, mid->mid_state);
+
+	spin_lock(&GlobalMid_Lock);
+	/* ensure that it's no longer on the pending_mid_q */
+	list_del_init(&mid->qhead);
+
+	switch (mid->mid_state) {
+	case MID_RESPONSE_RECEIVED:
+		spin_unlock(&GlobalMid_Lock);
+		return rc;
+	case MID_REQUEST_SUBMITTED:
+		/* socket is going down, reject all calls */
+		if (server->tcpStatus == CifsExiting) {
+			cERROR(1, "%s: canceling mid=%lld cmd=0x%x state=%d",
+				__func__, mid->mid, le16_to_cpu(mid->command),
+				mid->mid_state);
+			rc = -EHOSTDOWN;
+			break;
+		}
+	case MID_RETRY_NEEDED:
+		rc = -EAGAIN;
+		break;
+	case MID_RESPONSE_MALFORMED:
+		rc = -EIO;
+		break;
+	default:
+		cERROR(1, "%s: invalid mid state mid=%lld state=%d", __func__,
+			mid->mid, mid->mid_state);
+		rc = -EIO;
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	smb2_mid_entry_free(mid);
+	return rc;
+}
+
 static void
 free_smb2_mid(struct smb2_mid_entry *mid)
 {
-- 
1.7.1
