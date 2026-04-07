Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE123AF648
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 11:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775563114; cv=none; b=CdjyuW4h1wv+aO9ayJHrNTN9J/TONkS3Y/clu5+jiL9J0UCF56EugIdYvAcig41uyOpESIaNl92Sg/q9fETpDcKaPqAzJtEq9XzzNpk/zC8iMkazIb9vwT8h1+rdoFVKOKS1V2SgnKDXGKsnrHK5NkPb/TdszcLgOEW1IE0wh8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775563114; c=relaxed/simple;
	bh=Wuo13rVo8Hfoq5ak0pjtFWAS+k16mCQJvnaOn57WTQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oZ2VGPcQHRKVP37esDq9se32YcNfYZjY0s1vFAanXTetXtqmZSUr3YL7AySpQF3H+HshyS3seqGhEaEcCoQwMIokJ9oq2EYY6HdcCMG0iJXYpeTDtg+aKo9PY1eVm9q6p5lNq2RVi3U5ebXTg20USzrw3ONlFY17k5GDVdAmraQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0DNsmTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0DNsmTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC423C19421
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 11:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563113;
	bh=Wuo13rVo8Hfoq5ak0pjtFWAS+k16mCQJvnaOn57WTQQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=c0DNsmTKF3x/5EhmLZzeOgP060BoGPIAL8Srr9MwDpsxzdX74EYGVO64LHccO3Gzx
	 Xz57ic4cNfuS4S4DxtY44W/1B2R1JbiTaeeLNrPCoYkkFcpFNF5uE2VAtTqeM+e5ml
	 Ql+dx3xgti3gPNJsp9Gj6eS71WUdGjkjJqkxI+qY6i4k5OKEhdRWyPmhbu65k0qtb0
	 S80k/HDK5PdUZptMq7Z3MdHw/xFgzbj7twXusK5ZS9+cIVmFxNfKfZexIflooHNbJu
	 V9ZHDa2T2Tnph+ZV1PIi5azmGef1wGRMCyb1/lvPEagiGjzojUfudY6cngRaHuOpdC
	 E06xqvSBBU8lQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9bff57cb62so798437666b.2
        for <linux-cifs@vger.kernel.org>; Tue, 07 Apr 2026 04:58:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWOMuITHyl8t4owXFZSjGgM3/oR5HOBf+xz5m8+jV9Xfa6IecpjybjnXwUuiNdWQi+7CXCEQspTnJ1k@vger.kernel.org
X-Gm-Message-State: AOJu0YyGAf+9pCi8g2/B9jnNX7yI9hrunaE2TJ+68cEsVSlFP3+a5ZE9
	1Wn9XT8ye7H8VMB3WC8wPpanNrhD870qiCHPs3/rlQ5H5k4zXHjqSMrPCCNURLJjCpYEuVtI9jE
	0w0AibEBIZQG9USNcM4YYlY4QxbC8Zag=
X-Received: by 2002:a17:907:2d26:b0:b97:6147:def1 with SMTP id
 a640c23a62f3a-b9c679aca0amr741753866b.33.1775563112415; Tue, 07 Apr 2026
 04:58:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407023112.51220-1-joshuaklinesmith@gmail.com>
In-Reply-To: <20260407023112.51220-1-joshuaklinesmith@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 7 Apr 2026 20:58:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_sg7DjjARDz-UZCbotDqzJDm3b6VyK5OLrnYCC4kBY-g@mail.gmail.com>
X-Gm-Features: AQROBzD_OkjnxcUqPRS7gu4qUzg0DhlVCFXCvGpmbtAs0v4uFAv9GQlnYrz8AQQ
Message-ID: <CAKYAXd_sg7DjjARDz-UZCbotDqzJDm3b6VyK5OLrnYCC4kBY-g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free from async crypto on Qualcomm
 crypto engine
To: Joshua Klinesmith <joshuaklinesmith@gmail.com>
Cc: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 7, 2026 at 11:31=E2=80=AFAM Joshua Klinesmith
<joshuaklinesmith@gmail.com> wrote:
>
> ksmbd_crypt_message() sets a NULL completion callback on AEAD requests
> and does not handle the -EINPROGRESS return code from async hardware
> crypto engines like the Qualcomm Crypto Engine (QCE). When QCE returns
> -EINPROGRESS, ksmbd treats it as an error and immediately frees the
> request while the hardware DMA operation is still in flight. The DMA
> completion callback then dereferences freed memory, causing a NULL
> pointer crash:
>
>   pc : qce_skcipher_done+0x24/0x174
>   lr : vchan_complete+0x230/0x27c
>   ...
>   el1h_64_irq+0x68/0x6c
>   ksmbd_free_work_struct+0x20/0x118 [ksmbd]
>   ksmbd_exit_file_cache+0x694/0xa4c [ksmbd]
>
> Use the standard crypto_wait_req() pattern with crypto_req_done() as
> the completion callback, matching the approach used by the SMB client
> in fs/smb/client/smb2ops.c. This properly handles both synchronous
> engines (immediate return) and async engines (-EINPROGRESS followed
> by callback notification).
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Link: https://github.com/openwrt/openwrt/issues/21822
> Signed-off-by: Joshua Klinesmith <joshuaklinesmith@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
