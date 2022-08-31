Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B882ECAAD4
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 13:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbiHaNqS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 09:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiHaNqO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 09:46:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3E619C36
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 06:45:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 968EF220FB;
        Wed, 31 Aug 2022 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661953512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zi6WoDvRqw/olC7QpjXfpnZuN0LcnSYr7yPnUXi1Gok=;
        b=BclLkmlE48OR/Hpi5jQmSpxqGbfqCy2GYfgS4+nU4LcRURM/jUWFYpNROaAmJJOgtxHo86
        VeV0mGdEgjUWQhrVkIv20MVQSBW7mylO3doE+ovinFPkBFMLTl9KjPNgII9+6W9Uz1GG3x
        AoWK9kDaPYtz6rbbuItS48XIx9Yt2GQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661953512;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zi6WoDvRqw/olC7QpjXfpnZuN0LcnSYr7yPnUXi1Gok=;
        b=6ptCwzgKrx0TMNF9AHeIOM/aPn6LF3uQVKw5NMDoBZhGqOswyB6TOL1NF+O/C+7+59JtfO
        xUSAc2krUC0bh5BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC7921332D;
        Wed, 31 Aug 2022 13:45:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VlJwI+dlD2P5PgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 31 Aug 2022 13:45:11 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, dan.carpenter@oracle.com,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 1/3] cifs: introduce AES-GMAC signing support for SMB 3.1.1
Date:   Wed, 31 Aug 2022 10:44:42 -0300
Message-Id: <20220831134444.26252-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220831134444.26252-1-ematsumiya@suse.de>
References: <20220831134444.26252-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch implements the support for AES-GMAC message signing, as
specified in MS-SMB2 3.1.4.1 "Signing An Outgoing Message".

The core function is smb311_calc_aes_gmac(), which is to be used as the
->calc_signature op when a signing negotiate context
(SMB2_SIGNING_CAPABILITIES) has been sent ("enable_negotiate_signing"
module parameter) to the server and replied to with SIGNING_ALG_AES_GMAC
(i.e. the server supports it).

If "enable_negotiate_signing" is false (default) or if the server reply
with SIGNING_ALG_AES_CMAC, ->calc_signature will point to
smb3_calc_aes_cmac() (this was renamed from smb3_calc_signature() to
better identify which functions are dealing with which algorithms).

Since, in the crypto API context, AES-GMAC is not a hashing algorithm,
but rather AES-128-GCM with an empty plaintext buffer, the following
modifications were made:

- Introduce smb311_crypt_sign() to accommodate the common code for
  encrypt/decrypt and signing operations that deals with the crypto API

- crypt_message() has been modified to adopt smb311_crypt_sign() usage;
  no change of behaviour whatsoever

- init_sg() now takes a bool argument 'crypt' to indicate when it's
  initializing an SG list for crypt operations, or set to false when
  it's for initializing it for AES-GMAC signing. This is needed because
  crypt operations use a transform header, and it needs to skip the
  first 20 bytes of the first iov. For AES-GMAC signing this is not
  needed because iov[0] is already the beginning of the message

- Introduce smb311_aes_gmac_alloc() to allocate the secmech. This is
  called only once in smb311_update_preauth_hash(). The TFM has the
  lifetime of the TCP session, so it's only free when the TCP session
  is put() (via cifs_crypto_secmech_release())

- Introduce smb311_aes_gmac_nonce() to produce the nonce for AES-GMAC
  signing (as per MS-SMB2 3.1.4.1, item 2)

More implementation-specific information can be found in the kernel-doc
comments for the introduced functions.

Other smaller modifications:

- Check if the request is encrypted in smb2_setup_request(), as we
  must not sign a message if it is (MS-SMB2 3.2.4.1.1) -- AES-GCM and
  AES-CCM will generate their signatures based on the ciphertext
  (AES-GCM) or the plaintext (AES-CCM)

- smb2_verify_signature():
  - Remove extra call to memset to zero the header signature as this is
    already done in the beginning ->calc_signature() implementations
  - Remove useless call to check for "BSRSPYL" signature as it's SMB1 only
  - Add checks for if command is 0xFFFFFFFFFFFFFFFF or if status is
    STATUS_PENDING (MS-SMB2 3.2.5.1.3)

- Remove useless variable from smb2_sign_rqst()

- smb2_get_sign_key() is no longer static as it's now used by
  smb311_calc_aes_gmac()

- Use sizeof u16/__le16 in build_signing_ctxt() instead of hardcoded
  values

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2:
  - Fix check in smb2_verify_signature() to check for MessageId instead of Command (MS-SMB2
    3.2.5.1.3), mistake done by me being careless (reported by kernel test robot and Dan Carpenter)
  - Add prototypes for smb2_get_sign_key() (not static anymore) and smb311_aes_gmac_alloc() (new)
    to smb2proto.h (reported by kernel test robot)

 fs/cifs/cifsencrypt.c   |   5 +
 fs/cifs/cifsglob.h      |   9 +-
 fs/cifs/sess.c          |   2 +
 fs/cifs/smb2misc.c      |   4 +
 fs/cifs/smb2ops.c       | 482 +++++++++++++++++++++++++++++++++-------
 fs/cifs/smb2pdu.c       |  93 ++++++--
 fs/cifs/smb2proto.h     |   9 +-
 fs/cifs/smb2transport.c |  87 ++++++--
 8 files changed, 569 insertions(+), 122 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 46f5718754f9..39e934277dfc 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -743,6 +743,11 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 		server->secmech.hmacmd5 = NULL;
 	}
 
