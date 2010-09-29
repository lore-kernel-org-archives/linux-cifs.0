From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/7 cifs] ntlm authentication and signing - Make tiblob as part of session key (response)
Date: Wed, 29 Sep 2010 09:39:52 -0500
Message-ID: <1285771192-23170-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Have to move av_pair/ti blob to session key as part of ntlmv2 response.
This entire blob is part of the response and is use to calculate
signature for cases like ntlmv2 (without extended security) authentication.
The size of the blob is hard coded to 1024 byte which should be
sufficient to accomodate all 11 types of av pair types and their
lenghts/values.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   22 ++++++++--------------
 fs/cifs/cifsglob.h    |    2 +-
 fs/cifs/cifspdu.h     |    5 +++++
 fs/cifs/connect.c     |    1 -
 fs/cifs/sess.c        |   24 ++++++------------------
 5 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 0dda565..84c22e3 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -292,14 +292,7 @@ build_avpair_blob(struct cifsSesInfo *ses, const struct nls_table *nls_cp)
 	wlen = strlen(ses->server->hostname);
 
 	ses->tilen = size + 2 * (2 * dlen) + 2 * (2 * wlen) + 8;
-	ses->tiblob = kzalloc(ses->tilen, GFP_KERNEL);
-	if (!ses->tiblob) {
-		ses->tilen = 0;
-		cERROR(1, "Challenge target info allocation failure");
-		return -ENOMEM;
-	}
-
-	blobptr = ses->tiblob;
+	blobptr = ses->auth_key.data.ntlmv2.tiblob;
 	attrptr = (struct ntlmssp2_name *) blobptr;
 
 	attrptr->type = cpu_to_le16(NTLMSSP_AV_NB_DOMAIN_NAME);
@@ -369,11 +362,11 @@ find_domain_name(struct cifsSesInfo *ses)
 	unsigned char *blobend;
 	struct ntlmssp2_name *attrptr;
 
-	if (!ses->tilen || !ses->tiblob)
+	if (!ses->tilen)
 		return 0;
 
-	blobptr = ses->tiblob;
-	blobend = ses->tiblob + ses->tilen;
+	blobptr = ses->auth_key.data.ntlmv2.tiblob;
+	blobend = blobptr + ses->tilen;
 
 	while (blobptr + onesize < blobend) {
 		attrptr = (struct ntlmssp2_name *) blobptr;
@@ -510,12 +503,12 @@ setup_ntlmv2_rsp(struct cifsSesInfo *ses, char *resp_buf,
 	memcpy(&ses->auth_key.data.ntlmv2.resp, resp_buf,
 	       sizeof(struct ntlmv2_resp));
 	ses->auth_key.len = 16 + sizeof(struct ntlmv2_resp);
+	if (ses->tilen)
+		ses->auth_key.len += ses->tilen;
 
 	return 0;
 
 setup_ntlmv2_rsp_ret:
-	kfree(ses->tiblob);
-	ses->tiblob = NULL;
 	ses->tilen = 0;
 
 	return rc;
@@ -533,7 +526,8 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
 			sizeof(struct ntlmv2_resp) - 8, &context);
 
 	if (ses->tilen)
-		hmac_md5_update(ses->tiblob, ses->tilen, &context);
+		hmac_md5_update(ses->auth_key.data.ntlmv2.tiblob, ses->tilen,
+					&context);
 
 	hmac_md5_final(v2_session_response, &context);
 /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 4ae331c..72205d4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -105,6 +105,7 @@ struct session_key {
 		struct {
 			char key[16];
 			struct ntlmv2_resp resp;
+			unsigned char tiblob[CIFS_MAX_NTLMV2_AVPAIR_SIZE];
 		} ntlmv2;
 	} data;
 };
@@ -226,7 +227,6 @@ struct cifsSesInfo {
 	struct session_key auth_key;
 	char ntlmv2_hash[16];
 	unsigned int tilen; /* length of the target info blob */
-	unsigned char *tiblob; /* target info blob in challenge response */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 };
 /* no more than one of the following three session flags may be set */
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index b0f4b56..e778165 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -136,6 +136,11 @@
 #define CIFS_SESS_KEY_SIZE (24)
 
 /*
+ * Max expected size of an av pair blob in ntlmv2 auth exchange
+ */
+#define CIFS_MAX_NTLMV2_AVPAIR_SIZE (1024)
+
+/*
  * Maximum user name length
  */
 #define CIFS_UNLEN (20)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 12a6e20..f96f3c6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1787,7 +1787,6 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 		goto get_ses_fail;
 
 	ses->tilen = 0;
-	ses->tiblob = NULL;
 	/* new SMB session uses our server ref */
 	ses->server = server;
 	if (server->addr.sockAddr6.sin6_family == AF_INET6)
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index d632331..588de94 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -411,15 +411,9 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
 	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
 	ses->tilen = tilen;
-	if (ses->tilen) {
-		ses->tiblob = kmalloc(tilen, GFP_KERNEL);
-		if (!ses->tiblob) {
-			cERROR(1, "Challenge target info allocation failure");
-			ses->tilen = 0;
-			return -ENOMEM;
-		}
-		memcpy(ses->tiblob,  bcc_ptr + tioffset, ses->tilen);
-	}
+	if (ses->tilen && ses->tilen <= CIFS_MAX_NTLMV2_AVPAIR_SIZE)
+		memcpy(ses->auth_key.data.ntlmv2.tiblob,  bcc_ptr + tioffset,
+				ses->tilen);
 
 	return 0;
 }
@@ -505,16 +499,13 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	memcpy(tmp, (char *)&ntlmv2_response, size);
 	tmp += size;
 	if (ses->tilen > 0) {
-		memcpy(tmp, ses->tiblob, ses->tilen);
+		memcpy(tmp, ses->auth_key.data.ntlmv2.tiblob, ses->tilen);
 		tmp += ses->tilen;
 	}
 
 	sec_blob->NtChallengeResponse.Length = cpu_to_le16(size + ses->tilen);
 	sec_blob->NtChallengeResponse.MaximumLength =
 				cpu_to_le16(size + ses->tilen);
-	kfree(ses->tiblob);
-	ses->tiblob = NULL;
-	ses->tilen = 0;
 
 	if (ses->domainName == NULL) {
 		sec_blob->DomainName.BufferOffset = cpu_to_le32(tmp - pbuffer);
@@ -750,15 +741,12 @@ ssetup_ntlmssp_authenticate:
 		bcc_ptr += sizeof(struct ntlmv2_resp);
 		kfree(v2_sess_key);
 		if (ses->tilen > 0) {
-			memcpy(bcc_ptr, ses->tiblob, ses->tilen);
+			memcpy(bcc_ptr, ses->auth_key.data.ntlmv2.tiblob,
+					ses->tilen);
 			bcc_ptr += ses->tilen;
 			pSMB->req_no_secext.CaseSensitivePasswordLength =
 				cpu_to_le16(sizeof(struct ntlmv2_resp) +
 						ses->tilen);
-			/* we never did allocate ses->domainName to free */
-			kfree(ses->tiblob);
-			ses->tiblob = NULL;
-			ses->tilen = 0;
 		} else
 			pSMB->req_no_secext.CaseSensitivePasswordLength =
 				cpu_to_le16(sizeof(struct ntlmv2_resp));
-- 
1.6.0.2
