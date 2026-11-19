Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795088240;
	b=vwa7yLbK07yXRYVR2oXSGxBOAUJUJkt0joZxQqDeF6+tZW9bXC8VuYuhw6EhQZdB26/u
	 74By6kPPVhut587GwdDSik2m6/w6ckAotz+TwiDWSrvERb37AQnxsr3ywvEgMPCebJ1aE
	 dWJ0CrrnLQaQCdHwmL8F17dzy6QAzyEqLNGnSktINVvxWnh3CrohsZN5R4bl74XehgrOO
	 2Yoj/TLVPnCitU86jmbiNtUvRr9girpFMuZGFGdYf3FDHy5TDUSqXaYPKmF5cAw3Gbc+w
	 L7SjF3FurwZcZE55CBTKxOe3Z6FdXy7L1eC8k9oK+Pf7zzMnSDf3PA4Re641Hfxitcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795088240;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=rcqc+WTD9IhSKmFqP6R73mZ2Ro+j/JKdXcfJz00sz/A=;
	b=pvzuhnZS9fEnRtflJg887QmgsgcS36r3l7l/Rk58EZ3UQ/axaaEYXGm+srYzZeZfEuFj
	 Twuk8oDvO/gShHy1e6Tv7K7vNkthrU3RMuwOgpypIBlcus4PJkUpOTca9bRz63bUB1vyG
	 C2mJnQvGHU2fsaJ8BZJqXfn/oWpprQX7HABWl0npqucna9CEdfXc23f2PAftB4j5uLzST
	 4tId1RrMkdMSTFZKqE7EGNie8994lbHoXVrzHFfhKKFNSz8nro1VUrDTDMWPQDx+higH9
	 JVh70kY/twsNdC0kpBRId/FkGQDECm0MQA3d/Grkw/EWqJja0D8hSfND9PC9AZU6FUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOGWVJLQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA43606A33B
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 11:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oOGWVJLQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5BA1F000CE
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 11:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795088240;
	bh=rcqc+WTD9IhSKmFqP6R73mZ2Ro+j/JKdXcfJz00sz/A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oOGWVJLQMT9MROIPnXWFDxcv3oaPUNR2WPe+Ll8j0jzvaScGvNqyaM+ldHjR6d4ji
	 z/IesoVV0lESGfgeQhdoQBYDukAL7Wtn6MQjiLpMTe1Ec8vn33HxTNrmS4c/tIh3YD
	 HkDovWCXRcOR39ezWfIITSFy9CJpUDh9waYhNRHEmAfVVBsG/Id2L+dlQh67Pa8weY
	 LAamJ5FPJZCIUkuOxJl/0RDszHDdTKVLSBnkx5lMXF2hQFAzmNIJ+HPpZWq0JrFgY6
	 tP1N4xPK0SWsUFQuCqielT1c+8MyKoIwu9C8wFK+AEPcRTh1muMJFg2saCpdpd7MYn
	 kuT3br2QhN89Q==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so3724355a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 03:37:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFmK6OO14Y0rn6Qo9fxgGGfgY9nt0BFrDasdgG4qqUEZNeFP8JRhvfG/KC1knBJzR+hZU4Wt7czT6Ah@vger.kernel.org
X-Gm-Message-State: APuU4Z9MTpum17HK9eR5k9YUC1H8O18skg+1FHUEdzo3vOhQB42sMcHH
	2cIqMtBWkzO8AM/QuPogBwXDMRy4JEjfTqtznJNLtOdgTA3ws5OxBLHLCdZ6tvWQHy/ZWVSO3w8
	yElEsHUMzlgxfNnVvsTo07xVje1c+CUU=
X-Received: by 2002:aa7:d94b:0:b0:6b7:853f:5e9b with SMTP id
 4fb4d7f45d1cf-6b887f0d7fbmr3413317a12.16.1795088239018; Thu, 19 Nov 2026
 03:37:19 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119073534.118732-1-icb@fastmail.org>
In-Reply-To: <20261119073534.118732-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Nov 2026 20:37:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9FoDgXmR3nedUrjAJg8dYEUbKkO+E-N1U2a=wxn-EpUA@mail.gmail.com>
X-Gm-Features: AclHuK9osdHfklEjXswVGiM12TtcQ7-egTgsmLQIDqk_Uo_EuHbRQJ108BRcSQI
Message-ID: <CAKYAXd9FoDgXmR3nedUrjAJg8dYEUbKkO+E-N1U2a=wxn-EpUA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: build an inherited security descriptor with its
 own offsets
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 4:35=E2=80=AFPM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> A new file or directory can lose the access rules it should inherit from
> its parent. smb_inherit_dacl() sizes the child's descriptor for its SIDs
> and inherited ACEs but copies the parent's offsets. The owner and group
> SIDs keep their sizes, while the child's DACL can be smaller or larger.
> The parent's offsets may therefore be wrong for the child.
>
> ksmbd preserves the component order sent by the client. The Linux
> cifs client puts the DACL before the owner and group SIDs, so their
> offsets depend on the parent's DACL size. If the child's DACL is
> smaller, the copied SID offsets can fall outside the allocation.
> ksmbd then uses a default descriptor, losing inherited deny ACEs.
> If the child's DACL is larger, it can overwrite the SIDs.
>
> Build the child in owner, group, DACL order and calculate each offset
> as its component is copied. These writes exactly fill the allocation,
> so the checks on the copied parent offsets are no longer needed.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
