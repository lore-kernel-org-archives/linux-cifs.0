From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH -v2 5/6] convert hash calculations to use crypto apis
Date: Thu,  9 Sep 2010 13:13:30 -0500
Message-ID: <1284056010-867-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Use kernel crypto sync hash apis insetead of cifs crypto functions.
The calls typically corrospond one to one except that insead of
key init, setkey is used.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |  152 ++++++++++++++++++++++++++++++++++++-------------
 fs/cifs/cifsproto.h   |    1 -
 2 files changed, 112 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 09d9f74..e72b0e5 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -342,38 +342,52 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
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
 		/* the following line was removed since it didn't work well
@@ -381,18 +395,76 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		hmac_md5_update((char *)domain, 2*len, pctxt);
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
+		/* the following line was removed since it didn't work well
+		   with lower cased domain name that passed as an option.
+		   Maybe converting the domain name earlier makes sense */
+		/* UniStrupr(domain); */
+
+		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+					(char *)server, 2 * len);
+
+		kfree(server);
 	}
+
+	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
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
+CalcNTLMv2_response(const struct cifsSesInfo *ses, char *v2_session_response)
+{
+	int rc;
+
+	if (!ses->server->secmech.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		return -1;
+	}
+
+	crypto_shash_setkey(ses->server->secmech.hmacmd5,
+			ses->server->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
+	if (rc) {
+		cERROR(1, "CalcNTLMv2_response: could not init hmacmd5");
+		return rc;
+	}
+
+	memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
+		ses->server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
+	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+		v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
+		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE);
+
+	if (ses->tilen)
+		crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+					ses->tiblob, ses->tilen);
+
+	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
+					v2_session_response);
+
 	return rc;
 }
 
@@ -402,7 +474,6 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 {
 	int rc;
 	struct ntlmv2_resp *buf = (struct ntlmv2_resp *)resp_buf;
-	struct HMACMD5Context context;
 
 	buf->blob_signature = cpu_to_le32(0x00000101);
 	buf->reserved = 0;
@@ -432,15 +503,35 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 		cERROR(1, "could not get v2 hash rc %d", rc);
 		goto setup_ntlmv2_rsp_ret;
 	}
-	CalcNTLMv2_response(ses, resp_buf);
+	rc = CalcNTLMv2_response(ses, resp_buf);
+	if (rc) {
+		cERROR(1, "could not get v2 hash rc %d", rc);
+		goto setup_ntlmv2_rsp_ret;
+	}
+
+	if (!ses->server->secmech.sdeschmacmd5) {
+		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash\n");
+		rc = -1;
+		goto setup_ntlmv2_rsp_ret;
+	}
+
+	crypto_shash_setkey(ses->server->secmech.hmacmd5,
+			ses->server->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
+	if (rc) {
+		cERROR(1, "setup_ntlmv2_rsp: could not init hmacmd5\n");
+		goto setup_ntlmv2_rsp_ret;
+	}
+
+	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
+				resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
 
-	/* now calculate the MAC key for NTLMv2 */
-	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
-	hmac_md5_update(resp_buf, 16, &context);
-	hmac_md5_final(ses->server->session_key.data.ntlmv2.key, &context);
+	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
+		ses->server->session_key.data.ntlmv2.key);
 
 	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
-	       sizeof(struct ntlmv2_resp));
+		sizeof(struct ntlmv2_resp));
 	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
 
 	return 0;
@@ -452,25 +543,6 @@ setup_ntlmv2_rsp_ret:
 	return rc;
 }
 
-void CalcNTLMv2_response(const struct cifsSesInfo *ses,
-			 char *v2_session_response)
-{
-	struct HMACMD5Context context;
-	/* rest of v2 struct already generated */
-	memcpy(v2_session_response + 8, ses->server->cryptKey, 8);
-	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
-
-	hmac_md5_update(v2_session_response+8,
-			sizeof(struct ntlmv2_resp) - 8, &context);
-
-	if (ses->tilen)
-		hmac_md5_update(ses->tiblob,
-			ses->tilen, &context);
-
-	hmac_md5_final(v2_session_response, &context);
-/*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
-}
-
 int
 calc_seckey(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d89a87a..8fe46f5 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -366,7 +366,6 @@ extern int cifs_verify_signature(struct smb_hdr *,
 				__u32 expected_sequence_number);
 extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
 				 const char *pass);
-extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
 extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
 			     const struct nls_table *);
 extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
-- 
1.6.0.2
