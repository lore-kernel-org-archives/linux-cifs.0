Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E2B2D8773
	for <linux-cifs@vger.kernel.org>; Mon, 15 Sep 2025 23:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757979756; cv=none; b=awmHnJB2uW7TE75tYLHzp6ZCtDT5uh+dnbCBe4aneYovm0cR15eg1pV1gpOA8HyFbBkVwS5INXGb9MfWePmRrzLN7qUMerphGiOwWwIsbL5+UDgxBD6qqOC3J7pHyVPeKwcX0HH8K/JP0slfUvGcg8HHwW2TFeLfSgoB2lUhRqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757979756; c=relaxed/simple;
	bh=HXzQIZEmMeH/acqnjvSvT2MwRAkEYEvOZGAgwTjIZng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jGNQSA9Iv3H6gc4yrSajMaVS9PinWCQc6ByBvPqwDV29DJ8UDOlJ+kBRS+yRwotlV47NHp7kzTytfH9jDPwe/P9qoddtd0l1Ysh3noiZiwEqvViqcdlLL55VVBAosozziD6/duD18yTPymgKtxK7GqBWEjL9f9NTZKqgQ/pmddA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y2MSDRTG; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y2MSDRTG"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-770db3810a7so23961966d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 15 Sep 2025 16:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757979754; x=1758584554; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGy8VoZwZW4eoBATjgdVtXsWQZtxkghMwLuerOAeJ/M=;
        b=Y2MSDRTG+TukYea9l00OpgRB/jmMCjf2g8n/aWokn5dmtHfEpwPdKcVDD0fkGamqaP
         JVD+S/WefkJmeC5KVbQGlNnN1RRNEHQGk2RLVXEOf/0IyZ+PwRniVujrh2Cm/lOSjiya
         GReXHuQdZpSO0EHn0pB+f8hx+56NaIy+wTREpX9DEqDOW5EWby7iffNWeA7o0gCrWSVb
         0Ba18EA38c9hzH2FOaZYngVERPdFg+TeJcQIDOsZl+EO6bffB5MrmOyn0L5+7GUW6aUu
         NeFSDJR185kN6bzM/MYhbGBGna4JqIv1e1UDQAD4WnHKWisXzM0k1mINXJCKYUb9O4CC
         PnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757979754; x=1758584554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGy8VoZwZW4eoBATjgdVtXsWQZtxkghMwLuerOAeJ/M=;
        b=fYzJved6w07MeUwQHei/Z7J5SfTr1M3GBt3h+2k1CuW+P9fduuWFRd8eCGZm1Wi/GH
         X9V7dEK0R4OCgC1snYHf6nTSnSscO8vzACDCMf6x83jFPlFlrTQrKV4YegdonkJISUmw
         We9Y9mcwpZIUjoD+nAj8NDrFDeeWYBNsI5O/H0YcfoL54/98Hf3RmnS5Bcca9aCniEhH
         xLzaqy8MCtw0+kcGHTUr6rAvXvlOLYd+g4JpLz9CQaI1raHwpFNXN2fQ5sy9Ktmd19oL
         P1OVd6l/5WHDatzbk1JIatFORhbcAi/XkZ5LqPkJP6g/Bir/klC/dcKZIN36UdFKun71
         /HYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdbtU1LL6KHGVCu+Fpz13E/8Vb5mdaa0CIUzCKemAm+iWoqTQ+najXffKsXXg0gHjIlRCJoLHupeXh@vger.kernel.org
X-Gm-Message-State: AOJu0YxkLT3NVafZsIKFVQ3BwD8yzhxJIvZZP/ItTRA/39tRaZwC11ya
	V3lbHinebrCy8ggxudS0pA3TAygGfQQ80cXoTnr8v706mDBrD+jjFC7IYBCLTT9AJB7hBwk92ZE
	H9l5CklLodwux+BE7fsGbaVaTDbZ882A=
