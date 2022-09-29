Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689BEC04A95
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 01:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiI2B5Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 21:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI2B5Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 21:57:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC578122077
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 18:57:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7E88A1F8B3;
        Thu, 29 Sep 2022 01:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664416632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+eK9gaFrbahT57ysW0ktIoet+Lnf/S7ftMX4yG9Kd38=;
        b=fw65wXwHOhwtxv11xg57sT71TcVZZ47RGFZf4viPn60QsnXdGumbntylZXfHmpRTH1BUSE
        W/BKmymHGnXQ1nwmC5OONp9LVEno19hsnEeCVoDtMOdMtzYa/Ovfk364PmsMEx2/P1XyW7
        ls68bpzeQvk+G19G+RkUbckUnIXLzdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664416632;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+eK9gaFrbahT57ysW0ktIoet+Lnf/S7ftMX4yG9Kd38=;
        b=lWbvlL3d51SUWfuOK38PiAkEXTYeTdwNUpUaH/jN70sDc69yWwfny9YxDwf7PGP7Vhtaet
        wh0lFk1K+PBhI/BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B7F79139B3;
        Thu, 29 Sep 2022 01:57:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Tsn7HXf7NGOIeQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 01:57:11 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v3 4/8] cifs: create sign/verify secmechs, don't leave keys in memory
Date:   Wed, 28 Sep 2022 22:56:33 -0300
Message-Id: <20220929015637.14400-5-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929015637.14400-1-ematsumiya@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch creates separate TFMs for signing and verifying requests.
This detaches the secmechs fields' names from any particular algorithm.

Since the TFMs are now required to know/have the key set beforehand,
we have the added benefit of not needing private keys laying around
in memory anymore.  This patch sets signing and encryption keys right
after they are generated, and zero the generated ones upon success.
If CONFIG_CIFS_DUMP_KEYS option is enabled, the keys are copied over to
their previous locations for debugging.

These changes also makes the smb2_calc_signature and smb3_calc_signature
functions exactly the same, so converge them into one
(smb2_calc_signature).  The only difference now is the output buffer
size (32 bytes for HMAC-SHA256 vs 16 bytes for AES-CMAC) where the
generated hash is stored, but only the first 16 bytes are actually
copied to the header signature, so the same 32-byte buffer can be used
for both without any problems.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c   |  35 +++--
 fs/cifs/cifsglob.h      |  25 +++-
 fs/cifs/smb1ops.c       |   6 +
 fs/cifs/smb2ops.c       |  53 +-------
 fs/cifs/smb2pdu.c       |  43 +++++-
 fs/cifs/smb2proto.h     |   5 +-
 fs/cifs/smb2transport.c | 283 +++++++++++++---------------------------
 7 files changed, 176 insertions(+), 274 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index ed25ac811f05..4ae58ab29458 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -95,32 +95,33 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
  * the sequence number before this function is called. Also, this function
  * should be called with the server->srv_mutex held.
  */
-static int cifs_calc_signature(struct smb_rqst *rqst,
-			struct TCP_Server_Info *server, char *signature)
+static int cifs_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
+			       char *signature, bool verify)
 {
+	struct shash_desc *shash = NULL;
 	int rc;
 
 	if (!rqst->rq_iov || !signature || !server)
 		return -EINVAL;
 
-	rc = cifs_alloc_hash("md5", &server->secmech.md5);
-	if (rc)
-		return -1;
+	if (verify)
+		shash = server->secmech.verify;
+	else
+		shash = server->secmech.sign;
 
-	rc = crypto_shash_init(server->secmech.md5);
+	rc = crypto_shash_init(shash);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
 		return rc;
 	}
 
-	rc = crypto_shash_update(server->secmech.md5,
-		server->session_key.response, server->session_key.len);
+	rc = crypto_shash_update(shash, server->session_key.response, server->session_key.len);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
-	return __cifs_calc_signature(rqst, server, signature, server->secmech.md5);
+	return __cifs_calc_signature(rqst, server, signature, shash);
 }
 
 /* must be called with server->srv_mutex held */
