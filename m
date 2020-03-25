Return-Path: <SRS0=HB3D=5K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08509C2D0E5
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Mar 2020 18:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B90B520777
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Mar 2020 18:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="UAf1t0f8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgCYSOk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:14:40 -0400
Received: from linux.microsoft.com ([13.77.154.182]:47728 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgCYSOk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Mar 2020 14:14:40 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 87FFF20B4737; Wed, 25 Mar 2020 11:14:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 87FFF20B4737
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585160077;
        bh=HD04rAPX0fMXMU1oERDrerTT/pb8k1dRIKiudq5R9xk=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=UAf1t0f8XE7ZjscmX09ss5VBp4a2feMJKNcSxhNr5gdGo0EkSn9MLNlfIPtUcsNP+
         tVIom5S3MAhwqiaHfILY6cAHa6av2hothvWYeWrUonbT2HTFWWwL+/UlPloRQSlVa2
         J0Wzcf87zDgoFGhhYAchYLavpD7y4FzxyKI+jWAs=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH] cifs: Remove locking in smb2_verify_signature() when calculating SMB2/SMB3 signature on receiving packets
Date:   Wed, 25 Mar 2020 11:13:17 -0700
Message-Id: <1585159997-115196-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

On the sending and receiving paths, CIFS uses the same cypto data structures
to calculate SMB2/SMB3 packet signatures. A lock on the receiving path is
necessary to control shared access to crypto data structures. This lock
degrades performance because it races with the sending path.

