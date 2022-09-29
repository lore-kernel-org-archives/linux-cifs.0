Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF0AC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 20:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiI2UhI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 16:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiI2UhI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 16:37:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E2C1323E5
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 13:37:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 007DB1F38D;
        Thu, 29 Sep 2022 20:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664483824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RVB5hF8k2W9sZHA8L0OYgfnTW07ngd1hY90O+IPHhow=;
        b=WaLFA3eN2TBc6mePL8CXQQnNdyJydBUxQtp16am2OHuALarQ8BwWHabriIWedv9NfMCMDm
        V6Lt3qyiwKKN2s26ggbMkcjAcAPP/Vm3iZcf/UIS+n7EOoF5kP3b8HE4M0Z013imw9Z9xQ
        MoEBDsiEgi8enQFtdKIyPXUKVmjy9BQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664483824;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RVB5hF8k2W9sZHA8L0OYgfnTW07ngd1hY90O+IPHhow=;
        b=aimBMiS+DXBaExev72NJL9i37d1aDFTo7vH7K164dcg1QdZtf8xYuf6sj9onyHxFM46Ylo
        9pCwniAX9Gu3l9Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 68ABB1348E;
        Thu, 29 Sep 2022 20:37:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6CH9Cu8BNmPpTAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 20:37:03 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v4 2/8] cifs: secmech: use shash_desc directly, remove sdesc
Date:   Thu, 29 Sep 2022 17:36:50 -0300
Message-Id: <20220929203652.13178-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929203652.13178-1-ematsumiya@suse.de>
References: <20220929203652.13178-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The struct sdesc is just a wrapper around shash_desc, with exact same
memory layout. Replace the hashing TFMs with shash_desc as it's what's
passed to the crypto API anyway.

Also remove the crypto_shash pointers as they can be accessed via
shash_desc->tfm (and are actually only used in the setkey calls).

Adapt cifs_{alloc,free}_hash functions to this change.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c   | 86 +++++++++++++----------------------------
 fs/cifs/cifsglob.h      | 26 ++++---------
 fs/cifs/cifsproto.h     |  5 +--
 fs/cifs/link.c          | 13 +++----
 fs/cifs/misc.c          | 49 ++++++++++++-----------
 fs/cifs/smb2misc.c      | 13 +++----
 fs/cifs/smb2transport.c | 72 +++++++++++++---------------------
 7 files changed, 98 insertions(+), 166 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index f622d2ba6bd0..30ece0c58c71 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -103,26 +103,24 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 	if (!rqst->rq_iov || !signature || !server)
 		return -EINVAL;
 
-	rc = cifs_alloc_hash("md5", &server->secmech.md5,
-			     &server->secmech.sdescmd5);
+	rc = cifs_alloc_hash("md5", &server->secmech.md5);
 	if (rc)
 		return -1;
 
-	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
+	rc = crypto_shash_init(server->secmech.md5);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
 		return rc;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
+	rc = crypto_shash_update(server->secmech.md5,
 		server->session_key.response, server->session_key.len);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
-	return __cifs_calc_signature(rqst, server, signature,
-				     &server->secmech.sdescmd5->shash);
+	return __cifs_calc_signature(rqst, server, signature, server->secmech.md5);
 }
 
 /* must be called with server->srv_mutex held */
@@ -412,7 +410,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	wchar_t *domain;
 	wchar_t *server;
 
-	if (!ses->server->secmech.sdeschmacmd5) {
+	if (!ses->server->secmech.hmacmd5) {
 		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
 		return -1;
 	}
@@ -420,14 +418,14 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash, nls_cp);
 
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
+	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm, nt_hash,
 				CIFS_NTHASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set NT Hash as a key\n", __func__);
 		return rc;
 	}
 
-	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
+	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
 		return rc;
@@ -448,7 +446,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		memset(user, '\0', 2);
 	}
 
