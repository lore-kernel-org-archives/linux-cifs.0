Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74393A1A58
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675032; cv=none; b=aMn1fxqZLRZFG7CRL6xJ66oJnDsyuD4hp0eIW0bvQpwhwpvTLsJjbBYVz6BF3uPwiGH4KG9Zd8fnKTvsJ9B+soZ3hsPcpYjfguiAo9Bn1dVsqmo4CQdMdKWlc3Ukh5VlDWY6BDb4sBPt9Mu55y2Nz1uPWvDDZuKHoaycIa88XRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675032; c=relaxed/simple;
	bh=OrVPVsFSzmU5CJwWG3CyKxFMe8sudqLVOUBioJ4GPfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmMLWVmgGRwNCP9nGmR6XPOwcPV/Vp2cf9uKPyHQL5dq/u51OZ6Yz8Rgd5xku/sYgpq16YMdsqZzq4PA4pfyBDmntxrM4srcNPOrEVmpox4TP0h9sf4c8L2bapJjozvjyC/hVVdHzonVQHdivVRGbt1dqwYUKMTdX+LwrErJDFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LJR2YccJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LJR2YccJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LJR2YccJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LJR2YccJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8FA85766F1;
	Fri, 10 Jul 2026 09:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O69mI336td59A3s5aajBOubP07CWlb0nqDloFYrQLso=;
	b=LJR2YccJGC3XVJm1Vmt0wK3WTmHcsgJH1w3L7ffkxteAYUNZpZQ58tl5oTSSGuo84fDfwF
	aRPXKJFezaMEEIzHNjuaG0y+exddig++pTKeODSdvvNn+66Fd0E/mw96Uk0M7dXvJPNhZa
	0ak0qKC8taIDPxnm+CPuyj/lpK1a4pk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675021; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O69mI336td59A3s5aajBOubP07CWlb0nqDloFYrQLso=;
	b=LJR2YccJGC3XVJm1Vmt0wK3WTmHcsgJH1w3L7ffkxteAYUNZpZQ58tl5oTSSGuo84fDfwF
	aRPXKJFezaMEEIzHNjuaG0y+exddig++pTKeODSdvvNn+66Fd0E/mw96Uk0M7dXvJPNhZa
	0ak0qKC8taIDPxnm+CPuyj/lpK1a4pk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFA23779BD;
	Fri, 10 Jul 2026 09:17:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kLmcN4y4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:00 +0000
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
Subject: [PATCH 06/18] smb:client: Store the tcon dstaddr in the witness registration
Date: Fri, 10 Jul 2026 11:16:25 +0200
Message-ID: <20260710091637.58873-7-scabrero@suse.com>
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

Prepare to remove the tcon pointer from cifs_swn_reg struct.

Always use the address stored in the swnreg to send the register netlink
message.

To find the swnreg matching a tcon the stored address is compared to the
tcon dstaddr.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 125 ++++++++++++++++++---------------------
 1 file changed, 56 insertions(+), 69 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 36e199eb04c1..a33caaf4aaf0 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -25,6 +25,7 @@ struct cifs_swn_reg {
 
 	const char *net_name;
 	const char *share_name;
+	struct sockaddr_storage addr;
 	bool net_name_notify;
 	bool share_name_notify;
 	bool ip_notify;
@@ -81,7 +82,6 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 	struct sk_buff *skb;
 	struct genlmsghdr *hdr;
 	enum securityEnum authtype;
-	struct sockaddr_storage *addr;
 	int ret;
 
 	skb = genlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -106,18 +106,8 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 	if (ret < 0)
 		goto nlmsg_fail;
 
-	/*
-	 * If there is an address stored use it instead of the server address, because we are
-	 * in the process of reconnecting to it after a share has been moved or we have been
-	 * told to switch to it (client move message). In these cases we unregister from the
-	 * server address and register to the new address when we receive the notification.
-	 */
-	if (swnreg->tcon->ses->server->use_swn_dstaddr)
-		addr = &swnreg->tcon->ses->server->swn_dstaddr;
-	else
-		addr = &swnreg->tcon->ses->server->dstaddr;
-
-	ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP, sizeof(struct sockaddr_storage), addr);
+	ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP,
+		      sizeof(struct sockaddr_storage), &swnreg->addr);
 	if (ret < 0)
 		goto nlmsg_fail;
 
