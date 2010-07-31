From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [linux-cifs-client][PATCH] (resend) Enable signing for ntlmv2 within NTLMSSP using kernel crypto APIs
Date: Sat, 31 Jul 2010 15:50:32 -0500
Message-ID: <1280609432-10439-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Enable signing for ntlmv2 auth mech within NTLMSSP.
Changed most of the crypto routines used by cifs to the kernel crypto apis.


>From 11024eb79977a70502468a997744aca1e4ad81d0 Mon Sep 17 00:00:00 2001
From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, 31 Jul 2010 14:18:02 -0500
Subject: [PATCH] enable signing for ntlmv2 within NTLMSSP

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |  332 +++++++++++++++++++++++++++++++------------------
 fs/cifs/cifsglob.h    |   12 ++
 fs/cifs/cifsproto.h   |   10 +-
 fs/cifs/connect.c     |   11 ++-
 fs/cifs/sess.c        |   31 ++++-
 fs/cifs/transport.c   |    6 +-
 6 files changed, 269 insertions(+), 133 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 61cf380..f99009b 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -43,21 +43,43 @@ extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 		       unsigned char *p24);
 
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
-				    const struct mac_key *key, char *signature)
+			struct TCP_Server_Info *server, char *signature)
 {
-	struct	MD5Context context;
+	int rc = 0;
+	struct scatterlist sgin[2];
+	struct hash_desc desc;
 
-	if ((cifs_pdu == NULL) || (signature == NULL) || (key == NULL))
+	if (cifs_pdu == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	cifs_MD5_init(&context);
-	cifs_MD5_update(&context, (char *)&key->data, key->len);
-	cifs_MD5_update(&context, cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
+	desc.tfm = server->ntlmssp.tfm_md5;
+
+	rc = crypto_hash_init(&desc);
+	if (rc) {
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		return rc;
+	}
+
+	if (server->secType == RawNTLMSSP) {
+		sg_init_one(&sgin[0], server->mac_signing_key.data.ntlmv2.key,
+				CIFS_NTLMV2_SESSKEY_SIZE);
+		crypto_hash_update(&desc, &sgin[0], CIFS_NTLMV2_SESSKEY_SIZE);
+	} else {
+		sg_init_one(&sgin[0], &server->mac_signing_key.data,
+			server->mac_signing_key.len);
+		crypto_hash_update(&desc, &sgin[0],
+			server->mac_signing_key.len);
+	}
+
+	sg_init_one(&sgin[1], cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
+	crypto_hash_update(&desc, &sgin[1], cifs_pdu->smb_buf_length);
+
+	rc = crypto_hash_final(&desc, signature);
 
-	cifs_MD5_final(signature, &context);
 	return 0;
 }
 
+
 int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 		  __u32 *pexpected_response_sequence_number)
 {
@@ -79,8 +101,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 	server->sequence_number++;
 	spin_unlock(&GlobalMid_Lock);
 
-	rc = cifs_calculate_signature(cifs_pdu, &server->mac_signing_key,
-				      smb_signature);
+	rc = cifs_calculate_signature(cifs_pdu, server, smb_signature);
 	if (rc)
 		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
 	else
@@ -90,16 +111,35 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 }
 
 static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
-				const struct mac_key *key, char *signature)
+			struct TCP_Server_Info *server, char *signature)
 {
-	struct  MD5Context context;
 	int i;
+	int rc = 0;
+	struct scatterlist sgin[n_vec + 1];
+	struct hash_desc desc;
 
-	if ((iov == NULL) || (signature == NULL) || (key == NULL))
+	if (iov == NULL || server == NULL || signature == NULL)
 		return -EINVAL;
 
-	cifs_MD5_init(&context);
-	cifs_MD5_update(&context, (char *)&key->data, key->len);
+	desc.tfm = server->ntlmssp.tfm_md5;
+
+	rc = crypto_hash_init(&desc);
+	if (rc) {
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		return rc;
+	}
+
+	if (server->secType == RawNTLMSSP) {
+		sg_init_one(&sgin[0], server->mac_signing_key.data.ntlmv2.key,
+				CIFS_NTLMV2_SESSKEY_SIZE);
+		crypto_hash_update(&desc, &sgin[0], CIFS_NTLMV2_SESSKEY_SIZE);
+	} else {
+		sg_init_one(&sgin[0], &server->mac_signing_key.data,
+			server->mac_signing_key.len);
+		crypto_hash_update(&desc, &sgin[0],
+			server->mac_signing_key.len);
+	}
+
 	for (i = 0; i < n_vec; i++) {
 		if (iov[i].iov_len == 0)
 			continue;
@@ -112,18 +152,23 @@ static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
 		if (i == 0) {
 			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
 				break; /* nothing to sign or corrupt header */
-			cifs_MD5_update(&context, iov[0].iov_base+4,
-				  iov[0].iov_len-4);
-		} else
-			cifs_MD5_update(&context, iov[i].iov_base, iov[i].iov_len);
+			sg_init_one(&sgin[i + 1], iov[i].iov_base + 4,
+						iov[i].iov_len - 4);
+			crypto_hash_update(&desc, &sgin[i + 1],
+						iov[i].iov_len - 4);
+		} else {
+			sg_init_one(&sgin[i + 1], iov[i].iov_base,
+					iov[i].iov_len);
+			crypto_hash_update(&desc, &sgin[i + 1],
+						iov[i].iov_len);
+		}
 	}
 
