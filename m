Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A73DA5DA
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675027; cv=none; b=XBol/VqmNGiTqV7QQ2rJhRRkvGY/O5yTyDD5/E3JvQqBGnrpwRBAdkk1vlmkaa7Ppk+W5+aRdVFPzuBOTVIxWC7MJvFeok9g816yufTXMo+bynIs1N9HTgNuux8t8eP6czw987PuqhVMBCCqiX+llr1Nw0QAJtFIzrvFK6Z8Qdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675027; c=relaxed/simple;
	bh=D0gf9l2crkQBywODl5sovOUCb36xhoGNb2raovGFsA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Meb3+rXjilDFSnaRCwRrKPwStISG8ooPIR7VRvO+Y868PCa8e5TikLx7iRcH6Pj3oLJ4YqvryPMbgYRIQVwW+rTRMw7ZqpoGIZrCGjGN5NQlAVO5EUhJ00z0/+7Cr2HJjkk43b1D3ZeuwZueaznYUZ+6IhcqUqUfm0NlrbyZtg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 26EA5763A4;
	Fri, 10 Jul 2026 09:16:58 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 873A5779BE;
	Fri, 10 Jul 2026 09:16:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iKfaHYm4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:16:57 +0000
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
Subject: [PATCH 01/18] Revert "smb: client: resolve SWN tcon from live registrations"
Date: Fri, 10 Jul 2026 11:16:20 +0200
Message-ID: <20260710091637.58873-2-scabrero@suse.com>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 26EA5763A4
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]

This reverts commit ec457f9afe5ae9538bdcd58fd4cb442b9787e183.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 314 +++++++--------------------------------
 fs/smb/client/trace.h    |   2 -
 2 files changed, 54 insertions(+), 262 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 9951817d0d7f..9753a432d099 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -28,54 +28,10 @@ struct cifs_swn_reg {
 	bool net_name_notify;
 	bool share_name_notify;
 	bool ip_notify;
-};
 
-struct cifs_swn_reg_info {
-	int id;
-	unsigned int ref_count;
-	const char *net_name;
-	const char *share_name;
-	bool net_name_notify;
-	bool share_name_notify;
-	bool ip_notify;
+	struct cifs_tcon *tcon;
 };
 
