From: shirishpargaonkar@gmail.com
Subject: [linux-cifs-client][PATCH] Eliminate sparse warning - bad constant expression
Date: Tue, 24 Aug 2010 10:01:32 -0500
Message-ID: <1282662092-4785-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-cifs@vger.kernel.org,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: smfrench@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Eliminiate sparse warning during usage of crypto_shash_* APIs
	error: bad constant expression


>From 952f73a6813c119f78c657bdb40d1ee741efb3c2 Mon Sep 17 00:00:00 2001
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date: Tue, 24 Aug 2010 09:49:57 -0500
Subject: [PATCH] eliminate sparse warnings during crypto_shash_* APis usage

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
---
 fs/cifs/cifsencrypt.c |  185 ++++++++++++++++++++++++++++++++-----------------
 fs/cifs/cifsglob.h    |    5 ++
 2 files changed, 125 insertions(+), 65 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index eef78c2..3f2b2f3 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -46,37 +46,46 @@ static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 			struct TCP_Server_Info *server, char *signature)
 {
 	int rc = 0;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(server->ntlmssp.md5)];
-	} sdesc;
+	unsigned int size;
+	struct sdesc *sdesc;
 
 	if (cifs_pdu == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	sdesc.shash.tfm = server->ntlmssp.md5;
-	sdesc.shash.flags = 0x0;
+	size = sizeof(struct shash_desc) +
+				crypto_shash_descsize(server->ntlmssp.md5);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc) {
+		cERROR(1,
+			"cifs_calculate_signature: could not initialize md5\n");
+		return -ENOMEM;
+	}
+
+	sdesc->shash.tfm = server->ntlmssp.md5;
+	sdesc->shash.flags = 0x0;
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&sdesc->shash);
 	if (rc) {
 		cERROR(1, "could not initialize master crypto API hmacmd5\n");
-		return rc;
+		goto calc_sig_ret;
 	}
 
 	if (server->secType == RawNTLMSSP)
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&sdesc->shash,
 			server->session_key.data.ntlmv2.key,
 			CIFS_NTLMV2_SESSKEY_SIZE);
 	else
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&sdesc->shash,
 			(char *)&server->session_key.data,
 			server->session_key.len);
 
-	crypto_shash_update(&sdesc.shash,
+	crypto_shash_update(&sdesc->shash,
 			cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
 
-	rc = crypto_shash_final(&sdesc.shash, signature);
+	rc = crypto_shash_final(&sdesc->shash, signature);
 
+calc_sig_ret:
+	kfree(sdesc);
 	return 0;
 }
 
@@ -116,29 +125,36 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 {
 	int i;
 	int rc = 0;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(server->ntlmssp.md5)];
-	} sdesc;
+	unsigned int size;
+	struct sdesc *sdesc;
 
 	if (iov == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	sdesc.shash.tfm = server->ntlmssp.md5;
-	sdesc.shash.flags = 0x0;
+	size = sizeof(struct shash_desc) +
+				crypto_shash_descsize(server->ntlmssp.md5);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc) {
+		cERROR(1,
+			"cifs_calc_signature2: could not initialize md5\n");
+		return -ENOMEM;
+	}
+
+	sdesc->shash.tfm = server->ntlmssp.md5;
+	sdesc->shash.flags = 0x0;
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&sdesc->shash);
 	if (rc) {
 		cERROR(1, "could not initialize master crypto API hmacmd5\n");
-		return rc;
+		goto calc_sig2_ret;
 	}
 
 	if (server->secType == RawNTLMSSP)
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&sdesc->shash,
 			server->session_key.data.ntlmv2.key,
 			CIFS_NTLMV2_SESSKEY_SIZE);
 	else
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&sdesc->shash,
 			(char *)&server->session_key.data,
 			server->session_key.len);
 
