From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Limit allocation of crypto mechanisms to when we need
 it for a particular dialect [version 2]
Date: Wed, 3 Jul 2013 23:57:02 -0500
Message-ID: <CAH2r5muf77vV9b4X+0U6Kv57XNPfxcCHAy7+hHtt_Fu96o+PzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b6d80b0b5f6e404e0a86893
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b6d80b0b5f6e404e0a86893
Content-Type: text/plain; charset=ISO-8859-1

Updated patch based on Jeff's feedback

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, 3 Jul 2013 23:52:11 -0500
Subject: [PATCH] [CIFS] Limit allocation of crypto mechanisms to dialect
 which requires it

Updated patch to try to prevent allocation of cifs, smb2 or smb3 crypto
secmech structures unless needed.  Currently cifs allocates all crypto
mechanisms when the first session is established (4 functions and
4 contexts), rather than only allocating these when needed (smb3 needs
two, the rest of the dialects only need one).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c   | 195 +++++++++++++++++++++---------------------------
 fs/cifs/cifsproto.h     |   1 -
 fs/cifs/connect.c       |   6 --
 fs/cifs/smb2transport.c |  92 ++++++++++++++++++++++-
 4 files changed, 176 insertions(+), 118 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 3d8bf94..a95ee91 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -1,7 +1,7 @@
 /*
  *   fs/cifs/cifsencrypt.c
  *
- *   Copyright (C) International Business Machines  Corp., 2005,2006
+ *   Copyright (C) International Business Machines  Corp., 2005,2013
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This library is free software; you can redistribute it and/or modify
@@ -31,6 +31,36 @@
 #include <linux/random.h>
 #include <linux/highmem.h>

+static int
+cifs_crypto_shash_md5_allocate(struct TCP_Server_Info *server)
+{
+	int rc;
+	unsigned int size;
+
+	if (server->secmech.sdescmd5 != NULL)
+		return 0; /* already allocated */
+
+	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
+	if (IS_ERR(server->secmech.md5)) {
+		cifs_dbg(VFS, "could not allocate crypto md5\n");
+		return PTR_ERR(server->secmech.md5);
+	}
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.md5);
+	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdescmd5) {
+		rc = -ENOMEM;
+		crypto_free_shash(server->secmech.md5);
+		server->secmech.md5 = NULL;
+		return rc;
+	}
+	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
+	server->secmech.sdescmd5->shash.flags = 0x0;
+
+	return 0;
+}
+
 /*
  * Calculate and return the CIFS signature based on the mac key and SMB PDU.
  * The 16 byte signature must be allocated by the caller. Note we only use the
@@ -50,8 +80,11 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 		return -EINVAL;

 	if (!server->secmech.sdescmd5) {
-		cifs_dbg(VFS, "%s: Can't generate signature\n", __func__);
-		return -1;
+		rc = cifs_crypto_shash_md5_allocate(server);
+		if (rc) {
+			cifs_dbg(VFS, "%s: Can't alloc md5 crypto\n", __func__);
+			return -1;
+		}
 	}

 	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
@@ -556,6 +589,33 @@ CalcNTLMv2_response(const struct cifs_ses *ses,
char *ntlmv2_hash)
 	return rc;
 }

+static int crypto_hmacmd5_alloc(struct TCP_Server_Info *server)
+{
+	unsigned int size;
+
+	/* check if already allocated */
+	if (server->secmech.sdeschmacmd5)
+		return 0;
+
+	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
+	if (IS_ERR(server->secmech.hmacmd5)) {
+		cifs_dbg(VFS, "could not allocate crypto hmacmd5\n");
+		return PTR_ERR(server->secmech.hmacmd5);
+	}
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.hmacmd5);
+	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdeschmacmd5) {
+		crypto_free_shash(server->secmech.hmacmd5);
+		server->secmech.hmacmd5 = NULL;
+		return -ENOMEM;
+	}
+	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
+	server->secmech.sdeschmacmd5->shash.flags = 0x0;
+
+	return 0;
+}

 int
 setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
@@ -606,6 +666,12 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const
struct nls_table *nls_cp)

 	memcpy(ses->auth_key.response + baselen, tiblob, tilen);

