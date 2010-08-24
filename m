From: shirishpargaonkar@gmail.com
Subject: [linux-cifs-client][PATCH][Try 2] Eliminate sparse warning - bad constant expression
Date: Tue, 24 Aug 2010 11:53:48 -0500
Message-ID: <1282668828-7336-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-cifs@vger.kernel.org,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: smfrench@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Eliminiate sparse warning during usage of crypto_shash_* APIs
       error: bad constant expression

Allocate memory for shash descriptors once, so that we do not kmalloc/kfree it
for every signature generation (shash descriptor for md5 hash).


>From ed7538619817777decc44b5660b52268077b74f3 Mon Sep 17 00:00:00 2001
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date: Tue, 24 Aug 2010 11:47:43 -0500
Subject: [PATCH] eliminate sparse warnings during crypto_shash_* APis usage

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
---
 fs/cifs/cifsencrypt.c |  193 +++++++++++++++++++++++++++++++------------------
 fs/cifs/cifsglob.h    |    7 ++
 2 files changed, 128 insertions(+), 72 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index eef78c2..709f229 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -45,39 +45,38 @@ extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 			struct TCP_Server_Info *server, char *signature)
 {
-	int rc = 0;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(server->ntlmssp.md5)];
-	} sdesc;
+	int rc;
 
 	if (cifs_pdu == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	sdesc.shash.tfm = server->ntlmssp.md5;
-	sdesc.shash.flags = 0x0;
+	if (!server->ntlmssp.sdescmd5) {
+		cERROR(1,
+			"cifs_calculate_signature: can't generate signature\n");
+		return -1;
+	}
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&server->ntlmssp.sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		cERROR(1, "cifs_calculate_signature: oould not init md5\n");
 		return rc;
 	}
 
 	if (server->secType == RawNTLMSSP)
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
 			server->session_key.data.ntlmv2.key,
 			CIFS_NTLMV2_SESSKEY_SIZE);
 	else
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
 			(char *)&server->session_key.data,
 			server->session_key.len);
 
-	crypto_shash_update(&sdesc.shash,
+	crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
 			cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
 
-	rc = crypto_shash_final(&sdesc.shash, signature);
+	rc = crypto_shash_final(&server->ntlmssp.sdescmd5->shash, signature);
 
-	return 0;
+	return rc;
 }
 
 
@@ -115,30 +114,28 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 			struct TCP_Server_Info *server, char *signature)
 {
 	int i;
-	int rc = 0;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(server->ntlmssp.md5)];
-	} sdesc;
+	int rc;
 
 	if (iov == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	sdesc.shash.tfm = server->ntlmssp.md5;
-	sdesc.shash.flags = 0x0;
+	if (!server->ntlmssp.sdescmd5) {
+		cERROR(1, "cifs_calc_signature2: can't generate signature\n");
+		return -1;
+	}
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&server->ntlmssp.sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		cERROR(1, "cifs_calc_signature2: oould not init md5\n");
 		return rc;
 	}
 
 	if (server->secType == RawNTLMSSP)
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
 			server->session_key.data.ntlmv2.key,
 			CIFS_NTLMV2_SESSKEY_SIZE);
 	else
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
 			(char *)&server->session_key.data,
 			server->session_key.len);
 
@@ -146,7 +143,7 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (iov[i].iov_len == 0)
 			continue;
 		if (iov[i].iov_base == NULL) {
-			cERROR(1, "null iovec entry");
+			cERROR(1, "cifs_calc_signature2: null iovec entry");
 			return -EIO;
 		}
 		/* The first entry includes a length field (which does not get
@@ -154,16 +151,16 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (i == 0) {
 			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
 				break; /* nothing to sign or corrupt header */
-			crypto_shash_update(&sdesc.shash,
+			crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
 				iov[i].iov_base + 4, iov[i].iov_len - 4);
 		} else
-			crypto_shash_update(&sdesc.shash,
+			crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
 				iov[i].iov_base, iov[i].iov_len);
 	}
 
-	rc = crypto_shash_final(&sdesc.shash, signature);
+	rc = crypto_shash_final(&server->ntlmssp.sdescmd5->shash, signature);
 
-	return 0;
+	return rc;
 }
 
 int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
