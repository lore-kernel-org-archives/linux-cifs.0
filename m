Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5814EC32771
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 01:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiI2B5W (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 21:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI2B5U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 21:57:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADBA74B8A
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 18:57:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B88EF21C9D;
        Thu, 29 Sep 2022 01:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664416636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWMJO9ORUZOdWWz+swf+noR54h06GAmjBgjkO+LChN4=;
        b=wzLuL06u0ZKXG6wMFoMipD9iOPn+J+8mwFmueMyy5sILrKMxLBzXttsgEbe5M5tmdXK4Ht
        SSJY4jmrTqsGu74D9HrYKWAJf/hF7Ow/w0ezEfSMcznBGvOcZva8mGVUCGqQpWmsizWEWe
        pOfEMzXpgwg+cEIcbsVQjuVgHpUJQX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664416636;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWMJO9ORUZOdWWz+swf+noR54h06GAmjBgjkO+LChN4=;
        b=eCsCfZSyqB4D8OwRdj52zJQ0cpvLGgOXlSf4lmBLsm7qVcd43Rd3hPsayI416AQJGRvOy0
        HIIXOFLQQNXtrbBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AA765139B3;
        Thu, 29 Sep 2022 01:57:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id n2e8F3v7NGOQeQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 01:57:15 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v3 5/8] cifs: introduce AES-GMAC signing support for SMB 3.1.1
Date:   Wed, 28 Sep 2022 22:56:34 -0300
Message-Id: <20220929015637.14400-6-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929015637.14400-1-ematsumiya@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Implement support for AES-GMAC message signing, as specified in
MS-SMB2 3.1.4.1 "Signing An Outgoing Message".

The core function is smb311_calc_signature(), which will be used as the
->calc_signature op when SIGNING_ALG_AES_GMAC has been negotiated with
the server.

If "enable_negotiate_signing" is false (default) or if
SIGNING_ALG_AES_GMAC was not negotiated, use AES-CMAC.

Changes:
  - convert cifs_secmech sign/verify to unions, where .aead is for AES-GMAC
    TFM and .shash for all the others signing algorithms
  - init_sg(): rename to smb3_init_sg(), make it non-static, remove skip
    variable.  This makes it fit for both crypt_message() and
    smb311_calc_signature()
  - crypt_message(): advance the 20 bytes of rqst[0].rq_iov[0] that are
    not part of the encrypted blob before calling smb3_init_sg(). Rewind
    it back right after the call. (this was done in init_sg() via the
    skip variable)

Other smaller modifications:
  - smb2_setup_request(): check if the request has a transform header as we
    must not sign an encrypted message (MS-SMB2 3.2.4.1.1)
  - smb2_verify_signature():
    * check if MessageId is 0xFFFFFFFFFFFFFFFF or if status is STATUS_PENDING
      (MS-SMB2 3.2.5.1.3)
    * remove extra call to zero the header signature as this is already
      done by all ->calc_signature implementations
    * remove useless call to check for "BSRSPYL" signature (SMB1 only),
      and from smb2_sign_rqst() as well

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c   |  23 ++-
 fs/cifs/cifsglob.h      |  40 +++--
 fs/cifs/smb2ops.c       |  36 ++---
 fs/cifs/smb2pdu.c       |  82 +++++-----
 fs/cifs/smb2proto.h     |   9 +-
 fs/cifs/smb2transport.c | 331 ++++++++++++++++++++++++++++++----------
 6 files changed, 354 insertions(+), 167 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 4ae58ab29458..3a78efc45a23 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -23,6 +23,7 @@
 #include <linux/fips.h>
 #include "../smbfs_common/arc4.h"
 #include <crypto/aead.h>
+#include "smb2proto.h"
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
 			struct TCP_Server_Info *server, char *signature,
@@ -105,9 +106,9 @@ static int cifs_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *se
 		return -EINVAL;
 
 	if (verify)
-		shash = server->secmech.verify;
+		shash = server->secmech.verify.shash;
 	else
