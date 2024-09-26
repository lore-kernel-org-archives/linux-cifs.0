Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EB017D344
	for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2024 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727373059; cv=none; b=MnzpmIzw8KGlhiZyPMaPEeCCMVyqj/X5InqzlWSvPg9IZ0kmPO+jON9tiZmuSDbmHdMwHqbuI9SyDzirpwfQ9WgBkB7AVnJPq45kQrmGSZnidZdaXClMZJNw5MoHvZvuwIk30N133h5RM0qi2Ur+K3FnqpoDLbA+s5pmR3+VCxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727373059; c=relaxed/simple;
	bh=JjlMSGhH88pHqYnvq7x/6ChVhsareQksOl8UG0+QABk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2sNN8TqsQ4xrAEsDF9YWdsR91ZY1scG8LEtRNGvbQNecg3mvVBUzpsUT2PWtHTR3tWfjm8bT5NjK5hBRgMtEhyj12jEjCsn2W8ZfZz4I8hX557/9NkkGGPuAXTtfPf6J8ndA5mezYZaM9/kpOFdrek/yf9Y7FyGcg/HA0SIVZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DWKKdJy4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9yg3lkiB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DWKKdJy4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9yg3lkiB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DWKKdJy4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9yg3lkiB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DWKKdJy4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9yg3lkiB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D5DE1FCFB;
	Thu, 26 Sep 2024 17:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727373055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pAymWzaozK5zzYuJqsetoF9CtM6O4PhU4lUuSCOXKLA=;
	b=DWKKdJy4xCPWo19AoWI3QPGJLOBx4g7w3att0IGX97RmKs3ScO18aSCPYVA++ZEEeLg19m
	liji11pdgkjCscIbnEmrQTCk472CFJhG2Vx+zq0FEOvSfTI6GHyL6syePcWG/apsKoh1eK
	nyl6WSLcD4SFiGUpRMQSwNW2De8s1Dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727373055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pAymWzaozK5zzYuJqsetoF9CtM6O4PhU4lUuSCOXKLA=;
	b=9yg3lkiBQkfiFovtsA0sbGb/PLXgskpFoifloWIIjHwbrPG6OJiZKrIc1/CPSLpXyFdS28
	2u6oK4R6ev+Pv5Aw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727373055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pAymWzaozK5zzYuJqsetoF9CtM6O4PhU4lUuSCOXKLA=;
	b=DWKKdJy4xCPWo19AoWI3QPGJLOBx4g7w3att0IGX97RmKs3ScO18aSCPYVA++ZEEeLg19m
	liji11pdgkjCscIbnEmrQTCk472CFJhG2Vx+zq0FEOvSfTI6GHyL6syePcWG/apsKoh1eK
	nyl6WSLcD4SFiGUpRMQSwNW2De8s1Dw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727373055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pAymWzaozK5zzYuJqsetoF9CtM6O4PhU4lUuSCOXKLA=;
	b=9yg3lkiBQkfiFovtsA0sbGb/PLXgskpFoifloWIIjHwbrPG6OJiZKrIc1/CPSLpXyFdS28
	2u6oK4R6ev+Pv5Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A42113793;
	Thu, 26 Sep 2024 17:50:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wQe5NP6e9WZhMgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 26 Sep 2024 17:50:54 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH 4/4] smb: client: make SHA-512 TFM ephemeral
Date: Thu, 26 Sep 2024 14:46:16 -0300
Message-ID: <20240926174616.229666-5-ematsumiya@suse.de>
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
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 

The SHA-512 shash TFM is used only briefly during Session Setup stage,
when computing SMB 3.1.1 preauth hash.

There's no need to keep it allocated in servers' secmech the whole time,
so keep its lifetime inside smb311_update_preauth_hash().

This also makes smb311_crypto_shash_allocate() redundant, so expose
smb3_crypto_shash_allocate() and use that.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/cifsencrypt.c   |  1 -
 fs/smb/client/cifsglob.h      |  1 -
 fs/smb/client/sess.c          |  2 +-
 fs/smb/client/smb2misc.c      | 28 ++++++++++++++--------------
 fs/smb/client/smb2proto.h     |  2 +-
 fs/smb/client/smb2transport.c | 30 +-----------------------------
 6 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
index 464e6ccdfa5f..2d851f596a72 100644
--- a/fs/smb/client/cifsencrypt.c
+++ b/fs/smb/client/cifsencrypt.c
@@ -700,7 +700,6 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 	cifs_free_hash(&server->secmech.aes_cmac);
 	cifs_free_hash(&server->secmech.hmacsha256);
 	cifs_free_hash(&server->secmech.md5);
