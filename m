From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] Revert "Eliminate sparse warning - bad constant expression"
Date: Wed,  1 Sep 2010 21:37:33 -0400
Message-ID: <1283391455-6848-5-git-send-email-jlayton@redhat.com>
References: <1283391455-6848-1-git-send-email-jlayton@redhat.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283391455-6848-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This reverts commit 2d20ca835867d93ead6ce61780d883a4b128106d.
---
 fs/cifs/cifsencrypt.c |  193 ++++++++++++++++++-------------------------------
 fs/cifs/cifsglob.h    |    7 --
 2 files changed, 72 insertions(+), 128 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 709f229..eef78c2 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -45,38 +45,39 @@ extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 			struct TCP_Server_Info *server, char *signature)
 {
-	int rc;
+	int rc = 0;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(server->ntlmssp.md5)];
+	} sdesc;
 
 	if (cifs_pdu == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	if (!server->ntlmssp.sdescmd5) {
-		cERROR(1,
-			"cifs_calculate_signature: can't generate signature\n");
-		return -1;
-	}
+	sdesc.shash.tfm = server->ntlmssp.md5;
+	sdesc.shash.flags = 0x0;
 
-	rc = crypto_shash_init(&server->ntlmssp.sdescmd5->shash);
+	rc = crypto_shash_init(&sdesc.shash);
 	if (rc) {
-		cERROR(1, "cifs_calculate_signature: oould not init md5\n");
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
 		return rc;
 	}
 
 	if (server->secType == RawNTLMSSP)
-		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+		crypto_shash_update(&sdesc.shash,
 			server->session_key.data.ntlmv2.key,
 			CIFS_NTLMV2_SESSKEY_SIZE);
 	else
-		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+		crypto_shash_update(&sdesc.shash,
 			(char *)&server->session_key.data,
 			server->session_key.len);
 
-	crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+	crypto_shash_update(&sdesc.shash,
 			cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
 
-	rc = crypto_shash_final(&server->ntlmssp.sdescmd5->shash, signature);
+	rc = crypto_shash_final(&sdesc.shash, signature);
 
-	return rc;
+	return 0;
 }
 
 
@@ -114,28 +115,30 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 			struct TCP_Server_Info *server, char *signature)
 {
 	int i;
-	int rc;
+	int rc = 0;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(server->ntlmssp.md5)];
+	} sdesc;
 
 	if (iov == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	if (!server->ntlmssp.sdescmd5) {
-		cERROR(1, "cifs_calc_signature2: can't generate signature\n");
-		return -1;
-	}
+	sdesc.shash.tfm = server->ntlmssp.md5;
+	sdesc.shash.flags = 0x0;
 
-	rc = crypto_shash_init(&server->ntlmssp.sdescmd5->shash);
+	rc = crypto_shash_init(&sdesc.shash);
 	if (rc) {
-		cERROR(1, "cifs_calc_signature2: oould not init md5\n");
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
 		return rc;
 	}
 
 	if (server->secType == RawNTLMSSP)
-		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+		crypto_shash_update(&sdesc.shash,
 			server->session_key.data.ntlmv2.key,
 			CIFS_NTLMV2_SESSKEY_SIZE);
 	else
-		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+		crypto_shash_update(&sdesc.shash,
 			(char *)&server->session_key.data,
 			server->session_key.len);
 
@@ -143,7 +146,7 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (iov[i].iov_len == 0)
 			continue;
 		if (iov[i].iov_base == NULL) {
-			cERROR(1, "cifs_calc_signature2: null iovec entry");
+			cERROR(1, "null iovec entry");
 			return -EIO;
 		}
 		/* The first entry includes a length field (which does not get
@@ -151,16 +154,16 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (i == 0) {
 			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
 				break; /* nothing to sign or corrupt header */
-			crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+			crypto_shash_update(&sdesc.shash,
 				iov[i].iov_base + 4, iov[i].iov_len - 4);
 		} else
-			crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+			crypto_shash_update(&sdesc.shash,
 				iov[i].iov_base, iov[i].iov_len);
 	}
 
-	rc = crypto_shash_final(&server->ntlmssp.sdescmd5->shash, signature);
+	rc = crypto_shash_final(&sdesc.shash, signature);
 
-	return rc;
+	return 0;
 }
 
 int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
@@ -310,48 +313,43 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 	wchar_t *user;
 	wchar_t *domain;
 	wchar_t *server;
-
-	if (!ses->server->ntlmssp.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
-		return -1;
-	}
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
+	} sdesc;
 
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash);
 
