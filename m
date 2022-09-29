Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA33C32771
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 01:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiI2B5M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 21:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI2B5L (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 21:57:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101E7122077
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 18:57:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BFDC71F74D;
        Thu, 29 Sep 2022 01:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664416628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tziFjfy4hQN7103lSMy/8u6eTGwU/xH9mZ/QKefEpUA=;
        b=11U/6GhdxZhYD9ehXxes+zof32yWE8uN2uUzxmfZsznTX20JuHQEUCHeN/1RHynGwVgyE7
        VpuL/AArikfVLf4mcwwugVKcn0wqUMkH34FvsoKoHIy0SZOzb/SFslwZetfM0X0VVc+hSf
        rrcp3UShn3G5BEA2cMkqp2dhrm57RmI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664416628;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tziFjfy4hQN7103lSMy/8u6eTGwU/xH9mZ/QKefEpUA=;
        b=1DZTKseaVmIbPU4MfHAbUsKiHLmRpCrtn51IJVhKZvqPzQvs8NPgcqb1nnGzvsAIerdFkr
        MJ+6+jfTHG9rItAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C17E139B3;
        Thu, 29 Sep 2022 01:57:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CME2O3P7NGOEeQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 01:57:07 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v3 3/8] cifs: allocate ephemeral secmechs only on demand
Date:   Wed, 28 Sep 2022 22:56:32 -0300
Message-Id: <20220929015637.14400-4-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929015637.14400-1-ematsumiya@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reduce memory usage a bit by removing some secmechs as they are
only briefly used on session setup, and not needed anymore
throughout a server's object lifetime. Allocate and free them on
demand now.

HMAC-SHA256 is an exception because it's used both for SMB2 signatures
as for generating SMB3+ signatures, so allocate/free a dedicated one in
generate_key() too to keep things separated.

smb3*_crypto_shash_allocate functions are removed since we're now
calling cifs_alloc_hash() directly and especifically.

Also move smb3_crypto_aead_allocate() call to generate_key(), right
after when crypto keys are generated.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c   | 73 +++++++++++++++---------------------
 fs/cifs/cifsglob.h      |  2 -
 fs/cifs/misc.c          |  2 +-
 fs/cifs/sess.c          | 12 ------
 fs/cifs/smb2misc.c      | 18 ++++-----
 fs/cifs/smb2ops.c       |  8 ++--
 fs/cifs/smb2pdu.c       | 19 ++++++++++
 fs/cifs/smb2proto.h     |  1 -
 fs/cifs/smb2transport.c | 83 ++++++++++++-----------------------------
 9 files changed, 86 insertions(+), 132 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 30ece0c58c71..ed25ac811f05 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -401,7 +401,8 @@ find_timestamp(struct cifs_ses *ses)
 }
 
 static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
-			    const struct nls_table *nls_cp)
+			    const struct nls_table *nls_cp,
+			    struct shash_desc *hmacmd5)
 {
 	int rc = 0;
 	int len;
@@ -410,7 +411,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	wchar_t *domain;
 	wchar_t *server;
 
-	if (!ses->server->secmech.hmacmd5) {
+	if (!hmacmd5) {
 		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
 		return -1;
 	}
@@ -418,14 +419,13 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash, nls_cp);
 
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm, nt_hash,
-				CIFS_NTHASH_SIZE);
+	rc = crypto_shash_setkey(hmacmd5->tfm, nt_hash, CIFS_NTHASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set NT Hash as a key\n", __func__);
 		return rc;
 	}
 
-	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
+	rc = crypto_shash_init(hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
 		return rc;
@@ -446,8 +446,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		memset(user, '\0', 2);
 	}
 
-	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
-				(char *)user, 2 * len);
+	rc = crypto_shash_update(hmacmd5, (char *)user, 2 * len);
 	kfree(user);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with user\n", __func__);
@@ -465,9 +464,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		}
 		len = cifs_strtoUTF16((__le16 *)domain, ses->domainName, len,
 				      nls_cp);
-		rc =
-		crypto_shash_update(ses->server->secmech.hmacmd5,
-					(char *)domain, 2 * len);
+		rc = crypto_shash_update(hmacmd5, (char *)domain, 2 * len);
 		kfree(domain);
 		if (rc) {
 			cifs_dbg(VFS, "%s: Could not update with domain\n",
@@ -485,9 +482,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		}
 		len = cifs_strtoUTF16((__le16 *)server, ses->ip_addr, len,
 					nls_cp);
-		rc =
-		crypto_shash_update(ses->server->secmech.hmacmd5,
-					(char *)server, 2 * len);
+		rc = crypto_shash_update(hmacmd5, (char *)server, 2 * len);
 		kfree(server);
 		if (rc) {
 			cifs_dbg(VFS, "%s: Could not update with server\n",
@@ -496,8 +491,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		}
 	}
 
-	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
-					ntlmv2_hash);
+	rc = crypto_shash_final(hmacmd5, ntlmv2_hash);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
@@ -505,7 +499,8 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 }
 
 static int
-CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
+CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash,
+		    struct shash_desc *hmacmd5)
 {
 	int rc;
 	struct ntlmv2_resp *ntlmv2 = (struct ntlmv2_resp *)
@@ -516,20 +511,19 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	hash_len = ses->auth_key.len - (CIFS_SESS_KEY_SIZE +
 		offsetof(struct ntlmv2_resp, challenge.key[0]));
 
-	if (!ses->server->secmech.hmacmd5) {
+	if (!hmacmd5) {
 		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
 		return -1;
 	}
 
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm,
-				 ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+	rc = crypto_shash_setkey(hmacmd5->tfm, ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
 			 __func__);
 		return rc;
 	}
 
-	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
+	rc = crypto_shash_init(hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
 		return rc;
@@ -541,16 +535,14 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	else
 		memcpy(ntlmv2->challenge.key,
 		       ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
-	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
-				 ntlmv2->challenge.key, hash_len);
+	rc = crypto_shash_update(hmacmd5, ntlmv2->challenge.key, hash_len);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
 	/* Note that the MD5 digest over writes anon.challenge_key.key */
-	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
-				ntlmv2->ntlmv2_hash);
+	rc = crypto_shash_final(hmacmd5, ntlmv2->ntlmv2_hash);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
@@ -567,6 +559,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	char ntlmv2_hash[16];
 	unsigned char *tiblob = NULL; /* target info blob */
 	__le64 rsp_timestamp;
+	struct shash_desc *hmacmd5 = NULL;
 
 	if (nls_cp == NULL) {
 		cifs_dbg(VFS, "%s called with nls_cp==NULL\n", __func__);
@@ -625,53 +618,51 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 
 	cifs_server_lock(ses->server);
 
-	rc = cifs_alloc_hash("hmac(md5)", &ses->server->secmech.hmacmd5);
+	rc = cifs_alloc_hash("hmac(md5)", &hmacmd5);
 	if (rc) {
 		goto unlock;
 	}
 
 	/* calculate ntlmv2_hash */
-	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
+	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp, hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "Could not get v2 hash rc %d\n", rc);
-		goto unlock;
+		goto out_free_hash;
 	}
 
 	/* calculate first part of the client response (CR1) */
-	rc = CalcNTLMv2_response(ses, ntlmv2_hash);
+	rc = CalcNTLMv2_response(ses, ntlmv2_hash, hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "Could not calculate CR1 rc: %d\n", rc);
-		goto unlock;
+		goto out_free_hash;
 	}
 
 	/* now calculate the session key for NTLMv2 */
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm,
-		ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+	rc = crypto_shash_setkey(hmacmd5->tfm, ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
 			 __func__);
-		goto unlock;
+		goto out_free_hash;
 	}
 
-	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
+	rc = crypto_shash_init(hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
-		goto unlock;
+		goto out_free_hash;
 	}
 
-	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
-		ntlmv2->ntlmv2_hash,
-		CIFS_HMAC_MD5_HASH_SIZE);
+	rc = crypto_shash_update(hmacmd5, ntlmv2->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
-		goto unlock;
+		goto out_free_hash;
 	}
 
-	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
-		ses->auth_key.response);
+	rc = crypto_shash_final(hmacmd5, ses->auth_key.response);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
+out_free_hash:
+	cifs_free_hash(&hmacmd5);
 unlock:
 	cifs_server_unlock(ses->server);
 setup_ntlmv2_rsp_ret:
@@ -717,8 +708,6 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 	cifs_free_hash(&server->secmech.aes_cmac);
 	cifs_free_hash(&server->secmech.hmacsha256);
 	cifs_free_hash(&server->secmech.md5);
