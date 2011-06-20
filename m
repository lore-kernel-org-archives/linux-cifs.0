From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Cleanup: check return codes of crypto api calls
Date: Mon, 20 Jun 2011 16:14:03 -0500
Message-ID: <1308604443-16036-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Check return codes of crypto api calls and either log an error or log
an error and return from the calling function with error.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |  110 +++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/link.c        |    8 +++-
 fs/cifs/smbencrypt.c  |    8 +++-
 3 files changed, 103 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5a0ee7f..259991b 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -52,19 +52,29 @@ static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 
 	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Oould not init md5\n", __func__);
+		cERROR(1, "%s: Could not init md5\n", __func__);
 		return rc;
 	}
 
-	crypto_shash_update(&server->secmech.sdescmd5->shash,
+	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
 		server->session_key.response, server->session_key.len);
+	if (rc) {
+		cERROR(1, "%s: Could not update with response\n", __func__);
+		return rc;
+	}
 
-	crypto_shash_update(&server->secmech.sdescmd5->shash,
+	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
 		cifs_pdu->Protocol, be32_to_cpu(cifs_pdu->smb_buf_length));
+	if (rc) {
+		cERROR(1, "%s: Could not update with payload\n", __func__);
+		return rc;
+	}
 
 	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
+	if (rc)
+		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
 
-	return 0;
+	return rc;
 }
 
 /* must be called with server->srv_mutex held */
@@ -112,12 +122,16 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 
 	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Oould not init md5\n", __func__);
+		cERROR(1, "%s: Could not init md5\n", __func__);
 		return rc;
 	}
 
-	crypto_shash_update(&server->secmech.sdescmd5->shash,
+	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
 		server->session_key.response, server->session_key.len);
+	if (rc) {
+		cERROR(1, "%s: Could not update with response\n", __func__);
+		return rc;
+	}
 
 	for (i = 0; i < n_vec; i++) {
 		if (iov[i].iov_len == 0)
@@ -131,14 +145,24 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (i == 0) {
 			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
 				break; /* nothing to sign or corrupt header */
+			rc =
 			crypto_shash_update(&server->secmech.sdescmd5->shash,
 				iov[i].iov_base + 4, iov[i].iov_len - 4);
-		} else
+		} else {
+			rc =
 			crypto_shash_update(&server->secmech.sdescmd5->shash,
 				iov[i].iov_base, iov[i].iov_len);
+		}
+		if (rc) {
+			cERROR(1, "%s: Could not update with payload\n",
+							__func__);
+			return rc;
+		}
 	}
 
 	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
+	if (rc)
+		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
 
 	return rc;
 }
@@ -463,8 +487,12 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash);
 
-	crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
+	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
 				CIFS_NTHASH_SIZE);
+	if (rc) {
+		cERROR(1, "%s: Could not set NT Hash as a key", __func__);
+		return rc;
+	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
@@ -478,13 +506,18 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	if (user == NULL) {
 		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure\n");
 		rc = -ENOMEM;
-		goto calc_exit_2;
+		return rc;
 	}
 	len = cifs_strtoUCS((__le16 *)user, ses->user_name, len, nls_cp);
 	UniStrupr(user);
 
-	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 				(char *)user, 2 * len);
+	kfree(user);
+	if (rc) {
+		cERROR(1, "%s: Could not update with user\n", __func__);
+		return rc;
+	}
 
 	/* convert ses->domainName to unicode and uppercase */
 	if (ses->domainName) {
@@ -494,13 +527,19 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		if (domain == NULL) {
 			cERROR(1, "calc_ntlmv2_hash: domain mem alloc failure");
 			rc = -ENOMEM;
-			goto calc_exit_1;
+			return rc;
 		}
 		len = cifs_strtoUCS((__le16 *)domain, ses->domainName, len,
 					nls_cp);
+		rc =
 		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 					(char *)domain, 2 * len);
 		kfree(domain);
+		if (rc) {
+			cERROR(1, "%s: Could not update with domain\n",
+								__func__);
+			return rc;
+		}
 	} else if (ses->serverName) {
 		len = strlen(ses->serverName);
 
@@ -508,21 +547,26 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 		if (server == NULL) {
 			cERROR(1, "calc_ntlmv2_hash: server mem alloc failure");
 			rc = -ENOMEM;
-			goto calc_exit_1;
+			return rc;
 		}
 		len = cifs_strtoUCS((__le16 *)server, ses->serverName, len,
 					nls_cp);
+		rc =
 		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 					(char *)server, 2 * len);
 		kfree(server);
