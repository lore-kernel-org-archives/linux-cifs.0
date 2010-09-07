From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 8/8][ntlmv2 in ntlmssp 8/8] - use-kernel-crpto-apis-instead-of-cifs-crypto-functions
Date: Mon,  6 Sep 2010 22:36:24 -0500
Message-ID: <1283830584-25158-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use kernel crypto sync hash apis insetead of cifs crypto functions.
The calls typically corrospond one to one except that insead of
key init, setkey is used.

Use hmac-md5 to genereate ntlmv2 hash, ntlmv2 response, and HMAC (CR1 of
ntlmv2 auth blob.

Use md5 to generate signature (during send of a request and to verify response)


>From 90c4637c66ce7ff7901b71526a9844cb658247f5 Mon Sep 17 00:00:00 2001
From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Mon, 6 Sep 2010 21:56:40 -0500
Subject: [PATCH] use kernel crpto apis instead of cifs crypto functions

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Kconfig       |    3 +
 fs/cifs/cifsencrypt.c |  248 +++++++++++++++++++++++++++++++++++--------------
 fs/cifs/cifsproto.h   |    5 +-
 fs/cifs/transport.c   |    6 +-
 4 files changed, 184 insertions(+), 78 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 917b7d4..0ed2139 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -2,6 +2,9 @@ config CIFS
 	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
 	select NLS
+	select CRYPTO
+	select CRYPTO_MD5
+	select CRYPTO_ARC4
 	help
 	  This is the client VFS module for the Common Internet File System
 	  (CIFS) protocol which is the successor to the Server Message Block
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 0c1e9f2..bb8ee23 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -43,20 +43,39 @@ extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 		       unsigned char *p24);
 
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
-				    const struct session_key *key,
-					char *signature)
+			struct TCP_Server_Info *server, char *signature)
 {
-	struct	MD5Context context;
+	int rc;
 
-	if ((cifs_pdu == NULL) || (signature == NULL) || (key == NULL))
+	if (cifs_pdu == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	cifs_MD5_init(&context);
-	cifs_MD5_update(&context, (char *)&key->data, key->len);
-	cifs_MD5_update(&context, cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
+	if (!server->ntlmssp.sdescmd5) {
+		cERROR(1,
+			"cifs_calculate_signature: can't generate signature\n");
+		return -1;
+	}
 
-	cifs_MD5_final(signature, &context);
-	return 0;
+	rc = crypto_shash_init(&server->ntlmssp.sdescmd5->shash);
+	if (rc) {
+		cERROR(1, "cifs_calculate_signature: oould not init md5\n");
+		return rc;
+	}
+
+	if (server->secType == RawNTLMSSP)
+		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+			server->ntlmssp.sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
+	else
+		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+			(char *)&server->session_key.data,
+			server->session_key.len);
+
+	crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+			cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
+
+	rc = crypto_shash_final(&server->ntlmssp.sdescmd5->shash, signature);
+
+	return rc;
 }
 
 int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
@@ -80,8 +99,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 	server->sequence_number++;
 	spin_unlock(&GlobalMid_Lock);
 
-	rc = cifs_calculate_signature(cifs_pdu, &server->session_key,
-				      smb_signature);
+	rc = cifs_calculate_signature(cifs_pdu, server, smb_signature);
 	if (rc)
 		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
 	else
@@ -91,21 +109,38 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 }
 
 static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
-				const struct session_key *key, char *signature)
+			struct TCP_Server_Info *server, char *signature)
 {
-	struct  MD5Context context;
 	int i;
+	int rc;
 
-	if ((iov == NULL) || (signature == NULL) || (key == NULL))
+	if (iov == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	cifs_MD5_init(&context);
-	cifs_MD5_update(&context, (char *)&key->data, key->len);
+	if (!server->ntlmssp.sdescmd5) {
+		cERROR(1, "cifs_calc_signature2: can't generate signature\n");
+		return -1;
+	}
+
+	rc = crypto_shash_init(&server->ntlmssp.sdescmd5->shash);
+	if (rc) {
+		cERROR(1, "cifs_calc_signature2: oould not init md5\n");
+		return rc;
+	}
+
+	if (server->secType == RawNTLMSSP)
+		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+			server->ntlmssp.sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
+	else
+		crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+			(char *)&server->session_key.data,
+			server->session_key.len);
+
 	for (i = 0; i < n_vec; i++) {
 		if (iov[i].iov_len == 0)
 			continue;
 		if (iov[i].iov_base == NULL) {
-			cERROR(1, "null iovec entry");
+			cERROR(1, "cifs_calc_signature2: null iovec entry");
 			return -EIO;
 		}
 		/* The first entry includes a length field (which does not get
@@ -113,18 +148,18 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (i == 0) {
 			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
 				break; /* nothing to sign or corrupt header */
-			cifs_MD5_update(&context, iov[0].iov_base+4,
-				  iov[0].iov_len-4);
+			crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+				iov[i].iov_base + 4, iov[i].iov_len - 4);
 		} else
