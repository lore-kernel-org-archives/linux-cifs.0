Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28638315D34;
	Sun,  7 Sep 2025 21:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757280030; cv=none; b=r6/R131UuB18kLUMGxi1WGz0Nt+MnG1h1CscJmAoCiYo2iNnozAJlJXrDO5WjF4eyqkx8jk/N0X/29uY9AS8n/QvPxTKL1NDwOFYGneKCRAGsfWTiGQbjQRE8gbSXYgUcYuwWx3+O2RAAw2HFHnBPOotU9UAVNcf5dd9QK3+qdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757280030; c=relaxed/simple;
	bh=Qu3JdN1IRVENMRLuVNPs5Sra3Em/43K+isyRwlEyrrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nGvdDy2KyfJel79qOrgM7wKcakmJV+4mrZevojWLChaYqwOUsG4Yx5rLUaLFtOUzqVBq2h2JgV8tA/swB2fmbSYA7ZNETALbPctfLzgIyTLRbeokP+GHt5Efes2FXvIf9XiZWqHyLy1Am3qpc4N0/X9QT4qHB2QJsFGDAdS+YI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORH4bSHF; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORH4bSHF"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-70df91bdc53so32490526d6.3;
        Sun, 07 Sep 2025 14:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757280027; x=1757884827; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djaenSEI6B+1oSRfZSQhAXR01UIPQXB6jcXf/XE4FE4=;
        b=ORH4bSHF3j+em2x53juRs56ATXFaOtmcYwt6FgcJDCcF0nUFBHJ2ZJnNb9IX9eI9fU
         P92MANnOYYc/4mPIeTAF+eP6TZJ9NORfybfU6uBbQ43AP0K1vOln0/OD3aLqzE9EFimA
         /bIOjewz8vgxS3IXA5O3dBMv/bxIhfUlp/HCiZ4HyJcM+EB0mMWhPNMNGUXSxFopfUAg
         LEoS6hElEcAa0ise17doUpGhBeDYr/XV9HWr4kJwVcTfPeb9wNWokdgVWp8U2UJsnx9i
         dVvtY3mBtIdO4bAkqK7q4HgRZPj9JpmycXine2lhmK90936hfOFWDaFG75VEmLhZWIOO
         zh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757280027; x=1757884827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djaenSEI6B+1oSRfZSQhAXR01UIPQXB6jcXf/XE4FE4=;
        b=xDgAcQVG0VVEZZaBgDiFw+QMAqsVrHqTqIDI3sh1LK6DST6Xj3s73RgjBc5XDrxrSk
         Ih0wWNFjZcj/amKE2ObLAbNGt2aOoBSY20HMqQ4sivcFoOlh6K0gu0As8x6wkI2YpRSu
         0BzjMpd6bXzcS6IpSVOxtXAphcBzeQmNMsO5hFsLyKk5EvJGuf+UePTs7Cc5yAOa9mHF
         WBFomlucIBTrzTge7ZayWXdSh/tQD3NXjmKOpQjiBjI8N/T5W+Abyl8OsQkI1hcOzBcq
         z8CgTP74MvWv0RKp7E+EXHFKpRBrrK1RLKVdak2ViOAyCZ/CZi6XSKgnP1E4UzHjVBzc
         Wf7A==
X-Forwarded-Encrypted: i=1; AJvYcCWol5aIs70A3sQHVNryv49xa7BdgJ8BWexMiWNWd8E8PTlH7q3Aty55Nl71+pkXoosBPFe1IVeMcsFFfjo=@vger.kernel.org, AJvYcCXDjNrtEehzCqeaeT6YuUaw9fBlDe5DBjcAqY1rmXcfFtVqlO8mYq8zCrnEil2psHtCnoDooUFtS3PObYGp@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9P+X3IHotgmHMu3tQaMVLAFs+MpqyBj9GG2eyuT1ABsawfLMI
	7bXh4Nc0MLIbT0qcLlqO4S+0rF8C3f2Wr9O8YGf9MT0+xHowzI+PHk6obNWJqLGouWyIFfTw6W/
	IM53SEOf+cgKLkFQahfSCuNwQ+AZCU9c=
