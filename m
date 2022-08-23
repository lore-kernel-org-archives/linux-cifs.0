Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1217C3F6B0
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 16:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245519AbiHWQrg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344207AbiHWQq4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 12:46:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8567A4333D
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 07:25:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3F1B5336D3;
        Tue, 23 Aug 2022 14:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661264749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=FRiDfbzoZjLNE7BTK/xoJrrs44csNNw8IowgS4kMkZw=;
        b=cp2B6Mls6PaNOHjVJwdKIZgqtTb521ogp8GlYMXMO9oVhvdB6TvAviw9NolbGgrsjCdABz
        /e6cFxHggLBJWzrvwGz7HrXnKkzDhGPF1Z9QPbpE/dOCI13kEQO2CsOKi3R1JUthtZZ6Nd
        J9QAUKuc0lIvzztw4OPlL+LuCw2XEqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661264749;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=FRiDfbzoZjLNE7BTK/xoJrrs44csNNw8IowgS4kMkZw=;
        b=VWOQk4DsyqqqUu7qw3Lv7g7TakrvPBq9aSqPfAE4Va1oFXPEJ0K2Sfstv3d3ppSdD4YBFK
        gH1dZ5tkrW+X5pBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B70F213AB7;
        Tue, 23 Aug 2022 14:25:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2PZZHmzjBGNZfwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 23 Aug 2022 14:25:48 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: decouple code to handle an existing session
Date:   Tue, 23 Aug 2022 11:25:45 -0300
Message-Id: <20220823142545.9101-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Create a new get_existing_smb_ses() function to handle existing SMB
sessions. Also simplify the logic from that snippet a little bit.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/connect.c | 79 ++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 49162973ca30..2701b3351556 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2151,6 +2151,49 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx __attribute__((unused)),
 }
 #endif /* CONFIG_KEYS */
 
+static struct cifs_ses *get_existing_smb_ses(unsigned int xid,
+					     struct TCP_Server_Info *server,
+					     struct cifs_ses *ses,
+					     struct nls_table *cp)
+{
+	bool need_reconnect = false;
+	struct cifs_ses *sesp = NULL;
+	int rc = 0;
+
+	spin_lock(&ses->chan_lock);
+	need_reconnect = cifs_chan_needs_reconnect(ses, server);
+	spin_unlock(&ses->chan_lock);
+
+	if (need_reconnect) {
+		cifs_dbg(FYI, "Session needs reconnect\n");
+
+		mutex_lock(&ses->session_mutex);
+		rc = cifs_negotiate_protocol(xid, ses, server);
+		if (rc)
+			goto out_err;
+
+		rc = cifs_setup_session(xid, ses, server, cp);
+		if (rc)
+			goto out_err;
+		mutex_unlock(&ses->session_mutex);
+		sesp = ses;
+		rc = 0; /* ensure rc = 0 by now */
+	}
+
+	/* existing SMB ses has a server reference already */
+	cifs_put_tcp_session(server, 0);
+out_err:
+	if (rc) {
+		mutex_unlock(&ses->session_mutex);
+		cifs_put_smb_ses(ses);
+		sesp = ERR_PTR(rc);
+	}
+
+	free_xid(xid);
+
+	return sesp;
+}
+
 /**
  * cifs_get_smb_ses - get a session matching @ctx data from @server
  * @server: server to setup the session to
@@ -2175,41 +2218,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	if (ses) {
 		cifs_dbg(FYI, "Existing smb sess found (status=%d)\n",
 			 ses->ses_status);
-
-		spin_lock(&ses->chan_lock);
-		if (cifs_chan_needs_reconnect(ses, server)) {
-			spin_unlock(&ses->chan_lock);
-			cifs_dbg(FYI, "Session needs reconnect\n");
-
-			mutex_lock(&ses->session_mutex);
-			rc = cifs_negotiate_protocol(xid, ses, server);
-			if (rc) {
-				mutex_unlock(&ses->session_mutex);
-				/* problem -- put our ses reference */
-				cifs_put_smb_ses(ses);
-				free_xid(xid);
-				return ERR_PTR(rc);
-			}
-
-			rc = cifs_setup_session(xid, ses, server,
-						ctx->local_nls);
-			if (rc) {
-				mutex_unlock(&ses->session_mutex);
-				/* problem -- put our reference */
-				cifs_put_smb_ses(ses);
-				free_xid(xid);
-				return ERR_PTR(rc);
-			}
-			mutex_unlock(&ses->session_mutex);
-
-			spin_lock(&ses->chan_lock);
-		}
-		spin_unlock(&ses->chan_lock);
-
-		/* existing SMB ses has a server reference already */
-		cifs_put_tcp_session(server, 0);
-		free_xid(xid);
-		return ses;
+		return get_existing_smb_ses(xid, server, ses, ctx->local_nls);
 	}
 
 	cifs_dbg(FYI, "Existing smb sess not found\n");
-- 
2.35.3

