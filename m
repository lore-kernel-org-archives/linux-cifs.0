Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B461B3845AD
	for <linux-cifs@vger.kernel.org>; Sun,  5 Apr 2026 23:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775432321; cv=none; b=EZA66nlN2h4rlOhnoGpSH5zueL8Jjl9YhOtv1ge6TmrKnspgSZlJl0NyN70V1orQ446jApevR05x4vHh7mnHaU5MX0p2zEhD7KKr5Q1K1kCz4h3KRt2Jdql4TeqMVmWZbEnh4elDMPLaLqYXDo4vJYL+dEVXUeKqd3YzyI5Pv+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775432321; c=relaxed/simple;
	bh=OiiZAqzOAl3qlf5frR9Cwy7Ma7vOH8OBuml2KDp07Ts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qw1UHXYOsGT8Rq5OUZJdsAtrvoJZUFPQ43kPt2fmgfjcXqAPlT6uzZctEPP2+YHzb2o9Ti0J2koTKRvZuE0nQv6Re/j6xNVScz26agprFSpDVPbmsngF122+66ppYUFecsXV1+D5g5lmQ6+vc9GGc7glvEeUJO83hnbFr69vrSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Id9AasEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Id9AasEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC93C19425
	for <linux-cifs@vger.kernel.org>; Sun,  5 Apr 2026 23:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775432321;
	bh=OiiZAqzOAl3qlf5frR9Cwy7Ma7vOH8OBuml2KDp07Ts=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Id9AasElOAu6+YO69j2fGDK9l5HKddSNT74r89C749DMULrOVu4g7OX8PkRvMCxLl
	 59Fh6PYIeSDNeJB82Qau2KTn0uCNDBPooLBxbuTvD05NhgIkiunbZLIeuOLQy3jnIh
	 Nc65eOszod7u5Om6GLKCpeVOFE5zTA+9spMDTGNNMvlsY8vPaIUCAdAb4AAc/HdAJI
	 78BYRxENd/7NWQYfio0Y9fB73cf8n0t2dmfgsh+LSlUqDQUyX5R3phtqQUqBsMKTS+
	 h7h+i0VuqJSGXZapOLedjaXFezM8bPbr2xBvqKdlqHPvznYugBVDIZxfFBOIcR4S4b
	 UlyiDF7NQxjpw==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66c304dbfd2so2532522a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 05 Apr 2026 16:38:41 -0700 (PDT)
X-Gm-Message-State: AOJu0YzOjIOpJTJfPC7wbdSRT6hVhUq1UJCxjA7fWeMLVfcp9R8j/U0X
	CORXcegqXltQZ4Waw9aNvWlm6ieDo/ZJHWV9lR4S8LCGJ6q78fCJlimuUDomg1z2kAqa3whprHH
	svw7e2Lfo1avKcR0T+Ba3EDKD7Rx54Q0=
X-Received: by 2002:a05:6402:510f:b0:66d:d429:5852 with SMTP id
 4fb4d7f45d1cf-66e3e0e68a5mr4234837a12.3.1775432319947; Sun, 05 Apr 2026
 16:38:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260404194338.21168-1-ebiggers@kernel.org>
In-Reply-To: <20260404194338.21168-1-ebiggers@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 6 Apr 2026 08:38:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-pHhwzBzOG7SzmQRiw8LBPfQAqRCFEtv4nMWR855X0cQ@mail.gmail.com>
X-Gm-Features: AQROBzA53Ciex-J7pnoegmGNK3iVzv3t8oqC-OzlPsGr1MCjheD2I1iENB0_vzM
Message-ID: <CAKYAXd-pHhwzBzOG7SzmQRiw8LBPfQAqRCFEtv4nMWR855X0cQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove unnecessary selection of CRYPTO_ECB
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 5, 2026 at 4:45=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> Since the SMB server never uses any ecb(...) algorithm from the
> crypto_skcipher API, selecting CRYPTO_ECB is unnecessary.
>
> Remove it along with the unused CRYPTO_BLK_* constants.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks!
