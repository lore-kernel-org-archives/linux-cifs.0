Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76ACEBE
	for <linux-cifs@vger.kernel.org>; Sun, 28 Jul 2024 00:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722127183; cv=none; b=LMaFdaBpErFwKGpTCWPyOU14MK2Cf1oM7Bif8Gbh1tDTA6BHdpd1OU36k+wukuWLt5fMFKgho+dcQGUIhTWwqbQyOwtRWFLwG75LAD3YPzCpn3DlsHBf1/HLPDmCRu5/F9dfj2xMNpLfnbJrKcFPjQzzDR+pgRHb00triO7YTgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722127183; c=relaxed/simple;
	bh=xWRCLZJ7iHfF8c7yvkxSA1jJDbFWRys2MWJv1K7OYIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RFIHNQwWQA0oSdMHCq0ev2LVpxfixTpEF/JkCRKCbV3C3EVRD2b6Gh0F7Al8dRyl7MYmtveZGxwSL4S2Jr7UU1GT/aRLKr9DUYRRRw7cGk/m6n2ZmFX88Q+VVkbPyYmevH2lkQs1HAFgJNmrOCUCIN/a1WvNTeWiTZq4NXdIWU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnlPbCm6; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnlPbCm6"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52f025ab3a7so3660652e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jul 2024 17:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722127180; x=1722731980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2WtLQ0AuJweiHPK220i2nAx1+PX8DFaWeqci7mSxG24=;
        b=OnlPbCm6z7AoZfOPR3DJyauVU1KvMeyquEry0wpMcC7a+0qSI7yHb2qX4z2w+dkowm
         Yae4QGhPAeyhfu6qxYSoMlpkcJG6CZVjvgvPfcwui8n+WMNOh2pQsoxIvrUgF3OVjxFR
         o7x5H2UWKwU1ObNJywWZUVm/u/QppDf+VZGE9Yoaw22rmxL2N5SCGp8Ox3q3myfl3Trv
         qpYH8LAVTYFUIy68/qv0ZHLgnyw1Hz6JZb8XWruxXJpow8Zh5rmahf174i1KFYPVn9d/
         SFcgC7oFbw9F9TQ255r4TJ9kMskqAM/z4agM2Zu7o1jShIUtwsGvl9oTsE9ytBqvs3Ia
         T0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722127180; x=1722731980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WtLQ0AuJweiHPK220i2nAx1+PX8DFaWeqci7mSxG24=;
        b=bwK3elVJrnE4phPr7tSgOYnU7gCOo/Jq9Dk9hBtlxxhNE5key/4gmPfkcMy5GSRC3o
         0rd09ikZ+a8qovNWbCw6xSc/KUsdiPx1MGg9i3NAnn/Fj/oLZ6CILboeQJkpAU5HMKop
         bV0xc7x8S42PVa7aauwQVgvfyAKtIZ5ijtiidDSvIssb76hsFr4BcMYerxVi8P27aykn
         S5yE3uOoHU3cPc26d15QIus6UT574cscH1gTdQSpU0UOnALg/lD1RvxWMeztvkmjS4oD
         mA4xELeqP+ObLJlaDJxcYZ3SCNq6s7CBUhAB+JCIh/8PTOkTjEsqIxbfysUQ/JY6aMMa
         ae4w==
X-Forwarded-Encrypted: i=1; AJvYcCXU2osKwwmymbmNX+4268R+nIt9YxPw7vNUFQqo3USsYANqtk1eGSvU3AHPovMvc8KQirjzulGYD/wmfAe4MFbOUs+BSDggf59OKA==
X-Gm-Message-State: AOJu0Yygz7VL2puJWzFgOgWWb+zAzrFC7EWRYsszI/sAOG6do3bWawtt
	TdQPfadAlCRg+xnzNzOEGu8z7HGoQrOMvlb1gZbWVrxjLDd4cFX61uYgVnlYEvc/AHLwCOBZ/A9
	gjlczwBF1IfEgwcZyPJJfinkwN6Y=
X-Google-Smtp-Source: AGHT+IG5JQmE65nithUd9gPWobOGx0/wdLHMpZKHL5EDmk/X0iJLRv2GjUeuZ9m3ZtbUUM4Sp8hPEYcHGMBevld2lSc=
X-Received: by 2002:a05:6512:3414:b0:52f:cb5c:b083 with SMTP id
 2adb3069b0e04-5309b25a268mr2557766e87.5.1722127179445; Sat, 27 Jul 2024
 17:39:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvMr9YgvLds8_OCMVV6FOzuBUgwn8_X6Pbz3hq_oakSWw@mail.gmail.com>
In-Reply-To: <CAH2r5mvMr9YgvLds8_OCMVV6FOzuBUgwn8_X6Pbz3hq_oakSWw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 27 Jul 2024 19:39:28 -0500
Message-ID: <CAH2r5mt6n3-46_gS2GNVtrLj-CE4mCP60W3D_-y3QdZ6UKsgkg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mark compression as CONFIG_EXPERIMENTAL and fix
 missing compression operation
To: Enzo Matsumiya <ematsumiya@suse.de>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>, Anthony Nandaa <profnandaa@gmail.com>, 
	Jun Ma <junma@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Had to add one line due to an error in some configurations pointed out
by the kernel test robot:

index 0cc9c6abf840..3d0d3eaa8ffb 100644
--- a/fs/smb/client/compress/lz77.h
+++ b/fs/smb/client/compress/lz77.h
@@ -9,6 +9,7 @@
 #ifndef _SMB_COMPRESS_LZ77_H
 #define _SMB_COMPRESS_LZ77_H

+#include <linux/uaccess.h>
 #ifdef CONFIG_CIFS_COMPRESSION
 #include <asm/ptrace.h>
 #include <linux/kernel.h>

to address:

   In file included from fs/smb/client/compress/lz77.c:10:
>> fs/smb/client/compress/lz77.h:127:9: error: call to undeclared function =
'copy_from_kernel_nofault'; ISO C99 and later do not support implicit funct=
ion declarations [-Wimplicit-function-declaration]
     127 |         return copy_from_kernel_nofault(dst, src, count);
         |                ^
   1 error generated.


vim +/copy_from_kernel_nofault +127 fs/smb/client/compress/lz77.h

   124
   125  static __always_inline long lz77_copy(u8 *dst, const u8 *src,
size_t count)
   126  {
 > 127           return copy_from_kernel_nofault(dst, src, count);
   128  }
   129  #else /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
   130  static __always_inline u8 lz77_read8(const void *ptr)
   131  {
   132          return get_unaligned((u8 *)ptr);
   133  }
   134

On Fri, Jul 26, 2024 at 6:53=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Since some of Enzo's compression patch series has to be changed due to Da=
vid Howell's netfs changes to cifs.ko over the past two releases, I split o=
ut the obvious parts of his patch to implement the client side of SMB3.1.1 =
compression on write requests (see https://git.exis.tech/linux.git/patch/?i=
d=3D40414c6a34081b372e45c7ce5060a6d34779f6ba for the original patch of Enzo=
's) but left out the final piece of the patch (the calls from the write pat=
h).
>
> This moves SMB3.1.1 compression code into experimental config option,
> and fixes the compress mount option to require that config option.
> Also implements unchained LZ77 "plain" compression algorithm as per
> MS-XCA specification section "2.3 Plain LZ77 Compression Algorithm Detail=
s".
>
> See attached
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
