From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v5 05/19] crypto: introduce crypto wait for async op
Date: Tue, 15 Aug 2017 03:23:03 +0100
Message-ID: <20170815032303.000042b2@huawei.com>
References: <1502724094-23305-1-git-send-email-gilad@benyossef.com>
 <1502724094-23305-6-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org,
 Gary Hook <gary.hook@amd.com>, David Howells <dhowells@redhat.com>,
 dm-devel@redhat.com, keyrings@vger.kernel.org,
 linux-ima-devel@lists.sourceforge.net, Alasdair Kergon <agk@redhat.com>,
 Boris Brezillon <boris.brezillon@free-electrons.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
 Mimi Zohar <zohar@linux.vnet.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Eric Biggers <ebiggers3@gmail.com>,
 linux-cifs@vger.kernel.org, linux-ima-user@lists.sourceforge.net,
 Arnaud Ebalard <arno@natisbad.org>, linux-raid@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-mediatek@lists.infradead.org,
 James Morris <james.l.morris@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-arm-kernel@lists.infradead.o
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1502724094-23305-6-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 14 Aug 2017 18:21:15 +0300
Gilad Ben-Yossef <gilad@benyossef.com> wrote:

> Invoking a possibly async. crypto op and waiting for completion
> while correctly handling backlog processing is a common task
> in the crypto API implementation and outside users of it.
> 
> This patch adds a generic implementation for doing so in
> preparation for using it across the board instead of hand
> rolled versions.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> CC: Eric Biggers <ebiggers3@gmail.com>

One really trivial point inline I happened to notice.

> ---
>  crypto/api.c           | 13 +++++++++++++
>  include/linux/crypto.h | 41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 941cd4c..2a2479d 100644
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
> @@ -595,5 +596,17 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
>  }
>  EXPORT_SYMBOL_GPL(crypto_has_alg);
>  
> +void crypto_req_done(struct crypto_async_request *req, int err)
> +{
> +	struct crypto_wait *wait = req->data;
> +
> +	if (err == -EINPROGRESS)
> +		return;
> +
> +	wait->err = err;
> +	complete(&wait->completion);
> +}
> +EXPORT_SYMBOL_GPL(crypto_req_done);
> +
>  MODULE_DESCRIPTION("Cryptographic core API");
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 84da997..bb00186 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/uaccess.h>
> +#include <linux/completion.h>
>  
>  /*
>   * Autoloaded crypto modules should only use a prefixed name to avoid allowing
> @@ -468,6 +469,45 @@ struct crypto_alg {
>  } CRYPTO_MINALIGN_ATTR;
>  
>  /*
> + * A helper struct for waiting for completion of async crypto ops
> + */
> +struct crypto_wait {
> +	struct completion completion;
> +	int err;
> +};
> +
> +/*
> + * Macro for declaring a crypto op async wait object on stack
> + */
> +#define DECLARE_CRYPTO_WAIT(_wait) \
> +	struct crypto_wait _wait = { \
> +		COMPLETION_INITIALIZER_ONSTACK((_wait).completion), 0 }
> +
> +/*
> + * Async ops completion helper functioons
> + */
> +void crypto_req_done(struct crypto_async_request *req, int err);
> +
> +static inline int crypto_wait_req(int err, struct crypto_wait *wait)
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
> +
> +static inline void crypto_init_wait(struct crypto_wait *wait)
> +{
> +	init_completion(&wait->completion);
> +}
> +
> +/*
>   * Algorithm registration interface.
>   */
>  int crypto_register_alg(struct crypto_alg *alg);
> @@ -1604,5 +1644,6 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
>  						    src, slen, dst, dlen);
>  }
>  
> +

Trivial observation.  Shouldn't have this bonus blank line inserted here.

>  #endif	/* _LINUX_CRYPTO_H */
>  
