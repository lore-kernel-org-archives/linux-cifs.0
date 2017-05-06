From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [RFC 07/10] fscrypt: move to generic async completion
Date: Sat,  6 May 2017 15:59:56 +0300
Message-ID: <1494075602-5061-8-git-send-email-gilad@benyossef.com>
References: <1494075602-5061-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-ima-user@lists.sourceforge.net,
	Gilad Ben-Yossef <gilad.benyossef@arm.com>,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Shaohua Li <shli@kernel.org>,
	Steve French <sfrench@samba.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494075602-5061-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

fscrypt starts several async. crypto ops and waiting for them to
complete. Move it over to generic code doing the same.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 fs/crypto/crypto.c          | 28 ++++------------------------
 fs/crypto/fname.c           | 36 ++++++------------------------------
 fs/crypto/fscrypt_private.h | 10 ----------
 fs/crypto/keyinfo.c         | 21 +++------------------
 4 files changed, 13 insertions(+), 82 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 6d6eca3..94cac7d 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -125,21 +125,6 @@ struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *inode, gfp_t gfp_flags)
 }
 EXPORT_SYMBOL(fscrypt_get_ctx);
 
-/**
- * page_crypt_complete() - completion callback for page crypto
- * @req: The asynchronous cipher request context
- * @res: The result of the cipher operation
- */
-static void page_crypt_complete(struct crypto_async_request *req, int res)
-{
-	struct fscrypt_completion_result *ecr = req->data;
-
-	if (res == -EINPROGRESS)
-		return;
-	ecr->res = res;
-	complete(&ecr->completion);
-}
-
 int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
 			   u64 lblk_num, struct page *src_page,
 			   struct page *dest_page, unsigned int len,
@@ -150,7 +135,7 @@ int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
 		u8 padding[FS_XTS_TWEAK_SIZE - sizeof(__le64)];
 	} xts_tweak;
 	struct skcipher_request *req = NULL;
-	DECLARE_FS_COMPLETION_RESULT(ecr);
+	DECLARE_CRYPTO_WAIT(ecr);
 	struct scatterlist dst, src;
 	struct fscrypt_info *ci = inode->i_crypt_info;
 	struct crypto_skcipher *tfm = ci->ci_ctfm;
@@ -168,7 +153,7 @@ int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
 
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		page_crypt_complete, &ecr);
+		crypto_req_done, &ecr);
 
 	BUILD_BUG_ON(sizeof(xts_tweak) != FS_XTS_TWEAK_SIZE);
 	xts_tweak.index = cpu_to_le64(lblk_num);
@@ -180,14 +165,9 @@ int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
 	sg_set_page(&src, src_page, len, offs);
 	skcipher_request_set_crypt(req, &src, &dst, len, &xts_tweak);
 	if (rw == FS_DECRYPT)
-		res = crypto_skcipher_decrypt(req);
+		res = crypto_wait_req(crypto_skcipher_decrypt(req), &ecr);
 	else
