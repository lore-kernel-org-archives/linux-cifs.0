From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 33/53] CIFS: Add echo request support for SMB2
Date: Tue, 25 Oct 2011 10:12:06 +0400
Message-ID: <1319523146-2859-34-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 ++
 fs/cifs/connect.c   |   18 ++++------
 fs/cifs/smb2pdu.c   |   89 +++++++++++++++++++--------------------------------
 fs/cifs/smb2proto.h |    3 +-
 fs/cifs/smb2sess.c  |   25 ++++++++++++++
 5 files changed, 70 insertions(+), 68 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bde6241..d878378 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -79,6 +79,9 @@
 /*           (max path length + 1 for null) * 2 for unicode    */
 #define MAX_NAME 514
 
+/* SMB echo "timeout" -- FIXME: tunable? */
+#define SMB_ECHO_INTERVAL (60 * HZ)
+
 #include "cifspdu.h"
 
 #ifndef XATTR_DOS_ATTRIB
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5ee2308..b3f2e13 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -55,9 +55,6 @@
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
 
-/* SMB echo "timeout" -- FIXME: tunable? */
-#define SMB_ECHO_INTERVAL (60 * HZ)
-
 extern mempool_t *cifs_req_poolp;
 
 /* FIXME: should these be tunable? */
@@ -316,13 +313,7 @@ cifs_echo_request(struct work_struct *work)
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
-	if (server->is_smb2 == false)
-		rc = CIFSSMBEcho(server);
-#ifdef CONFIG_CIFS_SMB2
-	else /*temporarilly disable echo requests for smb2
-		rc = SMB2_echo(server); */
-		rc = 0;
-#endif
+	rc = CIFSSMBEcho(server);
 	if (rc)
 		cFYI(1, "Unable to send echo request to server: %s",
 			server->hostname);
@@ -2027,7 +2018,12 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->lstrp = jiffies;
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
-	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
+	if (volume_info->use_smb2 == false)
+		INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
+#ifdef CONFIG_CIFS_SMB2
+	else
+		INIT_DELAYED_WORK(&tcp_ses->echo, smb2_echo_request);
+#endif
 
 	/*
 	 * at this point we are the only ones with the pointer
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b5e717a..d682fa5 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1223,73 +1223,50 @@ int SMB2_flush(const int xid, struct cifs_tcon *tcon,
 
 
 /*
- * Although the tcon value is not needed to send the echo, the
- * echo is useful when problems with slow operations show up
- * on a tcon, and also after a mount to recognize very slow links
- * so it is useful to associate the results of echo with a tcon
- * and pass in a tcon to this function.
+ * This is a no-op for now. We're not really interested in the reply, but
+ * rather in the fact that the server sent one and that server->lstrp
+ * gets updated.
+ *
+ * FIXME: maybe we should consider checking that the reply matches request?
  */
-int SMB2_echo(const int xid, struct cifs_tcon *tcon)
+static void
+smb2_echo_callback(struct mid_q_entry *mid)
 {
-	struct echo_req *pSMB2;
-	struct TCP_Server_Info *server;
-	struct cifs_ses *ses = tcon->ses;
-	struct kvec iov[1];
-	int resp_buftype;
-	int status;
-	int rc = 0;
-	unsigned long when_sent;
+	struct TCP_Server_Info *server = mid->callback_data;
+	struct echo_rsp *smb2 = (struct echo_rsp *)mid->resp_buf;
+	unsigned int credits_received = 1;
 
-	cFYI(1, "Echo");
+	if (mid->mid_state == MID_RESPONSE_RECEIVED)
+		credits_received = le16_to_cpu(smb2->hdr.CreditRequest);
 
-	if (ses && (ses->server))
-		server = ses->server;
-	else
-		return -EIO;
+	smb2_mid_entry_free(mid);
+	atomic_add(credits_received, &server->credits);
+	wake_up(&server->request_q);
+}
 
-	rc = small_smb2_init(SMB2_ECHO, tcon, (void **) &pSMB2);
-	if (rc)
-		return rc;
+int
+SMB2_echo(struct TCP_Server_Info *server)
+{
+	struct echo_req *smb2;
+	int rc = 0;
+	struct kvec iov;
 
-	iov[0].iov_base = (char *)pSMB2;
-	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length)
-					+ 4 /* rfc1001 len */;
+	cFYI(1, "In echo request");
 
