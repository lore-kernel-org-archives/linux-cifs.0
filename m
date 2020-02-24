Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB28C11D34
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3D8920828
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GvXBL9Dq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgBXNQI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:16:08 -0500
Received: from hr2.samba.org ([144.76.82.148]:41990 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNQI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:16:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=ca8zRRwr8IWKubjdfXP0HJdvyH6qhJTymuaUcVBJ5O8=; b=GvXBL9DqDKQIq4z6u2ZrDMmBcr
        MGyY4ytP8IeYM5JctOA+qOjSJGJSADM03FwEECJV0W2r9Jf408QWNOTpfVWNPQgyv4KVaDN9UnZFk
        jpho1FnHM3ba6VsQireqHPLaoq+KKDGplFYFQibSVP2EJ7kC1OXqsfl7XdQJIZSvP/FOZx/NROX0x
        2l54ix878vOCsjo/8D5pCwCKzW/9GdFAdQCZMOUCoa/CoGyZ1RF6RXH7/uDwC7hfaktdoMI7esL3E
        P8obp5xfElAREvCzww5lUPbt76bdXgAsHB7qGlkDeizjerkIFH9Q9q5PXFURLy9LUIVYxRuUU9ULN
        O1SstBV6m/DkcETjXm+oy6uysR8b/Uu4SNRoJA0nF3fwejDPVb6FfiySOGpPxIXGty/RmOlN7wX5j
        GMp21cq8BPtwVPuhRzwLufbDQNKkoSkO0U/xgxT2ZeK1g9xvwYYeHoZ5QU2rTvvADTY5xH5YTd8aw
        gx2lIQuIAMxKnPOkrZspugng;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaR-00061e-4h; Mon, 24 Feb 2020 13:15:51 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 07/13] cifs: cifs_reconnect_tcon() make use of the generic cifs_tcon_reconnect() function
Date:   Mon, 24 Feb 2020 14:15:04 +0100
Message-Id: <20200224131510.20608-8-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/cifssmb.c | 117 +++++-----------------------------------------
 fs/cifs/connect.c |   7 +++
 2 files changed, 19 insertions(+), 105 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 412d141e1adc..2cf74028ce70 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -128,114 +128,22 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 static int
 cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 {
-	int rc;
-	struct cifs_ses *ses;
-	struct TCP_Server_Info *server;
-	struct nls_table *nls_codepage;
-	int retries;
-
-	/*
-	 * SMBs NegProt, SessSetup, uLogoff do not have tcon yet so check for
-	 * tcp and smb session status done differently for those three - in the
-	 * calling routine
-	 */
-	if (!tcon)
-		return 0;
-
-	ses = tcon->ses;
-	server = ses->server;
+	struct cifs_tcon_reconnect_params params = {
+		.skip_reconnect = false,
+	};
 
 	/*
 	 * only tree disconnect, open, and write, (and ulogoff which does not
 	 * have tcon) are allowed as we start force umount
 	 */
-	if (tcon->tidStatus == CifsExiting) {
-		if (smb_command != SMB_COM_WRITE_ANDX &&
-		    smb_command != SMB_COM_OPEN_ANDX &&
-		    smb_command != SMB_COM_TREE_DISCONNECT) {
-			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
-				 smb_command);
-			return -ENODEV;
-		}
-	}
-
-	retries = server->nr_targets;
-
-	/*
-	 * Give demultiplex thread up to 10 seconds to each target available for
-	 * reconnect -- should be greater than cifs socket timeout which is 7
-	 * seconds.
-	 */
-	while (server->tcpStatus == CifsNeedReconnect) {
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
-	}
-
-	if (!ses->need_reconnect && !tcon->need_reconnect)
-		return 0;
-
-	nls_codepage = load_nls_default();
-
-	/*
-	 * need to prevent multiple threads trying to simultaneously
-	 * reconnect the same SMB session
-	 */
-	mutex_lock(&ses->session_mutex);
-
-	/*
-	 * Recheck after acquire mutex. If another thread is negotiating
-	 * and the server never sends an answer the socket will be closed
-	 * and tcpStatus set to reconnect.
-	 */
-	rc = cifs_connect_session_locked(0, ses,
-					 nls_codepage,
-					 tcon->retry);
-	/* do we need to reconnect tcon? */
-	if (rc || !tcon->need_reconnect) {
-		mutex_unlock(&ses->session_mutex);
-		goto out;
-	}
-
-	cifs_mark_open_files_invalid(tcon);
-	rc = cifs_tree_connect(0, tcon, nls_codepage);
-	mutex_unlock(&ses->session_mutex);
-	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
-
-	if (rc) {
-		printk_once(KERN_WARNING "reconnect tcon failed rc = %d\n", rc);
-		goto out;
+	switch (smb_command) {
+	case SMB_COM_WRITE_ANDX:
+	case SMB_COM_OPEN_ANDX:
+	case SMB_COM_TREE_DISCONNECT:
+		params.exit_nodev = true;
+		break;
 	}
 
-	atomic_inc(&tconInfoReconnectCount);
-
-	/* tell server Unix caps we support */
-	if (cap_unix(ses))
-		reset_cifs_unix_caps(0, tcon, NULL, NULL);
-
 	/*
 	 * Removed call to reopen open files here. It is safer (and faster) to
 	 * reopen files one at a time as needed in read and write.
@@ -243,7 +151,6 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * FIXME: what about file locks? don't we need to reclaim them ASAP?
 	 */
 
-out:
 	/*
 	 * Check if handle based operation so we know whether we can continue
 	 * or not without returning to caller to reset file handle
@@ -254,11 +161,11 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	case SMB_COM_CLOSE:
 	case SMB_COM_FIND_CLOSE2:
 	case SMB_COM_LOCKING_ANDX:
-		rc = -EAGAIN;
+		params.late_eagain = true;
+		break;
 	}
 
-	unload_nls(nls_codepage);
-	return rc;
+	return cifs_tcon_reconnect(tcon, &params);
 }
 
 /* Allocate and return pointer to an SMB request buffer, and set basic
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 67d2ad330f33..e920335384d7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5510,6 +5510,13 @@ cifs_tcon_reconnect(struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	/*
+	 * tell server Unix caps we support,
+	 * note it's a noop for SMB2.
+	 */
+	if (cap_unix(ses))
+		reset_cifs_unix_caps(0, tcon, NULL, NULL);
+
 	if (params->start_timer)
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 
-- 
2.17.1