-	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
 				(char *)user, 2 * len);
 	kfree(user);
 	if (rc) {
@@ -468,7 +466,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		len = cifs_strtoUTF16((__le16 *)domain, ses->domainName, len,
 				      nls_cp);
 		rc =
-		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+		crypto_shash_update(ses->server->secmech.hmacmd5,
 					(char *)domain, 2 * len);
 		kfree(domain);
 		if (rc) {
@@ -488,7 +486,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		len = cifs_strtoUTF16((__le16 *)server, ses->ip_addr, len,
 					nls_cp);
 		rc =
-		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+		crypto_shash_update(ses->server->secmech.hmacmd5,
 					(char *)server, 2 * len);
 		kfree(server);
 		if (rc) {
@@ -498,7 +496,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		}
 	}
 
-	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
 					ntlmv2_hash);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
@@ -518,12 +516,12 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	hash_len = ses->auth_key.len - (CIFS_SESS_KEY_SIZE +
 		offsetof(struct ntlmv2_resp, challenge.key[0]));
 
-	if (!ses->server->secmech.sdeschmacmd5) {
+	if (!ses->server->secmech.hmacmd5) {
 		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
 		return -1;
 	}
 
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
+	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm,
 				 ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
@@ -531,7 +529,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 		return rc;
 	}
 
-	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
+	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
 		return rc;
@@ -543,7 +541,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	else
 		memcpy(ntlmv2->challenge.key,
 		       ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
-	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
 				 ntlmv2->challenge.key, hash_len);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
@@ -551,7 +549,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	}
 
 	/* Note that the MD5 digest over writes anon.challenge_key.key */
-	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
 				ntlmv2->ntlmv2_hash);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
@@ -627,9 +625,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 
 	cifs_server_lock(ses->server);
 
-	rc = cifs_alloc_hash("hmac(md5)",
-			     &ses->server->secmech.hmacmd5,
-			     &ses->server->secmech.sdeschmacmd5);
+	rc = cifs_alloc_hash("hmac(md5)", &ses->server->secmech.hmacmd5);
 	if (rc) {
 		goto unlock;
 	}
@@ -649,7 +645,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	}
 
 	/* now calculate the session key for NTLMv2 */
-	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
+	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5->tfm,
 		ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
@@ -657,13 +653,13 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		goto unlock;
 	}
 
-	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
+	rc = crypto_shash_init(ses->server->secmech.hmacmd5);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
 		goto unlock;
 	}
 
-	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_update(ses->server->secmech.hmacmd5,
 		ntlmv2->ntlmv2_hash,
 		CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
@@ -671,7 +667,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		goto unlock;
 	}
 
-	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_final(ses->server->secmech.hmacmd5,
 		ses->auth_key.response);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
