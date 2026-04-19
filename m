Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA041B81CA
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 08:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776586598; cv=none; b=fSm+gnznofQiOqBAEwlpHT3h1kzKhfIdBxNF2alcewUpJcjsKKQcAoHMVJOmWq0E1YSU13syu4RKDyj8Z8Or1lMuEcVZyBCLFX0xhuUEdo+lG2PlzlYqevKMWwKOLkvQmf6SCnBfMt6vXk6Fuj8GfxJQ7+Knoa6H6hbsuj9cinE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776586598; c=relaxed/simple;
	bh=ZAd+IFCa9tZH5vzsuiUNeNba8lEtkX8vemyuywiscs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i7QrhcHyLv7RMF9C7W+HnBDeuiNEgZmxczlmYR/tvAsWQrirYASyfvQGp9NYunfaeh0d8h5uX7oNimf1MD28fb9t4y7HhIWA3dRfIa2NAcYlliIWF4uw/eqanm546uUc686oSt5K4pgl/udQ3z93ZCpJlIOC3UVwgDY94jwGtbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATjQnqa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATjQnqa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B45AC2BCB5
	for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 08:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776586598;
	bh=ZAd+IFCa9tZH5vzsuiUNeNba8lEtkX8vemyuywiscs0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ATjQnqa3/boYdJ63gWBAI6DpeXnJ1Ha6sGbcmc8hs1oklqwpL6t4jWxI0f0f4+Q2P
	 u3GnkaGF59e8QeStNmXilPFvAgZ7y2SB5JzUE5SmMldmHsZj/7troSe0xmiizcw8W0
	 A/Fue5MjjgRkBH+brXtSHl5KjEm4j9DJhTKDcApVCRHj8Uhq5wJnPxY38y/MOpZho2
	 x88WP2ezvSZP9tmzxbx2xFfsDxT25nPyKfiWYAEj5KTH2/p0ULb30iwJ32eZZxOD+q
	 Pfj4tUsmOloGwe4l3hTpI95h4YP7fbvp/Nx+jS8CNiVNfYELaUnea3eMBq3wdXnHiK
	 0ul56XU8A9QJg==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67482e67171so1291505a12.1
        for <linux-cifs@vger.kernel.org>; Sun, 19 Apr 2026 01:16:38 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw0CP8Xl+VsUsnrXdq+PAg7btPbb0zVLy3ohkFe3Hg8+IZuUxdA
	p2qqYz9Uatk/fkcQuXL5QvTwlwz0cFX3TkqCdGpwQaz3XLxBNpjRuaT5SQt1QoIgzpvCxH3xK24
	tMOl2vKZQ4Negl5YvCKg1u84S2I1Nm/4=
X-Received: by 2002:a05:6402:325a:b0:672:158d:9de4 with SMTP id
 4fb4d7f45d1cf-672bfdc8c14mr3002401a12.14.1776586596796; Sun, 19 Apr 2026
 01:16:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260418221707.67972-1-ebiggers@kernel.org>
In-Reply-To: <20260418221707.67972-1-ebiggers@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 19 Apr 2026 17:16:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-g5E0hd63QBOhcZGx=KTe1unGRvO8iG+aQrctSyf7jrg@mail.gmail.com>
X-Gm-Features: AQROBzC7I1NiVlK1mnmba71tTfBdEbCO96YGQ7tM90Z8yYOaVhayMgG7K860Qkw
Message-ID: <CAKYAXd-g5E0hd63QBOhcZGx=KTe1unGRvO8iG+aQrctSyf7jrg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: Use AES-CMAC library for SMB3 signature calculation
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 7:18=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Now that AES-CMAC has a library API, convert ksmbd_sign_smb3_pdu() to
> use it instead of a "cmac(aes)" crypto_shash.
>
> The result is simpler and faster code.  With the library there's no need
> to dynamically allocate memory, no need to handle errors, and the
> AES-CMAC code is accessed directly without inefficient indirect calls
> and other unnecessary API overhead.
>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks!
