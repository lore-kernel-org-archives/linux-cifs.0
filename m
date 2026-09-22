Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874DE36A03F
	for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2026 01:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790040668; cv=none; b=emwtMixyULBjcDeCPt2Kq76jIxtEhHnVB010jKhlQ6N1rpXPhqBqN/N/OcSyEpZiwO9dDctoKeX4XuJISpe+4unN+w01hptWGtSZ1QEIx8eW0h0JoFO7IX8MLxKO9oUJPggKwRPPPNSXWgsGi7gInNhEYOWSHOLfDHnwYLlIklE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790040668; c=relaxed/simple;
	bh=efk3ZirlziI/LThNa4jecb5ywGEkb9gRmunoJG1cryI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mxHwXcTTVRq2uf2SfDyIyb6caxNe0SU7eRw0reTufUg0gvaKy0Ridic3BeZR+XZmvsui8LNNf+wi9vcXt92mzx6brtqem30zTN6EUENrwElAlwgTiKnFifHATg4p11Jrr990RjQbhc+WHvga+QAuEXt47ozrEmEfprMs4Ttrm1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZsrDcv4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZsrDcv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D14D1F0089C
	for <linux-cifs@vger.kernel.org>; Tue, 22 Sep 2026 01:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790040667;
	bh=Ox81vjx/oDplgH9TE7Sigle4Z1vESmuvwoSMbL/ZP5o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gZsrDcv4PGN7qGlvxiX4MopB/lTm9Y4+3ZgTRcuEmHmjFJ5k5lDoyLbcgv8Or5lrr
	 JArb8yI1k8vv2jwh0RSR7yyWzTaZBRYhEQL0W4g9bHrbFI0y0WSD1qZMO1Y5zwycx+
	 WBMVCholckopPRdfLLqf5cGPiMdDNRj4OxMcXPKkuvIpkqsHeYbpC0nldN6nbNOsCl
	 IZf//U7OeKsdCH8Na9PHxEdKFQg1hFWfvQkiOiAHm0qVknCim9VBceOlpjoCsOz9ap
	 x0qgrhUYU7GVotqGHvOU7dSXmggV6Na5aGu0Sdye0b+MBpp+XwG5ntGrnVCTeU6T5R
	 +F8+7E0dVNAgg==
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2a1a631f6aso424886266b.3
        for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 18:31:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwhIXOfOaR7pu6o/dlTYo0CQBapnBie/Md+y8+WvorOvpzTQAvG2PnwBCJ4fiGEx44lruqe+27E3+Vn@vger.kernel.org
X-Gm-Message-State: AFuF++k7MviKb1mF138NIfCXjQYkA3vCvCp0CXOybLQdfZtat3gDxs4A
	y/JgoAvdavpeIotXGIVOKlpEw2ktydsiPCwnapMvCu4WhbiyZqhZOy2vu2prks/hWh8M4o6EEjo
	/SNg+NFTOExGp4O9DJ6/xQohuYmVvGck=
X-Received: by 2002:a17:907:94d5:b0:c29:3a1b:ec91 with SMTP id
 a640c23a62f3a-c2a156d9481mr1102498966b.20.1790040665816; Mon, 21 Sep 2026
 18:31:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920181503.2830435-1-Jeremy.Jean@oss.cyber.gouv.fr>
In-Reply-To: <20260920181503.2830435-1-Jeremy.Jean@oss.cyber.gouv.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 22 Sep 2026 10:30:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_=1S6GP6e9Py+GopcUOGQzGSHYrMqpw=7=VSnJ1P+s3g@mail.gmail.com>
X-Gm-Features: AcwNN1V7kUn5wqRLPyFDy7g4XdXxCIsa8mszFJodO-7GKdZe9B9ErTVlqAh_dP4
Message-ID: <CAKYAXd_=1S6GP6e9Py+GopcUOGQzGSHYrMqpw=7=VSnJ1P+s3g@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix SMB2 CREATE response buffer overflow
To: =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 3:15=E2=80=AFAM J=C3=A9r=C3=A9my Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>
> smb2_allocate_rsp_buf() uses the MAX_CIFS_SMALL_BUFFER_SIZE
> (448-byte) buffer for a single SMB2_CREATE response. That buffer also
> holds a 4-byte length field, which only leaves 444 bytes for the SMB2
> body.
>
> The AAPL response made this buffer too small. After 8f1b796ff113, a
> request with AAPL response contexts may need at least 456 bytes. In
> the 456-byte case, create_aapl_rsp_buf() is appended last, clears 128
> bytes, and writes 12 bytes past the allocation.
>
> KASAN reports:
>
>     BUG: KASAN: slab-out-of-bounds in create_aapl_rsp_buf+0x31/0x6e0
>     Write of size 128 at addr ffff88800370954c by task kworker/0:0/9
>     ...
>     create_aapl_rsp_buf+0x31/0x6e0
>     smb2_open+0x58f9/0xef10
>     ...
>     smb2_allocate_rsp_buf+0x19d/0x370
>     ...
>     The buggy address is located 332 bytes inside of
>      allocated 448-byte region [ffff888003709400, ffff8880037095c0)
>
> Reserve enough space for any fixed CREATE response KSMBD can build.
> Store the required allocation size in the per-dialect values table.
> This keeps the small buffer for other commands and avoids using the max
> transaction buffer for every CREATE.
>
> Fixes: 8f1b796ff113 ("ksmbd: add AAPL kAAPL_SERVER_QUERY create context s=
upport")
> Assisted-by: Codex:gpt-5
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Applied it to #ksmbd-for-next.
Thanks!