@@ -207,8 +197,8 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
 	if (ret < 0)
 		goto nlmsg_fail;
 
-	ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP, sizeof(struct sockaddr_storage),
-			&swnreg->tcon->ses->server->dstaddr);
+	ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP,
+		      sizeof(struct sockaddr_storage), &swnreg->addr);
 	if (ret < 0)
 		goto nlmsg_fail;
 
@@ -290,7 +280,6 @@ static void cifs_swn_reg_check(struct work_struct *work)
 	}
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
-
 	/*
 	 * It is safe to send the registration message multiple times.
 	 * The userspace client library tracks if registered or not
@@ -347,13 +336,23 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 	}
 
 	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
-		if (strcasecmp(swnreg->net_name, net_name) != 0
-		    || strcasecmp(swnreg->share_name, share_name) != 0) {
+		struct sockaddr_storage *tcon_dstaddr;
+
+		if (tcon->ses->server->use_swn_dstaddr)
+			tcon_dstaddr = &tcon->ses->server->swn_dstaddr;
+		else
+			tcon_dstaddr = &tcon->ses->server->dstaddr;
+
+		if (strcasecmp(swnreg->net_name, net_name) != 0 ||
+		    strcasecmp(swnreg->share_name, share_name) != 0 ||
+		    !cifs_match_ipaddr((struct sockaddr *)&swnreg->addr,
+				       (struct sockaddr *)tcon_dstaddr)) {
 			continue;
 		}
 
-		cifs_dbg(FYI, "Existing swn registration for %s:%s found\n", swnreg->net_name,
-				swnreg->share_name);
+		cifs_dbg(FYI,
+			 "Existing swn registration for %pISc:%s:%s found\n",
+			 &swnreg->addr, swnreg->net_name, swnreg->share_name);
 
 		kfree(net_name);
 		kfree(share_name);
@@ -416,6 +415,17 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 		goto fail_net_name;
 	}
 
+	/*
+	 * If there is an address stored use it instead of the server address, because we are
+	 * in the process of reconnecting to it after a share has been moved or we have been
+	 * told to switch to it (client move message). In these cases we unregister from the
+	 * server address and register to the new address when we receive the notification.
+	 */
+	if (tcon->ses->server->use_swn_dstaddr)
+		swnreg->addr = tcon->ses->server->swn_dstaddr;
+	else
+		swnreg->addr = tcon->ses->server->dstaddr;
+
 	swnreg->net_name_notify = true;
 	swnreg->share_name_notify =
 		(tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC);
@@ -461,26 +471,6 @@ static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const ch
 	return 0;
 }
 
-static bool cifs_sockaddr_equal(struct sockaddr_storage *addr1, struct sockaddr_storage *addr2)
-{
-	if (addr1->ss_family != addr2->ss_family)
-		return false;
-
-	if (addr1->ss_family == AF_INET) {
-		return (memcmp(&((const struct sockaddr_in *)addr1)->sin_addr,
-				&((const struct sockaddr_in *)addr2)->sin_addr,
-				sizeof(struct in_addr)) == 0);
-	}
-
-	if (addr1->ss_family == AF_INET6) {
-		return (memcmp(&((const struct sockaddr_in6 *)addr1)->sin6_addr,
-				&((const struct sockaddr_in6 *)addr2)->sin6_addr,
-				sizeof(struct in6_addr)) == 0);
-	}
-
-	return false;
-}
-
 static int cifs_swn_store_swn_addr(const struct sockaddr_storage *new,
 				   const struct sockaddr_storage *old,
 				   struct sockaddr_storage *dst)