+	if (server->secmech.aes_gmac) {
+		crypto_free_aead(server->secmech.aes_gmac);
+		server->secmech.aes_gmac = NULL;
+	}
+
 	if (server->secmech.ccmaesencrypt) {
 		crypto_free_aead(server->secmech.ccmaesencrypt);
 		server->secmech.ccmaesencrypt = NULL;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ae7f571a7dba..0ce2ceaf039e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -171,6 +171,7 @@ struct cifs_secmech {
 	struct sdesc *sdeschmacsha256;  /* ctxt to generate smb2 signature */
 	struct sdesc *sdesccmacaes;  /* ctxt to generate smb3 signature */
 	struct sdesc *sdescsha512; /* ctxt to generate smb3.11 signing key */
+	struct crypto_aead *aes_gmac; /* to generate SMB3.1.1 signature */
 	struct crypto_aead *ccmaesencrypt; /* smb3 encryption aead */
 	struct crypto_aead *ccmaesdecrypt; /* smb3 decryption aead */
 };
@@ -704,7 +705,13 @@ struct TCP_Server_Info {
 	unsigned int	max_write;
 	unsigned int	min_offload;
 	__le16	compress_algorithm;
-	__u16	signing_algorithm;
+	/*
+	 * algorithm to be used to sign messages:
+	 *   SMB 2.x - HMAC-SHA256 (unsupported in SMB 3.1.1)
+	 *   SMB 3.0.x - AES-CMAC
+	 *   SMB 3.1.1 - AES-GMAC, if server negotiated it, or AES-CMAC otherwise
+	 */
+	__u16 signing_algorithm;
 	__le16	cipher_type;
 	 /* save initital negprot hash */
 	__u8	preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3af3b05b6c74..9708a531d604 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -458,6 +458,8 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	 * We need to allocate the server crypto now as we will need
 	 * to sign packets before we generate the channel signing key
 	 * (we sign with the session key)
+	 *
+	 * AES-GMAC secmech is allocated in smb311_update_preauth_hash() call.
 	 */
 	rc = smb311_crypto_shash_allocate(chan->server);
 	if (rc) {
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index d73e5672aac4..13033a4ec756 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -897,6 +897,10 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		return 0;
 
 ok:
+	rc = smb311_aes_gmac_alloc(&server->secmech.aes_gmac);
+	if (rc)
+		return rc;
+
 	rc = smb311_crypto_shash_allocate(server);
 	if (rc)
 		return rc;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5b5ddc1b4638..f776343b2dee 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -12,6 +12,7 @@
 #include <linux/uuid.h>
 #include <linux/sort.h>
 #include <crypto/aead.h>
+#include <crypto/gcm.h>
 #include <linux/fiemap.h>
 #include <uapi/linux/magic.h>
 #include "cifsfs.h"
@@ -4221,21 +4222,52 @@ static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *buf,
 	sg_set_page(sg, addr, buflen, offset_in_page(buf));
 }
 
-/* Assumes the first rqst has a transform header as the first iov.
- * I.e.
- * rqst[0].rq_iov[0]  is transform header
- * rqst[0].rq_iov[1+] data to be encrypted/decrypted
- * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
+/*
+ * Initialize a scatterlist for encrypt/decrypt/sign (AES-GMAC) operations
+ *
+ * @num_rqst: Number of requests that will be transformed. Note that this is always 1 for AES-GMAC
+ *	      signing.
+ * @rqst: Points to the first request to be transformed. Note that this is always a single request
+ *	  for AES-GMAC signing, that might contain 1 or more iovs.
+ * @sig: Points to a caller-allocated buffer that will hold the computed signature.
+ * @crypt: If true, indicates that this SG list is for a encryption/decryption transform. If false,
+ *	   this is an AES-GMAC signing operation. See 'skip' variable.
+ *
+ * General notes for callers:
+ *
+ * - The crypto API fully supports using the same SG list for encrypt/decrypt operations,i.e. it
+ *   encrypts/decrypts the plain/cipher text in src SG and then copies the result into dst SG,
+ *   where src == dst. The AAD buffer are should not be modified
+ * - If it's desired to use 2 different SGs, one for src, another for dst, make sure they have the
+ *   same layout, and same AAD/text/signature sizes
+ * - It's ok to have a hole/pad in the SG, if required, but make sure to account for its size when
+ *   setting crypt len/AAD len. Also, there should be no NULL buffers. init_sg() checks for that
+ *   when looping through the iovs, and will return ERR_PTR(-EIO) in case a NULL iov is found.
+ *
+ * Notes for encrypt/decrypt:
+ * - Assumes the first rqst has a transform header as the first iov, i.e.:
+ *   - rqst[0].rq_iov[0]: Transform header. The first 20 bytes of the transform header are not
+ *     part of the encrypted blob (see 'skip' variable)
+ *   - rqst[0].rq_iov[1+]: Data to be encrypted/decrypted
+ *   - rqst[1+].rq_iov[0+]: Data to be encrypted/decrypted
+ *
+ * Notes for AES-GMAC signing:
+ *   - @num_rqst is always 1
+ *   - 'skip' variable must be 0 (rqst[0].rq_iov[0] is smb2_hdr already)
+ *   - The memory layout is slightly different from encrypt/decrypt:
+ *     crypt: [ AAD (20 bytes) | plain/cipher text (iovs, variable length) | signature buffer (16 bytes) ]
+ *     sign: [ AAD (iovs, variable length) | empty plaintext (0 bytes, not NULL) | signature buffer (16 bytes) ]
+ *
+ * Return: On success, returns an SG filled with the iovs from @rqst. On
+ *	   failure, returns ERR_PTR(errno).
  */
-static struct scatterlist *
-init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
+static struct scatterlist *init_sg(int num_rqst, struct smb_rqst *rqst,
+				    u8 *sig, bool crypt)
 {
 	unsigned int sg_len;
 	struct scatterlist *sg;
-	unsigned int i;
-	unsigned int j;
-	unsigned int idx = 0;
-	int skip;
+	unsigned int i, j, idx = 0;
+	int skip = 0;
 
 	sg_len = 1;
 	for (i = 0; i < num_rqst; i++)
@@ -4243,20 +4275,26 @@ init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
 
 	sg = kmalloc_array(sg_len, sizeof(struct scatterlist), GFP_KERNEL);
 	if (!sg)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	sg_init_table(sg, sg_len);
+
+	/*
+	 * initializes the plain/cipher text buffers for encrypt/decrypt, or
+	 * the AAD area for signing
+	 */
 	for (i = 0; i < num_rqst; i++) {
 		for (j = 0; j < rqst[i].rq_nvec; j++) {
-			/*
-			 * The first rqst has a transform header where the
-			 * first 20 bytes are not part of the encrypted blob
-			 */
-			skip = (i == 0) && (j == 0) ? 20 : 0;
+			if (unlikely(!rqst[i].rq_iov[j].iov_base))
+				return ERR_PTR(-EIO);
+
+			if (crypt)
+				skip = (i == 0) && (j == 0) ? 20 : 0;
+
 			smb2_sg_set_buf(&sg[idx++],
 					rqst[i].rq_iov[j].iov_base + skip,
 					rqst[i].rq_iov[j].iov_len - skip);
-			}
+		}
 
 		for (j = 0; j < rqst[i].rq_npages; j++) {
 			unsigned int len, offset;
@@ -4265,7 +4303,10 @@ init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
 			sg_set_page(&sg[idx++], rqst[i].rq_pages[j], len, offset);
 		}
 	}
-	smb2_sg_set_buf(&sg[idx], sign, SMB2_SIGNATURE_SIZE);
+
+	/* initialize signature buffer */
+	smb2_sg_set_buf(&sg[idx], sig, SMB2_SIGNATURE_SIZE);
+
 	return sg;
 }
 
@@ -4293,6 +4334,178 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
 
 	return -EAGAIN;
 }