-	cifs_MD5_final(signature, &context);
+	rc = crypto_hash_final(&desc, signature);
 
 	return 0;
 }
 
-
 int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 		   __u32 *pexpected_response_sequence_number)
 {
@@ -146,8 +191,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 	server->sequence_number++;
 	spin_unlock(&GlobalMid_Lock);
 
-	rc = cifs_calc_signature2(iov, n_vec, &server->mac_signing_key,
-				      smb_signature);
+	rc = cifs_calc_signature2(iov, n_vec, server, smb_signature);
 	if (rc)
 		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
 	else
@@ -157,14 +201,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 }
 
 int cifs_verify_signature(struct smb_hdr *cifs_pdu,
-			  const struct mac_key *mac_key,
+			  struct TCP_Server_Info *server,
 			  __u32 expected_sequence_number)
 {
 	unsigned int rc;
 	char server_response_sig[8];
 	char what_we_think_sig_should_be[20];
 
-	if ((cifs_pdu == NULL) || (mac_key == NULL))
+	if (cifs_pdu == NULL || server == NULL)
 		return -EINVAL;
 
 	if (cifs_pdu->Command == SMB_COM_NEGOTIATE)
@@ -193,7 +237,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 					cpu_to_le32(expected_sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
-	rc = cifs_calculate_signature(cifs_pdu, mac_key,
+	rc = cifs_calculate_signature(cifs_pdu, server,
 		what_we_think_sig_should_be);
 
 	if (rc)
@@ -224,63 +268,6 @@ int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
 	return 0;
 }
 
-int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *ses,
-			       const struct nls_table *nls_info)
-{
-	char temp_hash[16];
-	struct HMACMD5Context ctx;
-	char *ucase_buf;
-	__le16 *unicode_buf;
-	unsigned int i, user_name_len, dom_name_len;
-
-	if (ses == NULL)
-		return -EINVAL;
-
-	E_md4hash(ses->password, temp_hash);
-
-	hmac_md5_init_limK_to_64(temp_hash, 16, &ctx);
-	user_name_len = strlen(ses->userName);
-	if (user_name_len > MAX_USERNAME_SIZE)
-		return -EINVAL;
-	if (ses->domainName == NULL)
-		return -EINVAL; /* BB should we use CIFS_LINUX_DOM */
-	dom_name_len = strlen(ses->domainName);
-	if (dom_name_len > MAX_USERNAME_SIZE)
-		return -EINVAL;
-
-	ucase_buf = kmalloc((MAX_USERNAME_SIZE+1), GFP_KERNEL);
-	if (ucase_buf == NULL)
-		return -ENOMEM;
-	unicode_buf = kmalloc((MAX_USERNAME_SIZE+1)*4, GFP_KERNEL);
-	if (unicode_buf == NULL) {
-		kfree(ucase_buf);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < user_name_len; i++)
-		ucase_buf[i] = nls_info->charset2upper[(int)ses->userName[i]];
-	ucase_buf[i] = 0;
-	user_name_len = cifs_strtoUCS(unicode_buf, ucase_buf,
-				      MAX_USERNAME_SIZE*2, nls_info);
-	unicode_buf[user_name_len] = 0;
-	user_name_len++;
-
-	for (i = 0; i < dom_name_len; i++)
-		ucase_buf[i] = nls_info->charset2upper[(int)ses->domainName[i]];
-	ucase_buf[i] = 0;
-	dom_name_len = cifs_strtoUCS(unicode_buf+user_name_len, ucase_buf,
-				     MAX_USERNAME_SIZE*2, nls_info);
-
-	unicode_buf[user_name_len + dom_name_len] = 0;
-	hmac_md5_update((const unsigned char *) unicode_buf,
-		(user_name_len+dom_name_len)*2, &ctx);
-
-	hmac_md5_final(ses->server->ntlmv2_hash, &ctx);
-	kfree(ucase_buf);
-	kfree(unicode_buf);
-	return 0;
-}
-
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 			char *lnm_session_key)
@@ -325,21 +312,25 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 {
 	int rc = 0;
 	int len;
-	char nt_hash[16];
-	struct HMACMD5Context *pctxt;
+	char nt_hash[CIFS_NTHASH_SIZE];
 	wchar_t *user;
 	wchar_t *domain;
-
-	pctxt = kmalloc(sizeof(struct HMACMD5Context), GFP_KERNEL);
-
-	if (pctxt == NULL)
-		return -ENOMEM;
+	struct hash_desc desc;
+	struct scatterlist sgin[2];
 
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash);
 
