Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991D13DB330
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675064; cv=none; b=Pvx1QyvYo9kS0l++5aXlxGQjTwwpoaMvjnAoEypxTJcAdYGH4MwxMSIo7m24P4HdQp09V78cNnr+foAKK1BEbIhcVWJ36csazfaIQfjPBNLQspjC7H0wZ+zualOBX5BPFR4zH7c2VfuR0zPZuhtzBtjkhfGukHuR6kAshdtG9Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675064; c=relaxed/simple;
	bh=Yk30+JS7cxbIpmfBavJUf+RBtbOxcpSOv9LzyRRiklY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMsYO8MAcEyfAK/w29kxrs6OOnNPPQYzYNRzQ6MFCZqP9mPzJSl3y3NKemRoR3u8UhKSh4KTf+V+FA21+wcKIyOqjJ40Sa4NyR/ahW0YiAL2D+ag9ZIdAhfk+2+l78d9fmsSfJi06PATHNAq3rtyRFLtLi2d2KVy5xXimYNyTTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g07g20Wz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P7oMU9UP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g07g20Wz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P7oMU9UP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE5C7766E4;
	Fri, 10 Jul 2026 09:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/lNoQKsFIof4V7q0emsjEtVN3ftXRHEv2ceUJuPoM8=;
	b=g07g20WzkpdoZ3oAzm6kaVyzNqGE7HEH/D1psO8LF4Y9DM2zrF96VUC4RoFUetocMI0F8B
	48o6wOdEB8En3wLmS/enpb6aQth3xcUJNH7r3xZ6dN9L9E46w7YstuWfg70s5IatEx/nBJ
	3HXTj+fKvvGIu4/66hgH5BBiX6dMSC4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/lNoQKsFIof4V7q0emsjEtVN3ftXRHEv2ceUJuPoM8=;
	b=P7oMU9UP+A0uWC4ylOo/QiS4teYnOb8bHW8L72a2/QmwjCdF8YtH/gUGeQ8hAsXTI76KIx
	raahjgUwI70zqvLGGsyNKAqwSwbnMJKAwQbNcfAIq3NAF/Ik7uABnzORhDU8EdJkaa4yU2
	pCZS/De3wOzHSCdlrc2MNZ6Yr0G6t+s=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5964F779BD;
	Fri, 10 Jul 2026 09:17:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EGTsEpW4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:09 +0000
From: Samuel Cabrero <scabrero@suse.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de,
	Samuel Cabrero <scabrero@suse.com>
Subject: [PATCH 18/18] smb:client: Avoid witness re-register if the address did not change
Date: Fri, 10 Jul 2026 11:16:37 +0200
Message-ID: <20260710091637.58873-19-scabrero@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710091637.58873-1-scabrero@suse.com>
References: <20260710091637.58873-1-scabrero@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,suse.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_SEVEN(0.00)[10];
	R_RATELIMIT(0.00)[to_ip_from(RLsmepzun9ugcn3tumbc3b9wxd)];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 

If received a client-move notification with a destination address
matching the current one, skip unregister and register to the same
address.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 67 ++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index a196b06c4b8c..fabde01d998a 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -626,7 +626,7 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 	return ERR_PTR(-ENOENT);
 }
 