Define separate crypto data structures for sending and receiving paths and
remove this lock.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifsencrypt.c   |  29 +++++----
 fs/cifs/cifsglob.h      |  21 +++++--
 fs/cifs/smb2proto.h     |   4 +-
 fs/cifs/smb2transport.c | 130 +++++++++++++++++++++++++---------------
 4 files changed, 119 insertions(+), 65 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 97b7497c13ef..222e8d13302c 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -804,16 +804,27 @@ calc_seckey(struct cifs_ses *ses)
 void
 cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 {
-	if (server->secmech.cmacaes) {
-		crypto_free_shash(server->secmech.cmacaes);
-		server->secmech.cmacaes = NULL;
-	}
+	int i;
+
+	for (i = CIFS_SECMECH_DIR_IN; i < CIFS_SECMECH_DIR_MAX; i++) {
+		if (server->secmech.cmacaes[i]) {
+			crypto_free_shash(server->secmech.cmacaes[i]);
+			server->secmech.cmacaes[i] = NULL;
+		}
 
-	if (server->secmech.hmacsha256) {
-		crypto_free_shash(server->secmech.hmacsha256);
-		server->secmech.hmacsha256 = NULL;
+		if (server->secmech.hmacsha256[i]) {
+			crypto_free_shash(server->secmech.hmacsha256[i]);
+			server->secmech.hmacsha256[i] = NULL;
+		}
+
+		kfree(server->secmech.sdesccmacaes[i]);
+		server->secmech.sdesccmacaes[i] = NULL;
+
+		kfree(server->secmech.sdeschmacsha256[i]);
+		server->secmech.sdeschmacsha256[i] = NULL;
 	}
 
+
 	if (server->secmech.md5) {
 		crypto_free_shash(server->secmech.md5);
 		server->secmech.md5 = NULL;
@@ -839,10 +850,6 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 		server->secmech.ccmaesdecrypt = NULL;
 	}
 
-	kfree(server->secmech.sdesccmacaes);
-	server->secmech.sdesccmacaes = NULL;
-	kfree(server->secmech.sdeschmacsha256);
-	server->secmech.sdeschmacsha256 = NULL;
 	kfree(server->secmech.sdeschmacmd5);
 	server->secmech.sdeschmacmd5 = NULL;
 	kfree(server->secmech.sdescmd5);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0d956360e984..e31a902ebadc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -137,17 +137,27 @@ struct sdesc {
 	char ctx[];
 };
 
+enum {
+	CIFS_SECMECH_DIR_IN = 0,
+	CIFS_SECMECH_DIR_OUT,
+	CIFS_SECMECH_DIR_MAX
+};
+
 /* crypto hashing related structure/fields, not specific to a sec mech */
 struct cifs_secmech {
 	struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
 	struct crypto_shash *md5; /* md5 hash function */
-	struct crypto_shash *hmacsha256; /* hmac-sha256 hash function */
-	struct crypto_shash *cmacaes; /* block-cipher based MAC function */
+	/* hmac-sha256 hash functions */
+	struct crypto_shash *hmacsha256[CIFS_SECMECH_DIR_MAX];
+	/* block-cipher based MAC function */
+	struct crypto_shash *cmacaes[CIFS_SECMECH_DIR_MAX];
 	struct crypto_shash *sha512; /* sha512 hash function */
 	struct sdesc *sdeschmacmd5;  /* ctxt to generate ntlmv2 hash, CR1 */
 	struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signature */
-	struct sdesc *sdeschmacsha256;  /* ctxt to generate smb2 signature */
-	struct sdesc *sdesccmacaes;  /* ctxt to generate smb3 signature */
+	/* ctxt to generate smb2 signature */
+	struct sdesc *sdeschmacsha256[CIFS_SECMECH_DIR_MAX];
+	/* ctxt to generate smb3 signature */
+	struct sdesc *sdesccmacaes[CIFS_SECMECH_DIR_MAX];
 	struct sdesc *sdescsha512; /* ctxt to generate smb3.11 signing key */
 	struct crypto_aead *ccmaesencrypt; /* smb3 encryption aead */
 	struct crypto_aead *ccmaesdecrypt; /* smb3 decryption aead */
@@ -426,7 +436,8 @@ struct smb_version_operations {
 	/* generate new lease key */
 	void (*new_lease_key)(struct cifs_fid *);
 	int (*generate_signingkey)(struct cifs_ses *);
-	int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *);
+	int (*calc_signature)(struct smb_rqst *, struct TCP_Server_Info *,
+			      int direction);
 	int (*set_integrity)(const unsigned int, struct cifs_tcon *tcon,
 			     struct cifsFileInfo *src_file);
 	int (*enum_snapshots)(const unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 4d1ff7b66fdc..f5edd6ea3639 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -55,9 +55,9 @@ extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
 extern struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 						__u64 ses_id, __u32  tid);
 extern int smb2_calc_signature(struct smb_rqst *rqst,
-				struct TCP_Server_Info *server);
+				struct TCP_Server_Info *server, int direction);
 extern int smb3_calc_signature(struct smb_rqst *rqst,
-				struct TCP_Server_Info *server);
+				struct TCP_Server_Info *server, int direction);
 extern void smb2_echo_request(struct work_struct *work);
 extern __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode);
 extern bool smb2_is_valid_oplock_break(char *buffer,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 08b703b7a15e..c8ba40d8fedf 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -43,30 +43,51 @@
 static int
 smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
-	return cifs_alloc_hash("hmac(sha256)",
-			       &server->secmech.hmacsha256,
-			       &server->secmech.sdeschmacsha256);
+	int i, rc;
+
+	for (i = CIFS_SECMECH_DIR_IN; i < CIFS_SECMECH_DIR_MAX; i++) {
+		rc = cifs_alloc_hash("hmac(sha256)",
+			       &server->secmech.hmacsha256[i],
+			       &server->secmech.sdeschmacsha256[i]);
+		if (rc)
+			goto fail;
+	}
+	return 0;
+
+fail:
+	for (i = CIFS_SECMECH_DIR_IN; i < CIFS_SECMECH_DIR_MAX; i++)
+		cifs_free_hash(
+		       &server->secmech.hmacsha256[i],
+		       &server->secmech.sdeschmacsha256[i]);
+	return rc;
 }
 
 static int
 smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p = &server->secmech;
