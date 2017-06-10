From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 01/11] crypto: introduce crypto wait for async op
Date: Sat, 10 Jun 2017 11:43:37 +0800
Message-ID: <20170610034336.GB14206@gondor.apana.org.au>
References: <1496046180-21962-1-git-send-email-gilad@benyossef.com>
 <1496046180-21962-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
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
        Eric Biggers <ebiggers3@gmail.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-cif
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496046180-21962-2-git-send-email-gilad@benyossef.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, May 29, 2017 at 11:22:48AM +0300, Gilad Ben-Yossef wrote:
>
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

This assumes that the request is used with backlog.  For non-backlog
requests this would result in a memory leak as EBUSY in that case is
a fatal error.

So this API can't be used without backlog.

We could introduce a flag to indicate whether we want backlog or not,
or maybe we should change our API so that in the non-backlog case we
return something other than EBUSY.

Opinions?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
