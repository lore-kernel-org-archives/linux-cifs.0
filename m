Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322F5C35671
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDE7720828
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="yeeVI6K3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgBXNQD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:16:03 -0500
Received: from hr2.samba.org ([144.76.82.148]:41990 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNQD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:16:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=PEwApxa6vfLWLY712uIc2r81kHnO9ehX7u3hj+jliQw=; b=yeeVI6K38CEIvr5OeD72+NVa46
        DbbYnn4Y6saNMhc298MjPC3+OqW3o6mj5GIlZrS2ka4YN2lF3Apv2trWbtX4+ESB9NK3XAEQYxWVl
        rpjcsBLFzs7xGPYdhqaOKrVk7fU19iXw1X5B3XagCP7/xev8UiZvXgeXCda6Y5Sj3kplVanZZNrEo
        g0RV2gcuelu5kxFO8r+pyh7/m0f94F4lNVnQmXfQsD9Z41xLRM1lc3P2Pndmkaw+WYvH4zAfAjCk7
        SHMqUC4tF8+qAuKeTUy1Kiw+BES6L1OVP+O58wUB/hIq8CxVDOk7Vv71ctsVfhyZrM9nSx+AjtwD/
        Juhq6jlM2Yk8GqvpfVoUKe8GDjpu07VWUiLbzuNtJ5JSAcaLfkL74g7+6CD6PK83VCcZBoYwzz7FC
        rA58XeMCGntHmtZYz3ih+PIB927DGEICps4YdCz/TRj7SS1dc1C3TfKsA6Di9Ed6dX+z/YanS4Zt7
        sGNzyyvBthbxKoVWHDYVEvV0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaQ-00061e-QL; Mon, 24 Feb 2020 13:15:50 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 06/13] cifs: abstract cifs_tcon_reconnect() out of smb2_reconnect()
Date:   Mon, 24 Feb 2020 14:15:03 +0100
Message-Id: <20200224131510.20608-7-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs_tcon_reconnect() will also be used in cifs_reconnect_tcon()
with the next commit.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/cifsglob.h  |   8 +++
 fs/cifs/cifsproto.h |   3 +
 fs/cifs/connect.c   | 125 ++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   | 151 +++++++++-----------------------------------
 4 files changed, 166 insertions(+), 121 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index de82cfa44b1a..8393ed7ebf96 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1074,6 +1074,14 @@ struct cached_fid {
 	struct smb2_file_all_info file_all_info;
 };
 
