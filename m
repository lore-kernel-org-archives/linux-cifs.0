Return-Path: <SRS0=EHaD=UR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB95C31E51
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jun 2019 07:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54B3820823
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jun 2019 07:17:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HYgPUpZ1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfFRHRD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jun 2019 03:17:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40063 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfFRHRC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jun 2019 03:17:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so2524508pgj.7;
        Tue, 18 Jun 2019 00:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0kwXvJg+PO6AzQUXfTLRwkAMgZw/vA4UDM+J2LllZI=;
        b=HYgPUpZ1Mb7N9pbKmwBALoXQGlpzloF38LM2HDcn8P2wrD0Zt8tLBu8ve1MlpLbw/p
         Wh+99NAPlLkwGY3ACckaVvnAdF5sIbzCfF4MIRbbVd35JiSEah5cB9Y2APvVZrC0Xn7g
         2+TiRkVJlbY3eTCC8LI9NJOX1qMkMdedbLM6F4XXAeQ0Gllc68zRVnuVbDCWfeMx7zBC
         8txhON/RcYIVTjihwe167ATJrDwkm8QozVsQ5Lft/MzZMAHfma1acmcqUK7Tp3h3afoK
         E+qcyKrj7SFiMU8cnFAZYeSl6eG2ycCqFK648A2nMHoLBdoJWn/uxGJxdJWxb4zKwxHg
         Nqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I0kwXvJg+PO6AzQUXfTLRwkAMgZw/vA4UDM+J2LllZI=;
        b=PwQvJ7uzYi4I4U4nWJvrVrtylOUkLVVAtxXARi75K8HPdFsq0HY3iulzF6/19doGzM
         VAckgt7evjJq99+pdv3iVeaFufxE6x+LwaThYDUwX0xtlJRVu7vnYPhgfnCEzEiCKa2B
         gEM4/BzSy7wZMV3cDLtODJ99vpGv0bwkGqGiNIcfrMZrTBjBoZrGjXZBvInr1qWxojBM
         lE7OMRuTluzNFBDbJED2wfTnK9eAl7fYJDXCeSehiYpbeAX4UjdKcgbkgJ6hjbDnriVt
         gdCoSQaWGeTAKB8jGQxTvbc9SSEbWBw2kkfKcpOXnQJjbmQR/q/VjGvFp28UWgP7lZFm
         /ehw==
X-Gm-Message-State: APjAAAX19/FSVc+iqnBZd/Ndlx0nP9xnbc9LhyopFLK8/ZbilimjeF2O
        8YlfC5GKpCAfdV/iQZKPuuWfOHDgRcVtFCwcftF1TQ==
X-Google-Smtp-Source: APXvYqwO3a1yEBfFcIt94SpZKef1+JrLo99gOGBdCO/YazcbqF6aHtHarWF7yPmU0bYrmFxDi/2m0k7herFBAu/X5Zc=
X-Received: by 2002:a62:2ec4:: with SMTP id u187mr116365152pfu.84.1560836299676;
 Mon, 17 Jun 2019 22:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190612161959.30478-1-ard.biesheuvel@linaro.org> <20190612161959.30478-8-ard.biesheuvel@linaro.org>
In-Reply-To: <20190612161959.30478-8-ard.biesheuvel@linaro.org>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 18 Jun 2019 00:38:08 -0500
Message-ID: <CAH2r5mu21Cr9Rt+P4c9s4JPXJB_nXiPd7GUbN1Dz=DdRAiQ82w@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] fs: cifs: switch to RC4 library interface
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Steve French <stfrench@microsoft.com>