-			cifs_MD5_update(&context, iov[i].iov_base, iov[i].iov_len);
+			crypto_shash_update(&server->ntlmssp.sdescmd5->shash,
+				iov[i].iov_base, iov[i].iov_len);
 	}
 
-	cifs_MD5_final(signature, &context);
+	rc = crypto_shash_final(&server->ntlmssp.sdescmd5->shash, signature);
 
-	return 0;
+	return rc;
 }
 
-
 int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 		   __u32 *pexpected_response_sequence_number)
 {
@@ -147,8 +182,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 	server->sequence_number++;
 	spin_unlock(&GlobalMid_Lock);
 
-	rc = cifs_calc_signature2(iov, n_vec, &server->session_key,
-				      smb_signature);
+	rc = cifs_calc_signature2(iov, n_vec, server, smb_signature);
 	if (rc)
 		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
 	else
@@ -158,14 +192,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 }
 
 int cifs_verify_signature(struct smb_hdr *cifs_pdu,
-			  const struct session_key *session_key,
+			  struct TCP_Server_Info *server,
 			  __u32 expected_sequence_number)
 {
-	unsigned int rc;
+	int rc;
 	char server_response_sig[8];
 	char what_we_think_sig_should_be[20];
 
-	if ((cifs_pdu == NULL) || (session_key == NULL))
+	if (cifs_pdu == NULL || server == NULL)
 		return -EINVAL;
 
 	if (cifs_pdu->Command == SMB_COM_NEGOTIATE)
@@ -194,7 +228,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 					cpu_to_le32(expected_sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
-	rc = cifs_calculate_signature(cifs_pdu, session_key,
+	rc = cifs_calculate_signature(cifs_pdu, server,
 		what_we_think_sig_should_be);
 
 	if (rc)
@@ -320,37 +354,51 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 	int rc = 0;
 	int len;
 	char nt_hash[CIFS_NTHASH_SIZE];
-	struct HMACMD5Context *pctxt;
 	wchar_t *user;
 	wchar_t *domain;
+	wchar_t *server;
 
-	pctxt = kmalloc(sizeof(struct HMACMD5Context), GFP_KERNEL);
-
-	if (pctxt == NULL)
-		return -ENOMEM;
+	if (!ses->server->ntlmssp.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
 
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash);
 
-	/* convert Domainname to unicode and uppercase */
-	hmac_md5_init_limK_to_64(nt_hash, 16, pctxt);
+	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5, nt_hash,
+				CIFS_NTHASH_SIZE);
+
+	rc = crypto_shash_init(&ses->server->ntlmssp.sdeschmacmd5->shash);
+	if (rc) {
+		cERROR(1, "calc_ntlmv2_hash: could not init hmacmd5\n");
+		return rc;
+	}
 
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
-	hmac_md5_update((char *)user, 2*len, pctxt);
+
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
@@ -358,18 +406,77 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		hmac_md5_update((char *)domain, 2*len, pctxt);
+		crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
+					(char *)domain, 2 * len);
 
 		kfree(domain);
+	} else if (ses->serverName) {
+		len = strlen(ses->serverName);
+
+		server = kmalloc(2 + (len * 2), GFP_KERNEL);
+		if (server == NULL) {
+			cERROR(1, "calc_ntlmv2_hash: server mem alloc failure");
+			rc = -ENOMEM;
+			goto calc_exit_1;
+		}
+		len = cifs_strtoUCS((__le16 *)server, ses->serverName, len,
+					nls_cp);
+		/* the following line was removed since it didn't work well
+		   with lower cased domain name that passed as an option.
+		   Maybe converting the domain name earlier makes sense */
+		/* UniStrupr(domain); */
+
+		crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
+					(char *)server, 2 * len);
+
+		kfree(server);
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
-	hmac_md5_final(ses->server->ntlmv2_hash, pctxt);
 
