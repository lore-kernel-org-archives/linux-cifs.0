Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE94D3DB330
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675057; cv=none; b=NY7odjz89VANTd3Qo9AdFT5gs7BSsnaNC+z5afnkHYpt4ofrk7Q1mHUL/kRwmOSLQhpDbyupYCorsrbJ7ZlT0IOXBuJ+j0alwRv/qf8s+k8EJaJGKwI5XnoNiWIt3tHopf3zmPMRtsF5fVS2KZ9j4InwB05PRnk5TwSbknTYCAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675057; c=relaxed/simple;
	bh=YuIfDO9xUIbiz9S86/Golc4Wy2AuEfmxJRZqx/R9EFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW/hJODeoKK8IRd8RhabigWMI5KUvLMRyIXtMfpgHJxU05RCTyIg3G7D26PhU0o+6vvekFs9JfIv3Bc3TsehNRR9YJYmWIng2Q7ssb09kU+Pia9I2qFQKqFhDuGN6uN/mfoSmP5nHBnyvHgGVy0uKjf2p6aOvLEdafL3U4JzFrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Fq+uiQpV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Fq+uiQpV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Fq+uiQpV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Fq+uiQpV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0335A763FC;
	Fri, 10 Jul 2026 09:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BUQEnwvvdjPPMDgn427ws0Zaj0nEMIsUN56c3KhVPL4=;
	b=Fq+uiQpVoiBWasgiV9KQrz8XlrpYyjH5HoFBeONgvy/x28iZTkWialrBAEXWZiXs24uX4L
	ftK6asix/HA3LdqkWUFKQyqJnlJM6WRKQ5vbWY/1IN4XyT4G16l/CknmXrRcsAfQ0tjqOY
	WvYiooO+YMVwvVKI7SMA0E9HY8RmwKE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783675023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BUQEnwvvdjPPMDgn427ws0Zaj0nEMIsUN56c3KhVPL4=;
	b=Fq+uiQpVoiBWasgiV9KQrz8XlrpYyjH5HoFBeONgvy/x28iZTkWialrBAEXWZiXs24uX4L
	ftK6asix/HA3LdqkWUFKQyqJnlJM6WRKQ5vbWY/1IN4XyT4G16l/CknmXrRcsAfQ0tjqOY
	WvYiooO+YMVwvVKI7SMA0E9HY8RmwKE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 602D0779BD;
	Fri, 10 Jul 2026 09:17:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2C6eFI64UGqnEQAAD6G6ig
	(envelope-from <scabrero@suse.com>); Fri, 10 Jul 2026 09:17:02 +0000
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
Subject: [PATCH 08/18] smb:client: Save memory allocations
Date: Fri, 10 Jul 2026 11:16:27 +0200
Message-ID: <20260710091637.58873-9-scabrero@suse.com>
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
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com,suse.de];
	R_RATELIMIT(0.00)[to_ip_from(RLsmepzun9ugcn3tumbc3b9wxd)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Level: 
X-Spam-Score: -6.80

Avoid memory allocations, parse the unc string directly and use
string lengths when comparing parts of it.

Signed-off-by: Samuel Cabrero <scabrero@suse.com>
---
 fs/smb/client/cifs_swn.c | 117 +++++++++++++++++++++++----------------
 1 file changed, 68 insertions(+), 49 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 877272788399..b823a496cba7 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -72,6 +72,72 @@ static int cifs_swn_auth_info_ntlm(struct cifs_tcon *tcon, struct sk_buff *skb)
 	return 0;
 }
 