X-Gm-Gg: ASbGncsy3FXfL8QZOhZ9szTI8+ltnCfQwtjYChCABSH5Pwd0wzw03VOQefB4ymHWQ/u
	hUpZ44XV8GDw9ZEW3C/8EllQA2Suk53u/h+v45titAsvadx7+r2HIQ5FbP9QooO4gpRW7sLrwfG
	5lBmSe0UJWKjSAQ3CHAL4EAX0ElBVGWIF8xRhkN8qdiG0qYEkbMwJN9DudeAm1l6n+3Dk+CKTQd
	u8MiAnUiJIu9dy1wOXqXd/uwFW+dcALyDW6BpLvxin5DUVHSPrclRp5V0yEkuEK99XmpoNAPCKa
	QGgjxMXJ99x9/Vh8E2JcmcHuzqteAl4pMRiNOgaVHs7MDjRwTGoyY51n89SnTMjfHxt41uzjoE4
	5
X-Google-Smtp-Source: AGHT+IEd9gSU7a4Aok3TvFqdkunAxb1EHfAzcYkPcWbxnPhvB9/RxHgqxXfn7G6aFOcmLDxYyZj9rPwFJKxrkWxx27k=
X-Received: by 2002:a05:6214:3015:b0:72a:679d:3560 with SMTP id
 6a1803df08f44-73940bb3714mr64793346d6.51.1757280026770; Sun, 07 Sep 2025
 14:20:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250907032003.386794-1-ebiggers@kernel.org>
In-Reply-To: <20250907032003.386794-1-ebiggers@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Sep 2025 16:20:15 -0500
X-Gm-Features: AS18NWBe_ISaMusaAMJKhdGHd8uUknbVvdxOFdP7kfVwSRodnEHAo67VwEYFFfM
Message-ID: <CAH2r5mu-JMKZrj1RiohyPeyBL7npcvXyVZYFQxX+yBmz4cV=VQ@mail.gmail.com>
Subject: Re: [PATCH] smb: Use arc4 library instead of duplicate arc4 code
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively put in cifs-2.6.git for-next pending any additional review/test=
ing

I did some simple tests and worked fine for me.

