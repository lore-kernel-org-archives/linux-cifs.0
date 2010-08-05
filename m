From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [linux-smb2-client][patch] Make NTLMv2 as auth mech within NTLMSSP and enable signing using crypto shash APIs
Date: Wed,  4 Aug 2010 23:01:43 -0500
Message-ID: <1280980903-4594-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make ntlmv2 as an authentication mechanism within ntlmssp
instead of ntlmv1.
Parse type 2 response in ntlmssp negotiation to pluck
AV pairs and use them to calculate ntlmv2 response token.
Also, assign domain name from the sever response in type 2
packet of ntlmssp and use that (netbios) domain name in
calculation of response.

Enable cifs/smb signing using rc4 and hmac-sha256.

Changed name of the structure mac_key to session_key to reflect
the type of key it holds.

Use kernel crypto_shash_* APIs instead of the equivalent cifs functions.


>From 42320e9889118b93bb747859b5d47af0803da378 Mon Sep 17 00:00:00 2001
From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, 4 Aug 2010 22:58:42 -0500
Subject: [PATCH] Make ntlmv2 as auth mech and enable signing using crypto_shash APIs

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/smb2/connect.c     |   11 ++-
 fs/smb2/ntlmssp.c     |  154 ++++++++++++-------
 fs/smb2/ntlmssp.h     |   13 ++
 fs/smb2/smb2encrypt.c |  418 +++++++++++++++++++++++++++++++++----------------
 fs/smb2/smb2glob.h    |   20 ++-
 fs/smb2/smb2pdu.c     |    2 +-
 fs/smb2/smb2pdu.h     |   16 ++-
 fs/smb2/smb2proto.h   |   11 +-
 fs/smb2/transport.c   |    6 +-
 9 files changed, 442 insertions(+), 209 deletions(-)

diff --git a/fs/smb2/connect.c b/fs/smb2/connect.c
index 97909a0..f515fee 100644
--- a/fs/smb2/connect.c
+++ b/fs/smb2/connect.c
@@ -430,6 +430,7 @@ smb2_put_smb_ses(struct smb2_ses *ses)
 		SMB2_logoff(xid, ses);
 		_free_xid2(xid);
 	}
+	smb2_crypto_hash_release(server);
 	smb2_ses_info_free(ses);
 	smb2_put_tcp_session(server);
 }
@@ -1606,12 +1607,20 @@ smb2_mount(struct super_block *sb, struct smb2_sb_info *smb2_sb,
 			pSMB2_ses = NULL;
 			goto mount_out;
 		}
+		rc = smb2_crypto_hash_allocate(pSMB2_ses->server);
+		if (rc) {
+			sERROR(1, "could not setup hash structures rc %d", rc);
+			goto mount_out;
+		}
+
 		down(&pSMB2_ses->ses_sem);
 		rc = smb2_setup_session(xid, pSMB2_ses,
 				smb2_sb->local_nls);
 		up(&pSMB2_ses->ses_sem);
-		if (rc)
+		if (rc) {
+			smb2_crypto_hash_release(pSMB2_ses->server);
 			goto mount_out;
+		}
 	}
 
 	sFYI(1, "about to search for tcon matching %s", vol_info->UNC);
diff --git a/fs/smb2/ntlmssp.c b/fs/smb2/ntlmssp.c
index e1e9fe6..d89c792 100644
--- a/fs/smb2/ntlmssp.c
+++ b/fs/smb2/ntlmssp.c
@@ -22,6 +22,9 @@
 /* TODO: Move this to common include directory with CIFS (which should
    eventually have a nearly identical file BB FIXME */
 
+#include <linux/utsname.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include "smb2pdu.h"
 #include "smb2glob.h"
 #include "smb2proto.h"
@@ -31,6 +34,8 @@
 
 int decode_ntlmssp_challenge_blob(__u8 *buf, int blob_len, struct smb2_ses *ses)
 {
+	unsigned int tioffset; /* challeng message target info area */
+	unsigned int tilen; /* challeng message target info area length  */
 	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)buf;
 
 	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
@@ -53,6 +58,20 @@ int decode_ntlmssp_challenge_blob(__u8 *buf, int blob_len, struct smb2_ses *ses)
 	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
 		we must set the MIC field of the AUTHENTICATE_MESSAGE */
 
+	ses->server->ntlmssp.server_flags = le32_to_cpu(pblob->NegotiateFlags);
+
+	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
+	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
+	ses->server->tilen = tilen;
+	if (tilen) {
+		ses->server->tiblob = kmalloc(tilen, GFP_KERNEL);;
+		if (!ses->server->tiblob) {
+			sERROR(1, "Challenge target info allocation failure");
+			return -ENOMEM;
+		}
+		memcpy(ses->server->tiblob,  buf + tioffset, tilen);
+	}
+
 	return 0;
 }
 
