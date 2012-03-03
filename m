From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 05/17] CIFS: Make wait_for_free_request killable
Date: Sat,  3 Mar 2012 12:37:06 +0300
Message-ID: <1330767438-19469-6-git-send-email-piastry@etersoft.ru>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330767438-19469-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

to let us kill the proccess if it hangs waiting for a credit when
the session is down and echo is disabled.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/transport.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5fab0f1..6a8378b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -257,6 +257,8 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 static int
 wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 {
+	int rc;
+
 	spin_lock(&server->req_lock);
 
 	if (long_op == CIFS_ASYNC_OP) {
@@ -276,8 +278,11 @@ wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
 		if (server->credits <= 0) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
-			wait_event(server->request_q, get_credits(server) > 0);
+			rc = wait_event_killable(server->request_q,
+						 get_credits(server) > 0);
 			cifs_num_waiters_dec(server);
+			if (rc)
+				return rc;
 			spin_lock(&server->req_lock);
 		} else {
 			if (server->tcpStatus == CifsExiting) {
-- 
1.7.1