-	/* convert Domainname to unicode and uppercase */
-	hmac_md5_init_limK_to_64(nt_hash, 16, pctxt);
+	desc.tfm = ses->server->ntlmssp.tfm_hmacmd5;
+
+	crypto_hash_setkey(ses->server->ntlmssp.tfm_hmacmd5, nt_hash,
+				CIFS_NTHASH_SIZE);
+
+	rc = crypto_hash_init(&desc);
+	if (rc) {
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		return rc;
+	}
 
 	/* convert ses->userName to unicode and uppercase */
 	len = strlen(ses->userName);
@@ -348,7 +339,9 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		goto calc_exit_2;
 	len = cifs_strtoUCS((__le16 *)user, ses->userName, len, nls_cp);
 	UniStrupr(user);
-	hmac_md5_update((char *)user, 2*len, pctxt);
+
+	sg_init_one(&sgin[0], user, 2 * len);
+	crypto_hash_update(&desc, &sgin[0], 2 * len);
 
 	/* convert ses->domainName to unicode and uppercase */
 	if (ses->domainName) {
@@ -364,7 +357,8 @@ static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* UniStrupr(domain); */
 
-		hmac_md5_update((char *)domain, 2*len, pctxt);
+		sg_init_one(&sgin[1], domain, 2 * len);
+		crypto_hash_update(&desc, &sgin[1], 2 * len);
 
 		kfree(domain);
 	}
@@ -373,9 +367,8 @@ calc_exit_1:
 calc_exit_2:
 	/* BB FIXME what about bytes 24 through 40 of the signing key?
 	   compare with the NTLM example */
-	hmac_md5_final(ses->server->ntlmv2_hash, pctxt);
+	rc = crypto_hash_final(&desc, ses->server->ntlmv2_hash);
 
-	kfree(pctxt);
 	return rc;
 }
 
@@ -417,12 +410,50 @@ find_domain_name(struct cifsSesInfo *ses)
 	return;
 }
 