@@ -74,8 +93,8 @@ void build_ntlmssp_negotiate_blob(char *ntlmssp_buf,
 	/* BB is NTLMV2 session security format easier to use here? */
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM |
-		NTLMSSP_NEGOTIATE_SIGN;
+		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_EXTENDED_SEC |
+		NTLMSSP_NEGOTIATE_SIGN | NTLMSSP_NEGOTIATE_KEY_XCH;
 	if (ses->server->sec_mode & SMB2SEC_MUST_SIGN)
 		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
 
@@ -97,44 +116,57 @@ void build_ntlmssp_negotiate_blob(char *ntlmssp_buf,
 int build_ntlmssp_auth_blob(unsigned char *pbuffer, struct smb2_ses *ses,
 			    const struct nls_table *nls_cp)
 {
+	int rc = 0;
+	int size = 0;
 	AUTHENTICATE_MESSAGE *sec_blob = (AUTHENTICATE_MESSAGE *)pbuffer;
 	__u32 flags;
 	unsigned char *tmp;
-	char ntlm_session_key[SMB2_SESS_KEY_SIZE];
+	wchar_t *hostname;
+	char *nodename = utsname()->nodename;
+	struct ntlmv2_resp ntlmv2_response = {};
+	char lm_response[SMB2_SESS_KEY_SIZE] = {0x0};
 
 	memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
 	sec_blob->MessageType = NtLmAuthenticate;
+	sec_blob->NegotiateFlags = 0x0;
 
-	flags = NTLMSSP_NEGOTIATE_56 |
-		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
-		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM |
-		NTLMSSP_NEGOTIATE_SIGN;
-	if (ses->server->sec_mode & SMB2SEC_MUST_SIGN)
-		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
+	flags = NTLMSSP_NEGOTIATE_56 | NTLMSSP_NEGOTIATE_KEY_XCH |
+		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_ALWAYS_SIGN |
+		NTLMSSP_NEGOTIATE_EXTENDED_SEC |
+		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_SIGN |
+		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_UNICODE;
 
-	tmp = pbuffer + sizeof(AUTHENTICATE_MESSAGE);
 	sec_blob->NegotiateFlags |= cpu_to_le32(flags);
 
-	sec_blob->LmChallengeResponse.BufferOffset =
-				cpu_to_le32(sizeof(AUTHENTICATE_MESSAGE));
-	sec_blob->LmChallengeResponse.Length = 0;
-	sec_blob->LmChallengeResponse.MaximumLength = 0;
+	tmp = pbuffer + sizeof(AUTHENTICATE_MESSAGE);
 
-	/* calculate session key,  BB what about adding similar ntlmv2 path? */
-	SMB2encrypt(ses->password, ses->server->crypt_key, ntlm_session_key,
-		    nls_cp);
-	/* BB do we have to restrict the following to the 1st time? */
-	smb2_calculate_mac_key(&ses->server->mac_signing_key,
-				       ntlm_session_key, ses->password, nls_cp);
+	sec_blob->LmChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
+	size = SMB2_SESS_KEY_SIZE;
+	sec_blob->LmChallengeResponse.Length = cpu_to_le16(size);
+	sec_blob->LmChallengeResponse.MaximumLength = cpu_to_le16(size);
+	memcpy(tmp, (char *)&lm_response, size);
+	tmp += size;
 
-	memcpy(tmp, ntlm_session_key, SMB2_SESS_KEY_SIZE);
 	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
-	sec_blob->NtChallengeResponse.Length = cpu_to_le16(SMB2_SESS_KEY_SIZE);
+	rc = smb2_setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
+	if (rc) {
+		sERROR(1, "error rc: %d during ntlmssp ntlmv2 setup", rc);
+		goto smb2_setup_ntlmv2_rsp_ret;
+	}
+	size =  sizeof(struct ntlmv2_resp);
+	memcpy(tmp, (char *)&ntlmv2_response, size);
+	tmp += size;
+
+	if (ses->server->tilen > 0) {
+		memcpy(tmp, ses->server->tiblob, ses->server->tilen);
+		tmp += ses->server->tilen;
+	} else
+		ses->server->tilen = 0;
+
+	sec_blob->NtChallengeResponse.Length = cpu_to_le16(size +
+							ses->server->tilen);
 	sec_blob->NtChallengeResponse.MaximumLength =
-				cpu_to_le16(SMB2_SESS_KEY_SIZE);
-
-	tmp += SMB2_SESS_KEY_SIZE;
+					cpu_to_le16(size + ses->server->tilen);
 
 	if (ses->domain_name == NULL) {
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
@@ -168,36 +200,48 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer, struct smb2_ses *ses,
 		tmp += len;
 	}
 
-	sec_blob->WorkstationName.BufferOffset = cpu_to_le32(tmp - pbuffer);
-	sec_blob->WorkstationName.Length = 0;
-	sec_blob->WorkstationName.MaximumLength = 0;
-	tmp += 2;
-
-	sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
-	sec_blob->SessionKey.Length = 0;
-	sec_blob->SessionKey.MaximumLength = 0;
-	return tmp - pbuffer;
-}
+	if (nodename == NULL) {
+		sec_blob->WorkstationName.BufferOffset =
+				cpu_to_le32(tmp - pbuffer);
+		sec_blob->WorkstationName.Length = 0;
+		sec_blob->WorkstationName.MaximumLength = 0;
+		tmp += 2;
+	} else {
+		int len = strlen(ses->username);
+		hostname = kmalloc(2 + (len * 2), GFP_KERNEL);
+		if (hostname) {
+			len = smb2_strtoUCS((__le16 *)hostname, nodename,
+					MAX_USERNAME_SIZE, nls_cp);
+			uni_strupr(hostname);
+			memcpy(tmp, hostname, len*2);
+			kfree(hostname);
+			len *= 2;
+			sec_blob->WorkstationName.BufferOffset =
+					cpu_to_le32(tmp - pbuffer);
+			sec_blob->WorkstationName.Length = cpu_to_le16(len);
+			sec_blob->WorkstationName.MaximumLength =
+					cpu_to_le16(len);
+			tmp += len;
+		}
+	}
 
+	if ((ses->server->ntlmssp.server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) &&
+			!calc_seckey(ses->server)) {
+		memcpy(tmp, ses->server->ntlmssp.ciphertext, SMB2_CPHTXT_SIZE);
+		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
+		sec_blob->SessionKey.Length = cpu_to_le16(SMB2_CPHTXT_SIZE);
+		sec_blob->SessionKey.MaximumLength =
+						cpu_to_le16(SMB2_CPHTXT_SIZE);
+		tmp += SMB2_CPHTXT_SIZE;
+	} else {
+		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
+		sec_blob->SessionKey.Length = 0;
+		sec_blob->SessionKey.MaximumLength = 0;
+	}
 
-/* static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
-				 struct smb2_ses *ses)
-{
-	build_ntlmssp_negotiate_blob(&pSMB->req.SecurityBlob[0], ses);
-	pSMB->req.SecurityBlobLength = cpu_to_le16(sizeof(NEGOTIATE_MESSAGE));
+smb2_setup_ntlmv2_rsp_ret:
+	if (ses->server->tilen > 0)
+		kfree(ses->server->tiblob);
 
-	return;
+	return tmp - pbuffer;
 }
-
-static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
-				  struct smb2_ses *ses,
-				  const struct nls_table *nls, int first_time)
-{
-	int bloblen;
-
-	bloblen = build_ntlmssp_auth_blob(&pSMB->req.SecurityBlob[0], ses, nls,
-					  first_time);
-	pSMB->req.SecurityBlobLength = cpu_to_le16(bloblen);
-
-	return bloblen;
-} */
diff --git a/fs/smb2/ntlmssp.h b/fs/smb2/ntlmssp.h
index 22db991..97c040c 100644
--- a/fs/smb2/ntlmssp.h
+++ b/fs/smb2/ntlmssp.h
@@ -70,6 +70,19 @@
 /* OpenGroup and to make the code more closely match the standard in */
 /* appearance */
 
+/* Define AV Pair Field IDs */
+#define NTLMSSP_AV_EOL			0
+#define NTLMSSP_AV_NB_COMPUTER_NAME	1
+#define NTLMSSP_AV_NB_DOMAIN_NAME	2
+#define NTLMSSP_AV_DNS_COMPUTER_NAME	3
+#define NTLMSSP_AV_DNS_DOMAIN_NAME	4
+#define NTLMSSP_AV_DNS_TREE_NAME	5
+#define NTLMSSP_AV_FLAGS		6
+#define NTLMSSP_AV_TIMESTAMP		7
+#define NTLMSSP_AV_RESTRICTION		8
+#define NTLMSSP_AV_TARGET_NAME		9
+#define NTLMSSP_AV_CHANNEL_BINDINGS	10
+
 typedef struct _SECURITY_BUFFER {
 	__le16 Length;
 	__le16 MaximumLength;
diff --git a/fs/smb2/smb2encrypt.c b/fs/smb2/smb2encrypt.c
index 253af0c..344db82 100644
--- a/fs/smb2/smb2encrypt.c
+++ b/fs/smb2/smb2encrypt.c
@@ -28,6 +28,7 @@
 #include "md5.h"
 #include "smb2_unicode.h"
 #include "smb2proto.h"
+#include "ntlmssp.h"
 
 /* Calculate and return the SMB2 signature based on the mac key and SMB2 PDU */
 /* the 16 byte signature must be allocated by the caller  */
@@ -95,34 +96,78 @@ SMB2encrypt(unsigned char *passwd, const unsigned char *c8, unsigned char *p24,
 }
 /* BB FIXME replace previous functions (above to mark) */
 
-static int smb2_calculate_signature(const struct smb2_hdr *smb2_pdu,
-				    const struct mac_key *key, char *signature)
+static int smb2_calculate_signature(struct smb2_hdr *smb2_pdu,
+			    struct tcp_srv_inf *server, char *signature)
 {
-	struct	MD5_context context;
-
-	if ((smb2_pdu == NULL) || (signature == NULL) || (key == NULL))
+	int rc = 0;
+	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
+	unsigned char *sigptr = smb2_signature;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(server->ntlmssp.hmacsha256)];
+	} sdesc;
+
+	if (smb2_pdu == NULL || signature == NULL || server == NULL)
 		return -EINVAL;
 
-	smb2_MD5_init(&context);
-	smb2_MD5_update(&context, (char *)&key->data, key->len);
-	smb2_MD5_update(&context, smb2_pdu->ProtocolId,
+	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
+	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
+
+	sdesc.shash.tfm = server->ntlmssp.hmacsha256;
+	sdesc.shash.flags = 0x0;
+
+	crypto_shash_setkey(server->ntlmssp.hmacsha256,
+				server->session_key.data.ntlmv2.key,
+				SMB2_NTLMV2_SESSKEY_SIZE);
+
+	rc = crypto_shash_init(&sdesc.shash);
+	if (rc) {
+		sERROR(1, "could not initialize crypto API sha256\n");
+		goto smb2_calc_sig_ret;
+	}
+
+	crypto_shash_update(&sdesc.shash, smb2_pdu->ProtocolId,
 			be32_to_cpu(smb2_pdu->smb2_buf_length));
 
-	smb2_MD5_final(signature, &context);
-	return 0;
+	rc = crypto_shash_final(&sdesc.shash, sigptr);
+
+	memcpy(signature, sigptr, SMB2_NTLMV2_SESSKEY_SIZE);
+
+smb2_calc_sig_ret:
+	return rc;
 }
 
 static int smb2_calc_signature2(const struct kvec *iov, int n_vec,
-				const struct mac_key *key, char *signature)
+			struct tcp_srv_inf *server, struct smb2_hdr *smb2_pdu)
 {
-	struct  MD5_context context;
 	int i;
-
-	if ((iov == NULL) || (signature == NULL) || (key == NULL))
+	int rc = 0;
+	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
+	unsigned char *sigptr = smb2_signature;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(server->ntlmssp.hmacsha256)];
+	} sdesc;
+
+	if (iov == NULL || server == NULL || smb2_pdu == NULL)
 		return -EINVAL;
 
