Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BADC32774
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 16:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245320AbiHWQkA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244924AbiHWQjY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 12:39:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648C02715B
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 07:41:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F2C5B1F99D;
        Tue, 23 Aug 2022 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661265700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=XZa29i1BszX9kp+671caTZUosdGyRXMmtUojhfxDt4Q=;
        b=KkyIovGk0PosqQ2BJk7qGYyrcRoW/9HeSYq+U6n6xd54En3hDDxNnIYA8WKLoLN4DgGrmg
        MhVWoxAlIdI3AtitQOZp1IaFvONXYlzfBetHDR4AkXvQzMCLdXcPa1KzxhGjtHxEFvcOA9
        HNG4iObIhtyFpLu5LkGc72bkED5CB24=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661265700;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=XZa29i1BszX9kp+671caTZUosdGyRXMmtUojhfxDt4Q=;
        b=wVsEtUmWnvuoSaFCgDASqi1dJvDQnuUUa7xdoYnZksMXkqW55n7AFDn5m1PuWsugFTBAZb
        LDtv29hV/aohsqAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A46413AB7;
        Tue, 23 Aug 2022 14:41:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hVMNECPnBGPwBwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 23 Aug 2022 14:41:39 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH v2] cifs: fix some memory leak when negotiate/session setup fails
Date:   Tue, 23 Aug 2022 11:41:33 -0300
Message-Id: <20220823144133.7626-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix memory leaks from some ses fields when cifs_negotiate_protocol() or
cifs_setup_session() fails in cifs_get_smb_ses().

A leak from ses->domainName has also been identified in setup_ntlmv2_rsp()
when session setup fails.

These has been reported by kmemleak.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2: replace kfree by kfree_sensitive() for ses->password

 fs/cifs/cifsencrypt.c |  5 +++++
 fs/cifs/connect.c     | 22 ++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 8f7835ccbca1..6b681b7084f5 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -680,6 +680,11 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 unlock:
 	cifs_server_unlock(ses->server);
 setup_ntlmv2_rsp_ret:
+	if (rc && ses->domainName) {
+		kfree(ses->domainName);
+		ses->domainName = NULL;
+	}
+
 	kfree(tiblob);
 
 	return rc;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3da5da9f16b0..7d8cd0f85ade 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2215,7 +2215,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	cifs_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)
-		goto get_ses_fail;
+		goto out;
 
 	/* new SMB session uses our server ref */
 	ses->server = server;
@@ -2227,19 +2227,19 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	if (ctx->username) {
 		ses->user_name = kstrdup(ctx->username, GFP_KERNEL);
 		if (!ses->user_name)
-			goto get_ses_fail;
+			goto out_free_ses;
 	}
 
 	/* ctx->password freed at unmount */
 	if (ctx->password) {
 		ses->password = kstrdup(ctx->password, GFP_KERNEL);
 		if (!ses->password)
-			goto get_ses_fail;
+			goto out_free_username;
 	}
 	if (ctx->domainname) {
 		ses->domainName = kstrdup(ctx->domainname, GFP_KERNEL);
 		if (!ses->domainName)
-			goto get_ses_fail;
+			goto out_free_pw;
 	}
 
 	strscpy(ses->workstation_name, ctx->workstation_name, sizeof(ses->workstation_name));
@@ -2273,7 +2273,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	spin_unlock(&ses->chan_lock);
 
 	if (rc)
-		goto get_ses_fail;
+		goto out_free_domain;
 
 	/*
 	 * success, put it on the list and add it as first channel
@@ -2290,8 +2290,18 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 	return ses;
 
-get_ses_fail:
+out_free_domain:
+	kfree(ses->domainName);
+	ses->domainName = NULL;
+out_free_pw:
+	kfree_sensitive(ses->password);
+	ses->password = NULL;
+out_free_username:
+	kfree(ses->user_name);
+	ses->user_name = NULL;
+out_free_ses:
 	sesInfoFree(ses);
+out:
 	free_xid(xid);
 	return ERR_PTR(rc);
 }
-- 
2.35.3

