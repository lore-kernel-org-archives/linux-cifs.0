Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA83B283FE4;
	Sun,  7 Sep 2025 18:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757270012; cv=none; b=ab3d5puf++ogiGtwBYLNLOBOunQ+igdxU6Vtm/A1aSMmIvCDkAhv1u6/28wOFgjhoU9GAL6SiAu/NktOcA9LKcLwlYONzbWqZZDxIK/j5s544tXFkVyo34h7B+m1fEftCIHuYgHhG30M8Ncpbt+84PA3iUSEQLfxGAlu2Xt2Sts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757270012; c=relaxed/simple;
	bh=2haumMTs1BksSWy181iFOdCCj5/UTBkAOBVDbcBWcAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FSh27KTxjEUVH/8dmWAWsRVLx/EdQeiSiYVz8y/CZqOoY/FrDWbT3SZnlKvAHHQRIge6AACIkFV45xzMgrKqF+tMSGLC1c6t0ezNoVAZVV8gOV2660BqdSU3UznE1YuiF5beSphw0grZeTy8XZ73f9XSiEbXHCYJX6qtvj6TnL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jrne/gQh; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jrne/gQh"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b49c1c130c9so2507149a12.0;
        Sun, 07 Sep 2025 11:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757270010; x=1757874810; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1prghCX2j/ZdYOZtRxnhLixcEap1cTasQWjSnDFEOK4=;
        b=jrne/gQhaoaoecHf9o+uEt/Kut7uuEDR8yxPmxbuH30yxr0WwbZvbZ6Q8lXLu6y75O
         9QmQTPyTZOKylWrgZTB4luLbmXoP/n16XP4GwAgxwewP+mFF/CbUSN9MwkhDhwCOrdHX
         ToDOOmS9Ccgoq6rgW5xJUTnci3hLD7Z3+y1CQfUR6RbbTLeP+5r1ztK6vaIdHKS080kE
         KF8HF4uf+KX+M7XtH6HRe8L1lVxrOYYnxwmA3DbGsFRBMpP0dGteiSxB/KA+JRyw31w5
         5tbXPJez7zzzlREvYP2AGuWjzVEKrbbG4JniaWlW1pmPfa035gteKEK1Kfz07zcgloFw
         amUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757270010; x=1757874810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1prghCX2j/ZdYOZtRxnhLixcEap1cTasQWjSnDFEOK4=;
        b=HkE/O9WnTUZ92e4Rd8yWMREvc4BTbxzlEfaDlK+VJp1mBK94recLSyKhUc581N1rSa
         no8JSNWb11QQRS4B16avAWD88jSSRtpxXQKt0n1QpaOpYd/TDF2gBS6au3VsjSfkhcKi
         Cvxipp53tZWSqdixe1J8amCoawgHXOgh3o/vOAhmdVdQURFndUPbqspdChZEz90Z2SEF
         8BappoEDPu13h+jQhBnyYm0f8vXPLLMhzt6oN/mgv+Cob3/nMHpleCIIKoZXQ42nWhIz
         n9YMsFDRVlUGWLgKEiAXKRc0Va1VcFIbuQP5kkDchbuv2s7DXTWLSUGEMz5WQJtHJG4j
         UJqQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7lKCTeKxUP61SBiq2Ysa7PTKPQMIeAu5nMbzAQqVYWSLQtb11GavhU1u9+eWgqJoSUraGjd8HuM14mpZ2@vger.kernel.org, AJvYcCUeoE7ILUUM5smLTVMQEOghJFMbnjaoWye/ZXvLb4J87ibwWUJ4Z07poZXRn1MYKDn3AMkDzW4gXS1w@vger.kernel.org, AJvYcCX/fLS5IYFbWLW6OkofMkvuhh8cgbmDi8503JI+jDyeilloPrGJf6bnC19e+CbNLMzczkDnkgflMttgI99G@vger.kernel.org
X-Gm-Message-State: AOJu0YwkTbRyYQL9HZvfvVOYBRCS6UOwKvhD+SNguvO0/yl9gBFf0ioW
	U++dOTPPr8ZGX8Tjbc0z19xU8hCfpKKJWbVGduSyrJ/8AX8PQyPcYuWz+G4GFtuiOA7SmOCgsyC
	454t0bsg1FagOYioZvn2x+Z0wqKqh1Ko=