+
+/**
+ * smb311_crypt_sign() - Encrypts, decrypts, or sign an SMB2 message using AES-GCM algorithm.
+ * @rqst: SMB2 request to transform.
+ * @num_rqst: Number of requests to transform.  Must be 1 if @sign_only is true.
+ * @enc: True for an encryption operation, false for decryption.  If both @enc and @sign_only are
+ *	 true, assumes an encryption operation and set @sign_only to false.
+ * @sign_only: True if the request must only have the signature computed.
+ * @tfm: AES-GCM crypto transformation object.  Must be allocated and freed by the caller.
+ * @key: The private key to be used for the operation.  Must be allocated and freed by the caller.
+ * @keylen: The size of @key.  Must be 16 for AES-128-GCM crypt ops and AES-GMAC, or 32 for
+ *	    AES-256-GCM.
+ * @iv: The Initialization Vector, a.k.a. nonce.  Must be allocated and freed by the caller.
+ * @assoclen: Size of the Additional Authenticated Data (AAD) (or Associated Data (AD)).  Must be
+ *	      size of smb2_transform_hdr - 20 for encryption/decryption, and the size of the whole
+ *	      SMB2 message for signing (e.g gotten from smb_rqst_len()).
+ * @cryptlen: Size of the plain/cipher text buffer.  Must be 0 if @sign_only is true.
+ *
+ * This function is shared between the SMB 3.1.1 AES-GCM encryption/decryption operations
+ * (crypt_message()), and AES-GMAC signing operation (smb311_calc_aes_gmac()).
+ *
+ * This function will perform the core operations (encrypt and decrypt) using the parameters passed
+ * by the callers, which is what differ encrypt/decrypt ops from signing ops.
+ *
+ * Note that signing functionality (@sign_only == true) must only be used when the request must NOT
+ * be encrypted, as encrypted requests will have their own signatures, but computed differently.
+ *
+ * References:
+ * MS-SMB2 3.2.4.1.1 "Signing the Message"
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+static int smb311_crypt_sign(struct smb_rqst *rqst, int num_rqst, int enc,
+			     bool sign_only, struct crypto_aead *tfm, u8 *key,
+			     unsigned int keylen, u8 *iv, unsigned int assoclen,
+			     unsigned int cryptlen)
+{
+	struct smb2_hdr *shdr = (struct smb2_hdr *)rqst[0].rq_iov[0].iov_base;
+	struct smb2_transform_hdr *tr_hdr =
+		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
+	u8 sig[SMB2_SIGNATURE_SIZE] = { 0 };
+	struct aead_request *aead_req;
+	DECLARE_CRYPTO_WAIT(wait);
+	struct scatterlist *sg;
+	int rc = 0;
+
+	/* basic checks */
+	if (!rqst || !tfm || !key || !iv)
+		return -EINVAL;
+
+	if (unlikely(!rqst))
+		return -ENODATA;
+
+	/* signing checks */
+	if (sign_only) {
+		/*
+		 * !enc && !sign_only == decrypt, but enc && sign_only is
+		 * invalid.
+		 *
+		 * Warn the user, but continue normally assuming this is an
+		 * encryption operation.
+		 *
+		 * (this is probably a bug from the caller)
+		 */
+		if (unlikely(enc)) {
+			pr_warn_once("%s: cannot have enc == true and sign_only == true, assuming "
+				     "encrypt\n", __func__);
+			sign_only = false;
+			goto check_key;
+		}
+
+		/* signing is done on single requests only */
+		if (num_rqst > 1) {
+			cifs_dbg(VFS, "%s: invalid number of requests to sign '%u', expected 1\n",
+				 __func__, num_rqst);
+			return -EINVAL;
+		}
+
+		if (unlikely(assoclen == 0)) {
+			cifs_dbg(FYI, "%s: assoclen is 0 for signing operation\n", __func__);
+			return -ENODATA;
+		}
+
+		if (unlikely(cryptlen > 0)) {
+			cifs_dbg(FYI, "%s: AES-GMAC signing must have cryptlen 0, got '%u'\n",
+				 __func__, cryptlen);
+			return -EINVAL;
+		}
+	} else {
+		/* crypt checks */
+		if (unlikely(assoclen != sizeof(struct smb2_transform_hdr) - 20)) {
+			cifs_dbg(FYI, "%s: invalid assoclen '%u' for %scrypt operation\n",
+				 __func__, assoclen, enc ? "en" : "de");
+			return -EINVAL;
+		}
+
+		if (unlikely(cryptlen == 0)) {
+			cifs_dbg(FYI, "%s: empty cryptlen for %scrypt operation\n", __func__,
+				 enc ? "en" : "de");
+			return -ENODATA;
+		}
+	}
+
+check_key:
+	if (keylen != SMB3_GCM128_CRYPTKEY_SIZE && /* 16 bytes, for AES-GMAC too */
+	    keylen != SMB3_GCM256_CRYPTKEY_SIZE) { /* 32 bytes */
+		cifs_dbg(FYI, "%s: invalid key size '%u'\n", __func__, keylen);
+		return -EINVAL;
+	}
+
+	rc = crypto_aead_setkey(tfm, key, keylen);
+	if (rc) {
+		cifs_dbg(VFS, "%s: Failed to set AEAD key, rc=%d\n", __func__, rc);
+		return rc;
+	}
+
+	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
+	if (rc) {
+		cifs_dbg(VFS, "%s: Failed to set AEAD authsize, rc=%d\n",
+			 __func__, rc);
+		return rc;
+	}
+
+	aead_req = aead_request_alloc(tfm, GFP_KERNEL);
+	if (!aead_req) {
+		cifs_dbg(VFS, "%s: Failed to alloc AEAD request\n", __func__);
+		return -ENOMEM;
+	}
+
+	/* decrypting */
+	if (!enc && !sign_only) {
+		memcpy(sig, &tr_hdr->Signature, SMB2_SIGNATURE_SIZE);
+		cryptlen += SMB2_SIGNATURE_SIZE;
+	}
+
+	sg = init_sg(num_rqst, rqst, sig, !sign_only);
+	if (IS_ERR(sg)) {
+		rc = PTR_ERR(sg);
+		cifs_dbg(VFS, "%s: Failed to init SG, rc=%d\n", __func__, rc);
+		goto out_free_req;
+	}
+
+	aead_request_set_crypt(aead_req, sg, sg, cryptlen, iv);
+	aead_request_set_ad(aead_req, assoclen);
+	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
+
+	/*
+	 * Note for AES-GMAC (@sign_only): whether signing or verifying a signature, we must
+	 * always use the encrypt function, as AES-GCM decrypt will internally try to match the
+	 * authentication codes, which were computed based on the ciphertext, and fail (-EBADMSG),
+	 * as expected.
+	 */
+	if (enc || sign_only)
+		rc = crypto_wait_req(crypto_aead_encrypt(aead_req), &wait);
+	else
+		rc = crypto_wait_req(crypto_aead_decrypt(aead_req), &wait);
+
+	if (!rc) {
+		if (enc)
+			memcpy(&tr_hdr->Signature, sig, SMB2_SIGNATURE_SIZE);
+		else if (sign_only)
+			memcpy(&shdr->Signature, sig, SMB2_SIGNATURE_SIZE);
+	}
+
+	kfree(sg);
+out_free_req:
+	kfree(aead_req);
+
+	return rc;
+}
+
 /*
  * Encrypt or decrypt @rqst message. @rqst[0] has the following format:
  * iov[0]   - transform header (associate data),
@@ -4306,17 +4519,16 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 {
 	struct smb2_transform_hdr *tr_hdr =
 		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
-	int rc = 0;
-	struct scatterlist *sg;
-	u8 sign[SMB2_SIGNATURE_SIZE] = {};
+	unsigned int assoclen, cryptlen;
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
-	struct aead_request *req;
-	char *iv;
-	unsigned int iv_len;
-	DECLARE_CRYPTO_WAIT(wait);
 	struct crypto_aead *tfm;
-	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
+	unsigned int iv_len;
+	unsigned int keylen;
+	char *iv;
+	int rc = 0;
+
+	assoclen = sizeof(struct smb2_transform_hdr) - 20;
+	cryptlen = le32_to_cpu(tr_hdr->OriginalMessageSize);
 
 	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), enc, key);
 	if (rc) {
@@ -4332,49 +4544,24 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	}
 
 	tfm = enc ? server->secmech.ccmaesencrypt :
-						server->secmech.ccmaesdecrypt;
-
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
-	req = aead_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		cifs_server_dbg(VFS, "%s: Failed to alloc aead request\n", __func__);
-		return -ENOMEM;
-	}
-
-	if (!enc) {
-		memcpy(sign, &tr_hdr->Signature, SMB2_SIGNATURE_SIZE);
-		crypt_len += SMB2_SIGNATURE_SIZE;
+		    server->secmech.ccmaesdecrypt;
+	/* sanity check -- shouldn't happen */
+	if (unlikely(!tfm)) {
+		cifs_server_dbg(FYI, "%s: AEAD TFM is NULL\n", __func__);
+		return -EIO;
 	}
 
