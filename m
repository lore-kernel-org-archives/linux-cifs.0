Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E51157490
	for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2024 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727373053; cv=none; b=uty06KxT299725TSf9n3RcWUlPyZGItF1yyhzgQPmQLZyYAnANRiGcHFFxQ1m2gvP7LifDjKp3Kf4KVmTVcFCBbAto4S9xf5rFEyLwgUqeaWYYZIvCq+OKqAnI8A2iZa+u1YIrXdn0oi4QFeiGqUvsTZp5gGePIgXSMQvY6a3L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727373053; c=relaxed/simple;
	bh=clZMv1ETXlWKoj4ZQBar2N9rvPTzJhE05IrvK9GxI6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiPF2xStLQ9GmOBCMgi+bPhKJS/Ftyy+Ag3c1xG7yhZpY48DqU/A7K2T9nHZVGgp8Y7+gyMVpXEStMLw3+bOf1bQrXztsyAUQ2qTaWmdvvTLTe91EYNoFs3NyGZbIa8O2i0eYgR6ob5FyWkk2MKrp04i/zOvS6T6j1oK7yAe1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dNuuqL7+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eacyOWt/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dNuuqL7+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eacyOWt/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dNuuqL7+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eacyOWt/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dNuuqL7+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eacyOWt/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 766F921B1D;
	Thu, 26 Sep 2024 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727373048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNkDZC73e3HSzIYo6QCiuYJS25yO+ArPNnawxTFjtAM=;
	b=dNuuqL7+FUUSOF4rvH+6yfuukqLka7G3wHw/IDmSDaN6olW2HR0CCBW98xid47i1c6mKz2
	mIIA3lSrho43lSnd6EGWt3qIjlZurpIa+11tM55r1XE9FjQfwuLWyIfm/z1YqKMW0zenkV
	4ujtelD6DJB6sQpLaB5Sweo2+hK14mU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727373048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNkDZC73e3HSzIYo6QCiuYJS25yO+ArPNnawxTFjtAM=;
	b=eacyOWt/slYqvefiRt6UOU19mA6NMgLepBKIO5I2WEcZaMaYF4vxYS9+GQB8RvYb66R9uL
	dD9702EhzT5xhvDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dNuuqL7+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="eacyOWt/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727373048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNkDZC73e3HSzIYo6QCiuYJS25yO+ArPNnawxTFjtAM=;
	b=dNuuqL7+FUUSOF4rvH+6yfuukqLka7G3wHw/IDmSDaN6olW2HR0CCBW98xid47i1c6mKz2
	mIIA3lSrho43lSnd6EGWt3qIjlZurpIa+11tM55r1XE9FjQfwuLWyIfm/z1YqKMW0zenkV
	4ujtelD6DJB6sQpLaB5Sweo2+hK14mU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727373048;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNkDZC73e3HSzIYo6QCiuYJS25yO+ArPNnawxTFjtAM=;
	b=eacyOWt/slYqvefiRt6UOU19mA6NMgLepBKIO5I2WEcZaMaYF4vxYS9+GQB8RvYb66R9uL
	dD9702EhzT5xhvDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02EA713793;
	Thu, 26 Sep 2024 17:50:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jmwWL/ee9WZVMgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 26 Sep 2024 17:50:47 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 3/4] smb: client: make HMAC-MD5 TFM ephemeral
Date: Thu, 26 Sep 2024 14:46:15 -0300
Message-ID: <20240926174616.229666-4-ematsumiya@suse.de>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240926174616.229666-1-ematsumiya@suse.de>
References: <20240926174616.229666-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 766F921B1D
X-Spam-Score: -5.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

The HMAC-MD5 shash TFM is used only briefly during Session Setup stage,
when computing NTLMv2 hashes.

There's no need to keep it allocated in servers' secmech the whole time,
so keep its lifetime inside setup_ntlmv2_rsp().

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifsencrypt.c | 133 ++++++++++++++----------------------
 fs/smb/client/cifsglob.h    |   1 -
 2 files changed, 50 insertions(+), 84 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 15aa75e7f1c3..464e6ccdfa5f 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -416,7 +416,7 @@ find_timestamp(struct cifs_ses *ses)
 }
 
 static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
-			    const struct nls_table *nls_cp)
+			    const struct nls_table *nls_cp, struct shash_desc *hmacmd5)
 {
 	int rc = 0;
 	int len;
@@ -425,34 +425,26 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	wchar_t *domain;
 	wchar_t *server;
 
-	if (!ses->server->secmech.hmacmd5) {
-		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
-		return -1;
-	}
-
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash, nls_cp);
 
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm, nt_hash,
-				CIFS_NTHASH_SIZE);
+	rc = crypto_shash_setkey(hmacmd5->tfm, nt_hash, CIFS_NTHASH_SIZE);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not set NT Hash as a key\n", __func__);
+		cifs_dbg(VFS, "%s: Could not set NT hash as a key, rc=%d\n", __func__, rc);
 		return rc;
 	}
 