-static void cifs_swn_snapshot_reg(struct cifs_swn_reg *swnreg,
-				  struct cifs_swn_reg_info *info)
-{
-	info->id = swnreg->id;
-	info->ref_count = kref_read(&swnreg->ref_count);
-	info->net_name = swnreg->net_name;
-	info->share_name = swnreg->share_name;
-	info->net_name_notify = swnreg->net_name_notify;
-	info->share_name_notify = swnreg->share_name_notify;
-	info->ip_notify = swnreg->ip_notify;
-}
-
-static int cifs_swn_dup_reg(struct cifs_swn_reg *swnreg,
-			    struct cifs_swn_reg_info *info)
-{
-	cifs_swn_snapshot_reg(swnreg, info);
-
-	info->net_name = kstrdup(swnreg->net_name, GFP_KERNEL);
-	if (!info->net_name)
-		return -ENOMEM;
-
-	info->share_name = kstrdup(swnreg->share_name, GFP_KERNEL);
-	if (!info->share_name) {
-		kfree(info->net_name);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void cifs_swn_free_reg_info(struct cifs_swn_reg_info *info)
-{
-	kfree(info->net_name);
-	kfree(info->share_name);
-}
-
 static int cifs_swn_auth_info_krb(struct cifs_tcon *tcon, struct sk_buff *skb)
 {
 	int ret;
@@ -117,8 +73,7 @@ static int cifs_swn_auth_info_ntlm(struct cifs_tcon *tcon, struct sk_buff *skb)
  * The authentication information to connect to the witness service is bundled
  * into the message.
  */
-static int cifs_swn_send_register_message(struct cifs_swn_reg_info *swnreg,
-					  struct cifs_tcon *tcon)
+static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 {
 	struct sk_buff *skb;
 	struct genlmsghdr *hdr;
@@ -154,10 +109,10 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg_info *swnreg,
 	 * told to switch to it (client move message). In these cases we unregister from the
 	 * server address and register to the new address when we receive the notification.
 	 */
-	if (tcon->ses->server->use_swn_dstaddr)
-		addr = &tcon->ses->server->swn_dstaddr;
+	if (swnreg->tcon->ses->server->use_swn_dstaddr)
+		addr = &swnreg->tcon->ses->server->swn_dstaddr;
 	else
-		addr = &tcon->ses->server->dstaddr;
+		addr = &swnreg->tcon->ses->server->dstaddr;
 
 	ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP, sizeof(struct sockaddr_storage), addr);
 	if (ret < 0)
@@ -181,10 +136,10 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg_info *swnreg,
 			goto nlmsg_fail;
 	}
 
-	authtype = cifs_select_sectype(tcon->ses->server, tcon->ses->sectype);
+	authtype = cifs_select_sectype(swnreg->tcon->ses->server, swnreg->tcon->ses->sectype);
 	switch (authtype) {
 	case Kerberos:
-		ret = cifs_swn_auth_info_krb(tcon, skb);
+		ret = cifs_swn_auth_info_krb(swnreg->tcon, skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get kerberos auth info: %d\n", __func__, ret);
 			goto nlmsg_fail;
@@ -192,7 +147,7 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg_info *swnreg,
 		break;
 	case NTLMv2:
 	case RawNTLMSSP:
-		ret = cifs_swn_auth_info_ntlm(tcon, skb);
+		ret = cifs_swn_auth_info_ntlm(swnreg->tcon, skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get NTLM auth info: %d\n", __func__, ret);
 			goto nlmsg_fail;
@@ -221,8 +176,7 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg_info *swnreg,
 /*
  * Sends an uregister message to the userspace daemon based on the registration
  */
-static int cifs_swn_send_unregister_message(struct cifs_swn_reg_info *swnreg,
-					    struct cifs_tcon *tcon)
+static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
 {
 	struct sk_buff *skb;
 	struct genlmsghdr *hdr;
@@ -251,7 +205,7 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg_info *swnreg,
 		goto nlmsg_fail;
 
 	ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP, sizeof(struct sockaddr_storage),
-			&tcon->ses->server->dstaddr);
+			&swnreg->tcon->ses->server->dstaddr);
 	if (ret < 0)
 		goto nlmsg_fail;
 
@@ -287,88 +241,6 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg_info *swnreg,
 	return ret;
 }
 
-/*
- * Allocation-free mirror of extract_hostname() + extract_sharename() from
- * fs/smb/client/unc.c.  Those helpers kmalloc(GFP_KERNEL); this runs under
- * cifs_tcp_ses_lock and tcon->tc_lock, both spinlocks, so we mirror their
- * parsing in place against the caller's stable net_name/share_name strings.
- * Keep in sync with unc.c.
- */
-static bool cifs_swn_tcon_matches(struct cifs_tcon *tcon,
-				  const char *net_name,
-				  const char *share_name)
-{
-	const char *unc = tcon->tree_name;
-	const char *host, *share, *delim;
-	size_t host_len, share_len;
-
-	if (!tcon->use_witness)
-		return false;
-
-	/* extract_hostname: require strlen(unc) >= 3 */
-	if (strnlen(unc, 3) < 3)
-		return false;
-	/* extract_hostname: skip all leading '\' characters */
-	for (host = unc; *host == '\\'; host++)
-		;
-	if (!*host)
-		return false;
-	delim = strchr(host, '\\');
-	if (!delim)
-		return false;
-	host_len = delim - host;
-	if (strlen(net_name) != host_len ||
-	    strncasecmp(host, net_name, host_len))
-		return false;
-
-	/* extract_sharename: start at unc + 2, then first '\' onward */
-	share = unc + 2;
-	delim = strchr(share, '\\');
-	if (!delim)
-		return false;
-	share = delim + 1;
-	share_len = strlen(share);
-
-	return strlen(share_name) == share_len &&
-	       !strncasecmp(share, share_name, share_len);
-}
-
-/*
- * One SWN registration id represents one net/share name pair.  Multiple
- * mounted tcons can therefore share the id.  Pick a live representative at
- * use time instead of caching the first tcon pointer in the registration.
- */
-static struct cifs_tcon *cifs_swn_get_tcon(struct cifs_swn_reg_info *swnreg)
-{
-	struct TCP_Server_Info *server;
-	struct cifs_ses *ses;
-	struct cifs_tcon *tcon;
-
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
-				spin_lock(&tcon->tc_lock);
-				if (tcon->status == TID_EXITING ||
-				    !cifs_swn_tcon_matches(tcon, swnreg->net_name,
-							   swnreg->share_name)) {
-					spin_unlock(&tcon->tc_lock);
-					continue;
-				}
-				++tcon->tc_count;
-				trace_smb3_tcon_ref(tcon->debug_id,
-						    tcon->tc_count,
-						    netfs_trace_tcon_ref_get_swn_notify);
-				spin_unlock(&tcon->tc_lock);
-				spin_unlock(&cifs_tcp_ses_lock);
-				return tcon;
-			}
-		}
-	}
-	spin_unlock(&cifs_tcp_ses_lock);
-	return NULL;
-}
-
 /*
  * Try to find a matching registration for the tcon's server name and share name.
  * Calls to this function must be protected by cifs_swnreg_idr_mutex.
@@ -475,6 +347,8 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	reg->net_name_notify = true;
 	reg->share_name_notify = true;
 	reg->ip_notify = (tcon->capabilities & SMB2_SHARE_CAP_SCALEOUT);
+
+	reg->tcon = tcon;
 unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
@@ -494,6 +368,11 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 static void cifs_swn_reg_release(struct kref *ref)
 {
 	struct cifs_swn_reg *swnreg = container_of(ref, struct cifs_swn_reg, ref_count);
+	int ret;
+
+	ret = cifs_swn_send_unregister_message(swnreg);
+	if (ret < 0)
+		cifs_dbg(VFS, "%s: Failed to send unregister message: %d\n", __func__, ret);
 
 	idr_remove(&cifs_swnreg_idr, swnreg->id);
 	kfree(swnreg->net_name);
@@ -501,33 +380,23 @@ static void cifs_swn_reg_release(struct kref *ref)
 	kfree(swnreg);
 }
 
-static void cifs_put_swn_reg_locked(struct cifs_swn_reg *swnreg,
-				    struct cifs_tcon *tcon)
+static void cifs_put_swn_reg(struct cifs_swn_reg *swnreg)
 {
-	if (kref_read(&swnreg->ref_count) == 1) {
-		struct cifs_swn_reg_info swnreg_info;
-		int ret;
-
-		cifs_swn_snapshot_reg(swnreg, &swnreg_info);
-		ret = cifs_swn_send_unregister_message(&swnreg_info, tcon);
-		if (ret < 0)
-			cifs_dbg(VFS, "%s: Failed to send unregister message: %d\n",
-				 __func__, ret);
-	}
-
+	mutex_lock(&cifs_swnreg_idr_mutex);
 	kref_put(&swnreg->ref_count, cifs_swn_reg_release);
+	mutex_unlock(&cifs_swnreg_idr_mutex);
 }
 
-static int cifs_swn_resource_state_changed(struct cifs_tcon *tcon, const char *name, int state)
+static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const char *name, int state)
 {
 	switch (state) {
 	case CIFS_SWN_RESOURCE_STATE_UNAVAILABLE:
 		cifs_dbg(FYI, "%s: resource name '%s' become unavailable\n", __func__, name);
-		cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(swnreg->tcon->ses->server, true);
 		break;
 	case CIFS_SWN_RESOURCE_STATE_AVAILABLE:
 		cifs_dbg(FYI, "%s: resource name '%s' become available\n", __func__, name);
-		cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(swnreg->tcon->ses->server, true);
 		break;
 	case CIFS_SWN_RESOURCE_STATE_UNKNOWN:
 		cifs_dbg(FYI, "%s: resource name '%s' changed to unknown state\n", __func__, name);
@@ -633,7 +502,7 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 	return ret;
 }
 
-static int cifs_swn_client_move(struct cifs_tcon *tcon, struct sockaddr_storage *addr)
+static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_storage *addr)
 {
 	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
@@ -643,17 +512,14 @@ static int cifs_swn_client_move(struct cifs_tcon *tcon, struct sockaddr_storage
 	else if (addr->ss_family == AF_INET6)
 		cifs_dbg(FYI, "%s: move to %pI6\n", __func__, &ipv6->sin6_addr);
 
-	return cifs_swn_reconnect(tcon, addr);
+	return cifs_swn_reconnect(swnreg->tcon, addr);
 }
 
 int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cifs_swn_reg *swnreg;
-	struct cifs_swn_reg_info swnreg_info;
-	struct cifs_tcon *tcon;
 	char name[256];
 	int type;
-	int ret = 0;
 
 	if (info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]) {
 		int swnreg_id;
@@ -661,34 +527,21 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 		swnreg_id = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]);
 		mutex_lock(&cifs_swnreg_idr_mutex);
 		swnreg = idr_find(&cifs_swnreg_idr, swnreg_id);
+		mutex_unlock(&cifs_swnreg_idr_mutex);
 		if (swnreg == NULL) {
-			mutex_unlock(&cifs_swnreg_idr_mutex);
 			cifs_dbg(FYI, "%s: registration id %d not found\n", __func__, swnreg_id);
 			return -EINVAL;
 		}
-		ret = cifs_swn_dup_reg(swnreg, &swnreg_info);
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		if (ret)
-			return ret;
 	} else {
 		cifs_dbg(FYI, "%s: missing registration id attribute\n", __func__);
 		return -EINVAL;
 	}
 
-	tcon = cifs_swn_get_tcon(&swnreg_info);
-	if (!tcon) {
-		cifs_dbg(FYI, "%s: registration id %d has no live tcon\n",
-			 __func__, swnreg_info.id);
-		ret = -ENODEV;
-		goto free_info;
-	}
-
 	if (info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]) {
 		type = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]);
 	} else {
 		cifs_dbg(FYI, "%s: missing notification type attribute\n", __func__);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	switch (type) {
@@ -700,18 +553,15 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 					sizeof(name));
 		} else {
 			cifs_dbg(FYI, "%s: missing resource name attribute\n", __func__);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 		if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]) {
 			state = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]);
 		} else {
 			cifs_dbg(FYI, "%s: missing resource state attribute\n", __func__);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
-		ret = cifs_swn_resource_state_changed(tcon, name, state);
-		break;
+		return cifs_swn_resource_state_changed(swnreg, name, state);
 	}
 	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE: {
 		struct sockaddr_storage addr;
@@ -720,36 +570,28 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 			nla_memcpy(&addr, info->attrs[CIFS_GENL_ATTR_SWN_IP], sizeof(addr));
 		} else {
 			cifs_dbg(FYI, "%s: missing IP address attribute\n", __func__);
-			ret = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
-		ret = cifs_swn_client_move(tcon, &addr);
-		break;
+		return cifs_swn_client_move(swnreg, &addr);
 	}
 	default:
 		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__, type);
 		break;
 	}
 
-out:
-	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_swn_notify);
-free_info:
-	cifs_swn_free_reg_info(&swnreg_info);
-	return ret;
+	return 0;
 }
 
 int cifs_swn_register(struct cifs_tcon *tcon)
 {
 	struct cifs_swn_reg *swnreg;
-	struct cifs_swn_reg_info swnreg_info;
 	int ret;
 
 	swnreg = cifs_get_swn_reg(tcon);
 	if (IS_ERR(swnreg))
 		return PTR_ERR(swnreg);
 
-	cifs_swn_snapshot_reg(swnreg, &swnreg_info);
-	ret = cifs_swn_send_register_message(&swnreg_info, tcon);
+	ret = cifs_swn_send_register_message(swnreg);
 	if (ret < 0) {
 		cifs_dbg(VFS, "%s: Failed to send swn register message: %d\n", __func__, ret);
 		/* Do not put the swnreg or return error, the echo task will retry */
