Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795867417;
	b=OBqb1S+jK9EDANsq/thlFnSDj817EZnuq4kuMj3TuvrmPlI4nZ7l48ILDhQ/SDRJ9oYm
	 IqSCZOKCoKRY82mfkzWNuQx/xjTKiC2DRK38xNAgduMGS61X2QuWvcdgxMP2r0cAs7alM
	 guXQ5CY8p1S/uv/R1E74awZrklPezYbT8NssuXhAXKAUr8oR2g/cj2Ir3HAkxdOqbKYm3
	 8sve+t2k/WmAg0YzsE09ourdE4miwu778XdhQ6VuWJffKLKK94YMuFTOrdfC3iISAGz9y
	 WmWvXPpZdTchPgHt7YgeUARLR7Rgpb/UAJHw0RR7W5i62E8VwojIMmG/08JcZ7XZBMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795867417;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3CB8SY7TGIq/K2qZ1+lG4WWd8xYqLibsrYuiHCxPx/Y=;
	b=vR+24dhzVyHwG67heeq8PauBXv6sh0LZR3ksnVtP9pCWyy4dkK1erSejWvejCG89nlC0
	 g8FjhVCX/1iyGxV4+WX3NGYsLxa35x8Pqkyc57slylZtMGXADHeqC6c9NkfNIM1rR2PS5
	 TVIHL36QVlvvwaLUmX86FCiuQdsOyRjWYt2/uflB5LHJpjC2HiwXqURvNlxn1+lpEcbws
	 NeXF/e6RwAeEmD0mC+K/7APDzT+OzWB8OvJ+c6mXxAh6tAaQxvYnRv9CnI+LVbE6oI4gO
	 wUbSBqUQgkZAUxpng0sE2SntmmlAiMuzhLEeAs8u5isnZ5amVq6HZ6fLS59dOAvdR1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nzxS7DML;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743C5606A31C
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 12:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nzxS7DML
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B501F0089B
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 12:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795867416;
	bh=3CB8SY7TGIq/K2qZ1+lG4WWd8xYqLibsrYuiHCxPx/Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nzxS7DMLntFvfM9fcGueyDEoS1Ir8b0+0CQlGoLr0SqrjBtoXvo70JkyOuhKlZd4Q
	 JQWTkuSB1G43oXltKjbC8S4KlY23NQ3qqn1jR7UTH7WKnkeE7XWd5uKY4saEydrSZP
	 z3CJK1qQP+A+R0s02MOgCBQeB0Z2Uj/AXFuAqyt2EnbP1VblBb/l4RDaHdEDVQYGMm
	 WO3PT/aCgculhzdBdjS98nC5inEZbr35LC0RHMJEJaJO6Q5CRNq2deOFUUA0aPQwqu
	 LBxeleoGqN+Ou1/xINWorRay5hbxeKS9Ij2p8aD2PpwGOrBDTr9TmKnFDEq7+QWv0u
	 b6xs5Zj0fX/Yg==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b87a240de3so11207019a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 04:03:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHsoFWWninuq3WL9Nz7+Kfrwz6sBWVYNCqCs7/UWTdCPGrF4HAhYp5PD0+yrqpOFv3oX4FqvCst3zFe@vger.kernel.org
X-Gm-Message-State: APuU4Z8prNMxmnFqYFTL4gZ1vDLVOYiyfqp19LWEuOHgnc5O7WetKjSO
	lI/l2b24N4UTTtyRlC1iZjwxKVHxqDVGthzWxAxAP7Leg8CkcP2l+HmwdTg5npCr1cUXzv0Dpsi
	lL6BPczrXd6bIrZz4XDjxfaN8QEnXLdw=
X-Received: by 2002:a05:6402:8:b0:6b4:2806:b057 with SMTP id
 4fb4d7f45d1cf-6ba37e9c5ffmr15019714a12.35.1795867415522; Sat, 28 Nov 2026
 04:03:35 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKYAXd9NSCsBsX3diAiKez1zE221+pZ62X+fcQZRxYx2xmwCvA@mail.gmail.com>
 <20261127222829.1664817-1-icb@fastmail.org>
In-Reply-To: <20261127222829.1664817-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 21:03:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9vYAHR9Ak6=Pe8=fn+HX3aVMX=z1odpbDc3dk=j+bLTw@mail.gmail.com>
X-Gm-Features: Aa3M54oO-XdqaFEZrMGaLBNb_K8Y_ZHPh_ekwQPhVDKAXtjhNtbFTRT8C912QY0
Message-ID: <CAKYAXd9vYAHR9Ak6=Pe8=fn+HX3aVMX=z1odpbDc3dk=j+bLTw@mail.gmail.com>
Subject: Re: [RFC] ksmbd: rework the DACL access check?
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Questions
>
> 1. Are the table and the rules outside it acceptable?
I agree with the proposed rules overall. My one suggestion is to use
the parent directory=E2=80=99s Linux permissions to determine whether it ca=
n
supply DELETE or FILE_READ_ATTRIBUTES when it has no current stored
DACL.

>
> 2. MS-FSA applies the MAXIMUM_ALLOWED half of the read-only file rule
>    to a directory too. I propose to leave directories out, because an
>    explicit request for the same rights on a read-only directory is
>    still granted, in MS-FSA as well. Should the rule cover them?
Yes, leave directories out of the DOS read-only restriction, as Samba
does. For regular files, please also match Samba by reporting the MxAC
mask before applying the DOS read-only filter.

>
> 3. For MAXIMUM_ALLOWED with GENERIC_EXECUTE on a regular file, ksmbd
>    lets the full set of read rights stand in for FILE_EXECUTE. Under
>    the formula the DACL must grant FILE_EXECUTE. smbtorture's
>    smb2.maximum_allowed.maximum_allowed expects the existing behavior,
>    so it would fail. Do you want ksmbd to keep the existing behavior
>    here?
No, You can drop the existing read-based fallback and follow Samba
here. For MAXIMUM_ALLOWED | GENERIC_EXECUTE, ksmbd should check that
the DACL grants FILE_EXECUTE.

Thanks.