-	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
+	rc = crypto_shash_init(hmacmd5);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
+		cifs_dbg(VFS, "%s: Could not init HMAC-MD5, rc=%d\n", __func__, rc);
 		return rc;
 	}
 
 	/* convert ses->user_name to unicode */
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
-	if (user == NULL) {
-		rc = -ENOMEM;
-		return rc;
-	}
+	if (user == NULL)
+		return -ENOMEM;
 
 	if (len) {
 		len = cifs_strtoUTF16(user, ses->user_name, len, nls_cp);
@@ -461,11 +453,10 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		*(u16 *)user = 0;
 	}
 
-	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
-				(char *)user, 2 * len);
+	rc = crypto_shash_update(hmacmd5, (char *)user, 2 * len);
 	kfree(user);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with user\n", __func__);
+		cifs_dbg(VFS, "%s: Could not update with user, rc=%d\n", __func__, rc);
 		return rc;
 	}
 
@@ -474,19 +465,15 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		len = strlen(ses->domainName);
 
 		domain = kmalloc(2 + (len * 2), GFP_KERNEL);
-		if (domain == NULL) {
-			rc = -ENOMEM;
-			return rc;
-		}
+		if (domain == NULL)
+			return -ENOMEM;
+
 		len = cifs_strtoUTF16((__le16 *)domain, ses->domainName, len,
 				      nls_cp);
-		rc =
-		crypto_shash_update(ses->server->secmech.hmacmd5,
-					(char *)domain, 2 * len);
+		rc = crypto_shash_update(hmacmd5, (char *)domain, 2 * len);
 		kfree(domain);
 		if (rc) {
-			cifs_dbg(VFS, "%s: Could not update with domain\n",
-				 __func__);
+			cifs_dbg(VFS, "%s: Could not update with domain, rc=%d\n", __func__, rc);
 			return rc;
 		}
 	} else {
@@ -494,33 +481,27 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		len = strlen(ses->ip_addr);
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
-		if (server == NULL) {
-			rc = -ENOMEM;
-			return rc;
-		}
-		len = cifs_strtoUTF16((__le16 *)server, ses->ip_addr, len,
-					nls_cp);
-		rc =
-		crypto_shash_update(ses->server->secmech.hmacmd5,
-					(char *)server, 2 * len);
+		if (server == NULL)
+			return -ENOMEM;
+
+		len = cifs_strtoUTF16((__le16 *)server, ses->ip_addr, len, nls_cp);
+		rc = crypto_shash_update(hmacmd5, (char *)server, 2 * len);
 		kfree(server);
 		if (rc) {
-			cifs_dbg(VFS, "%s: Could not update with server\n",
-				 __func__);
+			cifs_dbg(VFS, "%s: Could not update with server, rc=%d\n", __func__, rc);
 			return rc;
 		}
 	}
 
-	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
-					ntlmv2_hash);
+	rc = crypto_shash_final(hmacmd5, ntlmv2_hash);
 	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
+		cifs_dbg(VFS, "%s: Could not generate MD5 hash, rc=%d\n", __func__, rc);
 
 	return rc;
 }
 
 static int
-CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
+CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash, struct shash_desc *hmacmd5)
 {
 	int rc;
 	struct ntlmv2_resp *ntlmv2 = (struct ntlmv2_resp *)
@@ -531,43 +512,33 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	hash_len = ses->auth_key.len - (CIFS_SESS_KEY_SIZE +
 		offsetof(struct ntlmv2_resp, challenge.key[0]));
 
-	if (!ses->server->secmech.hmacmd5) {
-		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
-		return -1;
-	}
-
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm,
-				 ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+	rc = crypto_shash_setkey(hmacmd5->tfm, ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
-			 __func__);
+		cifs_dbg(VFS, "%s: Could not set NTLMv2 hash as a key, rc=%d\n", __func__, rc);
 		return rc;
 	}
 
-	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
+	rc = crypto_shash_init(hmacmd5);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
+		cifs_dbg(VFS, "%s: Could not init HMAC-MD5, rc=%d\n", __func__, rc);
 		return rc;
 	}
 
 	if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED)