-	cifs_free_hash(&server->secmech.sha512);
 
 	if (!SERVER_IS_CHAN(server)) {
 		if (server->secmech.enc) {
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index da35c160e7dd..315aac5dec05 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -180,7 +180,6 @@ struct session_key {
 struct cifs_secmech {
 	struct shash_desc *md5; /* md5 hash function, for CIFS/SMB1 signatures */
 	struct shash_desc *hmacsha256; /* hmac-sha256 hash function, for SMB2 signatures */
-	struct shash_desc *sha512; /* sha512 hash function, for SMB3.1.1 preauth hash */
 	struct shash_desc *aes_cmac; /* block-cipher based MAC function, for SMB3 signatures */
 
 	struct crypto_aead *enc; /* smb3 encryption AEAD TFM (AES-CCM and AES-GCM) */
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 3216f786908f..03c0b484a4b5 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -624,7 +624,7 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	 * to sign packets before we generate the channel signing key
 	 * (we sign with the session key)
 	 */
-	rc = smb311_crypto_shash_allocate(chan->server);
+	rc = smb3_crypto_shash_allocate(chan->server);
 	if (rc) {
 		cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
 		mutex_unlock(&ses->session_mutex);
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index f3c4b70b77b9..bdeb12ff53e3 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -906,41 +906,41 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		|| (hdr->Status !=
 		    cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))))
 		return 0;
-
 ok:
-	rc = smb311_crypto_shash_allocate(server);
-	if (rc)
+	rc = cifs_alloc_hash("sha512", &sha512);
+	if (rc) {
+		cifs_dbg(VFS, "%s: Could not allocate SHA512 shash, rc=%d\n", __func__, rc);
 		return rc;
+	}
 
-	sha512 = server->secmech.sha512;
 	rc = crypto_shash_init(sha512);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init sha512 shash\n", __func__);
-		return rc;
+		cifs_dbg(VFS, "%s: Could not init SHA512 shash, rc=%d\n", __func__, rc);
+		goto err_free;
 	}
 
 	rc = crypto_shash_update(sha512, ses->preauth_sha_hash,
 				 SMB2_PREAUTH_HASH_SIZE);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update sha512 shash\n", __func__);
-		return rc;
+		cifs_dbg(VFS, "%s: Could not update SHA512 shash, rc=%d\n", __func__, rc);
+		goto err_free;
 	}
 
 	for (i = 0; i < nvec; i++) {
 		rc = crypto_shash_update(sha512, iov[i].iov_base, iov[i].iov_len);
 		if (rc) {
-			cifs_dbg(VFS, "%s: Could not update sha512 shash\n",
-				 __func__);
-			return rc;
+			cifs_dbg(VFS, "%s: Could not update SHA512 shash, rc=%d\n", __func__, rc);
+			goto err_free;
 		}
 	}
 
 	rc = crypto_shash_final(sha512, ses->preauth_sha_hash);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not finalize sha512 shash\n",
-			 __func__);
-		return rc;
+		cifs_dbg(VFS, "%s: Could not finalize SHA12 shash, rc=%d\n", __func__, rc);
+		goto err_free;
 	}
+err_free:
+	cifs_free_hash(&sha512);
 
 	return 0;
 }
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index c7e1b149877a..56a896ff7cd9 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -291,7 +291,7 @@ extern int smb2_validate_and_copy_iov(unsigned int offset,
 extern void smb2_copy_fs_info_to_kstatfs(
 	 struct smb2_fs_full_size_info *pfs_inf,
 	 struct kstatfs *kst);
-extern int smb311_crypto_shash_allocate(struct TCP_Server_Info *server);
+extern int smb3_crypto_shash_allocate(struct TCP_Server_Info *server);
 extern int smb311_update_preauth_hash(struct cifs_ses *ses,
 				      struct TCP_Server_Info *server,
 				      struct kvec *iov, int nvec);
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index c8bf0000f73b..f7e04c40d22e 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -26,8 +26,7 @@
 #include "../common/smb2status.h"
 #include "smb2glob.h"
 
-static int
-smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
+int smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p = &server->secmech;
 	int rc;
@@ -46,33 +45,6 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 	return rc;
 }
 
-int
-smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
-{
-	struct cifs_secmech *p = &server->secmech;
-	int rc = 0;
-
-	rc = cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
-	if (rc)
-		return rc;
-
-	rc = cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
-	if (rc)
-		goto err;
-
-	rc = cifs_alloc_hash("sha512", &p->sha512);
-	if (rc)
-		goto err;
-
-	return 0;
-
-err:
-	cifs_free_hash(&p->aes_cmac);
-	cifs_free_hash(&p->hmacsha256);
-	return rc;
-}
-
-
 static
 int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 {
-- 
2.46.0

