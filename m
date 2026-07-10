Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92823DB325
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675057; cv=none; b=hb4nw26DpvgSaODY8Ye1xZZ5CmYznwS4KOlgIDcp47ePBq9vhoGutDxmRT4KeHMEdTvPR744yS4il0oly2fIV7IcqVN38SUlBnH0xxR8X9EKGZ9wbm609PpoPUF2PSfjmX8Av2+6+SYTIEBwzct9dDbpvy4Qm37o+iX2j3rPyjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675057; c=relaxed/simple;
	bh=mQR7WImh3dWR8D74daVSt72AJLMvdCXovHlJ6KTTajc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBRHtq6skH0xYWY1CwRvA2+ll5nRE9bwLXnWtV11soOqRrbS89iMQK09eyOhrBd+ztliiquW/dquwLVXeHYIcy7PZrPqUz/jc7oYOTO++8iToTjxPxZBzGjlmRSg7tSEpsYwG6Px/LQSj4HP6X5F0z2fJAlrM+TKMz59apY7qLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=X92/bFbd; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qZjyXiac; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="X92/bFbd";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qZjyXiac"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D9DC97670F;
	Fri, 10 Jul 2026 09:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMw9GP5308buMAd+XQ6lzqD5xtesSz8NEKO4qXDYId0=;
	b=X92/bFbdjUktdPuRfl9x9GvAnlvhganCMTsO+tus+E1lmL98oMpr+vSDVH7BaHICYAQcbc
	Pj+gpR+zf2jB+5EfuHIN4coupkr//XTQy6IH5A4HFy7Szq7RFVX2yRM4AMntT48pz2Eyyy
	idb5D8vDprQaXwgYxU3EZfdw3JCmZVA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMw9GP5308buMAd+XQ6lzqD5xtesSz8NEKO4qXDYId0=;
	b=qZjyXiacGwRqxWjAJQalv+eY96Sml7mN6ieFy8vx1L/H4lnRCnWcAT9uuqEOeHsXw19s4U
	svepOd00X5dZfnlMOyvbozZzp57nxAIea11PQnGijG13NvyyKMVk6piAFa6PuTvfyyb74T
	e0xFS+NuDVFMc5gJzur8icv5QS66dMk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4585A779BD;
	Fri, 10 Jul 2026 09:17:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EEAQDpO4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:07 +0000
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
Subject: [PATCH 15/18] smb:client: Do not store the tcon reference, find a matching one
Date: Fri, 10 Jul 2026 11:16:34 +0200
Message-ID: <20260710091637.58873-16-scabrero@suse.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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

Finally remove the cached tcon pointer from the registration.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 227 ++++++++++++++++++++++++++++-----------
 fs/smb/client/trace.h    |   2 +
 2 files changed, 166 insertions(+), 63 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 6d8e3b94a432..97e415e441e4 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -42,8 +42,6 @@ struct cifs_swn_reg {
 		} ntlm;
 	} authinfo;
 
-	struct cifs_tcon *tcon;
-
 	unsigned long check_interval;
 	struct delayed_work check;
 };
@@ -288,13 +286,46 @@ static bool cifs_swn_reg_tcon_matches(const struct cifs_swn_reg *swnreg,
 	return true;
 }
 
+static struct cifs_tcon *
+cifs_swn_reg_get_tcon(const struct cifs_swn_reg *swnreg)
+{
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		if (SERVER_IS_CHAN(server))
+			continue;
+
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+				spin_lock(&tcon->tc_lock);
+				if (tcon->status == TID_EXITING ||
+				    !cifs_swn_reg_tcon_matches(swnreg, tcon)) {
+					spin_unlock(&tcon->tc_lock);
+					continue;
+				}
+				++tcon->tc_count;
+				trace_smb3_tcon_ref(
+					tcon->debug_id, tcon->tc_count,
+					netfs_trace_tcon_ref_get_swn);
+				spin_unlock(&tcon->tc_lock);
+				spin_unlock(&cifs_tcp_ses_lock);
+				return tcon;
+			}
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+	return ERR_PTR(-ENOENT);
+}
+
 /*
  * Sends a register message to the userspace daemon based on the registration.
  * The authentication information to connect to the witness service is bundled
  * into the message.
  */
