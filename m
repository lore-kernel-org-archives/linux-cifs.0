Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795657172;
	b=PcTMbj5FHXsuXr74avuCkzckkKLaFJTl9DTN67fE4t7RgshYUILz7OUDu9ADpUZiB0YG
	 OE58zdtCu4AtznMFWyP5gTm+xSrAJb6tBL5IrwA7O2o4X3IMMQchbLpzaDkDYkno9YPVT
	 MtYEsNtafVa8VMOq6fSF6p5OPwVIItLmkMUjnBjzLOcggCnk8iEF8xBvAp8ofzC5jLoiN
	 ZP3C+YrcRlcN/MglqsJnu/itGeyXCcZG++XXwKHMwJssTUPXslvdxbhwVY1Pwh/hDDDXG
	 /KpYUGiQNlRWZGNDbeVWjr8OzaglwLinLYLJu87qSX9td6VMnBtZe+0pXRLg3zaKS6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657172;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=PYvbuZCxMqyZlK3phM3rr7DPshNcBzk1sd7nqfu7sVE=;
	b=1gXzOS4wtTOcRdwAkmJVF2aTZ4Xd68eetnbfnY+Rfpsikd+EOWG65bOhKPVCx02CDKnF
	 ebl6spTX4E1OWlY+ykToUNNJCGg4gFMrcG5aymwZXgsJcgqktZu+YY2Vd4poaWY2xdveg
	 Dge1B3mP8ZAuwn201GsSVmtaYO5haKET1dwL1NF3chHDm1bOet+c0jGeNBgQAzawWu/Rl
	 L7kUnHBfPdOf0ciAfjlJ5W7D3s3X0pRFFd3MWM6ox9h/bZGOI7ORaBPhYW9F2KzlOgAWZ
	 IvhDdkF+OSAsWzfgaGBBFMSQcDnSY0eB7B1WIlXm8s19b4TgKvzNOTYJaM3kR9ecVSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JB2Nt+tB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E950B606A31E
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JB2Nt+tB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B6F1F000C4
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795657171;
	bh=PYvbuZCxMqyZlK3phM3rr7DPshNcBzk1sd7nqfu7sVE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JB2Nt+tB0czG+5/PQpa0sJruN9/Ka/8BGjCAmCCqyhuX3ReKBC7YJblJv4jDUECZ3
	 5MQnRJmn8YynusPaY+URYJlgowI1QgkdsIJIhsR30zVkK8M1cxUhc1MD6wZPWT/Dup
	 f5R69MkRNVBOKkb/x6iSW5CtGamLyQQo351wxrxO7JevZK8SNILikySTM4KX0nBzua
	 VuxkTI7kUhInfHKkP2Te/wX054GRUYSZJPy2LGYOFzwH+rp8BSYI0lCQW/sBLB0RgX
	 zhS4R/5tR/dQ3A97a9E+FvIKYj0YiSo0PmB4IsiJr/CjoAbeNRruR7tE3qIJSnzvsB
	 q88qNZ2U1LF/w==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4d581da0aaso900245266b.2
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 17:39:31 -0800 (PST)
X-Gm-Message-State: APuU4Z95majsFaX/9pPXqDDF/OrbrFv75BFstfrjR0fJYlYsRaIuGkwf
	tDWeeon+fD2HJvRhCIJRU8o6itLuLsM30uUKL8yOhymtf7OxnH/6G/aUysOkaSXj2tnlXRed/5z
	ZOKNUYIla4zJ7p5FuRI1QUQfb2mfPhGc=
X-Received: by 2002:a17:906:5593:b0:c40:91fb:b76 with SMTP id
 a640c23a62f3a-c513ab48008mr1257751066b.33.1795657170126; Wed, 25 Nov 2026
 17:39:30 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124132554.1185817-1-huiwen.he@linux.dev> <CAKYAXd_GDhds=X8OgLCU6f6MqtF4A-7fZiQz-829SWSdUKJbdA@mail.gmail.com>
 <ec609ac9-c250-4e38-a0d1-9f7ff5252436@linux.dev>
In-Reply-To: <ec609ac9-c250-4e38-a0d1-9f7ff5252436@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 26 Nov 2026 10:39:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8u3-nbvuqmW+dvawKH3+X2tosOt2h7nCdNKri5yVmC-w@mail.gmail.com>
X-Gm-Features: Aa3M54qSuU4vAj3EVDVo8NLRaYmL4pgXbdqloHBaguimbD5mhS-g5J95k-tMqoM
Message-ID: <CAKYAXd8u3-nbvuqmW+dvawKH3+X2tosOt2h7nCdNKri5yVmC-w@mail.gmail.com>
Subject: Re: [PATCH 0/2] ksmbd: splice READ payloads over TCP
To: hehuiwen <huiwen.he@linux.dev>
Cc: linux-cifs@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 5:58=E2=80=AFPM hehuiwen <huiwen.he@linux.dev> wrot=
e:
>
> Hi Namjae,
Hi Huiwen,
>
> On a single TCP connection, pure per-CPU makes the RX thread and workers
> fight for the same core.
>
> Pure unbound fixes that, but causes other problems: parallel workers
> still contend on srv_mutex and send small replies one by one, cross-CPU
> execution hurts locality, and under schedutil spreading the load can
> drop workers onto lower-frequency CPUs (on the 64 KiB READ send path we
> saw ~1.97 GHz with per-CPU vs. ~0.9 GHz with unbound). For serial 1-job
> QD=3D1 writes, there is no overlap to benefit from either.
>
> For example=EF=BC=88Throughput=EF=BC=9AMiB/s=EF=BC=89=EF=BC=9A
>
> Workload           jobs/QD   PERCPU  UNBOUND   Change
> -----------------  -------  -------  -------  -------
> 1ch, 64 KiB READ     16/32  2051.38  1387.34  -32.37%
> 1ch,  4 KiB WRITE    16/32   215.82   182.71  -15.34%
> 1ch,  1 MiB WRITE      1/1  1948.84  1109.46  -43.07%
> 4ch, 64 KiB WRITE    16/32  2788.42  2497.57  -10.43%
> 4ch,  1 MiB WRITE    16/32  3482.73  3291.34   -5.50%
>
> So I tried sending only WRITE requests to an unbound workqueue, batching
> completed WRITE replies, and only using the unbound queue when WRITEs
> actually overlap (keeping serial WRITEs per-CPU). So far, across
> low/high QD, small/large blocks, READ/WRITE/mixed, and multichannel, it
> performs better than per-CPU without introducing the unbound regressions.
>
> However, given how complex the overlap-detection logic is, I'm not
> confident enough in its reliability yet and want to see if there's a
> simpler way. Right now I'm thinking of keeping a few switchable modes in
> ksmbd and picking the one that works best in most cases as the default.
> What do you think?
Okay, understood. Could you share the patch for your approach, along
with the benchmark setup and results? I=E2=80=99ll review the implementatio=
n,
especially the WRITE-overlap detection, to check its correctness and
see whether the logic can be simplified.
Thanks.