-	smb2_MD5_init(&context);
-	smb2_MD5_update(&context, (char *)&key->data, key->len);
+	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
+	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
+
+	sdesc.shash.tfm = server->ntlmssp.hmacsha256;
+	sdesc.shash.flags = 0x0;
+
+	crypto_shash_setkey(server->ntlmssp.hmacsha256,
+				server->session_key.data.ntlmv2.key,
+				SMB2_NTLMV2_SESSKEY_SIZE);
+
+	rc = crypto_shash_init(&sdesc.shash);
+	if (rc) {
+		sERROR(1, "could not initialize crypto API sha256\n");
+		goto smb2_calc_sig2_ret;
+	}
+
 	for (i = 0; i < n_vec; i++) {
 		if (iov[i].iov_len == 0)
 			continue;
@@ -135,22 +180,26 @@ static int smb2_calc_signature2(const struct kvec *iov, int n_vec,
 		if (i == 0) {
 			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
 				break; /* nothing to sign or corrupt header */
-			smb2_MD5_update(&context, iov[0].iov_base+4,
-				  iov[0].iov_len-4);
+			crypto_shash_update(&sdesc.shash, iov[i].iov_base + 4,
+					iov[i].iov_len - 4);
 		} else
-			smb2_MD5_update(&context, iov[i].iov_base, iov[i].iov_len);
+			crypto_shash_update(&sdesc.shash, iov[i].iov_base,
+					iov[i].iov_len);
 	}
 
-	smb2_MD5_final(signature, &context);
+	rc = crypto_shash_final(&sdesc.shash, sigptr);
 
-	return 0;
+	memcpy(smb2_pdu->Signature, sigptr, SMB2_NTLMV2_SESSKEY_SIZE);
+
+smb2_calc_sig2_ret:
+
+	return rc;
 }
 
 
 int sign_smb2(struct kvec *iov, int n_vec, struct tcp_srv_inf *server)
 {
 	int rc = 0;
-	char smb_signature[20];
 	struct smb2_hdr *smb2_pdu = iov[0].iov_base;
 
 	if ((smb2_pdu == NULL) || (server == NULL))
@@ -159,24 +208,19 @@ int sign_smb2(struct kvec *iov, int n_vec, struct tcp_srv_inf *server)
 	if ((smb2_pdu->Flags & SMB2_FLAGS_SIGNED) == 0)
 		return rc;
 
-	memset(smb2_pdu->Signature, 0, 16);
-
-	rc = smb2_calc_signature2(iov, n_vec, &server->mac_signing_key,
-				      smb_signature);
-	if (!rc)
-		memcpy(smb2_pdu->Signature, smb_signature, 16);
+	rc = smb2_calc_signature2(iov, n_vec, server, smb2_pdu);
 
 	return rc;
 }
 
 int smb2_verify_signature(struct smb2_hdr *smb2_pdu,
-			  const struct mac_key *mac_key)
+			struct tcp_srv_inf *server)
 {
 	unsigned int rc;
 	char server_response_sig[16];
 	char what_we_think_sig_should_be[20];
 
-	if ((smb2_pdu == NULL) || (mac_key == NULL))
+	if ((smb2_pdu == NULL) || (server == NULL))
 		return -EINVAL;
 
 	if (smb2_pdu->Command == SMB2_NEGOTIATE)
@@ -199,7 +243,7 @@ int smb2_verify_signature(struct smb2_hdr *smb2_pdu,
 
 	memset(smb2_pdu->Signature, 0, 16);
 
-	rc = smb2_calculate_signature(smb2_pdu, mac_key,
+	rc = smb2_calculate_signature(smb2_pdu, server,
 		what_we_think_sig_should_be);
 
 	if (rc)
@@ -215,100 +259,72 @@ int smb2_verify_signature(struct smb2_hdr *smb2_pdu,
 
 }
 
-/* We fill in key by putting in 40 byte array which was allocated by caller */
-int smb2_calculate_mac_key(struct mac_key *key, const char *rn,
-			   const char *password, const struct nls_table *cp)
-{
-	char temp_key[16];
-	if ((key == NULL) || (rn == NULL))
-		return -EINVAL;
-
-	E_md4hash(password, temp_key, cp);
-	smb2mdfour(key->data.ntlm, temp_key, 16);
-	memcpy(key->data.ntlm+16, rn, SMB2_SESS_KEY_SIZE);
-	key->len = 40;
-	return 0;
-}
-
-#if 0  /* Not needed yet, but probably will be */
-int calc_NTLMv2_partial_mac_key(struct smb2_ses *ses,
-				const struct nls_table *nls_info)
+void
+find_domain_name(struct smb2_ses *ses)
 {
-	char temp_hash[16];
-	struct HMAC_MD5_context ctx;
-	char *ucase_buf;
-	__le16 *unicode_buf;
-	unsigned int i, user_name_len, dom_name_len;
-
-	if (ses == NULL)
-		return -EINVAL;
-
-	E_md4hash(ses->password, temp_hash, nls_info);
-
-	smb2_hmac_md5_init_limK_to_64(temp_hash, 16, &ctx);
-	user_name_len = strlen(ses->username);
-	if (user_name_len > MAX_USERNAME_SIZE)
-		return -EINVAL;
-	if (ses->domain_name == NULL)
-		return -EINVAL; /* BB should we use SMB2_LINUX_DOM */
-	dom_name_len = strlen(ses->domain_name);
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
+	unsigned int attrsize;
+	unsigned int type;
+	unsigned char *blobptr;
+	struct ntlmssp2_name *attrptr;
+
+	if (ses->server->tiblob) {
+		blobptr = ses->server->tiblob;
+		attrptr = (struct ntlmssp2_name *) blobptr;
+
+		while ((type = attrptr->type) != 0) {
+			blobptr += 2; /* advance attr type */
+			attrsize = attrptr->length;
+			blobptr += 2; /* advance attr size */
+			if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
+				if (!ses->domain_name) {
+					ses->domain_name =
+						kmalloc(attrptr->length + 1,
+								GFP_KERNEL);
+					if (!ses->domain_name)
+						return;
+					smb2_from_ucs2(ses->domain_name,
+						(__le16 *)blobptr,
+						attrptr->length,
+						attrptr->length,
+						load_nls_default(), false);
+				}
+			}
+			blobptr += attrsize; /* advance attr  value */
+			attrptr = (struct ntlmssp2_name *) blobptr;
+		}
 	}
 
-	for (i = 0; i < user_name_len; i++)
-		ucase_buf[i] = nls_info->charset2upper[(int)ses->username[i]];
-	ucase_buf[i] = 0;
-	user_name_len = smb2_strtoUCS(unicode_buf, ucase_buf,
-				      MAX_USERNAME_SIZE*2, nls_info);
-	unicode_buf[user_name_len] = 0;
-	user_name_len++;
-
-	for (i = 0; i < dom_name_len; i++)
-		ucase_buf[i] = nls_info->charset2upper[(int)ses->domain_name[i]];
-	ucase_buf[i] = 0;
-	dom_name_len = smb2_strtoUCS(unicode_buf+user_name_len, ucase_buf,
-				     MAX_USERNAME_SIZE*2, nls_info);
-
-	unicode_buf[user_name_len + dom_name_len] = 0;
-	smb2_hmac_md5_update((const unsigned char *) unicode_buf,
-		(user_name_len+dom_name_len)*2, &ctx);
-
-	smb2_hmac_md5_final(ses->server->ntlmv2_hash, &ctx);
-	kfree(ucase_buf);
-	kfree(unicode_buf);
-	return 0;
+	return;
 }
-#endif /* endif 0 - not needed yet */
 
 static int calc_ntlmv2_hash(struct smb2_ses *ses,
 			    const struct nls_table *nls_cp)
 {
 	int rc = 0;
 	int len;
-	char nt_hash[16];
-	struct HMAC_MD5_context *pctxt;
+	char nt_hash[SMB2_NTHASH_SIZE];
 	wchar_t *user;
 	wchar_t *domain;
-
-	pctxt = kmalloc(sizeof(struct HMAC_MD5_context), GFP_KERNEL);
-
-	if (pctxt == NULL)
-		return -ENOMEM;
+	wchar_t *server;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
+	} sdesc;
 
 	/* calculate md4 hash of password */
 	E_md4hash(ses->password, nt_hash, nls_cp);
 
-	/* convert Domainname to unicode and uppercase */
-	smb2_hmac_md5_init_limK_to_64(nt_hash, 16, pctxt);
+	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
+	sdesc.shash.flags = 0x0;
+
+	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5, nt_hash,
+				SMB2_NTHASH_SIZE);
+
+	rc = crypto_shash_init(&sdesc.shash);
+	if (rc) {
+		sERROR(1, "could not initialize master crypto API hmacmd5\n");
+		return rc;
+	}
 
 	/* convert ses->username to unicode and uppercase */
 	len = strlen(ses->username);
@@ -317,7 +333,8 @@ static int calc_ntlmv2_hash(struct smb2_ses *ses,
 		goto calc_exit_2;
 	len = smb2_strtoUCS((__le16 *)user, ses->username, len, nls_cp);
 	uni_strupr(user);
-	smb2_hmac_md5_update((char *)user, 2*len, pctxt);
+
+	crypto_shash_update(&sdesc.shash, (char *)user, 2 * len);
 
 	/* convert ses->domain_name to unicode and uppercase */
 	if (ses->domain_name) {
@@ -333,65 +350,194 @@ static int calc_ntlmv2_hash(struct smb2_ses *ses,
 		   Maybe converting the domain name earlier makes sense */
 		/* uni_strupr(domain); */
 
-		smb2_hmac_md5_update((char *)domain, 2*len, pctxt);
+		crypto_shash_update(&sdesc.shash, (char *)domain, 2 * len);
 
 		kfree(domain);
+	} else if (ses->srvname) {
+		len = strlen(ses->srvname);
+
+		sERROR(1, "server name %s", ses->srvname);
+		server = kmalloc(2 + (len * 2), GFP_KERNEL);
+		if (server == NULL)
+			goto calc_exit_1;
+		len = smb2_strtoUCS((__le16 *)server, ses->srvname, len,
+			nls_cp);
+		/* the following line was removed since it didn't work well
+		   with lower cased domain name that passed as an option.
+		   Maybe converting the domain name earlier makes sense */
+		/* uni_strupr(domain); */
+
+		crypto_shash_update(&sdesc.shash, (char *)server, 2 * len);
+
+		kfree(server);
 	}
 calc_exit_1:
 	kfree(user);
 calc_exit_2:
 	/* BB FIXME what about bytes 24 through 40 of the signing key?
 	   compare with the NTLM example */
-	smb2_hmac_md5_final(ses->server->ntlmv2_hash, pctxt);
+	rc = crypto_shash_final(&sdesc.shash, ses->server->ntlmv2_hash);
 
 	return rc;
 }
 
-static void CalcNTLMv2_response(const struct smb2_ses *ses,
+static int CalcNTLMv2_response(const struct smb2_ses *ses,
 			 char *v2_session_response)
 {
-	struct HMAC_MD5_context context;
-	/* rest of v2 struct already generated */
-	memcpy(v2_session_response + 8, ses->server->crypt_key, 8);
-	smb2_hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
+	int rc = 0;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
+	} sdesc;
 
-	smb2_hmac_md5_update(v2_session_response+8,
-			sizeof(struct ntlmv2_resp) - 8, &context);
+	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
+	sdesc.shash.flags = 0x0;
 
-	smb2_hmac_md5_final(v2_session_response, &context);
-/*	smb2_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
+	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5,
+		ses->server->ntlmv2_hash, SMB2_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_shash_init(&sdesc.shash);
+	if (rc) {
+		sERROR(1, "could not initialize master crypto API hmacmd5\n");
+		return rc;
+	}
+
+	memcpy(v2_session_response + SMB2_SERVER_CHALLENGE_SIZE,
+			ses->server->crypt_key, SMB2_SERVER_CHALLENGE_SIZE);
+	crypto_shash_update(&sdesc.shash,
+		v2_session_response + SMB2_SERVER_CHALLENGE_SIZE,
+		sizeof(struct ntlmv2_resp) - SMB2_SERVER_CHALLENGE_SIZE);
+
+	if (ses->server->tilen)
+		crypto_shash_update(&sdesc.shash, ses->server->tiblob,
+				ses->server->tilen);
+
+	rc = crypto_shash_final(&sdesc.shash, v2_session_response);
+
+	return rc;
 }
 
-void smb2_setup_ntlmv2_rsp(struct smb2_ses *ses, char *resp_buf,
+int smb2_setup_ntlmv2_rsp(struct smb2_ses *ses, char *resp_buf,
 			   const struct nls_table *nls_cp)
 {
-	int rc;
+	int rc = 0;
 	struct ntlmv2_resp *buf = (struct ntlmv2_resp *)resp_buf;
-	struct HMAC_MD5_context context;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ses->server->ntlmssp.hmacmd5)];
+	} sdesc;
 
 	buf->blob_signature = cpu_to_le32(0x00000101);
 	buf->reserved = 0;
 	buf->time = cpu_to_le64(unix_time_to_SMB2(CURRENT_TIME));
 	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
 	buf->reserved2 = 0;
-	buf->names[0].type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
-	buf->names[0].length = 0;
-	buf->names[1].type = 0;
-	buf->names[1].length = 0;
+
+	if (!ses->domain_name)
+		find_domain_name(ses);
 
 	/* calculate buf->ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, nls_cp);
-	if (rc)
+	if (rc) {
 		sERROR(1, "could not get v2 hash rc %d", rc);
-	CalcNTLMv2_response(ses, resp_buf);
+		goto smb2_setup_ntlmv2_rsp_ret;
+	}
+	rc = CalcNTLMv2_response(ses, resp_buf);
+	if (rc) {
+		sERROR(1, "could not calculate v2 resp rc %d", rc);
+		goto smb2_setup_ntlmv2_rsp_ret;
+	}
+
+	sdesc.shash.tfm = ses->server->ntlmssp.hmacmd5;
+	sdesc.shash.flags = 0x0;
 
-	/* now calculate the MAC key for NTLMv2 */
-	smb2_hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
-	smb2_hmac_md5_update(resp_buf, 16, &context);
-	smb2_hmac_md5_final(ses->server->mac_signing_key.data.ntlmv2.key, &context);
+	crypto_shash_setkey(ses->server->ntlmssp.hmacmd5,
+		ses->server->ntlmv2_hash, SMB2_HMAC_MD5_HASH_SIZE);
 
-	memcpy(&ses->server->mac_signing_key.data.ntlmv2.resp, resp_buf,
+	rc = crypto_shash_init(&sdesc.shash);
+	if (rc) {
+		sERROR(1, "could not initialize master crypto API hmacmd5\n");
+		return rc;
+	}
+
+	crypto_shash_update(&sdesc.shash, resp_buf, SMB2_HMAC_MD5_HASH_SIZE);
+
+	rc = crypto_shash_final(&sdesc.shash,
+		ses->server->session_key.data.ntlmv2.key);
+
+	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
 	       sizeof(struct ntlmv2_resp));
-	ses->server->mac_signing_key.len = 16 + sizeof(struct ntlmv2_resp);
+	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
+
+smb2_setup_ntlmv2_rsp_ret:
+
+	return rc;
+}
+
+int
+calc_seckey(struct tcp_srv_inf *server)
+{
+	int rc;
+	unsigned char sec_key[SMB2_NTLMV2_SESSKEY_SIZE];
+	struct crypto_blkcipher *tfm_arc4;
+	struct scatterlist sgin, sgout;
+	struct blkcipher_desc desc;
+
+	get_random_bytes(sec_key, SMB2_NTLMV2_SESSKEY_SIZE);
+
+	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
+		sERROR(1, "could not allocate " "crypto API arc4\n");
+		return 1;
+	}
+
+	desc.tfm = tfm_arc4;
+
+	crypto_blkcipher_setkey(tfm_arc4,
+		server->session_key.data.ntlmv2.key, SMB2_CPHTXT_SIZE);
+	sg_init_one(&sgin, sec_key, SMB2_CPHTXT_SIZE);
+	sg_init_one(&sgout, server->ntlmssp.ciphertext, SMB2_CPHTXT_SIZE);
+	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, SMB2_CPHTXT_SIZE);
+
+	if (!rc) {
+		memcpy(server->session_key.data.ntlmv2.key,
+					sec_key, SMB2_NTLMV2_SESSKEY_SIZE);
+	}
+
+	crypto_free_blkcipher(tfm_arc4);
+
+	return 0;
+}
+
+void
+smb2_crypto_hash_release(struct tcp_srv_inf *server)
+{
+	if (server->ntlmssp.hmacmd5)
+		crypto_free_shash(server->ntlmssp.hmacmd5);
+
+	if (server->ntlmssp.hmacsha256)
+		crypto_free_shash(server->ntlmssp.hmacsha256);
 }
 
