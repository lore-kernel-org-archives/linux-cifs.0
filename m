From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [linux-cifs-client][PATCH] make ntlmv2 as auth mech within ntlmssp
Date: Fri, 30 Jul 2010 10:32:05 -0500
Message-ID: <1280503925-9746-1-git-send-email-shirishpargaonar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make ntlmv2 as an authentication mechanism ithin ntlmssp
instead of ntlmv1.

Parse type 2 response in ntlmssp negotiation to pluck
AV pairs and use them to calculate ntlmv2 response token.
Also, assign domain name from the sever response in type 2
packet of ntlmssp and use that (netbios) domain name in 
calculation of response.


>From 1309610674ecbbb60b316ad4d9df0c18994bff1f Mon Sep 17 00:00:00 2001
From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, 30 Jul 2010 10:18:32 -0500
Subject: [PATCH] make ntlmv2 as auth mech within ntlmssp

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   49 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/cifsglob.h    |    2 ++
 fs/cifs/cifspdu.h     |    1 -
 fs/cifs/ntlmssp.h     |   13 +++++++++++++
 fs/cifs/sess.c        |   45 +++++++++++++++++++++++++++++++--------------
 5 files changed, 91 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 847628d..61cf380 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -27,6 +27,7 @@
 #include "md5.h"
 #include "cifs_unicode.h"
 #include "cifsproto.h"
+#include "ntlmssp.h"
 #include <linux/ctype.h>
 #include <linux/random.h>
 
@@ -378,6 +379,44 @@ calc_exit_2:
 	return rc;
 }
 
+static void
+find_domain_name(struct cifsSesInfo *ses)
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
+				if (!ses->domainName) {
+					ses->domainName =
+						kmalloc(attrptr->length + 1,
+								GFP_KERNEL);
+					if (!ses->domainName)
+						return;
+					cifs_from_ucs2(ses->domainName,
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
 void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 		      const struct nls_table *nls_cp)
 {
@@ -390,10 +429,9 @@ void setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 	buf->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
 	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
 	buf->reserved2 = 0;
-	buf->names[0].type = cpu_to_le16(NTLMSSP_DOMAIN_TYPE);
-	buf->names[0].length = 0;
-	buf->names[1].type = 0;
-	buf->names[1].length = 0;
+
+	if (!ses->domainName)
+		find_domain_name(ses);
 
 	/* calculate buf->ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, nls_cp);
@@ -421,6 +459,9 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
 
 	hmac_md5_update(v2_session_response+8,
 			sizeof(struct ntlmv2_resp) - 8, &context);
+	if (ses->server->tilen)
+		hmac_md5_update(ses->server->tiblob,
+			ses->server->tilen, &context);
 
 	hmac_md5_final(v2_session_response, &context);
 /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d90abac..c4c5175 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -187,6 +187,8 @@ struct TCP_Server_Info {
 	unsigned long lstrp; /* when we got last response from this server */
 	u16 dialect; /* dialect index that server chose */
 	/* extended security flavors that server supports */
+	unsigned int tilen; /* length of the target info blob */
+	unsigned char *tiblob; /* target info blob in challenge response */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
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
 
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 49c9a4e..1db0f07 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -61,6 +61,19 @@
 #define NTLMSSP_NEGOTIATE_KEY_XCH   0x40000000
 #define NTLMSSP_NEGOTIATE_56        0x80000000
 
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
 /* Although typedefs are not commonly used for structure definitions */
 /* in the Linux kernel, in this particular case they are useful      */
 /* to more closely match the standards document for NTLMSSP from     */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 0a57cb7..32871a5 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -383,6 +383,9 @@ static int decode_ascii_ssetup(char **pbcc_area, int bleft,
 static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 				    struct cifsSesInfo *ses)
 {
+	unsigned int tioffset; /* challeng message target info area */
+	unsigned int tilen; /* challeng message target info area length  */
+
 	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
 
 	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
@@ -405,6 +408,18 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
 		we must set the MIC field of the AUTHENTICATE_MESSAGE */
 
+	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
+	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
+	ses->server->tilen = tilen;
+	if (tilen) {
+		ses->server->tiblob = kmalloc(tilen, GFP_KERNEL);
+		if (!ses->server->tiblob) {
+			cERROR(1, "Challenge target info allocation failure");
+			return -ENOMEM;
+		}
+		memcpy(ses->server->tiblob,  bcc_ptr + tioffset, tilen);
+	}
+
 	return 0;
 }
 
@@ -451,10 +466,11 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 				   struct cifsSesInfo *ses,
 				   const struct nls_table *nls_cp, bool first)
 {
+	unsigned int size;
 	AUTHENTICATE_MESSAGE *sec_blob = (AUTHENTICATE_MESSAGE *)pbuffer;
 	__u32 flags;
 	unsigned char *tmp;
-	char ntlm_session_key[CIFS_SESS_KEY_SIZE];
+	struct ntlmv2_resp ntlmv2_response = {};
 
 	memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
 	sec_blob->MessageType = NtLmAuthenticate;
@@ -477,19 +493,22 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
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
+	setup_ntlmv2_rsp(ses, (char *)&ntlmv2_response, nls_cp);
+	size =  sizeof(struct ntlmv2_resp);
+	memcpy(tmp, (char *)&ntlmv2_response, size);
+	tmp += size;
+	if (ses->server->tilen > 0) {
+		memcpy(tmp, ses->server->tiblob, ses->server->tilen);
+		kfree(ses->server->tiblob);
+		tmp += ses->server->tilen;
+	} else
+		ses->server->tilen = 0;
 
-	tmp += CIFS_SESS_KEY_SIZE;
+	sec_blob->NtChallengeResponse.Length = cpu_to_le16(size +
+				ses->server->tilen);
+	sec_blob->NtChallengeResponse.MaximumLength =
+		cpu_to_le16(size + ses->server->tilen);
 
 	if (ses->domainName == NULL) {
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
@@ -501,7 +520,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		len = cifs_strtoUCS((__le16 *)tmp, ses->domainName,
 				    MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
-		len += 2; /* trailing null */
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->DomainName.Length = cpu_to_le16(len);
 		sec_blob->DomainName.MaximumLength = cpu_to_le16(len);
@@ -518,7 +536,6 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		len = cifs_strtoUCS((__le16 *)tmp, ses->userName,
 				    MAX_USERNAME_SIZE, nls_cp);
 		len *= 2; /* unicode is 2 bytes each */
-		len += 2; /* trailing null */
 		sec_blob->UserName.BufferOffset = cpu_to_le32(tmp - pbuffer);
 		sec_blob->UserName.Length = cpu_to_le16(len);
 		sec_blob->UserName.MaximumLength = cpu_to_le16(len);
-- 
1.6.0.2