@@ -147,22 +163,25 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 			continue;
 		if (iov[i].iov_base == NULL) {
 			cERROR(1, "null iovec entry");
-			return -EIO;
+			rc = -EIO;
+			goto calc_sig2_ret;
 		}
 		/* The first entry includes a length field (which does not get
 		   signed that occupies the first 4 bytes before the header */
 		if (i == 0) {
 			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
 				break; /* nothing to sign or corrupt header */
-			crypto_shash_update(&sdesc.shash,
+			crypto_shash_update(&sdesc->shash,
 				iov[i].iov_base + 4, iov[i].iov_len - 4);
 		} else
-			crypto_shash_update(&sdesc.shash,
+			crypto_shash_update(&sdesc->shash,
 				iov[i].iov_base, iov[i].iov_len);
 	}
 
-	rc = crypto_shash_final(&sdesc.shash, signature);
+	rc = crypto_shash_final(&sdesc->shash, signature);
 
+calc_sig2_ret:
+	kfree(sdesc);
 	return 0;
 }
 
@@ -309,47 +328,60 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 {
 	int rc = 0;
 	int len;
+	unsigned int size;
 	char nt_hash[CIFS_NTHASH_SIZE];
 	wchar_t *user;
 	wchar_t *domain;
 	wchar_t *server;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
-	} sdesc;
+	struct sdesc *sdesc;
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(ses->server->ntlmssp.hmacmd5);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc) {
+		cERROR(1, "calc_ntlmv2_hash: could not initialize hmacmd5\n");
+		return -ENOMEM;
+	}
 
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash);
 
-	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
-	sdesc.shash.flags = 0x0;
+	sdesc->shash.tfm = ses->server->ntlmssp.hmacmd5;
+	sdesc->shash.flags = 0x0;
 
 	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5, nt_hash,
 				CIFS_NTHASH_SIZE);
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&sdesc->shash);
 	if (rc) {
-		cERROR(1, "could not initialize master crypto API hmacmd5\n");
-		return rc;
+		cERROR(1, "calc_ntlmv2_hash: could not initialize hmacmd5\n");
+		goto calc_exit_2;
 	}
 
 	/* convert ses->userName to unicode and uppercase */
 	len = strlen(ses->userName);
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
-	if (user == NULL)
+	if (user == NULL) {
+		cERROR(1, "calc_ntlmv2_hash: user memory alloc failure\n");
+		rc = -ENOMEM;
 		goto calc_exit_2;
+	}
 	len = cifs_strtoUCS((__le16 *)user, ses->userName, len, nls_cp);
 	UniStrupr(user);
 
-	crypto_shash_update(&sdesc.shash, (char *)user, 2 * len);
+	crypto_shash_update(&sdesc->shash, (char *)user, 2 * len);
 
 	/* convert ses->domainName to unicode and uppercase */
 	if (ses->domainName) {
 		len = strlen(ses->domainName);
 
 		domain = kmalloc(2 + (len * 2), GFP_KERNEL);
-		if (domain == NULL)
+		if (domain == NULL) {
+			cERROR(1,
+				"calc_ntlmv2_hash: domain mem alloc failure\n");
+			rc = -ENOMEM;
 			goto calc_exit_1;
+		}
 		len = cifs_strtoUCS((__le16 *)domain, ses->domainName, len,
 					nls_cp);
 		/* the following line was removed since it didn't work well
@@ -357,15 +389,19 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		crypto_shash_update(&sdesc.shash, (char *)domain, 2 * len);
+		crypto_shash_update(&sdesc->shash, (char *)domain, 2 * len);
 
 		kfree(domain);
 	} else if (ses->serverName) {
 		len = strlen(ses->serverName);
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
-		if (server == NULL)
+		if (server == NULL) {
+			cERROR(1,
+				"calc_ntlmv2_hash: server mem alloc failure\n");
+			rc = -ENOMEM;
 			goto calc_exit_1;
+		}
 		len = cifs_strtoUCS((__le16 *)server, ses->serverName, len,
 					nls_cp);
 		/* the following line was removed since it didn't work well
@@ -373,16 +409,19 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		crypto_shash_update(&sdesc.shash, (char *)server, 2 * len);
+		crypto_shash_update(&sdesc->shash, (char *)server, 2 * len);
 
 		kfree(server);
 	}
+
+	rc = crypto_shash_final(&sdesc->shash, ses->server->ntlmv2_hash);
+
 calc_exit_1:
 	kfree(user);
 calc_exit_2:
 	/* BB FIXME what about bytes 24 through 40 of the signing key?
 	   compare with the NTLM example */
-	rc = crypto_shash_final(&sdesc.shash, ses->server->ntlmv2_hash);
+	kfree(sdesc);
 
 	return rc;
 }
