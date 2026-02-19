Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6F5334C08
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 09:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493054; cv=none; b=cM3q3BfJuQq1x1+c2OJxvWZxuTagtXbOCRAsSBNGjUAdYSoXYbic1OFQ+LorzrIW6lQJab/vp2wYu2tw+c5QwbPraggp1fagxj0Bmu5WwJMo031f9Y3R9YSWNteacikIB4jhmwEA4ql3zHSKl70Fs0QppBhzPRetvQJgFTa1Bqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493054; c=relaxed/simple;
	bh=7x4iJcrAJx0s0mdhi4aA1VWX8cBG3QA4CqCnflf0TaM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=QXJfBvTKjr8T5WAT5qHAYQDrlibWTbxlkjr1DefYMZSH7O1IpfMcuZTgDcrV7bgDxM/UTSX/FdAE1StLpCaa0ZcZ+aPZBC5bM7OBQFZFs3sRHrcAmvOgJpTPLkaQ2bdZpC9dFSYQh5q0bYql/mq+QAxzVDck2YK1h3EcEiFdgiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mk5QNlSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mk5QNlSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F0FC4CEF7
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 09:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771493053;
	bh=7x4iJcrAJx0s0mdhi4aA1VWX8cBG3QA4CqCnflf0TaM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Mk5QNlSVq7ZeCXcXBrnaWTnXTpEBPuIkdKoVj/254KX9ma0laGDAxM42cU+jUbS+s
	 DIJDD0/br9yZjcws7vgMd7QjiXGfDlxhQnHyHbpL3VTw8OzHr3NaGKa9pOYUIoCPJd
	 KX/DQUBtyZM5b4+FNO1rvk5zQR0jMV41M7OnMASqPKvoMXt4UuQn8sUT3P40yDNNV0
	 GZVUhmPwkDiYeL7xPgkxs/bmDkx5qXHT7vR5/7yZplXZTW/3eN+3iM2sFr91//caVq
	 KZ4ONS1ZWFMCKDTTrYcGsoWRb/84j3dBUIiyy0q5r8zk48Fp5pJ8RXhBgqp2tF9F4I
	 AFCh6NAjRE8Hg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 67629F40069;
	Thu, 19 Feb 2026 04:24:12 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 19 Feb 2026 04:24:12 -0500
X-ME-Sender: <xms:vNaWabUcj4Aqx9nItrl4czIWPhn8_OResdeqA8wQhJn4x4rLxaDZIg>
    <xme:vNaWaeaqJJmsesaxFxUUxAR6N5U-1Wdl2OF-dWkCWD10w_KDLVGV_mXTUlpaGtL_Z
    pp9Z8OOU3O17BfqmwyW7PKa2ydBlWTKAdgMpAbYFtP-MWeUgLQw6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdehudehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeejudffheffueetveelgfeiueetgfegffelueetfeevkeeiueetieejkeef
    ueeiudenucffohhmrghinheprggvshdqmhhouggvshdrshgsnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusg
    eppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthht
    ohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgvrhgsvghrthesghhonh
    guohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopegvsghighhgvghrsheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlih
    hsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqtghifhhs
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghrhihpth
    hosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqfihirh
    gvlhgvshhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhtrggslhgv
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrshhonhesiiigvdgtge
    drtghomh
X-ME-Proxy: <xmx:vNaWaS64zKkRvQhaNM4wCXInrk7mBmRvcZy3O0-GJa4-wT3LisAR5A>
    <xmx:vNaWaXyS8N5sSvspaCM7is8CG3TqLDxl3wmtkBthmQen6O9hfbZ2yQ>
    <xmx:vNaWaefhJHLJmMJBEgL7DuqFOar2e3PCt75BVdSotqPSZEe5b9PsAg>
    <xmx:vNaWaUAkzwzwun1XhrdCGxSumha3ZtmudVayj7zyOqUPz8l0hnV-fg>
    <xmx:vNaWaa4oFUIZH8U2AHQhIKYPHtakE0NUwPusoA5Ny-wiou4_xJBzfBPs>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 44524700065; Thu, 19 Feb 2026 04:24:12 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AlW4kGf5pqho
Date: Thu, 19 Feb 2026 10:23:39 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-wireless@vger.kernel.org, stable@vger.kernel.org
Message-Id: <21d30582-9cb2-4e7a-9aa8-36e16aa45ff9@app.fastmail.com>
In-Reply-To: <20260218213501.136844-4-ebiggers@kernel.org>
References: <20260218213501.136844-1-ebiggers@kernel.org>
 <20260218213501.136844-4-ebiggers@kernel.org>
Subject: Re: [PATCH 03/15] crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated
 as 64-bit
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 18 Feb 2026, at 22:34, Eric Biggers wrote:
> Since the 'enc_after' argument to neon_aes_mac_update() and
> ce_aes_mac_update() has type 'int', it needs to be accessed using the
> corresponding 32-bit register, not the 64-bit register.  The upper half
> of the corresponding 64-bit register may contain garbage.
>

How could that happen? Setting the 32-bit alias of a GPR clears the upper half.

> Fixes: 4860620da7e5 ("crypto: arm64/aes - add NEON/Crypto Extensions 
> CBCMAC/CMAC/XCBC driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Agree with the change but I don't think this needs a cc:stable (or a fixes tag)

> ---
>  arch/arm64/crypto/aes-modes.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> index 0e834a2c062c..e793478f37c1 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -836,11 +836,11 @@ AES_FUNC_START(aes_mac_update)
>  	encrypt_block	v0, w2, x1, x7, w8
>  	eor		v0.16b, v0.16b, v3.16b
>  	encrypt_block	v0, w2, x1, x7, w8
>  	eor		v0.16b, v0.16b, v4.16b
>  	cmp		w3, wzr
> -	csinv		x5, x6, xzr, eq
> +	csinv		w5, w6, wzr, eq
>  	cbz		w5, .Lmacout
>  	encrypt_block	v0, w2, x1, x7, w8
>  	st1		{v0.16b}, [x4]			/* return dg */
>  	cond_yield	.Lmacout, x7, x8
>  	b		.Lmacloop4x
> @@ -850,11 +850,11 @@ AES_FUNC_START(aes_mac_update)
>  	cbz		w3, .Lmacout
>  	ld1		{v1.16b}, [x0], #16		/* get next pt block */
>  	eor		v0.16b, v0.16b, v1.16b		/* ..and xor with dg */
> 
>  	subs		w3, w3, #1
> -	csinv		x5, x6, xzr, eq
> +	csinv		w5, w6, wzr, eq
>  	cbz		w5, .Lmacout
> 
>  .Lmacenc:
>  	encrypt_block	v0, w2, x1, x7, w8
>  	b		.Lmacloop
> -- 
> 2.53.0