@@ -313,43 +310,48 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 	wchar_t *user;
 	wchar_t *domain;
 	wchar_t *server;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
-	} sdesc;
+
+	if (!ses->server->ntlmssp.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
 
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash);
 
-	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
-	sdesc.shash.flags = 0x0;
-
 	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5, nt_hash,
 				CIFS_NTHASH_SIZE);
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&ses->server->ntlmssp.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		cERROR(1, "calc_ntlmv2_hash: could not init hmacmd5\n");
 		return rc;
 	}
 
 	/* convert ses->userName to unicode and uppercase */
 	len = strlen(ses->userName);
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
-	if (user == NULL)
+	if (user == NULL) {
+		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure\n");
+		rc = -ENOMEM;
 		goto calc_exit_2;
+	}
 	len = cifs_strtoUCS((__le16 *)user, ses->userName, len, nls_cp);
 	UniStrupr(user);
 
-	crypto_shash_update(&sdesc.shash, (char *)user, 2 * len);
+	crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
+				(char *)user, 2 * len);
 
 	/* convert ses->domainName to unicode and uppercase */
 	if (ses->domainName) {
 		len = strlen(ses->domainName);
 
 		domain = kmalloc(2 + (len * 2), GFP_KERNEL);
-		if (domain == NULL)
+		if (domain == NULL) {
+			cERROR(1, "calc_ntlmv2_hash: domain mem alloc failure");
+			rc = -ENOMEM;
 			goto calc_exit_1;
+		}
 		len = cifs_strtoUCS((__le16 *)domain, ses->domainName, len,
 					nls_cp);
 		/* the following line was removed since it didn't work well
@@ -357,15 +359,19 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		crypto_shash_update(&sdesc.shash, (char *)domain, 2 * len);
+		crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
+					(char *)domain, 2 * len);
 
 		kfree(domain);
 	} else if (ses->serverName) {
 		len = strlen(ses->serverName);
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
-		if (server == NULL)
+		if (server == NULL) {
+			cERROR(1, "calc_ntlmv2_hash: server mem alloc failure");
+			rc = -ENOMEM;
 			goto calc_exit_1;
+		}
 		len = cifs_strtoUCS((__le16 *)server, ses->serverName, len,
 					nls_cp);
 		/* the following line was removed since it didn't work well
@@ -373,16 +379,20 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		crypto_shash_update(&sdesc.shash, (char *)server, 2 * len);
+		crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
+					(char *)server, 2 * len);
 
 		kfree(server);
 	}
+
+	rc = crypto_shash_final(&ses->server->ntlmssp.sdeschmacmd5->shash,
+					ses->server->ntlmv2_hash);
+
 calc_exit_1:
 	kfree(user);
 calc_exit_2:
 	/* BB FIXME what about bytes 24 through 40 of the signing key?
 	   compare with the NTLM example */
-	rc = crypto_shash_final(&sdesc.shash, ses->server->ntlmv2_hash);
 
 	return rc;
 }
@@ -442,34 +452,33 @@ CalcNTLMv2_response(const struct TCP_Server_Info *server,
 			 char *v2_session_response)
 {
 	int rc;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(server->ntlmssp.hmacmd5)];
-	} sdesc;
 
-	sdesc.shash.tfm = server->ntlmssp.hmacmd5;
-	sdesc.shash.flags = 0x0;
+	if (!server->ntlmssp.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
 
 	crypto_shash_setkey(server->ntlmssp.hmacmd5, server->ntlmv2_hash,
 		CIFS_HMAC_MD5_HASH_SIZE);
 
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&server->ntlmssp.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		cERROR(1, "CalcNTLMv2_response: could not init hmacmd5");
 		return rc;
 	}
 
 	memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
 		server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
-	crypto_shash_update(&sdesc.shash,
+	crypto_shash_update(&server->ntlmssp.sdeschmacmd5->shash,
 		v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
 		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE);
 
 	if (server->tilen)
-		crypto_shash_update(&sdesc.shash,
+		crypto_shash_update(&server->ntlmssp.sdeschmacmd5->shash,
 					server->tiblob, server->tilen);
 
-	rc = crypto_shash_final(&sdesc.shash, v2_session_response);
+	rc = crypto_shash_final(&server->ntlmssp.sdeschmacmd5->shash,
+					v2_session_response);
 
 	return rc;
 }
@@ -480,10 +489,6 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 {
 	int rc = 0;
 	struct ntlmv2_resp *buf = (struct ntlmv2_resp *)resp_buf;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
-	} sdesc;
 
 	buf->blob_signature = cpu_to_le32(0x00000101);
 	buf->reserved = 0;
@@ -511,21 +516,24 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 		return rc;
 	}
 
