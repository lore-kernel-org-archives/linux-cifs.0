From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 12/24] CIFS: Process reconnects for SMB2 shares
Date: Wed, 20 Jun 2012 18:30:52 +0400
Message-ID: <1340202664-28696-13-git-send-email-pshilovsky@samba.org>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/cifssmb.c   |   21 +++++---
 fs/cifs/connect.c   |    3 +
 fs/cifs/smb2pdu.c   |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 143 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 907f43c..16adcaa 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -171,6 +171,7 @@ extern struct smb_vol *cifs_get_volume_info(char *mount_data,
 					    const char *devname);
 extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
 extern void cifs_umount(struct cifs_sb_info *);
+extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b24ee86..f7a3402 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -88,24 +88,29 @@ static struct {
 
 /* Forward declarations */
 
-/* Mark as invalid, all open files on tree connections since they
-   were closed when session to server was lost */
-static void mark_open_files_invalid(struct cifs_tcon *pTcon)
+/*
+ * Mark as invalid, all open files on tree connections since they
+ * were closed when session to server was lost.
+ */
+void
+cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *open_file = NULL;
 	struct list_head *tmp;
 	struct list_head *tmp1;
 
-/* list all files open on tree connection and mark them invalid */
+	/* list all files open on tree connection and mark them invalid */
 	spin_lock(&cifs_file_list_lock);
-	list_for_each_safe(tmp, tmp1, &pTcon->openFileList) {
+	list_for_each_safe(tmp, tmp1, &tcon->openFileList) {
 		open_file = list_entry(tmp, struct cifsFileInfo, tlist);
 		open_file->invalidHandle = true;
 		open_file->oplock_break_cancelled = true;
 	}
 	spin_unlock(&cifs_file_list_lock);
-	/* BB Add call to invalidate_inodes(sb) for all superblocks mounted
-	   to this tcon */
+	/*
+	 * BB Add call to invalidate_inodes(sb) for all superblocks mounted
+	 * to this tcon.
+	 */
 }
 
 /* reconnect the socket, tcon, and smb session if needed */
@@ -185,7 +190,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		goto out;
 	}
 
-	mark_open_files_invalid(tcon);
+	cifs_mark_open_files_invalid(tcon);
 	rc = CIFSTCon(0, ses, tcon->treeName, tcon, nls_codepage);
 	mutex_unlock(&ses->session_mutex);
 	cFYI(1, "reconnect tcon rc = %d", rc);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cced470..9dc0d92 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -316,6 +316,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		server->tcpStatus = CifsNeedReconnect;
 	spin_unlock(&GlobalMid_Lock);
 	server->maxBuf = 0;
+#ifdef CONFIG_CIFS_SMB2
+	server->max_read = 0;
+#endif
 
 	cFYI(1, "Reconnecting tcp session");
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 882c7e2..66d6b24 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -127,7 +127,132 @@ static int
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
 
-- 
1.7.1