@@ -158,7 +159,7 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	*pexpected_response_sequence_number = ++server->sequence_number;
 	++server->sequence_number;
 
-	rc = cifs_calc_signature(rqst, server, smb_signature);
+	rc = cifs_calc_signature(rqst, server, smb_signature, false);
 	if (rc)
 		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
 	else
@@ -197,7 +198,7 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 {
 	unsigned int rc;
 	char server_response_sig[8];
-	char what_we_think_sig_should_be[20];
+	char sig[20];
 	struct smb_hdr *cifs_pdu = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
 
 	if (rqst->rq_iov[0].iov_len != 4 ||
@@ -234,16 +235,13 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
 	cifs_server_lock(server);
-	rc = cifs_calc_signature(rqst, server, what_we_think_sig_should_be);
+	rc = cifs_calc_signature(rqst, server, sig, true);
 	cifs_server_unlock(server);
 
 	if (rc)
 		return rc;
 
-/*	cifs_dump_mem("what we think it should be: ",
-		      what_we_think_sig_should_be, 16); */
-
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (memcmp(server_response_sig, sig, 8))
 		return -EACCES;
 	else
 		return 0;
@@ -705,9 +703,8 @@ calc_seckey(struct cifs_ses *ses)
 void
 cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 {
-	cifs_free_hash(&server->secmech.aes_cmac);
-	cifs_free_hash(&server->secmech.hmacsha256);
-	cifs_free_hash(&server->secmech.md5);
+	cifs_free_hash(&server->secmech.sign);
+	cifs_free_hash(&server->secmech.verify);
 
 	if (server->secmech.enc) {
 		crypto_free_aead(server->secmech.enc);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5da71d946012..30b3fadb4b06 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -153,14 +153,27 @@ struct session_key {
 	char *response;
 };
 
-/* crypto hashing related structure/fields, not specific to a sec mech */
+/**
+ * cifs_secmech - Crypto hashing related structure/fields, not specific to one mechanism
+ * @sign: SHASH descriptor to allocate a hashing TFM for signing requests
+ * @verify: SHASH descriptor to allocate a hashing TFM for verifying requests' signatures
+ * @enc: AEAD TFM for SMB3+ encryption
+ * @dec: AEAD TFM for SMB3+ decryption
+ *
+ * @sign and @verify are allocated per-server, and the negotiated connection dialect will dictate
+ * which algorithm to use:
+ * - MD5 for SMB1
+ * - HMAC-SHA256 for SMB2
+ * - AES-CMAC for SMB3
+ *
+ * @enc and @dec holds the encryption/decryption TFMs, where it'll be either AES-CCM or AES-GCM.
+ */
 struct cifs_secmech {
-	struct shash_desc *md5; /* md5 hash function, for CIFS/SMB1 signatures */
-	struct shash_desc *hmacsha256; /* hmac-sha256 hash function, for SMB2 signatures */
-	struct shash_desc *aes_cmac; /* block-cipher based MAC function, for SMB3 signatures */
+	struct shash_desc *sign;
+	struct shash_desc *verify;
 
-	struct crypto_aead *enc; /* smb3 encryption AEAD TFM (AES-CCM and AES-GCM) */
-	struct crypto_aead *dec; /* smb3 decryption AEAD TFM (AES-CCM and AES-GCM) */
+	struct crypto_aead *enc;
+	struct crypto_aead *dec;
 };
 
 /* per smb session structure/fields */
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index f36b2d2d40ca..28e0ff0bb35d 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -433,6 +433,12 @@ cifs_negotiate(const unsigned int xid,
 		if (rc == -EAGAIN)
 			rc = -EHOSTDOWN;
 	}
+
+	if (!rc) {
+		rc = cifs_alloc_hash("md5", &server->secmech.sign.shash);
+		if (!rc)
+			rc = cifs_alloc_hash("md5", &server->secmech.verify.shash);
+	}
 	return rc;
 }
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 34dea8aa854b..0aaad18e1ec8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4282,30 +4282,6 @@ init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
 	return sg;
 }
 
-static int
-smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
-{
-	struct cifs_ses *ses;
-	u8 *ses_enc_key;
-
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			if (ses->Suid == ses_id) {
-				spin_lock(&ses->ses_lock);
-				ses_enc_key = enc ? ses->smb3encryptionkey :
-					ses->smb3decryptionkey;
-				memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
-				spin_unlock(&ses->ses_lock);
-				spin_unlock(&cifs_tcp_ses_lock);
-				return 0;
-			}
-		}
-	}
-	spin_unlock(&cifs_tcp_ses_lock);
-
-	return -EAGAIN;
-}
 /*
  * Encrypt or decrypt @rqst message. @rqst[0] has the following format:
  * iov[0]   - transform header (associate data),
@@ -4323,7 +4299,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	int rc = 0;
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
-	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
 	char *iv;
 	unsigned int iv_len;
@@ -4331,13 +4306,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	struct crypto_aead *tfm;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 
-	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), enc, key);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not get %scryption key\n", __func__,
-			 enc ? "en" : "de");
-		return rc;
-	}
-
 	/* sanity check -- TFMs were allocated after negotiate protocol */
 	if (unlikely(!server->secmech.enc || !server->secmech.dec)) {
 		cifs_server_dbg(VFS, "%s: crypto TFMs are NULL\n", __func__);
@@ -4346,23 +4314,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 
 	tfm = enc ? server->secmech.enc : server->secmech.dec;
 
-	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
-		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
-	else
-		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
-
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
-		return rc;
-	}
-
-	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set authsize %d\n", __func__, rc);
-		return rc;
-	}
-
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		cifs_server_dbg(VFS, "%s: Failed to alloc aead request\n", __func__);
@@ -5470,7 +5421,7 @@ struct smb_version_operations smb30_operations = {
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb30signingkey,
-	.calc_signature = smb3_calc_signature,
+	.calc_signature = smb2_calc_signature,
 	.set_integrity  = smb3_set_integrity,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb3_set_oplock_level,
@@ -5584,7 +5535,7 @@ struct smb_version_operations smb311_operations = {
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb311signingkey,
-	.calc_signature = smb3_calc_signature,
+	.calc_signature = smb2_calc_signature,
 	.set_integrity  = smb3_set_integrity,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb3_set_oplock_level,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 48b25054354c..e5939c374c35 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -932,9 +932,15 @@ SMB2_negotiate(const unsigned int xid,
 		 * Allocate HMAC-SHA256 regardless of dialect requested, change to AES-CMAC later,
 		 * if SMB3+ is negotiated
 		 */
-		rc = cifs_alloc_hash("hmac(sha256)",&server->secmech.hmacsha256);
+		rc = cifs_alloc_hash("hmac(sha256)", &server->secmech.sign);
 		if (rc)
 			goto neg_exit;
+
+		rc = cifs_alloc_hash("hmac(sha256)", &server->secmech.verify);
+		if (rc) {
+			cifs_free_hash(&server->secmech.sign);
+			goto neg_exit;
+		}
 	}
 
 	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
@@ -1084,10 +1090,17 @@ SMB2_negotiate(const unsigned int xid,
 
 	if (server->sign && server->dialect >= SMB30_PROT_ID) {
 		/* free HMAC-SHA256 allocated earlier for negprot */
-		cifs_free_hash(&server->secmech.hmacsha256);
-		rc = cifs_alloc_hash("cmac(aes)", &server->secmech.aes_cmac);
+		cifs_free_hash(&server->secmech.sign);
+		cifs_free_hash(&server->secmech.verify);
+		rc = cifs_alloc_hash("cmac(aes)", &server->secmech.sign);
 		if (rc)
 			goto neg_exit;
+
+		rc = cifs_alloc_hash("cmac(aes)", &server->secmech.verify);
+		if (rc) {
+			cifs_free_hash(&server->secmech.sign);
+			goto neg_exit;
+		}
 	}
 
 	if (blob_length) {
@@ -1660,8 +1673,26 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 	}
 
 	rc = SMB2_sess_establish_session(sess_data);
-#ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
+	if (rc)
+		goto out;
+
 	if (ses->server->dialect < SMB30_PROT_ID) {
+		rc = crypto_shash_setkey(server->secmech.sign->tfm,
+					 ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		if (rc) {
+			cifs_dbg(VFS, "%s: Failed to set HMAC-SHA256 signing key, rc=%d\n",
+				 __func__, rc);
+			goto out;
+		}
+
+		rc = crypto_shash_setkey(server->secmech.verify->tfm,
+					 ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		if (rc) {
+			cifs_dbg(VFS, "%s: Failed to set HMAC-SHA256 verify key, rc=%d\n",
+				 __func__, rc);
+			goto out;
+		}
+#ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
 		cifs_dbg(VFS, "%s: dumping generated SMB2 session keys\n", __func__);
 		/*
 		 * The session id is opaque in terms of endianness, so we can't
@@ -1673,8 +1704,10 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 			 SMB2_NTLMV2_SESSKEY_SIZE, ses->auth_key.response);
 		cifs_dbg(VFS, "Signing Key   %*ph\n",
 			 SMB3_SIGN_KEY_SIZE, ses->auth_key.response);
+#else /* CONFIG_CIFS_DEBUG_DUMP_KEYS */
+		memzero_explicit(ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+#endif /* !CONFIG_CIFS_DEBUG_DUMP_KEYS */
 	}
-#endif
 out:
 	kfree(ntlmssp_blob);
 	SMB2_sess_free_buffer(sess_data);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index a975144c63bf..33af35b6e586 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -43,10 +43,7 @@ extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 						__u64 ses_id, __u32  tid);
 extern int smb2_calc_signature(struct smb_rqst *rqst,
 				struct TCP_Server_Info *server,
-				bool allocate_crypto);
-extern int smb3_calc_signature(struct smb_rqst *rqst,
-				struct TCP_Server_Info *server,
-				bool allocate_crypto);
+				bool verify);
 extern void smb2_echo_request(struct work_struct *work);
 extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
 extern bool smb2_is_valid_oplock_break(char *buffer,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 2dca2c255239..cf319fc25161 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -26,63 +26,61 @@
 #include "smb2status.h"
 #include "smb2glob.h"
 
-static
-int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
+static int
+smb3_setup_keys(struct TCP_Server_Info *server, u8 *sign_key, u8 *enc_key, u8 *dec_key)
 {
-	struct cifs_chan *chan;
-	struct cifs_ses *ses = NULL;
-	struct TCP_Server_Info *it = NULL;
-	int i;
+	unsigned int crypt_keylen = 0;
 	int rc = 0;
 
-	spin_lock(&cifs_tcp_ses_lock);
+	if (!(server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) || !enc_key || !dec_key)
+		goto setup_sign;
 
-	list_for_each_entry(it, &cifs_tcp_ses_list, tcp_ses_list) {
-		list_for_each_entry(ses, &it->smb_ses_list, smb_ses_list) {
-			if (ses->Suid == ses_id)
-				goto found;
-		}
+	if (server->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	    server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+		crypt_keylen = SMB3_GCM256_CRYPTKEY_SIZE;
+	else
+		crypt_keylen = SMB3_GCM128_CRYPTKEY_SIZE;
+
+	rc = crypto_aead_setkey(server->secmech.enc, enc_key, crypt_keylen);
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Failed to set AEAD encryption key, rc=%d\n",
+				__func__, rc);
+		return rc;
 	}
-	cifs_server_dbg(VFS, "%s: Could not find session 0x%llx\n",
-			__func__, ses_id);
-	rc = -ENOENT;
-	goto out;
 
-found:
-	spin_lock(&ses->chan_lock);
-	if (cifs_chan_needs_reconnect(ses, server) &&
-	    !CIFS_ALL_CHANS_NEED_RECONNECT(ses)) {
-		/*
-		 * If we are in the process of binding a new channel
-		 * to an existing session, use the master connection
-		 * session key
-		 */
-		memcpy(key, ses->smb3signingkey, SMB3_SIGN_KEY_SIZE);
-		spin_unlock(&ses->chan_lock);
-		goto out;
+	rc = crypto_aead_setauthsize(server->secmech.enc, SMB2_SIGNATURE_SIZE);
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Failed to set AEAD encryption authsize, rc=%d\n",
+				__func__, rc);
+		return rc;
 	}
 
-	/*
-	 * Otherwise, use the channel key.
-	 */
+	rc = crypto_aead_setkey(server->secmech.dec, dec_key, crypt_keylen);
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Failed to set AEAD decryption key, rc=%d\n",
+				__func__, rc);
+		return rc;
+	}
 
-	for (i = 0; i < ses->chan_count; i++) {
-		chan = ses->chans + i;
-		if (chan->server == server) {
-			memcpy(key, chan->signkey, SMB3_SIGN_KEY_SIZE);
-			spin_unlock(&ses->chan_lock);
-			goto out;
-		}
+	rc = crypto_aead_setauthsize(server->secmech.dec, SMB2_SIGNATURE_SIZE);
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Failed to set AEAD decryption authsize, rc=%d\n",
+				__func__, rc);
+		return rc;
+	}
+setup_sign:
+	rc = crypto_shash_setkey(server->secmech.sign->tfm, sign_key, SMB3_SIGN_KEY_SIZE);
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Failed to set AES-CMAC signing key, rc=%d\n",
+				__func__, rc);
+		return rc;
 	}
