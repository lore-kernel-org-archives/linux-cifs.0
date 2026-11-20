Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795170165;
	b=fSxFu6ZUrfwMghkZDlvy4oasA18bYQwIg6uBTWwFb354MaId6mHYspumOcPjSkA39/2D
	 XmLoWBkedBth4KPbsVh1ioCJ37KuD9VDzmDNknZuPbrsFPGo2nijwW/QSR2mtlRKoBYEy
	 hbb8vUcIHFaiszDaAkJ8HKF6r9zmtgeQBJMuPy2+TDoD+tP+VaGmhPqnVaeikpJfonK7X
	 Foq63FTcTTAfl6gpLaeAyuT43PQGhAgRClWWT/Gf/8iArq8jQGuXhARPtXbPNttuOPWv7
	 sMoT1RrFLTqrgWZ+zv5HmMBbG6QKT2Nq4BGCJ5nWKq+14gpvc31//pnQ36MYG0Pae0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795170165;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=E8EpAwpZYGj+7UCRgA7yP/4KDRZY1BSkeeABUDn2plU=;
	b=PEPQQPLWcZlaBdzCIeXtAGOec9ZKGxhx93GGROxxi9ks86NZAFLHkaIlmhZHgXuimWKy
	 MHkPihhVWyZncjDVT56ty+qA5OGY+Hcz6uI0D2Jo+lt9cQlcdb+FpKPOs59dLuAcNz1nA
	 Q9tam21Z28za53Gz83jSt9kgd+U/A4AzH6Z5HBV+ztLMuI+562rc9yUmzOlX9U7qXEh85
	 7Z6PsIp+MnNtkgbscILG2qi3eAqfitunFBMAzBFBsUsBcC17MVk/8qFYSsoFFmZfyXNib
	 KGdoLi5Y5/qol+iouKPO0ySI7j7KL5kSexTZDqAGIHiuALcHsCeR+YNCCvZ4dv6Gpsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MNhkhKa0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D78D606A32A
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 10:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MNhkhKa0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134A81F000D1
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 10:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170165;
	bh=E8EpAwpZYGj+7UCRgA7yP/4KDRZY1BSkeeABUDn2plU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MNhkhKa0HsFSZXmcOxmWejOqFoQUmhIzCs31quLsBUgZrIWPWoqoaoUQ5Y6AmKSlT
	 HGyuWZciDHf1IxQYcLEgnCbUOBX7V/IpYWPwVCupqAnVpAGTdYJL1VOxuBhAqUOa2p
	 aP2UwZlnuhmnfpkHUMp8OVvlGlOtY+jlb/Gg7w+9b8PJwz94E/jOKpWNuaEbP2TX9T
	 8VK2T/PrR5LfFlmcCaaHmUaNepQKIpXJ0WqHkN3NDvye5ImlQRqM7JvL4/cyqfIIIN
	 hE4FpGjZ33/XK6xp2mfWxXSEh6gih+dZiZRIJ7xbIlWwfEuxtjvow3Gmeh3m7wW2/t
	 wET7WXOkv3vYg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c445c95d553so105686366b.1
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 02:22:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEBGQtr2n02iDX2f64iBklc6vhQwPmtbHZBabHUySMkrArwKABRrCce/90DFwunarUKSyRl0DQLGnK9@vger.kernel.org
X-Gm-Message-State: APuU4Z9LVHMQUFhIZnC9xuDtzmseSnDkVA3sLFhlJCDd09Gc7RpbsA6q
	5AhHfbXwsR7a7Am0ov3oaN4B8JIMuTmjxommdCz3KDp1tgEVRdYQNGK82LpWXont2wcqXYMy3AJ
	6WbnV3F3oJBKKvgH+dQ0pw59PU7d0uSw=
X-Received: by 2002:a17:906:694f:b0:c50:ff1c:22be with SMTP id
 a640c23a62f3a-c513aace676mr189356766b.16.1795170163723; Fri, 20 Nov 2026
 02:22:43 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119192007.198258-1-icb@fastmail.org>
In-Reply-To: <20261119192007.198258-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 20 Nov 2026 19:22:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9sviaSnbKv1Fw_rGikGmd+KDDSVYvK3TLvAobOEamWsA@mail.gmail.com>
X-Gm-Features: Aa3M54qv7yG6VtpuGjo2-6Y4wZRz8JNdIfGNAaVL_Qd3C1dh9sJ8xtOrdZUCBbI
Message-ID: <CAKYAXd9sviaSnbKv1Fw_rGikGmd+KDDSVYvK3TLvAobOEamWsA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: count the ACL header when bounding the DACL size
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tristan@talencesecurity.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 4:20=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> set_posix_acl_entries_dacl() and set_ntacl_dacl() stop adding ACEs when
> their total size would no longer fit in 16 bits. The 8-byte ACL header
> is added to that total afterwards, so when the ACEs take 65528 to 65535
> bytes, the DACL size wraps to a value below 8. A POSIX ACL with about
> 1800 entries is enough, and tmpfs and XFS can hold one. The security
> descriptor built for a new file is then stored cut off before its DACL,
> and a query returns DACL_PRESENT with no DACL, which reads as a NULL
> DACL.
>
> Leave room for the header when bounding the ACEs.
>
> Fixes: 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16 DACL=
 size overflow")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