+int
+smb2_crypto_hash_allocate(struct tcp_srv_inf *server)
+{
+	server->ntlmssp.hmacmd5 = crypto_alloc_shash("hmac(md5)",
+						0, CRYPTO_ALG_ASYNC);
+	if (!server->ntlmssp.hmacmd5 ||
+			IS_ERR(server->ntlmssp.hmacmd5)) {
+		sERROR(1, "could not allocate crypto API hmacmd5\n");
+		return 1;
+	}
+
+	server->ntlmssp.hmacsha256 = crypto_alloc_shash("hmac(sha256)",
+						0, CRYPTO_ALG_ASYNC);
+	if (!server->ntlmssp.hmacsha256 ||
+			IS_ERR(server->ntlmssp.hmacsha256)) {
+		crypto_free_shash(server->ntlmssp.hmacmd5);
+		sERROR(1, "could not allocate crypto API hmacsha256\n");
+		 return 1;
+	}
+
+       return 0;
+}
diff --git a/fs/smb2/smb2glob.h b/fs/smb2/smb2glob.h
index ec39583..a53bc07 100644
--- a/fs/smb2/smb2glob.h
+++ b/fs/smb2/smb2glob.h
@@ -23,6 +23,9 @@
 #include <linux/slow-work.h>
 #include "smb2_fs_sb.h"
 #include "smb2acl.h"
