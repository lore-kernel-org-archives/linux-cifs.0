From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC 07/10] fscrypt: move to generic async completion
Date: Wed, 10 May 2017 21:04:42 -0700
Message-ID: <20170511040442.GB2936@zzz>
References: <1494075602-5061-1-git-send-email-gilad@benyossef.com>
 <1494075602-5061-8-git-send-email-gilad@benyossef.com>
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
In-Reply-To: <1494075602-5061-8-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Gilad,

On Sat, May 06, 2017 at 03:59:56PM +0300, Gilad Ben-Yossef wrote:
>  int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
>  			   u64 lblk_num, struct page *src_page,
>  			   struct page *dest_page, unsigned int len,
> @@ -150,7 +135,7 @@ int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
>  		u8 padding[FS_XTS_TWEAK_SIZE - sizeof(__le64)];
>  	} xts_tweak;
>  	struct skcipher_request *req = NULL;
> -	DECLARE_FS_COMPLETION_RESULT(ecr);
> +	DECLARE_CRYPTO_WAIT(ecr);
>  	struct scatterlist dst, src;
>  	struct fscrypt_info *ci = inode->i_crypt_info;
>  	struct crypto_skcipher *tfm = ci->ci_ctfm;
> @@ -168,7 +153,7 @@ int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
[...]

This patch looks good --- thanks for doing this!  I suggest also renaming 'ecr'
to 'wait' in the places being updated to use crypto_wait, since the name is
obsolete (and was already; it originally stood for "ext4 completion result").

- Eric
