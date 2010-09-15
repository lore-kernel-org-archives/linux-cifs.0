From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH -v5 2/4] cifs NTLMv2/NTLMSSP ntlmv2 within ntlmssp  autentication code
Date: Wed, 15 Sep 2010 17:37:04 -0500
Message-ID: <1284590224-5596-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Attribue Value (AV) pairs or Target Info (TI) pairs are part of
ntlmv2 authentication.
Structure ntlmv2_resp had only definition for two av pairs.
So removed it, and now allocation of av pairs is dynamic.
For servers like Windows 7/2008, av pairs sent by server in
challege packet (type 2 in the ntlmssp exchange/negotiation) can
vary.

Server sends them during ntlmssp negotiation. So when ntlmssp is used
as an authentication mechanism, type 2 challenge packet from server
has this information.  Pluck it and use the entire blob for
authenticaiton purpose.  If user has not specified, extract
(netbios) domain name from the av pairs which is used to calculate
ntlmv2 hash.  Servers like Windows 7 are particular about the AV pair
blob.

Servers like Windows 2003, are not very strict about the contents
of av pair blob used during ntlmv2 authentication.
So when security mechanism such as ntlmv2 is used (not ntlmv2 in ntlmssp),
there is no negotiation and so genereate a minimal blob that gets
used in ntlmv2 authentication as well as gets sent.

Fields tilen and tilbob are session specific.  AV pair values are defined.

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


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |  125 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/cifsglob.h    |    2 +
 fs/cifs/cifspdu.h     |    1 -
 fs/cifs/cifsproto.h   |    2 +-
 fs/cifs/cifssmb.c     |   16 ++++---
 fs/cifs/connect.c     |    2 +
 fs/cifs/ntlmssp.h     |   15 ++++++
 fs/cifs/sess.c        |  114 ++++++++++++++++++++++++++++++---------------
 8 files changed, 224 insertions(+), 53 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index eed70ca..ab0533a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -27,6 +27,7 @@
 #include "md5.h"
 #include "cifs_unicode.h"
 #include "cifsproto.h"
+#include "ntlmssp.h"
 #include <linux/ctype.h>
 #include <linux/random.h>
 
@@ -262,6 +263,92 @@ void calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 }
 #endif /* CIFS_WEAK_PW_HASH */
 
+/* This is just a filler for ntlmv2 type of security mechanisms.
+ * Older servers are not very particular about the contents of av pairs
+ * in the blob and for sec mechs like ntlmv2, there is no negotiation
+ * as in ntlmssp, so unless domain and server  netbios and dns names
+ * are specified, there is no way to obtain name.  In case of ntlmssp,
+ * server provides that info in type 2 challenge packet
+ */
+static int
+build_avpair_blob(struct cifsSesInfo *ses)
+{
+	struct ntlmssp2_name *attrptr;
+
+	ses->tilen = 2 * sizeof(struct ntlmssp2_name);
+	ses->tiblob = kzalloc(ses->tilen, GFP_KERNEL);
+	if (!ses->tiblob) {
+		ses->tilen = 0;
+		cERROR(1, "Challenge target info allocation failure");
+		return -ENOMEM;
+	}
+	attrptr = (struct ntlmssp2_name *) ses->tiblob;
+	attrptr->type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
+
+	return 0;
+}
+
+/* Server has provided av pairs/target info in the type 2 challenge
+ * packet and we have plucked it and stored within smb session.
+ * We parse that blob here to find netbios domain name to be used
+ * as part of ntlmv2 authentication (in Target String), if not already
+ * specified on the command line.
+ * If this function returns without any error but without fetching
+ * domain name, authentication may fail against some server but
+ * may not fail against other (those who are not very particular
+ * about target string i.e. for some, just user name might suffice.
+ */
+static int
+find_domain_name(struct cifsSesInfo *ses)
+{
+	unsigned int attrsize;
+	unsigned int type;
+	unsigned char *blobptr;
+	unsigned char *blobend;
+	struct ntlmssp2_name *attrptr;
+
+	if (!ses->tilen || !ses->tiblob)
+		return 0;
+
+	if (ses->tilen < sizeof(struct ntlmssp2_name))
+		return 0;
+
+	blobend = ses->tiblob + ses->tilen;
+	blobptr = ses->tiblob;
+	attrptr = (struct ntlmssp2_name *) blobptr;
+
+	while (blobptr <= blobend) {
+		type = le16_to_cpu(attrptr->type);
+		if (type == NTLMSSP_AV_EOL)
+			break;
+		blobptr += 2; /* advance attr type */
+		attrsize = le16_to_cpu(attrptr->length);
+		blobptr += 2; /* advance attr size */
+		if (blobptr + attrsize > blobend) {
+			cERROR(1, "%s: Invalid attribute size: %d",
+					__func__, attrsize);
+			return -EINVAL;
+		}
+		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
+			if (!ses->domainName) {
+				ses->domainName =
+					kmalloc(attrsize + 1, GFP_KERNEL);
+				if (!ses->domainName)
+						return -ENOMEM;
+				cifs_from_ucs2(ses->domainName,
+					(__le16 *)blobptr,
+					attrptr->length,
+					attrptr->length,
+					load_nls_default(), false);
+			}
+		}
+		blobptr += attrsize; /* advance attr  value */
+		attrptr = (struct ntlmssp2_name *) blobptr;
+	}
+
+	return 0;
+}
+
 static int calc_ntlmv2_hash(struct cifsSesInfo *ses,
 			    const struct nls_table *nls_cp)
 {
@@ -321,7 +408,8 @@ calc_exit_2:
 	return rc;
 }
 