-static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg,
-					  struct cifs_tcon *tcon)
+static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 {
 	struct sk_buff *skb;
 	struct genlmsghdr *hdr;
@@ -489,6 +520,7 @@ static void cifs_swn_reg_check(struct work_struct *work)
 {
 	struct cifs_swn_reg *swnreg =
 		container_of(work, struct cifs_swn_reg, check.work);
+	struct cifs_tcon *tcon;
 	int ret;
 
 	/*
@@ -507,12 +539,48 @@ static void cifs_swn_reg_check(struct work_struct *work)
 	}
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
+	tcon = cifs_swn_reg_get_tcon(swnreg);
+	if (IS_ERR(tcon)) {
+		ret = PTR_ERR(tcon);
+		cifs_dbg(FYI, "No matching tcon for registration id %d: %d\n",
+			 swnreg->id, ret);
+
+		/*
+		 * There is no point in keeping a live registration if there
+		 * are no matching tcons. Drop the reference that this fn
+		 * took at the top.
+		 */
+		mutex_lock(&cifs_swnreg_idr_mutex);
+		if (kref_put(&swnreg->ref_count, cifs_swn_reg_idr_remove)) {
+			mutex_unlock(&cifs_swnreg_idr_mutex);
+			cifs_swn_reg_release(swnreg);
+			return;
+		}
+
+		/*
+		 * Again, to drop the birth reference created via kref_init().
+		 * If there are other live references, next check run might release it.
+		 */
+		if (kref_put(&swnreg->ref_count, cifs_swn_reg_idr_remove)) {
+			mutex_unlock(&cifs_swnreg_idr_mutex);
+			cifs_swn_reg_release(swnreg);
+			return;
+		}
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+
+		/* References remain: retry later. */
+		queue_delayed_work(cifsiod_wq, &swnreg->check,
+				   swnreg->check_interval);
+		return;
+	}
+	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_swn);
+
 	/*
 	 * It is safe to send the registration message multiple times.
 	 * The userspace client library tracks if registered or not
 	 * using the swnreg->id.
 	 */
-	ret = cifs_swn_send_register_message(swnreg, swnreg->tcon);
+	ret = cifs_swn_send_register_message(swnreg);
 	if (ret < 0)
 		cifs_dbg(FYI, "%s: Failed to send register message: %d\n",
 			 __func__, ret);
@@ -618,8 +686,6 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 		(tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC);
 	swnreg->ip_notify = false;
 
-	swnreg->tcon = tcon;
-
 	swnreg->check_interval = tcon->ses->server->echo_interval;
 	INIT_DELAYED_WORK(&swnreg->check, cifs_swn_reg_check);
 
@@ -641,8 +707,8 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	return ERR_PTR(ret);
 }
 
-static int cifs_swn_resource_state_changed(struct cifs_tcon *tcon,
-					   const char *name, int state)
+static void cifs_swn_resource_state_changed(struct cifs_tcon *tcon,
+					    const char *name, int state)
 {
 	switch (state) {
 	case CIFS_SWN_RESOURCE_STATE_UNAVAILABLE:
@@ -657,7 +723,6 @@ static int cifs_swn_resource_state_changed(struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "%s: resource name '%s' changed to unknown state\n", __func__, name);
 		break;
 	}
-	return 0;
 }
 
 static int cifs_swn_store_swn_addr(const struct sockaddr_storage *new,
@@ -691,31 +756,22 @@ static int cifs_swn_store_swn_addr(const struct sockaddr_storage *new,
 	return 0;
 }
 
-static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *addr)
+static bool cifs_swn_client_move(struct cifs_tcon *tcon,
+				 struct sockaddr_storage *addr)
 {
-	int ret = 0;
+	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
+	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
+	int ret;
 
-	cifs_server_lock(tcon->ses->server);
+	if (addr->ss_family == AF_INET)
+		cifs_dbg(FYI, "%s: move to %pI4\n", __func__, &ipv4->sin_addr);
+	else if (addr->ss_family == AF_INET6)
+		cifs_dbg(FYI, "%s: move to %pI6\n", __func__, &ipv6->sin6_addr);
 
 	if (cifs_match_ipaddr((struct sockaddr *)&tcon->ses->server->dstaddr,
 			      (struct sockaddr *)addr)) {
 		/* no-op */
-		goto unlock;
-	}
-
-	/*
-	 * Unregister to stop receiving notifications for the old IP address.
-	 */
-	ret = cifs_swn_unregister(tcon);
-	if (ret < 0) {
-		cifs_dbg(VFS, "%s: Failed to unregister for witness notifications: %d\n",
-			 __func__, ret);
-		/*
-		 * Do not jump return on error, continue storing and registering for
-		 * notifications for the new address. There will be a stale registration
-		 * around running its periodic check task, which should cancel itself
-		 * if no matching any tcon.
-		 */
+		return false;
 	}
 
 	/* Store the reconnect address */
@@ -724,58 +780,103 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 	if (ret < 0) {
 		cifs_dbg(VFS, "%s: failed to store address: %d\n", __func__,
 			 ret);
-		goto unlock;
+		return false;
 	}
 	tcon->ses->server->use_swn_dstaddr = true;
 
-	/*
-	 * And register to receive notifications for the new IP address now that we have
-	 * stored the new address.
-	 */
-	ret = cifs_swn_register(tcon);
-	if (ret < 0) {
-		cifs_dbg(VFS, "%s: Failed to register for witness notifications: %d\n",
-			 __func__, ret);
-		goto unlock;
-	}
-
 	cifs_signal_cifsd_for_reconnect(tcon->ses->server, false);
 
-unlock:
-	cifs_server_unlock(tcon->ses->server);
-
-	return ret;
+	return true;
 }
 
