From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v6 07/19] crypto: move pub key to generic async completion
Date: Mon, 21 Aug 2017 17:04:53 +0300
Message-ID: <1503324309-13673-8-git-send-email-gilad__49739.9861146279$1503324819$gmane$org@benyossef.com>
References: <1503324309-13673-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
        David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>,
        Gary Hook <gary.hook-5C7GfCeVMHo@public.gmane.org>,
        Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
        Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
        Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
        Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-crypto@v
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503324309-13673-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

public_key_verify_signature() is starting an async crypto op and
waiting for it to complete. Move it over to generic code doing
the same.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 crypto/asymmetric_keys/public_key.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 3cd6e12..d916235 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -57,29 +57,13 @@ static void public_key_destroy(void *payload0, void *payload3)
 	public_key_signature_free(payload3);
 }
 
-struct public_key_completion {
-	struct completion completion;
-	int err;
-};
-
-static void public_key_verify_done(struct crypto_async_request *req, int err)
-{
-	struct public_key_completion *compl = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	compl->err = err;
-	complete(&compl->completion);
-}
-
 /*
  * Verify a signature using a public key.
  */
 int public_key_verify_signature(const struct public_key *pkey,
 				const struct public_key_signature *sig)
 {
-	struct public_key_completion compl;
+	struct crypto_wait cwait;
 	struct crypto_akcipher *tfm;
 	struct akcipher_request *req;
 	struct scatterlist sig_sg, digest_sg;
@@ -131,20 +115,16 @@ int public_key_verify_signature(const struct public_key *pkey,
 	sg_init_one(&digest_sg, output, outlen);
 	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
 				   outlen);
-	init_completion(&compl.completion);
+	crypto_init_wait(&cwait);
 	akcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				      CRYPTO_TFM_REQ_MAY_SLEEP,
-				      public_key_verify_done, &compl);
+				      crypto_req_done, &cwait);
 
 	/* Perform the verification calculation.  This doesn't actually do the
 	 * verification, but rather calculates the hash expected by the
 	 * signature and returns that to us.
 	 */
-	ret = crypto_akcipher_verify(req);
-	if ((ret == -EINPROGRESS) || (ret == -EBUSY)) {
-		wait_for_completion(&compl.completion);
-		ret = compl.err;
-	}
+	ret = crypto_wait_req(crypto_akcipher_verify(req), &cwait);
 	if (ret < 0)
 		goto out_free_output;
 
-- 
2.1.4
