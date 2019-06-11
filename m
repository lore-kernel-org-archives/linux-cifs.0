Return-Path: <SRS0=/HTR=UK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B65C4321A
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 18:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D805D2173C
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560277058;
	bh=FxnF+wQyVdil82o5E43BjgW8tBRCdoFPNiymJQAFTMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bqrp7HUaib2xtXS641/zp5y0E1VO5Gx6l6u3GOjTV8lqObXVbp6iEJPhhthPYlqjn
	 cnLbCIjK6m1QnesuBC8tHko5MXawTgL78H4hUD9nBCyfIj4YIbn2Nnm2CK1WrLekcJ
	 HXoNCsO0ig5HaIEWvDwv1cfc5LjfBdzeuH12EoH8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406994AbfFKSRi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jun 2019 14:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405802AbfFKSRi (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 Jun 2019 14:17:38 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5114E2173B;
        Tue, 11 Jun 2019 18:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560277057;
        bh=FxnF+wQyVdil82o5E43BjgW8tBRCdoFPNiymJQAFTMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhH3vm77R+20PcKpYYWCp6rQC44fgIWt0r3L7R8qHGrlyB5/L4MzMup2Hw8z2dEvS
         oHl5MZ2fx4GhESiZSzB+lC+hsEOZh6fTzq8N8OgAVzJRvW71Rh4Wf3jcy71JbLohBq
         /HQ+XRQlmpnhZbg3+2mKRL7roktN+XvsjubwgAVQ=
Date:   Tue, 11 Jun 2019 11:17:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: Re: [PATCH v3 7/7] fs: cifs: switch to RC4 library interface
Message-ID: <20190611181735.GE66728@gmail.com>
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
 <20190611134750.2974-8-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611134750.2974-8-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jun 11, 2019 at 03:47:50PM +0200, Ard Biesheuvel wrote:
> The CIFS code uses the sync skcipher API to invoke the ecb(arc4) skcipher,
> of which only a single generic C code implementation exists. This means
> that going through all the trouble of using scatterlists etc buys us
> very little, and we're better off just invoking the arc4 library directly.
> 
> Cc: linux-cifs@vger.kernel.org
> Cc: Steve French <sfrench@samba.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  fs/cifs/Kconfig       |  2 +-
>  fs/cifs/cifsencrypt.c | 53 ++++++--------------
>  2 files changed, 16 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index aae2b8b2adf5..523e9ea78a28 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -10,7 +10,7 @@ config CIFS
>  	select CRYPTO_SHA512
>  	select CRYPTO_CMAC
>  	select CRYPTO_HMAC
> -	select CRYPTO_ARC4
> +	select CRYPTO_LIB_ARC4
>  	select CRYPTO_AEAD2
>  	select CRYPTO_CCM
>  	select CRYPTO_ECB

Since the "arc4" module is no longer needed, the

	MODULE_SOFTDEP("pre: arc4");

in fs/cifs/cifsfs.c should be removed too.

(Note that it doesn't need a soft dependency on libarc4 instead, since the cifs
module will link directly to it.)

> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index d2a05e46d6f5..3b7b5e83493d 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -33,7 +33,8 @@
>  #include <linux/ctype.h>
>  #include <linux/random.h>
>  #include <linux/highmem.h>
> -#include <crypto/skcipher.h>
> +#include <linux/fips.h>
> +#include <crypto/arc4.h>
>  #include <crypto/aead.h>
>  
>  int __cifs_calc_signature(struct smb_rqst *rqst,
> @@ -772,11 +773,12 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>  int
>  calc_seckey(struct cifs_ses *ses)
>  {
> -	int rc;
> -	struct crypto_skcipher *tfm_arc4;
> -	struct scatterlist sgin, sgout;
> -	struct skcipher_request *req;
> +	struct arc4_ctx *ctx_arc4;
>  	unsigned char *sec_key;
> +	int rc = 0;
> +
> +	if (fips_enabled)
> +		return -ENODEV;
>  
>  	sec_key = kmalloc(CIFS_SESS_KEY_SIZE, GFP_KERNEL);
>  	if (sec_key == NULL)

sec_key should be moved back to the stack now, basically reverting this commit:

	commit 5f4b55699aaff1028468e3f53853d781cdafedd6
	Author: Sachin Prabhu <sprabhu@redhat.com>
	Date:   Mon Oct 17 16:40:22 2016 -0400

	    CIFS: Fix BUG() in calc_seckey()

It was only moved to the heap because it had to go in a scatterlist.

> +	arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
> +	arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
> +		   CIFS_CPHTXT_SIZE);
>  
>  	/* make secondary_key/nonce as session key */
>  	memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
>  	/* and make len as that of session key only */
>  	ses->auth_key.len = CIFS_SESS_KEY_SIZE;
>  
> -out_free_cipher:
> -	crypto_free_skcipher(tfm_arc4);
>  out:
> +	kfree(ctx_arc4);

Should be kzfree().

- Eric
