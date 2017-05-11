From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC 01/10] crypto: factor async completion for general use
Date: Wed, 10 May 2017 20:55:27 -0700
Message-ID: <20170511035527.GA2936@zzz>
References: <1494075602-5061-1-git-send-email-gilad@benyossef.com>
 <1494075602-5061-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, Steve French <sfrench@samba.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-raid@vger.kernel.org,
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494075602-5061-2-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Gilad,

On Sat, May 06, 2017 at 03:59:50PM +0300, Gilad Ben-Yossef wrote:
> Invoking a possibly async. crypto op and waiting for completion
> while correctly handling backlog processing is a common task
> in the crypto API implementation and outside users of it.
> 
> This patch re-factors one of the in crypto API implementation in
> preparation for using it across the board instead of hand
> rolled versions.

Thanks for doing this!  It annoyed me too that there wasn't a helper function
for this.  Just a few comments below:

> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 3556d8e..bf4acaf 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -480,33 +480,6 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
>  }
>  EXPORT_SYMBOL_GPL(af_alg_cmsg_send);
>  
> -int af_alg_wait_for_completion(int err, struct af_alg_completion *completion)
> -{
> -	switch (err) {
> -	case -EINPROGRESS:
> -	case -EBUSY:
> -		wait_for_completion(&completion->completion);
> -		reinit_completion(&completion->completion);
> -		err = completion->err;
> -		break;
> -	};
> -
> -	return err;
> -}
> -EXPORT_SYMBOL_GPL(af_alg_wait_for_completion);
> -
> -void af_alg_complete(struct crypto_async_request *req, int err)
> -{
> -	struct af_alg_completion *completion = req->data;
> -
> -	if (err == -EINPROGRESS)
> -		return;
> -
> -	completion->err = err;
> -	complete(&completion->completion);
> -}
> -EXPORT_SYMBOL_GPL(af_alg_complete);
> -

I think it would be cleaner to switch af_alg and algif_* over to the new
interface in its own patch, rather than in the same patch that introduces the
new interface.

> @@ -88,8 +88,8 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
>  		if ((msg->msg_flags & MSG_MORE))
>  			hash_free_result(sk, ctx);
>  
> -		err = af_alg_wait_for_completion(crypto_ahash_init(&ctx->req),
> -						&ctx->completion);
> +		err = crypto_wait_req(crypto_ahash_init(&ctx->req),
> +						&ctx->wait);
>  		if (err)
>  			goto unlock;
>  	}

In general can you try to keep the argument lists indented sanely?  (This
applies throughout the patch series.)  e.g. here I'd have expected:

		err = crypto_wait_req(crypto_ahash_init(&ctx->req),
				      &ctx->wait);

>  
> diff --git a/crypto/api.c b/crypto/api.c
> index 941cd4c..1c6e9cd 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -24,6 +24,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> +#include <linux/completion.h>
>  #include "internal.h"
>  
>  LIST_HEAD(crypto_alg_list);
> @@ -595,5 +596,32 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
>  }
>  EXPORT_SYMBOL_GPL(crypto_has_alg);
>  
> +int crypto_wait_req(int err, struct crypto_wait *wait)
> +{
> +	switch (err) {
> +	case -EINPROGRESS:
> +	case -EBUSY:
> +		wait_for_completion(&wait->completion);
> +		reinit_completion(&wait->completion);
> +		err = wait->err;
> +		break;
> +	};
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(crypto_wait_req);

crypto_wait_req() maybe should be inlined, since it doesn't do much (note that
reinit_completion is actually just a variable assignment), and the common case
is that 'err' will be 0, so there will be nothing to wait for.

Also drop the unnecessary semicolon at the end of the switch block.

With regards to the wait being uninterruptible, I agree that this should be the
default behavior, because I think users waiting for specific crypto requests are
generally not prepared to handle the wait actually being interrupted.  After
interruption the crypto operation will still proceed in the background, and it
will use buffers which the caller has in many cases already freed.  However, I'd
suggest taking a close look at anything that was actually doing an interruptible
wait before, to see whether it was a bug or intentional (or "doesn't matter").

And yes there could always be a crypto_wait_req_interruptible() introduced if
some users need it.

>  
>  #define CRYPTO_MINALIGN_ATTR __attribute__ ((__aligned__(CRYPTO_MINALIGN)))
>  
> +/*
> + * Macro for declaring a crypto op async wait object on stack
> + */
> +#define DECLARE_CRYPTO_WAIT(_wait) \
> +	struct crypto_wait _wait = { \
> +		COMPLETION_INITIALIZER_ONSTACK((_wait).completion), 0 }
> +

Move this definition down below, so it's next to crypto_wait?

>  
>  /*
>   * Algorithm registration interface.
>   */
> @@ -1604,5 +1631,6 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
>  						    src, slen, dst, dlen);
>  }
>  
> +

Don't add unrelated blank lines.

- Eric