-		memcpy(ntlmv2->challenge.key,
-		       ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
+		memcpy(ntlmv2->challenge.key, ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
 	else
-		memcpy(ntlmv2->challenge.key,
-		       ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
-	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
-				 ntlmv2->challenge.key, hash_len);
+		memcpy(ntlmv2->challenge.key, ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
+
+	rc = crypto_shash_update(hmacmd5, ntlmv2->challenge.key, hash_len);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
+		cifs_dbg(VFS, "%s: Could not update with response, rc=%d\n", __func__, rc);
 		return rc;
 	}
 
 	/* Note that the MD5 digest over writes anon.challenge_key.key */
-	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
-				ntlmv2->ntlmv2_hash);
+	rc = crypto_shash_final(hmacmd5, ntlmv2->ntlmv2_hash);
 	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
+		cifs_dbg(VFS, "%s: Could not generate MD5 hash, rc=%d\n", __func__, rc);
 
 	return rc;
 }
@@ -575,6 +546,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 int
 setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 {
+	struct shash_desc *hmacmd5 = NULL;
 	int rc;
 	int baselen;
 	unsigned int tilen;
@@ -640,55 +612,51 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 
 	cifs_server_lock(ses->server);
 
-	rc = cifs_alloc_hash("hmac(md5)", &ses->server->secmech.hmacmd5);
+	rc = cifs_alloc_hash("hmac(md5)", &hmacmd5);
 	if (rc) {
+		cifs_dbg(VFS, "Could not allocate HMAC-MD5, rc=%d\n", rc);
 		goto unlock;
 	}
 
 	/* calculate ntlmv2_hash */
-	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
+	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp, hmacmd5);
 	if (rc) {
-		cifs_dbg(VFS, "Could not get v2 hash rc %d\n", rc);
+		cifs_dbg(VFS, "Could not get NTLMv2 hash, rc=%d\n", rc);
 		goto unlock;
 	}
 
 	/* calculate first part of the client response (CR1) */
-	rc = CalcNTLMv2_response(ses, ntlmv2_hash);
+	rc = CalcNTLMv2_response(ses, ntlmv2_hash, hmacmd5);
 	if (rc) {
-		cifs_dbg(VFS, "Could not calculate CR1 rc: %d\n", rc);
+		cifs_dbg(VFS, "Could not calculate CR1, rc=%d\n", rc);
 		goto unlock;
 	}
 
 	/* now calculate the session key for NTLMv2 */
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm,
-		ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+	rc = crypto_shash_setkey(hmacmd5->tfm, ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
-			 __func__);
+		cifs_dbg(VFS, "%s: Could not set NTLMv2 hash as a key, rc=%d\n", __func__, rc);
 		goto unlock;
 	}
 
-	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
+	rc = crypto_shash_init(hmacmd5);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
+		cifs_dbg(VFS, "%s: Could not init HMAC-MD5, rc=%d\n", __func__, rc);
 		goto unlock;
 	}
 
-	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
-		ntlmv2->ntlmv2_hash,
-		CIFS_HMAC_MD5_HASH_SIZE);
+	rc = crypto_shash_update(hmacmd5, ntlmv2->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
+		cifs_dbg(VFS, "%s: Could not update with response, rc=%d\n", __func__, rc);
 		goto unlock;
 	}
 
-	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
-		ses->auth_key.response);
+	rc = crypto_shash_final(hmacmd5, ses->auth_key.response);
 	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
-
+		cifs_dbg(VFS, "%s: Could not generate MD5 hash, rc=%d\n", __func__, rc);
 unlock:
 	cifs_server_unlock(ses->server);
+	cifs_free_hash(&hmacmd5);
 setup_ntlmv2_rsp_ret:
 	kfree_sensitive(tiblob);
 
@@ -733,7 +701,6 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 	cifs_free_hash(&server->secmech.hmacsha256);
 	cifs_free_hash(&server->secmech.md5);
 	cifs_free_hash(&server->secmech.sha512);
-	cifs_free_hash(&server->secmech.hmacmd5);
 
 	if (!SERVER_IS_CHAN(server)) {
 		if (server->secmech.enc) {
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 15571cf0ba63..da35c160e7dd 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -178,7 +178,6 @@ struct session_key {
 
 /* crypto hashing related structure/fields, not specific to a sec mech */
 struct cifs_secmech {
-	struct shash_desc *hmacmd5; /* hmacmd5 hash function, for NTLMv2/CR1 hashes */
 	struct shash_desc *md5; /* md5 hash function, for CIFS/SMB1 signatures */
 	struct shash_desc *hmacsha256; /* hmac-sha256 hash function, for SMB2 signatures */
 	struct shash_desc *sha512; /* sha512 hash function, for SMB3.1.1 preauth hash */
-- 
2.46.0

