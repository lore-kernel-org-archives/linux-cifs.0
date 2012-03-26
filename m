From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 13/16] CIFS: Process reconnects for SMB2 shares
Date: Mon, 26 Mar 2012 13:21:40 +0400
Message-ID: <1332753703-4315-14-git-send-email-piastry@etersoft.ru>
References: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332753703-4315-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c   |    3 +
 fs/cifs/smb2pdu.c   |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2proto.h |    2 +
 3 files changed, 131 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e067af3..ccb1d87 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -289,6 +289,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		server->tcpStatus = CifsNeedReconnect;
 	spin_unlock(&GlobalMid_Lock);
 	server->maxBuf = 0;
+#ifdef CONFIG_CIFS_SMB2
+	server->max_read = 0;
+#endif
 
 	cFYI(1, "Reconnecting tcp session");
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 71bf301..4bf33b0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -183,7 +183,132 @@ static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 {
 	int rc = 0;
-	/* BB add missing code here */
+	struct nls_table *nls_codepage;
+	struct cifs_ses *ses;
+	struct TCP_Server_Info *server;
+
+	/*
+	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
+	 * check for tcp and smb session status done differently
+	 * for those three - in the calling routine.
+	 */
+	if (tcon == NULL)
+		return rc;
+
+	if (smb2_command == SMB2_TREE_CONNECT)
+		return rc;
+
+	if (tcon->tidStatus == CifsExiting) {
+		/*
+		 * only tree disconnect, open, and write,
+		 * (and ulogoff which does not have tcon)
+		 * are allowed as we start force umount.
+		 */
+		if ((smb2_command != SMB2_WRITE) &&
+		   (smb2_command != SMB2_CREATE) &&
+		   (smb2_command != SMB2_TREE_DISCONNECT)) {
+			cFYI(1, "can not send cmd %d while umounting",
+				smb2_command);
+			return -ENODEV;
+		}
+	}
+	if ((!tcon->ses) || (tcon->ses->status == CifsExiting) ||
+	    (!tcon->ses->server))
+		return -EIO;
+
+	ses = tcon->ses;
+	server = ses->server;
+
+	/*
+	 * Give demultiplex thread up to 10 seconds to reconnect, should be
+	 * greater than cifs socket timeout which is 7 seconds
+	 */
+	while (server->tcpStatus == CifsNeedReconnect) {
+		/*
+		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
+		 * here since they are implicitly done when session drops.
+		 */
+		switch (smb2_command) {
+		/*
+		 * BB Should we keep oplock break and add flush to exceptions?
+		 */
+		case SMB2_TREE_DISCONNECT:
+		case SMB2_CANCEL:
+		case SMB2_CLOSE:
+		case SMB2_OPLOCK_BREAK:
+			return -EAGAIN;
+		}
+
+		wait_event_interruptible_timeout(server->response_q,
+			(server->tcpStatus != CifsNeedReconnect), 10 * HZ);
+
+		/* are we still trying to reconnect? */
+		if (server->tcpStatus != CifsNeedReconnect)
+			break;
+
+		/*
+		 * on "soft" mounts we wait once. Hard mounts keep
+		 * retrying until process is killed or server comes
+		 * back on-line
+		 */
+		if (!tcon->retry) {
+			cFYI(1, "gave up waiting on reconnect in smb_init");
+			return -EHOSTDOWN;
+		}
+	}
+
+	if (!tcon->ses->need_reconnect && !tcon->need_reconnect)
+		return rc;
+
+	nls_codepage = load_nls_default();
+
+	/*
+	 * need to prevent multiple threads trying to simultaneously reconnect
+	 * the same SMB session
+	 */
+	mutex_lock(&tcon->ses->session_mutex);
+	rc = cifs_negotiate_protocol(0, tcon->ses);
+	if (!rc && tcon->ses->need_reconnect)
+		rc = cifs_setup_session(0, tcon->ses, nls_codepage);
+
+	if (rc || !tcon->need_reconnect) {
+		mutex_unlock(&tcon->ses->session_mutex);
+		goto out;
+	}
+
+	cifs_mark_open_files_invalid(tcon);
+	rc = SMB2_tcon(0, tcon->ses, tcon->treeName, tcon, nls_codepage);
+	mutex_unlock(&tcon->ses->session_mutex);
+	cFYI(1, "reconnect tcon rc = %d", rc);
+	if (rc)
+		goto out;
+	atomic_inc(&tconInfoReconnectCount);
+	/*
+	 * BB FIXME add code to check if wsize needs update due to negotiated
+	 * smb buffer size shrinking.
+	 */
+out:
+	/*
+	 * Check if handle based operation so we know whether we can continue
+	 * or not without returning to caller to reset file handle.
+	 */
+	/*
+	 * BB Is flush done by server on drop of tcp session? Should we special
+	 * case it and skip above?
+	 */
+	switch (smb2_command) {
+	case SMB2_FLUSH:
+	case SMB2_READ:
+	case SMB2_WRITE:
+	case SMB2_LOCK:
+	case SMB2_IOCTL:
+	case SMB2_QUERY_DIRECTORY:
+	case SMB2_CHANGE_NOTIFY:
+	case SMB2_QUERY_INFO:
+	case SMB2_SET_INFO:
+		return -EAGAIN;
+	}
+	unload_nls(nls_codepage);
 	return rc;
 }
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index bb57de3..db2db84 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -42,6 +42,8 @@ extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 			      unsigned int nvec, struct mid_q_entry **ret_mid);
+extern int smb2_setup_session(unsigned int xid, struct cifs_ses *psesinfo,
+			      struct nls_table *nls_info);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
-- 
1.7.1
