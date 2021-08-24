Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99BBC4320A
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 16:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F33161357
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 16:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbhHXQve (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 12:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhHXQvd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Aug 2021 12:51:33 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C022C061764
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 09:50:49 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id s3so38732315ljp.11
        for <linux-cifs@vger.kernel.org>; Tue, 24 Aug 2021 09:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qqlVNZVdii85Huzo2kpj4iDIvdiLAD3LzCs1aqFCTYc=;
        b=LOrLyh1P6ZzbZO6/iJd1FUXotYMLtpSbxTf359Rj8mE1jLBD1w/q5B/uXP/WHvV7WI
         tX4ZzmmpBMUdfNtN9+33CrlPwFhuX+r1SLJRCWwsNfYOICewoiFse3eWj7/V4LmqrO/y
         0+bjCdqmpc6fZETIe92c65IhDyplyTVqKbl/g+G7aih6zqBhdYNcm+cpbphbjHO6WrXM
         6iAogSE6U0dY/GzsZ3zK6Wr2YvM0QGGxVP+FH/waMCBJyFTaGHpvisWNPuRJ3OKqfAnc
         nGEtzQz2+KbzaPkXd4Vmi+pA5Xl2Hyzrup4TIpfOnNpvFJntO3gdGCB5aq6GsKyMlw+i
         89Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qqlVNZVdii85Huzo2kpj4iDIvdiLAD3LzCs1aqFCTYc=;
        b=nmKas01Jh7Nm2ia1d2jpXdQ/TIFfNyUUL1Lagsw57hl7OJ4gF/qIYbhc4y0yCyR3pB
         0iOp7Nrt/unt6g56T+A8FEuYItN3RECHgXMnHIH4qpqtXPd+VuWQPGaqBxuov+TDWrlh
         7zy6BTHEeV76tcnalI0m09m4hbFcYo9aHO0MHVnyXJf36enjdk/m5lyEgwaHrdvHNKOy
         VuviWvBR1Xt4SEWMcFNrTICqKy1OwkoK21IQeZOjqkirHlIYXbQczCj3KLBXMjknu6k4
         Rc09LrTcdvrSutV1fbwxf97PODp+DN2g/cNYg9T0H/Wz+WPcw2ynZf1py6BZ19EBghHe
         GEbQ==
X-Gm-Message-State: AOAM530mG7/fscBckTzrH2kKEicirXeF6FVrTAf23Dj22F4lNA4WnXng
        2a1yw+BpZZovxlMdrq0md7drivTdy+EiWGFhTxQ=
X-Google-Smtp-Source: ABdhPJxq0DG3TfNCf88O1vJ2u/8dg7ETU+zWY+vJjLcylXXJylxeKsHygpjBf+F7nZvvaDknGQs7z4Tn4cXcQRKvuJ0=
X-Received: by 2002:a2e:8e39:: with SMTP id r25mr32193636ljk.272.1629823847306;
 Tue, 24 Aug 2021 09:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210819233256.1320659-1-lsahlber@redhat.com>
In-Reply-To: <20210819233256.1320659-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 Aug 2021 11:50:36 -0500
Message-ID: <CAH2r5mvLbxwziJGRkufPa1HqT6Q_UYq9rYo0iP5iG6zKMRyZUA@mail.gmail.com>
Subject: Re: [PATCH] cifs: create a MD4 module and switch cifs.ko to use it
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000772dfa05ca50ef6e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000772dfa05ca50ef6e
Content-Type: text/plain; charset="UTF-8"

FIxed various checkpatch errors, and added a commit description




On Thu, Aug 19, 2021 at 6:33 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/Kconfig           |   1 -
>  fs/cifs/cifsfs.c          |   1 -
>  fs/cifs/smbencrypt.c      |  24 ++---
>  fs/cifs_common/Makefile   |   1 +
>  fs/cifs_common/cifs_md4.c | 201 ++++++++++++++++++++++++++++++++++++++
>  fs/cifs_common/md4.h      |  27 +++++
>  6 files changed, 239 insertions(+), 16 deletions(-)
>  create mode 100644 fs/cifs_common/cifs_md4.c
>  create mode 100644 fs/cifs_common/md4.h
>
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index aa4457d72392..3b7e3b9e4fd2 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -4,7 +4,6 @@ config CIFS
>         depends on INET
>         select NLS
>         select CRYPTO
> -       select CRYPTO_MD4
>         select CRYPTO_MD5
>         select CRYPTO_SHA256
>         select CRYPTO_SHA512
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 85c884db909d..c5ba42d75bc2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1749,7 +1749,6 @@ MODULE_DESCRIPTION
>  MODULE_VERSION(CIFS_VERSION);
>  MODULE_SOFTDEP("ecb");
>  MODULE_SOFTDEP("hmac");
> -MODULE_SOFTDEP("md4");
>  MODULE_SOFTDEP("md5");
>  MODULE_SOFTDEP("nls");
>  MODULE_SOFTDEP("aes");
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 5da7eea3323f..c4b0bf239073 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -24,6 +24,7 @@
>  #include "cifsglob.h"
>  #include "cifs_debug.h"
>  #include "cifsproto.h"
> +#include "../cifs_common/md4.h"
>
>  #ifndef false
>  #define false 0
> @@ -42,29 +43,24 @@ static int
>  mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
>  {
>         int rc;
> -       struct crypto_shash *md4 = NULL;
> -       struct sdesc *sdescmd4 = NULL;
> +       struct md4_ctx mctx;
>
> -       rc = cifs_alloc_hash("md4", &md4, &sdescmd4);
> -       if (rc)
> -               goto mdfour_err;
> -
> -       rc = crypto_shash_init(&sdescmd4->shash);
> +       rc = cifs_md4_init(&mctx);
>         if (rc) {
> -               cifs_dbg(VFS, "%s: Could not init md4 shash\n", __func__);
> +               cifs_dbg(VFS, "%s: Could not init MD4\n", __func__);
>                 goto mdfour_err;
>         }
> -       rc = crypto_shash_update(&sdescmd4->shash, link_str, link_len);
> +       rc = cifs_md4_update(&mctx, link_str, link_len);
>         if (rc) {
> -               cifs_dbg(VFS, "%s: Could not update with link_str\n", __func__);
> +               cifs_dbg(VFS, "%s: Could not update MD4\n", __func__);
>                 goto mdfour_err;
>         }
> -       rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
> -       if (rc)
> -               cifs_dbg(VFS, "%s: Could not generate md4 hash\n", __func__);
> +       rc = cifs_md4_final(&mctx, md4_hash);
> +       if (rc) {
> +               cifs_dbg(VFS, "%s: Could not finalize MD4\n", __func__);
> +       }
>
>  mdfour_err:
> -       cifs_free_hash(&md4, &sdescmd4);
>         return rc;
>  }
>
> diff --git a/fs/cifs_common/Makefile b/fs/cifs_common/Makefile
> index 2fc9b40345c4..6fedd2f88a25 100644
> --- a/fs/cifs_common/Makefile
> +++ b/fs/cifs_common/Makefile
> @@ -4,3 +4,4 @@
>  #
>
>  obj-$(CONFIG_CIFS_COMMON) += cifs_arc4.o
> +obj-$(CONFIG_CIFS_COMMON) += cifs_md4.o
> diff --git a/fs/cifs_common/cifs_md4.c b/fs/cifs_common/cifs_md4.c
> new file mode 100644
> index 000000000000..b975026759da
> --- /dev/null
> +++ b/fs/cifs_common/cifs_md4.c
> @@ -0,0 +1,201 @@
> +/*
> + * Cryptographic API.
> + *
> + * MD4 Message Digest Algorithm (RFC1320).
> + *
> + * Implementation derived from Andrew Tridgell and Steve French's
> + * CIFS MD4 implementation, and the cryptoapi implementation
> + * originally based on the public domain implementation written
> + * by Colin Plumb in 1993.
> + *
> + * Copyright (c) Andrew Tridgell 1997-1998.
> + * Modified by Steve French (sfrench@us.ibm.com) 2002
> + * Copyright (c) Cryptoapi developers.
> + * Copyright (c) 2002 David S. Miller (davem@redhat.com)
> + * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <asm/byteorder.h>
> +#include "md4.h"
> +
> +MODULE_LICENSE("GPL");
> +
> +static inline u32 lshift(u32 x, unsigned int s)
> +{
> +       x &= 0xFFFFFFFF;
> +       return ((x << s) & 0xFFFFFFFF) | (x >> (32 - s));
> +}
> +
> +static inline u32 F(u32 x, u32 y, u32 z)
> +{
> +       return (x & y) | ((~x) & z);
> +}
> +
> +static inline u32 G(u32 x, u32 y, u32 z)
> +{
> +       return (x & y) | (x & z) | (y & z);
> +}
> +
> +static inline u32 H(u32 x, u32 y, u32 z)
> +{
> +       return x ^ y ^ z;
> +}
> +
> +#define ROUND1(a,b,c,d,k,s) (a = lshift(a + F(b,c,d) + k, s))
> +#define ROUND2(a,b,c,d,k,s) (a = lshift(a + G(b,c,d) + k + (u32)0x5A827999,s))
> +#define ROUND3(a,b,c,d,k,s) (a = lshift(a + H(b,c,d) + k + (u32)0x6ED9EBA1,s))
> +
> +static void md4_transform(u32 *hash, u32 const *in)
> +{
> +       u32 a, b, c, d;
> +
> +       a = hash[0];
> +       b = hash[1];
> +       c = hash[2];
> +       d = hash[3];
> +
> +       ROUND1(a, b, c, d, in[0], 3);
> +       ROUND1(d, a, b, c, in[1], 7);
> +       ROUND1(c, d, a, b, in[2], 11);
> +       ROUND1(b, c, d, a, in[3], 19);
> +       ROUND1(a, b, c, d, in[4], 3);
> +       ROUND1(d, a, b, c, in[5], 7);
> +       ROUND1(c, d, a, b, in[6], 11);
> +       ROUND1(b, c, d, a, in[7], 19);
> +       ROUND1(a, b, c, d, in[8], 3);
> +       ROUND1(d, a, b, c, in[9], 7);
> +       ROUND1(c, d, a, b, in[10], 11);
> +       ROUND1(b, c, d, a, in[11], 19);
> +       ROUND1(a, b, c, d, in[12], 3);
> +       ROUND1(d, a, b, c, in[13], 7);
> +       ROUND1(c, d, a, b, in[14], 11);
> +       ROUND1(b, c, d, a, in[15], 19);
> +
> +       ROUND2(a, b, c, d,in[ 0], 3);
> +       ROUND2(d, a, b, c, in[4], 5);
> +       ROUND2(c, d, a, b, in[8], 9);
> +       ROUND2(b, c, d, a, in[12], 13);
> +       ROUND2(a, b, c, d, in[1], 3);
> +       ROUND2(d, a, b, c, in[5], 5);
> +       ROUND2(c, d, a, b, in[9], 9);
> +       ROUND2(b, c, d, a, in[13], 13);
> +       ROUND2(a, b, c, d, in[2], 3);
> +       ROUND2(d, a, b, c, in[6], 5);
> +       ROUND2(c, d, a, b, in[10], 9);
> +       ROUND2(b, c, d, a, in[14], 13);
> +       ROUND2(a, b, c, d, in[3], 3);
> +       ROUND2(d, a, b, c, in[7], 5);
> +       ROUND2(c, d, a, b, in[11], 9);
> +       ROUND2(b, c, d, a, in[15], 13);
> +
> +       ROUND3(a, b, c, d,in[ 0], 3);
> +       ROUND3(d, a, b, c, in[8], 9);
> +       ROUND3(c, d, a, b, in[4], 11);
> +       ROUND3(b, c, d, a, in[12], 15);
> +       ROUND3(a, b, c, d, in[2], 3);
> +       ROUND3(d, a, b, c, in[10], 9);
> +       ROUND3(c, d, a, b, in[6], 11);
> +       ROUND3(b, c, d, a, in[14], 15);
> +       ROUND3(a, b, c, d, in[1], 3);
> +       ROUND3(d, a, b, c, in[9], 9);
> +       ROUND3(c, d, a, b, in[5], 11);
> +       ROUND3(b, c, d, a, in[13], 15);
> +       ROUND3(a, b, c, d, in[3], 3);
> +       ROUND3(d, a, b, c, in[11], 9);
> +       ROUND3(c, d, a, b, in[7], 11);
> +       ROUND3(b, c, d, a, in[15], 15);
> +
> +       hash[0] += a;
> +       hash[1] += b;
> +       hash[2] += c;
> +       hash[3] += d;
> +}
> +
> +static inline void md4_transform_helper(struct md4_ctx *ctx)
> +{
> +       le32_to_cpu_array(ctx->block, ARRAY_SIZE(ctx->block));
> +       md4_transform(ctx->hash, ctx->block);
> +}
> +
> +int cifs_md4_init(struct md4_ctx *mctx)
> +{
> +       memset(mctx, 0, sizeof(struct md4_ctx));
> +       mctx->hash[0] = 0x67452301;
> +       mctx->hash[1] = 0xefcdab89;
> +       mctx->hash[2] = 0x98badcfe;
> +       mctx->hash[3] = 0x10325476;
> +       mctx->byte_count = 0;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(cifs_md4_init);
> +
> +int cifs_md4_update(struct md4_ctx *mctx, const u8 *data, unsigned int len)
> +{
> +       const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
> +
> +       mctx->byte_count += len;
> +
> +       if (avail > len) {
> +               memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
> +                      data, len);
> +               return 0;
> +       }
> +
> +       memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
> +              data, avail);
> +
> +       md4_transform_helper(mctx);
> +       data += avail;
> +       len -= avail;
> +
> +       while (len >= sizeof(mctx->block)) {
> +               memcpy(mctx->block, data, sizeof(mctx->block));
> +               md4_transform_helper(mctx);
> +               data += sizeof(mctx->block);
> +               len -= sizeof(mctx->block);
> +       }
> +
> +       memcpy(mctx->block, data, len);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(cifs_md4_update);
> +
> +int cifs_md4_final(struct md4_ctx *mctx, u8 *out)
> +{
> +       const unsigned int offset = mctx->byte_count & 0x3f;
> +       char *p = (char *)mctx->block + offset;
> +       int padding = 56 - (offset + 1);
> +
> +       *p++ = 0x80;
> +       if (padding < 0) {
> +               memset(p, 0x00, padding + sizeof (u64));
> +               md4_transform_helper(mctx);
> +               p = (char *)mctx->block;
> +               padding = 56;
> +       }
> +
> +       memset(p, 0, padding);
> +       mctx->block[14] = mctx->byte_count << 3;
> +       mctx->block[15] = mctx->byte_count >> 29;
> +       le32_to_cpu_array(mctx->block, (sizeof(mctx->block) -
> +                         sizeof(u64)) / sizeof(u32));
> +       md4_transform(mctx->hash, mctx->block);
> +       cpu_to_le32_array(mctx->hash, ARRAY_SIZE(mctx->hash));
> +       memcpy(out, mctx->hash, sizeof(mctx->hash));
> +       memset(mctx, 0, sizeof(*mctx));
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(cifs_md4_final);
> diff --git a/fs/cifs_common/md4.h b/fs/cifs_common/md4.h
> new file mode 100644
> index 000000000000..5337becc699a
> --- /dev/null
> +++ b/fs/cifs_common/md4.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Common values for ARC4 Cipher Algorithm
> + */
> +
> +#ifndef _CIFS_MD4_H
> +#define _CIFS_MD4_H
> +
> +#include <linux/types.h>
> +
> +#define MD4_DIGEST_SIZE                16
> +#define MD4_HMAC_BLOCK_SIZE    64
> +#define MD4_BLOCK_WORDS                16
> +#define MD4_HASH_WORDS         4
> +
> +struct md4_ctx {
> +       u32 hash[MD4_HASH_WORDS];
> +       u32 block[MD4_BLOCK_WORDS];
> +       u64 byte_count;
> +};
> +
> +
> +int cifs_md4_init(struct md4_ctx *mctx);
> +int cifs_md4_update(struct md4_ctx *mctx, const u8 *data, unsigned int len);
> +int cifs_md4_final(struct md4_ctx *mctx, u8 *out);
> +
> +#endif /* _CIFS_MD4_H */
> --
> 2.30.2
>


-- 
Thanks,

Steve

--000000000000772dfa05ca50ef6e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-create-a-MD4-module-and-switch-cifs.ko-to-use-i.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-create-a-MD4-module-and-switch-cifs.ko-to-use-i.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ksqb0ayc0>
X-Attachment-Id: f_ksqb0ayc0

RnJvbSAzMmVmNTVmZjQwN2ZkOGQ5NWQyYzcxMzgwNjBiYzI4NzEzMDkzMzc3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IEZyaSwgMjAgQXVnIDIwMjEgMDk6MzI6NTYgKzEwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBjcmVhdGUgYSBNRDQgbW9kdWxlIGFuZCBzd2l0Y2ggY2lmcy5rbyB0byB1c2UgaXQKCk1E
NCBzdXBwb3J0IHdpbGwgbGlrZWx5IGJlIHJlbW92ZWQgZnJvbSB0aGUgY3J5cHRvIGRpcmVjdG9y
eSwgYnV0CmlzIG5lZWRlZCBmb3IgY29tcHJlc3Npb24gb2YgTlRMTVNTUCBpbiBTTUIzIG1vdW50
cy4KClNpZ25lZC1vZmYtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4K
U2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0K
IGZzL2NpZnMvS2NvbmZpZyAgICAgICAgICAgfCAgIDEgLQogZnMvY2lmcy9jaWZzZnMuYyAgICAg
ICAgICB8ICAgMSAtCiBmcy9jaWZzL3NtYmVuY3J5cHQuYyAgICAgIHwgIDIyICsrLS0tCiBmcy9j
aWZzX2NvbW1vbi9NYWtlZmlsZSAgIHwgICAxICsKIGZzL2NpZnNfY29tbW9uL2NpZnNfbWQ0LmMg
fCAyMDEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnNfY29t
bW9uL21kNC5oICAgICAgfCAgMjcgKysrKysKIDYgZmlsZXMgY2hhbmdlZCwgMjM4IGluc2VydGlv
bnMoKyksIDE1IGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGZzL2NpZnNfY29tbW9u
L2NpZnNfbWQ0LmMKIGNyZWF0ZSBtb2RlIDEwMDY0NCBmcy9jaWZzX2NvbW1vbi9tZDQuaAoKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvS2NvbmZpZyBiL2ZzL2NpZnMvS2NvbmZpZwppbmRleCBhYTQ0NTdk
NzIzOTIuLjNiN2UzYjllNGZkMiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9LY29uZmlnCisrKyBiL2Zz
L2NpZnMvS2NvbmZpZwpAQCAtNCw3ICs0LDYgQEAgY29uZmlnIENJRlMKIAlkZXBlbmRzIG9uIElO
RVQKIAlzZWxlY3QgTkxTCiAJc2VsZWN0IENSWVBUTwotCXNlbGVjdCBDUllQVE9fTUQ0CiAJc2Vs
ZWN0IENSWVBUT19NRDUKIAlzZWxlY3QgQ1JZUFRPX1NIQTI1NgogCXNlbGVjdCBDUllQVE9fU0hB
NTEyCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRl
eCBiMWIxNzVmMjI5ZWUuLjhjMjBiZmExODdhYyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMu
YworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC0xNzQ4LDcgKzE3NDgsNiBAQCBNT0RVTEVfREVT
Q1JJUFRJT04KIE1PRFVMRV9WRVJTSU9OKENJRlNfVkVSU0lPTik7CiBNT0RVTEVfU09GVERFUCgi
ZWNiIik7CiBNT0RVTEVfU09GVERFUCgiaG1hYyIpOwotTU9EVUxFX1NPRlRERVAoIm1kNCIpOwog
TU9EVUxFX1NPRlRERVAoIm1kNSIpOwogTU9EVUxFX1NPRlRERVAoIm5scyIpOwogTU9EVUxFX1NP
RlRERVAoImFlcyIpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWJlbmNyeXB0LmMgYi9mcy9jaWZz
L3NtYmVuY3J5cHQuYwppbmRleCA1ZGE3ZWVhMzMyM2YuLjEwMDQ3Y2M1NTI4NiAxMDA2NDQKLS0t
IGEvZnMvY2lmcy9zbWJlbmNyeXB0LmMKKysrIGIvZnMvY2lmcy9zbWJlbmNyeXB0LmMKQEAgLTI0
LDYgKzI0LDcgQEAKICNpbmNsdWRlICJjaWZzZ2xvYi5oIgogI2luY2x1ZGUgImNpZnNfZGVidWcu
aCIKICNpbmNsdWRlICJjaWZzcHJvdG8uaCIKKyNpbmNsdWRlICIuLi9jaWZzX2NvbW1vbi9tZDQu
aCIKIAogI2lmbmRlZiBmYWxzZQogI2RlZmluZSBmYWxzZSAwCkBAIC00MiwyOSArNDMsMjQgQEAg
c3RhdGljIGludAogbWRmb3VyKHVuc2lnbmVkIGNoYXIgKm1kNF9oYXNoLCB1bnNpZ25lZCBjaGFy
ICpsaW5rX3N0ciwgaW50IGxpbmtfbGVuKQogewogCWludCByYzsKLQlzdHJ1Y3QgY3J5cHRvX3No
YXNoICptZDQgPSBOVUxMOwotCXN0cnVjdCBzZGVzYyAqc2Rlc2NtZDQgPSBOVUxMOworCXN0cnVj
dCBtZDRfY3R4IG1jdHg7CiAKLQlyYyA9IGNpZnNfYWxsb2NfaGFzaCgibWQ0IiwgJm1kNCwgJnNk
ZXNjbWQ0KTsKLQlpZiAocmMpCi0JCWdvdG8gbWRmb3VyX2VycjsKLQotCXJjID0gY3J5cHRvX3No
YXNoX2luaXQoJnNkZXNjbWQ0LT5zaGFzaCk7CisJcmMgPSBjaWZzX21kNF9pbml0KCZtY3R4KTsK
IAlpZiAocmMpIHsKLQkJY2lmc19kYmcoVkZTLCAiJXM6IENvdWxkIG5vdCBpbml0IG1kNCBzaGFz
aFxuIiwgX19mdW5jX18pOworCQljaWZzX2RiZyhWRlMsICIlczogQ291bGQgbm90IGluaXQgTUQ0
XG4iLCBfX2Z1bmNfXyk7CiAJCWdvdG8gbWRmb3VyX2VycjsKIAl9Ci0JcmMgPSBjcnlwdG9fc2hh
c2hfdXBkYXRlKCZzZGVzY21kNC0+c2hhc2gsIGxpbmtfc3RyLCBsaW5rX2xlbik7CisJcmMgPSBj
aWZzX21kNF91cGRhdGUoJm1jdHgsIGxpbmtfc3RyLCBsaW5rX2xlbik7CiAJaWYgKHJjKSB7Ci0J
CWNpZnNfZGJnKFZGUywgIiVzOiBDb3VsZCBub3QgdXBkYXRlIHdpdGggbGlua19zdHJcbiIsIF9f
ZnVuY19fKTsKKwkJY2lmc19kYmcoVkZTLCAiJXM6IENvdWxkIG5vdCB1cGRhdGUgTUQ0XG4iLCBf
X2Z1bmNfXyk7CiAJCWdvdG8gbWRmb3VyX2VycjsKIAl9Ci0JcmMgPSBjcnlwdG9fc2hhc2hfZmlu
YWwoJnNkZXNjbWQ0LT5zaGFzaCwgbWQ0X2hhc2gpOworCXJjID0gY2lmc19tZDRfZmluYWwoJm1j
dHgsIG1kNF9oYXNoKTsKIAlpZiAocmMpCi0JCWNpZnNfZGJnKFZGUywgIiVzOiBDb3VsZCBub3Qg
Z2VuZXJhdGUgbWQ0IGhhc2hcbiIsIF9fZnVuY19fKTsKKwkJY2lmc19kYmcoVkZTLCAiJXM6IENv
dWxkIG5vdCBmaW5hbGl6ZSBNRDRcbiIsIF9fZnVuY19fKTsKKwogCiBtZGZvdXJfZXJyOgotCWNp
ZnNfZnJlZV9oYXNoKCZtZDQsICZzZGVzY21kNCk7CiAJcmV0dXJuIHJjOwogfQogCmRpZmYgLS1n
aXQgYS9mcy9jaWZzX2NvbW1vbi9NYWtlZmlsZSBiL2ZzL2NpZnNfY29tbW9uL01ha2VmaWxlCmlu
ZGV4IDJmYzliNDAzNDVjNC4uNmZlZGQyZjg4YTI1IDEwMDY0NAotLS0gYS9mcy9jaWZzX2NvbW1v
bi9NYWtlZmlsZQorKysgYi9mcy9jaWZzX2NvbW1vbi9NYWtlZmlsZQpAQCAtNCwzICs0LDQgQEAK
ICMKIAogb2JqLSQoQ09ORklHX0NJRlNfQ09NTU9OKSArPSBjaWZzX2FyYzQubworb2JqLSQoQ09O
RklHX0NJRlNfQ09NTU9OKSArPSBjaWZzX21kNC5vCmRpZmYgLS1naXQgYS9mcy9jaWZzX2NvbW1v
bi9jaWZzX21kNC5jIGIvZnMvY2lmc19jb21tb24vY2lmc19tZDQuYwpuZXcgZmlsZSBtb2RlIDEw
MDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmRiZjkxMTNiODYwMAotLS0gL2Rldi9udWxsCisrKyBi
L2ZzL2NpZnNfY29tbW9uL2NpZnNfbWQ0LmMKQEAgLTAsMCArMSwyMDEgQEAKKy8qCisgKiBDcnlw
dG9ncmFwaGljIEFQSS4KKyAqCisgKiBNRDQgTWVzc2FnZSBEaWdlc3QgQWxnb3JpdGhtIChSRkMx
MzIwKS4KKyAqCisgKiBJbXBsZW1lbnRhdGlvbiBkZXJpdmVkIGZyb20gQW5kcmV3IFRyaWRnZWxs
IGFuZCBTdGV2ZSBGcmVuY2gncworICogQ0lGUyBNRDQgaW1wbGVtZW50YXRpb24sIGFuZCB0aGUg
Y3J5cHRvYXBpIGltcGxlbWVudGF0aW9uCisgKiBvcmlnaW5hbGx5IGJhc2VkIG9uIHRoZSBwdWJs
aWMgZG9tYWluIGltcGxlbWVudGF0aW9uIHdyaXR0ZW4KKyAqIGJ5IENvbGluIFBsdW1iIGluIDE5
OTMuCisgKgorICogQ29weXJpZ2h0IChjKSBBbmRyZXcgVHJpZGdlbGwgMTk5Ny0xOTk4LgorICog
TW9kaWZpZWQgYnkgU3RldmUgRnJlbmNoIChzZnJlbmNoQHVzLmlibS5jb20pIDIwMDIKKyAqIENv
cHlyaWdodCAoYykgQ3J5cHRvYXBpIGRldmVsb3BlcnMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMDIg
RGF2aWQgUy4gTWlsbGVyIChkYXZlbUByZWRoYXQuY29tKQorICogQ29weXJpZ2h0IChjKSAyMDAy
IEphbWVzIE1vcnJpcyA8am1vcnJpc0BpbnRlcmNvZGUuY29tLmF1PgorICoKKyAqIFRoaXMgcHJv
Z3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9k
aWZ5CisgKiBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNl
bnNlIGFzIHB1Ymxpc2hlZCBieQorICogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0
aGVyIHZlcnNpb24gMiBvZiB0aGUgTGljZW5zZSwgb3IKKyAqIChhdCB5b3VyIG9wdGlvbikgYW55
IGxhdGVyIHZlcnNpb24uCisgKgorICovCisjaW5jbHVkZSA8bGludXgvaW5pdC5oPgorI2luY2x1
ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgorI2luY2x1ZGUg
PGxpbnV4L3N0cmluZy5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8YXNt
L2J5dGVvcmRlci5oPgorI2luY2x1ZGUgIm1kNC5oIgorCitNT0RVTEVfTElDRU5TRSgiR1BMIik7
CisKK3N0YXRpYyBpbmxpbmUgdTMyIGxzaGlmdCh1MzIgeCwgdW5zaWduZWQgaW50IHMpCit7CisJ
eCAmPSAweEZGRkZGRkZGOworCXJldHVybiAoKHggPDwgcykgJiAweEZGRkZGRkZGKSB8ICh4ID4+
ICgzMiAtIHMpKTsKK30KKworc3RhdGljIGlubGluZSB1MzIgRih1MzIgeCwgdTMyIHksIHUzMiB6
KQoreworCXJldHVybiAoeCAmIHkpIHwgKCh+eCkgJiB6KTsKK30KKworc3RhdGljIGlubGluZSB1
MzIgRyh1MzIgeCwgdTMyIHksIHUzMiB6KQoreworCXJldHVybiAoeCAmIHkpIHwgKHggJiB6KSB8
ICh5ICYgeik7Cit9CisKK3N0YXRpYyBpbmxpbmUgdTMyIEgodTMyIHgsIHUzMiB5LCB1MzIgeikK
K3sKKwlyZXR1cm4geCBeIHkgXiB6OworfQorCisjZGVmaW5lIFJPVU5EMShhLGIsYyxkLGsscykg
KGEgPSBsc2hpZnQoYSArIEYoYixjLGQpICsgaywgcykpCisjZGVmaW5lIFJPVU5EMihhLGIsYyxk
LGsscykgKGEgPSBsc2hpZnQoYSArIEcoYixjLGQpICsgayArICh1MzIpMHg1QTgyNzk5OSxzKSkK
KyNkZWZpbmUgUk9VTkQzKGEsYixjLGQsayxzKSAoYSA9IGxzaGlmdChhICsgSChiLGMsZCkgKyBr
ICsgKHUzMikweDZFRDlFQkExLHMpKQorCitzdGF0aWMgdm9pZCBtZDRfdHJhbnNmb3JtKHUzMiAq
aGFzaCwgdTMyIGNvbnN0ICppbikKK3sKKwl1MzIgYSwgYiwgYywgZDsKKworCWEgPSBoYXNoWzBd
OworCWIgPSBoYXNoWzFdOworCWMgPSBoYXNoWzJdOworCWQgPSBoYXNoWzNdOworCisJUk9VTkQx
KGEsIGIsIGMsIGQsIGluWzBdLCAzKTsKKwlST1VORDEoZCwgYSwgYiwgYywgaW5bMV0sIDcpOwor
CVJPVU5EMShjLCBkLCBhLCBiLCBpblsyXSwgMTEpOworCVJPVU5EMShiLCBjLCBkLCBhLCBpblsz
XSwgMTkpOworCVJPVU5EMShhLCBiLCBjLCBkLCBpbls0XSwgMyk7CisJUk9VTkQxKGQsIGEsIGIs
IGMsIGluWzVdLCA3KTsKKwlST1VORDEoYywgZCwgYSwgYiwgaW5bNl0sIDExKTsKKwlST1VORDEo
YiwgYywgZCwgYSwgaW5bN10sIDE5KTsKKwlST1VORDEoYSwgYiwgYywgZCwgaW5bOF0sIDMpOwor
CVJPVU5EMShkLCBhLCBiLCBjLCBpbls5XSwgNyk7CisJUk9VTkQxKGMsIGQsIGEsIGIsIGluWzEw
XSwgMTEpOworCVJPVU5EMShiLCBjLCBkLCBhLCBpblsxMV0sIDE5KTsKKwlST1VORDEoYSwgYiwg
YywgZCwgaW5bMTJdLCAzKTsKKwlST1VORDEoZCwgYSwgYiwgYywgaW5bMTNdLCA3KTsKKwlST1VO
RDEoYywgZCwgYSwgYiwgaW5bMTRdLCAxMSk7CisJUk9VTkQxKGIsIGMsIGQsIGEsIGluWzE1XSwg
MTkpOworCisJUk9VTkQyKGEsIGIsIGMsIGQsIGluWzBdLCAzKTsKKwlST1VORDIoZCwgYSwgYiwg
YywgaW5bNF0sIDUpOworCVJPVU5EMihjLCBkLCBhLCBiLCBpbls4XSwgOSk7CisJUk9VTkQyKGIs
IGMsIGQsIGEsIGluWzEyXSwgMTMpOworCVJPVU5EMihhLCBiLCBjLCBkLCBpblsxXSwgMyk7CisJ
Uk9VTkQyKGQsIGEsIGIsIGMsIGluWzVdLCA1KTsKKwlST1VORDIoYywgZCwgYSwgYiwgaW5bOV0s
IDkpOworCVJPVU5EMihiLCBjLCBkLCBhLCBpblsxM10sIDEzKTsKKwlST1VORDIoYSwgYiwgYywg
ZCwgaW5bMl0sIDMpOworCVJPVU5EMihkLCBhLCBiLCBjLCBpbls2XSwgNSk7CisJUk9VTkQyKGMs
IGQsIGEsIGIsIGluWzEwXSwgOSk7CisJUk9VTkQyKGIsIGMsIGQsIGEsIGluWzE0XSwgMTMpOwor
CVJPVU5EMihhLCBiLCBjLCBkLCBpblszXSwgMyk7CisJUk9VTkQyKGQsIGEsIGIsIGMsIGluWzdd
LCA1KTsKKwlST1VORDIoYywgZCwgYSwgYiwgaW5bMTFdLCA5KTsKKwlST1VORDIoYiwgYywgZCwg
YSwgaW5bMTVdLCAxMyk7CisKKwlST1VORDMoYSwgYiwgYywgZCwgaW5bMF0sIDMpOworCVJPVU5E
MyhkLCBhLCBiLCBjLCBpbls4XSwgOSk7CisJUk9VTkQzKGMsIGQsIGEsIGIsIGluWzRdLCAxMSk7
CisJUk9VTkQzKGIsIGMsIGQsIGEsIGluWzEyXSwgMTUpOworCVJPVU5EMyhhLCBiLCBjLCBkLCBp
blsyXSwgMyk7CisJUk9VTkQzKGQsIGEsIGIsIGMsIGluWzEwXSwgOSk7CisJUk9VTkQzKGMsIGQs
IGEsIGIsIGluWzZdLCAxMSk7CisJUk9VTkQzKGIsIGMsIGQsIGEsIGluWzE0XSwgMTUpOworCVJP
VU5EMyhhLCBiLCBjLCBkLCBpblsxXSwgMyk7CisJUk9VTkQzKGQsIGEsIGIsIGMsIGluWzldLCA5
KTsKKwlST1VORDMoYywgZCwgYSwgYiwgaW5bNV0sIDExKTsKKwlST1VORDMoYiwgYywgZCwgYSwg
aW5bMTNdLCAxNSk7CisJUk9VTkQzKGEsIGIsIGMsIGQsIGluWzNdLCAzKTsKKwlST1VORDMoZCwg
YSwgYiwgYywgaW5bMTFdLCA5KTsKKwlST1VORDMoYywgZCwgYSwgYiwgaW5bN10sIDExKTsKKwlS
T1VORDMoYiwgYywgZCwgYSwgaW5bMTVdLCAxNSk7CisKKwloYXNoWzBdICs9IGE7CisJaGFzaFsx
XSArPSBiOworCWhhc2hbMl0gKz0gYzsKKwloYXNoWzNdICs9IGQ7Cit9CisKK3N0YXRpYyBpbmxp
bmUgdm9pZCBtZDRfdHJhbnNmb3JtX2hlbHBlcihzdHJ1Y3QgbWQ0X2N0eCAqY3R4KQoreworCWxl
MzJfdG9fY3B1X2FycmF5KGN0eC0+YmxvY2ssIEFSUkFZX1NJWkUoY3R4LT5ibG9jaykpOworCW1k
NF90cmFuc2Zvcm0oY3R4LT5oYXNoLCBjdHgtPmJsb2NrKTsKK30KKworaW50IGNpZnNfbWQ0X2lu
aXQoc3RydWN0IG1kNF9jdHggKm1jdHgpCit7CisJbWVtc2V0KG1jdHgsIDAsIHNpemVvZihzdHJ1
Y3QgbWQ0X2N0eCkpOworCW1jdHgtPmhhc2hbMF0gPSAweDY3NDUyMzAxOworCW1jdHgtPmhhc2hb
MV0gPSAweGVmY2RhYjg5OworCW1jdHgtPmhhc2hbMl0gPSAweDk4YmFkY2ZlOworCW1jdHgtPmhh
c2hbM10gPSAweDEwMzI1NDc2OworCW1jdHgtPmJ5dGVfY291bnQgPSAwOworCisJcmV0dXJuIDA7
Cit9CitFWFBPUlRfU1lNQk9MX0dQTChjaWZzX21kNF9pbml0KTsKKworaW50IGNpZnNfbWQ0X3Vw
ZGF0ZShzdHJ1Y3QgbWQ0X2N0eCAqbWN0eCwgY29uc3QgdTggKmRhdGEsIHVuc2lnbmVkIGludCBs
ZW4pCit7CisJY29uc3QgdTMyIGF2YWlsID0gc2l6ZW9mKG1jdHgtPmJsb2NrKSAtIChtY3R4LT5i
eXRlX2NvdW50ICYgMHgzZik7CisKKwltY3R4LT5ieXRlX2NvdW50ICs9IGxlbjsKKworCWlmIChh
dmFpbCA+IGxlbikgeworCQltZW1jcHkoKGNoYXIgKiltY3R4LT5ibG9jayArIChzaXplb2YobWN0
eC0+YmxvY2spIC0gYXZhaWwpLAorCQkgICAgICAgZGF0YSwgbGVuKTsKKwkJcmV0dXJuIDA7CisJ
fQorCisJbWVtY3B5KChjaGFyICopbWN0eC0+YmxvY2sgKyAoc2l6ZW9mKG1jdHgtPmJsb2NrKSAt
IGF2YWlsKSwKKwkgICAgICAgZGF0YSwgYXZhaWwpOworCisJbWQ0X3RyYW5zZm9ybV9oZWxwZXIo
bWN0eCk7CisJZGF0YSArPSBhdmFpbDsKKwlsZW4gLT0gYXZhaWw7CisKKwl3aGlsZSAobGVuID49
IHNpemVvZihtY3R4LT5ibG9jaykpIHsKKwkJbWVtY3B5KG1jdHgtPmJsb2NrLCBkYXRhLCBzaXpl
b2YobWN0eC0+YmxvY2spKTsKKwkJbWQ0X3RyYW5zZm9ybV9oZWxwZXIobWN0eCk7CisJCWRhdGEg
Kz0gc2l6ZW9mKG1jdHgtPmJsb2NrKTsKKwkJbGVuIC09IHNpemVvZihtY3R4LT5ibG9jayk7CisJ
fQorCisJbWVtY3B5KG1jdHgtPmJsb2NrLCBkYXRhLCBsZW4pOworCisJcmV0dXJuIDA7Cit9CitF
WFBPUlRfU1lNQk9MX0dQTChjaWZzX21kNF91cGRhdGUpOworCitpbnQgY2lmc19tZDRfZmluYWwo
c3RydWN0IG1kNF9jdHggKm1jdHgsIHU4ICpvdXQpCit7CisJY29uc3QgdW5zaWduZWQgaW50IG9m
ZnNldCA9IG1jdHgtPmJ5dGVfY291bnQgJiAweDNmOworCWNoYXIgKnAgPSAoY2hhciAqKW1jdHgt
PmJsb2NrICsgb2Zmc2V0OworCWludCBwYWRkaW5nID0gNTYgLSAob2Zmc2V0ICsgMSk7CisKKwkq
cCsrID0gMHg4MDsKKwlpZiAocGFkZGluZyA8IDApIHsKKwkJbWVtc2V0KHAsIDB4MDAsIHBhZGRp
bmcgKyBzaXplb2YodTY0KSk7CisJCW1kNF90cmFuc2Zvcm1faGVscGVyKG1jdHgpOworCQlwID0g
KGNoYXIgKiltY3R4LT5ibG9jazsKKwkJcGFkZGluZyA9IDU2OworCX0KKworCW1lbXNldChwLCAw
LCBwYWRkaW5nKTsKKwltY3R4LT5ibG9ja1sxNF0gPSBtY3R4LT5ieXRlX2NvdW50IDw8IDM7CisJ
bWN0eC0+YmxvY2tbMTVdID0gbWN0eC0+Ynl0ZV9jb3VudCA+PiAyOTsKKwlsZTMyX3RvX2NwdV9h
cnJheShtY3R4LT5ibG9jaywgKHNpemVvZihtY3R4LT5ibG9jaykgLQorCQkJICBzaXplb2YodTY0
KSkgLyBzaXplb2YodTMyKSk7CisJbWQ0X3RyYW5zZm9ybShtY3R4LT5oYXNoLCBtY3R4LT5ibG9j
ayk7CisJY3B1X3RvX2xlMzJfYXJyYXkobWN0eC0+aGFzaCwgQVJSQVlfU0laRShtY3R4LT5oYXNo
KSk7CisJbWVtY3B5KG91dCwgbWN0eC0+aGFzaCwgc2l6ZW9mKG1jdHgtPmhhc2gpKTsKKwltZW1z
ZXQobWN0eCwgMCwgc2l6ZW9mKCptY3R4KSk7CisKKwlyZXR1cm4gMDsKK30KK0VYUE9SVF9TWU1C
T0xfR1BMKGNpZnNfbWQ0X2ZpbmFsKTsKZGlmZiAtLWdpdCBhL2ZzL2NpZnNfY29tbW9uL21kNC5o
IGIvZnMvY2lmc19jb21tb24vbWQ0LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAw
MDAwMDAwLi41MzM3YmVjYzY5OWEKLS0tIC9kZXYvbnVsbAorKysgYi9mcy9jaWZzX2NvbW1vbi9t
ZDQuaApAQCAtMCwwICsxLDI3IEBACisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MCsgKi8KKy8qCisgKiBDb21tb24gdmFsdWVzIGZvciBBUkM0IENpcGhlciBBbGdvcml0aG0KKyAq
LworCisjaWZuZGVmIF9DSUZTX01ENF9ICisjZGVmaW5lIF9DSUZTX01ENF9ICisKKyNpbmNsdWRl
IDxsaW51eC90eXBlcy5oPgorCisjZGVmaW5lIE1ENF9ESUdFU1RfU0laRQkJMTYKKyNkZWZpbmUg
TUQ0X0hNQUNfQkxPQ0tfU0laRQk2NAorI2RlZmluZSBNRDRfQkxPQ0tfV09SRFMJCTE2CisjZGVm
aW5lIE1ENF9IQVNIX1dPUkRTCQk0CisKK3N0cnVjdCBtZDRfY3R4IHsKKwl1MzIgaGFzaFtNRDRf
SEFTSF9XT1JEU107CisJdTMyIGJsb2NrW01ENF9CTE9DS19XT1JEU107CisJdTY0IGJ5dGVfY291
bnQ7Cit9OworCisKK2ludCBjaWZzX21kNF9pbml0KHN0cnVjdCBtZDRfY3R4ICptY3R4KTsKK2lu
dCBjaWZzX21kNF91cGRhdGUoc3RydWN0IG1kNF9jdHggKm1jdHgsIGNvbnN0IHU4ICpkYXRhLCB1
bnNpZ25lZCBpbnQgbGVuKTsKK2ludCBjaWZzX21kNF9maW5hbChzdHJ1Y3QgbWQ0X2N0eCAqbWN0
eCwgdTggKm91dCk7CisKKyNlbmRpZiAvKiBfQ0lGU19NRDRfSCAqLwotLSAKMi4zMC4yCgo=
--000000000000772dfa05ca50ef6e--
