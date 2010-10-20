From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] [CIFS] [3/3 -v2] NTLM auth and sign - Use kernel crypto apis to calculate hashes and smb signatures
Date: Wed, 20 Oct 2010 16:04:22 -0500
Message-ID: <1287608662-914-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Use kernel crypto sync hash apis insetead of cifs crypto functions.
The calls typically corrospond one to one except that insead of
key init, setkey is used.

Use crypto apis to generate smb signagtures also.
Use hmac-md5 to genereate ntlmv2 hash, ntlmv2 response, and HMAC (CR1 of
ntlmv2 auth blob.
User crypto apis to genereate signature and to verify signature.
md5 hash is used to calculate signature.
Use secondary key to calculate signature in case of ntlmssp.

For ntlmv2 within ntlmssp, during signature calculation, only 16 bytes key
(a nonce) stored within session key is used. during smb signature calculation.
For ntlm and ntlmv2 without extended security, 16 bytes key
as well as entire response (24 bytes in case of ntlm and variable length
in case of ntlmv2) is used for smb signature calculation.
For kerberos, there is no distinction between key and response.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |  195 ++++++++++++++++++++++++++++++++++---------------
 fs/cifs/cifsproto.h   |    1 -
 2 files changed, 136 insertions(+), 60 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index b3e0b10..2abd271 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -45,17 +45,30 @@ extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 				struct TCP_Server_Info *server, char *signature)
 {
-	struct	MD5Context context;
+	int rc;
 
 	if (cifs_pdu == NULL || signature == NULL || server == NULL)
 		return -EINVAL;
 
-	cifs_MD5_init(&context);
-	cifs_MD5_update(&context, server->session_key.response,
-			server->session_key.len);
-	cifs_MD5_update(&context, cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
+	if (!server->secmech.sdescmd5) {
+		cERROR(1, "%s: Can't generate signature\n", __func__);
+		return -1;
+	}
+
+	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
+	if (rc) {
+		cERROR(1, "%s: Oould not init md5\n", __func__);
+		return rc;
+	}
+
+	crypto_shash_update(&server->secmech.sdescmd5->shash,
+		server->session_key.response, server->session_key.len);
+
+	crypto_shash_update(&server->secmech.sdescmd5->shash,
+		cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
+
+	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
 
-	cifs_MD5_final(signature, &context);
 	return 0;
 }
 
@@ -94,15 +107,26 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 				struct TCP_Server_Info *server, char *signature)
 {
-	struct  MD5Context context;
 	int i;
+	int rc;
 
 	if (iov == NULL || signature == NULL || server == NULL)
 		return -EINVAL;
 
-	cifs_MD5_init(&context);
-	cifs_MD5_update(&context, server->session_key.response,
-				server->session_key.len);
+	if (!server->secmech.sdescmd5) {
+		cERROR(1, "%s: Can't generate signature\n", __func__);
+		return -1;
+	}
+
+	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
+	if (rc) {
+		cERROR(1, "%s: Oould not init md5\n", __func__);
+		return rc;
+	}
+
+	crypto_shash_update(&server->secmech.sdescmd5->shash,
+		server->session_key.response, server->session_key.len);
+
 	for (i = 0; i < n_vec; i++) {
 		if (iov[i].iov_len == 0)
 			continue;
@@ -115,18 +139,18 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (i == 0) {
 			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
 				break; /* nothing to sign or corrupt header */
-			cifs_MD5_update(&context, iov[0].iov_base+4,
-				  iov[0].iov_len-4);
+			crypto_shash_update(&server->secmech.sdescmd5->shash,
+				iov[i].iov_base + 4, iov[i].iov_len - 4);
 		} else
-			cifs_MD5_update(&context, iov[i].iov_base, iov[i].iov_len);
+			crypto_shash_update(&server->secmech.sdescmd5->shash,
+				iov[i].iov_base, iov[i].iov_len);
 	}
 
-	cifs_MD5_final(signature, &context);
+	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
 
-	return 0;
+	return rc;
 }
 
-
 int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 		   __u32 *pexpected_response_sequence_number)
 {
@@ -424,67 +448,120 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 {
 	int rc = 0;
 	int len;
-	char nt_hash[16];
-	struct HMACMD5Context *pctxt;
+	char nt_hash[CIFS_NTHASH_SIZE];
 	wchar_t *user;
 	wchar_t *domain;
+	wchar_t *server;
 
-	pctxt = kmalloc(sizeof(struct HMACMD5Context), GFP_KERNEL);
-
-	if (pctxt == NULL)
-		return -ENOMEM;
+	if (!ses->server->secmech.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
 
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash);
 
-	/* convert Domainname to unicode and uppercase */
-	hmac_md5_init_limK_to_64(nt_hash, 16, pctxt);
+	crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
+				CIFS_NTHASH_SIZE);
+
+	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
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
+	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
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
-		/* the following line was removed since it didn't work well
-		   with lower cased domain name that passed as an option.
-		   Maybe converting the domain name earlier makes sense */
-		/* UniStrupr(domain); */
-
-		hmac_md5_update((char *)domain, 2*len, pctxt);
-
+		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
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
+		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+					(char *)server, 2 * len);
+		kfree(server);
 	}
