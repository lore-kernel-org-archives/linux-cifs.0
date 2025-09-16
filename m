Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B4C29B8EF
	for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 09:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758016086; cv=none; b=Y0XyTOwgzzTtE97inVnOnCQ7hxUeCKdCJ16VC4RrctbK25l3hMbsKbAtT+fwbsfSdhV1mxQUqo4gSEbu4xgDh1tn/mZZtnt/wcvstUrTrvEDN+szAF4MpYvb03noCRCclkRCcX3hSDak+/L3SgRGOJesP549blvJ/nx1wSFCZ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758016086; c=relaxed/simple;
	bh=T+Vf2dDOixMwZJgqQOACk6vB5Gd3gpAlFSucc0OqV4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DZLb9nVOc5YcMpCI+LLmbVkjUWhNKlwsUTFcsN/KFW5vgZ9IjQjuDi5t7GgDl12UFfSHid+aSFVEKyT8NNkYiAdmtnWc0FSfLggxvU+NhRHMe6hK+zG3MZvsqMkDV/j1p1f9DX2s2f9cJBeeR0hk1wROd134my959T5M6MrYuw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYQz/4ja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYQz/4ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529DEC4CEEB
	for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 09:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758016086;
	bh=T+Vf2dDOixMwZJgqQOACk6vB5Gd3gpAlFSucc0OqV4s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AYQz/4jaHc01xp0lHsYgtxa3o3ICkaIKfmv9RTdYHBg/osvx3Ztfw3XUoEwCUd+cQ
	 SuLctIuU6M1dxqjgBzU/6qCFGqOd9kr+4ipi2+d5ehmlRcFfVzSdeTQQnIpatOn3s7
	 0bRpLiiAQDg2xBeAHYjbKgzey+Pwz2f7mMCrGA+dvY3CdubV6OiRK6uQ+t2wFr5O2O
	 0bAGH/29s1xS0T6bXHG4djHdx/8D5elIXSWzjbGuJvh12QNKZ+jpGKP0YbuRd78Ly1
	 oRBL+p7MKKGVizSTlj0yB1kCDxbE9hbk15thxkSzmRuj69TDLV4llwPbu3JCBKEHQv
	 2o55s23PlVCFQ==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6228de280ccso10472581a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 02:48:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWPWN43x7xJVdBi4VnmuYB4BpfNAki2tL/yY3jYSDfJT3GyoErBZSlmx9A8uwC79BhtAKd52gVTgAl5@vger.kernel.org
X-Gm-Message-State: AOJu0YwUfIqtuH6QXfYzSE6OhexfX/f6CLbp/HBeuB9wXcPFn49N/501
	VC0mZKelWlf9TDycsDQ9em4LjwBuk8Dq0+QNq47NACFJj554YqiDqZMwkD75pT/GNLOgqZTh32x
	o1PJsxg39E0Ae/YGlb3SuU7KiVkrDgUQ=
X-Google-Smtp-Source: AGHT+IG5MpzkyHuBeYurcLYOABwn+9j18biIyZwShzF6P5WhNTG6F2NRQfL2YCbVZrlN0DmxOAZaYM3OsJVbJ6d5aS8=
X-Received: by 2002:a05:6402:274e:b0:62f:50cb:764d with SMTP id
 4fb4d7f45d1cf-62f50cb78aemr3983894a12.1.1758016084874; Tue, 16 Sep 2025
 02:48:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8da4d540-652c-4845-9feb-0d53eeb3b5ed@kzalloc.com>
In-Reply-To: <8da4d540-652c-4845-9feb-0d53eeb3b5ed@kzalloc.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 16 Sep 2025 18:47:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_ZG-ngCCtnG_Uxm=CHkWS6x+=JzM9TXpxGUiH-A7j1TQ@mail.gmail.com>
X-Gm-Features: AS18NWC8XScJsd_6-4oai0r4YYqwaLwcCHqfar6YXOpp9Gi5A1u9ol828uKaJPc
Message-ID: <CAKYAXd_ZG-ngCCtnG_Uxm=CHkWS6x+=JzM9TXpxGUiH-A7j1TQ@mail.gmail.com>
Subject: Re: [RFC] ksmbd: Deprecate MD5 support and enhance AES-GCM for SMB
 3.1.1 compliance
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 8:07=E2=80=AFAM Yunseong Kim <ysk@kzalloc.com> wrot=
e:
>
> Hi all,
Hi Yunseong,
>
> I'm looking into contributing to the ksmbd crypto module, specifically
> around crypto handling in crypto_ctx.c. I wanted to send this RFC to gaug=
e
> interest and get feedback before preparing patches.
>
> First, regarding MD5 support: The current code includes HMAC-MD5
> (via crypto_alloc_shash("hmac(md5)")) which appears to be for legacy SMB1
> compatibility. SMB1 is widely deprecated due to security issues, and MD5
> itself is vulnerable to collision attacks, making it unsuitable for moder=
n
> use. I propose deprecating or removing this support entirely, perhaps wit=
h
> a config option (e.g., CONFIG_KSMBD_LEGACY_SMB1) for those who absolutely
> need it, but defaulting to off. This would align ksmbd with security best
> practices, similar to how Windows has disabled SMB1 by default.
Steve answered it.
>
> Second, for SMB 3.1.1 compliance: The code already supports AES-GCM via
> crypto_alloc_aead("gcm(aes)"), but to fully adhere to the spec (MS-SMB2),
> we should explicitly handle AES-128-GCM as the default cipher, with
> AES-256-GCM as an optional stronger variant. AES-256-GCM isn't mandatory
> but is recommended for higher security (e.g., in Windows Server 2022+).
This cipher array in SMB2_ENCRYPTION_CAPABILITIES is ordered by
the client's preference, with the most preferred cipher at the beginning an=
d
the least preferred at the end. This allows the client to signal its
ideal choice
to the server.
The server chooses the first cipher in the client's array that it also supp=
orts.
Are you saying that the ksmbd server does have to choose AES-256-GCM
if it is not the first cipher in the client's array ?
>
> This would involve:
>  - Adding key length checks and setkey logic in the caller side
>    (e.g., negotiate or session setup).
>  - Updating the negotiate context to include cipher selection
>    (0x0001 for AES-128-GCM, 0x0002 for AES-256-GCM).
I'm not sure what you're trying to change. Are you trying to change a macro
defined in smb2pdu.h?

>  - Potentially separating signing (AES-CMAC) from encryption ciphers for
>    clarity.
>
> Is this direction worth pursuing? I'd like to prepare patches for review
> if there's consensus. Any thoughts on priorities, potential pitfalls, or
> related work in progress?
Could you elaborate more about the 3 items you suggested ?
>
> Thanks for your time.
Thanks!
>
> Yunseong