@@ -718,30 +714,11 @@ calc_seckey(struct cifs_ses *ses)
 void
 cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 {
-	if (server->secmech.cmacaes) {
-		crypto_free_shash(server->secmech.cmacaes);
-		server->secmech.cmacaes = NULL;
-	}
-
-	if (server->secmech.hmacsha256) {
-		crypto_free_shash(server->secmech.hmacsha256);
-		server->secmech.hmacsha256 = NULL;
-	}
-
-	if (server->secmech.md5) {
-		crypto_free_shash(server->secmech.md5);
-		server->secmech.md5 = NULL;
-	}
-
-	if (server->secmech.sha512) {
-		crypto_free_shash(server->secmech.sha512);
-		server->secmech.sha512 = NULL;
-	}
-
-	if (server->secmech.hmacmd5) {
-		crypto_free_shash(server->secmech.hmacmd5);
-		server->secmech.hmacmd5 = NULL;
-	}
+	cifs_free_hash(&server->secmech.aes_cmac);
+	cifs_free_hash(&server->secmech.hmacsha256);
+	cifs_free_hash(&server->secmech.md5);
+	cifs_free_hash(&server->secmech.sha512);
+	cifs_free_hash(&server->secmech.hmacmd5);
 
 	if (server->secmech.enc) {
 		crypto_free_aead(server->secmech.enc);
@@ -752,15 +729,4 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 		crypto_free_aead(server->secmech.dec);
 		server->secmech.dec = NULL;
 	}
-
-	kfree(server->secmech.sdesccmacaes);
-	server->secmech.sdesccmacaes = NULL;
-	kfree(server->secmech.sdeschmacsha256);
-	server->secmech.sdeschmacsha256 = NULL;
-	kfree(server->secmech.sdeschmacmd5);
-	server->secmech.sdeschmacmd5 = NULL;
-	kfree(server->secmech.sdescmd5);
-	server->secmech.sdescmd5 = NULL;
-	kfree(server->secmech.sdescsha512);
-	server->secmech.sdescsha512 = NULL;
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index cbb108b15412..ea76f4d7ef62 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -153,26 +153,16 @@ struct session_key {
 	char *response;
 };
 
-/* crypto security descriptor definition */
-struct sdesc {
-	struct shash_desc shash;
-	char ctx[];
-};
-
 /* crypto hashing related structure/fields, not specific to a sec mech */
 struct cifs_secmech {
-	struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
-	struct crypto_shash *md5; /* md5 hash function */
-	struct crypto_shash *hmacsha256; /* hmac-sha256 hash function */
-	struct crypto_shash *cmacaes; /* block-cipher based MAC function */
-	struct crypto_shash *sha512; /* sha512 hash function */
-	struct sdesc *sdeschmacmd5;  /* ctxt to generate ntlmv2 hash, CR1 */
-	struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signature */
-	struct sdesc *sdeschmacsha256;  /* ctxt to generate smb2 signature */
-	struct sdesc *sdesccmacaes;  /* ctxt to generate smb3 signature */
-	struct sdesc *sdescsha512; /* ctxt to generate smb3.11 signing key */
-	struct crypto_aead *enc; /* smb3 AEAD encryption TFM (AES-CCM and AES-GCM) */
-	struct crypto_aead *dec; /* smb3 AEAD decryption TFM (AES-CCM and AES-GCM) */
+	struct shash_desc *hmacmd5; /* hmacmd5 hash function, for NTLMv2/CR1 hashes */
+	struct shash_desc *md5; /* md5 hash function, for CIFS/SMB1 signatures */
+	struct shash_desc *hmacsha256; /* hmac-sha256 hash function, for SMB2 signatures */
+	struct shash_desc *sha512; /* sha512 hash function, for SMB3.1.1 preauth hash */
+	struct shash_desc *aes_cmac; /* block-cipher based MAC function, for SMB3 signatures */
+
+	struct crypto_aead *enc; /* smb3 encryption AEAD TFM (AES-CCM and AES-GCM) */
+	struct crypto_aead *dec; /* smb3 decryption AEAD TFM (AES-CCM and AES-GCM) */
 };
 
 /* per smb session structure/fields */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 3bc94bcc7177..f5adcb8ea04d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -598,9 +598,8 @@ struct cifs_aio_ctx *cifs_aio_ctx_alloc(void);
 void cifs_aio_ctx_release(struct kref *refcount);
 int setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw);
 
-int cifs_alloc_hash(const char *name, struct crypto_shash **shash,
-		    struct sdesc **sdesc);
-void cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc);
+int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
+void cifs_free_hash(struct shash_desc **sdesc);
 
 extern void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
 				unsigned int *len, unsigned int *offset);
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 6803cb27eecc..cd29c296cec6 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -38,29 +38,28 @@ static int
 symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 {
 	int rc;
-	struct crypto_shash *md5 = NULL;
-	struct sdesc *sdescmd5 = NULL;
+	struct shash_desc *md5 = NULL;
 
-	rc = cifs_alloc_hash("md5", &md5, &sdescmd5);
+	rc = cifs_alloc_hash("md5", &md5);
 	if (rc)
 		goto symlink_hash_err;
 
-	rc = crypto_shash_init(&sdescmd5->shash);
+	rc = crypto_shash_init(md5);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init md5 shash\n", __func__);
 		goto symlink_hash_err;
 	}