@@ -770,68 +612,35 @@ int cifs_swn_unregister(struct cifs_tcon *tcon)
 		return PTR_ERR(swnreg);
 	}
 
-	cifs_put_swn_reg_locked(swnreg, tcon);
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
-	return 0;
-}
-
-/*
- * Snapshot one registration under cifs_swnreg_idr_mutex and return.  Callers
- * intentionally do the per-registration network/genlmsg work without the
- * mutex held, both to keep the critical section short and to avoid nesting
- * cifs_swnreg_idr_mutex inside the higher tc_lock when a live tcon is then
- * pinned for the send.
- */
-static int cifs_swn_get_next_reg_info(int *id, struct cifs_swn_reg_info *info)
-{
-	struct cifs_swn_reg *swnreg;
-	int ret = 0;
-
-	mutex_lock(&cifs_swnreg_idr_mutex);
-	swnreg = idr_get_next(&cifs_swnreg_idr, id);
-	if (swnreg) {
-		ret = cifs_swn_dup_reg(swnreg, info);
-		if (!ret) {
-			*id = swnreg->id + 1;
-			ret = 1;
-		}
-	}
-	mutex_unlock(&cifs_swnreg_idr_mutex);
+	cifs_put_swn_reg(swnreg);
 
-	return ret;
+	return 0;
 }
 
 void cifs_swn_dump(struct seq_file *m)
 {
-	struct cifs_swn_reg_info swnreg_info;
-	struct cifs_tcon *tcon;
+	struct cifs_swn_reg *swnreg;
 	struct sockaddr_in *sa;
 	struct sockaddr_in6 *sa6;
-	int id = 0;
-	int ret;
+	int id;
 
 	seq_puts(m, "Witness registrations:");
 
-	while ((ret = cifs_swn_get_next_reg_info(&id, &swnreg_info)) > 0) {
+	mutex_lock(&cifs_swnreg_idr_mutex);
+	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
 		seq_printf(m, "\nId: %u Refs: %u Network name: '%s'%s Share name: '%s'%s Ip address: ",
-			   swnreg_info.id, swnreg_info.ref_count,
-			   swnreg_info.net_name, swnreg_info.net_name_notify ? "(y)" : "(n)",
-			   swnreg_info.share_name, swnreg_info.share_name_notify ? "(y)" : "(n)");
-
-		tcon = cifs_swn_get_tcon(&swnreg_info);
-		if (!tcon) {
-			seq_puts(m, "(no live tcon)");
-			goto next;
-		}
-
-		switch (tcon->ses->server->dstaddr.ss_family) {
+				id, kref_read(&swnreg->ref_count),
+				swnreg->net_name, swnreg->net_name_notify ? "(y)" : "(n)",
+				swnreg->share_name, swnreg->share_name_notify ? "(y)" : "(n)");
+		switch (swnreg->tcon->ses->server->dstaddr.ss_family) {
 		case AF_INET:
-			sa = (struct sockaddr_in *)&tcon->ses->server->dstaddr;
+			sa = (struct sockaddr_in *) &swnreg->tcon->ses->server->dstaddr;
 			seq_printf(m, "%pI4", &sa->sin_addr.s_addr);
 			break;
 		case AF_INET6:
-			sa6 = (struct sockaddr_in6 *)&tcon->ses->server->dstaddr;
+			sa6 = (struct sockaddr_in6 *) &swnreg->tcon->ses->server->dstaddr;
 			seq_printf(m, "%pI6", &sa6->sin6_addr.s6_addr);
 			if (sa6->sin6_scope_id)
 				seq_printf(m, "%%%u", sa6->sin6_scope_id);
@@ -839,38 +648,23 @@ void cifs_swn_dump(struct seq_file *m)
 		default:
 			seq_puts(m, "(unknown)");
 		}
-		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_swn_notify);
-next:
-		seq_printf(m, "%s", swnreg_info.ip_notify ? "(y)" : "(n)");
-		cifs_swn_free_reg_info(&swnreg_info);
+		seq_printf(m, "%s", swnreg->ip_notify ? "(y)" : "(n)");
 	}