+struct cifs_tcon_reconnect_params {
+	bool skip_reconnect;
+	bool exit_nodev;
+	bool early_eagain;
+	bool late_eagain;
+	bool start_timer;
+};
+
 /*
  * there is one of these for each connection to a resource on a particular
  * session
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 4c93007e44c0..64f13affdb15 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -270,6 +270,9 @@ extern int cifs_connect_session_locked(const unsigned int xid,
 				       struct cifs_ses *ses,
 				       struct nls_table *nls_info,
 				       bool retry);
+extern int cifs_tcon_reconnect(struct cifs_tcon *tcon,
+			       const struct cifs_tcon_reconnect_params *params);
+
 extern int cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required);
 extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c243c9a1b3d4..67d2ad330f33 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5398,6 +5398,131 @@ cifs_connect_session_locked(const unsigned int xid,
 	return rc;
 }
 
+int
+cifs_tcon_reconnect(struct cifs_tcon *tcon,
+		    const struct cifs_tcon_reconnect_params *params)
+{
+	int rc;
+	struct nls_table *nls_codepage;
+	struct cifs_ses *ses;
+	struct TCP_Server_Info *server;
+	int retries;
+
+	/*
+	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
+	 * check for tcp and smb session status done differently
+	 * for those three - in the calling routine.
+	 */
+	if (tcon == NULL)
+		return 0;
+
+	ses = tcon->ses;
+	server = ses->server;
+
+	if (params->skip_reconnect)
+		return 0;
+
+	if (tcon->tidStatus == CifsExiting) {
+		if (params->exit_nodev) {
+			cifs_dbg(FYI, "return ENODEV while umounting\n");
+			return -ENODEV;
+		}
+	}
+	if ((!ses) || (ses->status == CifsExiting) || (!server))
+		return -EIO;
+
+	retries = server->nr_targets;
+
+	/*
+	 * Give demultiplex thread up to 10 seconds to each target available for
+	 * reconnect -- should be greater than cifs socket timeout which is 7
+	 * seconds.
+	 */
+	while (server->tcpStatus == CifsNeedReconnect) {
+		if (params->early_eagain) {
+			return -EAGAIN;
+		}
+
+		rc = wait_event_interruptible_timeout(server->response_q,
+						      (server->tcpStatus != CifsNeedReconnect),
+						      10 * HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting reconnect due to a received"
+				 " signal by the process\n", __func__);
+			return -ERESTARTSYS;
+		}
+
+		/* are we still trying to reconnect? */
+		if (server->tcpStatus != CifsNeedReconnect)
+			break;
+
+		if (retries && --retries)
+			continue;
+
+		/*
+		 * on "soft" mounts we wait once. Hard mounts keep
+		 * retrying until process is killed or server comes
+		 * back on-line
+		 */
+		if (!tcon->retry) {
+			cifs_dbg(FYI, "gave up waiting on reconnect in smb_init\n");
+			return -EHOSTDOWN;
+		}
+		retries = server->nr_targets;
+	}
+
+	if (!ses->need_reconnect && !tcon->need_reconnect)
+		return 0;
+
+	nls_codepage = load_nls_default();
+
+	/*
+	 * need to prevent multiple threads trying to simultaneously reconnect
+	 * the same SMB session
+	 */
+	mutex_lock(&ses->session_mutex);
+
+	/*
+	 * Recheck after acquire mutex. If another thread is negotiating
+	 * and the server never sends an answer the socket will be closed
+	 * and tcpStatus set to reconnect.
+	 */
+	rc = cifs_connect_session_locked(0, ses,
+					 nls_codepage,
+					 tcon->retry);
+	/* do we need to reconnect tcon? */
+	if (rc || !tcon->need_reconnect) {
+		mutex_unlock(&ses->session_mutex);
+		goto out;
+	}
+
+	cifs_mark_open_files_invalid(tcon);
+	if (tcon->use_persistent)
+		tcon->need_reopen_files = true;
+
+	rc = cifs_tree_connect(0, tcon, nls_codepage);
+	mutex_unlock(&ses->session_mutex);
+
+	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
+	if (rc) {
+		/* If sess reconnected but tcon didn't, something strange ... */
+		printk_once(KERN_WARNING "reconnect tcon failed rc = %d\n", rc);
+		goto out;
+	}
+
+	if (params->start_timer)
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+
+	atomic_inc(&tconInfoReconnectCount);
+out:
+	if (params->late_eagain) {
+		rc = -EAGAIN;
+	}
+
+	unload_nls(nls_codepage);
+	return rc;
+}
+
 static int
 cifs_set_vol_auth(struct smb_vol *vol, struct cifs_ses *ses)
 {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 715a50ffb234..162fe3381f4c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -158,139 +158,48 @@ smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 {
-	int rc;
-	struct nls_table *nls_codepage;
-	struct cifs_ses *ses;
-	struct TCP_Server_Info *server;
-	int retries;
-
-	/*
-	 * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
-	 * check for tcp and smb session status done differently
-	 * for those three - in the calling routine.
-	 */
-	if (tcon == NULL)
-		return 0;
+	struct cifs_tcon_reconnect_params params = {
+		.skip_reconnect = false,
+	};
 
-	if (smb2_command == SMB2_TREE_CONNECT)
-		return 0;
-
-	if (tcon->tidStatus == CifsExiting) {
-		/*
-		 * only tree disconnect, open, and write,
-		 * (and ulogoff which does not have tcon)
-		 * are allowed as we start force umount.
-		 */
-		if ((smb2_command != SMB2_WRITE) &&
-		   (smb2_command != SMB2_CREATE) &&
-		   (smb2_command != SMB2_TREE_DISCONNECT)) {
-			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
-				 smb2_command);
-			return -ENODEV;
-		}
+	switch (smb2_command) {
+	case SMB2_TREE_CONNECT:
+		params.skip_reconnect = true;
+		break;
 	}
-	if ((!tcon->ses) || (tcon->ses->status == CifsExiting) ||
-	    (!tcon->ses->server))
-		return -EIO;
-
-	ses = tcon->ses;
-	server = ses->server;
-
-	retries = server->nr_targets;
 
 	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
+	 * only tree disconnect, open, and write,
+	 * (and ulogoff which does not have tcon)
+	 * are allowed as we start force umount.
 	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
-		/*
-		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
-		 * here since they are implicitly done when session drops.
-		 */
-		switch (smb2_command) {
-		/*
-		 * BB Should we keep oplock break and add flush to exceptions?
-		 */
-		case SMB2_TREE_DISCONNECT:
-		case SMB2_CANCEL:
-		case SMB2_CLOSE:
-		case SMB2_OPLOCK_BREAK:
-			return -EAGAIN;
-		}
-
-		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
-						      10 * HZ);
-		if (rc < 0) {
-			cifs_dbg(FYI, "%s: aborting reconnect due to a received"
-				 " signal by the process\n", __func__);
-			return -ERESTARTSYS;
-		}
-
-		/* are we still trying to reconnect? */
-		if (server->tcpStatus != CifsNeedReconnect)
-			break;
-
-		if (retries && --retries)
-			continue;
-
-		/*
-		 * on "soft" mounts we wait once. Hard mounts keep
-		 * retrying until process is killed or server comes
-		 * back on-line
-		 */
-		if (!tcon->retry) {
-			cifs_dbg(FYI, "gave up waiting on reconnect in smb_init\n");
-			return -EHOSTDOWN;
-		}
-		retries = server->nr_targets;
+	switch (smb2_command) {
+	case SMB2_WRITE:
+	case SMB2_CREATE:
+	case SMB2_TREE_DISCONNECT:
+		params.exit_nodev = true;
+		break;
 	}
 
-	if (!tcon->ses->need_reconnect && !tcon->need_reconnect)
-		return 0;
-
-	nls_codepage = load_nls_default();
-
 	/*
-	 * need to prevent multiple threads trying to simultaneously reconnect
-	 * the same SMB session
+	 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
+	 * here since they are implicitly done when session drops.
 	 */
-	mutex_lock(&tcon->ses->session_mutex);
-
+	switch (smb2_command) {
 	/*
-	 * Recheck after acquire mutex. If another thread is negotiating
-	 * and the server never sends an answer the socket will be closed
-	 * and tcpStatus set to reconnect.
+	 * BB Should we keep oplock break and add flush to exceptions?
 	 */
-	rc = cifs_connect_session_locked(0, tcon->ses,
-					 nls_codepage,
-					 tcon->retry);
-	/* do we need to reconnect tcon? */
-	if (rc || !tcon->need_reconnect) {
-		mutex_unlock(&tcon->ses->session_mutex);
-		goto out;
-	}
-
-	cifs_mark_open_files_invalid(tcon);
-	if (tcon->use_persistent)
-		tcon->need_reopen_files = true;
-
-	rc = cifs_tree_connect(0, tcon, nls_codepage);
-	mutex_unlock(&tcon->ses->session_mutex);
-
-	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
-	if (rc) {
-		/* If sess reconnected but tcon didn't, something strange ... */
-		printk_once(KERN_WARNING "reconnect tcon failed rc = %d\n", rc);
-		goto out;
+	case SMB2_TREE_DISCONNECT:
+	case SMB2_CANCEL:
+	case SMB2_CLOSE:
+	case SMB2_OPLOCK_BREAK:
+		params.early_eagain = true;
+		break;
 	}
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
-		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		params.start_timer = true;
 
-	atomic_inc(&tconInfoReconnectCount);
-out:
 	/*
 	 * Check if handle based operation so we know whether we can continue
 	 * or not without returning to caller to reset file handle.
@@ -309,11 +218,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	case SMB2_CHANGE_NOTIFY:
 	case SMB2_QUERY_INFO:
 	case SMB2_SET_INFO:
-		rc = -EAGAIN;
+		params.late_eagain = true;
+		break;
 	}
 
-	unload_nls(nls_codepage);
-	return rc;
+	return cifs_tcon_reconnect(tcon, &params);
 }
 
 static void
-- 
2.17.1