-	sg = init_sg(num_rqst, rqst, sign);
-	if (!sg) {
-		cifs_server_dbg(VFS, "%s: Failed to init sg\n", __func__);
-		rc = -ENOMEM;
-		goto free_req;
-	}
+	if (server->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	    server->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+		keylen = SMB3_GCM256_CRYPTKEY_SIZE;
+	else
+		keylen = SMB3_GCM128_CRYPTKEY_SIZE;
 
 	iv_len = crypto_aead_ivsize(tfm);
 	iv = kzalloc(iv_len, GFP_KERNEL);
 	if (!iv) {
 		cifs_server_dbg(VFS, "%s: Failed to alloc iv\n", __func__);
-		rc = -ENOMEM;
-		goto free_sg;
+		return -ENOMEM;
 	}
 
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
@@ -4385,23 +4572,156 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
 	}
 
-	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
-	aead_request_set_ad(req, assoc_data_len);
+	rc = smb311_crypt_sign(rqst, num_rqst, enc, false, tfm, key, keylen,
+			       iv, assoclen, cryptlen);
+	if (rc)
+		cifs_server_dbg(VFS, "%s: Failed to %scrypt request, rc=%d\n",
+				__func__, enc ? "en" : "de", rc);
 
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  crypto_req_done, &wait);
+	kfree(iv);
+	return rc;
+}
+
+/**
+ * smb311_aes_gmac_nonce() - Setup AES-GMAC nonce.
+ * @shdr: SMB2 header containing the MessageId and the Command of the request.
+ * @is_server: True if the request came from the server (i.e. we're verifying a signature), false
+ *	       if the request is being sent from the client (i.e. we're signing a request to be
+ *	       sent).
+ * @out_nonce: Output buffer to put the computed nonce.  Must be allocated and freed by the caller.
+ *	       @*out_nonce will be allocated here, and, on success, must be freed by the caller.
+ *
+ * Allocates @*out_nonce and fill it with the nonce computed.
+ *
+ * MS-SMB2 3.1.4.1 "Signing An Outgoing Message", item 2:
+ *
+ * If Connection.SigningAlgorithmId is AES-GMAC, Nonce specified in [RFC4543], MUST be initialized
+ * to 12 bytes with the following syntax:
+ *   - First 8 bytes are set to MessageId.
+ *   - Following 4 bytes are set as follows: If the sender is a client, least significant bit is
+ *     set to zero, otherwise set to 1. If the message is SMB2 CANCEL request, the penultimate bit
+ *     is set to 1, otherwise set to zero. Remaining 30 bits are set to zero.
+ *
+ * References:
+ * MS-SMB2 3.1.4.1 "Signing An Outgoing Message"
+ * RFC 4543 "GMAC in IPsec ESP and AH", section 3.2 "Nonce Format"
+ * https://www.ietf.org/rfc/rfc4543.txt
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+static int smb311_aes_gmac_nonce(struct smb2_hdr *shdr, bool is_server,
+				 u8 **out_nonce)
+{
+	struct {
+		/* for MessageId (8 bytes) */
+		__le64 mid;
+		/* for role (client or server) and if SMB2 CANCEL (4 bytes) */
+		__le32 role;
+	} __packed nonce;
+
+	if (!shdr || !out_nonce)
+		return -EINVAL;
 
