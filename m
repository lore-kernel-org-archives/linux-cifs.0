From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs: Fix smbencrypt() to stop pointing a scatterlist
 at the stack
Date: Tue, 13 Dec 2016 08:07:44 -0500
Message-ID: <1481634464.2630.17.camel@redhat.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
         <308cdb484648f98f6f0ad9feefd8acb2fe003aaf.1481575835.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        linux-cifs@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, sfrench@samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <308cdb484648f98f6f0ad9feefd8acb2fe003aaf.1481575835.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 2016-12-12 at 12:54 -0800, Andy Lutomirski wrote:
> smbencrypt() points a scatterlist to the stack, which is breaks if
> CONFIG_VMAP_STACK=y.
> 
> Fix it by switching to crypto_cipher_encrypt_one().  The new code
> should be considerably faster as an added benefit.
> 
> This code is nearly identical to some code that Eric Biggers
> suggested.
> 
> Cc: stable@vger.kernel.org # 4.9 only
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
> 
> Compile-tested only.
> 
> fs/cifs/smbencrypt.c | 40 ++++++++--------------------------------
>  1 file changed, 8 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 699b7868108f..c12bffefa3c9 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -23,7 +23,7 @@
>     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  */
>  
> -#include <crypto/skcipher.h>
> +#include <linux/crypto.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/fs.h>
> @@ -69,46 +69,22 @@ str_to_key(unsigned char *str, unsigned char *key)
>  static int
>  smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
>  {
> -	int rc;
>  	unsigned char key2[8];
> -	struct crypto_skcipher *tfm_des;
> -	struct scatterlist sgin, sgout;
> -	struct skcipher_request *req;
> +	struct crypto_cipher *tfm_des;
>  
>  	str_to_key(key, key2);
>  
> -	tfm_des = crypto_alloc_skcipher("ecb(des)", 0, CRYPTO_ALG_ASYNC);
> +	tfm_des = crypto_alloc_cipher("des", 0, 0);
>  	if (IS_ERR(tfm_des)) {
> -		rc = PTR_ERR(tfm_des);
> -		cifs_dbg(VFS, "could not allocate des crypto API\n");
> -		goto smbhash_err;
> -	}
> -
> -	req = skcipher_request_alloc(tfm_des, GFP_KERNEL);
> -	if (!req) {
> -		rc = -ENOMEM;
>  		cifs_dbg(VFS, "could not allocate des crypto API\n");
> -		goto smbhash_free_skcipher;
> +		return PTR_ERR(tfm_des);
>  	}
>  
> -	crypto_skcipher_setkey(tfm_des, key2, 8);
> -
> -	sg_init_one(&sgin, in, 8);
> -	sg_init_one(&sgout, out, 8);
> +	crypto_cipher_setkey(tfm_des, key2, 8);
> +	crypto_cipher_encrypt_one(tfm_des, out, in);
> +	crypto_free_cipher(tfm_des);
>  
> -	skcipher_request_set_callback(req, 0, NULL, NULL);
> -	skcipher_request_set_crypt(req, &sgin, &sgout, 8, NULL);
> -
> -	rc = crypto_skcipher_encrypt(req);
> -	if (rc)
> -		cifs_dbg(VFS, "could not encrypt crypt key rc: %d\n", rc);
> -
> -	skcipher_request_free(req);
> -
> -smbhash_free_skcipher:
> -	crypto_free_skcipher(tfm_des);
> -smbhash_err:
> -	return rc;
> +	return 0;
>  }
>  
>  static int

Acked-by: Jeff Layton <jlayton@redhat.com>