+#include <crypto/internal/hash.h>
+#include <linux/scatterlist.h>
+
 /*
  * The sizes of various internal tables and strings
  */
@@ -81,13 +84,13 @@ enum protocol_enum {
  */
 #define SMB2_SESS_KEY_SIZE (24)
 
-struct mac_key {
+struct session_key {
 	unsigned int len;
 	union {
 		char ntlm[SMB2_SESS_KEY_SIZE + 16];
 		char krb5[SMB2_SESS_KEY_SIZE + 16]; /* BB: length correct? */
 		struct {
-			char key[16];
+			unsigned char key[16];
 			struct ntlmv2_resp resp;
 		} ntlmv2;
 	} data;
@@ -104,6 +107,14 @@ struct smb2_cred {
 	struct smb2_ace *aces;
 };
 
+struct ntlmssp_auth {
+	__u32 client_flags;
+	__u32 server_flags;
+	unsigned char ciphertext[SMB2_CPHTXT_SIZE];
+	struct crypto_shash *hmacsha256;
+	struct crypto_shash *hmacmd5;
+};
+
 /*
  *****************************************************************
  * Except the SMB2 PDUs themselves all the
@@ -164,9 +175,12 @@ struct tcp_srv_inf {
 	int time_adj;  /* Adjust for difference in server time zone in sec */
 	__u64 current_mid;         /* multiplex id - rotating counter */
 	char crypt_key[SMB2_CRYPTO_KEY_SIZE];
+	unsigned int tilen; /* length of the target info blob */
+	unsigned char *tiblob; /* target info blob in challenge response */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
-	struct mac_key mac_signing_key;
+	struct session_key session_key;
+	struct ntlmssp_auth ntlmssp;
 	char ntlmv2_hash[16];
 	unsigned long lstrp; /* when we got last response from this server */
 };
diff --git a/fs/smb2/smb2pdu.c b/fs/smb2/smb2pdu.c
index 6640446..87c23af 100644
--- a/fs/smb2/smb2pdu.c
+++ b/fs/smb2/smb2pdu.c
@@ -745,7 +745,7 @@ ssetup_ntlmssp_authenticate:
 		}
 	} else if (phase == NtLmAuthenticate) {
 		pSMB2->hdr.SessionId = ses->suid;
-		ntlmssp_blob = kmalloc(sizeof(struct _NEGOTIATE_MESSAGE) + 500,
+		ntlmssp_blob = kmalloc(5 * sizeof(struct _AUTHENTICATE_MESSAGE),
 					GFP_KERNEL);
 		blob_length = build_ntlmssp_auth_blob(ntlmssp_blob, ses,
 						      nls_cp);
diff --git a/fs/smb2/smb2pdu.h b/fs/smb2/smb2pdu.h
index 8ca4206..965f4f0 100644
--- a/fs/smb2/smb2pdu.h
+++ b/fs/smb2/smb2pdu.h
@@ -723,6 +723,18 @@ struct ioctl_rsp {
  */
 #define SMB2_CRYPTO_KEY_SIZE (8)
 
+#define SMB2_SESS_KEY_SIZE (24)
+#define SMB2_CLIENT_CHALLENGE_SIZE (8)
+#define SMB2_SERVER_CHALLENGE_SIZE (8)
+#define SMB2_HMAC_MD5_HASH_SIZE (16)
+#define SMB2_CPHTXT_SIZE (16)
+#define SMB2_NTLMV2_SESSKEY_SIZE (16)
+#define SMB2_NTHASH_SIZE (16)
+#define SMB2_SIGNATURE_SIZE (16)
+#define SMB2_HMACSHA256_SIZE (32)
+
+
+
 /* format of NLTMv2 Response ie "case sensitive password" hash when NTLMv2 */
 
 #define NTLMSSP_SERVER_TYPE	1
@@ -734,7 +746,7 @@ struct ioctl_rsp {
 struct ntlmssp2_name {
 	__le16 type;
 	__le16 length;
-/*	char   name[length]; */
+	unsigned char value[1];
 } __attribute__((packed));
 
 struct ntlmv2_resp {
@@ -744,8 +756,6 @@ struct ntlmv2_resp {
 	__le64  time;
 	__u64  client_chal; /* random */
 	__u32  reserved2;
-	struct ntlmssp2_name names[2];
-	/* array of name entries could follow ending in minimum 4 byte struct */
 } __attribute__((packed));
 
 
diff --git a/fs/smb2/smb2proto.h b/fs/smb2/smb2proto.h
index e55a7d3..1ad4265 100644
--- a/fs/smb2/smb2proto.h
+++ b/fs/smb2/smb2proto.h
@@ -76,8 +76,7 @@ extern int smb2_sendrcv_blocking(const unsigned int xid, struct smb2_tcon *tcon,
 			struct smb2_hdr *out_buf,
 			int *pbytes_returned);
 extern int sign_smb2(struct kvec *iov, int n_vec, struct tcp_srv_inf *);
-extern int smb2_verify_signature(struct smb2_hdr *,
-				 const struct mac_key *mac_key);
+extern int smb2_verify_signature(struct smb2_hdr *, struct tcp_srv_inf *);
 extern int smb2_demultiplex_thread(struct tcp_srv_inf *server);
 extern int smb2_reconnect(struct tcp_srv_inf *server);
 extern int smb2_setup_session(unsigned int xid, struct smb2_ses *pses_info,
@@ -132,11 +131,11 @@ extern int build_spnego_ntlmssp_blob(char **security_blob, int ntlmssp_blob_len,
 				     char *ntlmssp_blob);
 extern void SMB2encrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24, const struct nls_table *cp);
-extern int smb2_calculate_mac_key(struct mac_key *key, const char *rn,
-				  const char *password,
-				  const struct nls_table *cp);
-void smb2_setup_ntlmv2_rsp(struct smb2_ses *ses, char *resp_buf,
+extern int smb2_setup_ntlmv2_rsp(struct smb2_ses *ses, char *resp_buf,
 			   const struct nls_table *nls_cp);
+extern int calc_seckey(struct tcp_srv_inf *);
+extern int smb2_crypto_hash_allocate(struct tcp_srv_inf *);
+extern void  smb2_crypto_hash_release(struct tcp_srv_inf *);
 /* smb2des.c */
 extern void smb2_E_P16(unsigned char *p14, unsigned char *p16);
 extern void smb2_E_P24(unsigned char *p21, const unsigned char *c8,
diff --git a/fs/smb2/transport.c b/fs/smb2/transport.c
index fc8af87..8e25a2e 100644
--- a/fs/smb2/transport.c
+++ b/fs/smb2/transport.c
@@ -670,8 +670,7 @@ pending_loop:
 
 	if ((receive_len > 24) &&
 	    (ses->server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)) {
-		rc = smb2_verify_signature(out_buf,
-					   &ses->server->mac_signing_key);
+		rc = smb2_verify_signature(out_buf, ses->server);
 		if (rc)
 			sERROR(1, "Unexpected SMB2 signature");
 	}
@@ -856,8 +855,7 @@ smb2_sendrcv2(const unsigned int xid, struct smb2_ses *ses,
 		/* convert the length into a more usable form */
 		if ((receive_len > 24) &&
 		    (ses->server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)) {
-			rc = smb2_verify_signature(midq->resp_buf,
-						&ses->server->mac_signing_key);
+			rc = smb2_verify_signature(midq->resp_buf, ses->server);
 			if (rc) {
 				sERROR(1, "Unexpected SMB signature");
 				/* BB FIXME add code to kill session */
-- 
1.6.0.2
