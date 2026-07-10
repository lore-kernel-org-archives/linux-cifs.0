Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304A43D5252
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675088; cv=none; b=uCjy6fZD+u0JjV+G8q5bq3FIEaauTJf7CpLT8wb+rdNqlrz1BgqUf7538BhBDfYY5/+hYGHA+mxtJICYqJbkK4sUX23U6KbKjXegW7PTnWdrkyQDi775BeoUhwJB12YIs5jcb8l0yfxzmfjo7rADEX6hpdGg3YhlTGHDBPsg39Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675088; c=relaxed/simple;
	bh=6+pZYHsHs/QfWLFuIekhz0357b7BoYrAbQKVEehbojM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMpSVhTkNGR3ykIQwL4ZT4Rp1u/5ln4lOQQ40FOdFNMmv5Z7gcjpDRZzMF3sF28P5eDqESQNXKl/A3tZVW4Xm3+DPKbLh6+MurrfCDl/HvLbAwR1hLeh0FOi8w5HoQMBuNyMMn8XReKxNf2BKhUKlff93pz0IN4QgQnzFKYepy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4460A76404;
	Fri, 10 Jul 2026 09:17:09 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2844779BD;
	Fri, 10 Jul 2026 09:17:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sL3HJJS4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:08 +0000
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
Subject: [PATCH 17/18] smb:client: Improve registration network and share names handling
Date: Fri, 10 Jul 2026 11:16:36 +0200
Message-ID: <20260710091637.58873-18-scabrero@suse.com>
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
X-Rspamd-Queue-Id: 4460A76404
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

Store the names and add them to the netlink messages only if required.

