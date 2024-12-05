Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7670E21885A
	for <linux-cifs@vger.kernel.org>; Thu,  5 Dec 2024 12:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733402673; cv=none; b=qN9IErIRAowujhZ0CnK3x2tGwXg8beZ1J4X7OPFRidC4jtHCiZIpaxyjtoYKylP4Lwa1sKCEZaPsERptR9InJmwOSsxWK6TaA/4WBcHOrgF9XaEk5DC3HPBYGacYKArnZzEEbQ35znDTYSklSTgAxzCdH+X3tvAj18+s5EwPbAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733402673; c=relaxed/simple;
	bh=mbj3tA6sl7Vk32fHkqjKp2FkPuUEgaNrp+0S/v7qyhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HA7YO+y8ZIFivkKnMYolCfBj6zYdXRHyQB244CpOg5ljCxsoDP9dg/0HYV0k8/EEcZz452vHg4sFH2ruux4avGpg1rDTRnsQLKroILKQoLykXSXJ9WzyHBdJBtE8ToXLWetuIPbb5wcX+4zuoZ0YFbKCNcAeO0EYCv0AvkDv/3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DEK2uVYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DEK2uVYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23001C4CEDF
	for <linux-cifs@vger.kernel.org>; Thu,  5 Dec 2024 12:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733402673;
	bh=mbj3tA6sl7Vk32fHkqjKp2FkPuUEgaNrp+0S/v7qyhQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DEK2uVYmFe091B24v3R9/VA8hkLo7FXUAAA8LWrENCdHHPYpniwEQobjz+d5nfMMx
	 NAdxGlsP6a39NEoMoprnPH47KlM3d3NJ31fN6rsnd02MxDnQT9l1UYIHusEpxxepZ1
	 ztzk2UM9T8qkm3jwaRSEUcv5HhC6L2AEGelNwfPSTXVfrwUWNYrlfLPOKhDUIDJ2vu
	 4HI0K/27D6DzDhKz/CSrqW+oE4+8q13++dsD7G0lRWHqL+wgC4hFkTupbK7BdrbiBG
	 h6nuZCtaZ0cCu7NPr1YBTImqN3EW8X6WiVI7YbkrfVq+NvL16jppoYf6tmjR5olHzi
	 f11SHAKlDC09w==
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3ea369fdb0cso556537b6e.3
        for <linux-cifs@vger.kernel.org>; Thu, 05 Dec 2024 04:44:33 -0800 (PST)
X-Gm-Message-State: AOJu0Yw/aYB7f2GD00wRmiik8Un6jsTgSLp21oYuBCdUYBpNiHM9MHwl
	upKhq91K9UTpzfaVKr965HfeSTJ3YWDEwaB+bZv5V9X/A3wl/XCbWfoLIT71oPhUcma2Ow38/Wa
	d2xCEDU96L3tmr7z42oklGz1a2Vs=
X-Google-Smtp-Source: AGHT+IEi9iOg758RcM2KX9fC5G+3wLO39de4jgzIZqXwtzK+uoNxcFAsB9K7thEquFehMiAmRkjTsXNvlzSa6bSiefM=
X-Received: by 2002:a05:6870:4205:b0:29e:4ba5:4ddc with SMTP id
 586e51a60fabf-29e886a6dbdmr11002540fac.24.1733402672368; Thu, 05 Dec 2024
 04:44:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20241205023131epcas1p3adfaf05ab3fcaf851d90f2e314001513@epcas1p3.samsung.com>
 <20241205023120.792280-1-hobin.woo@samsung.com>
In-Reply-To: <20241205023120.792280-1-hobin.woo@samsung.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 5 Dec 2024 21:44:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ueDEbdt5ydhhpeH=z7L3r=2XgcYcmbaD7fNmosiDYCg@mail.gmail.com>
Message-ID: <CAKYAXd9ueDEbdt5ydhhpeH=z7L3r=2XgcYcmbaD7fNmosiDYCg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: retry iterate_dir in smb2_query_dir
To: Hobin Woo <hobin.woo@samsung.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, sj1557.seo@samsung.com, yoonho.shin@samsung.com, 
	moons49.kim@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 11:31=E2=80=AFAM Hobin Woo <hobin.woo@samsung.com> w=
rote:
>
> Some file systems do not ensure that the single call of iterate_dir
> reaches the end of the directory. For example, FUSE fetches entries from
> a daemon using 4KB buffer and stops fetching if entries exceed the
> buffer. And then an actor of caller, KSMBD, is used to fill the entries
> from the buffer.
> Thus, pattern searching on FUSE, files located after the 4KB could not
> be found and STATUS_NO_SUCH_FILE was returned.
>
> Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
> Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
> Tested-by: Yoonho Shin <yoonho.shin@samsung.com>
Applied it to #ksmbd-for-next-next.
Thanks for your patch!