-	int rc;
+	int i, rc;
 
-	rc = cifs_alloc_hash("hmac(sha256)",
-			     &p->hmacsha256,
-			     &p->sdeschmacsha256);
-	if (rc)
-		goto err;
+	for (i = CIFS_SECMECH_DIR_IN; i < CIFS_SECMECH_DIR_MAX; i++) {
+		rc = cifs_alloc_hash("hmac(sha256)",
+			     &p->hmacsha256[i],
+			     &p->sdeschmacsha256[i]);
+		if (rc)
+			goto fail;
 
-	rc = cifs_alloc_hash("cmac(aes)", &p->cmacaes, &p->sdesccmacaes);
-	if (rc)
-		goto err;
+		rc = cifs_alloc_hash("cmac(aes)",
+			&p->cmacaes[i], &p->sdesccmacaes[i]);
 
+		if (rc)
+			goto fail;
+	}
 	return 0;
-err:
-	cifs_free_hash(&p->hmacsha256, &p->sdeschmacsha256);
+
+fail:
+	for (i = CIFS_SECMECH_DIR_IN; i < CIFS_SECMECH_DIR_MAX; i++) {
+		cifs_free_hash(&p->hmacsha256[i], &p->sdeschmacsha256[i]);
+		cifs_free_hash(&p->cmacaes[i], &p->sdesccmacaes[i]);
+	}
 	return rc;
 }
 
@@ -74,27 +95,32 @@ int
 smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p = &server->secmech;
-	int rc = 0;
+	int i, rc = 0;
 
-	rc = cifs_alloc_hash("hmac(sha256)",
-			     &p->hmacsha256,
-			     &p->sdeschmacsha256);
-	if (rc)
-		return rc;
+	for (i = CIFS_SECMECH_DIR_IN; i < CIFS_SECMECH_DIR_MAX; i++) {
+		rc = cifs_alloc_hash("hmac(sha256)",
+			     &p->hmacsha256[i],
+			     &p->sdeschmacsha256[i]);
+		if (rc)
+			goto fail;
 
-	rc = cifs_alloc_hash("cmac(aes)", &p->cmacaes, &p->sdesccmacaes);
-	if (rc)
-		goto err;
+		rc = cifs_alloc_hash("cmac(aes)",
+			&p->cmacaes[i], &p->sdesccmacaes[i]);
+		if (rc)
+			goto fail;
+	}
 
 	rc = cifs_alloc_hash("sha512", &p->sha512, &p->sdescsha512);
 	if (rc)
-		goto err;
+		goto fail;
 
 	return 0;
 
-err:
-	cifs_free_hash(&p->cmacaes, &p->sdesccmacaes);
-	cifs_free_hash(&p->hmacsha256, &p->sdeschmacsha256);
+fail:
+	for (i = CIFS_SECMECH_DIR_IN; i < CIFS_SECMECH_DIR_MAX; i++) {
+		cifs_free_hash(&p->hmacsha256[i], &p->sdeschmacsha256[i]);
+		cifs_free_hash(&p->cmacaes[i], &p->sdesccmacaes[i]);
+	}
 	return rc;
 }
 
@@ -219,7 +245,8 @@ smb2_find_smb_tcon(struct TCP_Server_Info *server, __u64 ses_id, __u32  tid)
 }
 
 int
-smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
+smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
+		    int direction)
 {
 	int rc;
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
@@ -229,6 +256,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	struct cifs_ses *ses;
 	struct shash_desc *shash;
 	struct smb_rqst drqst;
+	struct crypto_shash *hmacsha256;
 
 	ses = smb2_find_smb_ses(server, shdr->SessionId);
 	if (!ses) {
@@ -245,14 +273,16 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		return rc;
 	}
 
-	rc = crypto_shash_setkey(server->secmech.hmacsha256,
+	hmacsha256 = server->secmech.hmacsha256[direction];
+
+	rc = crypto_shash_setkey(hmacsha256,
 				 ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
-	shash = &server->secmech.sdeschmacsha256->shash;
+	shash = &server->secmech.sdeschmacsha256[direction]->shash;
 	rc = crypto_shash_init(shash);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not init sha256", __func__);
@@ -296,6 +326,8 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 	unsigned char prfhash[SMB2_HMACSHA256_SIZE];
 	unsigned char *hashptr = prfhash;
 	struct TCP_Server_Info *server = ses->server;
+	struct crypto_shash *hmacsha256;
+	struct sdesc *sdeschmacsha256;
 
 	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(key, 0x0, key_size);
@@ -306,55 +338,58 @@ static int generate_key(struct cifs_ses *ses, struct kvec label,
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_setkey(server->secmech.hmacsha256,
+	hmacsha256 = server->secmech.hmacsha256[CIFS_SECMECH_DIR_OUT];
+	sdeschmacsha256 = server->secmech.sdeschmacsha256[CIFS_SECMECH_DIR_OUT];
+
+	rc = crypto_shash_setkey(hmacsha256,
 		ses->auth_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set with session key\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
+	rc = crypto_shash_init(&sdeschmacsha256->shash);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not init sign hmac\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
+	rc = crypto_shash_update(&sdeschmacsha256->shash,
 				i, 4);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with n\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
+	rc = crypto_shash_update(&sdeschmacsha256->shash,
 				label.iov_base, label.iov_len);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with label\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
+	rc = crypto_shash_update(&sdeschmacsha256->shash,
 				&zero, 1);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with zero\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
+	rc = crypto_shash_update(&sdeschmacsha256->shash,
 				context.iov_base, context.iov_len);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with context\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
+	rc = crypto_shash_update(&sdeschmacsha256->shash,
 				L, 4);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not update with L\n", __func__);
 		goto smb3signkey_ret;
 	}
 
-	rc = crypto_shash_final(&server->secmech.sdeschmacsha256->shash,
+	rc = crypto_shash_final(&sdeschmacsha256->shash,
 				hashptr);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not generate sha256 hash\n", __func__);
@@ -504,16 +539,18 @@ generate_smb311signingkey(struct cifs_ses *ses)
 }
 
 int
-smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
+smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
+		    int direction)
 {
 	int rc;
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	unsigned char *sigptr = smb3_signature;
 	struct kvec *iov = rqst->rq_iov;
 	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[0].iov_base;
-	struct shash_desc *shash = &server->secmech.sdesccmacaes->shash;
+	struct shash_desc *shash;
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
+	struct crypto_shash *cmacaes;
 
 	rc = smb2_get_sign_key(shdr->SessionId, server, key);
 	if (rc)
@@ -522,8 +559,10 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
-	rc = crypto_shash_setkey(server->secmech.cmacaes,
-				 key, SMB2_CMACAES_SIZE);
+	cmacaes = server->secmech.cmacaes[direction];
+	shash = &server->secmech.sdesccmacaes[direction]->shash;
+
+	rc = crypto_shash_setkey(cmacaes, key, SMB2_CMACAES_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
 		return rc;
@@ -593,8 +632,7 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		return 0;
 	}
 
-	rc = server->ops->calc_signature(rqst, server);
-
+	rc = server->ops->calc_signature(rqst, server, CIFS_SECMECH_DIR_OUT);
 	return rc;
 }
 
@@ -631,9 +669,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 
 	memset(shdr->Signature, 0, SMB2_SIGNATURE_SIZE);
 
-	mutex_lock(&server->srv_mutex);
-	rc = server->ops->calc_signature(rqst, server);
-	mutex_unlock(&server->srv_mutex);
+	rc = server->ops->calc_signature(rqst, server, CIFS_SECMECH_DIR_IN);
 
 	if (rc)
 		return rc;
-- 
2.17.1