The network name notification is always enabled. The share name
notification is only enabled for asymmetric shares.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 111 +++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 50 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 3375a65ec32e..a196b06c4b8c 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -212,7 +212,7 @@ static bool cifs_swn_reg_net_name_matches(const struct cifs_swn_reg *swnreg,
 		return false;
 
 	host_len = delim - host;
-	if (strlen(swnreg->net_name) == host_len &&
+	if (swnreg->net_name != NULL && strlen(swnreg->net_name) == host_len &&
 	    !strncasecmp(swnreg->net_name, host, host_len)) {
 		return true;
 	}
@@ -269,7 +269,7 @@ static bool cifs_swn_reg_tcon_matches(const struct cifs_swn_reg *swnreg,
 		return false;
 
 	/* The network name notification is always enabled */
-	if (!cifs_swn_reg_net_name_matches(swnreg, tcon))
+	if (swnreg->net_name_notify && !cifs_swn_reg_net_name_matches(swnreg, tcon))
 		return false;
 
 	/*
@@ -346,26 +346,28 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 	if (ret < 0)
 		goto nlmsg_fail;
 
-	ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_NET_NAME, swnreg->net_name);
-	if (ret < 0)
-		goto nlmsg_fail;
-
-	ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME, swnreg->share_name);
-	if (ret < 0)
-		goto nlmsg_fail;
-
 	ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP,
 		      sizeof(struct sockaddr_storage), &swnreg->addr);
 	if (ret < 0)
 		goto nlmsg_fail;
 
 	if (swnreg->net_name_notify) {
+		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_NET_NAME,
+				     swnreg->net_name);
+		if (ret < 0)
+			goto nlmsg_fail;
+
 		ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_NET_NAME_NOTIFY);
 		if (ret < 0)
 			goto nlmsg_fail;
 	}
 
 	if (swnreg->share_name_notify) {
+		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME,
+				     swnreg->share_name);
+		if (ret < 0)
+			goto nlmsg_fail;
+
 		ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME_NOTIFY);
 		if (ret < 0)
 			goto nlmsg_fail;
@@ -403,8 +405,8 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 	genlmsg_end(skb, hdr);
 	genlmsg_multicast(&cifs_genl_family, skb, 0, CIFS_GENL_MCGRP_SWN, GFP_ATOMIC);
 
-	cifs_dbg(FYI, "%s: Message to register for network name %s with id %d sent\n", __func__,
-			swnreg->net_name, swnreg->id);
+	cifs_dbg(FYI, "%s: Message to register for network name '%s' with id %d sent\n", __func__,
+			swnreg->net_name ? swnreg->net_name : "", swnreg->id);
 
 	return 0;
 
@@ -439,26 +441,28 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
 	if (ret < 0)
 		goto nlmsg_fail;
 
-	ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_NET_NAME, swnreg->net_name);
-	if (ret < 0)
-		goto nlmsg_fail;
-
-	ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME, swnreg->share_name);
-	if (ret < 0)
-		goto nlmsg_fail;
-
 	ret = nla_put(skb, CIFS_GENL_ATTR_SWN_IP,
 		      sizeof(struct sockaddr_storage), &swnreg->addr);
 	if (ret < 0)
 		goto nlmsg_fail;
 
 	if (swnreg->net_name_notify) {
+		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_NET_NAME,
+				     swnreg->net_name);
+		if (ret < 0)
+			goto nlmsg_fail;
+
 		ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_NET_NAME_NOTIFY);
 		if (ret < 0)
 			goto nlmsg_fail;
 	}
 
 	if (swnreg->share_name_notify) {
+		ret = nla_put_string(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME,
+				     swnreg->share_name);
+		if (ret < 0)
+			goto nlmsg_fail;
+
 		ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_SHARE_NAME_NOTIFY);
 		if (ret < 0)
 			goto nlmsg_fail;
@@ -473,8 +477,8 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
 	genlmsg_end(skb, hdr);
 	genlmsg_multicast(&cifs_genl_family, skb, 0, CIFS_GENL_MCGRP_SWN, GFP_ATOMIC);
 
-	cifs_dbg(FYI, "%s: Message to unregister for network name %s with id %d sent\n", __func__,
-			swnreg->net_name, swnreg->id);
+	cifs_dbg(FYI, "%s: Message to unregister for network name '%s' with id %d sent\n", __func__,
+			swnreg->net_name ? swnreg->net_name : "", swnreg->id);
 
 	return 0;
 
@@ -938,29 +942,40 @@ int cifs_swn_register(struct cifs_tcon *tcon)
 		return ret;
 	}
 
-	swnreg->net_name = extract_hostname(tcon->tree_name);
-	if (IS_ERR(swnreg->net_name)) {
-		ret = PTR_ERR(swnreg->net_name);
-		cifs_dbg(VFS,
-			 "%s: failed to extract host name from target: %d\n",
-			 __func__, ret);
-		idr_remove(&cifs_swnreg_idr, swnreg->id);
-		kfree(swnreg);
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return ret;
+	swnreg->net_name_notify = true;
+	swnreg->share_name_notify =
+		(tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC);
+	swnreg->ip_notify = false;
+
+	if (swnreg->net_name_notify) {
+		swnreg->net_name = extract_hostname(tcon->tree_name);
+		if (IS_ERR(swnreg->net_name)) {
+			ret = PTR_ERR(swnreg->net_name);
+			cifs_dbg(
+				VFS,
+				"%s: failed to extract host name from target: %d\n",
+				__func__, ret);
+			idr_remove(&cifs_swnreg_idr, swnreg->id);
+			kfree(swnreg);
+			mutex_unlock(&cifs_swnreg_idr_mutex);
+			return ret;
+		}
 	}
 
-	swnreg->share_name = extract_sharename(tcon->tree_name);
-	if (IS_ERR(swnreg->share_name)) {
-		ret = PTR_ERR(swnreg->share_name);
-		cifs_dbg(VFS,
-			 "%s: failed to extract share name from target: %d\n",
-			 __func__, ret);
-		kfree(swnreg->net_name);
-		idr_remove(&cifs_swnreg_idr, swnreg->id);
-		kfree(swnreg);
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return ret;
+	if (swnreg->share_name_notify) {
+		swnreg->share_name = extract_sharename(tcon->tree_name);
+		if (IS_ERR(swnreg->share_name)) {
+			ret = PTR_ERR(swnreg->share_name);
+			cifs_dbg(
+				VFS,
+				"%s: failed to extract share name from target: %d\n",
+				__func__, ret);
+			kfree(swnreg->net_name);
+			idr_remove(&cifs_swnreg_idr, swnreg->id);
+			kfree(swnreg);
+			mutex_unlock(&cifs_swnreg_idr_mutex);
+			return ret;
+		}
 	}
 
 	ret = cifs_swn_reg_set_auth(swnreg, tcon);
@@ -986,11 +1001,6 @@ int cifs_swn_register(struct cifs_tcon *tcon)
 	else
 		swnreg->addr = tcon->ses->server->dstaddr;
 
-	swnreg->net_name_notify = true;
-	swnreg->share_name_notify =
-		(tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC);
-	swnreg->ip_notify = false;
-
 	swnreg->check_interval = tcon->ses->server->echo_interval;
 	INIT_DELAYED_WORK(&swnreg->check, cifs_swn_reg_check);
 
@@ -1036,9 +1046,10 @@ void cifs_swn_dump(struct seq_file *m)
 		seq_printf(
 			m,
 			"\nId: %d Refs: %u Network name: '%s'%s Share name: '%s'%s Ip address: '%pISc'%s",
-			id, kref_read(&swnreg->ref_count), swnreg->net_name,
+			id, kref_read(&swnreg->ref_count),
+			swnreg->net_name ? swnreg->net_name : "",
 			swnreg->net_name_notify ? "(y)" : "(n)",
-			swnreg->share_name,
+			swnreg->share_name ? swnreg->share_name : "",
 			swnreg->share_name_notify ? "(y)" : "(n)",
 			&swnreg->addr, swnreg->ip_notify ? "(y)" : "(n)");
 	}
-- 
2.54.0