+	rc = crypto_hmacmd5_alloc(ses->server);
+	if (rc) {
+		cifs_dbg(VFS, "could not crypto alloc md5 rc %d\n", rc);
+		goto setup_ntlmv2_rsp_ret;
+	}
+
 	/* calculate ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
 	if (rc) {
@@ -705,123 +771,32 @@ calc_seckey(struct cifs_ses *ses)
 void
 cifs_crypto_shash_release(struct TCP_Server_Info *server)
 {
-	if (server->secmech.cmacaes)
+	if (server->secmech.cmacaes) {
 		crypto_free_shash(server->secmech.cmacaes);
+		server->secmech.cmacaes = NULL;
+	}

-	if (server->secmech.hmacsha256)
+	if (server->secmech.hmacsha256) {
 		crypto_free_shash(server->secmech.hmacsha256);
+		server->secmech.hmacsha256 = NULL;
+	}

-	if (server->secmech.md5)
+	if (server->secmech.md5) {
 		crypto_free_shash(server->secmech.md5);
+		server->secmech.md5 = NULL;
+	}

-	if (server->secmech.hmacmd5)
+	if (server->secmech.hmacmd5) {
 		crypto_free_shash(server->secmech.hmacmd5);
+		server->secmech.hmacmd5 = NULL;
+	}

 	kfree(server->secmech.sdesccmacaes);
-
+	server->secmech.sdesccmacaes = NULL;
 	kfree(server->secmech.sdeschmacsha256);
-
+	server->secmech.sdeschmacsha256 = NULL;
 	kfree(server->secmech.sdeschmacmd5);
-
+	server->secmech.sdeschmacmd5 = NULL;
 	kfree(server->secmech.sdescmd5);
-}
-
-int
-cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
-{
-	int rc;
-	unsigned int size;
-
-	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
-	if (IS_ERR(server->secmech.hmacmd5)) {
-		cifs_dbg(VFS, "could not allocate crypto hmacmd5\n");
-		return PTR_ERR(server->secmech.hmacmd5);
-	}
-
-	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
-	if (IS_ERR(server->secmech.md5)) {
-		cifs_dbg(VFS, "could not allocate crypto md5\n");
-		rc = PTR_ERR(server->secmech.md5);
-		goto crypto_allocate_md5_fail;
-	}
-
-	server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
-	if (IS_ERR(server->secmech.hmacsha256)) {
-		cifs_dbg(VFS, "could not allocate crypto hmacsha256\n");
-		rc = PTR_ERR(server->secmech.hmacsha256);
-		goto crypto_allocate_hmacsha256_fail;
-	}
-
-	server->secmech.cmacaes = crypto_alloc_shash("cmac(aes)", 0, 0);
-	if (IS_ERR(server->secmech.cmacaes)) {
-		cifs_dbg(VFS, "could not allocate crypto cmac-aes");
-		rc = PTR_ERR(server->secmech.cmacaes);
-		goto crypto_allocate_cmacaes_fail;
-	}
-
-	size = sizeof(struct shash_desc) +
-			crypto_shash_descsize(server->secmech.hmacmd5);
-	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
-	if (!server->secmech.sdeschmacmd5) {
-		rc = -ENOMEM;
-		goto crypto_allocate_hmacmd5_sdesc_fail;
-	}
-	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
-	server->secmech.sdeschmacmd5->shash.flags = 0x0;
-
-	size = sizeof(struct shash_desc) +
-			crypto_shash_descsize(server->secmech.md5);
-	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
-	if (!server->secmech.sdescmd5) {
-		rc = -ENOMEM;
-		goto crypto_allocate_md5_sdesc_fail;
-	}
-	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
-	server->secmech.sdescmd5->shash.flags = 0x0;
-
-	size = sizeof(struct shash_desc) +
-			crypto_shash_descsize(server->secmech.hmacsha256);
-	server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
-	if (!server->secmech.sdeschmacsha256) {
-		rc = -ENOMEM;
-		goto crypto_allocate_hmacsha256_sdesc_fail;
-	}
-	server->secmech.sdeschmacsha256->shash.tfm = server->secmech.hmacsha256;
-	server->secmech.sdeschmacsha256->shash.flags = 0x0;
-
-	size = sizeof(struct shash_desc) +
-			crypto_shash_descsize(server->secmech.cmacaes);
-	server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
-	if (!server->secmech.sdesccmacaes) {
-		cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
-		rc = -ENOMEM;
-		goto crypto_allocate_cmacaes_sdesc_fail;
-	}
-	server->secmech.sdesccmacaes->shash.tfm = server->secmech.cmacaes;
-	server->secmech.sdesccmacaes->shash.flags = 0x0;
-
-	return 0;
-
-crypto_allocate_cmacaes_sdesc_fail:
-	kfree(server->secmech.sdeschmacsha256);
-
-crypto_allocate_hmacsha256_sdesc_fail:
-	kfree(server->secmech.sdescmd5);
-
-crypto_allocate_md5_sdesc_fail:
-	kfree(server->secmech.sdeschmacmd5);
-
-crypto_allocate_hmacmd5_sdesc_fail:
-	crypto_free_shash(server->secmech.cmacaes);
-
-crypto_allocate_cmacaes_fail:
-	crypto_free_shash(server->secmech.hmacsha256);
-
-crypto_allocate_hmacsha256_fail:
-	crypto_free_shash(server->secmech.md5);
-
-crypto_allocate_md5_fail:
-	crypto_free_shash(server->secmech.hmacmd5);
-
-	return rc;
+	server->secmech.sdescmd5 = NULL;
 }
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c8ff018..f7e584d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -433,7 +433,6 @@ extern int SMBNTencrypt(unsigned char *, unsigned
char *, unsigned char *,
 			const struct nls_table *);
 extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
 extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
-extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
 extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 extern int calc_seckey(struct cifs_ses *);
 extern void generate_smb3signingkey(struct TCP_Server_Info *);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index afcb8a1..fa68813 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2108,12 +2108,6 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err;
 	}

-	rc = cifs_crypto_shash_allocate(tcp_ses);
-	if (rc) {
-		cifs_dbg(VFS, "could not setup hash structures rc %d\n", rc);
-		goto out_err;
-	}
-
 	tcp_ses->ops = volume_info->ops;
 	tcp_ses->vals = volume_info->vals;
 	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 09b4fba..aef8ff4 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -39,6 +39,77 @@
 #include "smb2status.h"
 #include "smb2glob.h"

+static int
+smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
+{
+	unsigned int size;
+
+	if (server->secmech.sdeschmacsha256 != NULL)
+		return 0; /* already allocated */
+
+	server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
+	if (IS_ERR(server->secmech.hmacsha256)) {
+		cifs_dbg(VFS, "could not allocate crypto hmacsha256\n");
+		return PTR_ERR(server->secmech.hmacsha256);
+	}
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.hmacsha256);
+	server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdeschmacsha256) {
+		crypto_free_shash(server->secmech.hmacsha256);
+		server->secmech.hmacsha256 = NULL;
+		return -ENOMEM;
+	}
+	server->secmech.sdeschmacsha256->shash.tfm = server->secmech.hmacsha256;
+	server->secmech.sdeschmacsha256->shash.flags = 0x0;
+
+	return 0;
+}
+
+static int
+smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
+{
+	unsigned int size;
+	int rc;
+
+	if (server->secmech.sdesccmacaes != NULL)
+		return 0;  /* already allocated */
+
+	rc = smb2_crypto_shash_allocate(server);
+	if (rc)
+		return rc;
+
+	server->secmech.cmacaes = crypto_alloc_shash("cmac(aes)", 0, 0);
+	if (IS_ERR(server->secmech.cmacaes)) {
+		cifs_dbg(VFS, "could not allocate crypto cmac-aes");
+		kfree(server->secmech.sdeschmacsha256);
+		server->secmech.sdeschmacsha256 = NULL;
+		crypto_free_shash(server->secmech.hmacsha256);
+		server->secmech.hmacsha256 = NULL;
+		return PTR_ERR(server->secmech.cmacaes);
+	}
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.cmacaes);
+	server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdesccmacaes) {
+		cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
+		kfree(server->secmech.sdeschmacsha256);
+		server->secmech.sdeschmacsha256 = NULL;
+		crypto_free_shash(server->secmech.hmacsha256);
+		crypto_free_shash(server->secmech.cmacaes);
+		server->secmech.hmacsha256 = NULL;
+		server->secmech.cmacaes = NULL;
+		return -ENOMEM;
+	}
+	server->secmech.sdesccmacaes->shash.tfm = server->secmech.cmacaes;
+	server->secmech.sdesccmacaes->shash.flags = 0x0;
+
+	return 0;
+}
+
+
 int
 smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
@@ -52,6 +123,12 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
TCP_Server_Info *server)
 	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);

+	rc = smb2_crypto_shash_allocate(server);
+	if (rc) {
+		cifs_dbg(VFS, "%s: shah256 alloc failed\n", __func__);
+		return rc;
+	}
+
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
 		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
@@ -61,7 +138,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
TCP_Server_Info *server)

 	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
 	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
+		cifs_dbg(VFS, "%s: Could not init sha256", __func__);
 		return rc;
 	}

@@ -129,6 +206,14 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
 	memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
 	memset(server->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);

+	/* SMB3 essentially requires signing so no harm making sure needed
+	   sechmech (hmacsha256 and aes) are allocated now */
+	rc = smb3_crypto_shash_allocate(server);
+	if (rc) {
+		cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
+		goto smb3signkey_ret;
+	}
+
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
 		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
@@ -210,6 +295,11 @@ smb3_calc_signature(struct smb_rqst *rqst, struct
TCP_Server_Info *server)
 		return rc;
 	}