-	cifs_free_hash(&server->secmech.sha512);
-	cifs_free_hash(&server->secmech.hmacmd5);
 
 	if (server->secmech.enc) {
 		crypto_free_aead(server->secmech.enc);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ea76f4d7ef62..5da71d946012 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -155,10 +155,8 @@ struct session_key {
 
 /* crypto hashing related structure/fields, not specific to a sec mech */
 struct cifs_secmech {
-	struct shash_desc *hmacmd5; /* hmacmd5 hash function, for NTLMv2/CR1 hashes */
 	struct shash_desc *md5; /* md5 hash function, for CIFS/SMB1 signatures */
 	struct shash_desc *hmacsha256; /* hmac-sha256 hash function, for SMB2 signatures */
-	struct shash_desc *sha512; /* sha512 hash function, for SMB3.1.1 preauth hash */
 	struct shash_desc *aes_cmac; /* block-cipher based MAC function, for SMB3 signatures */
 
 	struct crypto_aead *enc; /* smb3 encryption AEAD TFM (AES-CCM and AES-GCM) */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 535dbe6ff994..c7eade06e2de 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1093,7 +1093,7 @@ cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
 		return rc;
 	}
 
-	*sdesc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(alg), GFP_KERNEL);
+	*sdesc = kzalloc(sizeof(struct shash_desc) + crypto_shash_descsize(alg), GFP_KERNEL);
 	if (*sdesc == NULL) {
 		cifs_dbg(VFS, "no memory left to allocate shash TFM '%s'\n", name);
 		crypto_free_shash(alg);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3af3b05b6c74..d59dec7a2a55 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -454,18 +454,6 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	spin_unlock(&ses->chan_lock);
 
 	mutex_lock(&ses->session_mutex);
-	/*
-	 * We need to allocate the server crypto now as we will need
-	 * to sign packets before we generate the channel signing key
-	 * (we sign with the session key)
-	 */
-	rc = smb311_crypto_shash_allocate(chan->server);
-	if (rc) {
-		cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
-		mutex_unlock(&ses->session_mutex);
-		goto out;
-	}
-
 	rc = cifs_negotiate_protocol(xid, ses, chan->server);
 	if (!rc)
 		rc = cifs_setup_session(xid, ses, chan->server, cifs_sb->local_nls);
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7db5c09ecceb..39a9fc60eb9e 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -897,22 +897,21 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		return 0;
 
 ok:
-	rc = smb311_crypto_shash_allocate(server);
+	rc = cifs_alloc_hash("sha512", &sha512);
 	if (rc)
 		return rc;
 
-	sha512 = server->secmech.sha512;
 	rc = crypto_shash_init(sha512);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init sha512 shash\n", __func__);
-		return rc;
+		goto out_free_hash;
 	}
 
 	rc = crypto_shash_update(sha512, ses->preauth_sha_hash,
 				 SMB2_PREAUTH_HASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update sha512 shash\n", __func__);
-		return rc;
+		goto out_free_hash;
 	}
 
 	for (i = 0; i < nvec; i++) {
@@ -920,16 +919,15 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		if (rc) {
 			cifs_dbg(VFS, "%s: Could not update sha512 shash\n",
 				 __func__);
-			return rc;
+			goto out_free_hash;
 		}
 	}
 
 	rc = crypto_shash_final(sha512, ses->preauth_sha_hash);
-	if (rc) {
+	if (rc)
 		cifs_dbg(VFS, "%s: Could not finalize sha512 shash\n",
 			 __func__);
-		return rc;
-	}
-
-	return 0;
+out_free_hash:
+	cifs_free_hash(&sha512);
+	return rc;
 }
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d1528755f330..34dea8aa854b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4338,10 +4338,10 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		return rc;
 	}
 