-	rc = crypto_shash_update(&sdescmd5->shash, link_str, link_len);
+	rc = crypto_shash_update(md5, link_str, link_len);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with link_str\n", __func__);
 		goto symlink_hash_err;
 	}
-	rc = crypto_shash_final(&sdescmd5->shash, md5_hash);
+	rc = crypto_shash_final(md5, md5_hash);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
 symlink_hash_err:
-	cifs_free_hash(&md5, &sdescmd5);
+	cifs_free_hash(&md5);
 	return rc;
 }
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index c6679398fff9..535dbe6ff994 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1071,59 +1071,58 @@ setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw)
 /**
  * cifs_alloc_hash - allocate hash and hash context together
  * @name: The name of the crypto hash algo
- * @shash: Where to put the pointer to the hash algo
- * @sdesc: Where to put the pointer to the hash descriptor
+ * @sdesc: SHASH descriptor where to put the pointer to the hash TFM
  *
  * The caller has to make sure @sdesc is initialized to either NULL or
- * a valid context. Both can be freed via cifs_free_hash().
+ * a valid context. It can be freed via cifs_free_hash().
  */
 int
-cifs_alloc_hash(const char *name,
-		struct crypto_shash **shash, struct sdesc **sdesc)
+cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
 {
 	int rc = 0;
-	size_t size;
+	struct crypto_shash *alg = NULL;
 
-	if (*sdesc != NULL)
+	if (*sdesc)
 		return 0;
 
-	*shash = crypto_alloc_shash(name, 0, 0);
-	if (IS_ERR(*shash)) {
-		cifs_dbg(VFS, "Could not allocate crypto %s\n", name);
-		rc = PTR_ERR(*shash);
-		*shash = NULL;
+	alg = crypto_alloc_shash(name, 0, 0);
+	if (IS_ERR(alg)) {
+		cifs_dbg(VFS, "Could not allocate shash TFM '%s'\n", name);
+		rc = PTR_ERR(alg);
 		*sdesc = NULL;
 		return rc;
 	}
 
-	size = sizeof(struct shash_desc) + crypto_shash_descsize(*shash);
-	*sdesc = kmalloc(size, GFP_KERNEL);
+	*sdesc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(alg), GFP_KERNEL);
 	if (*sdesc == NULL) {
-		cifs_dbg(VFS, "no memory left to allocate crypto %s\n", name);
-		crypto_free_shash(*shash);
-		*shash = NULL;
+		cifs_dbg(VFS, "no memory left to allocate shash TFM '%s'\n", name);
+		crypto_free_shash(alg);
 		return -ENOMEM;
 	}
 
-	(*sdesc)->shash.tfm = *shash;
+	(*sdesc)->tfm = alg;
 	return 0;
 }
 
 /**
  * cifs_free_hash - free hash and hash context together
- * @shash: Where to find the pointer to the hash algo
- * @sdesc: Where to find the pointer to the hash descriptor
+ * @sdesc: Where to find the pointer to the hash TFM
  *
- * Freeing a NULL hash or context is safe.
+ * Freeing a NULL descriptor is safe.
  */
 void
-cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc)
+cifs_free_hash(struct shash_desc **sdesc)
 {
+	if (unlikely(!sdesc) || !*sdesc)
+		return;
+
+	if ((*sdesc)->tfm) {
+		crypto_free_shash((*sdesc)->tfm);
+		(*sdesc)->tfm = NULL;
+	}
+
 	kfree(*sdesc);
 	*sdesc = NULL;
-	if (*shash)
-		crypto_free_shash(*shash);
-	*shash = NULL;
 }
 
 /**
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d73e5672aac4..7db5c09ecceb 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -870,8 +870,8 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 			   struct kvec *iov, int nvec)
 {
 	int i, rc;
-	struct sdesc *d;
 	struct smb2_hdr *hdr;
+	struct shash_desc *sha512 = NULL;
 
 	hdr = (struct smb2_hdr *)iov[0].iov_base;
 	/* neg prot are always taken */
@@ -901,14 +901,14 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	if (rc)
 		return rc;
 
-	d = server->secmech.sdescsha512;
-	rc = crypto_shash_init(&d->shash);
+	sha512 = server->secmech.sha512;
+	rc = crypto_shash_init(sha512);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init sha512 shash\n", __func__);
 		return rc;
 	}
 
-	rc = crypto_shash_update(&d->shash, ses->preauth_sha_hash,
+	rc = crypto_shash_update(sha512, ses->preauth_sha_hash,
 				 SMB2_PREAUTH_HASH_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update sha512 shash\n", __func__);
@@ -916,8 +916,7 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	}
 
 	for (i = 0; i < nvec; i++) {
-		rc = crypto_shash_update(&d->shash,
-					 iov[i].iov_base, iov[i].iov_len);
+		rc = crypto_shash_update(sha512, iov[i].iov_base, iov[i].iov_len);
 		if (rc) {
 			cifs_dbg(VFS, "%s: Could not update sha512 shash\n",
 				 __func__);
@@ -925,7 +924,7 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		}
 	}
 
-	rc = crypto_shash_final(&d->shash, ses->preauth_sha_hash);
+	rc = crypto_shash_final(sha512, ses->preauth_sha_hash);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not finalize sha512 shash\n",
 			 __func__);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index d4e1a5d74dcd..dfcbcc0b86e4 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -32,19 +32,17 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 	struct cifs_secmech *p = &server->secmech;
 	int rc;
 
-	rc = cifs_alloc_hash("hmac(sha256)",
-			     &p->hmacsha256,
-			     &p->sdeschmacsha256);
+	rc = cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
 	if (rc)
 		goto err;
 
-	rc = cifs_alloc_hash("cmac(aes)", &p->cmacaes, &p->sdesccmacaes);
+	rc = cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
 	if (rc)
 		goto err;
 
 	return 0;
 err:
-	cifs_free_hash(&p->hmacsha256, &p->sdeschmacsha256);
+	cifs_free_hash(&p->hmacsha256);
 	return rc;
 }
 
@@ -54,25 +52,23 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 	struct cifs_secmech *p = &server->secmech;
 	int rc = 0;
 
-	rc = cifs_alloc_hash("hmac(sha256)",
-			     &p->hmacsha256,
-			     &p->sdeschmacsha256);
+	rc = cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
 	if (rc)
 		return rc;
 
-	rc = cifs_alloc_hash("cmac(aes)", &p->cmacaes, &p->sdesccmacaes);
+	rc = cifs_alloc_hash("cmac(aes)", &p->aes_cmac);
 	if (rc)
 		goto err;
 
-	rc = cifs_alloc_hash("sha512", &p->sha512, &p->sdescsha512);
+	rc = cifs_alloc_hash("sha512", &p->sha512);
 	if (rc)
 		goto err;
 
 	return 0;
 
 err:
-	cifs_free_hash(&p->cmacaes, &p->sdesccmacaes);
-	cifs_free_hash(&p->hmacsha256, &p->sdeschmacsha256);
+	cifs_free_hash(&p->aes_cmac);
+	cifs_free_hash(&p->hmacsha256);
 	return rc;
 }
 
@@ -220,8 +216,6 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct cifs_ses *ses;
 	struct shash_desc *shash;
-	struct crypto_shash *hash;
-	struct sdesc *sdesc = NULL;
 	struct smb_rqst drqst;
 
 	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
