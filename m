Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3700010A3E
	for <linux-cifs@vger.kernel.org>; Tue, 28 May 2024 20:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716927086; cv=none; b=idrRYnOCNWIyaZhn6PtcqRTioC9vZttvawcJVjdcxmxAt83TkgRbDkpf+wxIb3N6gzpvr1oW8f1zJ6a1r+eeMYSqFlsOar1bGjhP452TfBReswQilTdCq7nBChiLZiL62Itn46tilLJxmkvPdWrxEm4+4Xv4mvXZ+QdqepI/qXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716927086; c=relaxed/simple;
	bh=6/WWBjHKpZmcJoF5zCz785ja6uKyTjISFCRpxDFI9tw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D8ENh1TocXaCx5fulKFdqVgFd1y1kn94XvwHNf+Av8Kn3LUp8f38LPVpD6AMEuKZLfz/OkI1wRi9sCDAA2rKi4AMCaHJfVC4hkmlUMUjZ70mSdireDfWc0bPm+wGGoQ2FdODIQJPGWay4C0sk+4ec6ZbIAtUf2NOuWzNGVbFaic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m8dKPnwg; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8dKPnwg"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-529597d77b4so1606215e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 28 May 2024 13:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716927083; x=1717531883; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R99cgwbRaoyDMMQnOHV81YLIXloRF52MndUSGUdZ2Vg=;
        b=m8dKPnwgGoMVRPtw1ou9Pv3KGbzTJ7Cs4k1vgeagv9AnrTgJORG1VlrsNwndWbm69n
         0+X3vxl+AQTVfI4GUOWPHIdo8VnITkvIClL5ghz6sO1wNRlfOh7Iz6gD3bHKEgqElwJn
         hSusmCk6h9ipoW7quqkSVUfQ+rQDiCjNYqLOtYn6wCX8K64SjQTX1Ez4t+f9DDU6Y/BR
         WNszxcnYEEUfF56tnSPKUndqezARLz/qLY/OJ79UTa1OJ6KS0LExhp9JXOavtyqPFD32
         t7rExTa8j78yYyf8Q9iQyxDLXnFVgxBkFtjAPI20wIBPSzLP7GIsXzFkN99Qm/4zoZBR
         0MbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716927083; x=1717531883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R99cgwbRaoyDMMQnOHV81YLIXloRF52MndUSGUdZ2Vg=;
        b=aNInODysiNolvP3FcGUABA3QlZ2LKFdjG/S1NwA6/RGM1cfBrawuFXvE5VLFSoF+o8
         e2Qy33s10X0gUWWYiv8WxtLqcxbIywtx+tWOchkksCI23uuv6zG1mQwdpBk1AtxZHJWr
         sapxJtvaykfjIjRWOIXYif4GGRZ0zrUGTMSwC5YXiBTejBQg3pTwoHSIRItZEQF1wIaJ
         d4nI6rBnBeriD3Nb1P1QW6y14G0Yq856HQdOONsGsWUtHR01odkLgT1sanzccIvAoFod
         IKwHbzgBhGKbjq99pzOl0ZOdjY4BBwTXz9hiKmdAIphjaV5EKoTEYXXMTpR65zl7PUUt
         pmpA==
X-Forwarded-Encrypted: i=1; AJvYcCUOQLSGuwX2v19xJeCKeerwfmIXSk7hmKthz3oRHPUU9J+SPz3w1wGKIe3+OhT7JIcFedRKJaPYlqMNiIYxu68++ThJ9C74jdnZoA==
X-Gm-Message-State: AOJu0YyIVgR6bq6yKWkAcrrNyJUNDreQmcfiWb68qHC5TgWn40+T9IGo
	mgvzgdbheVJbZ8H/GkNzVc2vJFqwKG1UTpEFqVYiV94HeD1cWL+ugMtsJ43jT1b1tC8W3R7MofI
	TDraqVx8Cziy+81jG6MmlTGgCcOFLz1nG