-	rc = smb3_crypto_aead_allocate(server);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: crypto alloc failed\n", __func__);
-		return rc;
+	/* sanity check -- TFMs were allocated after negotiate protocol */
+	if (unlikely(!server->secmech.enc || !server->secmech.dec)) {
+		cifs_server_dbg(VFS, "%s: crypto TFMs are NULL\n", __func__);
+		return -EIO;
 	}
 
 	tfm = enc ? server->secmech.enc : server->secmech.dec;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6352ab32c7e7..48b25054354c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -927,6 +927,16 @@ SMB2_negotiate(const unsigned int xid,
 	else
 		req->SecurityMode = 0;
 
+	if (req->SecurityMode) {
+		/*
+		 * Allocate HMAC-SHA256 regardless of dialect requested, change to AES-CMAC later,
+		 * if SMB3+ is negotiated
+		 */
+		rc = cifs_alloc_hash("hmac(sha256)",&server->secmech.hmacsha256);
+		if (rc)
+			goto neg_exit;
+	}
+
 	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
 	if (ses->chan_max > 1)
 		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
@@ -1071,6 +1081,15 @@ SMB2_negotiate(const unsigned int xid,
 	rc = cifs_enable_signing(server, ses->sign);
 	if (rc)
 		goto neg_exit;
+
+	if (server->sign && server->dialect >= SMB30_PROT_ID) {
+		/* free HMAC-SHA256 allocated earlier for negprot */
+		cifs_free_hash(&server->secmech.hmacsha256);
+		rc = cifs_alloc_hash("cmac(aes)", &server->secmech.aes_cmac);
+		if (rc)
+			goto neg_exit;
+	}
+
 	if (blob_length) {
 		rc = decode_negTokenInit(security_blob, blob_length, server);
 		if (rc == 1)
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 3f740f24b96a..a975144c63bf 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -267,7 +267,6 @@ extern int smb2_validate_and_copy_iov(unsigned int offset,
 extern void smb2_copy_fs_info_to_kstatfs(
 	 struct smb2_fs_full_size_info *pfs_inf,
 	 struct kstatfs *kst);
-extern int smb311_crypto_shash_allocate(struct TCP_Server_Info *server);
 extern int smb311_update_preauth_hash(struct cifs_ses *ses,
 				      struct TCP_Server_Info *server,
 				      struct kvec *iov, int nvec);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index dfcbcc0b86e4..2dca2c255239 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -26,53 +26,6 @@
 #include "smb2status.h"
 #include "smb2glob.h"
 
-static int
-smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
-{
-	struct cifs_secmech *p = &server->secmech;
-	int rc;
-
-	rc = cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
-	if (rc)
-		goto err;
-
-	rc = cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
-	if (rc)
-		goto err;
-
-	return 0;
-err:
-	cifs_free_hash(&p->hmacsha256);
-	return rc;
-}
-
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
@@ -215,7 +168,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct cifs_ses *ses;
-	struct shash_desc *shash;
+	struct shash_desc *shash = NULL;
 	struct smb_rqst drqst;
 
 	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
@@ -297,48 +250,50 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 	unsigned char prfhash[SMB2_HMACSHA256_SIZE];
 	unsigned char *hashptr = prfhash;
 	struct TCP_Server_Info *server = ses->server;
+	struct shash_desc *hmac_sha256 = NULL;
 
 	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(key, 0x0, key_size);
 
-	rc = smb3_crypto_shash_allocate(server);
+	/* do not reuse the server's secmech TFM */
+	rc = cifs_alloc_hash("hmac(sha256)", &hmac_sha256);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: crypto alloc failed\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_setkey(server->secmech.hmacsha256->tfm,
-		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+	rc = crypto_shash_setkey(hmac_sha256->tfm, ses->auth_key.response,
+				 SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set with session key\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_init(server->secmech.hmacsha256);
+	rc = crypto_shash_init(hmac_sha256);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not init sign hmac\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(server->secmech.hmacsha256, i, 4);
+	rc = crypto_shash_update(hmac_sha256, i, 4);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with n\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(server->secmech.hmacsha256, label.iov_base, label.iov_len);
+	rc = crypto_shash_update(hmac_sha256, label.iov_base, label.iov_len);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with label\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(server->secmech.hmacsha256, &zero, 1);
+	rc = crypto_shash_update(hmac_sha256, &zero, 1);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with zero\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(server->secmech.hmacsha256, context.iov_base, context.iov_len);
+	rc = crypto_shash_update(hmac_sha256, context.iov_base, context.iov_len);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with context\n", __func__);
 		goto smb3signkey_ret;
@@ -346,16 +301,16 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
 		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)) {
-		rc = crypto_shash_update(server->secmech.hmacsha256, L256, 4);
+		rc = crypto_shash_update(hmac_sha256, L256, 4);
 	} else {
-		rc = crypto_shash_update(server->secmech.hmacsha256, L128, 4);
+		rc = crypto_shash_update(hmac_sha256, L128, 4);
 	}
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with L\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_final(server->secmech.hmacsha256, hashptr);
+	rc = crypto_shash_final(hmac_sha256, hashptr);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not generate sha256 hash\n", __func__);
 		goto smb3signkey_ret;
@@ -364,6 +319,7 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 	memcpy(key, hashptr, key_size);
 
 smb3signkey_ret:
+	cifs_free_hash(&hmac_sha256);
 	return rc;
 }
 
@@ -428,12 +384,19 @@ generate_smb3signingkey(struct cifs_ses *ses,
 				  ptriplet->encryption.context,
 				  ses->smb3encryptionkey,
 				  SMB3_ENC_DEC_KEY_SIZE);
+		if (rc)
+			return rc;
+
 		rc = generate_key(ses, ptriplet->decryption.label,
 				  ptriplet->decryption.context,
 				  ses->smb3decryptionkey,
 				  SMB3_ENC_DEC_KEY_SIZE);
 		if (rc)
 			return rc;
+
+		rc = smb3_crypto_aead_allocate(server);
+		if (rc)
+			return rc;
 	}
 
 	if (rc)
@@ -535,7 +498,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	unsigned char *sigptr = smb3_signature;
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct shash_desc *shash;
+	struct shash_desc *shash = NULL;
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
-- 
2.35.3

