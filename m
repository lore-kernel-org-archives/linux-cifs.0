From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] CIFS: Fix possible use after free in demultiplex thread
Date: Tue, 28 Feb 2017 16:05:19 -0800
Message-ID: <1488326719-25303-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The recent changes that added SMB3 encryption support introduced
a possible use after free in the demultiplex thread. When we
process an encrypted packed we obtain a pointer to SMB session
but do not obtain a reference. This can possibly lead to a situation
when this session was freed before we copy a decryption key from
there. Fix this by obtaining a copy of the key rather than a pointer
to the session under a spinlock.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2ops.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a44b4db..d2cdd9c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1609,6 +1609,26 @@ static void cifs_crypt_complete(struct crypto_async_request *req, int err)
 	complete(&res->completion);
 }
 
+static int
+smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
+{
+	struct cifs_ses *ses;
+	u8 *ses_enc_key;
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		if (ses->Suid != ses_id)
+			continue;
+		ses_enc_key = enc ? ses->smb3encryptionkey :
+							ses->smb3decryptionkey;
+		memcpy(key, ses_enc_key, SMB3_SIGN_KEY_SIZE);
+		spin_unlock(&cifs_tcp_ses_lock);
+		return 0;
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	return 1;
+}
 /*
  * Encrypt or decrypt @rqst message. @rqst has the following format:
  * iov[0] - transform header (associate data),
@@ -1622,10 +1642,10 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 	struct smb2_transform_hdr *tr_hdr =
 			(struct smb2_transform_hdr *)rqst->rq_iov[0].iov_base;
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 24;
-	struct cifs_ses *ses;
 	int rc = 0;
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
+	u8 key[SMB3_SIGN_KEY_SIZE];
 	struct aead_request *req;
 	char *iv;
 	unsigned int iv_len;
@@ -1635,9 +1655,10 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 
 	init_completion(&result.completion);
 
-	ses = smb2_find_smb_ses(server, tr_hdr->SessionId);
-	if (!ses) {
-		cifs_dbg(VFS, "%s: Could not find session\n", __func__);
+	rc = smb2_get_enc_key(server, tr_hdr->SessionId, enc, key);
+	if (rc) {
+		cifs_dbg(VFS, "%s: Could not get %scryption key\n", __func__,
+			 enc ? "en" : "de");
 		return 0;
 	}
 
@@ -1649,8 +1670,7 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 
 	tfm = enc ? server->secmech.ccmaesencrypt :
 						server->secmech.ccmaesdecrypt;
-	rc = crypto_aead_setkey(tfm, enc ? ses->smb3encryptionkey :
-				ses->smb3decryptionkey, SMB3_SIGN_KEY_SIZE);
+	rc = crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
 		return rc;
-- 
2.7.4