@@ -234,19 +228,17 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	if (allocate_crypto) {
-		rc = cifs_alloc_hash("hmac(sha256)", &hash, &sdesc);
+		rc = cifs_alloc_hash("hmac(sha256)", &shash);
 		if (rc) {
 			cifs_server_dbg(VFS,
 					"%s: sha256 alloc failed\n", __func__);
 			goto out;
 		}
-		shash = &sdesc->shash;
 	} else {
-		hash = server->secmech.hmacsha256;
-		shash = &server->secmech.sdeschmacsha256->shash;
+		shash = server->secmech.hmacsha256;
 	}
 
-	rc = crypto_shash_setkey(hash, ses->auth_key.response,
+	rc = crypto_shash_setkey(shash->tfm, ses->auth_key.response,
 			SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS,
@@ -288,7 +280,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 
 out:
 	if (allocate_crypto)
-		cifs_free_hash(&hash, &sdesc);
+		cifs_free_hash(&shash);
 	if (ses)
 		cifs_put_smb_ses(ses);
 	return rc;
@@ -315,42 +307,38 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_setkey(server->secmech.hmacsha256,
+	rc = crypto_shash_setkey(server->secmech.hmacsha256->tfm,
 		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set with session key\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
+	rc = crypto_shash_init(server->secmech.hmacsha256);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not init sign hmac\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
-				i, 4);
+	rc = crypto_shash_update(server->secmech.hmacsha256, i, 4);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with n\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
-				label.iov_base, label.iov_len);
+	rc = crypto_shash_update(server->secmech.hmacsha256, label.iov_base, label.iov_len);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with label\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
-				&zero, 1);
+	rc = crypto_shash_update(server->secmech.hmacsha256, &zero, 1);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with zero\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
-				context.iov_base, context.iov_len);
+	rc = crypto_shash_update(server->secmech.hmacsha256, context.iov_base, context.iov_len);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with context\n", __func__);
 		goto smb3signkey_ret;
@@ -358,19 +346,16 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
 		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)) {
-		rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
-				L256, 4);
+		rc = crypto_shash_update(server->secmech.hmacsha256, L256, 4);
 	} else {
-		rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
-				L128, 4);
+		rc = crypto_shash_update(server->secmech.hmacsha256, L128, 4);
 	}
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with L\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_final(&server->secmech.sdeschmacsha256->shash,
-				hashptr);
+	rc = crypto_shash_final(server->secmech.hmacsha256, hashptr);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not generate sha256 hash\n", __func__);
 		goto smb3signkey_ret;
@@ -551,8 +536,6 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct shash_desc *shash;
-	struct crypto_shash *hash;
-	struct sdesc *sdesc = NULL;
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
@@ -563,27 +546,24 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	}
 
 	if (allocate_crypto) {
-		rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
+		rc = cifs_alloc_hash("cmac(aes)", &shash);
 		if (rc)
 			return rc;
-
-		shash = &sdesc->shash;
 	} else {
-		hash = server->secmech.cmacaes;
-		shash = &server->secmech.sdesccmacaes->shash;
+		shash = server->secmech.aes_cmac;
 	}
 
 	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
-	rc = crypto_shash_setkey(hash, key, SMB2_CMACAES_SIZE);
+	rc = crypto_shash_setkey(shash->tfm, key, SMB2_CMACAES_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
 		goto out;
 	}
 
 	/*
-	 * we already allocate sdesccmacaes when we init smb3 signing key,
+	 * we already allocate aes_cmac when we init smb3 signing key,
 	 * so unlike smb2 case we do not have to check here if secmech are
 	 * initialized
 	 */
@@ -619,7 +599,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 
 out:
 	if (allocate_crypto)
-		cifs_free_hash(&hash, &sdesc);
+		cifs_free_hash(&shash);
 	return rc;
 }
 
-- 
2.35.3

