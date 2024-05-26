Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C37812FF7D
	for <linux-cifs@vger.kernel.org>; Sun, 26 May 2024 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716752661; cv=none; b=ts8QqNQ4ISnDvUVnefaJC5JKYsQnI0OjIXgtLIQQrnmTR/5FMbQXPMWIeDGHwtsBh/jF/Ypn8+3qwzPFl66bXXUgfV/D+gkujT8/pqwj5wcpPd9vhktO90tcFFAtLxed7bpT+iy/D4If4JJWiwns03DkQhvKwWMuEf4Yht1ozIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716752661; c=relaxed/simple;
	bh=+rvzid5RK/7yzUJbPGGoP8Y1M1EYCTavl7OVIGgg5H8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ig60CoGr3+ZjR8pUIzqoMJJMhzx4hyalsf86Q96loZrc7uLvgV4LsSqKwA/ft2aa39Y+XAOI7OnlOLAHexTyGbwwubV5nkTV1XesJmQh7hTulg+aY2ZVYzMvN6N9YLbgtnztoHjba+gVDAN96nJZSMUzlJu0x3/GUjR/Y+ZKb2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VTmdBd0I; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VTmdBd0I"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-529644ec0ebso3371202e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 26 May 2024 12:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716752658; x=1717357458; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q46fOTZC0iOjPnPO+2DYrZR4InZbX2Nx2+iX8WULlng=;
        b=VTmdBd0IfUuKEXsfl3s4l4BYHyx5ENDk+P4+Cy7bfvvp1FycA8EFA7eYaEVGCB56cV
         bpGmPBL7s2WTKVTaJyLlVQ69SZzOt25JbEgbvzCpTglEfW/IrYfkInlFAeCZcGoTejPy
         wY0GXc6k0sQMn552WheQ/2XqBJCUlyOFV9Um0Vk+yzfEFqY5ld0JS7QGv1ntxoQv1Z1M
         zU5sV0+SctDVCmwiDyjkvvTcVXOyPHRsYbbuhVfyj/m9xIzxxpftzfOsNZtcszrq8BP+
         +uYvNTPY3qLZu1JKGSpCpf55Nt+IzNU5Pmq3MvkPuiKafvBezPzarkOBbMbMs2/xD7mV
         +0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716752658; x=1717357458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q46fOTZC0iOjPnPO+2DYrZR4InZbX2Nx2+iX8WULlng=;
        b=RHrAaioPLa2Lll42xdjBEuQfQCL6cuAxNmriZ1g7DASacUj+HCrFWM8tHAEf9ksUdU
         lxPnYwD79foICv99Bb66Y2ZMNrlYHaTz8YHvx0Sl0VsTpm+mIgar2YQew8WePEq2RrN0
         kSV5bpvEMNBHk8pxWzr11lLl5snDuhCrOwR+SxuDJY438RRCXlHo30mVWK/8weal0Ouf
         xwJJaXNRfYyLPWFZasvDqnxtUdK+tIwpvLNMuwviygYrZcxxH9FxY5dNehwn/c7T+PAB
         CM1+ytphqaYn1HZHtK0oaZjq/Itp4RSgpT0L47+ypZg6SqzK6Nvto2pxZw9DsZI4tVWz
         fK4Q==
X-Gm-Message-State: AOJu0YxOivIywoen2nqxUt9UIpZzdytJSyd4d6VQ6K09isw9IU1E1Oi7
	bkIA6LBZL6fsaBcLtwNWgCfBgspLRQ/IRRUoFuIvCFXO3Ju3v5Wk+owganohc6enMEwD/ETkQgh
	tLG4Dhn6CigvIA3vWpHkOMznu1Ks=
X-Google-Smtp-Source: AGHT+IF+s4plEJnVu3aRDwbKMAWLTLXVD0HgHzNkMP4UolasJ8tRbC1GxLAyB3jJWgj09FEAEY8vin7NgaXen9H1WJM=
X-Received: by 2002:ac2:5290:0:b0:51c:d1ac:c450 with SMTP id
 2adb3069b0e04-5296529060dmr6474996e87.10.1716752657530; Sun, 26 May 2024
 12:44:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240526-md-fs-smb-common-v1-1-564a0036abe9@quicinc.com>
In-Reply-To: <20240526-md-fs-smb-common-v1-1-564a0036abe9@quicinc.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 26 May 2024 14:44:06 -0500
Message-ID: <CAH2r5msb7G8Gh6mMXiMpS3ykC73WdTwRo9Zj662JaxU5Xq2H0A@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: common: add missing MODULE_DESCRIPTION() macros
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Sun, May 26, 2024 at 11:53=E2=80=AFAM Jeff Johnson <quic_jjohnson@quicin=
c.com> wrote:
>
> Fix the 'make W=3D1' warnings:
> WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_arc4=
.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_md4.=
o
>
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  fs/smb/common/cifs_arc4.c | 1 +
>  fs/smb/common/cifs_md4.c  | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/fs/smb/common/cifs_arc4.c b/fs/smb/common/cifs_arc4.c
> index 043e4cb839fa..df360ca47826 100644
> --- a/fs/smb/common/cifs_arc4.c
> +++ b/fs/smb/common/cifs_arc4.c
> @@ -10,6 +10,7 @@
>  #include <linux/module.h>
>  #include "arc4.h"
>
> +MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
>  MODULE_LICENSE("GPL");
>
>  int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned in=
t key_len)
> diff --git a/fs/smb/common/cifs_md4.c b/fs/smb/common/cifs_md4.c
> index 50f78cfc6ce9..7ee7f4dad90c 100644
> --- a/fs/smb/common/cifs_md4.c
> +++ b/fs/smb/common/cifs_md4.c
> @@ -24,6 +24,7 @@
>  #include <asm/byteorder.h>
>  #include "md4.h"
>
> +MODULE_DESCRIPTION("MD4 Message Digest Algorithm (RFC1320)");
>  MODULE_LICENSE("GPL");
>
>  static inline u32 lshift(u32 x, unsigned int s)
>
> ---
> base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
> change-id: 20240526-md-fs-smb-common-e92031f7d8cf
>
>


--=20
Thanks,

Steve
