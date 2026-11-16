Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794831033;
	b=JfKfNQTQ+d6Vsc5rE8NIeN6J4nz9BqUIsq5XwPB6qtSOHB9/BG+aAy8ZFmDZJOrXv4Qt
	 vf/1jxx7ZvGT2WxCyhLih43h0fmpgN8epyqWYLFUkM8JksgVgYqB3kUVbhEEUeCByub1+
	 KrsK6ejYrcCz4pAtoTydlT9BMfIp4akuoprrhfchGc/apU9HtcW3bY1ORCxz76+mY54Wa
	 nS1vMoMNREwyFPTpeEVX3BAqlbEyVEUXIGeMIJSWAA6XfputZXcMlLN56fVQN8ImiPXZ3
	 UNiI7RucIpBvQ03+rG/73cQxdgy1F67U8UBmB5mB/l9Q60WS+Eb75KPKyk3ZDtitH4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794831033;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=yogqGq6K7jVQChJ/YPRwUkMOSfe+PhV20PoYhuNYLPw=;
	b=2k1Oh+F6gWLdTTiwmD56q0jovD9a7dsn4mGphY3UG1xF3VqxsBI6eEpJ2dfYYHWIAwuX
	 4jnqPdQBk6RKZ+vm6HnBPKMdHGi7z6iGOW2iAEeO6eXmAzBC3EJlw3jKQFJeo31teluJo
	 yGnOmPkj3R19BnWWcpkd9Z7TosuEPOF7LJYPDR5einjFSPw1xrM1kZKABYz7m/sYcxsXE
	 WzjlOj1hPbCo9qzW8pZpcN7lLUgcpK5MhAnzASjftEhUf5RqtOXq8Wg7vd5k3cOcZd8OK
	 HY22Z8qoqVayXp7KALcIzuWzLLJVawByoS90jjTwCD0k92jRhFBF9vKYVf04p+alNJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=laVHPMRv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44889606A31C
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=laVHPMRv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221631F000C6
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 12:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794831033;
	bh=yogqGq6K7jVQChJ/YPRwUkMOSfe+PhV20PoYhuNYLPw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=laVHPMRvx6oakQPHa8D9yynGmLvQU7CtRHDG3k5VsbLKnX6MVJYC16B1n7TEo4pO7
	 Bfpdt8Koa3ncyPTCCvCfR39R4WAo2jqevyID/eDj2Hpega6j85UEtJxMaDzWtj8Zv0
	 BMxxoZw2GS0DYgoCt27Ja4AqJ2yCd7H1xauCw83Yev2Au35h9HjzPD1i0y0Pu837Un
	 HxhSR+M1J0y1Mi/uCPY/oXY39gnjhxLFMStltd6P2wsG2qxPb6+KQk42bpnXnKjprK
	 Decv25C+QyD1v6AF/32O7JgzZ9cSgBJRgAHWrWT2ZvBkkmn/tEQaFsslZj7TBnhiZP
	 +Le2R0w3nJTJw==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6767d92cde6so3222826d50.0
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 04:10:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEiCx2FtzyVYAcVcl2qBhIFPPdL7BABcpIclSYsb7szMxn2U672DjKIpHxfrNnkLS0w/R/Jmsm3W4Yl@vger.kernel.org
X-Gm-Message-State: APuU4Z/fTFQ7+R9Gre18C+feSxKdJEwl7LXYROBry0lSM1oA3xF6LDZg
	9XPZvpq6rrQdcv3A4Lvl4McWLnNNVge0jjwPSdv7NKNbC1WWxm6cJ2dUbnjk5OCMZkDHRxpBPbx
	7NlUOvGSg5HUJZP4cE0WgbpKCLcpmjaw=
X-Received: by 2002:a05:690e:bc2:b0:67d:b274:39d6 with SMTP id
 956f58d0204a3-67db274406emr1915423d50.55.1794831032524; Mon, 16 Nov 2026
 04:10:32 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116074849.475815-1-stefan.chulski@broadcom.com>
In-Reply-To: <20261116074849.475815-1-stefan.chulski@broadcom.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 16 Nov 2026 21:10:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com>
X-Gm-Features: AclHuK-NMgDJ7sKrkDrwDOe1Jm6Lwdix0HevzR3vIhht9ZS3bSgXg6UFWRTgmyo
Message-ID: <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1] ksmbd: add use_unbound_wq module parameter for the
 ksmbd-io workqueue
To: Stefan Chulski <stefan.chulski@broadcom.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ilya Lifshits <ilya.lifshits@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 4:49=E2=80=AFPM Stefan Chulski
<stefan.chulski@broadcom.com> wrote:
>
> The "ksmbd-io" workqueue has always been per-CPU. Commit 69635d7f4b34
> ("fs: WQ_PERCPU added to alloc_workqueue users") only made that
> default explicit as part of the treewide transition to unbound-by-default=
;
> it was not a ksmbd-specific decision.
>
> Per-CPU work keeps request processing on the CPU that queued it, which
> is good for cache locality, but it also runs work on CPUs that were
> isolated from workqueue noise (isolcpus=3D, nohz_full=3D) and prevents th=
e
> scheduler from placing blocked or long-running workers elsewhere.
> Which behaviour is better depends on the workload and platform.
>
> Add a boolean use_unbound_wq module parameter. It defaults to false, so
> behaviour is unchanged unless it is set; when true, "ksmbd-io" is
> allocated with WQ_UNBOUND instead of WQ_PERCPU. The "ksmbd-break"
> workqueue is already WQ_UNBOUND and is not affected.
>
> Document the parameter in ksmbd.rst.
>
> Signed-off-by: Stefan Chulski <stefan.chulski@broadcom.com>
Hi Stefan,

Do you have numbers comparing the per-CPU and unbound queues,
How does this compare with the earlier following RFC ?

https://lore.kernel.org/linux-cifs/20261022092514.2590010-1-huiwen.he@linux=
.dev/

Thanks.