-	if (ret < 0)
-		seq_printf(m, "\nFailed to snapshot witness registration: %d", ret);
+	mutex_unlock(&cifs_swnreg_idr_mutex);
 	seq_puts(m, "\n");
 }
 
 void cifs_swn_check(void)
 {
-	struct cifs_swn_reg_info swnreg_info;
-	struct cifs_tcon *tcon;
-	int id = 0;
+	struct cifs_swn_reg *swnreg;
+	int id;
 	int ret;
 
-	while ((ret = cifs_swn_get_next_reg_info(&id, &swnreg_info)) > 0) {
-		tcon = cifs_swn_get_tcon(&swnreg_info);
-		if (!tcon) {
-			cifs_dbg(FYI, "%s: registration id %d has no live tcon\n",
-				 __func__, swnreg_info.id);
-			goto free_info;
-		}
-
-		ret = cifs_swn_send_register_message(&swnreg_info, tcon);
+	mutex_lock(&cifs_swnreg_idr_mutex);
+	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
+		ret = cifs_swn_send_register_message(swnreg);
 		if (ret < 0)
 			cifs_dbg(FYI, "%s: Failed to send register message: %d\n", __func__, ret);
-		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_swn_notify);
-free_info:
-		cifs_swn_free_reg_info(&swnreg_info);
 	}
