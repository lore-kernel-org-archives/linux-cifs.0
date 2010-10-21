From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] [CIFS] [2/3 -v3] NTLM auth and sign - Define crypto hash functions and create and send keys needed for key exchange
Date: Thu, 21 Oct 2010 06:43:03 -0500
Message-ID: <1287661383-6977-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Mark dependency on crypto modules in Kconfig.

Defining per structures sdesc and cifs_secmech which are used to store
crypto hash functions and contexts.  They are stored per smb connection
and used for all auth mechs to genereate hash values and signatures.

Allocate crypto hashing functions, security descriptiors, and respective
contexts when a smb/tcp connection is established.
Release them when a tcp/smb connection is taken down.

md5 and hmac-md5 are two crypto hashing functions that are used
throught the life of an smb/tcp connection by various functions that
calcualte signagure and ntlmv2 hash, HMAC etc.

structure ntlmssp_auth is defined as per smb connection.

ntlmssp_auth holds ciphertext which is genereated by rc4/arc4 encryption of
secondary key, a nonce using ntlmv2 session key and sent in the session key
field of the type 3 message sent by the client during ntlmssp
negotiation/exchange

A key is exchanged with the server if client indicates so in flags in
type 1 messsage and server agrees in flag in type 2 message of ntlmssp
negotiation.  If both client and agree, a key sent by client in
type 3 message of ntlmssp negotiation in the session key field.
The key is a ciphertext generated off of secondary key, a nonce, using
ntlmv2 hash via rc4/arc4.


Signing works for ntlmssp in this patch. The sequence number within
the server structure needs to be zero until session is established
i.e. till type 3 packet of ntlmssp exchange of a to be very first
smb session on that smb connection is sent.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Kconfig       |    3 +
 fs/cifs/cifsencrypt.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsglob.h    |   26 +++++++++++
 fs/cifs/cifspdu.h     |    6 +++
 fs/cifs/cifsproto.h   |    4 ++
 fs/cifs/connect.c     |   16 +++++-
 fs/cifs/sess.c        |   26 ++++++++---
 7 files changed, 188 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 917b7d4..0ed2139 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -2,6 +2,9 @@ config CIFS
 	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
 	select NLS
+	select CRYPTO
+	select CRYPTO_MD5
+	select CRYPTO_ARC4
 	help
 	  This is the client VFS module for the Common Internet File System
 	  (CIFS) protocol which is the successor to the Server Message Block
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 987b479..0c4807c 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -72,6 +72,8 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 		return rc;
 
 	spin_lock(&GlobalMid_Lock);