+	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
+	sdesc.shash.flags = 0x0;
+
 	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5, nt_hash,
 				CIFS_NTHASH_SIZE);
 
-	rc = crypto_shash_init(&ses->server->ntlmssp.sdeschmacmd5->shash);
+	rc = crypto_shash_init(&sdesc.shash);
 	if (rc) {
-		cERROR(1, "calc_ntlmv2_hash: could not init hmacmd5\n");
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
 		return rc;
 	}
 
 	/* convert ses->userName to unicode and uppercase */
 	len = strlen(ses->userName);
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
-	if (user == NULL) {
-		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure\n");
-		rc = -ENOMEM;
+	if (user == NULL)
 		goto calc_exit_2;
-	}
 	len = cifs_strtoUCS((__le16 *)user, ses->userName, len, nls_cp);
 	UniStrupr(user);
 
-	crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
-				(char *)user, 2 * len);
+	crypto_shash_update(&sdesc.shash, (char *)user, 2 * len);
 
 	/* convert ses->domainName to unicode and uppercase */
 	if (ses->domainName) {
 		len = strlen(ses->domainName);
 
 		domain = kmalloc(2 + (len * 2), GFP_KERNEL);
-		if (domain == NULL) {
-			cERROR(1, "calc_ntlmv2_hash: domain mem alloc failure");
-			rc = -ENOMEM;
+		if (domain == NULL)
 			goto calc_exit_1;
-		}
 		len = cifs_strtoUCS((__le16 *)domain, ses->domainName, len,
 					nls_cp);
 		/* the following line was removed since it didn't work well
@@ -359,19 +357,15 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
-					(char *)domain, 2 * len);
+		crypto_shash_update(&sdesc.shash, (char *)domain, 2 * len);
 
 		kfree(domain);
 	} else if (ses->serverName) {
 		len = strlen(ses->serverName);
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
-		if (server == NULL) {
-			cERROR(1, "calc_ntlmv2_hash: server mem alloc failure");
-			rc = -ENOMEM;
+		if (server == NULL)
 			goto calc_exit_1;
-		}
 		len = cifs_strtoUCS((__le16 *)server, ses->serverName, len,
 					nls_cp);
 		/* the following line was removed since it didn't work well
@@ -379,20 +373,16 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
-					(char *)server, 2 * len);
+		crypto_shash_update(&sdesc.shash, (char *)server, 2 * len);
 
 		kfree(server);
 	}
-
-	rc = crypto_shash_final(&ses->server->ntlmssp.sdeschmacmd5->shash,
-					ses->server->ntlmv2_hash);
-
 calc_exit_1:
 	kfree(user);
 calc_exit_2:
 	/* BB FIXME what about bytes 24 through 40 of the signing key?
 	   compare with the NTLM example */
+	rc = crypto_shash_final(&sdesc.shash, ses->server->ntlmv2_hash);
 
 	return rc;
 }
@@ -452,33 +442,34 @@ CalcNTLMv2_response(const struct TCP_Server_Info *server,
 			 char *v2_session_response)
 {
 	int rc;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(server->ntlmssp.hmacmd5)];
+	} sdesc;
 
-	if (!server->ntlmssp.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
-		return -1;
-	}
+	sdesc.shash.tfm = server->ntlmssp.hmacmd5;
+	sdesc.shash.flags = 0x0;
 
 	crypto_shash_setkey(server->ntlmssp.hmacmd5, server->ntlmv2_hash,
 		CIFS_HMAC_MD5_HASH_SIZE);
 
-	rc = crypto_shash_init(&server->ntlmssp.sdeschmacmd5->shash);
+	rc = crypto_shash_init(&sdesc.shash);
 	if (rc) {
-		cERROR(1, "CalcNTLMv2_response: could not init hmacmd5");
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
 		return rc;
 	}
 
 	memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
 		server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
-	crypto_shash_update(&server->ntlmssp.sdeschmacmd5->shash,
+	crypto_shash_update(&sdesc.shash,
 		v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
 		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE);
 
 	if (server->tilen)
-		crypto_shash_update(&server->ntlmssp.sdeschmacmd5->shash,
+		crypto_shash_update(&sdesc.shash,
 					server->tiblob, server->tilen);
 
-	rc = crypto_shash_final(&server->ntlmssp.sdeschmacmd5->shash,
-					v2_session_response);
+	rc = crypto_shash_final(&sdesc.shash, v2_session_response);
 
 	return rc;
 }
@@ -489,6 +480,10 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 {
 	int rc = 0;
 	struct ntlmv2_resp *buf = (struct ntlmv2_resp *)resp_buf;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
+	} sdesc;
 
 	buf->blob_signature = cpu_to_le32(0x00000101);
 	buf->reserved = 0;
@@ -516,24 +511,21 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 		return rc;
 	}
 
