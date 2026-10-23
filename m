Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792719827;
	b=uC9GPxNE3nZoHH/x00MQrBV5xp47bdbrcZHoahO2n/fB8nSkwM5zSKQ6TkY1evcPmJIp
	 rS0pmiwdoY2gUGyxN8wg5jbRUCmmbsADHWUMs1RRwLH9ckrN3cLGRywwPe3bNzx/LbxL1
	 asCOQcS/GU+Lxnem+eMIkLYqJ22R9K/lCFPcAM/wWlgwNaAhT/AlBDyiPbQREJTjowYFX
	 QocBxbraWAJGXsMwUW1pIFmXEQZF3AyixItW2eC70FYCf13tu+3/qeWdfz4DWeFm+O4OY
	 pmcJ1ZQB2OGXT0tRSOmstsNEicpd/Awktzxb9JwxNxKn2FKDM+dFwiaXMW+zfMHIwzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792719827;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nJahHq/dhLGzw4vDnB7WcwfgTcni9/PlIZuKySAi6zI=;
	b=BHKfZ9tHk6BEdQhXXZTw0gA2LJucAgkCTRLUf+C7fJHYUeqGlIjhqUeSb5azajU4sjDF
	 mux72+IgBnj3gEP+b/eFlSeRVRpZo/5Hq2css0ni13r0SQL5hJmUlF8mVUmcPIVqDdPJx
	 dn+iuDzIhbBc2df3RN3dsANHDTM/5aR9F/I/4A+veYSdJhkDuxw8TiRgIvPq6kCNW0yci
	 sZfS508trBeO8oZN52ENBoKpZlkuGOyT5zDW9cgay4Vo5J+7QySzQ6XI7B9OZcjd2502E
	 zSRGvU5L6i6XQuP4mHvXJqrvcJ6xqy+V4sJ/DR/1YUhOE2YBuAyXPcPXHu9FdvREgcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pd9s3mED;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007B2606A31A
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 01:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pd9s3mED
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2141F031E0
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 01:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792719826;
	bh=nJahHq/dhLGzw4vDnB7WcwfgTcni9/PlIZuKySAi6zI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Pd9s3mEDLdz/jVlYMNdeg/clqF9G+mI+gDJq11DtNzJzfudPPA17LatNCvuJnqrk5
	 ndNN7H7MPskbJS6+8OUSkOgXgrQvQmOD5Lbsy1Qr0yIerMb213wFFQXhqn1aF5VuEk
	 /kPs5vc7OHSM6PwD05HwDGjZtppT2Ju53d4YL+nco9UBdfrUYOpkRVqRjo+RXD8XpV
	 jbjocFYzsVrgX5HXEkHQZyE0tNpczOHewmpplW+/Eo3St6mHDBjlwGQCghQ3LbIUko
	 QPTmoxA9yYVxwzd88+ZqfrNX6JUZR01drr+DxYETvNGjpnI5IGo7jfdZ6eS2Ythfcl
	 eX5vcIv1UcOHA==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b429f71dbeso320152a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 18:43:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzNhE2wMcz1TQmx8c/qZAj2FlZn/VdHIZurng8qNraNy7uZQMorKw7S9ElwzwVQ94SFm/PzgfCRtbD4@vger.kernel.org
X-Gm-Message-State: AFq9FYKYDOPv310QBlU+Q+ACb2RDzv9ZC78R724C1crHZvYYABIEgH75
	ZakJBRGKWE1cMaOcxr+wMv6FAo3FRcRqTzsPxpYRxC4fO99eSUmAj6rdgTtk6SMW3q6wg7tWgya
	QdWzywj0TI3wT2ZcJuCHqFRuIvqpWH2g=
X-Received: by 2002:a17:907:94cc:b0:c26:1649:47a5 with SMTP id
 a640c23a62f3a-c46a940913cmr117168666b.27.1792719825165; Thu, 22 Oct 2026
 18:43:45 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023004045.98484-1-mike.michalo@gmail.com>
In-Reply-To: <20261023004045.98484-1-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 23 Oct 2026 10:43:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-g779qGeZZ6_fBjwjxMtGmECirU4O1c2aEx91XAjhuLw@mail.gmail.com>
X-Gm-Features: AclHuK_BICgCSSlASk9GhD5kDurEaTe5s48oxtrbShSJzURVLsIRQ4yIHcc594o
Message-ID: <CAKYAXd-g779qGeZZ6_fBjwjxMtGmECirU4O1c2aEx91XAjhuLw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: select CRYPTO_AES
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 9:40=E2=80=AFAM Michail Andreas Michalopoulos
<mike.michalo@gmail.com> wrote:
>
> ksmbd allocates "gcm(aes)" and "ccm(aes)" AEAD transforms for SMB3
> encryption, but SMB_SERVER only selects CRYPTO_GCM and CRYPTO_CCM, not
> an AES cipher. With a configuration in which nothing else enables
> CRYPTO_AES, ksmbd builds but cannot allocate the transforms, and every
> session that uses encryption fails:
>
>   ksmbd: Failed to alloc encrypt aead : -2
>   ksmbd: crypto alloc failed
>
> Select CRYPTO_AES, as the SMB client already does.
>
> Fixes: a848c4f15ab6 ("cifsd: add Kconfig and Makefile")
> Assisted-by: LLM
> Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
