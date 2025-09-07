Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81739299949;
	Sun,  7 Sep 2025 18:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757268016; cv=none; b=Oj92AaiVSqa7NeUuveJPQNF7XcHbxtbVYPUEU8H3o3iXWDmjgWraX6pLyLS2/m/P2Qp3J1Eg5VDlMRvK0hyKoJkSvlag/fRPuAbxu0+nNjUaAdupdHB2tAPQRSkaJjrq+kqVMuNDpw/UApLy25S0AETt6eoR6eMmFBwTHkKPnic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757268016; c=relaxed/simple;
	bh=wR6Qn/iJVvGj9+UopMwDQejhovyzoGsDoobugjT4Wn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q3m6FELw7ElA6T8aecI0oQKm6H2YdnQYoplFhx/YH9nXxl56jGMzw4HvIXjD9D8U/hgbPb0ESkYfGxCMX2cH9C7zTcS7Cr1HRGewceHt2e12Bby2bZtYzh5M2J5T30ewZNoVFNHmU0Q1XsklON0sJNQ6z+cdZvkEL1MIdjlA8/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fWGPYJqg; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fWGPYJqg"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-731de180464so15455896d6.1;
        Sun, 07 Sep 2025 11:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757268012; x=1757872812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jfaSv/cVEcz4RWtVPMWk+nhXbO5eAmsXM5GQKveovdw=;
        b=fWGPYJqgLS4iHjHMiqMfqD4SFrIchOo2BIbszuM9y3evwaEEn/rOW7AbOyyKUdMWAZ
         BChb8GRxKj/aOTZ6WrB+fGQBfYJbUXYjjti+6hoGuFJ2bkbHAqY1rvwMmRNWArlj6le4
         gbu0wdgdajh91YqbyYVwjG8Neo6Pk8brWxOiwkHpLjT3FvqAxqTLlhwicgKiD3IX8i24
         u8rEZ7KBbhRfqEoXhu8FeChcWLXQ724j7cYEodXArIt/m6JKDlw0DqOKMHQSLV7g9iS4
         0xIOC1Wrih9Oo/QpFPN/PI3lDAp1l7taFi2+8JwtuEQ6PtGuwrJghC77tN3ftSOqnBOt
         8vzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757268012; x=1757872812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jfaSv/cVEcz4RWtVPMWk+nhXbO5eAmsXM5GQKveovdw=;
        b=eBX4+Hl2WveYkTb+2HYFWdLyE2CYZX5NpTTJM1pfo7cv7wG0RDoXFfZ1lS/N37iVZj
         apO99PtxN/ii157/hySLUwspN1qgS9yXI39PJ5bIWWiuxx2rs0fC5C10oEdS0DFeTx1F
         uM1xx30d/YTeAHauo3NTSg4CobXuPTTCUN5cwlHaE+5DASUk7zT1tIROZInYo7TMRpS0
         YTQDmlRBIWdgcIj+WHCzp5iiDcW6k6jqLcrUK5mcWXN51zwYjG9Rhv0Razqie0XhGhKs
         LetDno0f/xl//UChSWqLwW6jiExVEJ3w1mV0Zcl2QCFWpJ74jK7m7UsJCMsgX044j+pq
         Ttcg==
X-Forwarded-Encrypted: i=1; AJvYcCWaCV5Vm6ZLgpnHOY/V9DFJACwNLp56umpRTUt5VuJMZSQVPbdRGYTKYbabBwprW5EfI8Mv270+w6cwcZSN@vger.kernel.org, AJvYcCXxpPQGQXbkfEXJz6ZhHafmnp5CPvnZZv3oMjw80r6hLd8pQRz8CrZI63RaRoNgK3MxNSEUTLuqG62CCfE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUE/rcdtqkrGmR8eNVIsxDoHE66QoYyG/K3co11JDZMFfPlOdc
	fNLuh7+MuSqSMkwPsm4sW/khGHq9CePjwQRsCMjWtGcuu2JGb7zOQiyvbI1/fz+Udku5FkUQCDj
	m+5RhAfHxVDlTuIS0zgI2iMT8LPD0gCQ=
X-Gm-Gg: ASbGncuxG4V8qxi4YdSMkC2K6905TYDJuhkjJHZO7kds2WUPGcXaAibZ7HTLU455L72
	tdGq9BMfyXV6IMGURu5QoomPAIuFKzQORWcpT2T1EbEbhJETI+EhT9QXuHhJVqhgJdlNqQLyNdi
	7AryLVPsevn606ABQjfzTmWCgZDMw9crM7iuQFP4sZ91EmnzGOV8e5+Hbvhc3QSMJfgmfiRpILB
	sSkBYMcQGQlBhlFMgQrLcBUrYo4V4LlzVbnakO/sUZddNuG8Exz2+A/qwL5uf1Ny3aBs6ZI+eJX
	td0T46oUdKVw9sC/5BmRuAI5U+4IRPw5rSbCyPe06M3fef4WAKNE3mTgbULRsZFrwBSswUG6bi9
	B
X-Google-Smtp-Source: AGHT+IEmKAfjxKzDldhOpQ72mvvR40dDcW9UFQ2BP98shbODdlGx0iW4XeAHG7xN6CwL3SICIWIyeY3P9V4Ggez/bkA=
X-Received: by 2002:ad4:5c6c:0:b0:746:4ca1:fbc with SMTP id
 6a1803df08f44-7464ca1176fmr24532606d6.23.1757268012271; Sun, 07 Sep 2025
 11:00:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250907032003.386794-1-ebiggers@kernel.org> <CAH2r5mutq5vZwKNyZ6nforOierKSH9si+47XoFV7PZSKxuvqHQ@mail.gmail.com>
In-Reply-To: <CAH2r5mutq5vZwKNyZ6nforOierKSH9si+47XoFV7PZSKxuvqHQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Sep 2025 13:00:00 -0500
X-Gm-Features: AS18NWAIgrDZA9JooWeyLBgFoKfrc5lPq-gjrXTE07eYEaLxrA37VXfU2LY6tQA
Message-ID: <CAH2r5mtcexEYcfBosnt+12TCU8rS1ZvJtPfTCTYgZWVQsBt1Fg@mail.gmail.com>
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

This was the original commit:

commit 71c02863246167b3d1639b8278681ca8ebedcb4e
Author: Ronnie Sahlberg <lsahlber@redhat.com>
Date:   Thu Aug 19 20:34:59 2021 +1000

    cifs: fork arc4 and create a separate module for it for cifs and other =
users

    We can not drop ARC4 and basically destroy CIFS connectivity for
    almost all CIFS users so create a new forked ARC4 module that CIFS and =
other
    subsystems that have a hard dependency on ARC4 can use.

    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Sun, Sep 7, 2025 at 12:59=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Ronnie may have additional context, but it may have been forked due to
> unrelated restrictions on the arc4 module (that had nothing to do with
> cifs.ko very narrow usage of arc4) breaking cifs.ko.
>
> Ronnie,
> Do you remember the context?
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



--=20
Thanks,

Steve