+
+	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
+					ses->ntlmv2_hash);
+
 calc_exit_1:
 	kfree(user);
 calc_exit_2:
-	/* BB FIXME what about bytes 24 through 40 of the signing key?
-	   compare with the NTLM example */
-	hmac_md5_final(ses->ntlmv2_hash, pctxt);
+	return rc;
+}
+
+static int
+CalcNTLMv2_response(const struct cifsSesInfo *ses)
+{
+	int rc;
+	unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
+
+	if (!ses->server->secmech.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
+
+	crypto_shash_setkey(ses->server->secmech.hmacmd5,
+				ses->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
+	if (rc) {
+		cERROR(1, "CalcNTLMv2_response: could not init hmacmd5");
+		return rc;
+	}
+
+	memcpy(ses->auth_key.response + offset,
+		ses->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
+	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+		ses->auth_key.response + offset, ses->auth_key.len - offset);
+
+	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
+		ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 
-	kfree(pctxt);
 	return rc;
 }
 
+
 int
 setup_ntlmv2_rsp(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 {
 	int rc;
 	int baselen;
 	struct ntlmv2_resp *buf;
-	struct HMACMD5Context context;
 
 	if (ses->server->secType == RawNTLMSSP) {
 		if (!ses->domainName) {
@@ -527,13 +604,28 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 		cERROR(1, "could not get v2 hash rc %d", rc);
 		goto setup_ntlmv2_rsp_ret;
 	}
-	CalcNTLMv2_response(ses);
+	rc = CalcNTLMv2_response(ses);
+	if (rc) {
+		cERROR(1, "Could not calculate CR1  rc: %d", rc);
+		goto setup_ntlmv2_rsp_ret;
+	}
 
 	/* now calculate the session key for NTLMv2 */
-	hmac_md5_init_limK_to_64(ses->ntlmv2_hash, 16, &context);
-	hmac_md5_update(ses->auth_key.response + CIFS_SESS_KEY_SIZE,
-				16, &context);
-	hmac_md5_final(ses->auth_key.response, &context);
+	crypto_shash_setkey(ses->server->secmech.hmacmd5,
+		ses->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
+	if (rc) {
+		cERROR(1, "%s: Could not init hmacmd5\n", __func__);
+		goto setup_ntlmv2_rsp_ret;
+	}
+
+	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+		ses->auth_key.response + CIFS_SESS_KEY_SIZE,
+		CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
+		ses->auth_key.response);
 
 	return 0;
 
@@ -655,18 +747,3 @@ crypto_allocate_md5_fail:
 
 	return rc;
 }
-
-void CalcNTLMv2_response(const struct cifsSesInfo *ses)
-{
-	unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
-	struct HMACMD5Context context;
-
-	/* rest of v2 struct already generated */
-	memcpy(ses->auth_key.response + offset, ses->cryptKey, 8);
-	hmac_md5_init_limK_to_64(ses->ntlmv2_hash, 16, &context);
-
-	hmac_md5_update(ses->auth_key.response + offset,
-			ses->auth_key.len - offset, &context);
-
-	hmac_md5_final(ses->auth_key.response + CIFS_SESS_KEY_SIZE, &context);
-}
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1e4728b..edb6d90 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -366,7 +366,6 @@ extern int cifs_verify_signature(struct smb_hdr *,
 				__u32 expected_sequence_number);
 extern void SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
 extern int setup_ntlm_response(struct cifsSesInfo *);
-extern void CalcNTLMv2_response(const struct cifsSesInfo *);
 extern int setup_ntlmv2_rsp(struct cifsSesInfo *, const struct nls_table *);
 extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
 extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
-- 
1.6.0.2