-	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req)
-				: crypto_aead_decrypt(req), &wait);
+	*out_nonce = kzalloc(SMB3_AES_GCM_NONCE, GFP_KERNEL);
+	if (!*out_nonce)
+		return -ENOMEM;
 
-	if (!rc && enc)
-		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
+	memset(&nonce, 0, SMB3_AES_GCM_NONCE);
 
-	kfree(iv);
-free_sg:
-	kfree(sg);
-free_req:
-	kfree(req);
+	/* note that nonce must always be little endian */
+	nonce.mid = shdr->MessageId;
+
+	/* request is coming from the server */
+	if (is_server)
+		set_bit(0, (unsigned long *)&nonce.role);
+
+	/* set penultimate bit if SMB2_CANCEL command */
+	if (shdr->Command == SMB2_CANCEL)
+		set_bit(1, (unsigned long *)&nonce.role);
+
+	memcpy(*out_nonce, (u8 *)&nonce, SMB3_AES_GCM_NONCE);
+
+	return 0;
+}
+
+/**
+ * smb311_calc_aes_gmac() - Calculate the signature for a request using AES-GMAC algorithm.
+ * @rqst: SMB2 request to be signed.
+ * @server: Server pointer that holds the secmech to be used.
+ * @verify: If true, compute the nonce considering it came from the server.
+ *
+ * This function implements AES-GMAC signing for SMB2 messages as described in MS-SMB2
+ * specification.  This algorithm is only supported on SMB 3.1.1.
+ *
+ * For our purposes, AES-GMAC is AES-128-GCM, but without encrypting anything.  IOW, this is what's
+ * done:
+ * - set an Additional Authenticated Data (AAD) buffer, with the contents of the SMB2 request,
+ *   starting from the SMB2 header, and the length of rq_nvec + rq_npages
+ * - set plaintext buffer to have a 0 length, so AES-GCM will not encrypt anything
+ * - set a signature buffer, where AES-GCM will place the signature computed from the AAD buffer
+ *
+ * Most of that is done in smb311_crypt_sign().
+ *
+ * Note: even though Microsoft mentions RFC4543 in MS-SMB2, the mechanism used _must_ be the "raw"
+ * AES-128-GCM. RFC4543 is designed for IPsec Encapsulating Security Payload (ESP) and
+ * Authentication Header (AH).  Trying to use "rfc(gcm(aes)))" as the AEAD algorithm will fail the
+ * signature calculation.
+ *
+ * References:
+ * MS-SMB2 3.1.4.1 "Signing An Outgoing Message"
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+int smb311_calc_aes_gmac(struct smb_rqst *rqst, struct TCP_Server_Info *server,
+			 bool verify)
+{
+	u8 key[SMB3_SIGN_KEY_SIZE] = { 0 };
+	struct crypto_aead *tfm = NULL;
+	struct smb2_hdr *shdr;
+	unsigned int assoclen;
+	u8 *nonce = NULL;
+	int rc = 0;
+
+	/* allocated in smb311_update_preauth_hash() */
+	tfm = server->secmech.aes_gmac;
+	/* sanity check -- shouldn't happen */
+	if (unlikely(!tfm)) {
+		cifs_server_dbg(FYI, "%s: AES-GMAC TFM is NULL\n", __func__);
+		return -EIO;
+	}
+
+	shdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+	memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
+
+	rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Could not get AES-GMAC signing key, rc=%d\n", __func__,
+				rc);
+		goto out;
+	}
+
+	rc = smb311_aes_gmac_nonce(shdr, verify, &nonce);
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Could not get AES-GMAC nonce, rc=%d\n", __func__, rc);
+		goto out;
+	}
+
+	/*
+	 * Set the Additional Authenticated Data (AAD)/Associated Data (AD) length to the SMB
+	 * request length, which corresponds to the part of the buffer we want to sign/authenticate.
+	 */
+	assoclen = smb_rqst_len(server, rqst);
+
+	/*
+	 * Use 0 for cryptlen because we're not interested in encrypting, but only computing the
+	 * authentication tag (signature) of the AAD buffer.
+	 */
+	rc = smb311_crypt_sign(rqst, 1, false, true, tfm, key, SMB3_SIGN_KEY_SIZE, nonce, assoclen, 0);
+	if (rc)
+		cifs_server_dbg(VFS, "%s: Failed to compute AES-GMAC signature for request, rc=%d\n",
+				__func__, rc);
+	kfree(nonce);
+out:
 	return rc;
 }
 