On Wed, Jun 12, 2019 at 1:06 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> The CIFS code uses the sync skcipher API to invoke the ecb(arc4) skcipher,
> of which only a single generic C code implementation exists. This means
> that going through all the trouble of using scatterlists etc buys us
> very little, and we're better off just invoking the arc4 library directly.
>
> This also reverts commit 5f4b55699aaf ("CIFS: Fix BUG() in calc_seckey()"),
> since it is no longer necessary to allocate sec_key on the heap.
>
> Cc: linux-cifs@vger.kernel.org
> Cc: Steve French <sfrench@samba.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  fs/cifs/Kconfig       |  2 +-
>  fs/cifs/cifsencrypt.c | 62 +++++---------------
>  fs/cifs/cifsfs.c      |  1 -
>  3 files changed, 17 insertions(+), 48 deletions(-)
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index aae2b8b2adf5..523e9ea78a28 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -10,7 +10,7 @@ config CIFS
>         select CRYPTO_SHA512
>         select CRYPTO_CMAC
>         select CRYPTO_HMAC
> -       select CRYPTO_ARC4
> +       select CRYPTO_LIB_ARC4
>         select CRYPTO_AEAD2
>         select CRYPTO_CCM
>         select CRYPTO_ECB
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index d2a05e46d6f5..97b7497c13ef 100644
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
> @@ -772,63 +773,32 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>  int
>  calc_seckey(struct cifs_ses *ses)
>  {
> -       int rc;
> -       struct crypto_skcipher *tfm_arc4;
> -       struct scatterlist sgin, sgout;
> -       struct skcipher_request *req;
> -       unsigned char *sec_key;
> +       unsigned char sec_key[CIFS_SESS_KEY_SIZE]; /* a nonce */
> +       struct arc4_ctx *ctx_arc4;
>
> -       sec_key = kmalloc(CIFS_SESS_KEY_SIZE, GFP_KERNEL);
> -       if (sec_key == NULL)
> -               return -ENOMEM;
> +       if (fips_enabled)
> +               return -ENODEV;
>
>         get_random_bytes(sec_key, CIFS_SESS_KEY_SIZE);
>
> -       tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
> -       if (IS_ERR(tfm_arc4)) {
> -               rc = PTR_ERR(tfm_arc4);
> -               cifs_dbg(VFS, "could not allocate crypto API arc4\n");
> -               goto out;
> -       }
> -
> -       rc = crypto_skcipher_setkey(tfm_arc4, ses->auth_key.response,
> -                                       CIFS_SESS_KEY_SIZE);
> -       if (rc) {
> -               cifs_dbg(VFS, "%s: Could not set response as a key\n",
> -                        __func__);
> -               goto out_free_cipher;
> -       }
> -
> -       req = skcipher_request_alloc(tfm_arc4, GFP_KERNEL);
> -       if (!req) {
> -               rc = -ENOMEM;
> -               cifs_dbg(VFS, "could not allocate crypto API arc4 request\n");
> -               goto out_free_cipher;
> +       ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
> +       if (!ctx_arc4) {
> +               cifs_dbg(VFS, "could not allocate arc4 context\n");
> +               return -ENOMEM;
>         }
>
> -       sg_init_one(&sgin, sec_key, CIFS_SESS_KEY_SIZE);
> -       sg_init_one(&sgout, ses->ntlmssp->ciphertext, CIFS_CPHTXT_SIZE);
> -
> -       skcipher_request_set_callback(req, 0, NULL, NULL);
> -       skcipher_request_set_crypt(req, &sgin, &sgout, CIFS_CPHTXT_SIZE, NULL);
> -
> -       rc = crypto_skcipher_encrypt(req);
> -       skcipher_request_free(req);
> -       if (rc) {
> -               cifs_dbg(VFS, "could not encrypt session key rc: %d\n", rc);
> -               goto out_free_cipher;
> -       }
> +       arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
> +       arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
> +                  CIFS_CPHTXT_SIZE);
>
>         /* make secondary_key/nonce as session key */
>         memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
>         /* and make len as that of session key only */
>         ses->auth_key.len = CIFS_SESS_KEY_SIZE;
>
> -out_free_cipher:
> -       crypto_free_skcipher(tfm_arc4);
> -out:
> -       kfree(sec_key);
> -       return rc;
> +       memzero_explicit(sec_key, CIFS_SESS_KEY_SIZE);
> +       kzfree(ctx_arc4);
> +       return 0;
>  }
>
>  void
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f5fcd6360056..e55afaf9e5a3 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1590,7 +1590,6 @@ MODULE_DESCRIPTION
>         ("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
>         "also older servers complying with the SNIA CIFS Specification)");
>  MODULE_VERSION(CIFS_VERSION);
> -MODULE_SOFTDEP("pre: arc4");
>  MODULE_SOFTDEP("pre: des");
>  MODULE_SOFTDEP("pre: ecb");
>  MODULE_SOFTDEP("pre: hmac");
> --
> 2.20.1
>


-- 
Thanks,

Steve
