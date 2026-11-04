Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793757183;
	b=e1iYF+B84aJomsqw4Vk//3trNyHU+RotiRi9mZGvuVLiIkRvs4HIhbkTbuY1FqHQ4+g5
	 13U9FyClLg0FuK9EkMM+GIPsHqx/RjOpKNn+vzTRJt4VgO5GFA0eIbDJW5GPb2pzjJB4G
	 0CZbfexmjpmTtXE62NN0VSFPD9mtcyk8RtCDm5mxHdgWt0ByNsQCaBG9sy7aDBjpwbndk
	 Tsmkw2je7KPPc+kNbNw/PA3eXM4WPbKpM2ffFpeQTLX/XpLSdBrNvYwQdDzkG7lnu2LvT
	 ym8txgrea2IaFm70FCqYHec0BME/cpzzq2jI7KH9SzJ1JViI2z+ZVSg++j8ankW+09g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793757183;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=GQ4mEHI7sQjBBaEIricpvMN6RFFxM9rPq7clRjSmwKg=;
	b=xZt+A0/KTGK3JbtnEnA637hKjF0VPNCYLc3VL2vNvZ6dptJbNFlRs75jJ8dapA6kYtym
	 6TtYevX4WKcjNjGQQS90Gq6OncdkGXElUl6aTYJXPJEMsZw2flTT0sStnjSTdizLh7ZOC
	 V+hfkBTISOiA1XZLopeSo1OfaOZu+u+zjkmcdthbQV5lTLiZeJhhJoKRxfUBIEMI2v5GM
	 XcLOXR5v/YBTdXYWS7V3GZ+BsgxHMCzgYQFixfhVlcZ2SlqTSAUy62ViZQaBgaZvyqrSm
	 yDm8N7zC2a8oelnpHghBaxmWf3Iv+VU3pTLYM7B8zU9FpFO3e+aufTzb9JqHJ45InhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMKkVY3s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5299606A32C
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 01:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMKkVY3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21A01F00A15
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 01:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793757182;
	bh=GQ4mEHI7sQjBBaEIricpvMN6RFFxM9rPq7clRjSmwKg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NMKkVY3sFk5NieJ/HJQbEnMH0jt5LRjMXJGu/Nhi1+qt6+Hiepsyn1pZcY9uBWNnb
	 29IF4NE8GU83KH5MZHx6nKGUfU9kP8Fch30m6xVAEbZH2gsEP5CLltbd73u9lG8nMN
	 6hNpTQRUKxx2EQoi0Hv6xBsq+/35qz047oSuv5jE+jbH4GL/oCuJYt9MnkvVMQ8XG8
	 BN1Lj4xrS3De06nISJmQ24Uu/5lFqYk3WisKQU4YifirKKVmC45qFYvNVH7fRG6uDJ
	 kfDPyem7anvLkd7BsoB3ByY2Op0KyD7LvdYPTcj5W6TdsPieLxY/ENOp+yiQOTnGNs
	 EdfsJ6K2mc1/A==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4697404c2bso24633466b.2
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 17:53:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw2e0UW/WIzG44nGZe4GJU4VjR3QaXOdGI9zHmQk6u3ZmQYrSb2ssvnGOe8Hst8VgfPyqlT+CdlEZsD@vger.kernel.org
X-Gm-Message-State: APuU4Z8MBc4GS0NTvflURBk6+GzWaEwLdQScxVDRXKnALP1tl1gg49ta
	/sxnIvWs0KbmzkjiGNSLG4j/myazHzxAaf3YihydaTyCf12UrVFon8SydzDrTuWJZCNEKHI2ZDc
	1n+EgIOlLRcnM1trXqY4qJU0eWXOOoiU=
X-Received: by 2002:a17:906:ef06:b0:c41:1e13:8891 with SMTP id
 a640c23a62f3a-c4ca7a43c0fmr1236027766b.9.1793757181430; Tue, 03 Nov 2026
 17:53:01 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103110803.2517085-1-joseph.qi@linux.alibaba.com> <2026-11-03-1-daily-reply-0014-re-ksmbd-breaking-cnt-leak@kernel.org>
In-Reply-To: <2026-11-03-1-daily-reply-0014-re-ksmbd-breaking-cnt-leak@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 4 Nov 2026 10:52:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd__FvF-bCzzq_JHFqCF===_qrVZC8RLjrp4nh1s8sXq_Q@mail.gmail.com>
X-Gm-Features: AclHuK8LuxqZ51cFZaXEAg-WEfk--Vr4t3lFrt9KWk0uDBpkuGwjwHPpOGXYZf0
Message-ID: <CAKYAXd__FvF-bCzzq_JHFqCF===_qrVZC8RLjrp4nh1s8sXq_Q@mail.gmail.com>
Subject: Re: [PATCH 6.6.y] ksmbd: fix breaking_cnt leak on early return in oplock_break()
To: Sasha Levin <sashal@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Steve French <stfrench@microsoft.com>, stable@vger.kernel.org, 
	linux-cifs@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 11:52=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
>
> > For leases, oplock_break() increments breaking_cnt before calling
> > oplock_break_pending(), and returns early when the pending check
> > reports nothing to break
>
> This is a stable-only fix, so I need an ack from Namjae Jeon on the list =
before
> queueing it. 6.18 and 6.12 have the identical bug and this patch applies =
there
> unchanged, so once it is acked I will queue it for 6.18, 6.12 and 6.6 tog=
ether.
I agree this fix should be queued for all three stable branches.
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
>
> --
> Thanks,
> Sasha