-void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
-		      const struct nls_table *nls_cp)
+static int
+CalcNTLMv2_response(const struct TCP_Server_Info *server,
+			 char *v2_session_response)
 {
 	int rc;
+	struct hash_desc desc;
+	struct scatterlist sgin[2];
+
+	desc.tfm = server->ntlmssp.tfm_hmacmd5;
+
+	crypto_hash_setkey(server->ntlmssp.tfm_hmacmd5, server->ntlmv2_hash,
+		CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_hash_init(&desc);
+	if (rc) {
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		return rc;
+	}
+
+	memcpy(v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
+		server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
+	sg_init_one(&sgin[0], v2_session_response + CIFS_SERVER_CHALLENGE_SIZE,
+		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE);
+	crypto_hash_update(&desc, &sgin[0],
+		sizeof(struct ntlmv2_resp) - CIFS_SERVER_CHALLENGE_SIZE);
+
+	if (server->tilen) {
+		sg_init_one(&sgin[1], server->tiblob, server->tilen);
+		crypto_hash_update(&desc, &sgin[1], server->tilen);
+	}
+
+	rc = crypto_hash_final(&desc, v2_session_response);
+
+	return rc;
+}
+
+int
+setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
+		      const struct nls_table *nls_cp)
+{
+	int rc = 0;
+	struct hash_desc desc;
+	struct scatterlist sgin;
 	struct ntlmv2_resp *buf = (struct ntlmv2_resp *)resp_buf;
-	struct HMACMD5Context context;
 
 	buf->blob_signature = cpu_to_le32(0x00000101);
 	buf->reserved = 0;
@@ -437,32 +468,95 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 	rc = calc_ntlmv2_hash(ses, nls_cp);
 	if (rc)
 		cERROR(1, "could not get v2 hash rc %d", rc);
-	CalcNTLMv2_response(ses, resp_buf);
+	rc = CalcNTLMv2_response(ses->server, resp_buf);
+
+	desc.tfm = ses->server->ntlmssp.tfm_hmacmd5;
 
-	/* now calculate the MAC key for NTLMv2 */
-	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
-	hmac_md5_update(resp_buf, 16, &context);
-	hmac_md5_final(ses->server->mac_signing_key.data.ntlmv2.key, &context);
+	crypto_hash_setkey(ses->server->ntlmssp.tfm_hmacmd5,
+			ses->server->ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_hash_init(&desc);
+	if (rc) {
+		cERROR(1, "could not initialize master crypto API hmacmd5\n");
+		return rc;
+	}
+
+	sg_init_one(&sgin, resp_buf, CIFS_HMAC_MD5_HASH_SIZE);
+	crypto_hash_update(&desc, &sgin, CIFS_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_hash_final(&desc,
+		ses->server->mac_signing_key.data.ntlmv2.key);
 
 	memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp, resp_buf,
-	       sizeof(struct ntlmv2_resp));
+			sizeof(struct ntlmv2_resp));
 	ses->server->mac_signing_key.len = 16 + sizeof(struct ntlmv2_resp);
+
+	return rc;
 }
 
-void CalcNTLMv2_response(const struct cifsSesInfo *ses,
-			 char *v2_session_response)
+int
+calc_seckey(struct TCP_Server_Info *server)
 {
-	struct HMACMD5Context context;
-	/* rest of v2 struct already generated */
-	memcpy(v2_session_response + 8, ses->server->cryptKey, 8);
-	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
-
-	hmac_md5_update(v2_session_response+8,
-			sizeof(struct ntlmv2_resp) - 8, &context);
-	if (ses->server->tilen)
-		hmac_md5_update(ses->server->tiblob,
-			ses->server->tilen, &context);
-
-	hmac_md5_final(v2_session_response, &context);
-/*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
+	unsigned int rc;
+	unsigned char sec_key[CIFS_NTLMV2_SESSKEY_SIZE];
+	struct crypto_blkcipher *tfm_arc4;
+	struct scatterlist sgin, sgout;
+	struct blkcipher_desc desc;
+
+	get_random_bytes(sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
+
+	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)",
+						0, CRYPTO_ALG_ASYNC);
+	if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
+		cERROR(1, "could not allocate " "master crypto API arc4\n");
+		return 1;
+	}
+
+	desc.tfm = tfm_arc4;
+
+	crypto_blkcipher_setkey(tfm_arc4,
+		server->mac_signing_key.data.ntlmv2.key, CIFS_CPHTXT_SIZE);
+	sg_init_one(&sgin, sec_key, CIFS_CPHTXT_SIZE);
+	sg_init_one(&sgout, server->ntlmssp.ciphertext, CIFS_CPHTXT_SIZE);
+	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS_CPHTXT_SIZE);
+
+	if (!rc) {
+		memcpy(server->mac_signing_key.data.ntlmv2.key,
+				sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
+	}
+
+	crypto_free_blkcipher(tfm_arc4);
+
+	return 0;
+}
+
+void
+cifs_crypto_hash_release(struct TCP_Server_Info *server)
+{
+	if (server->ntlmssp.tfm_hmacmd5)
+		crypto_free_hash(server->ntlmssp.tfm_hmacmd5);
+
+	if (server->ntlmssp.tfm_md5)
+		crypto_free_hash(server->ntlmssp.tfm_md5);
+}
+
+int
+cifs_crypto_hash_allocate(struct TCP_Server_Info *server)
+{
+	server->ntlmssp.tfm_hmacmd5 = crypto_alloc_hash("hmac(md5)",
+						0, CRYPTO_ALG_ASYNC);
+	if (!server->ntlmssp.tfm_hmacmd5 ||
+			IS_ERR(server->ntlmssp.tfm_hmacmd5)) {
+		cERROR(1, "could not allocate master crypto API hmacmd5\n");
+		return 1;
+	}
+
+	server->ntlmssp.tfm_md5 = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
+	if (!server->ntlmssp.tfm_md5 || IS_ERR(server->ntlmssp.tfm_md5)) {
+		crypto_free_hash(server->ntlmssp.tfm_hmacmd5);
+		cERROR(1, "could not allocate master crypto API md5\n");
+		return 1;
+	}
+
+	return 0;
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c4c5175..488b806 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -25,6 +25,9 @@
 #include <linux/slow-work.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+
 /*
  * The sizes of various internal tables and strings
  */
@@ -120,6 +123,14 @@ struct cifs_cred {
 	struct cifs_ace *aces;
 };
 
+struct ntlmssp_auth {
+	__u32 client_flags;
+	__u32 server_flags;
+	unsigned char ciphertext[CIFS_CPHTXT_SIZE];
+	struct crypto_hash *tfm_hmacmd5;
+	struct crypto_hash *tfm_md5;
+};
+
 /*
  *****************************************************************
  * Except the CIFS PDUs themselves all the
@@ -189,6 +200,7 @@ struct TCP_Server_Info {
 	/* extended security flavors that server supports */
 	unsigned int tilen; /* length of the target info blob */
 	unsigned char *tiblob; /* target info blob in challenge response */
+	struct ntlmssp_auth ntlmssp; /* various keys, ciphers, flags */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2eaebbd..b1463bd 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -361,15 +361,15 @@ extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
 extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
 			  __u32 *);
 extern int cifs_verify_signature(struct smb_hdr *,
-				 const struct mac_key *mac_key,
+				 struct TCP_Server_Info *server,
 				__u32 expected_sequence_number);
 extern int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
 				 const char *pass);
-extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
-			const struct nls_table *);
-extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
-extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
+extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
 			     const struct nls_table *);
+extern int cifs_crypto_hash_allocate(struct TCP_Server_Info *);
+extern void cifs_crypto_hash_release(struct TCP_Server_Info *);
+extern int calc_seckey(struct TCP_Server_Info *);
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern void calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2a43a0a..f8b2052 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1705,6 +1705,7 @@ cifs_put_smb_ses(struct cifsSesInfo *ses)
 		CIFSSMBLogoff(xid, ses);
 		_FreeXid(xid);
 	}
+	cifs_crypto_hash_release(server);
 	sesInfoFree(ses);
 	cifs_put_tcp_session(server);
 }
@@ -1784,13 +1785,21 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	ses->linux_uid = volume_info->linux_uid;
 	ses->overrideSecFlg = volume_info->secFlg;
 
+	rc = cifs_crypto_hash_allocate(server);
+	if (rc) {
+		cERROR(1, "could not setup hash structures rc %d", rc);
+		goto get_ses_fail;
+	}
+
 	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(xid, ses);
 	if (!rc)
 		rc = cifs_setup_session(xid, ses, volume_info->local_nls);
 	mutex_unlock(&ses->session_mutex);
-	if (rc)
+	if (rc) {
+		cifs_crypto_hash_release(ses->server);
 		goto get_ses_fail;
+	}
 
 	/* success, put it on the list */
 	write_lock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 32871a5..04d30cc 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -466,6 +466,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 				   struct cifsSesInfo *ses,
 				   const struct nls_table *nls_cp, bool first)
 {
+	int rc;
 	unsigned int size;
 	AUTHENTICATE_MESSAGE *sec_blob = (AUTHENTICATE_MESSAGE *)pbuffer;
 	__u32 flags;
@@ -494,13 +495,16 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->LmChallengeResponse.MaximumLength = 0;
 
 	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
-	setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
+	rc = setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
+	if (rc) {
+		cERROR(1, "error rc: %d during ntlmssp ntlmv2 setup", rc);
+		goto setup_ntlmv2_ret;
+	}
 	size =  sizeof(struct ntlmv2_resp);
 	memcpy(tmp, (char *)&ntlmv2_response, size);
 	tmp += size;
 	if (ses->server->tilen > 0) {
 		memcpy(tmp, ses->server->tiblob, ses->server->tilen);
-		kfree(ses->server->tiblob);
 		tmp += ses->server->tilen;
 	} else
 		ses->server->tilen = 0;
@@ -547,9 +551,26 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->WorkstationName.MaximumLength = 0;
 	tmp += 2;
 
-	sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
-	sec_blob->SessionKey.Length = 0;
-	sec_blob->SessionKey.MaximumLength = 0;
+	if ((ses->server->ntlmssp.server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) &&
+			!calc_seckey(ses->server)) {
+		memcpy(tmp, ses->server->ntlmssp.ciphertext, CIFS_CPHTXT_SIZE);
+		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
+		sec_blob->SessionKey.Length = cpu_to_le16(CIFS_CPHTXT_SIZE);
+		sec_blob->SessionKey.MaximumLength =
+			cpu_to_le16(CIFS_CPHTXT_SIZE);
+		tmp += CIFS_CPHTXT_SIZE;
+	} else {
+		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
+		sec_blob->SessionKey.Length = 0;
+		sec_blob->SessionKey.MaximumLength = 0;
+	}
+
+	ses->server->sequence_number = 0;
+
+setup_ntlmv2_ret:
+	if (ses->server->tilen > 0)
+		kfree(ses->server->tiblob);
+
 	return tmp - pbuffer;
 }
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 82f78c4..e0588cd 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -543,7 +543,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 					     SECMODE_SIGN_ENABLED))) {
 			rc = cifs_verify_signature(midQ->resp_buf,
-						&ses->server->mac_signing_key,
+						ses->server,
 						midQ->sequence_number+1);
 			if (rc) {
 				cERROR(1, "Unexpected SMB signature");
@@ -731,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 					     SECMODE_SIGN_ENABLED))) {
 			rc = cifs_verify_signature(out_buf,
-						&ses->server->mac_signing_key,
+						ses->server,
 						midQ->sequence_number+1);
 			if (rc) {
 				cERROR(1, "Unexpected SMB signature");
@@ -981,7 +981,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 				     SECMODE_SIGN_ENABLED))) {
 		rc = cifs_verify_signature(out_buf,
-					   &ses->server->mac_signing_key,
+					   ses->server,
 					   midQ->sequence_number+1);
 		if (rc) {
 			cERROR(1, "Unexpected SMB signature");
-- 
1.6.0.2