-	if (!ses->server->ntlmssp.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
-		return -1;
-	}
-
 	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5,
 			ses->server->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 
-	rc = crypto_shash_init(&ses->server->ntlmssp.sdeschmacmd5->shash);
+	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
+	sdesc.shash.flags = 0x0;
+
+	rc = crypto_shash_init(&sdesc.shash);
 	if (rc) {
-		cERROR(1, "setup_ntlmv2_rsp: could not init hmacmd5\n");
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
 		return rc;
 	}
 
-	crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
-				resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
+	crypto_shash_update(&sdesc.shash, resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
 
-	rc = crypto_shash_final(&ses->server->ntlmssp.sdeschmacmd5->shash,
+	rc = crypto_shash_final(&sdesc.shash,
 		ses->server->session_key.data.ntlmv2.key);
 
 	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
@@ -586,65 +578,24 @@ cifs_crypto_shash_release(struct TCP_Server_Info *server)
 
 	if (server->ntlmssp.hmacmd5)
 		crypto_free_shash(server->ntlmssp.hmacmd5);
-
-	kfree(server->ntlmssp.sdeschmacmd5);
-
-	kfree(server->ntlmssp.sdescmd5);
 }
 
 int
 cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
-	int rc;
-	unsigned int size;
-
 	server->ntlmssp.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
 	if (!server->ntlmssp.hmacmd5 ||
 			IS_ERR(server->ntlmssp.hmacmd5)) {
-		cERROR(1, "could not allocate crypto hmacmd5\n");
+		cERROR(1, "could not allocate master crypto API hmacmd5\n");
 		return 1;
 	}
 
 	server->ntlmssp.md5 = crypto_alloc_shash("md5", 0, 0);
 	if (!server->ntlmssp.md5 || IS_ERR(server->ntlmssp.md5)) {
-		cERROR(1, "could not allocate crypto md5\n");
-		rc = 1;
-		goto cifs_crypto_shash_allocate_ret1;
-	}
-
-	size = sizeof(struct shash_desc) +
-			crypto_shash_descsize(server->ntlmssp.hmacmd5);
-	server->ntlmssp.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
-	if (!server->ntlmssp.sdeschmacmd5) {
-		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5\n");
-		rc = -ENOMEM;
-		goto cifs_crypto_shash_allocate_ret2;
-	}
-	server->ntlmssp.sdeschmacmd5->shash.tfm = server->ntlmssp.hmacmd5;
-	server->ntlmssp.sdeschmacmd5->shash.flags = 0x0;
-
-
-	size = sizeof(struct shash_desc) +
-			crypto_shash_descsize(server->ntlmssp.md5);
-	server->ntlmssp.sdescmd5 = kmalloc(size, GFP_KERNEL);
-	if (!server->ntlmssp.sdescmd5) {
-		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5\n");
-		rc = -ENOMEM;
-		goto cifs_crypto_shash_allocate_ret3;
+		crypto_free_shash(server->ntlmssp.hmacmd5);
+		cERROR(1, "could not allocate master crypto API md5\n");
+		return 1;
 	}
-	server->ntlmssp.sdescmd5->shash.tfm = server->ntlmssp.md5;
-	server->ntlmssp.sdescmd5->shash.flags = 0x0;
 
 	return 0;
-
-cifs_crypto_shash_allocate_ret3:
-	kfree(server->ntlmssp.sdeschmacmd5);
-
-cifs_crypto_shash_allocate_ret2:
-	crypto_free_shash(server->ntlmssp.md5);
-
-cifs_crypto_shash_allocate_ret1:
-	crypto_free_shash(server->ntlmssp.hmacmd5);
-
-	return rc;
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c9d0cfc..49563e0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -123,19 +123,12 @@ struct cifs_cred {
 	struct cifs_ace *aces;
 };
 
-struct sdesc {
-	struct shash_desc shash;
-	char ctx[];
-};
-
 struct ntlmssp_auth {
 	__u32 client_flags;
 	__u32 server_flags;
 	unsigned char ciphertext[CIFS_CPHTXT_SIZE];
 	struct crypto_shash *hmacmd5;
 	struct crypto_shash *md5;
-	struct sdesc *sdeschmacmd5;
-	struct sdesc *sdescmd5;
 };
 
 /*
-- 
1.7.2.2
