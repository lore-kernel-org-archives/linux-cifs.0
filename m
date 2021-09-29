Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F64FC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 21:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3EAE615A7
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 21:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346420AbhI2VVn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 17:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhI2VVn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 17:21:43 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E22DC061767
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 14:20:01 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id y26so16323308lfa.11
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 14:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=00/0F7InT7N6sLceL7O9GfgK0Tzf0TnJEHa37FMLEpk=;
        b=JqyXO+4A+hvxJZMIjGwcZBDXJruMxipJ+DYjz2PmZ/aXFzIu+rHmdkKWp3dHtgN5s4
         XAEu2P3MPHm81ByYJVh80EcFE4zpwwtwsxzb5uHX288RLD7v0LmyMZHWeX3EzLs5vyTD
         zdJk1UY2xuw01z5cwYVThJq5S/hn6GGn5Xv6RBxNvU2OoiYQO36vP68voLAbjhNjiBl7
         POYAiKUxic4ZhekbX0vT5Uh+Blr/74jvBKX/mR9LCSBh8KoiKc3CsSHZUlaLlKJXDZP/
         fL/U7XUyCf6OTdKk0pFsiSajNL3lsFxNsuFv5zl+uCrPCb9at/Mp1Igu9PPIYrLe30Wz
         CQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=00/0F7InT7N6sLceL7O9GfgK0Tzf0TnJEHa37FMLEpk=;
        b=zqXgsp/RvVM9eduJcJcxIvNx6YxHHk/GrtQdCRu5qSPaZ+UZ+p6YUjZBiZJbK19Nko
         dkGgH0lewxQvihzMt12lUX9hmIuP0apZP+h8n+6gtTX1M2HdocNp303M2hrZd+AgTmk1
         xJLc1x77Lbchm/vS1QTd1CAGVVawtm8JsiMfrMxR9j09cQVUIcplYLbOOI9RF0UeOipo
         L74HXi1QXh9YPy3IRhu4WJ2ROwqbNIWbcKJdke9vmr39cS9y6QoXbb7kEHfwBrPNH/zI
         hJFQOnqqiXLOHWE75gjDeLMvq7FRdO7diNbImlOBQGh15jFCHhauPq33jVpCgtN03lfI
         SZaQ==
X-Gm-Message-State: AOAM533mb5YXoQntzSiN606q2KrokQscyucul9C95341jJEEBf6N536T
        nZZxUHE16u6/OwAqAuMrhmxWD5RnONlXVjh955k=
X-Google-Smtp-Source: ABdhPJxFNL7va3exQSHKrxuN4hNMkYnsQWjzdGkW0+Tzjf02gq0235Vgb2xHBrPijaK28q5tLl/eKDK/WyXCCoyjOBs=
X-Received: by 2002:a05:6512:3fa4:: with SMTP id x36mr1895380lfa.320.1632950399671;
 Wed, 29 Sep 2021 14:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210927124748.5614-1-linkinjeon@kernel.org> <20210927124748.5614-2-linkinjeon@kernel.org>
 <8af27366-2bcf-08d3-ff8a-f0635a3c002b@talpey.com> <CAKYAXd8p2+XSY_uzoLofRu8z-R-HOUfHwAQCoi9yX7GuSR5vbA@mail.gmail.com>
 <7c40232b-0135-6c7e-de2f-612dcf30a909@talpey.com>
In-Reply-To: <7c40232b-0135-6c7e-de2f-612dcf30a909@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 29 Sep 2021 16:19:48 -0500
Message-ID: <CAH2r5msx_PchGHbBeHuaMUm7Jgbr+pGYP275fsaLW-1WYW5kXA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: remove NTLMv1 authentication
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifsd-for-next (and ksmbd-for-next)