+	if (!ses->server->ntlmssp.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
+
 	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5,
 			ses->server->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 
-	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
-	sdesc.shash.flags = 0x0;
-
-	rc = crypto_shash_init(&sdesc.shash);
+	rc = crypto_shash_init(&ses->server->ntlmssp.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		cERROR(1, "setup_ntlmv2_rsp: could not init hmacmd5\n");
 		return rc;
 	}
 
-	crypto_shash_update(&sdesc.shash, resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
+	crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
+				resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
 
-	rc = crypto_shash_final(&sdesc.shash,
+	rc = crypto_shash_final(&ses->server->ntlmssp.sdeschmacmd5->shash,
 		ses->server->session_key.data.ntlmv2.key);
 
 	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
@@ -578,24 +586,65 @@ cifs_crypto_shash_release(struct TCP_Server_Info *server)
 
 	if (server->ntlmssp.hmacmd5)
 		crypto_free_shash(server->ntlmssp.hmacmd5);
+
+	kfree(server->ntlmssp.sdeschmacmd5);
+
+	kfree(server->ntlmssp.sdescmd5);
 }
 
 int
 cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
+	int rc;
+	unsigned int size;
+
 	server->ntlmssp.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
 	if (!server->ntlmssp.hmacmd5 ||
 			IS_ERR(server->ntlmssp.hmacmd5)) {
-		cERROR(1, "could not allocate master crypto API hmacmd5\n");
+		cERROR(1, "could not allocate crypto hmacmd5\n");
 		return 1;
 	}
 
 	server->ntlmssp.md5 = crypto_alloc_shash("md5", 0, 0);
 	if (!server->ntlmssp.md5 || IS_ERR(server->ntlmssp.md5)) {
-		crypto_free_shash(server->ntlmssp.hmacmd5);
-		cERROR(1, "could not allocate master crypto API md5\n");
-		return 1;
+		cERROR(1, "could not allocate crypto md5\n");
+		rc = 1;
+		goto cifs_crypto_shash_allocate_ret1;
 	}
 
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->ntlmssp.hmacmd5);
+	server->ntlmssp.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->ntlmssp.sdeschmacmd5) {
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5\n");
+		rc = -ENOMEM;
+		goto cifs_crypto_shash_allocate_ret2;
+	}
+	server->ntlmssp.sdeschmacmd5->shash.tfm = server->ntlmssp.hmacmd5;
+	server->ntlmssp.sdeschmacmd5->shash.flags = 0x0;
+
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->ntlmssp.md5);
+	server->ntlmssp.sdescmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->ntlmssp.sdescmd5) {
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5\n");
+		rc = -ENOMEM;
+		goto cifs_crypto_shash_allocate_ret3;
+	}
+	server->ntlmssp.sdescmd5->shash.tfm = server->ntlmssp.md5;
+	server->ntlmssp.sdescmd5->shash.flags = 0x0;
+
 	return 0;
+
+cifs_crypto_shash_allocate_ret3:
+	kfree(server->ntlmssp.sdeschmacmd5);
+
+cifs_crypto_shash_allocate_ret2:
+	crypto_free_shash(server->ntlmssp.md5);
+
+cifs_crypto_shash_allocate_ret1:
+	crypto_free_shash(server->ntlmssp.hmacmd5);
+
+	return rc;
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 49563e0..c9d0cfc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -123,12 +123,19 @@ struct cifs_cred {
 	struct cifs_ace *aces;
 };
 
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
 struct ntlmssp_auth {
 	__u32 client_flags;
 	__u32 server_flags;
 	unsigned char ciphertext[CIFS_CPHTXT_SIZE];
 	struct crypto_shash *hmacmd5;
 	struct crypto_shash *md5;
+	struct sdesc *sdeschmacmd5;
+	struct sdesc *sdescmd5;
 };
 
 /*
-- 
1.6.0.2