-	when_sent = jiffies;
-	rc = smb2_sendrcv2(xid, ses, iov, 1, &resp_buftype /* ret */, &status,
-			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&smb2);
+	if (rc)
+		return rc;
 
-	/*
-	 * 15 jiffies is about 60 milliseconds - and plenty of time for network
-	 * request to reach server and be processed but if it takes 1000 jiffies
-	 * (about 4 seconds) then network or server is sick. 15 seconds and it
-	 * would have timed out and returned an error.
-	 */
-	if (time_before(jiffies, when_sent + 3))
-		tcon->ses->server->speed = SMB2_ECHO_FAST;
-	else if (time_before(jiffies, when_sent + 15))
-		tcon->ses->server->speed = SMB2_ECHO_OK;
-	else if (time_before(jiffies, when_sent + 125)) {
-		tcon->ses->server->speed = SMB2_ECHO_SLOW;
-		cERROR(1, "slow network, SMB2 echo took %lu jiffies",
-			when_sent - jiffies);
-	} else if (time_before(jiffies, when_sent + 1000)) {
-		tcon->ses->server->speed = SMB2_ECHO_VERY_SLOW;
-		cERROR(1, "bad network? SMB2 echo took %lu jiffies",
-			when_sent - jiffies);
-	} else {
-		tcon->ses->server->speed = SMB2_ECHO_TIMEOUT;
-		cERROR(1, "server may be down - echo took %lu jiffies",
-			when_sent - jiffies);
-	}
+	iov.iov_base = smb2;
+	iov.iov_len = be32_to_cpu(smb2->hdr.smb2_buf_length) + 4;
 
-	cFYI(1, "ECHO speed %d rc %d status %d", tcon->ses->server->speed, rc,
-	     status);
+	rc = smb2_call_async(server, &iov, 1, NULL, smb2_echo_callback, server,
+			     false);
+	if (rc)
+		cFYI(1, "Echo request failed: %d", rc);
 
-	if (rc != 0)
-		cifs_stats_fail_inc(tcon, SMB2ECHO);
+	cifs_small_buf_release(smb2);
 
-	free_rsp_buf(resp_buftype, iov[0].iov_base);
 	return rc;
 }
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 79d05ab..d64a25b 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -96,6 +96,7 @@ extern int sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *);
 /* BB FIXME - need to add SMB2's signing mechanism - not same as CIFS BB */
 /*extern int smb2_verify_signature(struct smb2_hdr *,
 				 const struct mac_key *mac_key);*/
+extern void smb2_echo_request(struct work_struct *work);
 extern int smb2_demultiplex_thread(struct TCP_Server_Info *server);
 extern int smb2_observe_thread(struct TCP_Server_Info *server);
 extern int smb2_reconnect(struct TCP_Server_Info *server);
@@ -174,7 +175,7 @@ extern int SMB2_tcon(unsigned int xid, struct cifs_ses *ses,
 		    const struct nls_table *);
 extern int SMB2_tdis(const int xid, struct cifs_tcon *tcon);
 extern int SMB2_logoff(const int xid, struct cifs_ses *ses);
-extern int SMB2_echo(const int xid, struct cifs_tcon *tcon);
+extern int SMB2_echo(struct TCP_Server_Info *server);
 extern int SMB2_QFS_info(const int xid, struct cifs_tcon *tcon,
 			u64 persistent_file_id, u64 volatile_file_id,
 			struct kstatfs *FSData);
diff --git a/fs/cifs/smb2sess.c b/fs/cifs/smb2sess.c
index 430cf14..503ec77 100644
--- a/fs/cifs/smb2sess.c
+++ b/fs/cifs/smb2sess.c
@@ -82,3 +82,28 @@ int smb2_setup_session(unsigned int xid, struct cifs_ses *psesinfo,
 ss_err_exit:
 	return rc;
 }
+
+void
+smb2_echo_request(struct work_struct *work)
+{
+	int rc = 0;
+	struct TCP_Server_Info *server = container_of(work,
+					struct TCP_Server_Info, echo.work);
+
+	/*
+	 * We cannot send an echo until the NEGOTIATE_PROTOCOL request is
+	 * done, which is indicated by max_read != 0. Also, no need to ping
+	 * if we got a response recently.
+	 */
+	if (server->max_read == 0 ||
+	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
+		goto requeue_echo;
+
+	rc = SMB2_echo(server);
+	if (rc)
+		cFYI(1, "Unable to send echo request to server: %s",
+			server->hostname);
+
+requeue_echo:
+	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
+}
-- 
1.7.1
