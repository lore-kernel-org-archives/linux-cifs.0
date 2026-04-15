Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F13D1E5207
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776227509; cv=none; b=mVBkXtvfUBeLayigZntY96W/+m0/39lKIBlC0xeqvZ5fz9IR9oCsv29mxnfzvQHCfeVhwRBVaUzyGLgwhT6z8DlAlnSt3ffL0Vi+WpdZ+2nOvHN4wrmKv2ZffQghLgxw1HsoU+xyGK4dtZEAMc+CYI2WMMYNkNTZM9sVAxOZcVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776227509; c=relaxed/simple;
	bh=NVd9v9s8jT3l9T5KQpB/av/FH682cJCjX0WUmhnM4D4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DhzHeTLdMbWkj7R1F5TcRpptzVfoj0Lw3WJu525oTnSK5oI81+zQkMjEFiPKTre4uZ9BLEfIuVUmS7CxxccBB/GEHttyUOi5GYcnBLg8g8RB53N1RLXzRpak6uPceOQX0GDp6oe52uewagyZ9jQMf/N4L4rVZhyDSk7nxTBcQGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfYTki7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfYTki7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BB6C4AF09
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 04:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776227509;
	bh=NVd9v9s8jT3l9T5KQpB/av/FH682cJCjX0WUmhnM4D4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PfYTki7PPLAxf1RZyN2A+eZzXq5Qb8LRo7DTr3aZ8kJELBs3XWTI6EjR7gDGvMouK
	 3PZ97IKjz1UZ840LbZl1l8fhzNdh0NVGC1GcKOE0l2MKAnOhOepogODAxBtqLuZYoL
	 yfGGnhHWb57QYBgHAlrqjWhWv1sS3Nn+cMtPCQ7aOMbbMTl2605d0C0TXn9lTWhg8B
	 KXYvmDFbUA9ulOBs1OjCCTYIzw3UlNB5IXkSuExIEPOdI6Hk+er8SboPfSOaeGU45s
	 uCjLLQ/oZo836RlxayGncvi3SsGSfOaTplTYlCry1epU2CgT7FsCAbFxxfUxKjloUV
	 LFIZNkJFjb4LA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67251e91bc8so93821a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 21:31:49 -0700 (PDT)
X-Gm-Message-State: AOJu0YxR201OE081fP8z4mt2xJCHdfsdZNtG6Z/l4VHHCp2t/oThMQlJ
	aT0YUVvhEKESGWkEH0zajUiqgzCaP1mJZah50WwXcgqMYcU0pFM5RyLhbACEk5H5Zr18zws589d
	qpPhZzpXhWSFEhvaQsie9I5lw48Jre4k=
X-Received: by 2002:a17:907:7f9f:b0:b98:654:d9eb with SMTP id
 a640c23a62f3a-b9d46264c9cmr1092114466b.22.1776227507586; Tue, 14 Apr 2026
 21:31:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414191533.1467353-1-michael.bommarito@gmail.com>
 <20260414191533.1467353-3-michael.bommarito@gmail.com> <CAKYAXd-pXiJy4S05C_s6sqz6FtnCeCh6Q2c4B7tPuHseA94mkQ@mail.gmail.com>
 <20260415023531.2659989-1-michael.bommarito@gmail.com>
In-Reply-To: <20260415023531.2659989-1-michael.bommarito@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 15 Apr 2026 13:31:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8B78Gde_7+Ph0cSL998k4qqs_okB0jky0m5h8i25_AGQ@mail.gmail.com>
X-Gm-Features: AQROBzCrk-7V7-V-wpd68dsUjlrrrYyEbWlnp6E7AbFp-N-nxdzfyMQMqteAERw
Message-ID: <CAKYAXd8B78Gde_7+Ph0cSL998k4qqs_okB0jky0m5h8i25_AGQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd: reject negative ngroups in ksmbd_alloc_user()
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 11:35=E2=80=AFAM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> On Wed, Apr 15, 2026 at 11:05:45AM +0900, Namjae Jeon wrote:
> > With the previous patch ("ksmbd: cap response sizes in
> > ipc_validate_msg()"), negative ngroups is now rejected early in IPC
> > validation.
> > However, ksmbd_alloc_user() still needs an explicit negative check ?
>
> Yup, good point.  I originally wrote the tests and fixes independently
> and missed the overlap, so if you accept the cap in patch 1, then we
> can skip it.
>
> Two Qs:
>
> 1. Should I add a comment in case someone refactors the flow to
> emphasize that a check would be needed here if not covered earlier?
Yes, since ipc_validate_msg() now checks ngroups early, the same check
in ksmbd_alloc_user() has become redundant. So please remove the
ngroup check from ksmbd_alloc_user(). And we can also move pr_err
message to ipc_validate_msg() so that the error is reported earlier.
>
> 2. Do you want me to fold this into 1/3 above?
Please fold this change into patch 1/3.

Thanks.
>
> Thanks,
> Mike