@@ -5458,7 +5778,7 @@ struct smb_version_operations smb30_operations = {
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb30signingkey,
-	.calc_signature = smb3_calc_signature,
+	.calc_signature = smb3_calc_aes_cmac,
 	.set_integrity  = smb3_set_integrity,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb3_set_oplock_level,
@@ -5572,7 +5892,11 @@ struct smb_version_operations smb311_operations = {
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
 	.generate_signingkey = generate_smb311signingkey,
-	.calc_signature = smb3_calc_signature,
+	/*
+	 * .calc_signature is replaced by smb311_calc_aes_gmac if AES-GMAC
+	 * gets negotiated with the server.
+	 */
+	.calc_signature = smb3_calc_aes_cmac,
 	.set_integrity  = smb3_set_integrity,
 	.is_read_op = smb21_is_read_op,
 	.set_oplock_level = smb3_set_oplock_level,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 128e44e57528..45215e4e6f37 100644
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
@@ -469,14 +469,25 @@ build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
 	pneg_ctxt->DataLength = cpu_to_le16(DIV_ROUND_UP(
 				sizeof(struct smb2_signing_capabilities) -
 				sizeof(struct smb2_neg_context) +
-				(num_algs * 2 /* sizeof u16 */), 8) * 8);
+				(num_algs * sizeof(u16)), 8) * 8);
 	pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(num_algs);
-	pneg_ctxt->SigningAlgorithms[0] = cpu_to_le16(SIGNING_ALG_AES_CMAC);
 
-	ctxt_len += 2 /* sizeof le16 */ * num_algs;
+	/*
+	 * MS-SMB2 2.2.3.1.7:
+	 * These IDs MUST be in an order such that the most preferred
+	 * signing algorithm MUST be at the beginning of the array and least
+	 * preferred signing algorithm at the end of the array.
+	 *
+	 * Hint the server that we prefer AES-GMAC, but there's no guarantee
+	 * it'll be used, e.g. server might not support it.
+	 */
+	pneg_ctxt->SigningAlgorithms[0] = SIGNING_ALG_AES_GMAC_LE;
+	pneg_ctxt->SigningAlgorithms[1] = SIGNING_ALG_AES_CMAC_LE;
+	/* SMB 3.1.1 doesn't accept HMAC-SHA256, so no need to send it */
+
+	ctxt_len += sizeof(__le16) * num_algs;
 	ctxt_len = DIV_ROUND_UP(ctxt_len, 8) * 8;
 	return ctxt_len;
-	/* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
 }
 
 static void
@@ -613,7 +624,6 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 
 	/* check for and add transport_capabilities and signing capabilities */
 	req->NegotiateContextCount = cpu_to_le16(neg_context_count);
-
 }
 
 static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
@@ -702,30 +712,49 @@ static int decode_encrypt_ctx(struct TCP_Server_Info *server,
 	return 0;
 }
 