+	/*
+	 * we already allocate sdesccmacaes when we init smb3 signing key,
+	 * so unlike smb2 case we do not have to check here if secmech are
+	 * initialized
+	 */
 	rc = crypto_shash_init(&server->secmech.sdesccmacaes->shash);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not init cmac aes\n", __func__);
-- 
1.7.11.7


-- 
Thanks,

Steve

--047d7b6d80b0b5f6e404e0a86893
Content-Type: application/octet-stream;
	name="0001-CIFS-Limit-allocation-of-crypto-mechanisms-to-dialec.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Limit-allocation-of-crypto-mechanisms-to-dialec.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hiphdsxc0

RnJvbSAwYWQ3YTJkZDU5YmI1YmM3MjBlNWEyZDdiNzcxNGU2MzdkMWM2MDY1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogV2VkLCAzIEp1bCAyMDEzIDIzOjUyOjExIC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gW0NJRlNd
IExpbWl0IGFsbG9jYXRpb24gb2YgY3J5cHRvIG1lY2hhbmlzbXMgdG8gZGlhbGVjdAogd2hpY2gg
cmVxdWlyZXMgaXQKClVwZGF0ZWQgcGF0Y2ggdG8gdHJ5IHRvIHByZXZlbnQgYWxsb2NhdGlvbiBv
ZiBjaWZzLCBzbWIyIG9yIHNtYjMgY3J5cHRvCnNlY21lY2ggc3RydWN0dXJlcyB1bmxlc3MgbmVl
ZGVkLiAgQ3VycmVudGx5IGNpZnMgYWxsb2NhdGVzIGFsbCBjcnlwdG8KbWVjaGFuaXNtcyB3aGVu
IHRoZSBmaXJzdCBzZXNzaW9uIGlzIGVzdGFibGlzaGVkICg0IGZ1bmN0aW9ucyBhbmQKNCBjb250
ZXh0cyksIHJhdGhlciB0aGFuIG9ubHkgYWxsb2NhdGluZyB0aGVzZSB3aGVuIG5lZWRlZCAoc21i
MyBuZWVkcwp0d28sIHRoZSByZXN0IG9mIHRoZSBkaWFsZWN0cyBvbmx5IG5lZWQgb25lKS4KClNp
Z25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPgotLS0KIGZzL2Np
ZnMvY2lmc2VuY3J5cHQuYyAgIHwgMTk1ICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQogZnMvY2lmcy9jaWZzcHJvdG8uaCAgICAgfCAgIDEgLQogZnMvY2lm
cy9jb25uZWN0LmMgICAgICAgfCAgIDYgLS0KIGZzL2NpZnMvc21iMnRyYW5zcG9ydC5jIHwgIDky
ICsrKysrKysrKysrKysrKysrKysrKystCiA0IGZpbGVzIGNoYW5nZWQsIDE3NiBpbnNlcnRpb25z
KCspLCAxMTggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZW5jcnlwdC5j
IGIvZnMvY2lmcy9jaWZzZW5jcnlwdC5jCmluZGV4IDNkOGJmOTQuLmE5NWVlOTEgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvY2lmc2VuY3J5cHQuYworKysgYi9mcy9jaWZzL2NpZnNlbmNyeXB0LmMKQEAg
LTEsNyArMSw3IEBACiAvKgogICogICBmcy9jaWZzL2NpZnNlbmNyeXB0LmMKICAqCi0gKiAgIENv
cHlyaWdodCAoQykgSW50ZXJuYXRpb25hbCBCdXNpbmVzcyBNYWNoaW5lcyAgQ29ycC4sIDIwMDUs
MjAwNgorICogICBDb3B5cmlnaHQgKEMpIEludGVybmF0aW9uYWwgQnVzaW5lc3MgTWFjaGluZXMg
IENvcnAuLCAyMDA1LDIwMTMKICAqICAgQXV0aG9yKHMpOiBTdGV2ZSBGcmVuY2ggKHNmcmVuY2hA
dXMuaWJtLmNvbSkKICAqCiAgKiAgIFRoaXMgbGlicmFyeSBpcyBmcmVlIHNvZnR3YXJlOyB5b3Ug
Y2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CkBAIC0zMSw2ICszMSwzNiBAQAogI2lu
Y2x1ZGUgPGxpbnV4L3JhbmRvbS5oPgogI2luY2x1ZGUgPGxpbnV4L2hpZ2htZW0uaD4KIAorc3Rh
dGljIGludAorY2lmc19jcnlwdG9fc2hhc2hfbWQ1X2FsbG9jYXRlKHN0cnVjdCBUQ1BfU2VydmVy
X0luZm8gKnNlcnZlcikKK3sKKwlpbnQgcmM7CisJdW5zaWduZWQgaW50IHNpemU7CisKKwlpZiAo
c2VydmVyLT5zZWNtZWNoLnNkZXNjbWQ1ICE9IE5VTEwpCisJCXJldHVybiAwOyAvKiBhbHJlYWR5
IGFsbG9jYXRlZCAqLworCisJc2VydmVyLT5zZWNtZWNoLm1kNSA9IGNyeXB0b19hbGxvY19zaGFz
aCgibWQ1IiwgMCwgMCk7CisJaWYgKElTX0VSUihzZXJ2ZXItPnNlY21lY2gubWQ1KSkgeworCQlj
aWZzX2RiZyhWRlMsICJjb3VsZCBub3QgYWxsb2NhdGUgY3J5cHRvIG1kNVxuIik7CisJCXJldHVy
biBQVFJfRVJSKHNlcnZlci0+c2VjbWVjaC5tZDUpOworCX0KKworCXNpemUgPSBzaXplb2Yoc3Ry
dWN0IHNoYXNoX2Rlc2MpICsKKwkJCWNyeXB0b19zaGFzaF9kZXNjc2l6ZShzZXJ2ZXItPnNlY21l
Y2gubWQ1KTsKKwlzZXJ2ZXItPnNlY21lY2guc2Rlc2NtZDUgPSBrbWFsbG9jKHNpemUsIEdGUF9L
RVJORUwpOworCWlmICghc2VydmVyLT5zZWNtZWNoLnNkZXNjbWQ1KSB7CisJCXJjID0gLUVOT01F
TTsKKwkJY3J5cHRvX2ZyZWVfc2hhc2goc2VydmVyLT5zZWNtZWNoLm1kNSk7CisJCXNlcnZlci0+
c2VjbWVjaC5tZDUgPSBOVUxMOworCQlyZXR1cm4gcmM7CisJfQorCXNlcnZlci0+c2VjbWVjaC5z
ZGVzY21kNS0+c2hhc2gudGZtID0gc2VydmVyLT5zZWNtZWNoLm1kNTsKKwlzZXJ2ZXItPnNlY21l
Y2guc2Rlc2NtZDUtPnNoYXNoLmZsYWdzID0gMHgwOworCisJcmV0dXJuIDA7Cit9CisKIC8qCiAg
KiBDYWxjdWxhdGUgYW5kIHJldHVybiB0aGUgQ0lGUyBzaWduYXR1cmUgYmFzZWQgb24gdGhlIG1h
YyBrZXkgYW5kIFNNQiBQRFUuCiAgKiBUaGUgMTYgYnl0ZSBzaWduYXR1cmUgbXVzdCBiZSBhbGxv
Y2F0ZWQgYnkgdGhlIGNhbGxlci4gTm90ZSB3ZSBvbmx5IHVzZSB0aGUKQEAgLTUwLDggKzgwLDEx
IEBAIHN0YXRpYyBpbnQgY2lmc19jYWxjX3NpZ25hdHVyZShzdHJ1Y3Qgc21iX3Jxc3QgKnJxc3Qs
CiAJCXJldHVybiAtRUlOVkFMOwogCiAJaWYgKCFzZXJ2ZXItPnNlY21lY2guc2Rlc2NtZDUpIHsK
LQkJY2lmc19kYmcoVkZTLCAiJXM6IENhbid0IGdlbmVyYXRlIHNpZ25hdHVyZVxuIiwgX19mdW5j
X18pOwotCQlyZXR1cm4gLTE7CisJCXJjID0gY2lmc19jcnlwdG9fc2hhc2hfbWQ1X2FsbG9jYXRl
KHNlcnZlcik7CisJCWlmIChyYykgeworCQkJY2lmc19kYmcoVkZTLCAiJXM6IENhbid0IGFsbG9j
IG1kNSBjcnlwdG9cbiIsIF9fZnVuY19fKTsKKwkJCXJldHVybiAtMTsKKwkJfQogCX0KIAogCXJj
ID0gY3J5cHRvX3NoYXNoX2luaXQoJnNlcnZlci0+c2VjbWVjaC5zZGVzY21kNS0+c2hhc2gpOwpA
QCAtNTU2LDYgKzU4OSwzMyBAQCBDYWxjTlRMTXYyX3Jlc3BvbnNlKGNvbnN0IHN0cnVjdCBjaWZz
X3NlcyAqc2VzLCBjaGFyICpudGxtdjJfaGFzaCkKIAlyZXR1cm4gcmM7CiB9CiAKK3N0YXRpYyBp
bnQgY3J5cHRvX2htYWNtZDVfYWxsb2Moc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQor
eworCXVuc2lnbmVkIGludCBzaXplOworCisJLyogY2hlY2sgaWYgYWxyZWFkeSBhbGxvY2F0ZWQg
Ki8KKwlpZiAoc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY21kNSkKKwkJcmV0dXJuIDA7CisKKwlz
ZXJ2ZXItPnNlY21lY2guaG1hY21kNSA9IGNyeXB0b19hbGxvY19zaGFzaCgiaG1hYyhtZDUpIiwg
MCwgMCk7CisJaWYgKElTX0VSUihzZXJ2ZXItPnNlY21lY2guaG1hY21kNSkpIHsKKwkJY2lmc19k
YmcoVkZTLCAiY291bGQgbm90IGFsbG9jYXRlIGNyeXB0byBobWFjbWQ1XG4iKTsKKwkJcmV0dXJu
IFBUUl9FUlIoc2VydmVyLT5zZWNtZWNoLmhtYWNtZDUpOworCX0KKworCXNpemUgPSBzaXplb2Yo
c3RydWN0IHNoYXNoX2Rlc2MpICsKKwkJCWNyeXB0b19zaGFzaF9kZXNjc2l6ZShzZXJ2ZXItPnNl
Y21lY2guaG1hY21kNSk7CisJc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY21kNSA9IGttYWxsb2Mo
c2l6ZSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFzZXJ2ZXItPnNlY21lY2guc2Rlc2NobWFjbWQ1KSB7
CisJCWNyeXB0b19mcmVlX3NoYXNoKHNlcnZlci0+c2VjbWVjaC5obWFjbWQ1KTsKKwkJc2VydmVy
LT5zZWNtZWNoLmhtYWNtZDUgPSBOVUxMOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CisJc2VydmVy
LT5zZWNtZWNoLnNkZXNjaG1hY21kNS0+c2hhc2gudGZtID0gc2VydmVyLT5zZWNtZWNoLmhtYWNt
ZDU7CisJc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY21kNS0+c2hhc2guZmxhZ3MgPSAweDA7CisK
KwlyZXR1cm4gMDsKK30KIAogaW50CiBzZXR1cF9udGxtdjJfcnNwKHN0cnVjdCBjaWZzX3NlcyAq
c2VzLCBjb25zdCBzdHJ1Y3QgbmxzX3RhYmxlICpubHNfY3ApCkBAIC02MDYsNiArNjY2LDEyIEBA
IHNldHVwX250bG12Ml9yc3Aoc3RydWN0IGNpZnNfc2VzICpzZXMsIGNvbnN0IHN0cnVjdCBubHNf
dGFibGUgKm5sc19jcCkKIAogCW1lbWNweShzZXMtPmF1dGhfa2V5LnJlc3BvbnNlICsgYmFzZWxl
biwgdGlibG9iLCB0aWxlbik7CiAKKwlyYyA9IGNyeXB0b19obWFjbWQ1X2FsbG9jKHNlcy0+c2Vy
dmVyKTsKKwlpZiAocmMpIHsKKwkJY2lmc19kYmcoVkZTLCAiY291bGQgbm90IGNyeXB0byBhbGxv
YyBtZDUgcmMgJWRcbiIsIHJjKTsKKwkJZ290byBzZXR1cF9udGxtdjJfcnNwX3JldDsKKwl9CisK
IAkvKiBjYWxjdWxhdGUgbnRsbXYyX2hhc2ggKi8KIAlyYyA9IGNhbGNfbnRsbXYyX2hhc2goc2Vz
LCBudGxtdjJfaGFzaCwgbmxzX2NwKTsKIAlpZiAocmMpIHsKQEAgLTcwNSwxMjMgKzc3MSwzMiBA
QCBjYWxjX3NlY2tleShzdHJ1Y3QgY2lmc19zZXMgKnNlcykKIHZvaWQKIGNpZnNfY3J5cHRvX3No
YXNoX3JlbGVhc2Uoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogewotCWlmIChzZXJ2
ZXItPnNlY21lY2guY21hY2FlcykKKwlpZiAoc2VydmVyLT5zZWNtZWNoLmNtYWNhZXMpIHsKIAkJ
Y3J5cHRvX2ZyZWVfc2hhc2goc2VydmVyLT5zZWNtZWNoLmNtYWNhZXMpOworCQlzZXJ2ZXItPnNl
Y21lY2guY21hY2FlcyA9IE5VTEw7CisJfQogCi0JaWYgKHNlcnZlci0+c2VjbWVjaC5obWFjc2hh
MjU2KQorCWlmIChzZXJ2ZXItPnNlY21lY2guaG1hY3NoYTI1NikgewogCQljcnlwdG9fZnJlZV9z
aGFzaChzZXJ2ZXItPnNlY21lY2guaG1hY3NoYTI1Nik7CisJCXNlcnZlci0+c2VjbWVjaC5obWFj
c2hhMjU2ID0gTlVMTDsKKwl9CiAKLQlpZiAoc2VydmVyLT5zZWNtZWNoLm1kNSkKKwlpZiAoc2Vy
dmVyLT5zZWNtZWNoLm1kNSkgewogCQljcnlwdG9fZnJlZV9zaGFzaChzZXJ2ZXItPnNlY21lY2gu
bWQ1KTsKKwkJc2VydmVyLT5zZWNtZWNoLm1kNSA9IE5VTEw7CisJfQogCi0JaWYgKHNlcnZlci0+
c2VjbWVjaC5obWFjbWQ1KQorCWlmIChzZXJ2ZXItPnNlY21lY2guaG1hY21kNSkgewogCQljcnlw
dG9fZnJlZV9zaGFzaChzZXJ2ZXItPnNlY21lY2guaG1hY21kNSk7CisJCXNlcnZlci0+c2VjbWVj
aC5obWFjbWQ1ID0gTlVMTDsKKwl9CiAKIAlrZnJlZShzZXJ2ZXItPnNlY21lY2guc2Rlc2NjbWFj
YWVzKTsKLQorCXNlcnZlci0+c2VjbWVjaC5zZGVzY2NtYWNhZXMgPSBOVUxMOwogCWtmcmVlKHNl
cnZlci0+c2VjbWVjaC5zZGVzY2htYWNzaGEyNTYpOwotCisJc2VydmVyLT5zZWNtZWNoLnNkZXNj
aG1hY3NoYTI1NiA9IE5VTEw7CiAJa2ZyZWUoc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY21kNSk7
Ci0KKwlzZXJ2ZXItPnNlY21lY2guc2Rlc2NobWFjbWQ1ID0gTlVMTDsKIAlrZnJlZShzZXJ2ZXIt
PnNlY21lY2guc2Rlc2NtZDUpOwotfQotCi1pbnQKLWNpZnNfY3J5cHRvX3NoYXNoX2FsbG9jYXRl
KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikKLXsKLQlpbnQgcmM7Ci0JdW5zaWduZWQg
aW50IHNpemU7Ci0KLQlzZXJ2ZXItPnNlY21lY2guaG1hY21kNSA9IGNyeXB0b19hbGxvY19zaGFz
aCgiaG1hYyhtZDUpIiwgMCwgMCk7Ci0JaWYgKElTX0VSUihzZXJ2ZXItPnNlY21lY2guaG1hY21k
NSkpIHsKLQkJY2lmc19kYmcoVkZTLCAiY291bGQgbm90IGFsbG9jYXRlIGNyeXB0byBobWFjbWQ1
XG4iKTsKLQkJcmV0dXJuIFBUUl9FUlIoc2VydmVyLT5zZWNtZWNoLmhtYWNtZDUpOwotCX0KLQot
CXNlcnZlci0+c2VjbWVjaC5tZDUgPSBjcnlwdG9fYWxsb2Nfc2hhc2goIm1kNSIsIDAsIDApOwot
CWlmIChJU19FUlIoc2VydmVyLT5zZWNtZWNoLm1kNSkpIHsKLQkJY2lmc19kYmcoVkZTLCAiY291
bGQgbm90IGFsbG9jYXRlIGNyeXB0byBtZDVcbiIpOwotCQlyYyA9IFBUUl9FUlIoc2VydmVyLT5z
ZWNtZWNoLm1kNSk7Ci0JCWdvdG8gY3J5cHRvX2FsbG9jYXRlX21kNV9mYWlsOwotCX0KLQotCXNl
cnZlci0+c2VjbWVjaC5obWFjc2hhMjU2ID0gY3J5cHRvX2FsbG9jX3NoYXNoKCJobWFjKHNoYTI1
NikiLCAwLCAwKTsKLQlpZiAoSVNfRVJSKHNlcnZlci0+c2VjbWVjaC5obWFjc2hhMjU2KSkgewot
CQljaWZzX2RiZyhWRlMsICJjb3VsZCBub3QgYWxsb2NhdGUgY3J5cHRvIGhtYWNzaGEyNTZcbiIp
OwotCQlyYyA9IFBUUl9FUlIoc2VydmVyLT5zZWNtZWNoLmhtYWNzaGEyNTYpOwotCQlnb3RvIGNy
eXB0b19hbGxvY2F0ZV9obWFjc2hhMjU2X2ZhaWw7Ci0JfQotCi0Jc2VydmVyLT5zZWNtZWNoLmNt
YWNhZXMgPSBjcnlwdG9fYWxsb2Nfc2hhc2goImNtYWMoYWVzKSIsIDAsIDApOwotCWlmIChJU19F
UlIoc2VydmVyLT5zZWNtZWNoLmNtYWNhZXMpKSB7Ci0JCWNpZnNfZGJnKFZGUywgImNvdWxkIG5v
dCBhbGxvY2F0ZSBjcnlwdG8gY21hYy1hZXMiKTsKLQkJcmMgPSBQVFJfRVJSKHNlcnZlci0+c2Vj
bWVjaC5jbWFjYWVzKTsKLQkJZ290byBjcnlwdG9fYWxsb2NhdGVfY21hY2Flc19mYWlsOwotCX0K
LQotCXNpemUgPSBzaXplb2Yoc3RydWN0IHNoYXNoX2Rlc2MpICsKLQkJCWNyeXB0b19zaGFzaF9k
ZXNjc2l6ZShzZXJ2ZXItPnNlY21lY2guaG1hY21kNSk7Ci0Jc2VydmVyLT5zZWNtZWNoLnNkZXNj
aG1hY21kNSA9IGttYWxsb2Moc2l6ZSwgR0ZQX0tFUk5FTCk7Ci0JaWYgKCFzZXJ2ZXItPnNlY21l
Y2guc2Rlc2NobWFjbWQ1KSB7Ci0JCXJjID0gLUVOT01FTTsKLQkJZ290byBjcnlwdG9fYWxsb2Nh
dGVfaG1hY21kNV9zZGVzY19mYWlsOwotCX0KLQlzZXJ2ZXItPnNlY21lY2guc2Rlc2NobWFjbWQ1
LT5zaGFzaC50Zm0gPSBzZXJ2ZXItPnNlY21lY2guaG1hY21kNTsKLQlzZXJ2ZXItPnNlY21lY2gu
c2Rlc2NobWFjbWQ1LT5zaGFzaC5mbGFncyA9IDB4MDsKLQotCXNpemUgPSBzaXplb2Yoc3RydWN0
IHNoYXNoX2Rlc2MpICsKLQkJCWNyeXB0b19zaGFzaF9kZXNjc2l6ZShzZXJ2ZXItPnNlY21lY2gu
bWQ1KTsKLQlzZXJ2ZXItPnNlY21lY2guc2Rlc2NtZDUgPSBrbWFsbG9jKHNpemUsIEdGUF9LRVJO
RUwpOwotCWlmICghc2VydmVyLT5zZWNtZWNoLnNkZXNjbWQ1KSB7Ci0JCXJjID0gLUVOT01FTTsK
LQkJZ290byBjcnlwdG9fYWxsb2NhdGVfbWQ1X3NkZXNjX2ZhaWw7Ci0JfQotCXNlcnZlci0+c2Vj
bWVjaC5zZGVzY21kNS0+c2hhc2gudGZtID0gc2VydmVyLT5zZWNtZWNoLm1kNTsKLQlzZXJ2ZXIt
PnNlY21lY2guc2Rlc2NtZDUtPnNoYXNoLmZsYWdzID0gMHgwOwotCi0Jc2l6ZSA9IHNpemVvZihz
dHJ1Y3Qgc2hhc2hfZGVzYykgKwotCQkJY3J5cHRvX3NoYXNoX2Rlc2NzaXplKHNlcnZlci0+c2Vj
bWVjaC5obWFjc2hhMjU2KTsKLQlzZXJ2ZXItPnNlY21lY2guc2Rlc2NobWFjc2hhMjU2ID0ga21h
bGxvYyhzaXplLCBHRlBfS0VSTkVMKTsKLQlpZiAoIXNlcnZlci0+c2VjbWVjaC5zZGVzY2htYWNz
aGEyNTYpIHsKLQkJcmMgPSAtRU5PTUVNOwotCQlnb3RvIGNyeXB0b19hbGxvY2F0ZV9obWFjc2hh
MjU2X3NkZXNjX2ZhaWw7Ci0JfQotCXNlcnZlci0+c2VjbWVjaC5zZGVzY2htYWNzaGEyNTYtPnNo
YXNoLnRmbSA9IHNlcnZlci0+c2VjbWVjaC5obWFjc2hhMjU2OwotCXNlcnZlci0+c2VjbWVjaC5z
ZGVzY2htYWNzaGEyNTYtPnNoYXNoLmZsYWdzID0gMHgwOwotCi0Jc2l6ZSA9IHNpemVvZihzdHJ1
Y3Qgc2hhc2hfZGVzYykgKwotCQkJY3J5cHRvX3NoYXNoX2Rlc2NzaXplKHNlcnZlci0+c2VjbWVj
aC5jbWFjYWVzKTsKLQlzZXJ2ZXItPnNlY21lY2guc2Rlc2NjbWFjYWVzID0ga21hbGxvYyhzaXpl
LCBHRlBfS0VSTkVMKTsKLQlpZiAoIXNlcnZlci0+c2VjbWVjaC5zZGVzY2NtYWNhZXMpIHsKLQkJ
Y2lmc19kYmcoVkZTLCAiJXM6IENhbid0IGFsbG9jIGNtYWNhZXNcbiIsIF9fZnVuY19fKTsKLQkJ
cmMgPSAtRU5PTUVNOwotCQlnb3RvIGNyeXB0b19hbGxvY2F0ZV9jbWFjYWVzX3NkZXNjX2ZhaWw7
Ci0JfQotCXNlcnZlci0+c2VjbWVjaC5zZGVzY2NtYWNhZXMtPnNoYXNoLnRmbSA9IHNlcnZlci0+
c2VjbWVjaC5jbWFjYWVzOwotCXNlcnZlci0+c2VjbWVjaC5zZGVzY2NtYWNhZXMtPnNoYXNoLmZs
YWdzID0gMHgwOwotCi0JcmV0dXJuIDA7Ci0KLWNyeXB0b19hbGxvY2F0ZV9jbWFjYWVzX3NkZXNj
X2ZhaWw6Ci0Ja2ZyZWUoc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY3NoYTI1Nik7Ci0KLWNyeXB0
b19hbGxvY2F0ZV9obWFjc2hhMjU2X3NkZXNjX2ZhaWw6Ci0Ja2ZyZWUoc2VydmVyLT5zZWNtZWNo
LnNkZXNjbWQ1KTsKLQotY3J5cHRvX2FsbG9jYXRlX21kNV9zZGVzY19mYWlsOgotCWtmcmVlKHNl
cnZlci0+c2VjbWVjaC5zZGVzY2htYWNtZDUpOwotCi1jcnlwdG9fYWxsb2NhdGVfaG1hY21kNV9z
ZGVzY19mYWlsOgotCWNyeXB0b19mcmVlX3NoYXNoKHNlcnZlci0+c2VjbWVjaC5jbWFjYWVzKTsK
LQotY3J5cHRvX2FsbG9jYXRlX2NtYWNhZXNfZmFpbDoKLQljcnlwdG9fZnJlZV9zaGFzaChzZXJ2
ZXItPnNlY21lY2guaG1hY3NoYTI1Nik7Ci0KLWNyeXB0b19hbGxvY2F0ZV9obWFjc2hhMjU2X2Zh
aWw6Ci0JY3J5cHRvX2ZyZWVfc2hhc2goc2VydmVyLT5zZWNtZWNoLm1kNSk7Ci0KLWNyeXB0b19h
bGxvY2F0ZV9tZDVfZmFpbDoKLQljcnlwdG9fZnJlZV9zaGFzaChzZXJ2ZXItPnNlY21lY2guaG1h
Y21kNSk7Ci0KLQlyZXR1cm4gcmM7CisJc2VydmVyLT5zZWNtZWNoLnNkZXNjbWQ1ID0gTlVMTDsK
IH0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3Byb3RvLmggYi9mcy9jaWZzL2NpZnNwcm90by5o
CmluZGV4IGM4ZmYwMTguLmY3ZTU4NGQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3Byb3RvLmgK
KysrIGIvZnMvY2lmcy9jaWZzcHJvdG8uaApAQCAtNDMzLDcgKzQzMyw2IEBAIGV4dGVybiBpbnQg
U01CTlRlbmNyeXB0KHVuc2lnbmVkIGNoYXIgKiwgdW5zaWduZWQgY2hhciAqLCB1bnNpZ25lZCBj
aGFyICosCiAJCQljb25zdCBzdHJ1Y3QgbmxzX3RhYmxlICopOwogZXh0ZXJuIGludCBzZXR1cF9u
dGxtX3Jlc3BvbnNlKHN0cnVjdCBjaWZzX3NlcyAqLCBjb25zdCBzdHJ1Y3QgbmxzX3RhYmxlICop
OwogZXh0ZXJuIGludCBzZXR1cF9udGxtdjJfcnNwKHN0cnVjdCBjaWZzX3NlcyAqLCBjb25zdCBz
dHJ1Y3QgbmxzX3RhYmxlICopOwotZXh0ZXJuIGludCBjaWZzX2NyeXB0b19zaGFzaF9hbGxvY2F0
ZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICopOwogZXh0ZXJuIHZvaWQgY2lmc19jcnlwdG9fc2hh
c2hfcmVsZWFzZShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICopOwogZXh0ZXJuIGludCBjYWxjX3Nl
Y2tleShzdHJ1Y3QgY2lmc19zZXMgKik7CiBleHRlcm4gdm9pZCBnZW5lcmF0ZV9zbWIzc2lnbmlu
Z2tleShzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICopOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jb25u
ZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBhZmNiOGExLi5mYTY4ODEzIDEwMDY0NAot
LS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3QuYwpAQCAtMjEwOCwx
MiArMjEwOCw2IEBAIGNpZnNfZ2V0X3RjcF9zZXNzaW9uKHN0cnVjdCBzbWJfdm9sICp2b2x1bWVf
aW5mbykKIAkJZ290byBvdXRfZXJyOwogCX0KIAotCXJjID0gY2lmc19jcnlwdG9fc2hhc2hfYWxs
b2NhdGUodGNwX3Nlcyk7Ci0JaWYgKHJjKSB7Ci0JCWNpZnNfZGJnKFZGUywgImNvdWxkIG5vdCBz
ZXR1cCBoYXNoIHN0cnVjdHVyZXMgcmMgJWRcbiIsIHJjKTsKLQkJZ290byBvdXRfZXJyOwotCX0K
LQogCXRjcF9zZXMtPm9wcyA9IHZvbHVtZV9pbmZvLT5vcHM7CiAJdGNwX3Nlcy0+dmFscyA9IHZv
bHVtZV9pbmZvLT52YWxzOwogCWNpZnNfc2V0X25ldF9ucyh0Y3Bfc2VzLCBnZXRfbmV0KGN1cnJl
bnQtPm5zcHJveHktPm5ldF9ucykpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIydHJhbnNwb3J0
LmMgYi9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYwppbmRleCAwOWI0ZmJhLi5hZWY4ZmY0IDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJ0cmFuc3BvcnQuYworKysgYi9mcy9jaWZzL3NtYjJ0cmFuc3Bv
cnQuYwpAQCAtMzksNiArMzksNzcgQEAKICNpbmNsdWRlICJzbWIyc3RhdHVzLmgiCiAjaW5jbHVk
ZSAic21iMmdsb2IuaCIKIAorc3RhdGljIGludAorc21iMl9jcnlwdG9fc2hhc2hfYWxsb2NhdGUo
c3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQoreworCXVuc2lnbmVkIGludCBzaXplOwor
CisJaWYgKHNlcnZlci0+c2VjbWVjaC5zZGVzY2htYWNzaGEyNTYgIT0gTlVMTCkKKwkJcmV0dXJu
IDA7IC8qIGFscmVhZHkgYWxsb2NhdGVkICovCisKKwlzZXJ2ZXItPnNlY21lY2guaG1hY3NoYTI1
NiA9IGNyeXB0b19hbGxvY19zaGFzaCgiaG1hYyhzaGEyNTYpIiwgMCwgMCk7CisJaWYgKElTX0VS
UihzZXJ2ZXItPnNlY21lY2guaG1hY3NoYTI1NikpIHsKKwkJY2lmc19kYmcoVkZTLCAiY291bGQg
bm90IGFsbG9jYXRlIGNyeXB0byBobWFjc2hhMjU2XG4iKTsKKwkJcmV0dXJuIFBUUl9FUlIoc2Vy
dmVyLT5zZWNtZWNoLmhtYWNzaGEyNTYpOworCX0KKworCXNpemUgPSBzaXplb2Yoc3RydWN0IHNo
YXNoX2Rlc2MpICsKKwkJCWNyeXB0b19zaGFzaF9kZXNjc2l6ZShzZXJ2ZXItPnNlY21lY2guaG1h
Y3NoYTI1Nik7CisJc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY3NoYTI1NiA9IGttYWxsb2Moc2l6
ZSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFzZXJ2ZXItPnNlY21lY2guc2Rlc2NobWFjc2hhMjU2KSB7
CisJCWNyeXB0b19mcmVlX3NoYXNoKHNlcnZlci0+c2VjbWVjaC5obWFjc2hhMjU2KTsKKwkJc2Vy
dmVyLT5zZWNtZWNoLmhtYWNzaGEyNTYgPSBOVUxMOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CisJ
c2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY3NoYTI1Ni0+c2hhc2gudGZtID0gc2VydmVyLT5zZWNt
ZWNoLmhtYWNzaGEyNTY7CisJc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY3NoYTI1Ni0+c2hhc2gu
ZmxhZ3MgPSAweDA7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludAorc21iM19jcnlwdG9f
c2hhc2hfYWxsb2NhdGUoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQoreworCXVuc2ln
bmVkIGludCBzaXplOworCWludCByYzsKKworCWlmIChzZXJ2ZXItPnNlY21lY2guc2Rlc2NjbWFj
YWVzICE9IE5VTEwpCisJCXJldHVybiAwOyAgLyogYWxyZWFkeSBhbGxvY2F0ZWQgKi8KKworCXJj
ID0gc21iMl9jcnlwdG9fc2hhc2hfYWxsb2NhdGUoc2VydmVyKTsKKwlpZiAocmMpCisJCXJldHVy
biByYzsKKworCXNlcnZlci0+c2VjbWVjaC5jbWFjYWVzID0gY3J5cHRvX2FsbG9jX3NoYXNoKCJj
bWFjKGFlcykiLCAwLCAwKTsKKwlpZiAoSVNfRVJSKHNlcnZlci0+c2VjbWVjaC5jbWFjYWVzKSkg
eworCQljaWZzX2RiZyhWRlMsICJjb3VsZCBub3QgYWxsb2NhdGUgY3J5cHRvIGNtYWMtYWVzIik7
CisJCWtmcmVlKHNlcnZlci0+c2VjbWVjaC5zZGVzY2htYWNzaGEyNTYpOworCQlzZXJ2ZXItPnNl
Y21lY2guc2Rlc2NobWFjc2hhMjU2ID0gTlVMTDsKKwkJY3J5cHRvX2ZyZWVfc2hhc2goc2VydmVy
LT5zZWNtZWNoLmhtYWNzaGEyNTYpOworCQlzZXJ2ZXItPnNlY21lY2guaG1hY3NoYTI1NiA9IE5V
TEw7CisJCXJldHVybiBQVFJfRVJSKHNlcnZlci0+c2VjbWVjaC5jbWFjYWVzKTsKKwl9CisKKwlz
aXplID0gc2l6ZW9mKHN0cnVjdCBzaGFzaF9kZXNjKSArCisJCQljcnlwdG9fc2hhc2hfZGVzY3Np
emUoc2VydmVyLT5zZWNtZWNoLmNtYWNhZXMpOworCXNlcnZlci0+c2VjbWVjaC5zZGVzY2NtYWNh
ZXMgPSBrbWFsbG9jKHNpemUsIEdGUF9LRVJORUwpOworCWlmICghc2VydmVyLT5zZWNtZWNoLnNk
ZXNjY21hY2FlcykgeworCQljaWZzX2RiZyhWRlMsICIlczogQ2FuJ3QgYWxsb2MgY21hY2Flc1xu
IiwgX19mdW5jX18pOworCQlrZnJlZShzZXJ2ZXItPnNlY21lY2guc2Rlc2NobWFjc2hhMjU2KTsK
KwkJc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY3NoYTI1NiA9IE5VTEw7CisJCWNyeXB0b19mcmVl
X3NoYXNoKHNlcnZlci0+c2VjbWVjaC5obWFjc2hhMjU2KTsKKwkJY3J5cHRvX2ZyZWVfc2hhc2go
c2VydmVyLT5zZWNtZWNoLmNtYWNhZXMpOworCQlzZXJ2ZXItPnNlY21lY2guaG1hY3NoYTI1NiA9
IE5VTEw7CisJCXNlcnZlci0+c2VjbWVjaC5jbWFjYWVzID0gTlVMTDsKKwkJcmV0dXJuIC1FTk9N
RU07CisJfQorCXNlcnZlci0+c2VjbWVjaC5zZGVzY2NtYWNhZXMtPnNoYXNoLnRmbSA9IHNlcnZl
ci0+c2VjbWVjaC5jbWFjYWVzOworCXNlcnZlci0+c2VjbWVjaC5zZGVzY2NtYWNhZXMtPnNoYXNo
LmZsYWdzID0gMHgwOworCisJcmV0dXJuIDA7Cit9CisKKwogaW50CiBzbWIyX2NhbGNfc2lnbmF0
dXJlKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVy
KQogewpAQCAtNTIsNiArMTIzLDEyIEBAIHNtYjJfY2FsY19zaWduYXR1cmUoc3RydWN0IHNtYl9y
cXN0ICpycXN0LCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIpCiAJbWVtc2V0KHNtYjJf
c2lnbmF0dXJlLCAweDAsIFNNQjJfSE1BQ1NIQTI1Nl9TSVpFKTsKIAltZW1zZXQoc21iMl9wZHUt
PlNpZ25hdHVyZSwgMHgwLCBTTUIyX1NJR05BVFVSRV9TSVpFKTsKIAorCXJjID0gc21iMl9jcnlw
dG9fc2hhc2hfYWxsb2NhdGUoc2VydmVyKTsKKwlpZiAocmMpIHsKKwkJY2lmc19kYmcoVkZTLCAi
JXM6IHNoYWgyNTYgYWxsb2MgZmFpbGVkXG4iLCBfX2Z1bmNfXyk7CisJCXJldHVybiByYzsKKwl9
CisKIAlyYyA9IGNyeXB0b19zaGFzaF9zZXRrZXkoc2VydmVyLT5zZWNtZWNoLmhtYWNzaGEyNTYs
CiAJCXNlcnZlci0+c2Vzc2lvbl9rZXkucmVzcG9uc2UsIFNNQjJfTlRMTVYyX1NFU1NLRVlfU0la
RSk7CiAJaWYgKHJjKSB7CkBAIC02MSw3ICsxMzgsNyBAQCBzbWIyX2NhbGNfc2lnbmF0dXJlKHN0
cnVjdCBzbWJfcnFzdCAqcnFzdCwgc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCiAJ
cmMgPSBjcnlwdG9fc2hhc2hfaW5pdCgmc2VydmVyLT5zZWNtZWNoLnNkZXNjaG1hY3NoYTI1Ni0+
c2hhc2gpOwogCWlmIChyYykgewotCQljaWZzX2RiZyhWRlMsICIlczogQ291bGQgbm90IGluaXQg
bWQ1XG4iLCBfX2Z1bmNfXyk7CisJCWNpZnNfZGJnKFZGUywgIiVzOiBDb3VsZCBub3QgaW5pdCBz
aGEyNTYiLCBfX2Z1bmNfXyk7CiAJCXJldHVybiByYzsKIAl9CiAKQEAgLTEyOSw2ICsyMDYsMTQg
QEAgZ2VuZXJhdGVfc21iM3NpZ25pbmdrZXkoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVy
KQogCW1lbXNldChwcmZoYXNoLCAweDAsIFNNQjJfSE1BQ1NIQTI1Nl9TSVpFKTsKIAltZW1zZXQo
c2VydmVyLT5zbWIzc2lnbmluZ2tleSwgMHgwLCBTTUIzX1NJR05LRVlfU0laRSk7CiAKKwkvKiBT
TUIzIGVzc2VudGlhbGx5IHJlcXVpcmVzIHNpZ25pbmcgc28gbm8gaGFybSBtYWtpbmcgc3VyZSBu
ZWVkZWQKKwkgICBzZWNobWVjaCAoaG1hY3NoYTI1NiBhbmQgYWVzKSBhcmUgYWxsb2NhdGVkIG5v
dyAqLworCXJjID0gc21iM19jcnlwdG9fc2hhc2hfYWxsb2NhdGUoc2VydmVyKTsKKwlpZiAocmMp
IHsKKwkJY2lmc19kYmcoVkZTLCAiJXM6IGNyeXB0byBhbGxvYyBmYWlsZWRcbiIsIF9fZnVuY19f
KTsKKwkJZ290byBzbWIzc2lnbmtleV9yZXQ7CisJfQorCiAJcmMgPSBjcnlwdG9fc2hhc2hfc2V0
a2V5KHNlcnZlci0+c2VjbWVjaC5obWFjc2hhMjU2LAogCQlzZXJ2ZXItPnNlc3Npb25fa2V5LnJl
c3BvbnNlLCBTTUIyX05UTE1WMl9TRVNTS0VZX1NJWkUpOwogCWlmIChyYykgewpAQCAtMjEwLDYg
KzI5NSwxMSBAQCBzbWIzX2NhbGNfc2lnbmF0dXJlKHN0cnVjdCBzbWJfcnFzdCAqcnFzdCwgc3Ry
dWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKQogCQlyZXR1cm4gcmM7CiAJfQogCisJLyoKKwkg
KiB3ZSBhbHJlYWR5IGFsbG9jYXRlIHNkZXNjY21hY2FlcyB3aGVuIHdlIGluaXQgc21iMyBzaWdu
aW5nIGtleSwKKwkgKiBzbyB1bmxpa2Ugc21iMiBjYXNlIHdlIGRvIG5vdCBoYXZlIHRvIGNoZWNr
IGhlcmUgaWYgc2VjbWVjaCBhcmUKKwkgKiBpbml0aWFsaXplZAorCSAqLwogCXJjID0gY3J5cHRv
X3NoYXNoX2luaXQoJnNlcnZlci0+c2VjbWVjaC5zZGVzY2NtYWNhZXMtPnNoYXNoKTsKIAlpZiAo
cmMpIHsKIAkJY2lmc19kYmcoVkZTLCAiJXM6IENvdWxkIG5vdCBpbml0IGNtYWMgYWVzXG4iLCBf
X2Z1bmNfXyk7Ci0tIAoxLjcuMTEuNwoK
--047d7b6d80b0b5f6e404e0a86893--