+	if (server->secType == RawNTLMSSP && !server->session_estab)
+		server->sequence_number = 0x0;
 	cifs_pdu->Signature.Sequence.SequenceNumber =
 			cpu_to_le32(server->sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
@@ -139,6 +141,8 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 		return rc;
 
 	spin_lock(&GlobalMid_Lock);
+	if (server->secType == RawNTLMSSP && !server->session_estab)
+		server->sequence_number = 0x0;
 	cifs_pdu->Signature.Sequence.SequenceNumber =
 				cpu_to_le32(server->sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
@@ -541,6 +545,119 @@ setup_ntlmv2_rsp_ret:
 	return rc;
 }
 
+int
+calc_seckey(struct cifsSesInfo *ses)
+{
+	int rc;
+	struct crypto_blkcipher *tfm_arc4;
+	struct scatterlist sgin, sgout;
+	struct blkcipher_desc desc;
+	unsigned char sec_key[CIFS_SESS_KEY_SIZE]; /* a nonce */
+
+	get_random_bytes(sec_key, CIFS_SESS_KEY_SIZE);
+
+	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	if (!tfm_arc4 || IS_ERR(tfm_arc4)) {
+		cERROR(1, "could not allocate crypto API arc4\n");
+		return PTR_ERR(tfm_arc4);
+	}
+
+	desc.tfm = tfm_arc4;
+
+	crypto_blkcipher_setkey(tfm_arc4, ses->auth_key.response,
+					CIFS_SESS_KEY_SIZE);
+
+	sg_init_one(&sgin, sec_key, CIFS_SESS_KEY_SIZE);
+	sg_init_one(&sgout, ses->ntlmssp.ciphertext, CIFS_CPHTXT_SIZE);
+
+	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS_CPHTXT_SIZE);
+	if (rc) {
+		cERROR(1, "could not encrypt session key rc: %d\n", rc);
+		crypto_free_blkcipher(tfm_arc4);
+		return rc;
+	}
+
+	/* make secondary_key/nonce as session key */
+	memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
+	/* and make len as that of session key only */
+	ses->auth_key.len = CIFS_SESS_KEY_SIZE;
+
+	crypto_free_blkcipher(tfm_arc4);
+
+	return 0;
+}
+
+void
+cifs_crypto_shash_release(struct TCP_Server_Info *server)
+{
+	if (server->secmech.md5)
+		crypto_free_shash(server->secmech.md5);
+
+	if (server->secmech.hmacmd5)
+		crypto_free_shash(server->secmech.hmacmd5);
+
+	kfree(server->secmech.sdeschmacmd5);
+
+	kfree(server->secmech.sdescmd5);
+}
+
+int
+cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
+{
+	int rc;
+	unsigned int size;
+
+	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
+	if (!server->secmech.hmacmd5 ||
+			IS_ERR(server->secmech.hmacmd5)) {
+		cERROR(1, "could not allocate crypto hmacmd5\n");
+		return PTR_ERR(server->secmech.hmacmd5);
+	}
+
+	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
+	if (!server->secmech.md5 || IS_ERR(server->secmech.md5)) {
+		cERROR(1, "could not allocate crypto md5\n");
+		rc = PTR_ERR(server->secmech.md5);
+		goto crypto_allocate_md5_fail;
+	}
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.hmacmd5);
+	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdeschmacmd5) {
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5\n");
+		rc = -ENOMEM;
+		goto crypto_allocate_hmacmd5_sdesc_fail;
+	}
+	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
+	server->secmech.sdeschmacmd5->shash.flags = 0x0;
+
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.md5);
+	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdescmd5) {
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5\n");
+		rc = -ENOMEM;
+		goto crypto_allocate_md5_sdesc_fail;
+	}
+	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
+	server->secmech.sdescmd5->shash.flags = 0x0;
+
+	return 0;
+
+crypto_allocate_md5_sdesc_fail:
+	kfree(server->secmech.sdeschmacmd5);
+
+crypto_allocate_hmacmd5_sdesc_fail:
+	crypto_free_shash(server->secmech.md5);
+
+crypto_allocate_md5_fail:
+	crypto_free_shash(server->secmech.hmacmd5);
+
+	return rc;
+}
+
 void CalcNTLMv2_response(const struct cifsSesInfo *ses)
 {
 	unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 68d0da0..78e9142 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -25,6 +25,9 @@
 #include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
+#include <crypto/internal/hash.h>
+#include <linux/scatterlist.h>
+
 /*
  * The sizes of various internal tables and strings
  */
@@ -102,6 +105,27 @@ struct session_key {
 	char *response;
 };
 
+/* crypto security descriptor definition */
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+/* crypto hashing related structure/fields, not speicific to a sec mech */
+struct cifs_secmech {
+	struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
+	struct crypto_shash *md5; /* md5 hash function */
+	struct sdesc *sdeschmacmd5;  /* ctxt to generate ntlmv2 hash, CR1 */
+	struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signature */
+};
+
+/* per smb connection structure/fields */
+struct ntlmssp_auth {
+	__u32 client_flags; /* sent by client in type 1 ntlmsssp exchange */
+	__u32 server_flags; /* sent by server in type 2 ntlmssp exchange */
+	unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to server */
+};
+
 struct cifs_cred {
 	int uid;
 	int gid;
@@ -178,6 +202,7 @@ struct TCP_Server_Info {
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
 	u16 dialect; /* dialect index that server chose */
+	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 	/* extended security flavors that server supports */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
@@ -220,6 +245,7 @@ struct cifsSesInfo {
 	char ntlmv2_hash[16];
 	unsigned int tilen; /* length of the target info blob */
 	unsigned char *tiblob; /* target info blob in challenge response */
+	struct ntlmssp_auth ntlmssp; /* ciphertext, flags */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 };
 /* no more than one of the following three session flags may be set */
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index a152cd6..de36b09 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -140,6 +140,12 @@
  */
 #define CIFS_SESS_KEY_SIZE (16)
 
+#define CIFS_CLIENT_CHALLENGE_SIZE (8)
+#define CIFS_SERVER_CHALLENGE_SIZE (8)
+#define CIFS_HMAC_MD5_HASH_SIZE (16)
+#define CIFS_CPHTXT_SIZE (16)
+#define CIFS_NTHASH_SIZE (16)
+
 /*
  * Maximum user name length
  */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8c2d0cf..1e4728b 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -368,6 +368,10 @@ extern void SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
 extern int setup_ntlm_response(struct cifsSesInfo *);
 extern void CalcNTLMv2_response(const struct cifsSesInfo *);
 extern int setup_ntlmv2_rsp(struct cifsSesInfo *, const struct nls_table *);
+extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
+extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
+extern int calc_seckey(struct cifsSesInfo *);
+
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern void calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6182b63..80e8b75 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1563,6 +1563,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
 
+	cifs_crypto_shash_release(server);
 	cifs_fscache_release_client_cookie(server);
 
 	kfree(server->session_key.response);
@@ -1621,10 +1622,16 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err;
 	}
 
+	rc = cifs_crypto_shash_allocate(tcp_ses);
+	if (rc) {
+		cERROR(1, "could not setup hash structures rc %d", rc);
+		goto out_err;
+	}
+
 	tcp_ses->hostname = extract_hostname(volume_info->UNC);
 	if (IS_ERR(tcp_ses->hostname)) {
 		rc = PTR_ERR(tcp_ses->hostname);
-		goto out_err;
+		goto out_err2;
 	}
 
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
@@ -1668,7 +1675,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	}
 	if (rc < 0) {
 		cERROR(1, "Error connecting to socket. Aborting operation");
-		goto out_err;
+		goto out_err2;
 	}
 
 	/*
@@ -1682,7 +1689,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		rc = PTR_ERR(tcp_ses->tsk);
 		cERROR(1, "error %d create cifsd thread", rc);
 		module_put(THIS_MODULE);
-		goto out_err;
+		goto out_err2;
 	}
 
 	/* thread spawned, put it on the list */
@@ -1694,6 +1701,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	return tcp_ses;
 
+out_err2:
+	cifs_crypto_shash_release(tcp_ses);
+
 out_err:
 	if (tcp_ses) {
 		if (!IS_ERR(tcp_ses->hostname))
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 82cab31..5832345 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -404,7 +404,7 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	/* In particular we can examine sign flags */
 	/* BB spec says that if AvId field of MsvAvTimestamp is populated then
 		we must set the MIC field of the AUTHENTICATE_MESSAGE */
-
+	ses->ntlmssp.server_flags = le32_to_cpu(pblob->NegotiateFlags);
 	tioffset = cpu_to_le16(pblob->TargetInfoArray.BufferOffset);
 	tilen = cpu_to_le16(pblob->TargetInfoArray.Length);
 	ses->tilen = tilen;
@@ -440,10 +440,12 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
 		NTLMSSP_NEGOTIATE_NTLM;
 	if (ses->server->secMode &
-	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
-	if (ses->server->secMode & SECMODE_SIGN_REQUIRED)
-		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
+		if (!ses->server->session_estab)
+			flags |= NTLMSSP_NEGOTIATE_KEY_XCH |
+				NTLMSSP_NEGOTIATE_EXTENDED_SEC;
+	}
 
 	sec_blob->NegotiateFlags |= cpu_to_le32(flags);
 
@@ -543,9 +545,19 @@ static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->WorkstationName.MaximumLength = 0;
 	tmp += 2;
 
-	sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
-	sec_blob->SessionKey.Length = 0;
-	sec_blob->SessionKey.MaximumLength = 0;
+	if ((ses->ntlmssp.server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) &&
+			!calc_seckey(ses)) {
+		memcpy(tmp, ses->ntlmssp.ciphertext, CIFS_CPHTXT_SIZE);
+		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
+		sec_blob->SessionKey.Length = cpu_to_le16(CIFS_CPHTXT_SIZE);
+		sec_blob->SessionKey.MaximumLength =
+				cpu_to_le16(CIFS_CPHTXT_SIZE);
+		tmp += CIFS_CPHTXT_SIZE;
+	} else {
+		sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
+		sec_blob->SessionKey.Length = 0;
+		sec_blob->SessionKey.MaximumLength = 0;
+	}
 
 setup_ntlmv2_ret:
 	*buflen = tmp - pbuffer;
-- 
1.6.0.2