+/* XXX: maybe move this somewhere else? */
+static const char *smb3_signing_algo_str(u16 algo)
+{
+	switch (algo) {
+	case SIGNING_ALG_AES_CMAC: return "AES-CMAC";
+	case SIGNING_ALG_AES_GMAC: return "AES-GMAC";
+	/* HMAC-SHA256 is unused in SMB3+ context */
+	default: return "unknown";
+	}
+}
+
 static void decode_signing_ctx(struct TCP_Server_Info *server,
 			       struct smb2_signing_capabilities *pctxt)
 {
 	unsigned int len = le16_to_cpu(pctxt->DataLength);
 
 	if ((len < 4) || (len > 16)) {
-		pr_warn_once("server sent bad signing negcontext\n");
+		pr_warn_once("server sent bad signing negcontext, len=%u\n", len);
 		return;
 	}
+
 	if (le16_to_cpu(pctxt->SigningAlgorithmCount) != 1) {
-		pr_warn_once("Invalid signing algorithm count\n");
+		pr_warn_once("invalid signing algorithm count '%u'\n",
+			     le16_to_cpu(pctxt->SigningAlgorithmCount));
 		return;
 	}
-	if (le16_to_cpu(pctxt->SigningAlgorithms[0]) > 2) {
-		pr_warn_once("unknown signing algorithm\n");
+
+	if (le16_to_cpu(pctxt->SigningAlgorithms[0]) > SIGNING_ALG_AES_GMAC) {
+		pr_warn_once("unknown signing algorithm '%u'\n",
+			     le16_to_cpu(pctxt->SigningAlgorithms[0]));
 		return;
 	}
 
 	server->signing_negotiated = true;
 	server->signing_algorithm = le16_to_cpu(pctxt->SigningAlgorithms[0]);
-	cifs_dbg(FYI, "signing algorithm %d chosen\n",
-		     server->signing_algorithm);
-}
+	if (server->signing_algorithm == SIGNING_ALG_AES_GMAC)
+		server->ops->calc_signature = smb311_calc_aes_gmac;
 
+	/* AES-CMAC is already the default, in case AES-GMAC wasn't negotiated */
+
+	cifs_dbg(FYI, "negotiated signing algorithm '%s'\n",
+		 smb3_signing_algo_str(server->signing_algorithm));
+}
 
 static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 				     struct TCP_Server_Info *server,
@@ -745,6 +774,9 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 
 	len_of_ctxts = len_of_smb - offset;
 
+	/* ensure this is false before decoding */
+	server->signing_negotiated = false;
+
 	for (i = 0; i < ctxt_cnt; i++) {
 		int clen;
 		/* check that offset is not beyond end of SMB */
@@ -784,6 +816,21 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 		offset += clen + sizeof(struct smb2_neg_context);
 		len_of_ctxts -= clen;
 	}
+
+	/*
+	 * Throw a warning if user requested signing to be negotiated, but it
+	 * wasn't.
+	 *
+	 * Some servers will not send a SMB2_SIGNING_CAPABILITIES context (*),
+	 * so we use AES-CMAC (default in smb311 ops) as it is expected to be
+	 * accepted (e.g. only Windows Server 2022 supports AES-GMAC)
+	 *
+	 * (*) see note "<125> Section 3.2.4.2.2.2" in MS-SMB2
+	 */
+	if (!server->signing_negotiated && enable_negotiate_signing)
+		cifs_dbg(VFS, "signing capabilities were not negotiated, using "
+			 "AES-CMAC for message signing\n");
+
 	return rc;
 }
 
@@ -931,6 +978,15 @@ SMB2_negotiate(const unsigned int xid,
 	if (ses->chan_max > 1)
 		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
+	/* set default settings for signing */
+	if (server->vals->protocol_id >= SMB30_PROT_ID) {
+		server->signing_algorithm = SIGNING_ALG_AES_CMAC;
+		server->ops->calc_signature = smb3_calc_aes_cmac;
+	} else if (server->vals->protocol_id >= SMB20_PROT_ID) {
+		server->signing_algorithm = SIGNING_ALG_HMAC_SHA256;
+		/* ->calc_signature is already set to smb2_calc_signature */
+	}
+
 	/* ClientGUID must be zero for SMB2.02 dialect */
 	if (server->vals->protocol_id == SMB20_PROT_ID)
 		memset(req->ClientGUID, 0, SMB2_CLIENT_GUID_SIZE);
@@ -1078,11 +1134,15 @@ SMB2_negotiate(const unsigned int xid,
 	}
 
 	if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
-		if (rsp->NegotiateContextCount)
+		if (rsp->NegotiateContextCount) {
 			rc = smb311_decode_neg_context(rsp, server,
 						       rsp_iov.iov_len);
-		else
+		} else {
 			cifs_server_dbg(VFS, "Missing expected negotiate contexts\n");
+			cifs_server_dbg(VFS, "Using default signing algorithm (AES-CMAC)\n");
+			server->signing_algorithm = SIGNING_ALG_AES_CMAC;
+			server->ops->calc_signature = smb3_calc_aes_cmac;
+		}
 	}
 neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
@@ -1387,8 +1447,7 @@ SMB2_sess_establish_session(struct SMB2_sess_data *sess_data)
 	if (server->ops->generate_signingkey) {
 		rc = server->ops->generate_signingkey(ses, server);
 		if (rc) {
-			cifs_dbg(FYI,
-				"SMB3 session key generation failed\n");
+			cifs_dbg(FYI, "SMB3 session key generation failed\n");
 			cifs_server_unlock(server);
 			return rc;
 		}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 3f740f24b96a..5d08ca240fdc 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -36,6 +36,7 @@ extern struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
 					      struct TCP_Server_Info *,
 					      struct smb_rqst *rqst);
 extern struct mid_q_entry *smb2_setup_async_request(
+extern int smb311_aes_gmac_alloc(struct crypto_aead **);
 			struct TCP_Server_Info *server, struct smb_rqst *rqst);
 extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
 					   __u64 ses_id);
@@ -44,9 +45,12 @@ extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 extern int smb2_calc_signature(struct smb_rqst *rqst,
 				struct TCP_Server_Info *server,
 				bool allocate_crypto);