On Sat, Sep 6, 2025 at 10:22=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> fs/smb/common/cifs_arc4.c has an implementation of ARC4, but a copy of
> this same code is also present in lib/crypto/arc4.c to serve the other
> users of this legacy algorithm in the kernel.  Remove the duplicate
> implementation in fs/smb/, which seems to have been added because of a
> misunderstanding, and just use the lib/crypto/ one.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/smb/client/Kconfig       |  1 +
>  fs/smb/client/cifsencrypt.c |  8 ++--
>  fs/smb/common/Makefile      |  1 -
>  fs/smb/common/arc4.h        | 23 ------------
>  fs/smb/common/cifs_arc4.c   | 75 -------------------------------------
>  fs/smb/server/Kconfig       |  1 +
>  fs/smb/server/auth.c        |  9 ++---
>  7 files changed, 10 insertions(+), 108 deletions(-)
>  delete mode 100644 fs/smb/common/arc4.h
>  delete mode 100644 fs/smb/common/cifs_arc4.c
>
> diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
> index 9f05f94e265a6..a4c02199fef48 100644
> --- a/fs/smb/client/Kconfig
> +++ b/fs/smb/client/Kconfig
> @@ -13,10 +13,11 @@ config CIFS
>         select CRYPTO_AEAD2
>         select CRYPTO_CCM
>         select CRYPTO_GCM
>         select CRYPTO_ECB
>         select CRYPTO_AES
> +       select CRYPTO_LIB_ARC4
>         select KEYS
>         select DNS_RESOLVER
>         select ASN1
>         select OID_REGISTRY
>         select NETFS_SUPPORT
> diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
> index 3cc6862469087..7b7c8c38fdd08 100644
> --- a/fs/smb/client/cifsencrypt.c
> +++ b/fs/smb/client/cifsencrypt.c
> @@ -20,12 +20,12 @@
>  #include <linux/ctype.h>
>  #include <linux/random.h>
>  #include <linux/highmem.h>
>  #include <linux/fips.h>
>  #include <linux/iov_iter.h>
> -#include "../common/arc4.h"
>  #include <crypto/aead.h>
> +#include <crypto/arc4.h>
>
>  static size_t cifs_shash_step(void *iter_base, size_t progress, size_t l=
en,
>                               void *priv, void *priv2)
>  {
>         struct shash_desc *shash =3D priv;
> @@ -723,13 +723,13 @@ calc_seckey(struct cifs_ses *ses)
>         if (!ctx_arc4) {
>                 cifs_dbg(VFS, "Could not allocate arc4 context\n");
>                 return -ENOMEM;
>         }
>
> -       cifs_arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_=
SIZE);
> -       cifs_arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
> -                       CIFS_CPHTXT_SIZE);
> +       arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE)=
;
> +       arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
> +                  CIFS_CPHTXT_SIZE);
>
>         /* make secondary_key/nonce as session key */
>         memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
>         /* and make len as that of session key only */
>         ses->auth_key.len =3D CIFS_SESS_KEY_SIZE;
> diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
> index c66dbbc1469c3..9e0730a385fb1 100644
> --- a/fs/smb/common/Makefile
> +++ b/fs/smb/common/Makefile
> @@ -1,7 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  #
>  # Makefile for Linux filesystem routines that are shared by client and s=
erver.
>  #
>
> -obj-$(CONFIG_SMBFS) +=3D cifs_arc4.o
>  obj-$(CONFIG_SMBFS) +=3D cifs_md4.o
> diff --git a/fs/smb/common/arc4.h b/fs/smb/common/arc4.h
> deleted file mode 100644
> index 12e71ec033a18..0000000000000
> --- a/fs/smb/common/arc4.h
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0+ */
> -/*
> - * Common values for ARC4 Cipher Algorithm
> - */
> -
> -#ifndef _CRYPTO_ARC4_H
> -#define _CRYPTO_ARC4_H
> -
> -#include <linux/types.h>
> -
> -#define ARC4_MIN_KEY_SIZE      1
> -#define ARC4_MAX_KEY_SIZE      256
> -#define ARC4_BLOCK_SIZE                1
> -
> -struct arc4_ctx {
> -       u32 S[256];
> -       u32 x, y;
> -};
> -
> -int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned in=
t key_len);
> -void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsign=
ed int len);
> -
> -#endif /* _CRYPTO_ARC4_H */
> diff --git a/fs/smb/common/cifs_arc4.c b/fs/smb/common/cifs_arc4.c
> deleted file mode 100644
> index df360ca47826a..0000000000000
> --- a/fs/smb/common/cifs_arc4.c
> +++ /dev/null
> @@ -1,75 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-or-later
> -/*
> - * Cryptographic API
> - *
> - * ARC4 Cipher Algorithm
> - *
> - * Jon Oberheide <jon@oberheide.org>
> - */
> -
> -#include <linux/module.h>
> -#include "arc4.h"
> -
> -MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
> -MODULE_LICENSE("GPL");
> -
> -int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned in=
t key_len)
> -{
> -       int i, j =3D 0, k =3D 0;
> -
> -       ctx->x =3D 1;
> -       ctx->y =3D 0;
> -
> -       for (i =3D 0; i < 256; i++)
> -               ctx->S[i] =3D i;
> -
> -       for (i =3D 0; i < 256; i++) {
> -               u32 a =3D ctx->S[i];
> -
> -               j =3D (j + in_key[k] + a) & 0xff;
> -               ctx->S[i] =3D ctx->S[j];
> -               ctx->S[j] =3D a;
> -               if (++k >=3D key_len)
> -                       k =3D 0;
> -       }
> -
> -       return 0;
> -}
> -EXPORT_SYMBOL_GPL(cifs_arc4_setkey);
> -
> -void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsign=
ed int len)
> -{
> -       u32 *const S =3D ctx->S;
> -       u32 x, y, a, b;
> -       u32 ty, ta, tb;
> -
> -       if (len =3D=3D 0)
> -               return;
> -
> -       x =3D ctx->x;
> -       y =3D ctx->y;
> -
> -       a =3D S[x];
> -       y =3D (y + a) & 0xff;
> -       b =3D S[y];
> -
> -       do {
> -               S[y] =3D a;
> -               a =3D (a + b) & 0xff;
> -               S[x] =3D b;
> -               x =3D (x + 1) & 0xff;
> -               ta =3D S[x];
> -               ty =3D (y + ta) & 0xff;
> -               tb =3D S[ty];
> -               *out++ =3D *in++ ^ S[a];
> -               if (--len =3D=3D 0)
> -                       break;
> -               y =3D ty;
> -               a =3D ta;
> -               b =3D tb;
> -       } while (true);
> -
> -       ctx->x =3D x;
> -       ctx->y =3D y;
> -}
> -EXPORT_SYMBOL_GPL(cifs_arc4_crypt);
> diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
> index 4a23a5e7e8fec..098cac98d31e6 100644
> --- a/fs/smb/server/Kconfig
> +++ b/fs/smb/server/Kconfig
> @@ -8,10 +8,11 @@ config SMB_SERVER
>         select NLS_UCS2_UTILS
>         select CRYPTO
>         select CRYPTO_MD5
>         select CRYPTO_HMAC
>         select CRYPTO_ECB
> +       select CRYPTO_LIB_ARC4
>         select CRYPTO_LIB_DES
>         select CRYPTO_LIB_SHA256
>         select CRYPTO_SHA256
>         select CRYPTO_CMAC
>         select CRYPTO_SHA512
> diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
> index d99871c214518..b4020bb55a268 100644
> --- a/fs/smb/server/auth.c
> +++ b/fs/smb/server/auth.c
> @@ -18,20 +18,20 @@
>
>  #include "auth.h"
>  #include "glob.h"
>
>  #include <linux/fips.h>
> +#include <crypto/arc4.h>
>  #include <crypto/des.h>
>
>  #include "server.h"
>  #include "smb_common.h"
>  #include "connection.h"
>  #include "mgmt/user_session.h"
>  #include "mgmt/user_config.h"
>  #include "crypto_ctx.h"
>  #include "transport_ipc.h"
> -#include "../common/arc4.h"
>
>  /*
>   * Fixed format data defining GSS header and fixed string
>   * "not_defined_in_RFC4178@please_ignore".
>   * So sec blob data in neg phase could be generated statically.
> @@ -363,14 +363,13 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authentic=
ate_message *authblob,
>
>                 ctx_arc4 =3D kmalloc(sizeof(*ctx_arc4), KSMBD_DEFAULT_GFP=
);
>                 if (!ctx_arc4)
>                         return -ENOMEM;
>
> -               cifs_arc4_setkey(ctx_arc4, sess->sess_key,
> -                                SMB2_NTLMV2_SESSKEY_SIZE);
> -               cifs_arc4_crypt(ctx_arc4, sess->sess_key,
> -                               (char *)authblob + sess_key_off, sess_key=
_len);
> +               arc4_setkey(ctx_arc4, sess->sess_key, SMB2_NTLMV2_SESSKEY=
_SIZE);
> +               arc4_crypt(ctx_arc4, sess->sess_key,
> +                          (char *)authblob + sess_key_off, sess_key_len)=
;
>                 kfree_sensitive(ctx_arc4);
>         }
>
>         return ret;
>  }
>
> base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