-void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
+int
+setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 		      const struct nls_table *nls_cp)
 {
 	int rc;
@@ -333,15 +421,29 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 	buf->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
 	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
 	buf->reserved2 = 0;
-	buf->names[0].type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
-	buf->names[0].length = 0;
-	buf->names[1].type = 0;
-	buf->names[1].length = 0;
+
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
 
 	/* calculate buf->ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, nls_cp);
-	if (rc)
+	if (rc) {
 		cERROR(1, "could not get v2 hash rc %d", rc);
+		goto setup_ntlmv2_rsp_ret;
+	}
 	CalcNTLMv2_response(ses, resp_buf);
 
 	/* now calculate the MAC key for NTLMv2 */
@@ -352,6 +454,14 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 	memcpy(&ses->server->session_key.data.ntlmv2.resp, resp_buf,
 	       sizeof(struct ntlmv2_resp));
 	ses->server->session_key.len = 16 + sizeof(struct ntlmv2_resp);
+
+	return 0;
+
+setup_ntlmv2_rsp_ret:
+	kzfree(ses->tiblob);
+	ses->tilen = 0;
+
+	return rc;
 }
 
 void CalcNTLMv2_response(const struct cifsSesInfo *ses,
@@ -365,6 +475,9 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
 	hmac_md5_update(v2_session_response+8,
 			sizeof(struct ntlmv2_resp) - 8, &context);
 
+	if (ses->tilen)
+		hmac_md5_update(ses->tiblob, ses->tilen, &context);
+
 	hmac_md5_final(v2_session_response, &context);
 /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 14dfa9a..c68f31c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -222,6 +222,8 @@ struct cifsSesInfo {
 	char userName[MAX_USERNAME_SIZE + 1];
 	char *domainName;
 	char *password;
+	unsigned int tilen; /* length of the target info blob */
+	unsigned char *tiblob; /* target info blob in challenge response */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 };
 /* no more than one of the following three session flags may be set */
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 14d036d..b0f4b56 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -663,7 +663,6 @@ struct ntlmv2_resp {
 	__le64  time;
 	__u64  client_chal; /* random */
 	__u32  reserved2;
-	struct ntlmssp2_name names[2];
 	/* array of name entries could follow ending in minimum 4 byte struct */
 } __attribute__((packed));
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 3f4fa81..c155479 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -367,7 +367,7 @@ extern int cifs_verify_signature(struct smb_hdr *,
 extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
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
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 88c84a3..c99760a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1740,6 +1740,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	if (ses == NULL)
 		goto get_ses_fail;
 
+	ses->tilen = 0;
+	ses->tiblob = NULL;
 	/* new SMB session uses our server ref */
 	ses->server = server;
 	if (server->addr.sockAddr6.sin6_family == AF_INET6)
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 49c9a4e..5d52e4a 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -61,6 +61,21 @@
 #define NTLMSSP_NEGOTIATE_KEY_XCH   0x40000000
 #define NTLMSSP_NEGOTIATE_56        0x80000000
 
+/* Define AV Pair Field IDs */
+enum av_field_type {
+	NTLMSSP_AV_EOL = 0,
+	NTLMSSP_AV_NB_COMPUTER_NAME,
+	NTLMSSP_AV_NB_DOMAIN_NAME,
+	NTLMSSP_AV_DNS_COMPUTER_NAME,
+	NTLMSSP_AV_DNS_DOMAIN_NAME,
+	NTLMSSP_AV_DNS_TREE_NAME,
+	NTLMSSP_AV_FLAGS,
+	NTLMSSP_AV_TIMESTAMP,
+	NTLMSSP_AV_RESTRICTION,
+	NTLMSSP_AV_TARGET_NAME,
+	NTLMSSP_AV_CHANNEL_BINDINGS
+};
+
 /* Although typedefs are not commonly used for structure definitions */
 /* in the Linux kernel, in this particular case they are useful      */
 /* to more closely match the standards document for NTLMSSP from     */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 8882012..42688ec 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
 static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 				    struct cifsSesInfo *ses)
 {
+	unsigned int tioffset; /* challenge message target info area */
+	unsigned int tilen; /* challenge message target info area length  */
+
 	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
 
 	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
@@ -405,6 +408,19 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
 		we must set the MIC field of the AUTHENTICATE_MESSAGE */
 
+	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
+	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
+	ses->tilen = tilen;
+	if (ses->tilen) {
+		ses->tiblob = kmalloc(tilen, GFP_KERNEL);
+		if (!ses->tiblob) {
+			cERROR(1, "Challenge target info allocation failure");
+			ses->tilen = 0;
+			return -ENOMEM;
+		}
+		memcpy(ses->tiblob,  bcc_ptr + tioffset, ses->tilen);
+	}
+
 	return 0;
 }
 
@@ -425,7 +441,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 	/* BB is NTLMV2 session security format easier to use here? */
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
+		NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->secMode &
 	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
@@ -449,12 +465,14 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
    This function returns the length of the data in the blob */
 static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 				   struct cifsSesInfo *ses,
-				   const struct nls_table *nls_cp, bool first)
+				   const struct nls_table *nls_cp)
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
@@ -462,7 +480,7 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	flags = NTLMSSP_NEGOTIATE_56 |
 		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