X-Gm-Gg: ASbGncsVn0m/l4qQ428nzJJmVyjLRZRh7ujaA7btHkZo0mlrgmkWwdomHnFPJSiuB9S
	jOeUJrDWCCedvv4Gz+A6tLTCGC1+Bdt49i/UWRt8q+uNhatsUGgsXVtxNFt2NR0dniRW8ji8K6R
	t56lRV1CpmPHHTOts5C4X8Xu56/tATwxPWed96PGvmLTUBulPCU0naG8L41PUm7jCe5Wp/RqjTg
	WF4FW46xGaXdtq1slrdZtTfJ+YgQXwf2CH3Fg1HoT6QWhPjLiwiaX9Kwus+Edca8MO1P7Rp9IOA
	W4dF213wyLgKeQnggIS8YIY9QVyu
X-Google-Smtp-Source: AGHT+IFjfTcXJzJh/7ORSsr6YKSiTpYCKWeAiM6thVSA/HWC7288bJJeoN2DUrrdpELKhYQx7uP28iz08wyDGkrRyCU=
X-Received: by 2002:a05:6214:2a85:b0:782:9454:ac8a with SMTP id
 6a1803df08f44-7829454b102mr79326236d6.57.1757979753934; Mon, 15 Sep 2025
 16:42:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8da4d540-652c-4845-9feb-0d53eeb3b5ed@kzalloc.com>
In-Reply-To: <8da4d540-652c-4845-9feb-0d53eeb3b5ed@kzalloc.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 15 Sep 2025 18:42:22 -0500
X-Gm-Features: AS18NWCQiHh2MzzVDmZftbAEj8FB0pnLDmhp12pDlOe0LbYbvLqmAmO_LaC98cw
Message-ID: <CAH2r5mtgU+r6QM5xh=WwXyAa1xPmHQ0KMFxAdTiRPnTHj+_xjw@mail.gmail.com>
Subject: Re: [RFC] ksmbd: Deprecate MD5 support and enhance AES-GCM for SMB
 3.1.1 compliance
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> current code includes HMAC-MD5 (via crypto_alloc_shash("hmac(md5)")) whic=
h
> appears to be for legacy SMB1 compatibility.

NTLMv2 uses HMAC-MD5 to compute the challenge response, replacing the
weaker DES algorithm used in NTLMv1.   With long passwords AFAIK there
is little security risk if any in using MD5 in such a narrow case, but
I don't think it could be removed without breaking typical mounts
(with the move to IAKERB and Peer-to-Peer Kerberos, not just domain
joined KRB5 which has been supported for years, this may be less of a
problem in a few years as Macs and soon Samba and Windows will support
IAKERB and Peer-to-Peer krb5 as alternatives to the more common
NTLMV2/NTLMSSP mounts).

On your other question, yes these are worth investigating.  For
example the server should be able to support standard AES-128-GCM
encryption AND "military grade" AES-256-GCM encryption - as most
clients (including LInux) can require mounting with AES-256-GCM in
some cases, so not good enough to just support AES-128-GCM, but I was
more concerned about making sure the faster signing algorithm was
supported on both Linux client and server (today e.g. mounting from
Linux client due to lack of support for faster signing algorithm it is
actually faster to mount with "seal" (encryption) than "sign")


On Mon, Sep 15, 2025 at 6:07=E2=80=AFPM Yunseong Kim <ysk@kzalloc.com> wrot=
e:
>
> Hi all,
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
>
> Second, for SMB 3.1.1 compliance: The code already supports AES-GCM via
> crypto_alloc_aead("gcm(aes)"), but to fully adhere to the spec (MS-SMB2),
> we should explicitly handle AES-128-GCM as the default cipher, with
> AES-256-GCM as an optional stronger variant. AES-256-GCM isn't mandatory
> but is recommended for higher security (e.g., in Windows Server 2022+).
>
> This would involve:
>  - Adding key length checks and setkey logic in the caller side
>    (e.g., negotiate or session setup).
>  - Updating the negotiate context to include cipher selection
>    (0x0001 for AES-128-GCM, 0x0002 for AES-256-GCM).
>  - Potentially separating signing (AES-CMAC) from encryption ciphers for
>    clarity.
>
> Is this direction worth pursuing? I'd like to prepare patches for review
> if there's consensus. Any thoughts on priorities, potential pitfalls, or
> related work in progress?
>
> Thanks for your time.
>
> Yunseong



--
Thanks,

Steve
