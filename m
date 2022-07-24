Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E37DC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiGXPMR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGXPMQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:12:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2728110FE2
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:12:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D12BA35067;
        Sun, 24 Jul 2022 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90R3adTXIrSoOy06fi4S6omxPjfe2JaTqAX6Hjoo9zQ=;
        b=yRzyHnCDzCaTB/KHVukNHIOfbY7XJ1rJCTQQgRjHxAOTv+v9Ifk4XvjtChHBLCJhUZGyqH
        PM8xo0mqwdQ6H6GYk9FTvdbfXICGc047Dyvgk3tH4WSdiUaYWD1tk/gsQWjPq3a/zrByL+
        ZTgG0vyFcSIYvJonaTGBkmmoyBwZpHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675533;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90R3adTXIrSoOy06fi4S6omxPjfe2JaTqAX6Hjoo9zQ=;
        b=MH4QaybXURRB4jrUSUONy5jDSsk02/acTW8m42iWb4gUls68cUgRMQAd2taQ47HIzDb55q
        k2UPg4eeXcTtSmCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 508DA13A8D;
        Sun, 24 Jul 2022 15:12:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id slMoBU1h3WJLMQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:12:13 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 07/14] cifs: typedef server status enum
Date:   Sun, 24 Jul 2022 12:11:30 -0300
Message-Id: <20220724151137.7538-8-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220724151137.7538-1-ematsumiya@suse.de>
References: <20220724151137.7538-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

typedef "enum statusEnum" to "cifs_server_status_t".
Rename the status values from CamelCase to snake_case.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c   |  2 +-
 fs/cifs/cifsglob.h      | 18 +++++------
 fs/cifs/cifssmb.c       |  8 ++---
 fs/cifs/connect.c       | 68 ++++++++++++++++++++---------------------
 fs/cifs/smb1ops.c       |  2 +-
 fs/cifs/smb2ops.c       |  8 ++---
 fs/cifs/smb2pdu.c       |  8 ++---
 fs/cifs/smb2transport.c |  8 ++---
 fs/cifs/transport.c     | 16 +++++-----
 9 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 7d8020b90220..0ff54aba4a96 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -143,7 +143,7 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct cifs_server_info *server,
 
 	spin_lock(&g_servers_lock);
 	if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
-	    server->status == CifsNeedNegotiate) {
+	    server->status == SERVER_STATUS_NEED_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return rc;
 	}
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 12b6aafa5fa6..49e0821fd61d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -111,14 +111,14 @@
  */
 
 /* associated with each connection */