X-Google-Smtp-Source: AGHT+IGpZN9Wlds/TjvXdWJL1itm/NEpZkvCANd3ucQghOw6PfNeyaEQU95RCSrjUF0lK1Z+xH2MPaI/cPgPYieE02M=
X-Received: by 2002:a05:6512:4018:b0:529:b702:e62c with SMTP id
 2adb3069b0e04-529b702e6b4mr3306580e87.42.1716927083081; Tue, 28 May 2024
 13:11:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240526-md-fs-smb-common-v1-1-564a0036abe9@quicinc.com>
 <CAH2r5msb7G8Gh6mMXiMpS3ykC73WdTwRo9Zj662JaxU5Xq2H0A@mail.gmail.com> <bcfeb77e-e986-4be8-87a0-65051bf98c29@talpey.com>
In-Reply-To: <bcfeb77e-e986-4be8-87a0-65051bf98c29@talpey.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 28 May 2024 15:11:11 -0500
Message-ID: <CAH2r5mvcM4_86_+Zf0a2XECztP6fS0nb=avGZeQgMjH8iXOF4g@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: common: add missing MODULE_DESCRIPTION() macros
To: Tom Talpey <tom@talpey.com>
Cc: Jeff Johnson <quic_jjohnson@quicinc.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > Would it be worth adding the word "DEPRECATED"

Perhaps, but it might get confusing since those two modules are loaded
by default (and ksmbd also loads cifs_arc4, but not cifs_md4)

Note that Reiserfs shows "deprecated" in the config menu (Kconfig) but
doesn't mention deprecated in modinfo (in the Description field)

An obvious first step would be to allow cifs.ko to be loaded without
cifs_arc4 and cifs_md4 being available but simply limit the auth protocols =
if
those two modules aren't available.

On Mon, May 27, 2024 at 10:26=E2=80=AFAM Tom Talpey <tom@talpey.com> wrote:
>
> On 5/26/2024 3:44 PM, Steve French wrote:
> > merged into cifs-2.6.git for-next
> >
> > On Sun, May 26, 2024 at 11:53=E2=80=AFAM Jeff Johnson <quic_jjohnson@qu=
icinc.com> wrote:
> >>
> >> Fix the 'make W=3D1' warnings:
> >> WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_a=
rc4.o
> >> WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_m=
d4.o
> >>
> >> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>
> Would it be worth adding the word "DEPRECATED" (or some such)?
> These are present only for SMB1 down-compat, and we don't want
> people to think they're generally useful.
>
> Tom.
>
> >> ---
> >>   fs/smb/common/cifs_arc4.c | 1 +
> >>   fs/smb/common/cifs_md4.c  | 1 +
> >>   2 files changed, 2 insertions(+)
> >>
> >> diff --git a/fs/smb/common/cifs_arc4.c b/fs/smb/common/cifs_arc4.c
> >> index 043e4cb839fa..df360ca47826 100644
> >> --- a/fs/smb/common/cifs_arc4.c
> >> +++ b/fs/smb/common/cifs_arc4.c
> >> @@ -10,6 +10,7 @@
> >>   #include <linux/module.h>
> >>   #include "arc4.h"
> >>
> >> +MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
> >>   MODULE_LICENSE("GPL");
> >>
> >>   int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigne=
d int key_len)
> >> diff --git a/fs/smb/common/cifs_md4.c b/fs/smb/common/cifs_md4.c
> >> index 50f78cfc6ce9..7ee7f4dad90c 100644
> >> --- a/fs/smb/common/cifs_md4.c
> >> +++ b/fs/smb/common/cifs_md4.c
> >> @@ -24,6 +24,7 @@
> >>   #include <asm/byteorder.h>
> >>   #include "md4.h"
> >>
> >> +MODULE_DESCRIPTION("MD4 Message Digest Algorithm (RFC1320)");
> >>   MODULE_LICENSE("GPL");
> >>
> >>   static inline u32 lshift(u32 x, unsigned int s)
> >>
> >> ---
> >> base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
> >> change-id: 20240526-md-fs-smb-common-e92031f7d8cf
> >>
> >>
> >
> >



--=20
Thanks,

Steve