-		NTLMSSP_NEGOTIATE_NT_ONLY | NTLMSSP_NEGOTIATE_NTLM;
+		NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->secMode &
 	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
@@ -477,19 +495,25 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->LmChallengeResponse.Length = 0;
 	sec_blob->LmChallengeResponse.MaximumLength = 0;
 
-	/* calculate session key,  BB what about adding similar ntlmv2 path? */
-	SMBNTencrypt(ses->password, ses->server->cryptKey, ntlm_session_key);
-	if (first)
-		cifs_calculate_session_key(&ses->server->session_key,
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
+	sec_blob->NtChallengeResponse.Length = cpu_to_le16(size + ses->tilen);
+	sec_blob->NtChallengeResponse.MaximumLength =
+				cpu_to_le16(size + ses->tilen);
+	kzfree(ses->tiblob);
+	ses->tilen = 0;
 
 	if (ses->domainName == NULL) {
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
@@ -501,7 +525,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		len = cifs_strtoUCS((__le16 *)tmp, ses->domainName,
 				    MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
-		len += 2; /* trailing null */
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->DomainName.Length = cpu_to_le16(len);
 		sec_blob->DomainName.MaximumLength = cpu_to_le16(len);
@@ -518,7 +541,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		len = cifs_strtoUCS((__le16 *)tmp, ses->userName,
 				    MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
-		len += 2; /* trailing null */
 		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->UserName.Length = cpu_to_le16(len);
 		sec_blob->UserName.MaximumLength = cpu_to_le16(len);
@@ -533,6 +555,8 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
 	sec_blob->SessionKey.Length = 0;
 	sec_blob->SessionKey.MaximumLength = 0;
+
+setup_ntlmv2_ret:
 	return tmp - pbuffer;
 }
 
@@ -545,19 +569,6 @@ static void setup_ntlmssp_neg_req(SESSION_SETUP_ANDX *pSMB,
 
 	return;
 }
-
-static int setup_ntlmssp_auth_req(SESSION_SETUP_ANDX *pSMB,
-				  struct cifsSesInfo *ses,
-				  const struct nls_table *nls, bool first_time)
-{
-	int bloblen;
-
-	bloblen = build_ntlmssp_auth_blob(&pSMB->req.SecurityBlob[0], ses, nls,
-					  first_time);
-	pSMB->req.SecurityBlobLength = cpu_to_le16(bloblen);
-
-	return bloblen;
-}
 #endif
 
 int
@@ -580,6 +591,8 @@ CIFS_SessSetup(unsigned int xid, struct cifsSesInfo *ses,
 	struct key *spnego_key = NULL;
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
 	bool first_time;
+	int blob_len;
+	char *ntlmsspblob = NULL;
 
 	if (ses == NULL)
 		return -EINVAL;
@@ -641,6 +654,19 @@ ssetup_ntlmssp_authenticate:
 	}
 	bcc_ptr = str_area;
 
+	/* 5 is an empirical value, large enought to
+	 * hold authenticate message, max 10 of
+	 * av paris, doamin,user,workstation mames,
+	 * flags etc..
+	 */
+	ntlmsspblob = kmalloc(5 * sizeof(struct _AUTHENTICATE_MESSAGE),
+					GFP_KERNEL);
+	if (!ntlmsspblob) {
+		cERROR(1, "Can't allocate NTLMSSP response");
+		rc = -ENOMEM;
+		goto ssetup_exit;
+	}
+
 	ses->flags &= ~CIFS_SES_LANMAN;
 
 	iov[1].iov_base = NULL;
@@ -729,12 +755,22 @@ ssetup_ntlmssp_authenticate:
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
-		       sizeof(struct ntlmv2_resp));
+				sizeof(struct ntlmv2_resp));
 		bcc_ptr += sizeof(struct ntlmv2_resp);
 		kfree(v2_sess_key);
+		if (ses->tilen > 0) {
+			memcpy(bcc_ptr, ses->tiblob, ses->tilen);
+			bcc_ptr += ses->tilen;
+			kzfree(ses->tiblob);
+			ses->tilen = 0;
+		}
 		if (ses->capabilities & CAP_UNICODE) {
 			if (iov[0].iov_len % 2) {
 				*bcc_ptr = 0;
@@ -815,12 +851,14 @@ ssetup_ntlmssp_authenticate:
 			if (phase == NtLmNegotiate) {
 				setup_ntlmssp_neg_req(pSMB, ses);
 				iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
+				iov[1].iov_base = &pSMB->req.SecurityBlob[0];
 			} else if (phase == NtLmAuthenticate) {
-				int blob_len;
-				blob_len = setup_ntlmssp_auth_req(pSMB, ses,
-								  nls_cp,
-								  first_time);
+				blob_len = build_ntlmssp_auth_blob(ntlmsspblob,
+							ses, nls_cp);
 				iov[1].iov_len = blob_len;
+				iov[1].iov_base = ntlmsspblob;
+				pSMB->req.SecurityBlobLength =
+					cpu_to_le16(blob_len);
 				/* Make sure that we tell the server that we
 				   are using the uid that it just gave us back
 				   on the response (challenge) */
@@ -830,7 +868,6 @@ ssetup_ntlmssp_authenticate:
 				rc = -ENOSYS;
 				goto ssetup_exit;
 			}
-			iov[1].iov_base = &pSMB->req.SecurityBlob[0];
 			/* unicode strings must be word aligned */
 			if ((iov[0].iov_len + iov[1].iov_len) % 2) {
 				*bcc_ptr = 0;
@@ -931,6 +968,7 @@ ssetup_exit:
 		key_put(spnego_key);
 	}
 	kfree(str_area);
+	kfree(ntlmsspblob);
 	if (resp_buf_type == CIFS_SMALL_BUFFER) {
 		cFYI(1, "ssetup freeing small buf %p", iov[0].iov_base);
 		cifs_small_buf_release(iov[0].iov_base);
-- 
1.6.0.2
