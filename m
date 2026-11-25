Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591779;
	b=BtHEwxxs2KjFdfnmI38KZ1yqqHASxo8/1pGljMKy9bjeyC2orvWYOtf3hzjPCxH401Rx
	 /mkl4Mp6mMm/les3v+DVckhZ6lTsWP6G0lx991lElyVarZaMlkPCbYIVWNWUAHgLdE0bn
	 HV/TPFIxbuuN1slmKOEcxN4d8YxGQzaGYN71/zXdwt6E/WnTKEVsnBfObDCCO9WRrTU2X
	 d3XWu93S7ev2nQsdy2FDr39NJMLNu+Prn6SaprbodSuq11KvP2RdL5z2Ln3SctQI7TNI7
	 GOyUkYRj6DA2zalRZE8GoVOE8TqTv6TX032+f6QYhBB+ODmjhRpcnqW6r5ej/YYmPYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591779;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=5ASMf0Q0IZoUjb7XIzBethXRQ2xxqpnfFXzN5Y72Ppw=;
	b=Q79+OL3wb7+vV1ArCHDo1Y58zL9xh4fdecizlw5MY0sKL+mmldUESQVtDQgQ2waRdjBt
	 W905HH0RhbxWz0mu/GISZIleJ9rAc1ISZnLN62DQ8XdvLHMF2fBl1AC0OVxruDwTj1N76
	 HWW3vD0l4AGxJV6W/uZ890IEeCRtOp4aPqQUcg2igexnQ/A2N1LKf4pX4ZVB/E/ZX6kDJ
	 BWWWAWLqoL5QKbop9csH+tOkwBQGtjCdITH9CNLzE81okWUcCeZqhgJ70Cqw290bQ/91n
	 pJM4uderY664siTBBSrTUB/iY5fstHfLLuU/48mCl/yENhplTiKGPE+/VTsSxRJHljw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMCcHfr9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2B606A31E
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 07:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMCcHfr9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0C81F00A3D
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 07:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795591778;
	bh=5ASMf0Q0IZoUjb7XIzBethXRQ2xxqpnfFXzN5Y72Ppw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NMCcHfr9lb2tDJVp7O3lXzn+N2X/1h+Ri7m73MjLjYJJU2supJjYQmC89wemQEmal
	 N9l58SKHTFV0SJKYHnSX2Pn70lTUS3mCujXs77F19zj7Tio1/hI8ljCSrVEPDqSB5f
	 rAjMGoFZvofkh8VhYqyiLEL2EIPTz0MVRnOUnFBtxD7xzkfuwKTfHVOvhwQoBzXjpz
	 /LkKxjmb8YdmoA2p7/XNDs9lRyajwaNacGBeSZl2BFISHl5W7X/8QOKL+xPDhCYvXB
	 RZJfPsRNCMzepDwjssIkv4kkl1+6bvFKd7x8xaj4M8dYrRCGGrJKolpJsjv/wIldip
	 7YdWTcZePmEmA==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c5133831027so771883566b.2
        for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 23:29:37 -0800 (PST)
X-Gm-Message-State: APuU4Z/axeTwwddUdGfIf+agoS0c/PDcTlMtdw689+jgN8qc/jEj7N2h
	pnGBdeV8D+2YOvFBahPym4D/kSawskcDUsvf3pq9NyxyTscjOf55Ge1KK+7oH5iO14Q7gVRWl82
	kkCRbB09iLV3JCor6OTy4CNZ8ZPlhZR4=
X-Received: by 2002:a17:907:9692:b0:c48:ddac:7eb1 with SMTP id
 a640c23a62f3a-c513aad95cbmr1357457166b.45.1795591776579; Tue, 24 Nov 2026
 23:29:36 -0800 (PST)
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
Date: Wed, 25 Nov 2026 16:29:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_GDhds=X8OgLCU6f6MqtF4A-7fZiQz-829SWSdUKJbdA@mail.gmail.com>
X-Gm-Features: Aa3M54rw8hTnZ1ZI6EcGEc4ZzgV5kkXbOTeOurhBS1FPtiz9jGd2ANQqnnoUyNQ
Message-ID: <CAKYAXd_GDhds=X8OgLCU6f6MqtF4A-7fZiQz-829SWSdUKJbdA@mail.gmail.com>
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
I don't see any patch using unbound workqueues in this series. Will
you send it to the list later ? or need to check it more?

Thanks.