-		res = crypto_skcipher_encrypt(req);
-	if (res == -EINPROGRESS || res == -EBUSY) {
-		BUG_ON(req->base.data != &ecr);
-		wait_for_completion(&ecr.completion);
-		res = ecr.res;
-	}
+		res = crypto_wait_req(crypto_skcipher_encrypt(req), &ecr);
 	skcipher_request_free(req);
 	if (res) {
 		printk_ratelimited(KERN_ERR
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 37b4989..8b4caf3 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -15,21 +15,6 @@
 #include "fscrypt_private.h"
 
 /**
- * fname_crypt_complete() - completion callback for filename crypto
- * @req: The asynchronous cipher request context
- * @res: The result of the cipher operation
- */
-static void fname_crypt_complete(struct crypto_async_request *req, int res)
-{
-	struct fscrypt_completion_result *ecr = req->data;
-
-	if (res == -EINPROGRESS)
-		return;
-	ecr->res = res;
-	complete(&ecr->completion);
-}
-
-/**
  * fname_encrypt() - encrypt a filename
  *
  * The caller must have allocated sufficient memory for the @oname string.
@@ -40,7 +25,7 @@ static int fname_encrypt(struct inode *inode,
 			const struct qstr *iname, struct fscrypt_str *oname)
 {
 	struct skcipher_request *req = NULL;
-	DECLARE_FS_COMPLETION_RESULT(ecr);
+	DECLARE_CRYPTO_WAIT(ecr);
 	struct fscrypt_info *ci = inode->i_crypt_info;
 	struct crypto_skcipher *tfm = ci->ci_ctfm;
 	int res = 0;
@@ -76,17 +61,12 @@ static int fname_encrypt(struct inode *inode,
 	}
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			fname_crypt_complete, &ecr);
+			crypto_req_done, &ecr);
 	sg_init_one(&sg, oname->name, cryptlen);
 	skcipher_request_set_crypt(req, &sg, &sg, cryptlen, iv);
 
 	/* Do the encryption */
-	res = crypto_skcipher_encrypt(req);
-	if (res == -EINPROGRESS || res == -EBUSY) {
-		/* Request is being completed asynchronously; wait for it */
-		wait_for_completion(&ecr.completion);
-		res = ecr.res;
-	}
+	res = crypto_wait_req(crypto_skcipher_encrypt(req), &ecr);
 	skcipher_request_free(req);
 	if (res < 0) {
 		printk_ratelimited(KERN_ERR
@@ -110,7 +90,7 @@ static int fname_decrypt(struct inode *inode,
 				struct fscrypt_str *oname)
 {
 	struct skcipher_request *req = NULL;
-	DECLARE_FS_COMPLETION_RESULT(ecr);
+	DECLARE_CRYPTO_WAIT(ecr);
 	struct scatterlist src_sg, dst_sg;
 	struct fscrypt_info *ci = inode->i_crypt_info;
 	struct crypto_skcipher *tfm = ci->ci_ctfm;
@@ -131,7 +111,7 @@ static int fname_decrypt(struct inode *inode,
 	}
 	skcipher_request_set_callback(req,
 		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		fname_crypt_complete, &ecr);
+		crypto_req_done, &ecr);
 
 	/* Initialize IV */
 	memset(iv, 0, FS_CRYPTO_BLOCK_SIZE);
@@ -140,11 +120,7 @@ static int fname_decrypt(struct inode *inode,
 	sg_init_one(&src_sg, iname->name, iname->len);
 	sg_init_one(&dst_sg, oname->name, oname->len);
 	skcipher_request_set_crypt(req, &src_sg, &dst_sg, iname->len, iv);
-	res = crypto_skcipher_decrypt(req);
-	if (res == -EINPROGRESS || res == -EBUSY) {
-		wait_for_completion(&ecr.completion);
-		res = ecr.res;
-	}
+	res = crypto_wait_req(crypto_skcipher_decrypt(req), &ecr);
 	skcipher_request_free(req);
 	if (res < 0) {
 		printk_ratelimited(KERN_ERR
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index e39696e..158dadf 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -78,16 +78,6 @@ typedef enum {
 #define FS_CTX_REQUIRES_FREE_ENCRYPT_FL		0x00000001
 #define FS_CTX_HAS_BOUNCE_BUFFER_FL		0x00000002
 
-struct fscrypt_completion_result {
-	struct completion completion;
-	int res;
-};
-
-#define DECLARE_FS_COMPLETION_RESULT(ecr) \
-	struct fscrypt_completion_result ecr = { \
-		COMPLETION_INITIALIZER_ONSTACK((ecr).completion), 0 }
-
-
 /* crypto.c */
 extern int fscrypt_initialize(unsigned int cop_flags);
 extern struct workqueue_struct *fscrypt_read_workqueue;
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 8cdfddc..0ae0426 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -12,17 +12,6 @@
 #include <linux/scatterlist.h>
 #include "fscrypt_private.h"
 
-static void derive_crypt_complete(struct crypto_async_request *req, int rc)
-{
-	struct fscrypt_completion_result *ecr = req->data;
-
-	if (rc == -EINPROGRESS)
-		return;
-
-	ecr->res = rc;
-	complete(&ecr->completion);
-}
-
 /**
  * derive_key_aes() - Derive a key using AES-128-ECB
  * @deriving_key: Encryption key used for derivation.
@@ -37,7 +26,7 @@ static int derive_key_aes(u8 deriving_key[FS_AES_128_ECB_KEY_SIZE],
 {
 	int res = 0;
 	struct skcipher_request *req = NULL;
-	DECLARE_FS_COMPLETION_RESULT(ecr);
+	DECLARE_CRYPTO_WAIT(ecr);
 	struct scatterlist src_sg, dst_sg;
 	struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
 
@@ -54,7 +43,7 @@ static int derive_key_aes(u8 deriving_key[FS_AES_128_ECB_KEY_SIZE],
 	}
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			derive_crypt_complete, &ecr);
+			crypto_req_done, &ecr);
 	res = crypto_skcipher_setkey(tfm, deriving_key,
 					FS_AES_128_ECB_KEY_SIZE);
 	if (res < 0)
@@ -64,11 +53,7 @@ static int derive_key_aes(u8 deriving_key[FS_AES_128_ECB_KEY_SIZE],
 	sg_init_one(&dst_sg, derived_key, FS_AES_256_XTS_KEY_SIZE);
 	skcipher_request_set_crypt(req, &src_sg, &dst_sg,
 					FS_AES_256_XTS_KEY_SIZE, NULL);
-	res = crypto_skcipher_encrypt(req);
-	if (res == -EINPROGRESS || res == -EBUSY) {
-		wait_for_completion(&ecr.completion);
-		res = ecr.res;
-	}
+	res = crypto_wait_req(crypto_skcipher_encrypt(req), &ecr);
 out:
 	skcipher_request_free(req);
 	crypto_free_skcipher(tfm);
-- 
2.1.4
