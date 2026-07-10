Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA3B3DB325
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675063; cv=none; b=fBReq7u6mfgzm9br0W5FmGNrtd0zOqAANzdPhJcBMcL1n0bI+eJx8iCSZ3i0j+LAGyy48j7PKk8Uvo/ClxQ07DyFnwzk3PsncpWVms+NTFVFAah88fFpeV0GqbrL89VAj9iUVuKb3vMPTcJargm9dtLzdI8cdre3Jsg7gy1QVuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675063; c=relaxed/simple;
	bh=5KCdoJPeEvvIizEMOrwDNYxH0hBSBGfD87iLhSlu4JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvnwKK7qliDXj/MrvbQfIDKB8W7lRw1lJL3esWXyZwRIxyQyhqyIPC8aD+AXHqvCnf066yIb7gfridXD3leSBqlqbgxpHF0rW+QgLNFcqZzgXgIMDZPpwW31OvlVALl9E0UDMc3tWSe6PZuRTvZCD1n/9qwjitjojXeB/ipH6gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 60CDC76400;
	Fri, 10 Jul 2026 09:17:04 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF2B5779BD;
	Fri, 10 Jul 2026 09:17:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CE7JK4+4UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:03 +0000
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
Subject: [PATCH 10/18] smb:client: Improve tcon matching logic
Date: Fri, 10 Jul 2026 11:16:29 +0200
Message-ID: <20260710091637.58873-11-scabrero@suse.com>
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
X-Rspamd-Queue-Id: 60CDC76400
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

Split the network name and share name checking into their own functions,
and check if these names match only if its associated flag is enabled.
The registration address is always compared.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 117 ++++++++++++++++++++++++---------------
 1 file changed, 72 insertions(+), 45 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 0d7e99203281..5728647a1e5d 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -72,13 +72,67 @@ static int cifs_swn_auth_info_ntlm(struct cifs_tcon *tcon, struct sk_buff *skb)
 	return 0;
 }
 
+static bool cifs_swn_reg_net_name_matches(const struct cifs_swn_reg *swnreg,
+					  const struct cifs_tcon *tcon)
+{
+	const char *unc = tcon->tree_name;
+	const char *host, *delim;
+	size_t host_len;
+
+	/* extract hostname, requires strlen(unc) >= 3 (\\a)*/
+	if (strnlen(unc, 3) < 3)
+		return false;
+
+	/* extract_hostname: skip all leading '\' characters */
+	for (host = unc; *host && *host == '\\'; host++)
+		;
+
+	if (!*host)
+		return false;
+
+	delim = strchr(host, '\\');
+	if (!delim)
+		return false;
+
+	host_len = delim - host;
+	if (strlen(swnreg->net_name) == host_len &&
+	    !strncasecmp(swnreg->net_name, host, host_len)) {
+		return true;
+	}
+	return false;
+}
+
+static bool cifs_swn_reg_share_name_matches(const struct cifs_swn_reg *swnreg,
+					    const struct cifs_tcon *tcon)
+{
+	const char *unc = tcon->tree_name;
+	const char *share, *delim;
+	size_t share_len;
+
+	/* extract share name, requires strlen(unc) >= 5 (\\a\b) */
+	if (strnlen(unc, 5) < 5)
+		return false;
+
+	/* extract share name, start at unc + 2, then first '\' onward */
+	share = unc + 2;
+	delim = strchr(share, '\\');
+	if (!delim)
+		return false;
+
+	share = delim + 1;
+	share_len = strlen(share);
+
+	if (strlen(swnreg->share_name) == share_len &&
+	    !strncasecmp(swnreg->share_name, share, share_len)) {
+		return true;
+	}
+	return false;
+}
+
 static bool cifs_swn_reg_tcon_matches(const struct cifs_swn_reg *swnreg,
 				      const struct cifs_tcon *tcon)
 {
-	const char *unc = tcon->tree_name;
 	struct sockaddr_storage *tcon_dstaddr;
-	const char *host, *share, *delim;
-	size_t host_len, share_len;
 
 	if (!tcon->use_witness)
 		return false;
@@ -88,54 +142,27 @@ static bool cifs_swn_reg_tcon_matches(const struct cifs_swn_reg *swnreg,
 	else
 		tcon_dstaddr = &tcon->ses->server->dstaddr;
 
+	/* Address must always match */
 	if (!cifs_match_ipaddr((struct sockaddr *)&swnreg->addr,
 			       (struct sockaddr *)tcon_dstaddr))
 		return false;
 
-	if (swnreg->net_name_notify) {
-		/* extract hostname, requires strlen(unc) >= 3 (\\a)*/
-		if (strnlen(unc, 3) < 3)
-			return false;
-
-		/* extract_hostname: skip all leading '\' characters */
-		for (host = unc; *host && *host == '\\'; host++)
-			;
-
-		if (!*host)
-			return false;
-
-		delim = strchr(host, '\\');
-		if (!delim)
-			return false;
-
-		host_len = delim - host;
-		if (strlen(swnreg->net_name) == host_len &&
-		    !strncasecmp(swnreg->net_name, host, host_len)) {
-			return true;
-		}
-	}
+	/* The network name notification is always enabled */
+	if (!cifs_swn_reg_net_name_matches(swnreg, tcon))
+		return false;
 
-	if (swnreg->share_name_notify) {
-		/* extract share name, requires strlen(unc) >= 5 (\\a\b) */
-		if (strnlen(unc, 5) < 5)
-			return false;
-
-		/* extract share name, start at unc + 2, then first '\' onward */
-		share = unc + 2;
-		delim = strchr(share, '\\');
-		if (!delim)
-			return false;
-
-		share = delim + 1;
-		share_len = strlen(share);
-
-		if (strlen(swnreg->share_name) == share_len &&
-		    !strncasecmp(swnreg->share_name, share, share_len)) {
-			return true;
-		}
-	}
+	/*
+	 * Share name notifications is enabled only if asymmetric
+	 * capability enabled otherwise ignored
+	 */
+	if (swnreg->share_name_notify !=
+	    (tcon->capabilities & SMB2_SHARE_CAP_ASYMMETRIC))
+		return false;
+	else if (swnreg->share_name_notify &&
+		 !cifs_swn_reg_share_name_matches(swnreg, tcon))
+		return false;
 
-	return false;
+	return true;
 }
 
 /*
-- 
2.54.0

