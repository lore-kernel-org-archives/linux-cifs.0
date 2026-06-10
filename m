Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1CA17A305
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 00:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781051023; cv=none; b=X3gZryGRF2TcmvOTHVENAdLHbvjBc/zyTZoKuHx6vlM9qe9nsQDmqkpRmTWwxvRex/cnMnLZOMrz/GPkHfzBbDa9JZscyD5agxNLxIJFgqy8/CvrwFEGDwihFsp+BSlmQSkS8V/AyYlnBJFIN3TsjV6Ar/W1GwYyBRxqyA+LiOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781051023; c=relaxed/simple;
	bh=PJG1w2d1W/a3t5veQf3n86qTeMEYX+FrclQ1NsOvJN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qHGqGRdteyoQZBjEo7dpMa1GK9jlvarsYXYtoggER3DaQJ1vMd18S4IykIzT4FXJlXvIU06W22oqEHjLz9VJEkdRUezgLPyH668y9AL3cahHymaRsWzep+2sXWMtfZns7Ud/r6UycTrtMxyeznRAqScF2hMR99o8Ok5ZESK/ito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JzGDvC+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzGDvC+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A83F1F00893
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 00:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781051022;
	bh=PJG1w2d1W/a3t5veQf3n86qTeMEYX+FrclQ1NsOvJN0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JzGDvC+UZcOgKTy4u8fB4A1b8u1rt/hbhBQUThS83uKw2apKcO0aGgkUKnBgWKIIF
	 kvdv5dacVw9YIjVJGaF5D9wkmWn5i5813o5h8DDG/73eTB/Avnowcu3bjcI+DTCIBL
	 E2WVHq1KpyTVSwCedqSBVfFZtIZk88YJkyl7dCiOrf8UpZJphvZzVkS6V8WV+GdaJT
	 7dpjGTTGR9oV870WfenVenMqv1ZWHhYsIrh6tUTDoksGVtswN5xKMW/27dibO9IWyv
	 jmO6D9+0SBHqKF2d8lTSQKznDvyZjv6yD61YtxUNnC06kMj1JNJ+RmvOMdJQpr588Y
	 9jMnPiZMMNbCA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-beeba001887so819897066b.3
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jun 2026 17:23:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9oXv+QrPa3lCW9SA9rKn0sw7f1LYIfokRPSkZnWrb8BjXNSPhlC8yNHHE1+/gFW8QiZPcQDGWUwHj4@vger.kernel.org
X-Gm-Message-State: AOJu0YyI8qMqrd/2kwZDIhC4TSm0m8eNfmus50+aJAeDCT0RWfrgkMl2
	IIU5Q9irtfjKT9O0cimQFtzX73ZzsybkRWRZFNqpM9UGO3GyG/h386LOO8foM8xNcmGSNrDZzg4
	29afjyVfq5zlRoptH3TnFYo0ftdUi+4A=
X-Received: by 2002:a17:907:608b:b0:bec:9f90:629d with SMTP id
 a640c23a62f3a-bf3743ea8d5mr1371195466b.39.1781051021329; Tue, 09 Jun 2026
 17:23:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muMKwYGGAcBN_LQcE2zhd-+Kk+fKsRiTokpYXwZoGS68A@mail.gmail.com>
 <069dbbfd-e3f7-4566-a7ef-624e56aea46a@chenxiaosong.com>
In-Reply-To: <069dbbfd-e3f7-4566-a7ef-624e56aea46a@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 10 Jun 2026 09:23:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd852AzX8PAo8joXSOeDqTYgbgoiz98sALduLOTh1BTTdw@mail.gmail.com>
X-Gm-Features: AVVi8CeKHmP8vIj1F3RBMpSLji7qrhCWCriFA3hrPos2hMtY3rVlsHf54bTgNwA
Message-ID: <CAKYAXd852AzX8PAo8joXSOeDqTYgbgoiz98sALduLOTh1BTTdw@mail.gmail.com>
Subject: Re: xfstest generic/035
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 9:14=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae,
Hi ChenXiaoSong,
>
> Is anyone currently working on this issue? If not, I'm planning to spend
> some time looking into it.
I haven't started yet. I would be really grateful if you could take a
look at this problem!