X-Gm-Gg: ASbGncuN93lonpRDUbggREg93bpSGfWUFaRtk3lqfJp32i8WIcInHlbPBFnFbHXx48q
	xVbNmXH9TnFvJeFjzM2npfG5GltHW6gE9xfaBvg3kUWfZ5u2Ch84ttN3v9hDkJmD40b1fgD/FXS
	4xPbClBafhjC8D92EoPxiyKrZfLxUHa9cU9KEblymEG3AXZ2dbqck211mMkSonD6zOzwkH8oZeM
	ms+x9MIkmnWYCfeLj4lV2aVyO/XSpQt5kEADMos2GEMNnQ/6ltN/MyH7kwZwjcZeVP8BWodJsW9
	qsQ=
X-Google-Smtp-Source: AGHT+IFR/gRhNkc1YOW9Zi7R1cnc2A7iUPAIgKgthiJn5F7NTQaDezr7EVExPYq6YHZKpDdlHlFdPKtYZHtahoQRI5w=
X-Received: by 2002:a17:903:2341:b0:24b:25f:5f7f with SMTP id
 d9443c01a7336-2517301ce47mr64467415ad.60.1757270010091; Sun, 07 Sep 2025
 11:33:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250907032003.386794-1-ebiggers@kernel.org> <CAH2r5mutq5vZwKNyZ6nforOierKSH9si+47XoFV7PZSKxuvqHQ@mail.gmail.com>
In-Reply-To: <CAH2r5mutq5vZwKNyZ6nforOierKSH9si+47XoFV7PZSKxuvqHQ@mail.gmail.com>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Mon, 8 Sep 2025 04:33:18 +1000
X-Gm-Features: AS18NWCpN9KIq6ir13rA4hDgL4YVOU6GMbSEJ81vt4fcEK9IDcVMKkK-7j9FVDM
Message-ID: <CAN05THRE0powMS-AgXHfGT_rbkrqBA09PDA6ydzcCGzSnA-V9w@mail.gmail.com>
Subject: Re: [PATCH] smb: Use arc4 library instead of duplicate arc4 code
To: Steve French <smfrench@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-cifs@vger.kernel.org, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Sept 2025 at 03:59, Steve French <smfrench@gmail.com> wrote:
>
> Ronnie may have additional context, but it may have been forked due to
> unrelated restrictions on the arc4 module (that had nothing to do with
> cifs.ko very narrow usage of arc4) breaking cifs.ko.
>
> Ronnie,
> Do you remember the context?

Yepp.
The context was that to my understanding it was suggested that the
arc4 module would be going away
and would be removed so cifs had to stop using it. (or create its own
private copy)

Must been a misunderstanding of what/how would happen with arc4 when
it was retired.