-extern int smb3_calc_signature(struct smb_rqst *rqst,
+extern int smb3_calc_aes_cmac(struct smb_rqst *rqst,
+			      struct TCP_Server_Info *server,
+			      bool allocate_crypto);
+extern int smb311_calc_aes_gmac(struct smb_rqst *rqst,
 				struct TCP_Server_Info *server,
-				bool allocate_crypto);
+				bool alloc);
 extern void smb2_echo_request(struct work_struct *work);
 extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
 extern bool smb2_is_valid_oplock_break(char *buffer,
@@ -268,6 +272,7 @@ extern void smb2_copy_fs_info_to_kstatfs(
 	 struct smb2_fs_full_size_info *pfs_inf,
 	 struct kstatfs *kst);
 extern int smb311_crypto_shash_allocate(struct TCP_Server_Info *server);
+extern int smb2_get_sign_key(__u64, struct TCP_Server_Info *, u8 *);
 extern int smb311_update_preauth_hash(struct cifs_ses *ses,
 				      struct TCP_Server_Info *server,
 				      struct kvec *iov, int nvec);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 1a5fc3314dbf..5c1cc9a6ab26 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -76,8 +76,6 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 	return rc;
 }
 
-
-static
 int smb2_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 {
 	struct cifs_chan *chan;
@@ -542,8 +540,8 @@ generate_smb311signingkey(struct cifs_ses *ses,
 }
 
 int
-smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
-			bool allocate_crypto)
+smb3_calc_aes_cmac(struct smb_rqst *rqst, struct TCP_Server_Info *server,
+		   bool allocate_crypto)
 {
 	int rc;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
@@ -625,7 +623,6 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 static int
 smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
-	int rc = 0;
 	struct smb2_hdr *shdr;
 	struct smb2_sess_setup_req *ssr;
 	bool is_binding;
@@ -652,9 +649,7 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		return 0;
 	}
 
-	rc = server->ops->calc_signature(rqst, server, false);
-
-	return rc;
+	return server->ops->calc_signature(rqst, server, false);
 }
 
 int
@@ -668,6 +663,8 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	if ((shdr->Command == SMB2_NEGOTIATE) ||
 	    (shdr->Command == SMB2_SESSION_SETUP) ||
 	    (shdr->Command == SMB2_OPLOCK_BREAK) ||
+	    (shdr->MessageId == 0xFFFFFFFFFFFFFFFF) || /* MS-SMB2 3.2.5.1.3 */
+	    (shdr->Status == STATUS_PENDING) || /* MS-SMB2 3.2.5.1.3 */
 	    server->ignore_signature ||
 	    (!server->session_estab))
 		return 0;
@@ -677,21 +674,17 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
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
+	/*
+	 * all implementations of ->calc_signature() will zero shdr->Signature
+	 * before computing it
+	 */
 	rc = server->ops->calc_signature(rqst, server, true);
-
 	if (rc)
 		return rc;
 
@@ -699,8 +692,9 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		cifs_dbg(VFS, "sign fail cmd 0x%x message id 0x%llx\n",
 			shdr->Command, shdr->MessageId);
 		return -EACCES;
-	} else
-		return 0;
+	}
+
+	return 0;
 }
 
 /*
@@ -843,7 +837,23 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	int rc;
 	struct smb2_hdr *shdr =
 			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_transform_hdr *trhdr =
+			(struct smb2_transform_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
+	bool is_encrypted;
+
+	/*
+	 * Client must not sign the request is encrypted.
+	 *
+	 * Note: we can't rely on SMB2_SESSION_FLAG_ENCRYPT_DATA or
+	 * SMB2_GLOBAL_CAP_ENCRYPTION here because they might be set, but not
+	 * being actively used (e.g. not mounted with "seal"). So we just check
+	 * if the request header is a transform header.
+	 *
+	 * References:
+	 * MS-SMB2 3.2.4.1.1
+	 */
+	is_encrypted = (trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM);
 
 	smb2_seq_num_into_buf(server, shdr);
 
@@ -853,11 +863,13 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		return ERR_PTR(rc);
 	}
 
-	rc = smb2_sign_rqst(rqst, server);
-	if (rc) {
-		revert_current_mid_from_hdr(server, shdr);
-		delete_mid(mid);
-		return ERR_PTR(rc);
+	if (!is_encrypted) {
+		rc = smb2_sign_rqst(rqst, server);
+		if (rc) {
+			revert_current_mid_from_hdr(server, shdr);
+			delete_mid(mid);
+			return ERR_PTR(rc);
+		}
 	}
 
 	return mid;
@@ -897,6 +909,35 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	return mid;
 }
 
+int smb311_aes_gmac_alloc(struct crypto_aead **tfm)
+{
+	int rc = 0;
+
+	if (!tfm)
+		return -EIO;
+
+	/*
+	 * This is unlikely as we only call this once per TCP session in
+	 * smb311_update_preauth_hash(). If *tfm is already allocated, this
+	 * is probably a bug.
+	 *
+	 * XXX: rc == 0 here, maybe return an error here instead?
+	 */
+	if (unlikely(*tfm))
+		return rc;
+
+	*tfm = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(*tfm)) {
+		rc = PTR_ERR(*tfm);
+
+		cifs_dbg(VFS, "%s: Failed to alloc AES-GMAC AEAD, rc=%d\n",
+			 __func__, rc);
+		*tfm = NULL;
+	}
+
+	return rc;
+}
+
 int
 smb3_crypto_aead_allocate(struct TCP_Server_Info *server)
 {
-- 
2.35.3

