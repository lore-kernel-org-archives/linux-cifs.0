From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v7 19/19] crypto: adapt api sample to use async. op wait
Date: Thu, 24 Aug 2017 17:19:06 +0300
Message-ID: <1503584350-7831-20-git-send-email-gilad__30368.6607200236$1503584680$gmane$org@benyossef.com>
References: <1503584350-7831-1-git-send-email-gilad@benyossef.com>
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
In-Reply-To: <1503584350-7831-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The code sample is waiting for an async. crypto op completion.
Adapt sample to use the new generic infrastructure to do the same.

This also fixes a possible data coruption bug created by the
use of wait_for_completion_interruptible() without dealing
correctly with an interrupt aborting the wait prior to the
async op finishing.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---
 Documentation/crypto/api-samples.rst | 52 +++++++-----------------------------
 1 file changed, 10 insertions(+), 42 deletions(-)

diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
index 2531948..006827e 100644
--- a/Documentation/crypto/api-samples.rst
+++ b/Documentation/crypto/api-samples.rst
@@ -7,59 +7,27 @@ Code Example For Symmetric Key Cipher Operation
 ::
 
 
-    struct tcrypt_result {
-        struct completion completion;
-        int err;
-    };
-
     /* tie all data structures together */
     struct skcipher_def {
         struct scatterlist sg;
         struct crypto_skcipher *tfm;
         struct skcipher_request *req;
-        struct tcrypt_result result;
+        struct crypto_wait wait;
     };
 
-    /* Callback function */
-    static void test_skcipher_cb(struct crypto_async_request *req, int error)
-    {
-        struct tcrypt_result *result = req->data;
-
-        if (error == -EINPROGRESS)
-            return;
-        result->err = error;
-        complete(&result->completion);
-        pr_info("Encryption finished successfully\n");
-    }
-
     /* Perform cipher operation */
     static unsigned int test_skcipher_encdec(struct skcipher_def *sk,
                          int enc)
     {
-        int rc = 0;
+        int rc;
 
         if (enc)
-            rc = crypto_skcipher_encrypt(sk->req);
+            rc = crypto_wait_req(crypto_skcipher_encrypt(sk->req), &sk->wait);
         else
-            rc = crypto_skcipher_decrypt(sk->req);
-
-        switch (rc) {
-        case 0:
-            break;
-        case -EINPROGRESS:
-        case -EBUSY:
-            rc = wait_for_completion_interruptible(
-                &sk->result.completion);
-            if (!rc && !sk->result.err) {
-                reinit_completion(&sk->result.completion);
-                break;
-            }
-        default:
-            pr_info("skcipher encrypt returned with %d result %d\n",
-                rc, sk->result.err);
-            break;
-        }
-        init_completion(&sk->result.completion);
+            rc = crypto_wait_req(crypto_skcipher_decrypt(sk->req), &sk->wait);
+
+	if (rc)
+		pr_info("skcipher encrypt returned with result %d\n", rc);
 
         return rc;
     }
@@ -89,8 +57,8 @@ Code Example For Symmetric Key Cipher Operation
         }
 
         skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-                          test_skcipher_cb,
-                          &sk.result);
+                          crypto_req_done,
+                          &sk.wait);
 
         /* AES 256 with random key */
         get_random_bytes(&key, 32);
@@ -122,7 +90,7 @@ Code Example For Symmetric Key Cipher Operation
         /* We encrypt one block */
         sg_init_one(&sk.sg, scratchpad, 16);
         skcipher_request_set_crypt(req, &sk.sg, &sk.sg, 16, ivdata);
-        init_completion(&sk.result.completion);
+        crypto_init_wait(&sk.wait);
 
         /* encrypt data */
         ret = test_skcipher_encdec(&sk, 1);
-- 
2.1.4