>
> On Sat, Sep 6, 2025 at 10:22=E2=80=AFPM Eric Biggers <ebiggers@kernel.org=
> wrote:
> >
> > fs/smb/common/cifs_arc4.c has an implementation of ARC4, but a copy of
> > this same code is also present in lib/crypto/arc4.c to serve the other
> > users of this legacy algorithm in the kernel.  Remove the duplicate
> > implementation in fs/smb/, which seems to have been added because of a
> > misunderstanding, and just use the lib/crypto/ one.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  fs/smb/client/Kconfig       |  1 +
> >  fs/smb/client/cifsencrypt.c |  8 ++--
> >  fs/smb/common/Makefile      |  1 -
> >  fs/smb/common/arc4.h        | 23 ------------
> >  fs/smb/common/cifs_arc4.c   | 75 -------------------------------------
> >  fs/smb/server/Kconfig       |  1 +
> >  fs/smb/server/auth.c        |  9 ++---
> >  7 files changed, 10 insertions(+), 108 deletions(-)
> >  delete mode 100644 fs/smb/common/arc4.h
> >  delete mode 100644 fs/smb/common/cifs_arc4.c
> >
> > diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
> > index 9f05f94e265a6..a4c02199fef48 100644
> > --- a/fs/smb/client/Kconfig
> > +++ b/fs/smb/client/Kconfig
> > @@ -13,10 +13,11 @@ config CIFS
> >         select CRYPTO_AEAD2
> >         select CRYPTO_CCM
> >         select CRYPTO_GCM
> >         select CRYPTO_ECB
> >         select CRYPTO_AES
> > +       select CRYPTO_LIB_ARC4
> >         select KEYS
> >         select DNS_RESOLVER
> >         select ASN1
> >         select OID_REGISTRY
> >         select NETFS_SUPPORT
> > diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
> > index 3cc6862469087..7b7c8c38fdd08 100644
> > --- a/fs/smb/client/cifsencrypt.c
> > +++ b/fs/smb/client/cifsencrypt.c
> > @@ -20,12 +20,12 @@
> >  #include <linux/ctype.h>
> >  #include <linux/random.h>
> >  #include <linux/highmem.h>
> >  #include <linux/fips.h>
> >  #include <linux/iov_iter.h>
> > -#include "../common/arc4.h"
> >  #include <crypto/aead.h>
> > +#include <crypto/arc4.h>
> >
> >  static size_t cifs_shash_step(void *iter_base, size_t progress, size_t=
 len,
> >                               void *priv, void *priv2)
> >  {
> >         struct shash_desc *shash =3D priv;
> > @@ -723,13 +723,13 @@ calc_seckey(struct cifs_ses *ses)
> >         if (!ctx_arc4) {
> >                 cifs_dbg(VFS, "Could not allocate arc4 context\n");
> >                 return -ENOMEM;
> >         }
> >
> > -       cifs_arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KE=
Y_SIZE);
> > -       cifs_arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
> > -                       CIFS_CPHTXT_SIZE);
> > +       arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZ=
E);
> > +       arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
> > +                  CIFS_CPHTXT_SIZE);
> >
> >         /* make secondary_key/nonce as session key */
> >         memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
> >         /* and make len as that of session key only */
> >         ses->auth_key.len =3D CIFS_SESS_KEY_SIZE;
> > diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
> > index c66dbbc1469c3..9e0730a385fb1 100644
> > --- a/fs/smb/common/Makefile
> > +++ b/fs/smb/common/Makefile
> > @@ -1,7 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  #
> >  # Makefile for Linux filesystem routines that are shared by client and=
 server.