-	spin_unlock(&ses->chan_lock);
 
-	cifs_dbg(VFS,
-		 "%s: Could not find channel signing key for session 0x%llx\n",
-		 __func__, ses_id);
-	rc = -ENOENT;
+	rc = crypto_shash_setkey(server->secmech.verify->tfm, sign_key, SMB3_SIGN_KEY_SIZE);
+	if (rc)
+		cifs_server_dbg(VFS, "%s: Failed to set AES-CMAC verify key, rc=%d\n",
+				__func__, rc);
 
-out:
-	spin_unlock(&cifs_tcp_ses_lock);
 	return rc;
 }
 
@@ -159,51 +157,29 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 }
 
 int
-smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
-			bool allocate_crypto)
+smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server, bool verify)
 {
 	int rc;
-	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
-	unsigned char *sigptr = smb2_signature;
+	unsigned char sig[SMB2_HMACSHA256_SIZE]; /* big enough for HMAC-SHA256 and AES-CMAC */
+	unsigned char *sigptr = sig;
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct cifs_ses *ses;
 	struct shash_desc *shash = NULL;
 	struct smb_rqst drqst;
 
-	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
-	if (unlikely(!ses)) {
-		cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
-		return -ENOENT;
-	}
-
-	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
+	memset(sig, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
-	if (allocate_crypto) {
-		rc = cifs_alloc_hash("hmac(sha256)", &shash);
-		if (rc) {
-			cifs_server_dbg(VFS,
-					"%s: sha256 alloc failed\n", __func__);
-			goto out;
-		}
-	} else {
-		shash = server->secmech.hmacsha256;
-	}
-
-	rc = crypto_shash_setkey(shash->tfm, ses->auth_key.response,
-			SMB2_NTLMV2_SESSKEY_SIZE);
-	if (rc) {
-		cifs_server_dbg(VFS,
-				"%s: Could not update with response\n",
-				__func__);
-		goto out;
-	}
+	if (verify)
+		shash = server->secmech.verify;
+	else
+		shash = server->secmech.sign;
 
 	rc = crypto_shash_init(shash);
 	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not init sha256", __func__);
-		goto out;
+		cifs_server_dbg(VFS, "%s: Could not init %s\n", __func__,
+				crypto_shash_alg_name(shash->tfm));
+		return rc;
 	}
 
 	/*
@@ -215,13 +191,11 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	 */
 	drqst = *rqst;
 	if (drqst.rq_nvec >= 2 && iov[0].iov_len == 4) {
-		rc = crypto_shash_update(shash, iov[0].iov_base,
-					 iov[0].iov_len);
+		rc = crypto_shash_update(shash, iov[0].iov_base, iov[0].iov_len);
 		if (rc) {
-			cifs_server_dbg(VFS,
-					"%s: Could not update with payload\n",
-					__func__);
-			goto out;
+			cifs_server_dbg(VFS, "%s: Could not update with payload, rc=%d\n",
+					__func__, rc);
+			return rc;
 		}
 		drqst.rq_iov++;
 		drqst.rq_nvec--;
@@ -231,11 +205,6 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	if (!rc)
 		memcpy(shdr->Signature, sigptr, SMB2_SIGNATURE_SIZE);
 
-out:
-	if (allocate_crypto)
-		cifs_free_hash(&shash);
-	if (ses)
-		cifs_put_smb_ses(ses);
 	return rc;
 }
 
@@ -342,6 +311,9 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	int rc;
 	bool is_binding = false;
 	int chan_index = 0;
+	u8 sign_key[SMB3_SIGN_KEY_SIZE] = { 0 };
+	u8 enc_key[SMB3_ENC_DEC_KEY_SIZE] = { 0 };
+	u8 dec_key[SMB3_ENC_DEC_KEY_SIZE] = { 0 };
 
 	spin_lock(&ses->chan_lock);
 	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
@@ -362,47 +334,54 @@ generate_smb3signingkey(struct cifs_ses *ses,
 	if (is_binding) {
 		rc = generate_key(ses, ptriplet->signing.label,
 				  ptriplet->signing.context,
-				  ses->chans[chan_index].signkey,
-				  SMB3_SIGN_KEY_SIZE);
+				  sign_key, SMB3_SIGN_KEY_SIZE);
 		if (rc)
-			return rc;
+			goto out_zero_keys;
+
+		rc = smb3_setup_keys(ses->chans[chan_index].server, sign_key, NULL, NULL);
+		if (rc)
+			goto out_zero_keys;
 	} else {
 		rc = generate_key(ses, ptriplet->signing.label,
 				  ptriplet->signing.context,
-				  ses->smb3signingkey,
-				  SMB3_SIGN_KEY_SIZE);
+				  sign_key, SMB3_SIGN_KEY_SIZE);
 		if (rc)
-			return rc;
-
-		/* safe to access primary channel, since it will never go away */
-		spin_lock(&ses->chan_lock);
-		memcpy(ses->chans[0].signkey, ses->smb3signingkey,
-		       SMB3_SIGN_KEY_SIZE);
-		spin_unlock(&ses->chan_lock);
+			goto out_zero_keys;
 
 		rc = generate_key(ses, ptriplet->encryption.label,
 				  ptriplet->encryption.context,
-				  ses->smb3encryptionkey,
-				  SMB3_ENC_DEC_KEY_SIZE);
+				  enc_key, SMB3_ENC_DEC_KEY_SIZE);
 		if (rc)