On Wed, Sep 29, 2021 at 10:02 AM Tom Talpey <tom@talpey.com> wrote:
>
> Ok, feel to free to add my
> Reviewed-By: Tom Talpey <tom@talpey.com>
>
> On 9/28/2021 8:34 PM, Namjae Jeon wrote:
> > 2021-09-28 23:32 GMT+09:00, Tom Talpey <tom@talpey.com>:
> >> On 9/27/2021 8:47 AM, Namjae Jeon wrote:
> >>> Remove insecure NTLMv1 authentication.
> >>
> >> There are some extremely confusing name overloads in this file.
> >> Apparently "ksmbd_auth_ntlmv2()" and "__ksmb2_auth_ntlmv2()"
> >> are entirely different things! Yes, this patch removes one,
> >> but it's not easy to review.
> > A long time ago, There was a mistake to rename this function to
> > current name during clean-up.
> >>
> >>> /**
> >>>   * ksmbd_auth_ntlmv2() - NTLMv2 authentication handler
> >>>   * @sess:  session of connection
> >>>   * @ntlmv2:                NTLMv2 challenge response
> >>>   * @blen:          NTLMv2 blob length
> >>>   * @domain_name:   domain name
> >>>   *
> >>>   * Return: 0 on success, error number on error
> >>>   */
> >>
> >>> /**
> >>>   * __ksmbd_auth_ntlmv2() - NTLM2(extended security) authentication
> >>> handler
> >>>   * @sess:  session of connection
> >>>   * @client_nonce:  client nonce from LM response.
> >>>   * @ntlm_resp:             ntlm response data from client.
> >>>   *
> >>>   * Return: 0 on success, error number on error
> >>>   */
> >>
> >> Two questions:
> >> 1) Have you tested this does not remove existing NTLMv2 support?
> > Yes, tested. This is NTLM2 not NTLMv2.
> >> 2) Does this fully clean up the rather insane function naming?
> > Yes, This patch will do all(remove NTLM and insane fucntion name) :)
> >>
> >> Tom.
> > Thank you for your review!
> >>
> >>> Cc: Tom Talpey <tom@talpey.com>
> >>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> >>> Cc: Ralph B=C3=B6hme <slow@samba.org>
> >>> Cc: Steve French <smfrench@gmail.com>
> >>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> >>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> >>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >>> ---
> >>>    fs/ksmbd/auth.c       | 205 --------------------------------------=
----
> >>>    fs/ksmbd/crypto_ctx.c |  16 ----
> >>>    fs/ksmbd/crypto_ctx.h |   8 --
> >>>    3 files changed, 229 deletions(-)
> >>>
> >>> diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
> >>> index de36f12070bf..71c989f1568d 100644
> >>> --- a/fs/ksmbd/auth.c
> >>> +++ b/fs/ksmbd/auth.c
> >>> @@ -68,125 +68,6 @@ void ksmbd_copy_gss_neg_header(void *buf)
> >>>     memcpy(buf, NEGOTIATE_GSS_HEADER, AUTH_GSS_LENGTH);
> >>>    }
> >>>
> >>> -static void
> >>> -str_to_key(unsigned char *str, unsigned char *key)
> >>> -{
> >>> -   int i;
> >>> -
> >>> -   key[0] =3D str[0] >> 1;
> >>> -   key[1] =3D ((str[0] & 0x01) << 6) | (str[1] >> 2);
> >>> -   key[2] =3D ((str[1] & 0x03) << 5) | (str[2] >> 3);
> >>> -   key[3] =3D ((str[2] & 0x07) << 4) | (str[3] >> 4);
> >>> -   key[4] =3D ((str[3] & 0x0F) << 3) | (str[4] >> 5);
> >>> -   key[5] =3D ((str[4] & 0x1F) << 2) | (str[5] >> 6);
> >>> -   key[6] =3D ((str[5] & 0x3F) << 1) | (str[6] >> 7);
> >>> -   key[7] =3D str[6] & 0x7F;
> >>> -   for (i =3D 0; i < 8; i++)
> >>> -           key[i] =3D (key[i] << 1);
> >>> -}
> >>> -
> >>> -static int
> >>> -smbhash(unsigned char *out, const unsigned char *in, unsigned char *=
key)
> >>> -{
> >>> -   unsigned char key2[8];
> >>> -   struct des_ctx ctx;
> >>> -
> >>> -   if (fips_enabled) {
> >>> -           ksmbd_debug(AUTH, "FIPS compliance enabled: DES not permi=
tted\n");
> >>> -           return -ENOENT;
> >>> -   }
> >>> -
> >>> -   str_to_key(key, key2);
> >>> -   des_expand_key(&ctx, key2, DES_KEY_SIZE);
> >>> -   des_encrypt(&ctx, out, in);
> >>> -   memzero_explicit(&ctx, sizeof(ctx));
> >>> -   return 0;
> >>> -}
> >>> -
> >>> -static int ksmbd_enc_p24(unsigned char *p21, const unsigned char *c8=
,
> >>> unsigned char *p24)
> >>> -{
> >>> -   int rc;
> >>> -
> >>> -   rc =3D smbhash(p24, c8, p21);
> >>> -   if (rc)
> >>> -           return rc;
> >>> -   rc =3D smbhash(p24 + 8, c8, p21 + 7);
> >>> -   if (rc)
> >>> -           return rc;
> >>> -   return smbhash(p24 + 16, c8, p21 + 14);
> >>> -}
> >>> -
> >>> -/* produce a md4 message digest from data of length n bytes */
> >>> -static int ksmbd_enc_md4(unsigned char *md4_hash, unsigned char
> >>> *link_str,
> >>> -                    int link_len)
> >>> -{
> >>> -   int rc;
> >>> -   struct ksmbd_crypto_ctx *ctx;
> >>> -
> >>> -   ctx =3D ksmbd_crypto_ctx_find_md4();
> >>> -   if (!ctx) {
> >>> -           ksmbd_debug(AUTH, "Crypto md4 allocation error\n");
> >>> -           return -ENOMEM;
> >>> -   }
> >>> -
> >>> -   rc =3D crypto_shash_init(CRYPTO_MD4(ctx));
> >>> -   if (rc) {
> >>> -           ksmbd_debug(AUTH, "Could not init md4 shash\n");
> >>> -           goto out;
> >>> -   }
> >>> -
> >>> -   rc =3D crypto_shash_update(CRYPTO_MD4(ctx), link_str, link_len);
> >>> -   if (rc) {
> >>> -           ksmbd_debug(AUTH, "Could not update with link_str\n");
> >>> -           goto out;
> >>> -   }
> >>> -
> >>> -   rc =3D crypto_shash_final(CRYPTO_MD4(ctx), md4_hash);
> >>> -   if (rc)
> >>> -           ksmbd_debug(AUTH, "Could not generate md4 hash\n");
> >>> -out:
> >>> -   ksmbd_release_crypto_ctx(ctx);
> >>> -   return rc;
> >>> -}
> >>> -
> >>> -static int ksmbd_enc_update_sess_key(unsigned char *md5_hash, char
> >>> *nonce,
> >>> -                                char *server_challenge, int len)
> >>> -{
> >>> -   int rc;
> >>> -   struct ksmbd_crypto_ctx *ctx;
> >>> -
> >>> -   ctx =3D ksmbd_crypto_ctx_find_md5();
> >>> -   if (!ctx) {
> >>> -           ksmbd_debug(AUTH, "Crypto md5 allocation error\n");
> >>> -           return -ENOMEM;
> >>> -   }
> >>> -
> >>> -   rc =3D crypto_shash_init(CRYPTO_MD5(ctx));
> >>> -   if (rc) {
> >>> -           ksmbd_debug(AUTH, "Could not init md5 shash\n");
> >>> -           goto out;
> >>> -   }
> >>> -
> >>> -   rc =3D crypto_shash_update(CRYPTO_MD5(ctx), server_challenge, len=
);
> >>> -   if (rc) {
> >>> -           ksmbd_debug(AUTH, "Could not update with challenge\n");
> >>> -           goto out;
> >>> -   }
> >>> -
> >>> -   rc =3D crypto_shash_update(CRYPTO_MD5(ctx), nonce, len);
> >>> -   if (rc) {
> >>> -           ksmbd_debug(AUTH, "Could not update with nonce\n");
> >>> -           goto out;
> >>> -   }
> >>> -
> >>> -   rc =3D crypto_shash_final(CRYPTO_MD5(ctx), md5_hash);
> >>> -   if (rc)
> >>> -           ksmbd_debug(AUTH, "Could not generate md5 hash\n");
> >>> -out:
> >>> -   ksmbd_release_crypto_ctx(ctx);
> >>> -   return rc;
> >>> -}
> >>> -
> >>>    /**
> >>>     * ksmbd_gen_sess_key() - function to generate session key
> >>>     * @sess:        session of connection
> >>> @@ -324,43 +205,6 @@ static int calc_ntlmv2_hash(struct ksmbd_session
> >>> *sess, char *ntlmv2_hash,
> >>>     return ret;
> >>>    }
> >>>
> >>> -/**
> >>> - * ksmbd_auth_ntlm() - NTLM authentication handler
> >>> - * @sess:  session of connection
> >>> - * @pw_buf:        NTLM challenge response
> >>> - * @passkey:       user password
> >>> - *
> >>> - * Return: 0 on success, error number on error
> >>> - */
> >>> -int ksmbd_auth_ntlm(struct ksmbd_session *sess, char *pw_buf)
> >>> -{
> >>> -   int rc;
> >>> -   unsigned char p21[21];
> >>> -   char key[CIFS_AUTH_RESP_SIZE];
> >>> -
> >>> -   memset(p21, '\0', 21);
> >>> -   memcpy(p21, user_passkey(sess->user), CIFS_NTHASH_SIZE);
> >>> -   rc =3D ksmbd_enc_p24(p21, sess->ntlmssp.cryptkey, key);
> >>> -   if (rc) {
> >>> -           pr_err("password processing failed\n");
> >>> -           return rc;
> >>> -   }
> >>> -
> >>> -   ksmbd_enc_md4(sess->sess_key, user_passkey(sess->user),
> >>> -                 CIFS_SMB1_SESSKEY_SIZE);
> >>> -   memcpy(sess->sess_key + CIFS_SMB1_SESSKEY_SIZE, key,
> >>> -          CIFS_AUTH_RESP_SIZE);
> >>> -   sess->sequence_number =3D 1;
> >>> -
> >>> -   if (strncmp(pw_buf, key, CIFS_AUTH_RESP_SIZE) !=3D 0) {
> >>> -           ksmbd_debug(AUTH, "ntlmv1 authentication failed\n");
> >>> -           return -EINVAL;
> >>> -   }
> >>> -
> >>> -   ksmbd_debug(AUTH, "ntlmv1 authentication pass\n");
> >>> -   return 0;
> >>> -}
> >>> -
> >>>    /**
> >>>     * ksmbd_auth_ntlmv2() - NTLMv2 authentication handler
> >>>     * @sess:        session of connection
> >>> @@ -441,44 +285,6 @@ int ksmbd_auth_ntlmv2(struct ksmbd_session *sess=
,
> >>> struct ntlmv2_resp *ntlmv2,
> >>>     return rc;
> >>>    }
> >>>
> >>> -/**
> >>> - * __ksmbd_auth_ntlmv2() - NTLM2(extended security) authentication
> >>> handler
> >>> - * @sess:  session of connection
> >>> - * @client_nonce:  client nonce from LM response.
> >>> - * @ntlm_resp:             ntlm response data from client.
> >>> - *
> >>> - * Return: 0 on success, error number on error
> >>> - */
> >>> -static int __ksmbd_auth_ntlmv2(struct ksmbd_session *sess, char
> >>> *client_nonce,
> >>> -                          char *ntlm_resp)
> >>> -{
> >>> -   char sess_key[CIFS_SMB1_SESSKEY_SIZE] =3D {0};
> >>> -   int rc;
> >>> -   unsigned char p21[21];
> >>> -   char key[CIFS_AUTH_RESP_SIZE];
> >>> -
> >>> -   rc =3D ksmbd_enc_update_sess_key(sess_key,
> >>> -                                  client_nonce,
> >>> -                                  (char *)sess->ntlmssp.cryptkey, 8)=
;
> >>> -   if (rc) {
> >>> -           pr_err("password processing failed\n");
> >>> -           goto out;
> >>> -   }
> >>> -
> >>> -   memset(p21, '\0', 21);
> >>> -   memcpy(p21, user_passkey(sess->user), CIFS_NTHASH_SIZE);
> >>> -   rc =3D ksmbd_enc_p24(p21, sess_key, key);
> >>> -   if (rc) {
> >>> -           pr_err("password processing failed\n");
> >>> -           goto out;
> >>> -   }
> >>> -
> >>> -   if (memcmp(ntlm_resp, key, CIFS_AUTH_RESP_SIZE) !=3D 0)
> >>> -           rc =3D -EINVAL;
> >>> -out:
> >>> -   return rc;
> >>> -}
> >>> -
> >>>    /**
> >>>     * ksmbd_decode_ntlmssp_auth_blob() - helper function to construct
> >>>     * authenticate blob
> >>> @@ -512,17 +318,6 @@ int ksmbd_decode_ntlmssp_auth_blob(struct
> >>> authenticate_message *authblob,
> >>>     nt_off =3D le32_to_cpu(authblob->NtChallengeResponse.BufferOffset=
);
> >>>     nt_len =3D le16_to_cpu(authblob->NtChallengeResponse.Length);
> >>>
> >>> -   /* process NTLM authentication */
> >>> -   if (nt_len =3D=3D CIFS_AUTH_RESP_SIZE) {
> >>> -           if (le32_to_cpu(authblob->NegotiateFlags) &
> >>> -               NTLMSSP_NEGOTIATE_EXTENDED_SEC)
> >>> -                   return __ksmbd_auth_ntlmv2(sess, (char *)authblob=
 +
> >>> -                           lm_off, (char *)authblob + nt_off);
> >>> -           else
> >>> -                   return ksmbd_auth_ntlm(sess, (char *)authblob +
> >>> -                           nt_off);
> >>> -   }
> >>> -
> >>>     /* TODO : use domain name that imported from configuration file *=
/
> >>>     domain_name =3D smb_strndup_from_utf16((const char *)authblob +
> >>>                     le32_to_cpu(authblob->DomainName.BufferOffset),
> >>> diff --git a/fs/ksmbd/crypto_ctx.c b/fs/ksmbd/crypto_ctx.c
> >>> index 5f4b1008d17e..81488d04199d 100644
> >>> --- a/fs/ksmbd/crypto_ctx.c
> >>> +++ b/fs/ksmbd/crypto_ctx.c
> >>> @@ -81,12 +81,6 @@ static struct shash_desc *alloc_shash_desc(int id)
> >>>     case CRYPTO_SHASH_SHA512:
> >>>             tfm =3D crypto_alloc_shash("sha512", 0, 0);
> >>>             break;
> >>> -   case CRYPTO_SHASH_MD4:
> >>> -           tfm =3D crypto_alloc_shash("md4", 0, 0);
> >>> -           break;
> >>> -   case CRYPTO_SHASH_MD5:
> >>> -           tfm =3D crypto_alloc_shash("md5", 0, 0);
> >>> -           break;
> >>>     default:
> >>>             return NULL;
> >>>     }
> >>> @@ -214,16 +208,6 @@ struct ksmbd_crypto_ctx
> >>> *ksmbd_crypto_ctx_find_sha512(void)
> >>>     return ____crypto_shash_ctx_find(CRYPTO_SHASH_SHA512);
> >>>    }
> >>>
> >>> -struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_md4(void)
> >>> -{
> >>> -   return ____crypto_shash_ctx_find(CRYPTO_SHASH_MD4);
> >>> -}
> >>> -
> >>> -struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_md5(void)
> >>> -{
> >>> -   return ____crypto_shash_ctx_find(CRYPTO_SHASH_MD5);
> >>> -}
> >>> -
> >>>    static struct ksmbd_crypto_ctx *____crypto_aead_ctx_find(int id)
> >>>    {
> >>>     struct ksmbd_crypto_ctx *ctx;
> >>> diff --git a/fs/ksmbd/crypto_ctx.h b/fs/ksmbd/crypto_ctx.h
> >>> index ef11154b43df..4a367c62f653 100644
> >>> --- a/fs/ksmbd/crypto_ctx.h
> >>> +++ b/fs/ksmbd/crypto_ctx.h
> >>> @@ -15,8 +15,6 @@ enum {
> >>>     CRYPTO_SHASH_CMACAES,
> >>>     CRYPTO_SHASH_SHA256,
> >>>     CRYPTO_SHASH_SHA512,
> >>> -   CRYPTO_SHASH_MD4,
> >>> -   CRYPTO_SHASH_MD5,
> >>>     CRYPTO_SHASH_MAX,
> >>>    };
> >>>
> >>> @@ -43,8 +41,6 @@ struct ksmbd_crypto_ctx {
> >>>    #define CRYPTO_CMACAES(c)        ((c)->desc[CRYPTO_SHASH_CMACAES])
> >>>    #define CRYPTO_SHA256(c) ((c)->desc[CRYPTO_SHASH_SHA256])
> >>>    #define CRYPTO_SHA512(c) ((c)->desc[CRYPTO_SHASH_SHA512])
> >>> -#define CRYPTO_MD4(c)              ((c)->desc[CRYPTO_SHASH_MD4])
> >>> -#define CRYPTO_MD5(c)              ((c)->desc[CRYPTO_SHASH_MD5])
> >>>
> >>>    #define CRYPTO_HMACMD5_TFM(c)    ((c)->desc[CRYPTO_SHASH_HMACMD5]-=
>tfm)
> >>>    #define CRYPTO_HMACSHA256_TFM(c)\
> >>> @@ -52,8 +48,6 @@ struct ksmbd_crypto_ctx {
> >>>    #define CRYPTO_CMACAES_TFM(c)    ((c)->desc[CRYPTO_SHASH_CMACAES]-=
>tfm)
> >>>    #define CRYPTO_SHA256_TFM(c)     ((c)->desc[CRYPTO_SHASH_SHA256]->=
tfm)
> >>>    #define CRYPTO_SHA512_TFM(c)     ((c)->desc[CRYPTO_SHASH_SHA512]->=
tfm)
> >>> -#define CRYPTO_MD4_TFM(c)  ((c)->desc[CRYPTO_SHASH_MD4]->tfm)
> >>> -#define CRYPTO_MD5_TFM(c)  ((c)->desc[CRYPTO_SHASH_MD5]->tfm)
> >>>
> >>>    #define CRYPTO_GCM(c)            ((c)->ccmaes[CRYPTO_AEAD_AES_GCM]=
)
> >>>    #define CRYPTO_CCM(c)            ((c)->ccmaes[CRYPTO_AEAD_AES_CCM]=
)
> >>> @@ -64,8 +58,6 @@ struct ksmbd_crypto_ctx
> >>> *ksmbd_crypto_ctx_find_hmacsha256(void);
> >>>    struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_cmacaes(void);
> >>>    struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha512(void);
> >>>    struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_sha256(void);
> >>> -struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_md4(void);
> >>> -struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_md5(void);
> >>>    struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_gcm(void);
> >>>    struct ksmbd_crypto_ctx *ksmbd_crypto_ctx_find_ccm(void);
> >>>    void ksmbd_crypto_destroy(void);
> >>>
> >>
> >



--=20
Thanks,

Steve