-	if (ret < 0)
-		cifs_dbg(FYI, "%s: Failed to snapshot registration: %d\n", __func__, ret);
+	mutex_unlock(&cifs_swnreg_idr_mutex);
 }
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 5b21ad3c15fb..b99ec5a417fa 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -181,7 +181,6 @@
 	EM(netfs_trace_tcon_ref_get_find,		"GET Find  ") \
 	EM(netfs_trace_tcon_ref_get_find_sess_tcon,	"GET FndSes") \
 	EM(netfs_trace_tcon_ref_get_reconnect_server,	"GET Reconn") \
-	EM(netfs_trace_tcon_ref_get_swn_notify,		"GET SwnNot") \
 	EM(netfs_trace_tcon_ref_new,			"NEW       ") \
 	EM(netfs_trace_tcon_ref_new_ipc,		"NEW Ipc   ") \
 	EM(netfs_trace_tcon_ref_new_reconnect_server,	"NEW Reconn") \
@@ -193,7 +192,6 @@
 	EM(netfs_trace_tcon_ref_put_mnt_ctx,		"PUT MntCtx") \
 	EM(netfs_trace_tcon_ref_put_dfs_refer,		"PUT DfsRfr") \
 	EM(netfs_trace_tcon_ref_put_reconnect_server,	"PUT Reconn") \
-	EM(netfs_trace_tcon_ref_put_swn_notify,		"PUT SwnNot") \
 	EM(netfs_trace_tcon_ref_put_tlink,		"PUT Tlink ") \
 	EM(netfs_trace_tcon_ref_see_cancelled_close,	"SEE Cn-Cls") \
 	EM(netfs_trace_tcon_ref_see_fscache_collision,	"SEE FV-CO!") \
-- 
2.54.0

