From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [PATCH v4] cifs: Do not modify mid entry after submitting I/O in cifs_call_async
Date: Wed, 28 Jun 2017 15:55:55 -0700
Message-ID: <1498690555-8454-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

In cifs_call_async, server may respond as soon as I/O is submitted. Because
mid entry is freed on the return path, it should not be modified after I/O
is submitted.

cifs_save_when_sent modifies the sent timestamp in mid entry, and should not
be called after I/O. Call it before I/O.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 47a125e..7efbab0 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -536,11 +536,14 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	list_add_tail(&mid->qhead, &server->pending_mid_q);
 	spin_unlock(&GlobalMid_Lock);
 
-
+	/*
+	 * Need to store the time in mid before calling I/O. For call_async,
+	 * I/O response may come back and free the mid entry on another thread.
+	 */
+	cifs_save_when_sent(mid);
 	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, rqst, flags);
 	cifs_in_send_dec(server);
-	cifs_save_when_sent(mid);
 
 	if (rc < 0) {
 		server->sequence_number -= 2;
-- 
2.7.4