-static int cifs_swn_client_move(struct cifs_tcon *tcon,
-				struct sockaddr_storage *addr)
+/*
+ * This function applies the notification to a matching tcon.
+ * It is called holding a spinlock. Just sets the reconnect flag and
+ * store the reconnect address if necessary.
+ */
+static bool
+cifs_swn_handle_notification_tcon(const struct cifs_swn_notification *not,
+				  struct cifs_tcon *tcon)
 {
-	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
-	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
-
-	if (addr->ss_family == AF_INET)
-		cifs_dbg(FYI, "%s: move to %pI4\n", __func__, &ipv4->sin_addr);
-	else if (addr->ss_family == AF_INET6)
-		cifs_dbg(FYI, "%s: move to %pI6\n", __func__, &ipv6->sin6_addr);
-
-	return cifs_swn_reconnect(tcon, addr);
+	switch (not->type) {
+	case CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE:
+		cifs_swn_resource_state_changed(
+			tcon, not->data.resource_name_changed.name,
+			not->data.resource_name_changed.state);
+		return false;
+	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE:
+		return cifs_swn_client_move(tcon, not->data.client_move.addr);
+	default:
+		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__,
+			 not->type);
+		break;
+	}
+	return false;
 }
 
+/*
+ * This function process a notification received for a registration. It
+ * searches all matching tcons to deliver it and then unregisters/registers
+ * as necessary if the address has changed.
+ */
 static int cifs_swn_handle_notification(const struct cifs_swn_notification *not)
 {
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
+	int ret;
+
+	/* Walk the tcons and apply the notification to matching ones */
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		if (SERVER_IS_CHAN(server))
+			continue;
+
+		cifs_server_lock(server);
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+				spin_lock(&tcon->tc_lock);
+				if (tcon->status == TID_EXITING ||
+				    !cifs_swn_reg_tcon_matches(not->swnreg,
+							       tcon)) {
+					spin_unlock(&tcon->tc_lock);
+					continue;
+				}
+				cifs_swn_handle_notification_tcon(not, tcon);
+				spin_unlock(&tcon->tc_lock);
+			}
+		}
+		cifs_server_unlock(server);
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
 	switch (not->type) {
-	case CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE:
-		return cifs_swn_resource_state_changed(
-			not->swnreg->tcon, not->data.resource_name_changed.name,
-			not->data.resource_name_changed.state);
 	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE:
-		return cifs_swn_client_move(not->swnreg->tcon,
-					    not->data.client_move.addr);
+		/* Unregister from the current address */
+		ret = cifs_swn_send_unregister_message(not->swnreg);
+		if (ret < 0) {
+			cifs_dbg(VFS,
+				 "%s: Failed to unregister for witness notifications: %d\n",
+				 __func__, ret);
+		}
+
+		/* Store the new address */
+		not->swnreg->addr = *not->data.client_move.addr;
+
+		/* Register for this new address */
+		ret = cifs_swn_send_register_message(not->swnreg);
+		if (ret < 0) {
+			cifs_dbg(VFS,
+				 "%s: Failed to register for witness notifications: %d\n",
+				 __func__, ret);
+		}
+		break;
 	default:
 		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__,
 			 not->type);
 		break;
 	}
+
 	return 0;
 }
 
@@ -889,7 +990,7 @@ int cifs_swn_register(struct cifs_tcon *tcon)
 	if (IS_ERR(swnreg))
 		return PTR_ERR(swnreg);
 
-	ret = cifs_swn_send_register_message(swnreg, tcon);
+	ret = cifs_swn_send_register_message(swnreg);
 	if (ret < 0) {
 		cifs_dbg(VFS, "%s: Failed to send swn register message: %d\n", __func__, ret);
 		/* Do not put the swnreg or return error, the check task will retry */
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index b99ec5a417fa..2b4cbffd2931 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -181,6 +181,7 @@
 	EM(netfs_trace_tcon_ref_get_find,		"GET Find  ") \
 	EM(netfs_trace_tcon_ref_get_find_sess_tcon,	"GET FndSes") \
 	EM(netfs_trace_tcon_ref_get_reconnect_server,	"GET Reconn") \
+	EM(netfs_trace_tcon_ref_get_swn,		"GET Swn   ") \
 	EM(netfs_trace_tcon_ref_new,			"NEW       ") \
 	EM(netfs_trace_tcon_ref_new_ipc,		"NEW Ipc   ") \
 	EM(netfs_trace_tcon_ref_new_reconnect_server,	"NEW Reconn") \
@@ -193,6 +194,7 @@
 	EM(netfs_trace_tcon_ref_put_dfs_refer,		"PUT DfsRfr") \
 	EM(netfs_trace_tcon_ref_put_reconnect_server,	"PUT Reconn") \
 	EM(netfs_trace_tcon_ref_put_tlink,		"PUT Tlink ") \
+	EM(netfs_trace_tcon_ref_put_swn,		"PUT Swn   ") \
 	EM(netfs_trace_tcon_ref_see_cancelled_close,	"SEE Cn-Cls") \
 	EM(netfs_trace_tcon_ref_see_fscache_collision,	"SEE FV-CO!") \
 	EM(netfs_trace_tcon_ref_see_fscache_okay,	"SEE FV-Ok ") \
-- 
2.54.0

