Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A5BC43334
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGXPMU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGXPMT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:12:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E1911159
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:12:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2294935066;
        Sun, 24 Jul 2022 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RaZxpFjvcsO1dxOmhWkU7isSXyuAa/BmEoj1qRkxiL0=;
        b=be9/zNtxVeDjGzeQYmCFKzgEm4Iiz7YmR/BqMd/yMw9PPdqYZ0UTmkWG04bZUixgea0Uwg
        JBMjUAe62Imsq6RzjqcWNpc97cYSjP1+R+yGwtC7BaNLG47pnKsRMXQjT1p3IqfMFZiOdN
        a+KPgNPjJjk0zgw+IDyV19Icn33Yzeo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675537;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RaZxpFjvcsO1dxOmhWkU7isSXyuAa/BmEoj1qRkxiL0=;
        b=yubO1t1qB/p2SqbvNpjpmbJqEFOwflHlAsut0TaWW8HCYnaeTfDBAKj3JV5faHq6Xi4Cw1
        XUdT/V6RYKmvqnCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D3E513A8D;
        Sun, 24 Jul 2022 15:12:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AoZ8GFBh3WJNMQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:12:16 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 08/14] cifs: typedef ses status enum
Date:   Sun, 24 Jul 2022 12:11:31 -0300
Message-Id: <20220724151137.7538-9-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220724151137.7538-1-ematsumiya@suse.de>
References: <20220724151137.7538-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

