From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 41/53] CIFS: Disable SMB2.1 protocol negotiating
Date: Fri, 28 Oct 2011 23:54:52 +0400
Message-ID: <1319831704-3572-42-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

because we don't support it now.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2pdu.c   |    2 +-
 fs/cifs/transport.c |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 308dd36..4b66a76 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -525,7 +525,7 @@ static void free_rsp_buf(int resp_buftype, void *pSMB2r)
 		cifs_buf_release(pSMB2r);
 }
 
-#define SMB2_NUM_PROT 2
+#define SMB2_NUM_PROT 1
 
 #define SMB2_PROT   0
 #define SMB21_PROT  1
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index bfae7d9..e205d2a 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -294,8 +294,11 @@ int wait_for_free_request(struct TCP_Server_Info *server,
 			  (atomic_read(&server->credits) < 1)) {
 			spin_unlock(&GlobalMid_Lock);
 			cifs_num_waiters_inc(server);
-			wait_event(server->request_q,
-				   atomic_read(&server->credits) > 0);
+			if (wait_event_killable(server->request_q,
+				    atomic_read(&server->credits) > 0)) {
+				cifs_num_waiters_dec(server);
+				return -ENOENT;
+			}
 			cifs_num_waiters_dec(server);
 			spin_lock(&GlobalMid_Lock);
 #endif /* CONFIG_CIFS_SMB2 */
-- 
1.7.1