@@ -442,35 +481,43 @@ CalcNTLMv2_response(const struct TCP_Server_Info *server,
 			 char *v2_session_response)
 {
 	int rc;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(server->ntlmssp.hmacmd5)];
-	} sdesc;
+	unsigned int size;
+	struct sdesc *sdesc;
+
+	size = sizeof(struct shash_desc) +
+				crypto_shash_descsize(server->ntlmssp.hmacmd5);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc) {
+		cERROR(1, "CalcNTLMv2_response: could not initialize hmacmd5");
+		return -ENOMEM;
+	}
 
-	sdesc.shash.tfm = server->ntlmssp.hmacmd5;
-	sdesc.shash.flags = 0x0;
+	sdesc->shash.tfm = server->ntlmssp.hmacmd5;
+	sdesc->shash.flags = 0x0;
 
 	crypto_shash_setkey(server->ntlmssp.hmacmd5, server->ntlmv2_hash,
 		CIFS_HMAC_MD5_HASH_SIZE);
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&sdesc->shash);
 	if (rc) {
-		cERROR(1, "could not initialize master crypto API hmacmd5\n");
-		return rc;
+		cERROR(1, "CalcNTLMv2_response: could not initialize hmacmd5");
+		goto calc_ntlmv2_resp_ret;
 	}
 
 	memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
 		server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
-	crypto_shash_update(&sdesc.shash,
+	crypto_shash_update(&sdesc->shash,
 		v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
 		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE);
 
 	if (server->tilen)
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&sdesc->shash,
 					server->tiblob, server->tilen);
 
-	rc = crypto_shash_final(&sdesc.shash, v2_session_response);
+	rc = crypto_shash_final(&sdesc->shash, v2_session_response);
 
+calc_ntlmv2_resp_ret:
+	kfree(sdesc);
 	return rc;
 }
 
@@ -479,11 +526,9 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 		      const struct nls_table *nls_cp)
 {
 	int rc = 0;
+	unsigned int size;
 	struct ntlmv2_resp *buf = (struct ntlmv2_resp *)resp_buf;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
-	} sdesc;
+	struct sdesc *sdesc;
 
 	buf->blob_signature = cpu_to_le32(0x00000101);
 	buf->reserved = 0;
@@ -511,27 +556,37 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 		return rc;
 	}
 
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(ses->server->ntlmssp.hmacmd5);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc) {
+		cERROR(1, "setup_ntlmv2_rsp: could not initialize hmacmd5\n");
+		return -ENOMEM;
+	}
+
 	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5,
 			ses->server->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 
-	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
-	sdesc.shash.flags = 0x0;
+	sdesc->shash.tfm = ses->server->ntlmssp.hmacmd5;
+	sdesc->shash.flags = 0x0;
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&sdesc->shash);
 	if (rc) {
-		cERROR(1, "could not initialize master crypto API hmacmd5\n");
-		return rc;
+		cERROR(1, "setup_ntlmv2_rsp: could not initialize hmacmd5\n");
+		goto setup_ntlmv2_resp_ret;
 	}
 
-	crypto_shash_update(&sdesc.shash, resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
+	crypto_shash_update(&sdesc->shash, resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
 
-	rc = crypto_shash_final(&sdesc.shash,
+	rc = crypto_shash_final(&sdesc->shash,
 		ses->server->session_key.data.ntlmv2.key);
 
 	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
 			sizeof(struct ntlmv2_resp));
 	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
 
+setup_ntlmv2_resp_ret:
+	kfree(sdesc);
 	return rc;
 }
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 49563e0..634c85d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -131,6 +131,11 @@ struct ntlmssp_auth {
 	struct crypto_shash *md5;
 };
 
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
 /*
  *****************************************************************
  * Except the CIFS PDUs themselves all the
-- 
1.6.0.2
