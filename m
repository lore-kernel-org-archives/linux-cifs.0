From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] [CIFS] NTLM auth and sign - Use appropriate server challenge
Date: Wed, 27 Oct 2010 11:38:38 -0500
Message-ID: <1288197518-9117-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Need to have cryptKey or server challenge in smb connection
(struct TCP_Server_Info) for ntlm and ntlmv2 auth types for which
cryptKey (Encryption Key) is supplied just once in Negotiate Protocol
response during an smb connection setup for all the smb sessions over
that smb connection.

For ntlmssp, cryptKey or server challenge is provided for every
smb session in type 2 packet of ntlmssp negotiation, the cryptKey
provided during Negotiation Protocol response before smb connection
does not count.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   10 +++++++---
 fs/cifs/cifsglob.h    |    3 ++-
 fs/cifs/cifssmb.c     |    4 ++--
 fs/cifs/connect.c     |    4 ++--
 fs/cifs/sess.c        |   10 +++++++---
 5 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 17d603a..10d3d0f 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -249,7 +249,7 @@ int setup_ntlm_response(struct cifsSesInfo *ses)
 	}
 	ses->auth_key.len = temp_len;
 
-	SMBNTencrypt(ses->password, ses->cryptKey,
+	SMBNTencrypt(ses->password, ses->server->cryptKey,
 			ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 
 	E_md4hash(ses->password, temp_key);
@@ -537,8 +537,12 @@ CalcNTLMv2_response(const struct cifsSesInfo *ses)
 		return rc;
 	}
 
-	memcpy(ses->auth_key.response + offset,
-		ses->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
+	if (ses->server->secType == RawNTLMSSP)
+		memcpy(ses->auth_key.response + offset,
+			ses->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
+	else
+		memcpy(ses->auth_key.response + offset,
+			ses->server->cryptKey, CIFS_SERVER_CHALLENGE_SIZE);
 	crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + offset, ses->auth_key.len - offset);
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 67d6a22..7255657 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -196,6 +196,7 @@ struct TCP_Server_Info {
 	int capabilities; /* allow selective disabling of caps by smb sess */
 	int timeAdj;  /* Adjust for difference in server time zone in sec */
 	__u16 CurrentMid;         /* multiplex id - rotating counter */
+	char cryptKey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* needed for CIFS PDU signature */
@@ -240,7 +241,7 @@ struct cifsSesInfo {
 	char userName[MAX_USERNAME_SIZE + 1];
 	char *domainName;
 	char *password;
-	char cryptKey[CIFS_CRYPTO_KEY_SIZE];
+	char cryptKey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlmssp */
 	struct session_key auth_key;
 	char ntlmv2_hash[16];
 	unsigned int tilen; /* length of the target info blob */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e98f1f3..a32a42e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -503,7 +503,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 
 		if (rsp->EncryptionKeyLength ==
 				cpu_to_le16(CIFS_CRYPTO_KEY_SIZE)) {
-			memcpy(ses->cryptKey, rsp->EncryptionKey,
+			memcpy(ses->server->cryptKey, rsp->EncryptionKey,
 				CIFS_CRYPTO_KEY_SIZE);
 		} else if (server->secMode & SECMODE_PW_ENCRYPT) {
 			rc = -EIO; /* need cryptkey unless plain text */
@@ -574,7 +574,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifsSesInfo *ses)
 	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
 	server->timeAdj *= 60;
 	if (pSMBr->EncryptionKeyLength == CIFS_CRYPTO_KEY_SIZE) {
-		memcpy(ses->cryptKey, pSMBr->u.EncryptionKey,
+		memcpy(ses->server->cryptKey, pSMBr->u.EncryptionKey,
 		       CIFS_CRYPTO_KEY_SIZE);
 	} else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC)
 			&& (pSMBr->EncryptionKeyLength == 0)) {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 469c3dd..f8f1ec6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3002,13 +3002,13 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 		if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
 		    (ses->server->secType == LANMAN))
-			calc_lanman_hash(tcon->password, ses->cryptKey,
+			calc_lanman_hash(tcon->password, ses->server->cryptKey,
 					 ses->server->secMode &
 					    SECMODE_PW_ENCRYPT ? true : false,
 					 bcc_ptr);
 		else
 #endif /* CIFS_WEAK_PW_HASH */
-		SMBNTencrypt(tcon->password, ses->cryptKey, bcc_ptr);
+		SMBNTencrypt(tcon->password, ses->server->cryptKey, bcc_ptr);
 
 		bcc_ptr += CIFS_SESS_KEY_SIZE;
 		if (ses->capabilities & CAP_UNICODE) {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index e0515a6..cbd3bf7 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -667,10 +667,14 @@ ssetup_ntlmssp_authenticate:
 		/* no capabilities flags in old lanman negotiation */
 
 		pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_SESS_KEY_SIZE);
-		/* BB calculate hash with password */
-		/* and copy into bcc */
 
-		calc_lanman_hash(ses->password, ses->cryptKey,
+		/* Calculate hash with password and copy into bcc_ptr.
+		 * Encryption Key (stored as in cryptKey) gets used if the
+		 * security mode bit in Negottiate Protocol response states
+		 * to use challenge/response method (i.e. Password bit is 1).
+		 */
+
+		calc_lanman_hash(ses->password, ses->server->cryptKey,
 				 ses->server->secMode & SECMODE_PW_ENCRYPT ?
 					true : false, lnm_session_key);
 
-- 
1.6.0.2
