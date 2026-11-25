Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795643806;
	b=Emk2APlD59dsZMjyIuaKpJPGjOq4WE/Hl//pv0tGGVsaJUcJSHf2rFCtSYYcsYoxPidI
	 iPILzdqr3X2/MMSLAXIRCfkwGdX93n4L2w6TNYTYaK7x1n9fC4coizK1nAGDrvEutH4dm
	 bS/VfLK+IrM3YidtaJ0uoE9J9HWe66BMpdvgvBjYSqR+VXzIAguBdsI3xwYGXVe4viU/y
	 B4K+v3a1ltUy+TYdIUq25jiZZ18Y7/fwvJiw/CbZIKafrDo57AQrWauXVtymhxjmO571z
	 lQCmSX1Fy+hW+59ZulCekYIP6weomGSkwfwUKJcYJVH4B+gEymu74njR3vI+nNM4+Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795643806;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=I8yUuoDLOJ3cPHTfwwSd2xdm2DX+w/l6PVX4s7epec0=;
	b=TK0gt+DU7+2j1MrdFGuldIpPhns5TrXphHCtN8BzhwRjekdLdzrBBQZnJL+r/jAvCA70
	 9nl+6qz0lhSt/8y0KvcfP9iZyGY4HDhlf/iXk7j7DAXX57mrVMAjAcm9JXsQgwZnqXAK8
	 5d657E0evDPMTvEBvwZJbXViw/xVT+p84bepNjkEfyOuQxfmUjcXK0/Jir+BuPf0AyNWL
	 MJcZkvhb+EzQx5QaoOmqrJ4oq6tbW1gZn2KvfS4Er4+7Dj8ZYd3nvVV18txTGqxtkvFLL
	 3UikFISNgQBWesNouukQjJ1puAacNH8yxbmnBHvXBEXtUyfsOq68AgMqGL0fJiRnJiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nk9SjC1s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8CC606A323
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 21:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nk9SjC1s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB001F000CF
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 21:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795643805;
	bh=I8yUuoDLOJ3cPHTfwwSd2xdm2DX+w/l6PVX4s7epec0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Nk9SjC1sIjaD0EpBh6m95pPUBP8lysbj4Z5TrSpsb11kPrRXhHpfCv3saCIhyhnTL
	 PTjyooxFK0peAHW7dlMjHbVV3FR2xKSJ+hiPKVipB+yyAhw+xYL2wez5Ep3JChbyiB
	 gZgWUlCev3Edu/RWDnlOgNQXTXzCJRMzt1UBVI8Y6Lxl26BNypwWFn6NQpVUkxo2qR
	 JDXxP+LC8bOnJYy/f/Hc4wDy4kTJqdCaYtU0vwXOOmUDH2cT9G0azaPWdyV/XQ4X0C
	 9klqlhzZZnihnbcsqnLSZGh7x1xjMpehpf6H004FHWz3I5oV8o7d1Lvzzl+cHNlPZp
	 O2hh2KmVw8Gbw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so1057212066b.3
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 13:56:45 -0800 (PST)
X-Gm-Message-State: APuU4Z+FG/Y4aPOxvW8B6S+X9mog4OtdWUw11sNyfaPppBUhzqtv4Dih
	xDIqDRg5jtvHpZ5/aKm2Jsdxg0XYbSmAYdP6AQSoUVGItPJ4pScgY1SLgMt+XFHEFZeQvYT0/qW
	DzD0SW3hjxI/txA3FqaicHVzz2Ak8sXg=
X-Received: by 2002:a17:906:9e2b:b0:c26:2a2:b91d with SMTP id
 a640c23a62f3a-c513a39f13fmr1296237366b.6.1795643804341; Wed, 25 Nov 2026
 13:56:44 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124132554.1185817-1-huiwen.he@linux.dev>
In-Reply-To: <20261124132554.1185817-1-huiwen.he@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 26 Nov 2026 06:56:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd894Qj-Q5xiA7AC+vaPTeg4OxXyFUbUC24Pa6KzzQtDWg@mail.gmail.com>
X-Gm-Features: Aa3M54ouIX2YtgAqbDWgIvshMBU7JsEnaSj4IG7Ca4X2eMDy_dnjbMXq3wUyFr0
Message-ID: <CAKYAXd894Qj-Q5xiA7AC+vaPTeg4OxXyFUbUC24Pa6KzzQtDWg@mail.gmail.com>
Subject: Re: [PATCH 0/2] ksmbd: splice READ payloads over TCP
To: Huiwen He <huiwen.he@linux.dev>
Cc: linux-cifs@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 10:30=E2=80=AFPM Huiwen He <huiwen.he@linux.dev> wr=
ote:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> ksmbd reads file data into a private response buffer. TCP then copies
> the payload into an skb. If the reply must be queued, ksmbd also
> copies the unsent bytes into a queue buffer.
>
> This series uses MSG_SPLICE_PAGES to avoid those TCP copies for plain,
> standalone READs: patch 1 splices the initial TCP send from private
> pages and a header page fragment, and patch 2 retains references to
> unsent payload folios on the send queue so the send worker can splice
> them as well.
>
> Summary of fio sequential read results (16 jobs, QD32 per job, SMB3.1.1
> tmpfs; each column is relative to the preceding commit):
>
> Channels  I/O         Throughput change        Host Gcycles/GiB change
>                      patch 1    patch 2          patch 1    patch 2
>        1  4 KiB        -0.3%      -0.9%            +1.8%      -1.1%
>        1  64 KiB      +28.4%      +0.9%           -31.5%      -5.9%
>        1  256 KiB     +60.8%      +5.3%           -40.5%     -22.5%
>        1  1 MiB       +51.5%      +9.2%           -33.1%     -32.2%
>        4  4 KiB        +0.2%      +0.2%            +0.9%      +0.2%
>        4  64 KiB       +3.9%      +2.6%            -6.9%      +0.8%
>        4  256 KiB     +12.1%      -0.4%           -43.0%      -0.8%
>        4  1 MiB       +17.6%      +7.1%           -39.5%     -34.7%
>
> Huiwen He (2):
>   ksmbd: send READ payloads with MSG_SPLICE_PAGES
>   ksmbd: retain unsent READ pages on the TCP send queue
Applied them to #ksmbd-for-next.
Thanks!
