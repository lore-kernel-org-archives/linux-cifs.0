Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18A0306495
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 23:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761174827; cv=none; b=kLttTlmHxI3hFROtcQmOz360ehA+vzBHeENgJWkFoSgJujccvUZSsvmuUNEoRU1zYvQ7OwFqJNxPugfsrVWZY7drKgqSKtY4VUjocn7D2u7FCkGRSB3SKcgiBwj9yikF6JFWWY83CBiE51PNZtBBWN8u8wdQAM+tMidTfcx3ZVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761174827; c=relaxed/simple;
	bh=TGQodGtXgknIsWY7/3w2xJfTuc724moitZcuwddpmY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qCB37BPHGkR16TcZE0538J5qtRQVZuoffEN3FNvxVEJov6ZDb+LCUA/3TulOxhBG2P+wr+WLlP7Z2LFcVlK0xT/DeNUItq10IZqmv/Bq6FsfNYeKQm1j1qOsHwAVGWDTGAiE5gfrUgMeSQq5GB9Cw8WicIYx15IFNw62kPfXH10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWnmU19m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWnmU19m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCFAC4CEF5
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 23:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761174827;
	bh=TGQodGtXgknIsWY7/3w2xJfTuc724moitZcuwddpmY8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dWnmU19mOcQIiyBuF8JpGmdU3+wwiT2XOiniqiJR54sonlLROu40d6sFubKCNoTvr
	 FVNlaRE66w0aUBDH77G8JMCfeLN1KLMort8YxIs1A40tFOc2L+q7ciXDSgQB7YqEAe
	 8jgOg6isnFvZEROs4ilXe3TmoPT/sLcw5wboQmExEe/3A8K9AKXrZ7Q+Gwgzzj/6dY
	 amXto+DNg0sV4ke2fRtYe/TApAS2gQOyDHbqYykwwAPf8LqJSVjHE23i6b3dm5OO8r
	 Je5qIWBv5UfbrWwIBZV2nexSEy8gs2DKgnn0x/FlEcIg+rfBL6j0rgUr5+viKkYc2F
	 svj1niu9+Pq+w==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c4c346bd9so275930a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 16:13:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXxBfLwTQi6uzJzbdsQQQevsYvWVCz+XAUxA2Iy04cyceEg/wrNZyw5TG2NcyrtgrVEnyonMYfcm/8w@vger.kernel.org
X-Gm-Message-State: AOJu0YyhNjqBC03FNK7Tr1/d1O3GBd/Gapp4OKQ2mHAcc2XmUX/OzdOY
	3ZjxEycww1MK5d2ckwmmdAWq6Ymhtjs8LFOfLxTwLf3WuvqDK3AtfWxRA0SP8UDl9G/ut9mUGCX
	90A6y9f2xpusKqEVvtn1Rmc/LwG/62WE=
X-Google-Smtp-Source: AGHT+IHa5nyuANlWVI4EYphccWVc09Zo1B8uBJqUhFVxvUaS+9LYu1uwl3f9ymu6svhKRlY1hkMC5RHo/C+TtCFRprE=
X-Received: by 2002:a05:6402:2551:b0:63c:295a:d516 with SMTP id
 4fb4d7f45d1cf-63c295ad6f1mr23462978a12.27.1761174825930; Wed, 22 Oct 2025
 16:13:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2025102125-petted-gristle-43a0@gregkh> <20251021145449.473932-1-pioooooooooip@gmail.com>
 <CAKYAXd-JFuBptqzEbgggUhaF2bEfWMRXCSK9N_spiBxvi1v0Wg@mail.gmail.com> <CAFgAp7g52dJDvJyEoV7Ms-YofG6a2=G=N16ARNrBOiCSkLVLTw@mail.gmail.com>
In-Reply-To: <CAFgAp7g52dJDvJyEoV7Ms-YofG6a2=G=N16ARNrBOiCSkLVLTw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 Oct 2025 08:13:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-v9r0kKU9wO1ZZAtFju4H+OsG8RA3iYd15=eR6d5VEaQ@mail.gmail.com>
X-Gm-Features: AS18NWA9NqkARBQUm-jcxNp4I7v8U9iK-F28MdBbsUrCH4ZQBHXD6jTrQSJ5QII
Message-ID: <CAKYAXd-v9r0kKU9wO1ZZAtFju4H+OsG8RA3iYd15=eR6d5VEaQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: transport_ipc: validate payload size before
 reading handle
To: =?UTF-8?B?44GP44GV44GC44GV?= <pioooooooooip@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 7:45=E2=80=AFPM =E3=81=8F=E3=81=95=E3=81=82=E3=81=
=95 <pioooooooooip@gmail.com> wrote:
>
> Hi Namjae, Steve,
Hi,
>
> Thanks for updating the patch. I=E2=80=99ve reviewed the changes and they=
 look good to me.
Okay.
>
> Minor impact note: this patch prevents a 4-byte out-of-bounds read in ksm=
bd=E2=80=99s handle_response() when the declared Generic Netlink payload si=
ze is < 4.
> If a remote client can influence ksmbd.mountd to emit a truncated payload=
, this could be remotely triggerable (info-leak/DoS potential).
I don't understand how this is possible. Could you please explain it
to me via private email?
> If you consider this security-impacting, I=E2=80=99m happy to request a C=
VE via the kernel.org CNA.
>
> Thanks!!
> Qianchang Zhao
