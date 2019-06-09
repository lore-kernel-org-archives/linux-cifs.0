Return-Path: <SRS0=1kIp=UI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B74FC28EBD
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jun 2019 22:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D03BA206C3
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jun 2019 22:03:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TRin+e+z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfFIWDi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jun 2019 18:03:38 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35721 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFIWDh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jun 2019 18:03:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so3947787pgl.2;
        Sun, 09 Jun 2019 15:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UW4lx/dXozllODMsrDEnjT74BinFnpST4DJVQDFkvYU=;
        b=TRin+e+zQUyhMtUY67tCJfkIvgP5DRha5bS0kcYniNTBozvbNFUVBZzSGriRpOJebb
         3szU4FaqAHwXYJSuLff17lU0YdQcRhg3xYAlz03uOXG9QPdiXUQCLItYOb+kZwHSPwej
         yEUxI6he+E1Bb0EMaoQB0cNYI/h7ZOdwIjr1IQkQzH6C7xZIQQhYXj+SzjIB6ev5CWzZ
         ayITvZkKpSRuOLFDLlfJ9oq0wEWwtsbZDXlfb+ASWH4w0nUQqcCi9wHeykn/jS3HXRbp
         Afev6fMtCB9smzWZlBTMqOXn3W3GgOb2TSoOwz9ds/Ke72GctAf/GKuBOv6qess/FfZw
         4A4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UW4lx/dXozllODMsrDEnjT74BinFnpST4DJVQDFkvYU=;
        b=t6bG3/fWHkokerV5So2epwT7JfGBTjt/ihigbLys0ILQ6+7ds96z6xrDgYT3zT5Jon
         y+Xx8TijgGrwbD1cbkOJZBJWtsyLqst9CVgpDPYXtT+lpEH+Ggj0YO2GrXf3wtAc4mK+
         +S8HwL/dQdxzCRM7bBoeHxcytTJTiJLFwhDLVqVlyAS8R3J/+QAul2RbUE3j/eMhc4mv
         PsNpQ0SKXjah4fy/gu/c/d5ZCfHYBdziXTkZUb8SB+JXz1FMj4r0keXs4Uoa+XLUIdTp
         Aj8fPStL0p5U59nVbm2fd8sIq0Fj/gs9NgZvPCjFURJAkgpZVsYgkDCLdXRMVBjJqBII
         GZiQ==
X-Gm-Message-State: APjAAAVCrDVPrD2ObuVBMa2hIjBiwudC7qxqTRVlqG0JUJSYfPM/LHSz
        o8hz6SHJJX6gYFrqgsQnuhX1wnYnItTrD6n4irc=
X-Google-Smtp-Source: APXvYqz/h7HnBhyTDM+Rbjvp46GWYbyANUIB5F1Eeg4q1OE5XxAODeFamF0xZCT+l0a7on1F7lKMxOz3tRWYjdDugMQ=
X-Received: by 2002:a63:8b4c:: with SMTP id j73mr1227364pge.15.1560117816294;
 Sun, 09 Jun 2019 15:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org> <20190609115509.26260-8-ard.biesheuvel@linaro.org>
In-Reply-To: <20190609115509.26260-8-ard.biesheuvel@linaro.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 9 Jun 2019 17:03:25 -0500
Message-ID: <CAH2r5mvQmY8onx6y2Y1aJOuWP9AsK52EJ=cXiJ7hdYPWrLp6uA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] fs: cifs: switch to RC4 library interface
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Probably harmless to change this code path (build_ntlmssp_auth_blob is
called at session negotiation time so shouldn't have much of a
performance impact).

On the other hand if we can find optimizations in the encryption and
signing paths, that would be really helpful.   There was a lot of
focus on encryption performance at SambaXP last week.

Andreas from Redhat gave a talk on the improvements in Samba with TLS
implementation of AES-GCM.   I added the cifs client implementation of
AES-GCM and notice it is now faster to encrypt packets than sign them
(performance is about 2 to 3 times faster now with GCM).

On Sun, Jun 9, 2019 at 6:57 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
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
>  fs/cifs/cifsencrypt.c | 50 +++++---------------
>  2 files changed, 13 insertions(+), 39 deletions(-)
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
> index d2a05e46d6f5..d0ab5a38e5d2 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -33,7 +33,7 @@
>  #include <linux/ctype.h>
>  #include <linux/random.h>
>  #include <linux/highmem.h>
> -#include <crypto/skcipher.h>
> +#include <crypto/arc4.h>
>  #include <crypto/aead.h>
>
>  int __cifs_calc_signature(struct smb_rqst *rqst,
> @@ -772,11 +772,9 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>  int
>  calc_seckey(struct cifs_ses *ses)
>  {
> -       int rc;
> -       struct crypto_skcipher *tfm_arc4;
> -       struct scatterlist sgin, sgout;
> -       struct skcipher_request *req;
> +       struct crypto_arc4_ctx *ctx_arc4;
>         unsigned char *sec_key;
> +       int rc = 0;
>
>         sec_key = kmalloc(CIFS_SESS_KEY_SIZE, GFP_KERNEL);
>         if (sec_key == NULL)
> @@ -784,49 +782,25 @@ calc_seckey(struct cifs_ses *ses)
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
> +       ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
> +       if (!ctx_arc4) {
>                 rc = -ENOMEM;
> -               cifs_dbg(VFS, "could not allocate crypto API arc4 request\n");
> -               goto out_free_cipher;
> +               cifs_dbg(VFS, "could not allocate arc4 context\n");
> +               goto out;
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
> +       crypto_arc4_set_key(ctx_arc4, ses->auth_key.response,
> +                           CIFS_SESS_KEY_SIZE);
> +       crypto_arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
> +                         CIFS_CPHTXT_SIZE);
>
>         /* make secondary_key/nonce as session key */
>         memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
>         /* and make len as that of session key only */
>         ses->auth_key.len = CIFS_SESS_KEY_SIZE;
>
> -out_free_cipher:
> -       crypto_free_skcipher(tfm_arc4);
>  out:
> +       kfree(ctx_arc4);
>         kfree(sec_key);
>         return rc;
>  }
> --
> 2.20.1
>


-- 
Thanks,

Steve
