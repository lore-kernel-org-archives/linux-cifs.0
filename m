Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167F0CA4E
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 05:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760591032; cv=none; b=HR7ScLkoEbJlgXq6Xcatdiap0ugMMnHcsYCHGuBYSaIw2GxDPbYnS7lfzu8YKpEEAi6mhhtxocZEfs2vaehME4Hw2Vu8P3Vy+cAKcCeBSNIRqkoQxDrU8++D85EcfGo181sYtnwnra4mo6P0idx09GRn4vmgi5WXA918ott0Qb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760591032; c=relaxed/simple;
	bh=XbNOMe4WEb74BHJ6N5Hs04lus3m+FI+k+2CKQNndKIU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MKP8Z88AFEU/3YX7Fo1iuKMrZT1emOnRG8vNppBKVzGeL748R12BQLOe7r+XDQHUgkA1121EK2LansfaOhPtqOwKzkCNBovyb4rfnhV3D5A+Q3WpYD5i5G4d3HmsDGS/Mb0Xqlc8iMDODIAC0nUMXWW7xJd+GsG/MhlLBD75KEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQ2XtwIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQ2XtwIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B373C4CEFB
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 05:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760591030;
	bh=XbNOMe4WEb74BHJ6N5Hs04lus3m+FI+k+2CKQNndKIU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SQ2XtwIOW5a496hDI5LhvC+pIL2pP3HCMNGllZWAx8DJvtDkPrUdLtg2padS2IUhe
	 pXDyYWOtPg5XPwBRl/NsqzQCRgxNYtajIfjxsq0jRcToFlKZU7+2/hQDegbRtGSNFP
	 7QyME+f2uQVGjh3ZED8+LJo6Ro+xYAuZWjhdV1vVGTO8+1az+Wo98teE211D2qlBai
	 SmEKfMkUSi367OIzsSzKeUgN50thrxrClA2+FdY4c+kkIXQCbBQHBaS8j3wik05A6S
	 yBJoyoHGMT6CquyaKbPrmz68DomgdyApOWj46HOeJ8dcLv8DKxWEb2Pm0mx4Qab/lc
	 aF6h9HWAUMfSQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b4c89df6145so46718266b.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 22:03:50 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyn+BCKaJTsH26LC8xc27hOUThro3JzrOfXLcbO6LBpwMbPbavU
	JSOzGgSUnLZgS00I/2amfw0bJXKeiVPo08vflbf8cTnw8xJQFx3wkH5Rb6KwemnMx1L8lWOGVPZ
	CdtDfn9Ju5A1sqKXnjTEq5n5IjkwFlIE=
X-Google-Smtp-Source: AGHT+IFzpxfaJt7i6obli67Opa1w/oEbET38t4nGIt4EeUTQd/GUGQ8+7gCRiLnd7tDeiWOapSwtCQ1xat87tumll9k=
X-Received: by 2002:a17:906:2a1b:b0:b57:3089:7f75 with SMTP id
 a640c23a62f3a-b5730897fddmr1679093566b.3.1760591029101; Wed, 15 Oct 2025
 22:03:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014231759.136630-1-ebiggers@kernel.org>
In-Reply-To: <20251014231759.136630-1-ebiggers@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 16 Oct 2025 14:03:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_TGeG3NJq_0-+1YUzaNf9c7swAKvkBoofcGrOXMZ50eQ@mail.gmail.com>
X-Gm-Features: AS18NWBYQoQ2mcTx3PfZzJqAvDUcqWD1yyifhPdmmDlwbizTMvXn4gcKgBk5DMY
Message-ID: <CAKYAXd_TGeG3NJq_0-+1YUzaNf9c7swAKvkBoofcGrOXMZ50eQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] ksmbd: More crypto library conversions
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2025 at 8:18=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> This series converts fs/smb/server/ to access SHA-512, HMAC-SHA256, and
> HMAC-MD5 using the library APIs instead of crypto_shash.
>
> This simplifies the code significantly.  It also slightly improves
> performance, as it eliminates unnecessary overhead.  I haven't done
> server-specific benchmarks, but you can get an idea of what to expect by
> looking at the numbers I gave for the similar client-side series:
> https://lore.kernel.org/linux-cifs/20251014034230.GC2763@sol/
>
> No change in behavior intended.  All the crypto computations should be
> the same as before.  I haven't tested this series (I did test the
> similar client-side series), but everything should still work.
>
> Eric Biggers (3):
>   ksmbd: Use SHA-512 library for SMB3.1.1 preauth hash
>   ksmbd: Use HMAC-SHA256 library for message signing and key generation
>   ksmbd: Use HMAC-MD5 library for NTLMv2
Applied them to #ksmbd-for-next-next.
Thanks!
>
>  fs/smb/server/Kconfig      |   6 +-
>  fs/smb/server/auth.c       | 390 +++++++------------------------------
>  fs/smb/server/auth.h       |  10 +-
>  fs/smb/server/crypto_ctx.c |  24 ---
>  fs/smb/server/crypto_ctx.h |  15 +-
>  fs/smb/server/server.c     |   4 -
>  fs/smb/server/smb2pdu.c    |  26 +--
>  fs/smb/server/smb_common.h |   2 +-
>  8 files changed, 87 insertions(+), 390 deletions(-)
>
>
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> --
> 2.51.0
>
