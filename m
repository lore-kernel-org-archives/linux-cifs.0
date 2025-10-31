Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA2C32ED50
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 23:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761954654; cv=none; b=QpLitvVlFj8odKy/MnT5hiRz/mnABM6+6mfSHD3GgQmaTzA6SDKZdujMevhjv6mRUt6wLX1aqToKHocp2XOuldMvz1SJ+3+5CuzHGCzHolphxj7rhTaPm62y0QjioLjQ6JnZVXGFPx85nLuRIXGuNfDZrP/DB4b9vhn82WWWBV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761954654; c=relaxed/simple;
	bh=vpvm7wOdtrB3Ns8GW+amqnU7ULxpYLWKGAm34Amb4T0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ND4at8BS6H2kq+8idVsY5gFl8n3v8/iq5PVnKn2rkt8q6/J3WuyI0aF8gS/0iyl5OVJ951E0Y9iEa6o2CZOR2KUJvW0u9RQ37s/36gUZ/3wg8hh1jke8/1JbcOS74HNDX9xn/TlNK7WiFForDfBlP6LZamd046jntUXspdAwH5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCdsl7UJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCdsl7UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6105C19423
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 23:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761954653;
	bh=vpvm7wOdtrB3Ns8GW+amqnU7ULxpYLWKGAm34Amb4T0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nCdsl7UJpLskZO67zKjdkVugtZEur3BWgNp9mub2G4iiB83QHMcNN72wFva6dX4SI
	 YjSIZquKKAMWlcNum97jMhrIaADzvD/rfVNn2i9UixTspTn4VsRFsHYEOAnzKfBgQI
	 tTlPWWjZBQ18qIIBWw4m6G39sKfIl+J3AKtJEx2/8rKyYmthb/aqtqRINWMc7qt052
	 1UMeENKUvRqavAd0Y+RGMgtvAXFvSK/CuS6eggNH8jZddwhTQ3BNjtf38iJAmX0Q7N
	 84zYNXZo1mxUXvCj3bU1BeAFyKCOeIGrKX9K9EPAaaU/6c5b0VB9hgjaYEHsyBNi2J
	 7yJymZj2tziUA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-63c3d7e2217so5022111a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 16:50:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWQSi9tlH4gof5BEJfFqvuqcNNQ9BmOTCbThGsRFsWnO/xhaWe2ZZpu7UNIJ0Wgc1iKaFSbcFEq5Rec@vger.kernel.org
X-Gm-Message-State: AOJu0YwoVbJOj0CILkgOoW77iWd7IA3EpQ27XRnyZwZhRM0Qp6bPt1WV
	Eo+cXVLX7BX0G5bpO29s7gfncrJVV33j1Q+WKEniUSK71nDV25qa2CJ5J3T0ByjQcDOCc2a/tKR
	At/X+KxRl00C0lhFpL7okrR1xwq11YCY=
X-Google-Smtp-Source: AGHT+IFYOngRr162Y43f2hE7ormKcaP4Mblz6ZPfEkfVpLgAUzvuR4AnuPYlcQQNTLsH0+ZVIi9NNkQ11nuI7J5go9w=
X-Received: by 2002:a05:6402:1e88:b0:63c:1170:656a with SMTP id
 4fb4d7f45d1cf-64077041b61mr3590736a12.37.1761954652229; Fri, 31 Oct 2025
 16:50:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030064736.24061-1-dqfext@gmail.com> <CAKYAXd9nkQFgXPpKpOY+O_B5HRLeyiZKO5a4X5MdfjYoO_O+Aw@mail.gmail.com>
 <CALW65jZQzTMv1HMB3R9cSACebVagtUsMM9iiL8zkTGmethfcPg@mail.gmail.com>
 <2025103116-grinning-component-3aea@gregkh> <CALW65jZgu2=BfSEvi5A8vG_vBKrg=XLs68UoE3F3GBOOpeJtpg@mail.gmail.com>
In-Reply-To: <CALW65jZgu2=BfSEvi5A8vG_vBKrg=XLs68UoE3F3GBOOpeJtpg@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 1 Nov 2025 08:50:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8gbpoQXCsEuaKsoZpsw2ZR5GkT4scLoBSLCkScH6Xvow@mail.gmail.com>
X-Gm-Features: AWmQ_bn2HoAc3qCopFzNNtsX8TZzJNQBiOPs9s_azg1kgzYotbe35jPoxbA5UI0
Message-ID: <CAKYAXd8gbpoQXCsEuaKsoZpsw2ZR5GkT4scLoBSLCkScH6Xvow@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: server: avoid busy polling in accept loop
To: Qingfang Deng <dqfext@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Sasha Levin <sashal@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2025 at 4:49=E2=80=AFPM Qingfang Deng <dqfext@gmail.com> wr=
ote:
>
> On Fri, Oct 31, 2025 at 3:44=E2=80=AFPM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Oct 31, 2025 at 03:32:06PM +0800, Qingfang Deng wrote:
> > > Hi Namjae,
> > >
> > > On Thu, Oct 30, 2025 at 4:11=E2=80=AFPM Namjae Jeon <linkinjeon@kerne=
l.org> wrote:
> > > > > Fixes: 0626e6641f6b ("cifsd: add server handler for central proce=
ssing and tranport layers")
> > > > > Signed-off-by: Qingfang Deng <dqfext@gmail.com>
> > > > Applied it to #ksmbd-for-next-next.
> > > > Thanks!
> > >
> > > I just found that this depends on another commit which is not in
> > > kernel versions earlier than v6.1:
> > > a7c01fa93aeb ("signal: break out of wait loops on kthread_stop()")
> > >
> > > With the current Fixes tag, this commit will be backported to v5.15
> > > automatically. But without said commit, kthread_stop() cannot wake up
> > > a blocking kernel_accept().
> > > Should I change the Fixes tag, or inform linux-stable not to backport
> > > this patch to v5.15?
> >
> > Email stable@vger.kernel.org when it lands in Linus's tree to not
> > backport it that far.
>
> Noted. Thanks!
I think it would be better to use the stable tag + kernel version tag
instead of the fixes tag.

Cc: stable@vger.kernel.org # v6.1+

Also, I don't think this patch necessarily needs to be merged into the
stable kernels.
Thanks.