typedef "enum ses_status_enum" to "cifs_ses_status_t".
Rename the status values.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c    |  4 ++--
 fs/cifs/cifsglob.h      | 16 ++++++++--------
 fs/cifs/cifssmb.c       |  2 +-
 fs/cifs/connect.c       | 34 +++++++++++++++++-----------------
 fs/cifs/misc.c          |  2 +-
 fs/cifs/smb2pdu.c       |  2 +-
 fs/cifs/smb2transport.c |  4 ++--
 fs/cifs/transport.c     |  8 ++++----
 8 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index eb24928e1298..c88bea9d3ac3 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -382,7 +382,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				(ses->serverNOS == NULL)) {
 				seq_printf(m, "\n\t%d) Address: %s Uses: %d Capability: 0x%x\tSession Status: %d ",
 					i, ses->ip_addr, ses->ses_count,
-					ses->capabilities, ses->ses_status);
+					ses->capabilities, ses->status);
 				if (ses->session_flags & SMB2_SESSION_FLAG_IS_GUEST)
 					seq_printf(m, "Guest ");
 				else if (ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
@@ -394,7 +394,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 					"\n\tSMB session status: %d ",
 				i, ses->ip_addr, ses->serverDomain,
 				ses->ses_count, ses->serverOS, ses->serverNOS,
-				ses->capabilities, ses->ses_status);
+				ses->capabilities, ses->status);
 			}
 
 			seq_printf(m, "\n\tSecurity type: %s ",
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 49e0821fd61d..0fa23f392bb9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -121,13 +121,13 @@ typedef enum {
 } cifs_server_status_t;
 
 /* associated with each smb session */
-enum ses_status_enum {
-	SES_NEW = 0,
-	SES_GOOD,
-	SES_EXITING,
-	SES_NEED_RECON,
-	SES_IN_SETUP
-};
+typedef enum {
+	SES_STATUS_NEW = 0,
+	SES_STATUS_GOOD,
+	SES_STATUS_EXITING,
+	SES_STATUS_NEED_RECONNECT,
+	SES_STATUS_IN_SETUP
+} cifs_ses_status_t;
 
 /* associated with each tree connection to the server */
 enum tid_status_enum {
@@ -1011,7 +1011,7 @@ struct cifs_ses {
 	struct mutex session_mutex;
 	struct cifs_server_info *server;	/* pointer to server info */
 	int ses_count;		/* reference counter */
-	enum ses_status_enum ses_status;  /* updates protected by g_servers_lock */
+	cifs_ses_status_t status;  /* updates protected by g_servers_lock */
 	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c88a42ebb509..25009dd47f96 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -75,7 +75,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
-	if ((tcon->ses->ses_status != SES_GOOD) || (tcon->status != TID_NEED_RECON)) {
+	if ((tcon->ses->status != SES_STATUS_GOOD) || (tcon->status != TID_NEED_RECON)) {
 		spin_unlock(&g_servers_lock);
 		return;
 	}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ec014e007ff9..55264aef1b83 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -277,7 +277,7 @@ cifs_mark_server_conns_for_reconnect(struct cifs_server_info *server,
 		if (!mark_smb_session && !CIFS_ALL_CHANS_NEED_RECONNECT(ses))
 			goto next_session;
 
-		ses->ses_status = SES_NEED_RECON;
+		ses->status = SES_STATUS_NEED_RECONNECT;
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			tcon->need_reconnect = true;
@@ -1863,7 +1863,7 @@ cifs_find_smb_ses(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 
 	spin_lock(&g_servers_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		if (ses->ses_status == SES_EXITING)
+		if (ses->status == SES_STATUS_EXITING)
 			continue;
 		if (!match_session(ses, ctx))
 			continue;
@@ -1882,7 +1882,7 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	struct cifs_server_info *server = ses->server;
 
 	spin_lock(&g_servers_lock);
-	if (ses->ses_status == SES_EXITING) {
+	if (ses->status == SES_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return;
 	}
@@ -1898,13 +1898,13 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	/* ses_count can never go negative */
 	WARN_ON(ses->ses_count < 0);
 
-	if (ses->ses_status == SES_GOOD)
-		ses->ses_status = SES_EXITING;
+	if (ses->status == SES_STATUS_GOOD)
+		ses->status = SES_STATUS_EXITING;
 	spin_unlock(&g_servers_lock);
 
 	cifs_free_ipc(ses);
 
-	if (ses->ses_status == SES_EXITING && server->ops->logoff) {
+	if (ses->status == SES_STATUS_EXITING && server->ops->logoff) {
 		xid = get_xid();
 		rc = server->ops->logoff(xid, ses);
 		if (rc)
@@ -2113,7 +2113,7 @@ cifs_get_smb_ses(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 	ses = cifs_find_smb_ses(server, ctx);
 	if (ses) {
 		cifs_dbg(FYI, "Existing smb sess found (status=%d)\n",
-			 ses->ses_status);
+			 ses->status);
 
 		spin_lock(&ses->chan_lock);
 		if (cifs_chan_needs_reconnect(ses, server)) {
@@ -4029,9 +4029,9 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	else
 		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
 
-	if (ses->ses_status != SES_GOOD &&
-	    ses->ses_status != SES_NEW &&
-	    ses->ses_status != SES_NEED_RECON) {
+	if (ses->status != SES_STATUS_GOOD &&
+	    ses->status != SES_STATUS_NEW &&
+	    ses->status != SES_STATUS_NEED_RECONNECT) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
@@ -4049,7 +4049,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	spin_unlock(&ses->chan_lock);
 
 	if (!is_binding)
-		ses->ses_status = SES_IN_SETUP;
+		ses->status = SES_STATUS_IN_SETUP;
 	spin_unlock(&g_servers_lock);
 
 	if (!is_binding) {
@@ -4075,16 +4075,16 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
 		spin_lock(&g_servers_lock);
-		if (ses->ses_status == SES_IN_SETUP)
-			ses->ses_status = SES_NEED_RECON;
+		if (ses->status == SES_STATUS_IN_SETUP)
+			ses->status = SES_STATUS_NEED_RECONNECT;
 		spin_lock(&ses->chan_lock);
 		cifs_chan_clear_in_reconnect(ses, server);
 		spin_unlock(&ses->chan_lock);
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (ses->ses_status == SES_IN_SETUP)
-			ses->ses_status = SES_GOOD;
+		if (ses->status == SES_STATUS_IN_SETUP)
+			ses->status = SES_STATUS_GOOD;
 		spin_lock(&ses->chan_lock);
 		cifs_chan_clear_in_reconnect(ses, server);
 		cifs_chan_clear_need_reconnect(ses, server);
@@ -4559,7 +4559,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
-	if (tcon->ses->ses_status != SES_GOOD ||
+	if (tcon->ses->status != SES_STATUS_GOOD ||
 	    (tcon->status != TID_NEW &&
 	    tcon->status != TID_NEED_TCON)) {
 		spin_unlock(&g_servers_lock);
@@ -4627,7 +4627,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
-	if (tcon->ses->ses_status != SES_GOOD ||
+	if (tcon->ses->status != SES_STATUS_GOOD ||
 	    (tcon->status != TID_NEW &&
 	    tcon->status != TID_NEED_TCON)) {
 		spin_unlock(&g_servers_lock);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a31780cf6d21..e209aa3194de 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -69,7 +69,7 @@ sesInfoAlloc(void)
 	ret_buf = kzalloc(sizeof(struct cifs_ses), GFP_KERNEL);
 	if (ret_buf) {
 		atomic_inc(&g_ses_alloc_count);
-		ret_buf->ses_status = SES_NEW;
+		ret_buf->status = SES_STATUS_NEW;
 		++ret_buf->ses_count;
 		INIT_LIST_HEAD(&ret_buf->smb_ses_list);
 		INIT_LIST_HEAD(&ret_buf->tcon_list);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8b06b3267318..e495121f7d99 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -179,7 +179,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		}
 	}
 	spin_unlock(&g_servers_lock);
-	if ((!tcon->ses) || (tcon->ses->ses_status == SES_EXITING) ||
+	if ((!tcon->ses) || (tcon->ses->status == SES_STATUS_EXITING) ||
 	    (!tcon->ses->server) || !server)
 		return -EIO;
 
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 5ffe472e692d..5ac2dbffb939 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -780,7 +780,7 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct cifs_server_info *server,
 		return -EAGAIN;
 	}
 
-	if (ses->ses_status == SES_NEW) {
+	if (ses->status == SES_STATUS_NEW) {
 		if ((shdr->Command != SMB2_SESSION_SETUP) &&
 		    (shdr->Command != SMB2_NEGOTIATE)) {
 			spin_unlock(&g_servers_lock);
@@ -789,7 +789,7 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct cifs_server_info *server,
 		/* else ok - we are setting up session */
 	}
 
-	if (ses->ses_status == SES_EXITING) {
+	if (ses->status == SES_STATUS_EXITING) {
 		if (shdr->Command != SMB2_LOGOFF) {
 			spin_unlock(&g_servers_lock);
 			return -EAGAIN;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 41da942de4a3..b681a0c9b03d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -726,7 +726,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 			struct mid_q_entry **ppmidQ)
 {
 	spin_lock(&g_servers_lock);
-	if (ses->ses_status == SES_NEW) {
+	if (ses->status == SES_STATUS_NEW) {
 		if ((in_buf->Command != SMB_COM_SESSION_SETUP_ANDX) &&
 			(in_buf->Command != SMB_COM_NEGOTIATE)) {
 			spin_unlock(&g_servers_lock);
@@ -735,7 +735,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 		/* else ok - we are setting up session */
 	}
 
-	if (ses->ses_status == SES_EXITING) {
+	if (ses->status == SES_STATUS_EXITING) {
 		/* check if SMB session is bad because we are setting it up */
 		if (in_buf->Command != SMB_COM_LOGOFF_ANDX) {
 			spin_unlock(&g_servers_lock);
@@ -1187,7 +1187,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * Compounding is never used during session establish.
 	 */
 	spin_lock(&g_servers_lock);
-	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+	if ((ses->status == SES_STATUS_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
 		spin_unlock(&g_servers_lock);
 
 		cifs_server_lock(server);
@@ -1260,7 +1260,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * Compounding is never used during session establish.
 	 */
 	spin_lock(&g_servers_lock);
-	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+	if ((ses->status == SES_STATUS_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
 		struct kvec iov = {
 			.iov_base = resp_iov[0].iov_base,
 			.iov_len = resp_iov[0].iov_len
-- 
2.35.3