-enum statusEnum {
-	CifsNew = 0,
-	CifsGood,
-	CifsExiting,
-	CifsNeedReconnect,
-	CifsNeedNegotiate,
-	CifsInNegotiate,
-};
+typedef enum {
+	SERVER_STATUS_NEW = 0,
+	SERVER_STATUS_GOOD,
+	SERVER_STATUS_EXITING,
+	SERVER_STATUS_NEED_RECONNECT,
+	SERVER_STATUS_NEED_NEGOTIATE,
+	SERVER_STATUS_IN_NEGOTIATE,
+} cifs_server_status_t;
 
 /* associated with each smb session */
 enum ses_status_enum {
@@ -612,7 +612,7 @@ struct cifs_server_info {
 	struct smb_version_operations	*ops;
 	struct smb_version_values	*vals;
 	/* updates to status protected by g_servers_lock */
-	enum statusEnum status; /* what we think the status is */
+	cifs_server_status_t status; /* what we think the status is */
 	char *hostname; /* hostname portion of UNC string */
 	struct socket *ssocket;
 	struct sockaddr_storage dstaddr;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 326db1db353e..c88a42ebb509 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -154,9 +154,9 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * reconnect -- should be greater than cifs socket timeout which is 7
 	 * seconds.
 	 */
-	while (server->status == CifsNeedReconnect) {
+	while (server->status == SERVER_STATUS_NEED_RECONNECT) {
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->status != CifsNeedReconnect),
+						      (server->status != SERVER_STATUS_NEED_RECONNECT),
 						      10 * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
@@ -166,7 +166,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 
 		/* are we still trying to reconnect? */
 		spin_lock(&g_servers_lock);
-		if (server->status != CifsNeedReconnect) {
+		if (server->status != SERVER_STATUS_NEED_RECONNECT) {
 			spin_unlock(&g_servers_lock);
 			break;
 		}
@@ -202,7 +202,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * and status set to reconnect.
 	 */
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedReconnect) {
+	if (server->status == SERVER_STATUS_NEED_RECONNECT) {
 		spin_unlock(&g_servers_lock);
 		rc = -EHOSTDOWN;
 		goto out;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4ab1933fca76..ec014e007ff9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -207,7 +207,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
 
 	spin_lock(&g_servers_lock);
 	if (!all_channels) {
-		pserver->status = CifsNeedReconnect;
+		pserver->status = SERVER_STATUS_NEED_RECONNECT;
 		spin_unlock(&g_servers_lock);
 		return;
 	}
@@ -215,7 +215,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++)
-			ses->chans[i].server->status = CifsNeedReconnect;
+			ses->chans[i].server->status = SERVER_STATUS_NEED_RECONNECT;
 		spin_unlock(&ses->chan_lock);
 	}
 	spin_unlock(&g_servers_lock);
@@ -228,7 +228,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
  * cifs_signal_cifsd_for_reconnect
  *
  * @server: the tcp ses for which reconnect is needed
- * @server needs to be previously set to CifsNeedReconnect.
+ * @server needs to be previously set to SERVER_STATUS_NEED_RECONNECT.
  * @mark_smb_session: whether even sessions need to be marked
  */
 void
@@ -352,7 +352,7 @@ static bool cifs_server_needs_reconnect(struct cifs_server_info *server, int num
 {
 	spin_lock(&g_servers_lock);
 	server->nr_targets = num_targets;
-	if (server->status == CifsExiting) {
+	if (server->status == SERVER_STATUS_EXITING) {
 		/* the demux thread will exit normally next time through the loop */
 		spin_unlock(&g_servers_lock);
 		wake_up(&server->response_q);
@@ -362,7 +362,7 @@ static bool cifs_server_needs_reconnect(struct cifs_server_info *server, int num
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
-	server->status = CifsNeedReconnect;
+	server->status = SERVER_STATUS_NEED_RECONNECT;
 
 	spin_unlock(&g_servers_lock);
 	return true;
@@ -415,17 +415,17 @@ static int __cifs_reconnect(struct cifs_server_info *server,
 			atomic_inc(&g_server_reconnect_count);
 			set_credits(server, 1);
 			spin_lock(&g_servers_lock);
-			if (server->status != CifsExiting)
-				server->status = CifsNeedNegotiate;
+			if (server->status != SERVER_STATUS_EXITING)
+				server->status = SERVER_STATUS_NEED_NEGOTIATE;
 			spin_unlock(&g_servers_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
 			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		}
-	} while (server->status == CifsNeedReconnect);
+	} while (server->status == SERVER_STATUS_NEED_RECONNECT);
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedNegotiate)
+	if (server->status == SERVER_STATUS_NEED_NEGOTIATE)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 	spin_unlock(&g_servers_lock);
 
@@ -535,20 +535,20 @@ static int reconnect_dfs_server(struct cifs_server_info *server)
 			continue;
 		}
 		/*
-		 * Socket was created.  Update tcp session status to CifsNeedNegotiate so that a
+		 * Socket was created.  Update tcp session status to SERVER_STATUS_NEED_NEGOTIATE so that a
 		 * process waiting for reconnect will know it needs to re-establish session and tcon
 		 * through the reconnected target server.
 		 */
 		atomic_inc(&g_server_reconnect_count);
 		set_credits(server, 1);
 		spin_lock(&g_servers_lock);
-		if (server->status != CifsExiting)
-			server->status = CifsNeedNegotiate;
+		if (server->status != SERVER_STATUS_EXITING)
+			server->status = SERVER_STATUS_NEED_NEGOTIATE;
 		spin_unlock(&g_servers_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
-	} while (server->status == CifsNeedReconnect);
+	} while (server->status == SERVER_STATUS_NEED_RECONNECT);
 
 	if (target_hint)
 		dfs_cache_noreq_update_tgthint(refpath, target_hint);
@@ -557,7 +557,7 @@ static int reconnect_dfs_server(struct cifs_server_info *server)
 
 	/* Need to set up echo worker again once connection has been established */
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedNegotiate)
+	if (server->status == SERVER_STATUS_NEED_NEGOTIATE)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 
 	spin_unlock(&g_servers_lock);
@@ -604,9 +604,9 @@ cifs_echo_request(struct work_struct *work)
 	 * Also, no need to ping if we got a response recently.
 	 */
 
-	if (server->status == CifsNeedReconnect ||
-	    server->status == CifsExiting ||
-	    server->status == CifsNew ||
+	if (server->status == SERVER_STATUS_NEED_RECONNECT ||
+	    server->status == SERVER_STATUS_EXITING ||
+	    server->status == SERVER_STATUS_NEW ||
 	    (server->ops->can_echo && !server->ops->can_echo(server)) ||
 	    time_before(jiffies, server->lstrp + server->echo_interval - HZ))
 		goto requeue_echo;
@@ -671,8 +671,8 @@ server_unresponsive(struct cifs_server_info *server)
 	 *     a response in >60s.
 	 */
 	spin_lock(&g_servers_lock);
-	if ((server->status == CifsGood ||
-	    server->status == CifsNeedNegotiate) &&
+	if ((server->status == SERVER_STATUS_GOOD ||
+	    server->status == SERVER_STATUS_NEED_NEGOTIATE) &&
 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
 	    time_after(jiffies, server->lstrp + 3 * server->echo_interval)) {
 		spin_unlock(&g_servers_lock);
@@ -727,12 +727,12 @@ cifs_readv_from_socket(struct cifs_server_info *server, struct msghdr *smb_msg)
 			length = sock_recvmsg(server->ssocket, smb_msg, 0);
 
 		spin_lock(&g_servers_lock);
-		if (server->status == CifsExiting) {
+		if (server->status == SERVER_STATUS_EXITING) {
 			spin_unlock(&g_servers_lock);
 			return -ESHUTDOWN;
 		}
 
-		if (server->status == CifsNeedReconnect) {
+		if (server->status == SERVER_STATUS_NEED_RECONNECT) {
 			spin_unlock(&g_servers_lock);
 			cifs_reconnect(server, false);
 			return -ECONNABORTED;
@@ -745,7 +745,7 @@ cifs_readv_from_socket(struct cifs_server_info *server, struct msghdr *smb_msg)
 			/*
 			 * Minimum sleep to prevent looping, allowing socket
 			 * to clear and app threads to set status
-			 * CifsNeedReconnect if server hung.
+			 * SERVER_STATUS_NEED_RECONNECT if server hung.
 			 */
 			usleep_range(1000, 2000);
 			length = 0;
@@ -916,7 +916,7 @@ static void clean_demultiplex_info(struct cifs_server_info *server)
 	cancel_delayed_work_sync(&server->resolve);
 
 	spin_lock(&g_servers_lock);
-	server->status = CifsExiting;
+	server->status = SERVER_STATUS_EXITING;
 	spin_unlock(&g_servers_lock);
 	wake_up_all(&server->response_q);
 
@@ -1123,7 +1123,7 @@ cifs_demultiplex_thread(void *p)
 
 	set_freezable();
 	allow_kernel_signal(SIGKILL);
-	while (server->status != CifsExiting) {
+	while (server->status != SERVER_STATUS_EXITING) {
 		if (try_to_freeze())
 			continue;
 
@@ -1534,7 +1534,7 @@ cifs_put_server(struct cifs_server_info *server, int from_reconnect)
 		cancel_delayed_work_sync(&server->reconnect);
 
 	spin_lock(&g_servers_lock);
-	server->status = CifsExiting;
+	server->status = SERVER_STATUS_EXITING;
 	spin_unlock(&g_servers_lock);
 
 	cifs_crypto_secmech_release(server);
@@ -1634,7 +1634,7 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this init of status or srv_count
 	 */
-	server->status = CifsNew;
+	server->status = SERVER_STATUS_NEW;
 	++server->srv_count;
 
 	if (ctx->echo_interval >= SMB_ECHO_INTERVAL_MIN &&
@@ -1685,7 +1685,7 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	 * no need to spinlock this update of status
 	 */
 	spin_lock(&g_servers_lock);
-	server->status = CifsNeedNegotiate;
+	server->status = SERVER_STATUS_NEED_NEGOTIATE;
 	spin_unlock(&g_servers_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
@@ -3179,7 +3179,7 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
 		 */
 		reset_cifs_unix_caps(xid, tcon, cifs_sb, ctx);
 		spin_lock(&g_servers_lock);
-		if ((tcon->ses->server->status == CifsNeedReconnect) &&
+		if ((tcon->ses->server->status == SERVER_STATUS_NEED_RECONNECT) &&
 		    (le64_to_cpu(tcon->fsUnixInfo.Capability) &
 		     CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)) {
 			spin_unlock(&g_servers_lock);
@@ -3988,25 +3988,25 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
 	if (!server->ops->need_neg(server) ||
-	    server->status != CifsNeedNegotiate) {
+	    server->status != SERVER_STATUS_NEED_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
-	server->status = CifsInNegotiate;
+	server->status = SERVER_STATUS_IN_NEGOTIATE;
 	spin_unlock(&g_servers_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
 	if (rc == 0) {
 		spin_lock(&g_servers_lock);
-		if (server->status == CifsInNegotiate)
-			server->status = CifsGood;
+		if (server->status == SERVER_STATUS_IN_NEGOTIATE)
+			server->status = SERVER_STATUS_GOOD;
 		else
 			rc = -EHOSTDOWN;
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (server->status == CifsInNegotiate)
-			server->status = CifsNeedNegotiate;
+		if (server->status == SERVER_STATUS_IN_NEGOTIATE)
+			server->status = SERVER_STATUS_NEED_NEGOTIATE;
 		spin_unlock(&g_servers_lock);
 	}
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 8b2a504c92f1..9d63099ad26a 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1024,7 +1024,7 @@ cifs_dir_needs_close(struct cifs_file_info *cfile)
 static bool
 cifs_can_echo(struct cifs_server_info *server)
 {
-	if (server->status == CifsGood)
+	if (server->status == SERVER_STATUS_GOOD)
 		return true;
 
 	return false;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 41d1237bb24c..9d2064cf44d8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -127,8 +127,8 @@ smb2_add_credits(struct cifs_server_info *server,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedReconnect
-	    || server->status == CifsExiting) {
+	if (server->status == SERVER_STATUS_NEED_RECONNECT
+	    || server->status == SERVER_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return;
 	}
@@ -219,7 +219,7 @@ smb2_wait_mtu_credits(struct cifs_server_info *server, unsigned int size,
 		} else {
 			spin_unlock(&server->req_lock);
 			spin_lock(&g_servers_lock);
-			if (server->status == CifsExiting) {
+			if (server->status == SERVER_STATUS_EXITING) {
 				spin_unlock(&g_servers_lock);
 				return -ENOENT;
 			}
@@ -5080,7 +5080,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 		} else {
 			spin_lock(&g_servers_lock);
 			spin_lock(&g_mid_lock);
-			if (dw->server->status == CifsNeedReconnect) {
+			if (dw->server->status == SERVER_STATUS_NEED_RECONNECT) {
 				mid->mid_state = MID_RETRY_NEEDED;
 				spin_unlock(&g_mid_lock);
 				spin_unlock(&g_servers_lock);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b5bdd7356d59..8b06b3267318 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -191,7 +191,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 * reconnect -- should be greater than cifs socket timeout which is 7
 	 * seconds.
 	 */
-	while (server->status == CifsNeedReconnect) {
+	while (server->status == SERVER_STATUS_NEED_RECONNECT) {
 		/*
 		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
 		 * here since they are implicitly done when session drops.
@@ -208,7 +208,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		}
 
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->status != CifsNeedReconnect),
+						      (server->status != SERVER_STATUS_NEED_RECONNECT),
 						      10 * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
@@ -218,7 +218,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 		/* are we still trying to reconnect? */
 		spin_lock(&g_servers_lock);
-		if (server->status != CifsNeedReconnect) {
+		if (server->status != SERVER_STATUS_NEED_RECONNECT) {
 			spin_unlock(&g_servers_lock);
 			break;
 		}
@@ -257,7 +257,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 * and status set to reconnect.
 	 */
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedReconnect) {
+	if (server->status == SERVER_STATUS_NEED_RECONNECT) {
 		spin_unlock(&g_servers_lock);
 		rc = -EHOSTDOWN;
 		goto out;
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 4417953ecbb2..5ffe472e692d 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -763,18 +763,18 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct cifs_server_info *server,
 		   struct smb2_hdr *shdr, struct mid_q_entry **mid)
 {
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsExiting) {
+	if (server->status == SERVER_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
 
-	if (server->status == CifsNeedReconnect) {
+	if (server->status == SERVER_STATUS_NEED_RECONNECT) {
 		spin_unlock(&g_servers_lock);
 		cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
 		return -EAGAIN;
 	}
 
-	if (server->status == CifsNeedNegotiate &&
+	if (server->status == SERVER_STATUS_NEED_NEGOTIATE &&
 	   shdr->Command != SMB2_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return -EAGAIN;
@@ -870,7 +870,7 @@ smb2_setup_async_request(struct cifs_server_info *server, struct smb_rqst *rqst)
 	struct mid_q_entry *mid;
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedNegotiate &&
+	if (server->status == SERVER_STATUS_NEED_NEGOTIATE &&
 	   shdr->Command != SMB2_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return ERR_PTR(-EAGAIN);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 22ed055c0c39..41da942de4a3 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -578,7 +578,7 @@ wait_for_free_credits(struct cifs_server_info *server, const int num_credits,
 			spin_unlock(&server->req_lock);
 
 			spin_lock(&g_servers_lock);
-			if (server->status == CifsExiting) {
+			if (server->status == SERVER_STATUS_EXITING) {
 				spin_unlock(&g_servers_lock);
 				return -ENOENT;
 			}
@@ -1079,7 +1079,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsExiting) {
+	if (server->status == SERVER_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1361,7 +1361,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsExiting) {
+	if (server->status == SERVER_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1506,7 +1506,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsExiting) {
+	if (server->status == SERVER_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1564,15 +1564,15 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	/* Wait for a reply - allow signals to interrupt. */
 	rc = wait_event_interruptible(server->response_q,
 		(!(midQ->mid_state == MID_REQUEST_SUBMITTED)) ||
-		((server->status != CifsGood) &&
-		 (server->status != CifsNew)));
+		((server->status != SERVER_STATUS_GOOD) &&
+		 (server->status != SERVER_STATUS_NEW)));
 
 	/* Were we interrupted by a signal ? */
 	spin_lock(&g_servers_lock);
 	if ((rc == -ERESTARTSYS) &&
 		(midQ->mid_state == MID_REQUEST_SUBMITTED) &&
-		((server->status == CifsGood) ||
-		 (server->status == CifsNew))) {
+		((server->status == SERVER_STATUS_GOOD) ||
+		 (server->status == SERVER_STATUS_NEW))) {
 		spin_unlock(&g_servers_lock);
 
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
-- 
2.35.3

