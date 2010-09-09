From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH -v2 2/6] ntlmv2/ntlmssp  ntlmssp autentication code
Date: Thu,  9 Sep 2010 13:12:40 -0500
Message-ID: <1284055960-792-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

To calculate ntlmv2 response we need ti/av pair blob.

For sec mech like ntlmssp, the blob is plucked from type 2 response from
the server.  From this blob, netbios name of the domain is retrieved,
if user has not already provided, to be included in the Target String
as part of ntlmv2 hash calculations.

For sec mech like ntlmv2, create a minimal, two av pair blob.

The allocated blob is freed in case of error.  In case there is no error,
this blob is used in calculating ntlmv2 response (in CalcNTLMv2_response)
and is also copied on the response to the server, and then freed.

The type 3 ntlmssp response is prepared on a buffer,
5 * sizeof of struct _AUTHENTICATE_MESSAGE, an empirical value large
enough to hold _AUTHENTICATE_MESSAGE plus a blob with max possible
10 values as part of ntlmv2 response and lmv2 keys and domain, user,
workstation  names etc.

Also, kerberos gets selected as a default mechanism if server supports it,
over the other security mechanisms.

The reason mac_key was changed to session key is, this structure does not hold
message authentication code, it holds the session key (for ntlmv2, ntlmv1 etc.).
mac is generated as a signature in cifs_calc* functions.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   58 +++++++++++++++++++++++-------
 fs/cifs/cifsglob.h    |    4 +-
 fs/cifs/cifsproto.h   |    6 ++--
 fs/cifs/cifssmb.c     |   16 +++++----
 fs/cifs/sess.c        |   93 ++++++++++++++++++++++++++++++++++--------------
 fs/cifs/transport.c   |    6 ++--
 6 files changed, 128 insertions(+), 55 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 346fb64..7e15cd0 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -43,7 +43,8 @@ extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 		       unsigned char *p24);
 
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
-				    const struct mac_key *key, char *signature)
+				    const struct session_key *key,
+					char *signature)
 {
 	struct	MD5Context context;
 
@@ -79,7 +80,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 	server->sequence_number++;
 	spin_unlock(&GlobalMid_Lock);
 
-	rc = cifs_calculate_signature(cifs_pdu, &server->mac_signing_key,
+	rc = cifs_calculate_signature(cifs_pdu, &server->session_key,
 				      smb_signature);
 	if (rc)
 		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
@@ -90,7 +91,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 }
 
 static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
-				const struct mac_key *key, char *signature)
+				const struct session_key *key, char *signature)
 {
 	struct  MD5Context context;
 	int i;
@@ -146,7 +147,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 	server->sequence_number++;
 	spin_unlock(&GlobalMid_Lock);
 
-	rc = cifs_calc_signature2(iov, n_vec, &server->mac_signing_key,
+	rc = cifs_calc_signature2(iov, n_vec, &server->session_key,
 				      smb_signature);
 	if (rc)
 		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
@@ -157,14 +158,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 }
 
 int cifs_verify_signature(struct smb_hdr *cifs_pdu,
-			  const struct mac_key *mac_key,
+			  const struct session_key *session_key,
 			  __u32 expected_sequence_number)
 {
 	unsigned int rc;
 	char server_response_sig[8];
 	char what_we_think_sig_should_be[20];
 
-	if ((cifs_pdu == NULL) || (mac_key == NULL))
+	if (cifs_pdu == NULL || session_key == NULL)
 		return -EINVAL;
 
 	if (cifs_pdu->Command == SMB_COM_NEGOTIATE)
@@ -193,7 +194,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 					cpu_to_le32(expected_sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
-	rc = cifs_calculate_signature(cifs_pdu, mac_key,
+	rc = cifs_calculate_signature(cifs_pdu, session_key,
 		what_we_think_sig_should_be);
 
 	if (rc)
@@ -210,7 +211,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 }
 
 /* We fill in key by putting in 40 byte array which was allocated by caller */
-int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
+int cifs_calculate_session_key(struct session_key *key, const char *rn,
 			   const char *password)
 {
 	char temp_key[16];
@@ -395,7 +396,8 @@ calc_exit_2:
 	return rc;
 }
 
-void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
+int
+setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 		      const struct nls_table *nls_cp)
 {
 	int rc;
@@ -408,20 +410,46 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
 	buf->reserved2 = 0;
 
+	if (ses->server->secType == RawNTLMSSP) {
+		if (!ses->domainName) {
+			rc = find_domain_name(ses);
+			if (rc) {
+				cERROR(1, "error %d finding domain name", rc);
+				goto setup_ntlmv2_rsp_ret;
+			}
+		}
+	} else {
+		rc = build_avpair_blob(ses);
+		if (rc) {
+			cERROR(1, "error %d building av pair blob", rc);
+			return rc;
+		}
+	}
+
 	/* calculate buf->ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, nls_cp);
-	if (rc)
+	if (rc) {
 		cERROR(1, "could not get v2 hash rc %d", rc);
+		goto setup_ntlmv2_rsp_ret;
+	}
 	CalcNTLMv2_response(ses, resp_buf);
 
 	/* now calculate the MAC key for NTLMv2 */
 	hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
 	hmac_md5_update(resp_buf, 16, &context);
-	hmac_md5_final(ses->server->mac_signing_key.data.ntlmv2.key, &context);
+	hmac_md5_final(ses->server->session_key.data.ntlmv2.key, &context);
 
-	memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp, resp_buf,
+	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
 	       sizeof(struct ntlmv2_resp));
-	ses->server->mac_signing_key.len = 16 + sizeof(struct ntlmv2_resp);
+	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
+
+	return 0;
+
+setup_ntlmv2_rsp_ret:
+	kfree(ses->tiblob);
+	ses->tilen = 0;
+
+	return rc;
 }
 
 void CalcNTLMv2_response(const struct cifsSesInfo *ses,
@@ -435,6 +463,10 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
 	hmac_md5_update(v2_session_response+8,
 			sizeof(struct ntlmv2_resp) - 8, &context);
 
+	if (ses->tilen)
+		hmac_md5_update(ses->tiblob,
+			ses->tilen, &context);
+
 	hmac_md5_final(v2_session_response, &context);
 /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2bfe682..c68f31c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -97,7 +97,7 @@ enum protocolEnum {
 	/* Netbios frames protocol not supported at this time */
 };
 
-struct mac_key {
+struct session_key {
 	unsigned int len;
 	union {
 		char ntlm[CIFS_SESS_KEY_SIZE + 16];
@@ -182,7 +182,7 @@ struct TCP_Server_Info {
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* needed for CIFS PDU signature */
-	struct mac_key mac_signing_key;
+	struct session_key session_key;
 	char ntlmv2_hash[16];
 	unsigned long lstrp; /* when we got last response from this server */
 	u16 dialect; /* dialect index that server chose */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1d60c65..c155479 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -362,12 +362,12 @@ extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
 extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
 			  __u32 *);
 extern int cifs_verify_signature(struct smb_hdr *,
-				 const struct mac_key *mac_key,
+				 const struct session_key *session_key,
 				__u32 expected_sequence_number);
-extern int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
+extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
 				 const char *pass);
 extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
-extern void setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
+extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
 			     const struct nls_table *);
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern void calc_lanman_hash(const char *password, const char *cryptkey,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..13c854e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -603,13 +603,15 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 				rc = 0;
 			else
 				rc = -EINVAL;
-
-			if (server->sec_kerberos || server->sec_mskerberos)
-				server->secType = Kerberos;
-			else if (server->sec_ntlmssp)
-				server->secType = RawNTLMSSP;
-			else
-				rc = -EOPNOTSUPP;
+			if (server->secType == Kerberos) {
+				if (!server->sec_kerberos &&
+						!server->sec_mskerberos)
+					rc = -EOPNOTSUPP;
+			} else if (server->secType == RawNTLMSSP) {
+				if (!server->sec_ntlmssp)
+					rc = -EOPNOTSUPP;
+			} else
+					rc = -EOPNOTSUPP;
 		}
 	} else
 		server->capabilities &= ~CAP_EXTENDED_SECURITY;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2de5f08..8f44fde 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -440,7 +440,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 	/* BB is NTLMV2 session security format easier to use here? */
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
+		NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->secMode &
 	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
@@ -466,10 +466,12 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 				   struct cifsSesInfo *ses,
 				   const struct nls_table *nls_cp, bool first)
 {
+	int rc;
+	unsigned int size;
 	AUTHENTICATE_MESSAGE *sec_blob = (AUTHENTICATE_MESSAGE *)pbuffer;
 	__u32 flags;
 	unsigned char *tmp;
-	char ntlm_session_key[CIFS_SESS_KEY_SIZE];
+	struct ntlmv2_resp ntlmv2_response = {};
 
 	memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
 	sec_blob->MessageType = NtLmAuthenticate;
@@ -477,7 +479,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	flags = NTLMSSP_NEGOTIATE_56 |
 		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
+		NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->secMode &
 	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
@@ -492,19 +494,26 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->LmChallengeResponse.Length = 0;
 	sec_blob->LmChallengeResponse.MaximumLength = 0;
 
-	/* calculate session key,  BB what about adding similar ntlmv2 path? */
-	SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_session_key);
-	if (first)
-		cifs_calculate_mac_key(&ses->server->mac_signing_key,
-				       ntlm_session_key, ses->password);
-
-	memcpy(tmp, ntlm_session_key, CIFS_SESS_KEY_SIZE);
 	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
-	sec_blob->NtChallengeResponse.Length = cpu_to_le16(CIFS_SESS_KEY_SIZE);
-	sec_blob->NtChallengeResponse.MaximumLength =
-				cpu_to_le16(CIFS_SESS_KEY_SIZE);
+	rc = setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
+	if (rc) {
+		cERROR(1, "Error %d during NTLMSSP authentication", rc);
+		goto setup_ntlmv2_ret;
+	}
+	size =  sizeof(struct ntlmv2_resp);
+	memcpy(tmp, (char *)&ntlmv2_response, size);
+	tmp += size;
+	if (ses->tilen > 0) {
+		memcpy(tmp, ses->tiblob, ses->tilen);
+		tmp += ses->tilen;
+	}
 
-	tmp += CIFS_SESS_KEY_SIZE;
+	sec_blob->NtChallengeResponse.Length = cpu_to_le16(size +
+			ses->tilen);
+	sec_blob->NtChallengeResponse.MaximumLength =
+			cpu_to_le16(size + ses->tilen);
+	kfree(ses->tiblob);
+	ses->tilen = 0;
 
 	if (ses->domainName == NULL) {
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
@@ -516,7 +525,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		len = cifs_strtoUCS((__le16 *)tmp, ses->domainName,
 				    MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
-		len += 2; /* trailing null */
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->DomainName.Length = cpu_to_le16(len);
 		sec_blob->DomainName.MaximumLength = cpu_to_le16(len);
@@ -533,7 +541,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		len = cifs_strtoUCS((__le16 *)tmp, ses->userName,
 				    MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
-		len += 2; /* trailing null */
 		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->UserName.Length = cpu_to_le16(len);
 		sec_blob->UserName.MaximumLength = cpu_to_le16(len);
@@ -548,6 +555,8 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
 	sec_blob->SessionKey.Length = 0;
 	sec_blob->SessionKey.MaximumLength = 0;
+
+setup_ntlmv2_ret:
 	return tmp - pbuffer;
 }
 
@@ -561,15 +570,14 @@ static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
 	return;
 }
 
-static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
+static int setup_ntlmssp_auth_req(char *ntlmsspblob,
 				  struct cifsSesInfo *ses,
 				  const struct nls_table *nls, bool first_time)
 {
 	int bloblen;
 
-	bloblen = build_ntlmssp_auth_blob(&pSMB->req.SecurityBlob[0], ses, nls,
+	bloblen = build_ntlmssp_auth_blob(ntlmsspblob, ses, nls,
 					  first_time);
-	pSMB->req.SecurityBlobLength = cpu_to_le16(bloblen);
 
 	return bloblen;
 }
@@ -705,7 +713,7 @@ ssetup_ntlmssp_authenticate:
 
 		if (first_time) /* should this be moved into common code
 				  with similar ntlmv2 path? */
-			cifs_calculate_mac_key(&ses->server->mac_signing_key,
+			cifs_calculate_session_key(&ses->server->session_key,
 				ntlm_session_key, ses->password);
 		/* copy session key */
 
@@ -744,12 +752,23 @@ ssetup_ntlmssp_authenticate:
 			cpu_to_le16(sizeof(struct ntlmv2_resp));
 
 		/* calculate session key */
-		setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
-		/* FIXME: calculate MAC key */
+		rc = setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
+		if (rc) {
+			cERROR(1, "Error %d during NTLMv2 authentication", rc);
+			kfree(v2_sess_key);
+			goto ssetup_exit;
+		}
 		memcpy(bcc_ptr, (char *)v2_sess_key,
 		       sizeof(struct ntlmv2_resp));
 		bcc_ptr += sizeof(struct ntlmv2_resp);
 		kfree(v2_sess_key);
+		if (ses->tilen > 0) {
+			memcpy(bcc_ptr, ses->tiblob,
+				ses->tilen);
+			bcc_ptr += ses->tilen;
+			kfree(ses->tiblob);
+			ses->tilen = 0;
+		}
 		if (ses->capabilities & CAP_UNICODE) {
 			if (iov[0].iov_len % 2) {
 				*bcc_ptr = 0;
@@ -780,15 +799,15 @@ ssetup_ntlmssp_authenticate:
 		}
 		/* bail out if key is too long */
 		if (msg->sesskey_len >
-		    sizeof(ses->server->mac_signing_key.data.krb5)) {
+		    sizeof(ses->server->session_key.data.krb5)) {
 			cERROR(1, "Kerberos signing key too long (%u bytes)",
 				msg->sesskey_len);
 			rc = -EOVERFLOW;
 			goto ssetup_exit;
 		}
 		if (first_time) {
-			ses->server->mac_signing_key.len = msg->sesskey_len;
-			memcpy(ses->server->mac_signing_key.data.krb5,
+			ses->server->session_key.len = msg->sesskey_len;
+			memcpy(ses->server->session_key.data.krb5,
 				msg->data, msg->sesskey_len);
 		}
 		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
@@ -830,12 +849,33 @@ ssetup_ntlmssp_authenticate:
 			if (phase == NtLmNegotiate) {
 				setup_ntlmssp_neg_req(pSMB, ses);
 				iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
+				iov[1].iov_base = &pSMB->req.SecurityBlob[0];
 			} else if (phase == NtLmAuthenticate) {
 				int blob_len;
-				blob_len = setup_ntlmssp_auth_req(pSMB, ses,
+				char *ntlmsspblob;
+
+				/* 5 is an empirical value, large enought to
+				 * hold authenticate message, max 10 of
+				 * av paris, doamin,user,workstation mames,
+				 * flags etc..
+				 */
+				ntlmsspblob = kmalloc(5 *
+					sizeof(struct _AUTHENTICATE_MESSAGE),
+					GFP_KERNEL);
+				if (!ntlmsspblob) {
+					cERROR(1, "Can't allocate NTLMSSP");
+					rc = -ENOMEM;
+					goto ssetup_exit;
+				}
+
+				blob_len = setup_ntlmssp_auth_req(ntlmsspblob,
+								ses,
 								  nls_cp,
 								  first_time);
 				iov[1].iov_len = blob_len;
+				iov[1].iov_base = ntlmsspblob;
+				pSMB->req.SecurityBlobLength =
+					cpu_to_le16(blob_len);
 				/* Make sure that we tell the server that we
 				   are using the uid that it just gave us back
 				   on the response (challenge) */
@@ -845,7 +885,6 @@ ssetup_ntlmssp_authenticate:
 				rc = -ENOSYS;
 				goto ssetup_exit;
 			}
-			iov[1].iov_base = &pSMB->req.SecurityBlob[0];
 			/* unicode strings must be word aligned */
 			if ((iov[0].iov_len + iov[1].iov_len) % 2) {
 				*bcc_ptr = 0;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 82f78c4..a66c91e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -543,7 +543,7 @@ SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
 		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 					     SECMODE_SIGN_ENABLED))) {
 			rc = cifs_verify_signature(midQ->resp_buf,
-						&ses->server->mac_signing_key,
+						&ses->server->session_key,
 						midQ->sequence_number+1);
 			if (rc) {
 				cERROR(1, "Unexpected SMB signature");
@@ -731,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
 		    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 					     SECMODE_SIGN_ENABLED))) {
 			rc = cifs_verify_signature(out_buf,
-						&ses->server->mac_signing_key,
+						&ses->server->session_key,
 						midQ->sequence_number+1);
 			if (rc) {
 				cERROR(1, "Unexpected SMB signature");
@@ -981,7 +981,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifsTconInfo *tcon,
 	    (ses->server->secMode & (SECMODE_SIGN_REQUIRED |
 				     SECMODE_SIGN_ENABLED))) {
 		rc = cifs_verify_signature(out_buf,
-					   &ses->server->mac_signing_key,
+					   &ses->server->session_key,
 					   midQ->sequence_number+1);
 		if (rc) {
 			cERROR(1, "Unexpected SMB signature");
-- 
1.6.0.2
