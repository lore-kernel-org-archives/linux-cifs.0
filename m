From: shirishpargaonkar@gmail.com
Subject: [linux-smb2-client][PATCH] Make ntlmv2 as auth mech within NTLMSSP
Date: Sun,  1 Aug 2010 15:40:18 -0500
Message-ID: <1280695218-18850-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@samba.org
To: smfrench@gmail.com
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Make ntlmv2 as an authentication mechanism within ntlmssp
instead of ntlmv1.

Parse type 2 response in ntlmssp negotiation to pluck
AV pairs and use them to calculate ntlmv2 response token.
Also, assign domain name from the sever response in type 2
packet of ntlmssp and use that (netbios) domain name in
calculation of response.


>From 4f591f31d8c90afdd7969a0032dceb0d35fa56f9 Mon Sep 17 00:00:00 2001
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date: Sun, 1 Aug 2010 15:35:07 -0500
Subject: [PATCH] make ntlmv2 as auth mech within NTLMSSP


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
---
 fs/smb2/ntlmssp.c     |  148 +++++++++++++++++++++++++++-----------------
 fs/smb2/ntlmssp.h     |   13 ++++
 fs/smb2/smb2encrypt.c |  164 ++++++++++++++++++++++++++++++-------------------
 fs/smb2/smb2glob.h    |   18 +++++-
 fs/smb2/smb2pdu.c     |    2 +-
 fs/smb2/smb2pdu.h     |   13 +++-
 fs/smb2/smb2proto.h   |    1 +
 7 files changed, 234 insertions(+), 125 deletions(-)

diff --git a/fs/smb2/ntlmssp.c b/fs/smb2/ntlmssp.c
index e1e9fe6..e8a2864 100644
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
+		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC |
+		NTLMSSP_NEGOTIATE_SIGN | NTLMSSP_NEGOTIATE_KEY_XCH;
 	if (ses->server->sec_mode & SMB2SEC_MUST_SIGN)
 		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
 