-			return rc;
+			goto out_zero_keys;
 
 		rc = generate_key(ses, ptriplet->decryption.label,
 				  ptriplet->decryption.context,
-				  ses->smb3decryptionkey,
-				  SMB3_ENC_DEC_KEY_SIZE);
+				  dec_key, SMB3_ENC_DEC_KEY_SIZE);
 		if (rc)
-			return rc;
+			goto out_zero_keys;
 
 		rc = smb3_crypto_aead_allocate(server);
 		if (rc)
-			return rc;
-	}
-
-	if (rc)
-		return rc;
+			goto out_zero_keys;
 
+		rc = smb3_setup_keys(ses->server, sign_key, enc_key, dec_key);
+		if (rc)
+			goto out_zero_keys;
+	}
+out_zero_keys:
 #ifdef CONFIG_CIFS_DEBUG_DUMP_KEYS
+	/* only leave keys in memory if debugging */
+	memcpy(ses->smb3encryptionkey, enc_key, SMB3_ENC_DEC_KEY_SIZE);
+	memcpy(ses->smb3decryptionkey, dec_key, SMB3_ENC_DEC_KEY_SIZE);
+	spin_lock(&ses->chan_lock);
+	if (is_binding)
+		memcpy(ses->chans[chan_index].signkey, sign_key, SMB3_SIGN_KEY_SIZE);
+	else
+		/* safe to access primary channel, since it will never go away */
+		memcpy(ses->chans[0].signkey, sign_key, SMB3_SIGN_KEY_SIZE);
+	spin_unlock(&ses->chan_lock);
+	memcpy(ses->smb3signingkey, sign_key, SMB3_SIGN_KEY_SIZE);
+
 	cifs_dbg(VFS, "%s: dumping generated AES session keys\n", __func__);
 	/*
 	 * The session id is opaque in terms of endianness, so we can't
@@ -428,6 +407,9 @@ generate_smb3signingkey(struct cifs_ses *ses,
 				SMB3_GCM128_CRYPTKEY_SIZE, ses->smb3decryptionkey);
 	}
 #endif
+	memzero_explicit(sign_key, SMB3_SIGN_KEY_SIZE);
+	memzero_explicit(enc_key, SMB3_ENC_DEC_KEY_SIZE);
+	memzero_explicit(dec_key, SMB3_ENC_DEC_KEY_SIZE);
 	return rc;
 }
 
@@ -489,83 +471,6 @@ generate_smb311signingkey(struct cifs_ses *ses,
 	return generate_smb3signingkey(ses, server, &triplet);
 }
 
-int
-smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
-			bool allocate_crypto)
-{
-	int rc;
-	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
-	unsigned char *sigptr = smb3_signature;
-	struct kvec *iov = rqst->rq_iov;
-	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
-	struct shash_desc *shash = NULL;
-	struct smb_rqst drqst;
-	u8 key[SMB3_SIGN_KEY_SIZE];
-
-	rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
-	if (unlikely(rc)) {
-		cifs_server_dbg(VFS, "%s: Could not get signing key\n", __func__);
-		return rc;
-	}
-
-	if (allocate_crypto) {
-		rc = cifs_alloc_hash("cmac(aes)", &shash);
-		if (rc)
-			return rc;
-	} else {
-		shash = server->secmech.aes_cmac;
-	}
-
-	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
-	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
-
-	rc = crypto_shash_setkey(shash->tfm, key, SMB2_CMACAES_SIZE);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
-		goto out;
-	}
-
-	/*
-	 * we already allocate aes_cmac when we init smb3 signing key,
-	 * so unlike smb2 case we do not have to check here if secmech are
-	 * initialized
-	 */
-	rc = crypto_shash_init(shash);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not init cmac aes\n", __func__);
-		goto out;
-	}
-
-	/*
-	 * For SMB2+, __cifs_calc_signature() expects to sign only the actual
-	 * data, that is, iov[0] should not contain a rfc1002 length.
-	 *
-	 * Sign the rfc1002 length prior to passing the data (iov[1-N]) down to
-	 * __cifs_calc_signature().
-	 */
-	drqst = *rqst;
-	if (drqst.rq_nvec >= 2 && iov[0].iov_len == 4) {
-		rc = crypto_shash_update(shash, iov[0].iov_base,
-					 iov[0].iov_len);
-		if (rc) {
-			cifs_server_dbg(VFS, "%s: Could not update with payload\n",
-				 __func__);
-			goto out;
-		}
-		drqst.rq_iov++;
-		drqst.rq_nvec--;
-	}
-
-	rc = __cifs_calc_signature(&drqst, server, sigptr, shash);
-	if (!rc)
-		memcpy(shdr->Signature, sigptr, SMB2_SIGNATURE_SIZE);
-
-out:
-	if (allocate_crypto)
-		cifs_free_hash(&shash);
-	return rc;
-}
-
 /* must be called with server->srv_mutex held */
 static int
 smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
-- 
2.35.3

