From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH -v2 6/6] convert signature calculations to use crypto apis
Date: Thu,  9 Sep 2010 13:13:45 -0500
Message-ID: <1284056025-892-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Use crypto apis to generate smb signagtures.

Use hmac-md5 to genereate ntlmv2 hash, ntlmv2 response, and HMAC (CR1 of
ntlmv2 auth blob.
User crypto apis to genereate signature and to verify signature.
md5 hash is used to calculate signature.
Use secondary key to calculate signature in case of ntlmssp.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   92 +++++++++++++++++++++++++++++++++---------------
 fs/cifs/cifsproto.h   |    2 +-
 fs/cifs/transport.c   |    6 ++--
 3 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index e72b0e5..96437df 100644
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
+	if (!server->secmech.sdescmd5) {
+		cERROR(1,
+			"cifs_calculate_signature: can't generate signature\n");
+		return -1;
+	}
 
-	cifs_MD5_final(signature, &context);
-	return 0;
+	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
+	if (rc) {
+		cERROR(1, "cifs_calculate_signature: oould not init md5\n");
+		return rc;
+	}
+
+	if (server->secType == RawNTLMSSP)
+		crypto_shash_update(&server->secmech.sdescmd5->shash,
+			server->ntlmssp.sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
+	else
+		crypto_shash_update(&server->secmech.sdescmd5->shash,
+			(char *)&server->session_key.data,
+			server->session_key.len);
+
+	crypto_shash_update(&server->secmech.sdescmd5->shash,
+			cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
+
+	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
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
+	if (!server->secmech.sdescmd5) {
+		cERROR(1, "cifs_calc_signature2: can't generate signature\n");
+		return -1;
+	}
+
+	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
+	if (rc) {
+		cERROR(1, "cifs_calc_signature2: oould not init md5\n");
+		return rc;
+	}
+
+	if (server->secType == RawNTLMSSP)
+		crypto_shash_update(&server->secmech.sdescmd5->shash,
+			server->ntlmssp.sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
+	else
+		crypto_shash_update(&server->secmech.sdescmd5->shash,
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
 
-	if (cifs_pdu == NULL || session_key == NULL)
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
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8fe46f5..c3d3472 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -362,7 +362,7 @@ extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
 extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
 			  __u32 *);
 extern int cifs_verify_signature(struct smb_hdr *,
-				 const struct session_key *session_key,
+				 struct TCP_Server_Info *server,
 				__u32 expected_sequence_number);
 extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
 				 const char *pass);
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