> >  #
> >
> > -obj-$(CONFIG_SMBFS) +=3D cifs_arc4.o
> >  obj-$(CONFIG_SMBFS) +=3D cifs_md4.o
> > diff --git a/fs/smb/common/arc4.h b/fs/smb/common/arc4.h
> > deleted file mode 100644
> > index 12e71ec033a18..0000000000000
> > --- a/fs/smb/common/arc4.h
> > +++ /dev/null
> > @@ -1,23 +0,0 @@
> > -/* SPDX-License-Identifier: GPL-2.0+ */
> > -/*
> > - * Common values for ARC4 Cipher Algorithm
> > - */
> > -
> > -#ifndef _CRYPTO_ARC4_H
> > -#define _CRYPTO_ARC4_H
> > -
> > -#include <linux/types.h>
> > -
> > -#define ARC4_MIN_KEY_SIZE      1
> > -#define ARC4_MAX_KEY_SIZE      256
> > -#define ARC4_BLOCK_SIZE                1
> > -
> > -struct arc4_ctx {
> > -       u32 S[256];
> > -       u32 x, y;
> > -};
> > -
> > -int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned =
int key_len);
> > -void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsi=
gned int len);
> > -
> > -#endif /* _CRYPTO_ARC4_H */
> > diff --git a/fs/smb/common/cifs_arc4.c b/fs/smb/common/cifs_arc4.c
> > deleted file mode 100644
> > index df360ca47826a..0000000000000
> > --- a/fs/smb/common/cifs_arc4.c
> > +++ /dev/null
> > @@ -1,75 +0,0 @@
> > -// SPDX-License-Identifier: GPL-2.0-or-later
> > -/*
> > - * Cryptographic API
> > - *
> > - * ARC4 Cipher Algorithm
> > - *
> > - * Jon Oberheide <jon@oberheide.org>
> > - */
> > -
> > -#include <linux/module.h>
> > -#include "arc4.h"
> > -
> > -MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
> > -MODULE_LICENSE("GPL");
> > -
> > -int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned =
int key_len)
> > -{
> > -       int i, j =3D 0, k =3D 0;
> > -
> > -       ctx->x =3D 1;
> > -       ctx->y =3D 0;
> > -
> > -       for (i =3D 0; i < 256; i++)
> > -               ctx->S[i] =3D i;
> > -
> > -       for (i =3D 0; i < 256; i++) {
> > -               u32 a =3D ctx->S[i];
> > -
> > -               j =3D (j + in_key[k] + a) & 0xff;
> > -               ctx->S[i] =3D ctx->S[j];
> > -               ctx->S[j] =3D a;
> > -               if (++k >=3D key_len)
> > -                       k =3D 0;
> > -       }
> > -
> > -       return 0;
> > -}
> > -EXPORT_SYMBOL_GPL(cifs_arc4_setkey);
> > -
> > -void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsi=
gned int len)
> > -{
> > -       u32 *const S =3D ctx->S;
> > -       u32 x, y, a, b;
> > -       u32 ty, ta, tb;
> > -
> > -       if (len =3D=3D 0)
> > -               return;
> > -
> > -       x =3D ctx->x;
> > -       y =3D ctx->y;
> > -
> > -       a =3D S[x];
> > -       y =3D (y + a) & 0xff;
> > -       b =3D S[y];
> > -
> > -       do {
> > -               S[y] =3D a;
> > -               a =3D (a + b) & 0xff;
> > -               S[x] =3D b;
> > -               x =3D (x + 1) & 0xff;
> > -               ta =3D S[x];
> > -               ty =3D (y + ta) & 0xff;
> > -               tb =3D S[ty];
> > -               *out++ =3D *in++ ^ S[a];
> > -               if (--len =3D=3D 0)
> > -                       break;
> > -               y =3D ty;
> > -               a =3D ta;
> > -               b =3D tb;
> > -       } while (true);
> > -
> > -       ctx->x =3D x;
> > -       ctx->y =3D y;
> > -}
> > -EXPORT_SYMBOL_GPL(cifs_arc4_crypt);
> > diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
> > index 4a23a5e7e8fec..098cac98d31e6 100644
> > --- a/fs/smb/server/Kconfig
> > +++ b/fs/smb/server/Kconfig
> > @@ -8,10 +8,11 @@ config SMB_SERVER
> >         select NLS_UCS2_UTILS
> >         select CRYPTO
> >         select CRYPTO_MD5
> >         select CRYPTO_HMAC
> >         select CRYPTO_ECB
> > +       select CRYPTO_LIB_ARC4
> >         select CRYPTO_LIB_DES
> >         select CRYPTO_LIB_SHA256
> >         select CRYPTO_SHA256
> >         select CRYPTO_CMAC
> >         select CRYPTO_SHA512
> > diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
> > index d99871c214518..b4020bb55a268 100644
> > --- a/fs/smb/server/auth.c
> > +++ b/fs/smb/server/auth.c
> > @@ -18,20 +18,20 @@
> >
> >  #include "auth.h"
> >  #include "glob.h"
> >
> >  #include <linux/fips.h>
> > +#include <crypto/arc4.h>
> >  #include <crypto/des.h>
> >
> >  #include "server.h"
> >  #include "smb_common.h"
> >  #include "connection.h"
> >  #include "mgmt/user_session.h"
> >  #include "mgmt/user_config.h"
> >  #include "crypto_ctx.h"
> >  #include "transport_ipc.h"
> > -#include "../common/arc4.h"
> >
> >  /*
> >   * Fixed format data defining GSS header and fixed string
> >   * "not_defined_in_RFC4178@please_ignore".
> >   * So sec blob data in neg phase could be generated statically.
> > @@ -363,14 +363,13 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authent=
icate_message *authblob,
> >
> >                 ctx_arc4 =3D kmalloc(sizeof(*ctx_arc4), KSMBD_DEFAULT_G=
FP);
> >                 if (!ctx_arc4)
> >                         return -ENOMEM;
> >
> > -               cifs_arc4_setkey(ctx_arc4, sess->sess_key,
> > -                                SMB2_NTLMV2_SESSKEY_SIZE);
> > -               cifs_arc4_crypt(ctx_arc4, sess->sess_key,
> > -                               (char *)authblob + sess_key_off, sess_k=
ey_len);
> > +               arc4_setkey(ctx_arc4, sess->sess_key, SMB2_NTLMV2_SESSK=
EY_SIZE);
> > +               arc4_crypt(ctx_arc4, sess->sess_key,
> > +                          (char *)authblob + sess_key_off, sess_key_le=
n);
> >                 kfree_sensitive(ctx_arc4);
> >         }
> >
> >         return ret;
> >  }
> >
> > base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> > --
> > 2.50.1
> >
> >
>
>
> --
> Thanks,
>
> Steve