-	kfree(pctxt);
+	return rc;
+}
+
+static int
+CalcNTLMv2_response(const struct TCP_Server_Info *server,
+			 char *v2_session_response)
+{
+	int rc;
+
+	if (!server->ntlmssp.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
+
+	crypto_shash_setkey(server->ntlmssp.hmacmd5, server->ntlmv2_hash,
+		CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_shash_init(&server->ntlmssp.sdeschmacmd5->shash);
+	if (rc) {
+		cERROR(1, "CalcNTLMv2_response: could not init hmacmd5");
+		return rc;
+	}
+
+	memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
+		server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
+	crypto_shash_update(&server->ntlmssp.sdeschmacmd5->shash,
+		v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
+		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE);
+
+	if (server->tilen)
+		crypto_shash_update(&server->ntlmssp.sdeschmacmd5->shash,
+					server->tiblob, server->tilen);
+
+	rc = crypto_shash_final(&server->ntlmssp.sdeschmacmd5->shash,
+					v2_session_response);
+
 	return rc;
 }
 
@@ -379,7 +486,6 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 {
 	int rc = 0;
 	struct ntlmv2_resp *buf = (struct ntlmv2_resp *)resp_buf;
-	struct HMACMD5Context context;
 
 	buf->blob_signature = cpu_to_le32(0x00000101);
 	buf->reserved = 0;
@@ -397,44 +503,44 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 
 	/* calculate buf->ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, nls_cp);
-	if (rc)
+	if (rc) {
+		cERROR(1, "could not get v2 hash rc %d", rc);
+		return rc;
+	}
+	rc = CalcNTLMv2_response(ses->server, resp_buf);
+	if (rc) {
 		cERROR(1, "could not get v2 hash rc %d", rc);
-	CalcNTLMv2_response(ses, resp_buf);
+		return rc;
+	}
 
-	/* now calculate the MAC key for NTLMv2 */
-	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
-	hmac_md5_update(resp_buf, 16, &context);
-	hmac_md5_final(ses->server->session_key.data.ntlmv2.key, &context);
+	if (!ses->server->ntlmssp.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
 
-	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
-	       sizeof(struct ntlmv2_resp));
-	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
+	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5,
+			ses->server->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 
-	return rc;
-}
+	rc = crypto_shash_init(&ses->server->ntlmssp.sdeschmacmd5->shash);
+	if (rc) {
+		cERROR(1, "setup_ntlmv2_rsp: could not init hmacmd5\n");
+		return rc;
+	}
 
-void CalcNTLMv2_response(const struct cifsSesInfo *ses,
-			 char *v2_session_response)
-{
-	struct HMACMD5Context context;
-	/* rest of v2 struct already generated */
-	memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
-		ses->server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
-	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash,
-		CIFS_HMAC_MD5_HASH_SIZE, &context);
+	crypto_shash_update(&ses->server->ntlmssp.sdeschmacmd5->shash,
+				resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
 
-	hmac_md5_update(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
-		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE,
-		&context);
+	rc = crypto_shash_final(&ses->server->ntlmssp.sdeschmacmd5->shash,
+		ses->server->session_key.data.ntlmv2.key);
 
-	if (ses->server->tilen)
-		hmac_md5_update(ses->server->tiblob,
-			ses->server->tilen, &context);
+	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
+			sizeof(struct ntlmv2_resp));
+	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
 
-	hmac_md5_final(v2_session_response, &context);
-/*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
+	return rc;
 }
 
+
 int
 calc_seckey(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7c115a8..1378d91 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -361,13 +361,10 @@ extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
 extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
 			  __u32 *);
 extern int cifs_verify_signature(struct smb_hdr *,
-				 const struct session_key *session_key,
+				 struct TCP_Server_Info *server,
 				__u32 expected_sequence_number);
 extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
 				 const char *pass);
-extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
-			const struct nls_table *);
-extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
 extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
 			     const struct nls_table *);
 extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index a66c91e..e0588cd 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -543,7 +543,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 					     SECMODE_SIGN_ENABLED))) {
 			rc = cifs_verify_signature(midQ->resp_buf,
-						&ses->server->session_key,
+						ses->server,
 						midQ->sequence_number+1);
 			if (rc) {
 				cERROR(1, "Unexpected SMB signature");
@@ -731,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 					     SECMODE_SIGN_ENABLED))) {
 			rc = cifs_verify_signature(out_buf,
-						&ses->server->session_key,
+						ses->server,
 						midQ->sequence_number+1);
 			if (rc) {
 				cERROR(1, "Unexpected SMB signature");
@@ -981,7 +981,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 				     SECMODE_SIGN_ENABLED))) {
 		rc = cifs_verify_signature(out_buf,
-					   &ses->server->session_key,
+					   ses->server,
 					   midQ->sequence_number+1);
 		if (rc) {
 			cERROR(1, "Unexpected SMB signature");
-- 
1.6.0.2