+		if (rc) {
+			cERROR(1, "%s: Could not update with server\n",
+								__func__);
+			return rc;
+		}
 	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 					ntlmv2_hash);
+	if (rc)
+		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
 
-calc_exit_1:
-	kfree(user);
-calc_exit_2:
 	return rc;
 }
 
@@ -537,8 +581,12 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 		return -1;
 	}
 
-	crypto_shash_setkey(ses->server->secmech.hmacmd5,
+	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
 				ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+	if (rc) {
+		cERROR(1, "%s: Could not set NTLMV2 Hash as a key", __func__);
+		return rc;
+	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
@@ -552,11 +600,17 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	else
 		memcpy(ses->auth_key.response + offset,
 			ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
-	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + offset, ses->auth_key.len - offset);
+	if (rc) {
+		cERROR(1, "%s: Could not update with response\n", __func__);
+		return rc;
+	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + CIFS_SESS_KEY_SIZE);
+	if (rc)
+		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
 
 	return rc;
 }
@@ -626,8 +680,12 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	}
 
 	/* now calculate the session key for NTLMv2 */
-	crypto_shash_setkey(ses->server->secmech.hmacmd5,
+	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
 		ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+	if (rc) {
+		cERROR(1, "%s: Could not set NTLMV2 Hash as a key", __func__);
+		goto setup_ntlmv2_rsp_ret;
+	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
@@ -635,12 +693,18 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		goto setup_ntlmv2_rsp_ret;
 	}
 
-	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + CIFS_SESS_KEY_SIZE,
 		CIFS_HMAC_MD5_HASH_SIZE);
+	if (rc) {
+		cERROR(1, "%s: Could not update with response\n", __func__);
+		goto setup_ntlmv2_rsp_ret;
+	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response);
+	if (rc)
+		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
 
 setup_ntlmv2_rsp_ret:
 	kfree(tiblob);
@@ -668,8 +732,12 @@ calc_seckey(struct cifs_ses *ses)
 
 	desc.tfm = tfm_arc4;
 
-	crypto_blkcipher_setkey(tfm_arc4, ses->auth_key.response,
+	rc = crypto_blkcipher_setkey(tfm_arc4, ses->auth_key.response,
 					CIFS_SESS_KEY_SIZE);
+	if (rc) {
+		cERROR(1, "%s: Could not set response as a key", __func__);
+		return rc;
+	}
 
 	sg_init_one(&sgin, sec_key, CIFS_SESS_KEY_SIZE);
 	sg_init_one(&sgout, ses->ntlmssp->ciphertext, CIFS_CPHTXT_SIZE);
@@ -688,7 +756,7 @@ calc_seckey(struct cifs_ses *ses)
 
 	crypto_free_blkcipher(tfm_arc4);
 
-	return 0;
+	return rc;
 }
 
 void
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 556b1a0..db3f18c 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -74,8 +74,14 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 		cERROR(1, "%s: Could not init md5 shash\n", __func__);
 		goto symlink_hash_err;
 	}
-	crypto_shash_update(&sdescmd5->shash, link_str, link_len);
+	rc = crypto_shash_update(&sdescmd5->shash, link_str, link_len);
+	if (rc) {
+		cERROR(1, "%s: Could not update iwth link_str\n", __func__);
+		goto symlink_hash_err;
+	}
 	rc = crypto_shash_final(&sdescmd5->shash, md5_hash);
+	if (rc)
+		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
 
 symlink_hash_err:
 	crypto_free_shash(md5);
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 1525d5e..c857a31 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -159,8 +159,14 @@ mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
 		cERROR(1, "%s: Could not init md4 shash\n", __func__);
 		goto mdfour_err;
 	}
-	crypto_shash_update(&sdescmd4->shash, link_str, link_len);
+	rc = crypto_shash_update(&sdescmd4->shash, link_str, link_len);
+	if (rc) {
+		cERROR(1, "%s: Could not update with link_str\n", __func__);
+		goto mdfour_err;
+	}
 	rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
+	if (rc)
+		cERROR(1, "%s: Could not genereate md4 hash\n", __func__);
 
 mdfour_err:
 	crypto_free_shash(md4);
-- 
1.6.0.2
