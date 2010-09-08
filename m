From: shirishpargaonkar@gmail.com
Subject: [PATCH 7/8 Rev2] ntlmv2/ntlmssp  generate secondary session key and ciphertext and send it if signing enabled
Date: Wed,  8 Sep 2010 12:04:38 -0500
Message-ID: <1283965478-19009-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: smfrench@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>


A key is exchanged with the server if client indicates so in flags in
type 1 messsage and server agrees in flag in type 2 message of ntlmssp
negotiation.  If both client and agree, a key sent by client in
type 3 message of ntlmssp negotiation in the session key field.
The key is a ciphertext generated off of secondary key, a nonce, using
ntlmv2 hash via rc4/arc4. ciphertext is calculated within a mutex lock.

If authentication is successful, the secondary key is the that client
uses to calculate cifs/smb signature in the messages that client sends
and to verify the messages sent by server.
This key stays with the smb connection for its life and is the key used
to generate (and verify) signatures for all the subsequent smb sessions
for this smb connection.

So only for the first smb session on any smb connection, type 1 message
of ntlmssp negotiation selects the flag NTLMSSP_NEGOTIATE_KEY_XCH.
It is not used for subsequent smb sessions on this smb connection i.e.
no need to generate secondary key, create ciphertext and send it etc.

After the very first successful smb session, sequence number gets set
to 0 and  variable cphready is used to mark that the key calculations
are done, this is done within a mutex lock.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
---
 fs/cifs/cifsencrypt.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsproto.h   |    1 +
 fs/cifs/connect.c     |    1 +
 fs/cifs/sess.c        |   24 +++++++++++++++++-----
 4 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index f9c140a..197fc85 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -470,6 +470,58 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
 /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
 }
 
+int
+calc_seckey(struct TCP_Server_Info *server)
+{
+	int rc;
+	struct crypto_blkcipher *tfm_arc4;
+	struct scatterlist sgin, sgout;
+	struct blkcipher_desc desc;
+
+	if (!server) {
+		cERROR(1, "%s: Can't determine ciphertext key\n", __func__);
+		return 1;
+	}
+
+	mutex_lock(&server->srv_mutex);
+	if (server->cphready) {
+		mutex_unlock(&server->srv_mutex);
+		return 0;
+	}
+
+	get_random_bytes(server->ntlmssp.sec_key, CIFS_NTLMV2_SESSKEY_SIZE);
+
+	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
+		cERROR(1, "could not allocate arc4 crypto function\n");
+		mutex_unlock(&server->srv_mutex);
+		return 1;
+	}
+
+	desc.tfm = tfm_arc4;
+
+	crypto_blkcipher_setkey(tfm_arc4, server->session_key.data.ntlmv2.key,
+					CIFS_CPHTXT_SIZE);
+
+	sg_init_one(&sgin, server->ntlmssp.sec_key, CIFS_CPHTXT_SIZE);
+	sg_init_one(&sgout, server->ntlmssp.ciphertext, CIFS_CPHTXT_SIZE);
+
+	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS_CPHTXT_SIZE);
+	if (rc) {
+		cERROR(1, "could not encrypt session key rc: %d\n", rc);
+		mutex_unlock(&server->srv_mutex);
+		return rc;
+	}
+
+	crypto_free_blkcipher(tfm_arc4);
+
+	server->sequence_number = 0;
+	server->cphready = true;
+	mutex_unlock(&server->srv_mutex);
+
+	return 0;
+}
+
 void
 cifs_crypto_shash_release(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fbfdd8e..b78bb77 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -370,6 +370,7 @@ extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
 			     const struct nls_table *);
 extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
 extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
+extern int calc_seckey(struct TCP_Server_Info *);
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern void calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0621a72..e3883f3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1587,6 +1587,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err2;
 	}
 
+	tcp_ses->cphready = false;
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 68ea153..7c94d7b 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -444,10 +444,12 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
 		NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->secMode &
-	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
-	if (ses->server->secMode & SECMODE_SIGN_REQUIRED)
-		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
+		if (!ses->server->cphready)
+			flags |= NTLMSSP_NEGOTIATE_KEY_XCH |
+				NTLMSSP_NEGOTIATE_EXTENDED_SEC;
+	}
 
 	sec_blob->NegotiateFlags |= cpu_to_le32(flags);
 
@@ -554,9 +556,19 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
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
 
 setup_ntlmv2_ret:
 	return tmp - pbuffer;
-- 
1.6.0.2