+static bool cifs_swn_reg_tcon_matches(const struct cifs_swn_reg *swnreg,
+				      const struct cifs_tcon *tcon)
+{
+	const char *unc = tcon->tree_name;
+	struct sockaddr_storage *tcon_dstaddr;
+	const char *host, *share, *delim;
+	size_t host_len, share_len;
+
+	if (!tcon->use_witness)
+		return false;
+
+	if (tcon->ses->server->use_swn_dstaddr)
+		tcon_dstaddr = &tcon->ses->server->swn_dstaddr;
+	else
+		tcon_dstaddr = &tcon->ses->server->dstaddr;
+
+	if (!cifs_match_ipaddr((struct sockaddr *)&swnreg->addr,
+			       (struct sockaddr *)tcon_dstaddr))
+		return false;
+
+	if (swnreg->net_name_notify) {
+		/* extract hostname, requires strlen(unc) >= 3 (\\a)*/
+		if (strnlen(unc, 3) < 3)
+			return false;
+
+		/* extract_hostname: skip all leading '\' characters */
+		for (host = unc; *host && *host == '\\'; host++)
+			;
+
+		if (!*host)
+			return false;
+
+		delim = strchr(host, '\\');
+		if (!delim)
+			return false;
+
+		host_len = delim - host;
+		if (strlen(swnreg->net_name) == host_len &&
+		    !strncasecmp(swnreg->net_name, host, host_len)) {
+			return true;
+		}
+	}
+
+	if (swnreg->share_name_notify) {
+		/* extract share name, requires strlen(unc) >= 5 (\\a\b) */
+		if (strnlen(unc, 5) < 5)
+			return false;
+
+		/* extract share name, start at unc + 2, then first '\' onward */
+		share = unc + 2;
+		delim = strchr(share, '\\');
+		if (!delim)
+			return false;
+
+		share = delim + 1;
+		share_len = strlen(share);
+
+		if (strlen(swnreg->share_name) == share_len &&
+		    !strncasecmp(swnreg->share_name, share, share_len)) {
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * Sends a register message to the userspace daemon based on the registration.
  * The authentication information to connect to the witness service is bundled
@@ -305,64 +371,17 @@ static void cifs_swn_reg_check(struct work_struct *work)
 /*
  * Try to find a matching registration for the tcon's server name and share name.
  * Calls to this function must be protected by cifs_swnreg_idr_mutex.
- * TODO Try to avoid memory allocations
  */
 static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 {
 	struct cifs_swn_reg *swnreg;
 	int id;
-	const char *share_name;
-	const char *net_name;
-
-	net_name = extract_hostname(tcon->tree_name);
-	if (IS_ERR(net_name)) {
-		int ret;
-
-		ret = PTR_ERR(net_name);
-		cifs_dbg(VFS, "%s: failed to extract host name from target '%s': %d\n",
-				__func__, tcon->tree_name, ret);
-		return ERR_PTR(-EINVAL);
-	}
-
-	share_name = extract_sharename(tcon->tree_name);
-	if (IS_ERR(share_name)) {
-		int ret;
-
-		ret = PTR_ERR(share_name);
-		cifs_dbg(VFS, "%s: failed to extract share name from target '%s': %d\n",
-				__func__, tcon->tree_name, ret);
-		kfree(net_name);
-		return ERR_PTR(-EINVAL);
-	}
 
 	idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
-		struct sockaddr_storage *tcon_dstaddr;
-
-		if (tcon->ses->server->use_swn_dstaddr)
-			tcon_dstaddr = &tcon->ses->server->swn_dstaddr;
-		else
-			tcon_dstaddr = &tcon->ses->server->dstaddr;
-
-		if (strcasecmp(swnreg->net_name, net_name) != 0 ||
-		    strcasecmp(swnreg->share_name, share_name) != 0 ||
-		    !cifs_match_ipaddr((struct sockaddr *)&swnreg->addr,
-				       (struct sockaddr *)tcon_dstaddr)) {
-			continue;
-		}
-
-		cifs_dbg(FYI,
-			 "Existing swn registration for %pISc:%s:%s found\n",
-			 &swnreg->addr, swnreg->net_name, swnreg->share_name);
-
-		kfree(net_name);
-		kfree(share_name);
-
-		return swnreg;
+		if (cifs_swn_reg_tcon_matches(swnreg, tcon))
+			return swnreg;
 	}
 
-	kfree(net_name);
-	kfree(share_name);
-
 	return ERR_PTR(-EEXIST);
 }
 
-- 
2.54.0