@@ -97,44 +116,53 @@ void build_ntlmssp_negotiate_blob(char *ntlmssp_buf,
 int build_ntlmssp_auth_blob(unsigned char *pbuffer, struct smb2_ses *ses,
 			    const struct nls_table *nls_cp)
 {
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
+		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_SIGN |
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
+	smb2_setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
+	size =  sizeof(struct ntlmv2_resp);
+	memcpy(tmp, (char *)&ntlmv2_response, size);
+	tmp += size;
+
+	if (ses->server->tilen > 0) {
+		memcpy(tmp, ses->server->tiblob, ses->server->tilen);
+		kfree(ses->server->tiblob);
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
@@ -168,36 +196,44 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer, struct smb2_ses *ses,
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
-
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
 
-/* static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
-				 struct smb2_ses *ses)
-{
-	build_ntlmssp_negotiate_blob(&pSMB->req.SecurityBlob[0], ses);
-	pSMB->req.SecurityBlobLength = cpu_to_le16(sizeof(NEGOTIATE_MESSAGE));
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
index 253af0c..9309916 100644
--- a/fs/smb2/smb2encrypt.c
+++ b/fs/smb2/smb2encrypt.c
@@ -28,6 +28,7 @@
 #include "md5.h"
 #include "smb2_unicode.h"
 #include "smb2proto.h"
+#include "ntlmssp.h"
 
 /* Calculate and return the SMB2 signature based on the mac key and SMB2 PDU */
 /* the 16 byte signature must be allocated by the caller  */
@@ -215,6 +216,44 @@ int smb2_verify_signature(struct smb2_hdr *smb2_pdu,
 
 }
 
+void
+find_domain_name(struct smb2_ses *ses)
+{
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
+	}
+
+	return;
+}
+
 /* We fill in key by putting in 40 byte array which was allocated by caller */
 int smb2_calculate_mac_key(struct mac_key *key, const char *rn,
 			   const char *password, const struct nls_table *cp)
@@ -230,65 +269,6 @@ int smb2_calculate_mac_key(struct mac_key *key, const char *rn,
 	return 0;
 }
 
-#if 0  /* Not needed yet, but probably will be */
-int calc_NTLMv2_partial_mac_key(struct smb2_ses *ses,
-				const struct nls_table *nls_info)
-{
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
-	}
-
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
-}
-#endif /* endif 0 - not needed yet */
-
 static int calc_ntlmv2_hash(struct smb2_ses *ses,
 			    const struct nls_table *nls_cp)
 {
@@ -298,6 +278,7 @@ static int calc_ntlmv2_hash(struct smb2_ses *ses,
 	struct HMAC_MD5_context *pctxt;
 	wchar_t *user;
 	wchar_t *domain;
+	wchar_t *server;
 
 	pctxt = kmalloc(sizeof(struct HMAC_MD5_context), GFP_KERNEL);
 
@@ -336,6 +317,23 @@ static int calc_ntlmv2_hash(struct smb2_ses *ses,
 		smb2_hmac_md5_update((char *)domain, 2*len, pctxt);
 
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
+		smb2_hmac_md5_update((char *)server, 2*len, pctxt);
+
+		kfree(server);
 	}
 calc_exit_1:
 	kfree(user);
@@ -351,12 +349,17 @@ static void CalcNTLMv2_response(const struct smb2_ses *ses,
 			 char *v2_session_response)
 {
 	struct HMAC_MD5_context context;
+
 	/* rest of v2 struct already generated */
 	memcpy(v2_session_response + 8, ses->server->crypt_key, 8);
 	smb2_hmac_md5_init_limK_to_64(ses->server->ntlmv2_hash, 16, &context);
 
-	smb2_hmac_md5_update(v2_session_response+8,
+	smb2_hmac_md5_update(v2_session_response + 8,
 			sizeof(struct ntlmv2_resp) - 8, &context);
+	if (ses->server->tilen)
+		smb2_hmac_md5_update(ses->server->tiblob,
+			ses->server->tilen, &context);
+
 
 	smb2_hmac_md5_final(v2_session_response, &context);
 /*	smb2_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
@@ -374,10 +377,9 @@ void smb2_setup_ntlmv2_rsp(struct smb2_ses *ses, char *resp_buf,
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
@@ -395,3 +397,37 @@ void smb2_setup_ntlmv2_rsp(struct smb2_ses *ses, char *resp_buf,
 	ses->server->mac_signing_key.len = 16 + sizeof(struct ntlmv2_resp);
 }
 
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
+		sERROR(1, "could not allocate " "master crypto API arc4\n");
+		return 1;
+	}
+
+	desc.tfm = tfm_arc4;
+
+	crypto_blkcipher_setkey(tfm_arc4,
+		server->mac_signing_key.data.ntlmv2.key, SMB2_CPHTXT_SIZE);
+	sg_init_one(&sgin, sec_key, SMB2_CPHTXT_SIZE);
+	sg_init_one(&sgout, server->ntlmssp.ciphertext, SMB2_CPHTXT_SIZE);
+	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, SMB2_CPHTXT_SIZE);
+
+	if (!rc) {
+		memcpy(server->mac_signing_key.data.ntlmv2.key,
+					sec_key, SMB2_NTLMV2_SESSKEY_SIZE);
+	}
+
+	crypto_free_blkcipher(tfm_arc4);
+
+	return 0;
+}
diff --git a/fs/smb2/smb2glob.h b/fs/smb2/smb2glob.h
index a6cfa11..f77ebe1 100644
--- a/fs/smb2/smb2glob.h
+++ b/fs/smb2/smb2glob.h
@@ -20,9 +20,13 @@
  */
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/crypto.h>
 #include <linux/slow-work.h>
 #include "smb2_fs_sb.h"
 #include "smb2acl.h"
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+
 /*
  * The sizes of various internal tables and strings
  */
@@ -87,7 +91,7 @@ struct mac_key {
 		char ntlm[SMB2_SESS_KEY_SIZE + 16];
 		char krb5[SMB2_SESS_KEY_SIZE + 16]; /* BB: length correct? */
 		struct {
-			char key[16];
+			unsigned char key[16];
 			struct ntlmv2_resp resp;
 		} ntlmv2;
 	} data;
@@ -104,6 +108,15 @@ struct smb2_cred {
 	struct smb2_ace *aces;
 };
 
+struct ntlmssp_auth {
+	__u32 client_flags;
+	__u32 server_flags;
+	unsigned char ciphertext[SMB2_CPHTXT_SIZE];
+	struct crypto_hash *tfm_hmacsha256;
+	struct crypto_hash *tfm_hmacmd5;
+	struct crypto_hash *tfm_md5;
+};
+
 /*
  *****************************************************************
  * Except the SMB2 PDUs themselves all the
@@ -164,9 +177,12 @@ struct tcp_srv_inf {
 	int time_adj;  /* Adjust for difference in server time zone in sec */
 	__u64 current_mid;         /* multiplex id - rotating counter */
 	char crypt_key[SMB2_CRYPTO_KEY_SIZE];
+	unsigned int tilen; /* length of the target info blob */
+	unsigned char *tiblob; /* target info blob in challenge response */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	struct mac_key mac_signing_key;
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
index 8ca4206..3c6b4cd 100644
--- a/fs/smb2/smb2pdu.h
+++ b/fs/smb2/smb2pdu.h
@@ -723,6 +723,15 @@ struct ioctl_rsp {
  */
 #define SMB2_CRYPTO_KEY_SIZE (8)
 
+#define SMB2_SESS_KEY_SIZE (24)
+#define SMB2_CLIENT_CHALLENGE_SIZE (8)
+#define SMB2_SERVER_CHALLENGE_SIZE (8)
+#define SMB2_HMAC_MD5_HASH_SIZE (16)
+#define SMB2_CPHTXT_SIZE (16)
+#define SMB2_NTLMV2_SESSKEY_SIZE (16)
+#define SMB2_NTHASH_SIZE (16)
+
+
 /* format of NLTMv2 Response ie "case sensitive password" hash when NTLMv2 */
 
 #define NTLMSSP_SERVER_TYPE	1
@@ -734,7 +743,7 @@ struct ioctl_rsp {
 struct ntlmssp2_name {
 	__le16 type;
 	__le16 length;
-/*	char   name[length]; */
+	unsigned char value[1];
 } __attribute__((packed));
 
 struct ntlmv2_resp {
@@ -744,8 +753,6 @@ struct ntlmv2_resp {
 	__le64  time;
 	__u64  client_chal; /* random */
 	__u32  reserved2;
-	struct ntlmssp2_name names[2];
-	/* array of name entries could follow ending in minimum 4 byte struct */
 } __attribute__((packed));
 
 
diff --git a/fs/smb2/smb2proto.h b/fs/smb2/smb2proto.h
index e55a7d3..9843b45 100644
--- a/fs/smb2/smb2proto.h
+++ b/fs/smb2/smb2proto.h
@@ -137,6 +137,7 @@ extern int smb2_calculate_mac_key(struct mac_key *key, const char *rn,
 				  const struct nls_table *cp);
 void smb2_setup_ntlmv2_rsp(struct smb2_ses *ses, char *resp_buf,
 			   const struct nls_table *nls_cp);
+extern int calc_seckey(struct tcp_srv_inf *);
 /* smb2des.c */
 extern void smb2_E_P16(unsigned char *p14, unsigned char *p16);
 extern void smb2_E_P24(unsigned char *p21, const unsigned char *c8,
-- 
1.6.0.2