-static void cifs_swn_resource_state_changed(struct cifs_tcon *tcon,
+static bool cifs_swn_resource_state_changed(struct cifs_tcon *tcon,
 					    const char *name, int state)
 {
 	switch (state) {
@@ -642,6 +642,9 @@ static void cifs_swn_resource_state_changed(struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "%s: resource name '%s' changed to unknown state\n", __func__, name);
 		break;
 	}
+
+	/* Address has not changed */
+	return false;
 }
 
 static int cifs_swn_store_swn_addr(const struct sockaddr_storage *new,
@@ -678,21 +681,16 @@ static int cifs_swn_store_swn_addr(const struct sockaddr_storage *new,
 static bool cifs_swn_client_move(struct cifs_tcon *tcon,
 				 struct sockaddr_storage *addr)
 {
-	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
-	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
 	int ret;
 
-	if (addr->ss_family == AF_INET)
-		cifs_dbg(FYI, "%s: move to %pI4\n", __func__, &ipv4->sin_addr);
-	else if (addr->ss_family == AF_INET6)
-		cifs_dbg(FYI, "%s: move to %pI6\n", __func__, &ipv6->sin6_addr);
-
 	if (cifs_match_ipaddr((struct sockaddr *)&tcon->ses->server->dstaddr,
 			      (struct sockaddr *)addr)) {
 		/* no-op */
 		return false;
 	}
 
+	cifs_dbg(FYI, "%s: move to %pISc\n", __func__, addr);
+
 	/* Store the reconnect address */
 	ret = cifs_swn_store_swn_addr(addr, &tcon->ses->server->dstaddr,
 				      &tcon->ses->server->swn_dstaddr);
@@ -705,6 +703,7 @@ static bool cifs_swn_client_move(struct cifs_tcon *tcon,
 
 	cifs_signal_cifsd_for_reconnect(tcon->ses->server, false);
 
+	/* Address changed */
 	return true;
 }
 
@@ -719,10 +718,9 @@ cifs_swn_handle_notification_tcon(const struct cifs_swn_notification *not,
 {
 	switch (not->type) {
 	case CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE:
-		cifs_swn_resource_state_changed(
+		return cifs_swn_resource_state_changed(
 			tcon, not->data.resource_name_changed.name,
 			not->data.resource_name_changed.state);
-		return false;
 	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE:
 		return cifs_swn_client_move(tcon, not->data.client_move.addr);
 	default:
@@ -743,6 +741,7 @@ static int cifs_swn_handle_notification(const struct cifs_swn_notification *not)
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
+	bool addr_changed = false;
 	int ret;
 
 	/* Walk the tcons and apply the notification to matching ones */
@@ -761,7 +760,9 @@ static int cifs_swn_handle_notification(const struct cifs_swn_notification *not)
 					spin_unlock(&tcon->tc_lock);
 					continue;
 				}
-				cifs_swn_handle_notification_tcon(not, tcon);
+				addr_changed |=
+					cifs_swn_handle_notification_tcon(not,
+									  tcon);
 				spin_unlock(&tcon->tc_lock);
 			}
 		}
@@ -769,31 +770,29 @@ static int cifs_swn_handle_notification(const struct cifs_swn_notification *not)
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	switch (not->type) {
-	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE:
-		/* Unregister from the current address */
-		ret = cifs_swn_send_unregister_message(not->swnreg);
-		if (ret < 0) {
-			cifs_dbg(VFS,
-				 "%s: Failed to unregister for witness notifications: %d\n",
-				 __func__, ret);
-		}
+	if (!addr_changed)
+		return 0;
 
-		/* Store the new address */
-		not->swnreg->addr = *not->data.client_move.addr;
+	/*
+	 * If the address has changed, unregister from the previous and
+	 * register for the new one
+	 */
+	ret = cifs_swn_send_unregister_message(not->swnreg);
+	if (ret < 0) {
+		cifs_dbg(VFS,
+			"%s: Failed to unregister for witness notifications: %d\n",
+			__func__, ret);
+	}
 
-		/* Register for this new address */
-		ret = cifs_swn_send_register_message(not->swnreg);
-		if (ret < 0) {
-			cifs_dbg(VFS,
-				 "%s: Failed to register for witness notifications: %d\n",
-				 __func__, ret);
-		}
-		break;
-	default:
-		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__,
-			 not->type);
-		break;
+	/* Store the new address */
+	not->swnreg->addr = *not->data.client_move.addr;
+
+	/* Register for this new address */
+	ret = cifs_swn_send_register_message(not->swnreg);
+	if (ret < 0) {
+		cifs_dbg(VFS,
+			"%s: Failed to register for witness notifications: %d\n",
+			__func__, ret);
 	}
 
 	return 0;
-- 
2.54.0