@@ -516,18 +506,13 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 {
 	int ret = 0;
 
-	/* Store the reconnect address */
 	cifs_server_lock(tcon->ses->server);
-	if (cifs_sockaddr_equal(&tcon->ses->server->dstaddr, addr))
-		goto unlock;
 
-	ret = cifs_swn_store_swn_addr(addr, &tcon->ses->server->dstaddr,
-				      &tcon->ses->server->swn_dstaddr);
-	if (ret < 0) {
-		cifs_dbg(VFS, "%s: failed to store address: %d\n", __func__, ret);
+	if (cifs_match_ipaddr((struct sockaddr *)&tcon->ses->server->dstaddr,
+			      (struct sockaddr *)addr)) {
+		/* no-op */
 		goto unlock;
 	}
-	tcon->ses->server->use_swn_dstaddr = true;
 
 	/*
 	 * Unregister to stop receiving notifications for the old IP address.
@@ -536,8 +521,23 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 	if (ret < 0) {
 		cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
 			 __func__, ret);
+		/*
+		 * Do not jump return on error, continue storing and registering for
+		 * notifications for the new address. There will be a stale registration
+		 * around running its periodic check task, which should cancel itself
+		 * if no matching any tcon.
+		 */
+	}
+
+	/* Store the reconnect address */
+	ret = cifs_swn_store_swn_addr(addr, &tcon->ses->server->dstaddr,
+				      &tcon->ses->server->swn_dstaddr);
+	if (ret < 0) {
+		cifs_dbg(VFS, "%s: failed to store address: %d\n", __func__,
+			 ret);
 		goto unlock;
 	}
+	tcon->ses->server->use_swn_dstaddr = true;
 
 	/*
 	 * And register to receive notifications for the new IP address now that we have
@@ -681,33 +681,20 @@ int cifs_swn_unregister(struct cifs_tcon *tcon)
 void cifs_swn_dump(struct seq_file *m)
 {
 	struct cifs_swn_reg *swnreg;
-	struct sockaddr_in *sa;
-	struct sockaddr_in6 *sa6;
 	int id;
 
 	seq_puts(m, "Witness registrations:");
 
 	mutex_lock(&cifs_swnreg_idr_mutex);
 	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
-		seq_printf(m, "\nId: %u Refs: %u Network name: '%s'%s Share name: '%s'%s Ip address: ",
-				id, kref_read(&swnreg->ref_count),
-				swnreg->net_name, swnreg->net_name_notify ? "(y)" : "(n)",
-				swnreg->share_name, swnreg->share_name_notify ? "(y)" : "(n)");
-		switch (swnreg->tcon->ses->server->dstaddr.ss_family) {
-		case AF_INET:
-			sa = (struct sockaddr_in *) &swnreg->tcon->ses->server->dstaddr;
-			seq_printf(m, "%pI4", &sa->sin_addr.s_addr);
-			break;
-		case AF_INET6:
-			sa6 = (struct sockaddr_in6 *) &swnreg->tcon->ses->server->dstaddr;
-			seq_printf(m, "%pI6", &sa6->sin6_addr.s6_addr);
-			if (sa6->sin6_scope_id)
-				seq_printf(m, "%%%u", sa6->sin6_scope_id);
-			break;
-		default:
-			seq_puts(m, "(unknown)");
-		}
-		seq_printf(m, "%s", swnreg->ip_notify ? "(y)" : "(n)");
+		seq_printf(
+			m,
+			"\nId: %u Refs: %u Network name: '%s'%s Share name: '%s'%s Ip address: '%pISc'%s",
+			id, kref_read(&swnreg->ref_count), swnreg->net_name,
+			swnreg->net_name_notify ? "(y)" : "(n)",
+			swnreg->share_name,
+			swnreg->share_name_notify ? "(y)" : "(n)",
+			&swnreg->addr, swnreg->ip_notify ? "(y)" : "(n)");
 	}
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 	seq_puts(m, "\n");
-- 
2.54.0