-		shash = server->secmech.sign;
+		shash = server->secmech.sign.shash;
 
 	rc = crypto_shash_init(shash);
 	if (rc) {
@@ -703,16 +704,14 @@ calc_seckey(struct cifs_ses *ses)
 void
 cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 {
-	cifs_free_hash(&server->secmech.sign);
-	cifs_free_hash(&server->secmech.verify);
-
-	if (server->secmech.enc) {
-		crypto_free_aead(server->secmech.enc);
-		server->secmech.enc = NULL;
+	if (server->signing_algorithm == SIGNING_ALG_AES_GMAC) {
+		smb3_crypto_aead_free(&server->secmech.sign.aead);
+		smb3_crypto_aead_free(&server->secmech.verify.aead);
+	} else {
+		cifs_free_hash(&server->secmech.sign.shash);
+		cifs_free_hash(&server->secmech.verify.shash);
 	}
 
-	if (server->secmech.dec) {
-		crypto_free_aead(server->secmech.dec);
-		server->secmech.dec = NULL;
-	}
+	smb3_crypto_aead_free(&server->secmech.enc);
+	smb3_crypto_aead_free(&server->secmech.dec);
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 30b3fadb4b06..81a8eff06467 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -153,24 +153,48 @@ struct session_key {
 	char *response;
 };
 
+struct smb_rqst;
+struct TCP_Server_Info;
 /**
  * cifs_secmech - Crypto hashing related structure/fields, not specific to one mechanism
- * @sign: SHASH descriptor to allocate a hashing TFM for signing requests
- * @verify: SHASH descriptor to allocate a hashing TFM for verifying requests' signatures
+ * @sign.shash: SHASH descriptor for signing TFM
+ * @sign.aead: AEAD TFM for signing
+ * @sign_wait: Completion struct for signing operations
+ * @verify.shash: SHASH descriptor for verifying TFM
+ * @verify.aead: AEAD TFM for verifying
+ * @verify_wait: Completion struct for verifying operations
+ * @calc_signature: Signature calculation function to be used.
  * @enc: AEAD TFM for SMB3+ encryption
  * @dec: AEAD TFM for SMB3+ decryption
  *
- * @sign and @verify are allocated per-server, and the negotiated connection dialect will dictate
- * which algorithm to use:
+ * @sign and @verify TFMs are allocated per-server, and the negotiated dialect will dictate which
+ * algorithm to use:
  * - MD5 for SMB1
  * - HMAC-SHA256 for SMB2
  * - AES-CMAC for SMB3
+ * - AES-GMAC for SMB3.1.1
+ *
+ * The completion structs @sign_wait and @verify_wait are required so that we can serialize access
+ * to the AEAD TFMs, since they're asynchronous by design.  Using a stack-allocated structure could
+ * cause concurrent access to the TFMs to overwrite the completion status of a previous operation.
  *
- * @enc and @dec holds the encryption/decryption TFMs, where it'll be either AES-CCM or AES-GCM.
+ * @enc and @dec holds the encryption/decryption TFMs, also allocated per server, where each will
+ * be either AES-CCM or AES-GCM.
  */
 struct cifs_secmech {
-	struct shash_desc *sign;
-	struct shash_desc *verify;
+	union {
+		struct shash_desc *shash;
+		struct crypto_aead *aead;
+	} sign;
+	struct crypto_wait sign_wait;
+
+	union {
+		struct shash_desc *shash;
+		struct crypto_aead *aead;
+	} verify;
+	struct crypto_wait verify_wait;
+
+	int (*calc_signature)(struct smb_rqst *rqst, struct TCP_Server_Info *server, bool verify);
 
 	struct crypto_aead *enc;
 	struct crypto_aead *dec;
@@ -445,8 +469,6 @@ struct smb_version_operations {
 	void (*new_lease_key)(struct cifs_fid *);
 	int (*generate_signingkey)(struct cifs_ses *ses,
 				   struct TCP_Server_Info *server);
-	int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *,
-				bool allocate_crypto);
 	int (*set_integrity)(const unsigned int, struct cifs_tcon *tcon,
 			     struct cifsFileInfo *src_file);
 	int (*enum_snapshots)(const unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0aaad18e1ec8..22b40d181bba 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4234,21 +4234,14 @@ static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *buf,
 	sg_set_page(sg, addr, buflen, offset_in_page(buf));
 }
 
-/* Assumes the first rqst has a transform header as the first iov.
- * I.e.
- * rqst[0].rq_iov[0]  is transform header
- * rqst[0].rq_iov[1+] data to be encrypted/decrypted
- * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
- */
-static struct scatterlist *
-init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
+struct scatterlist *
+smb3_init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
 {
 	unsigned int sg_len;
 	struct scatterlist *sg;
 	unsigned int i;
 	unsigned int j;
 	unsigned int idx = 0;
-	int skip;
 
 	sg_len = 1;
 	for (i = 0; i < num_rqst; i++)
@@ -4261,15 +4254,10 @@ init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
 	sg_init_table(sg, sg_len);
 	for (i = 0; i < num_rqst; i++) {
 		for (j = 0; j < rqst[i].rq_nvec; j++) {
-			/*
-			 * The first rqst has a transform header where the
-			 * first 20 bytes are not part of the encrypted blob
-			 */
-			skip = (i == 0) && (j == 0) ? 20 : 0;
 			smb2_sg_set_buf(&sg[idx++],
-					rqst[i].rq_iov[j].iov_base + skip,
-					rqst[i].rq_iov[j].iov_len - skip);
-			}
+					rqst[i].rq_iov[j].iov_base,
+					rqst[i].rq_iov[j].iov_len);
+		}
 
 		for (j = 0; j < rqst[i].rq_npages; j++) {
 			unsigned int len, offset;
@@ -4325,7 +4313,15 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		crypt_len += SMB2_SIGNATURE_SIZE;
 	}
 
-	sg = init_sg(num_rqst, rqst, sign);
+	/* Skip the first 20 bytes of the first iov of the first request as they're not part of the
+	 * encrypted blob */
+	rqst[0].rq_iov[0].iov_base += 20;
+	rqst[0].rq_iov[0].iov_len -= 20;
+	sg = smb3_init_sg(num_rqst, rqst, sign);
+	/* Rewind those 20 bytes before going any further */
+	rqst[0].rq_iov[0].iov_base -= 20;
+	rqst[0].rq_iov[0].iov_len += 20;
+
 	if (!sg) {
 		cifs_server_dbg(VFS, "%s: Failed to init sg\n", __func__);
 		rc = -ENOMEM;
@@ -5213,7 +5209,6 @@ struct smb_version_operations smb20_operations = {
 	.get_lease_key = smb2_get_lease_key,
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
-	.calc_signature = smb2_calc_signature,
 	.is_read_op = smb2_is_read_op,
 	.set_oplock_level = smb2_set_oplock_level,
 	.create_lease_buf = smb2_create_lease_buf,
@@ -5314,7 +5309,6 @@ struct smb_version_operations smb21_operations = {
 	.get_lease_key = smb2_get_lease_key,
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
-	.calc_signature = smb2_calc_signature,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb21_set_oplock_level,
 	.create_lease_buf = smb2_create_lease_buf,
@@ -5421,7 +5415,6 @@ struct smb_version_operations smb30_operations = {
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb30signingkey,
-	.calc_signature = smb2_calc_signature,
 	.set_integrity  = smb3_set_integrity,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb3_set_oplock_level,
@@ -5535,7 +5528,6 @@ struct smb_version_operations smb311_operations = {
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb311signingkey,
-	.calc_signature = smb2_calc_signature,
 	.set_integrity  = smb3_set_integrity,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb3_set_oplock_level,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e5939c374c35..2c2bf28382bc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -460,7 +460,7 @@ static unsigned int
 build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
 {
 	unsigned int ctxt_len = sizeof(struct smb2_signing_capabilities);
-	unsigned short num_algs = 1; /* number of signing algorithms sent */
+	unsigned short num_algs = 2; /* number of signing algorithms sent */
 
 	pneg_ctxt->ContextType = SMB2_SIGNING_CAPABILITIES;
 	/*
@@ -471,12 +471,18 @@ build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
 				sizeof(struct smb2_neg_context) +
 				(num_algs * 2 /* sizeof u16 */), 8) * 8);
 	pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(num_algs);
-	pneg_ctxt->SigningAlgorithms[0] = cpu_to_le16(SIGNING_ALG_AES_CMAC);
+
+	/*
+	 * Set AES-GMAC as preferred, but will fall back to AES-CMAC if server doesn't support it.
+	 * MS-SMB2 2.2.3.1.7
+	 */
+	pneg_ctxt->SigningAlgorithms[0] = SIGNING_ALG_AES_GMAC_LE;
+	pneg_ctxt->SigningAlgorithms[1] = SIGNING_ALG_AES_CMAC_LE;
+	/* SMB 3.1.1 doesn't accept HMAC-SHA256, so no need to send it */
 
 	ctxt_len += 2 /* sizeof le16 */ * num_algs;
 	ctxt_len = DIV_ROUND_UP(ctxt_len, 8) * 8;
 	return ctxt_len;
-	/* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
 }
 
 static void
@@ -927,22 +933,6 @@ SMB2_negotiate(const unsigned int xid,
 	else
 		req->SecurityMode = 0;
 
-	if (req->SecurityMode) {
-		/*
-		 * Allocate HMAC-SHA256 regardless of dialect requested, change to AES-CMAC later,
-		 * if SMB3+ is negotiated
-		 */
-		rc = cifs_alloc_hash("hmac(sha256)", &server->secmech.sign);
-		if (rc)
-			goto neg_exit;
-
-		rc = cifs_alloc_hash("hmac(sha256)", &server->secmech.verify);
-		if (rc) {
-			cifs_free_hash(&server->secmech.sign);
-			goto neg_exit;
-		}
-	}
-
 	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
 	if (ses->chan_max > 1)
 		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
@@ -1087,22 +1077,6 @@ SMB2_negotiate(const unsigned int xid,
 	rc = cifs_enable_signing(server, ses->sign);
 	if (rc)
 		goto neg_exit;
-
-	if (server->sign && server->dialect >= SMB30_PROT_ID) {
-		/* free HMAC-SHA256 allocated earlier for negprot */
-		cifs_free_hash(&server->secmech.sign);
-		cifs_free_hash(&server->secmech.verify);
-		rc = cifs_alloc_hash("cmac(aes)", &server->secmech.sign);
-		if (rc)
-			goto neg_exit;
-
-		rc = cifs_alloc_hash("cmac(aes)", &server->secmech.verify);
-		if (rc) {
-			cifs_free_hash(&server->secmech.sign);
-			goto neg_exit;
-		}
-	}
-
 	if (blob_length) {
 		rc = decode_negTokenInit(security_blob, blob_length, server);
 		if (rc == 1)
@@ -1112,12 +1086,35 @@ SMB2_negotiate(const unsigned int xid,
 	}
 
 	if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
+		server->signing_algorithm = SIGNING_ALG_AES_CMAC;
+		server->signing_negotiated = false;
+
 		if (rsp->NegotiateContextCount)
 			rc = smb311_decode_neg_context(rsp, server,
 						       rsp_iov.iov_len);
 		else
 			cifs_server_dbg(VFS, "Missing expected negotiate contexts\n");
+
+		/*
+		 * Some servers will not send a SMB2_SIGNING_CAPABILITIES context response (*),
+		 * so use AES-CMAC signing algorithm as it is expected to be accepted.
+		 * See MS-SMB2 note <125> Section 3.2.4.2.2.2
+		 */
+		if (!server->signing_negotiated)
+			cifs_dbg(VFS, "signing capabilities were not negotiated, using "
+				 "AES-CMAC for message signing\n");
+	} else if (server->dialect >= SMB30_PROT_ID) {
+		server->signing_algorithm = SIGNING_ALG_AES_CMAC;
+	} else if (server->dialect >= SMB20_PROT_ID) {
+		server->signing_algorithm = SIGNING_ALG_HMAC_SHA256;
 	}
+
+	rc = smb2_init_secmechs(server);
+	if (rc) {
+		cifs_dbg(VFS, "Failed to initialize secmechs, rc=%d\n", rc);
+		goto neg_exit;
+	}
+
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
@@ -1677,18 +1674,13 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 		goto out;
 
 	if (ses->server->dialect < SMB30_PROT_ID) {
-		rc = crypto_shash_setkey(server->secmech.sign->tfm,
-					 ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
-		if (rc) {
-			cifs_dbg(VFS, "%s: Failed to set HMAC-SHA256 signing key, rc=%d\n",
-				 __func__, rc);
-			goto out;
-		}
-
-		rc = crypto_shash_setkey(server->secmech.verify->tfm,
+		rc = crypto_shash_setkey(server->secmech.sign.shash->tfm,
 					 ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+		if (!rc)
+			rc = crypto_shash_setkey(server->secmech.verify.shash->tfm,
+						 ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 		if (rc) {
-			cifs_dbg(VFS, "%s: Failed to set HMAC-SHA256 verify key, rc=%d\n",
+			cifs_dbg(VFS, "%s: Failed to set HMAC-SHA256 signing keys, rc=%d\n",
 				 __func__, rc);
 			goto out;
 		}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 33af35b6e586..e4db59e6cee6 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -14,6 +14,7 @@
 
 struct statfs;
 struct smb_rqst;
+struct crypto_aead;
 
 /*
  *****************************************************************
@@ -37,6 +38,7 @@ extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
 					      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
+extern int smb2_init_secmechs(struct TCP_Server_Info *server);
 extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
 					   __u64 ses_id);
 extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
@@ -44,6 +46,10 @@ extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 extern int smb2_calc_signature(struct smb_rqst *rqst,
 				struct TCP_Server_Info *server,
 				bool verify);
+extern int smb311_calc_signature(struct smb_rqst *rqst,
+				 struct TCP_Server_Info *server,
+				 bool verify);
+extern struct scatterlist *smb3_init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign);
 extern void smb2_echo_request(struct work_struct *work);
 extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
 extern bool smb2_is_valid_oplock_break(char *buffer,
@@ -99,7 +105,8 @@ extern int smb2_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
 extern int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
 extern void smb2_reconnect_server(struct work_struct *work);
-extern int smb3_crypto_aead_allocate(struct TCP_Server_Info *server);
+extern int smb3_crypto_aead_allocate(const char *name, struct crypto_aead **tfm);
+extern void smb3_crypto_aead_free(struct crypto_aead **tfm);
 extern unsigned long smb_rqst_len(struct TCP_Server_Info *server,
 				  struct smb_rqst *rqst);
 extern void smb2_set_next_command(struct cifs_tcon *tcon,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index cf319fc25161..ded7144d1578 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -26,6 +26,63 @@
 #include "smb2status.h"
 #include "smb2glob.h"
 
+int
+smb2_init_secmechs(struct TCP_Server_Info *server)
+{
+	int rc = 0;
+
+	if (server->dialect >= SMB30_PROT_ID &&
+	    (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION)) {
+		if (server->cipher_type == SMB2_ENCRYPTION_AES128_GCM ||
+		    server->cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
+			rc = smb3_crypto_aead_allocate("gcm(aes)", &server->secmech.enc);
+			if (!rc)
+				rc = smb3_crypto_aead_allocate("gcm(aes)", &server->secmech.dec);
+		} else {
+			rc = smb3_crypto_aead_allocate("ccm(aes)", &server->secmech.enc);
+			if (!rc)
+				rc = smb3_crypto_aead_allocate("ccm(aes)", &server->secmech.dec);
+		}
+
+		if (rc)
+			return rc;
+	}
+
+	if (server->signing_algorithm == SIGNING_ALG_AES_GMAC) {
+		cifs_free_hash(&server->secmech.sign.shash);
+		cifs_free_hash(&server->secmech.verify.shash);
+
+		rc = smb3_crypto_aead_allocate("gcm(aes)", &server->secmech.sign.aead);
+		if (!rc)
+			rc = smb3_crypto_aead_allocate("gcm(aes)", &server->secmech.verify.aead);
+		if (rc) {
+			smb3_crypto_aead_free(&server->secmech.sign.aead);
+			return rc;
+		}
+
+		server->secmech.calc_signature = smb311_calc_signature;
+	} else {
+		char *shash_alg;
+
+		if (server->dialect >= SMB30_PROT_ID)
+			shash_alg = "cmac(aes)";
+		else
+			shash_alg = "hmac(sha256)";
+
+		rc = cifs_alloc_hash(shash_alg, &server->secmech.sign.shash);
+		if (!rc)
+			rc = cifs_alloc_hash(shash_alg, &server->secmech.verify.shash);
+		if (rc) {
+			cifs_free_hash(&server->secmech.sign.shash);
+			return rc;
+		}
+
+		server->secmech.calc_signature = smb2_calc_signature;
+	}
+
+	return rc;
+}
+
 static int
 smb3_setup_keys(struct TCP_Server_Info *server, u8 *sign_key, u8 *enc_key, u8 *dec_key)
 {
@@ -42,44 +99,51 @@ smb3_setup_keys(struct TCP_Server_Info *server, u8 *sign_key, u8 *enc_key, u8 *d
 		crypt_keylen = SMB3_GCM128_CRYPTKEY_SIZE;
 
 	rc = crypto_aead_setkey(server->secmech.enc, enc_key, crypt_keylen);
+	if (!rc)
+		rc = crypto_aead_setkey(server->secmech.dec, dec_key, crypt_keylen);
 	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set AEAD encryption key, rc=%d\n",
+		cifs_server_dbg(VFS, "%s: Failed to set encryption/decryption key, rc=%d\n",
 				__func__, rc);
 		return rc;
 	}
 
 	rc = crypto_aead_setauthsize(server->secmech.enc, SMB2_SIGNATURE_SIZE);
+	if (!rc)
+		rc = crypto_aead_setauthsize(server->secmech.dec, SMB2_SIGNATURE_SIZE);
 	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set AEAD encryption authsize, rc=%d\n",
-				__func__, rc);
-		return rc;
-	}
-
-	rc = crypto_aead_setkey(server->secmech.dec, dec_key, crypt_keylen);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set AEAD decryption key, rc=%d\n",
-				__func__, rc);
-		return rc;
-	}
-
-	rc = crypto_aead_setauthsize(server->secmech.dec, SMB2_SIGNATURE_SIZE);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set AEAD decryption authsize, rc=%d\n",
+		cifs_server_dbg(VFS, "%s: Failed to set encryption/decryption authsize, rc=%d\n",
 				__func__, rc);
 		return rc;
 	}
 setup_sign:
-	rc = crypto_shash_setkey(server->secmech.sign->tfm, sign_key, SMB3_SIGN_KEY_SIZE);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set AES-CMAC signing key, rc=%d\n",
-				__func__, rc);
-		return rc;
-	}
+	if (server->signing_algorithm == SIGNING_ALG_AES_GMAC) {
+		rc = crypto_aead_setkey(server->secmech.sign.aead, sign_key, SMB3_SIGN_KEY_SIZE);
+		if (!rc)
+			rc = crypto_aead_setkey(server->secmech.verify.aead, sign_key,
+						SMB3_SIGN_KEY_SIZE);
+		if (rc) {
+			cifs_server_dbg(VFS, "%s: Failed to set AES-GMAC key, rc=%d\n",
+					__func__, rc);
+			return rc;
+		}
 
-	rc = crypto_shash_setkey(server->secmech.verify->tfm, sign_key, SMB3_SIGN_KEY_SIZE);
-	if (rc)
-		cifs_server_dbg(VFS, "%s: Failed to set AES-CMAC verify key, rc=%d\n",
-				__func__, rc);
+		rc = crypto_aead_setauthsize(server->secmech.sign.aead, SMB2_SIGNATURE_SIZE);
+		if (!rc)
+			rc = crypto_aead_setauthsize(server->secmech.verify.aead,
+						     SMB2_SIGNATURE_SIZE);
+		if (rc)
+			cifs_server_dbg(VFS, "%s: Failed to set AES-GMAC authsize, rc=%d\n",
+					__func__, rc);
+	} else {
+		rc = crypto_shash_setkey(server->secmech.sign.shash->tfm, sign_key,
+					 SMB3_SIGN_KEY_SIZE);
+		if (!rc)
+			rc = crypto_shash_setkey(server->secmech.verify.shash->tfm, sign_key,
+						 SMB3_SIGN_KEY_SIZE);
+		if (rc)
+			cifs_server_dbg(VFS, "%s: Failed to set %s signing key, rc=%d\n", __func__,
+					crypto_shash_alg_name(server->secmech.sign.shash->tfm), rc);
+	}
 
 	return rc;
 }
@@ -171,9 +235,9 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server, bool
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	if (verify)
-		shash = server->secmech.verify;
+		shash = server->secmech.verify.shash;
 	else
-		shash = server->secmech.sign;
+		shash = server->secmech.sign.shash;
 
 	rc = crypto_shash_init(shash);
 	if (rc) {
@@ -360,10 +424,6 @@ generate_smb3signingkey(struct cifs_ses *ses,
 		if (rc)
 			goto out_zero_keys;
 
-		rc = smb3_crypto_aead_allocate(server);
-		if (rc)
-			goto out_zero_keys;
-
 		rc = smb3_setup_keys(ses->server, sign_key, enc_key, dec_key);
 		if (rc)
 			goto out_zero_keys;
@@ -471,6 +531,125 @@ generate_smb311signingkey(struct cifs_ses *ses,
 	return generate_smb3signingkey(ses, server, &triplet);
 }
 
+/*
+ * This function implements AES-GMAC signing for SMB2 messages as described in MS-SMB2
+ * specification.  This algorithm is only supported on SMB 3.1.1.
+ *
+ * Note: even though Microsoft mentions RFC4543 in MS-SMB2, the mechanism used _must_ be the "raw"
+ * AES-128-GCM ("gcm(aes)"); RFC4543 is designed for IPsec and trying to use "rfc4543(gcm(aes)))"
+ * will fail the signature computation.
+ *
+ * MS-SMB2 3.1.4.1
+ */
+int
+smb311_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server, bool verify)
+{
+	union {
+		struct {
+			/* for MessageId (8 bytes) */
+			__le64 mid;
+			/* for role (client or server) and if SMB2 CANCEL (4 bytes) */
+			__le32 role;
+		};
+		u8 buffer[12];
+	} __packed nonce;
+	u8 sig[SMB2_SIGNATURE_SIZE] = { 0 };
+	struct aead_request *aead_req = NULL;
+	struct crypto_aead *tfm = NULL;
+	struct scatterlist *sg = NULL;
+	unsigned long assoclen;
+	struct smb2_hdr *shdr = NULL;
+	struct crypto_wait *wait;
+	unsigned int save_npages = 0;
+	int rc = 0;
+
+	if (verify) {
+		wait = &server->secmech.verify_wait;
+		tfm = server->secmech.verify.aead;
+	} else {
+		wait = &server->secmech.sign_wait;
+		tfm = server->secmech.sign.aead;
+	}
+
+	if (completion_done(&wait->completion))
+		reinit_completion(&wait->completion);
+
+	shdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+
+	memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
+	memset(&nonce, 0, SMB3_AES_GCM_NONCE);
+
+	/* note that nonce must always be little endian */
+	nonce.mid = shdr->MessageId;
+	/* request is coming from the server, set LSB */
+	nonce.role |= shdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR;
+	/* set penultimate LSB if SMB2_CANCEL command */
+	if (shdr->Command == SMB2_CANCEL)
+		nonce.role |= cpu_to_le32(1UL << 1);
+
+	aead_req = aead_request_alloc(tfm, GFP_KERNEL);
+	if (!aead_req) {
+		cifs_dbg(VFS, "%s: Failed to alloc AEAD request\n", __func__);
+		return -ENOMEM;
+	}
+
+	/* skip page data if non-success error status, as it will compute an invalid signature */
+	if (shdr->Status != 0 && rqst->rq_npages > 0) {
+		save_npages = rqst->rq_npages;
+		rqst->rq_npages = 0;
+	}
+
+	assoclen = smb_rqst_len(server, rqst);
+
+	sg = smb3_init_sg(1, rqst, sig);
+	if (!sg) {
+		cifs_dbg(VFS, "%s: Failed to init SG\n", __func__);
+		goto out_free_req;
+	}
+
+	/* cryptlen == 0 because we're not encrypting anything */
+	aead_request_set_crypt(aead_req, sg, sg, 0, nonce.buffer);
+	aead_request_set_ad(aead_req, assoclen);
+	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG, crypto_req_done, wait);
+
+	/*
+	 * Reminder: we must always use the encrypt function, as AES-GCM decrypt will internally
+	 * try to match the authentication codes, where we pass a zeroed buffer, and the operation
+	 * will fail with -EBADMSG (expectedly).
+	 *
+	 * Also note we can't use crypto_wait_req() here since it's not interruptible.
+	 */
+	rc = crypto_aead_encrypt(aead_req);
+	if (!rc)
+		goto out;
+
+	if (rc == -EINPROGRESS || rc == -EBUSY) {
+		rc = wait_for_completion_interruptible(&wait->completion);
+		if (!rc)
+			/* wait->err is set by crypto_req_done callback above */
+			rc = wait->err;
+	}
+
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Failed to compute AES-GMAC signature, rc=%d\n",
+				__func__, rc);
+		goto out_free_sg;
+	}
+
+out:
+	memcpy(&shdr->Signature, sig, SMB2_SIGNATURE_SIZE);
+out_free_sg:
+	kfree(sg);
+out_free_req:
+	kfree(aead_req);
+
+	/* restore rq_npages for further processing */
+	if (shdr->Status != 0 && save_npages > 0)
+		rqst->rq_npages = save_npages;
+
+	return rc;
+}
+
 /* must be called with server->srv_mutex held */
 static int
 smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
@@ -497,12 +676,10 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		return 0;
 	}
 	spin_unlock(&server->srv_lock);
-	if (!is_binding && !server->session_estab) {
-		strncpy(shdr->Signature, "BSRSPYL", 8);
+	if (!is_binding && !server->session_estab)
 		return 0;
-	}
 
-	rc = server->ops->calc_signature(rqst, server, false);
+	rc = server->secmech.calc_signature(rqst, server, false);
 
 	return rc;
 }
@@ -518,6 +695,8 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	if ((shdr->Command == SMB2_NEGOTIATE) ||
 	    (shdr->Command == SMB2_SESSION_SETUP) ||
 	    (shdr->Command == SMB2_OPLOCK_BREAK) ||
+	    (shdr->MessageId == cpu_to_le64(0xFFFFFFFFFFFFFFFF)) ||
+	    (shdr->Status == STATUS_PENDING) ||
 	    server->ignore_signature ||
 	    (!server->session_estab))
 		return 0;
@@ -527,20 +706,13 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	 * server does not send one? BB
 	 */
 
-	/* Do not need to verify session setups with signature "BSRSPYL " */
-	if (memcmp(shdr->Signature, "BSRSPYL ", 8) == 0)
-		cifs_dbg(FYI, "dummy signature received for smb command 0x%x\n",
-			 shdr->Command);
-
 	/*
 	 * Save off the origiginal signature so we can modify the smb and check
 	 * our calculated signature against what the server sent.
 	 */
 	memcpy(server_response_sig, shdr->Signature, SMB2_SIGNATURE_SIZE);
 
-	memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
-
-	rc = server->ops->calc_signature(rqst, server, true);
+	rc = server->secmech.calc_signature(rqst, server, true);
 
 	if (rc)
 		return rc;
@@ -693,6 +865,8 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	int rc;
 	struct smb2_hdr *shdr =
 			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_transform_hdr *trhdr =
+			(struct smb2_transform_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	smb2_seq_num_into_buf(server, shdr);
@@ -703,11 +877,22 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		return ERR_PTR(rc);
 	}
 
-	rc = smb2_sign_rqst(rqst, server);
-	if (rc) {
-		revert_current_mid_from_hdr(server, shdr);
-		delete_mid(mid);
-		return ERR_PTR(rc);
+	/*
+	 * Client must not sign the request if it's encrypted.
+	 *
+	 * Note: we can't rely on SMB2_SESSION_FLAG_ENCRYPT_DATA or SMB2_GLOBAL_CAP_ENCRYPTION
+	 * here because they might be set, but not being actively used (e.g. not mounted with
+	 * "seal"), so just check if header is a transform header.
+	 *
+	 * MS-SMB2 3.2.4.1.1
+	 */
+	if (trhdr->ProtocolId != SMB2_TRANSFORM_PROTO_NUM) {
+		rc = smb2_sign_rqst(rqst, server);
+		if (rc) {
+			revert_current_mid_from_hdr(server, shdr);
+			delete_mid(mid);
+			return ERR_PTR(rc);
+		}
 	}
 
 	return mid;
@@ -748,39 +933,29 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 }
 
 int
-smb3_crypto_aead_allocate(struct TCP_Server_Info *server)
+smb3_crypto_aead_allocate(const char *name, struct crypto_aead **tfm)
 {
-	struct crypto_aead *tfm;
+	if (unlikely(!tfm))
+		return -EIO;
 
-	if (!server->secmech.enc) {
-		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-		else
-			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
-		if (IS_ERR(tfm)) {
-			cifs_server_dbg(VFS, "%s: Failed alloc encrypt aead\n",
-				 __func__);
-			return PTR_ERR(tfm);
-		}
-		server->secmech.enc = tfm;
-	}
+	if (*tfm)
+		return 0;
 
-	if (!server->secmech.dec) {
-		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-		else
-			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
-		if (IS_ERR(tfm)) {
-			crypto_free_aead(server->secmech.enc);
-			server->secmech.enc = NULL;
-			cifs_server_dbg(VFS, "%s: Failed to alloc decrypt aead\n",
-				 __func__);
-			return PTR_ERR(tfm);
-		}
-		server->secmech.dec = tfm;
+	*tfm = crypto_alloc_aead(name, CRYPTO_ALG_TYPE_AEAD, 0);
+	if (IS_ERR(*tfm)) {
+		cifs_dbg(VFS, "%s: Failed to alloc %s crypto TFM, rc=%ld\n",
+			 __func__, name, PTR_ERR(*tfm));
+		return PTR_ERR(*tfm);
 	}
 
 	return 0;
 }
+
+void smb3_crypto_aead_free(struct crypto_aead **tfm)
+{
+	if (!tfm || !*tfm)
+		return;
+
+	crypto_free_aead(*tfm);
+	*tfm = NULL;
+}
-- 
2.35.3

