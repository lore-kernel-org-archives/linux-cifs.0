Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8576C35893
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 19:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748807975; cv=none; b=SpGZYMbkk1JC4rAUDEWvnTquaKrEX8PgVm1Nms+qVG9UVzkQRj/vaGqht33egPgj4TQvrXyctvB0thO7rhs/23NTQxd+wVZuR4xyelpcAOPbz6vKuRI5t3SxgdVnHOl5C9w03OZkKTWbsjy1nEo0czdnfDLXVixVGhufN3Zz8k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748807975; c=relaxed/simple;
	bh=l30Z+FLW9M3nm/k+1zSm7ehEEPvThO5b/vzMA8BOLAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F2rEGHWN9mRW3j77SSXuzSdj5rl8KGTDU53c+LsT8tI2nCs4lBAbw9M/W9SqY+3SbJrLuI4YsNRQl1Acf64uX9G0SOJhvShcHN0uYUhbAITX2jjpmhduCx3UNRwUaxRAYNVC2F6Esn1KZ0nMYDJyAXoDF1QCdhpEVLKkJ7gqyqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kX0C3gFB; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kX0C3gFB"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3292aad800aso40731951fa.0
        for <linux-cifs@vger.kernel.org>; Sun, 01 Jun 2025 12:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748807971; x=1749412771; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/7qnIAcZPZrnPGeCLYuUrS9f0kVeFRjxJpjdAxiX/Y=;
        b=kX0C3gFB18+jhjqyp5RSXhwzjbeavwbqqF3/pZCfi9J+XOX2DJ4hF702CFJcyrR9QA
         bEsB7hUjicQq89bSl19l+rj/Vh1CZF32dXPhVwJybOtgAZ1dPt04k4vC1vJQmsdIQv7m
         lnL5ZYthXXkG0JGmHMOvr/tUepFwsC6DeasTVXXds/pj0VwvXcEz4M3VTtaFb1/Db5vO
         yRb3K5lV/h8t1e2y/ic5DbRNyz8O0ZG0f3F3Z4DAVnVjVZmDfIfupGYI7j0c5tY4+th3
         nP3W2ifWHjMuLzTObGziir/KwyDJqF32A/IGHTwhqV3+nM85pO9iZ5KV0X7m3bh7njsv
         YjVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748807971; x=1749412771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/7qnIAcZPZrnPGeCLYuUrS9f0kVeFRjxJpjdAxiX/Y=;
        b=gDPdUWGLhDGrQHZaSLQ/DAMmcEkQCICtYXF2I6N5N2YuHGQAXqJCTdgx9+HhWqfEDC
         /fhota5tyHchJhM77Ca6XGww5AndR175DWJSGBLiaIAgKykPKoketSyLj+xXCyjPgq0p
         vcY0UZiXiOJXfj7F8pUZbtdSLCrQuCxXrEc3aZuW1DqZm9Osfz6ZLFPoeScq0hvronjo
         HkxM29j8a6wjC/v0mTxEOfRJlTVxQ5hZX9vbZ/dcK4GFc4v6WKu4JkqZ4ep78vEQzQZu
         AsmLKvI4DoLz1WkvWpVlt9xs+Ex3zl2qWKJZcr17QM/ATw+Afw6qSlkb9c+eqdfQrKA7
         loVA==
X-Forwarded-Encrypted: i=1; AJvYcCWcZIYbfSOrQ0A/aDa+QBRmhwkrmSW8Hk2J1zSFjf5CSZuecIr0CaCibgyYWjkzhHAH43m6pDALYGzb@vger.kernel.org
X-Gm-Message-State: AOJu0YwMhasiM1txIJz5lBSNnmXVtxk8mYnMWUlYq8iEtxk0zcBrtI9O
	3qBXzfAX99L47oue6fhAbW0SiPSP/UJVbL2vcpO9j77Oz1/+Dsr+pjecKROC4y1kfJ3j7ov9778
	2ZYE6Uj4gv+yau0dxbqr01EViQKGqJeI=
X-Gm-Gg: ASbGncuB2TQU+pWHIqXicU93iI4D1DMX9DNigWJdlV/yA2SyA3yUaouCkaOdeigLYXS
	D/a4J2W7IzjQbpHRYHm9thODlUoBSsFexV2yQnPzwVrODi/L7HITedVYn0I1aL86qn7jBE0Qb/y
	EmlkEMv5V2NYc6AIK+5oPbH4+mv6OaJd9LbwkrPygqqIgdsCAD5wShl4v/03Ujc8vmC4GRg//2Q
	9F8
X-Google-Smtp-Source: AGHT+IFXq0Mu2OTg5OlHUs6RkSH7/rvgr/UEENIN2GJ7snWjDpPqdN2P+TUnfQ4sZHjLdGuTs67fKngseT+b+fQaVI4=
X-Received: by 2002:a2e:bc24:0:b0:32a:6c39:8939 with SMTP id
 38308e7fff4ca-32a8dbfc226mr35925691fa.19.1748807971168; Sun, 01 Jun 2025
 12:59:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
 <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
 <088096eba2d038bce2f73e6519d11ce9@manguebit.com> <2025060107-anatomist-squander-d073@gregkh>
 <be8026cec8f645de3409433fe15e690a@manguebit.com>
In-Reply-To: <be8026cec8f645de3409433fe15e690a@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Jun 2025 14:59:20 -0500
X-Gm-Features: AX0GCFtqdK2JgZuhkIZvJzwcyN6k9gCaTwRryOLT3WfVn9d3mvfEC-07vGdR4K0
Message-ID: <CAH2r5mtm1FjgtzgM0p=2Q0QWifqZwZ2ZjCG6Rry04xQQ7rX4TA@mail.gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
To: Paulo Alcantara <pc@manguebit.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Walleij <linus.walleij@linaro.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 1, 2025 at 2:56=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>
> > On Sat, May 31, 2025 at 03:49:47PM -0300, Paulo Alcantara wrote:
> >> Steve French <smfrench@gmail.com> writes:
> >>
> >> > It is interesting that almost 700 kernel modules define
> >> > MODULE_VERSION() for their module, but only 4 filesystems (including
> >> > cifs.ko).  I find it useful mainly for seeing which fixes are in
> >> > (since some distros do 'full backports' so easier to look at the
> >> > module version sometimes to see what fixes are likely in the module
> >> > when someone reports a problem).   I am curious why few fs use it
> >> > though since it is apparently very widely used for other module type=
s.
> >>
> >> I find cifs.ko version quite useless, especially for distro and stable
> >> kernels which take fixes from newer versions while not backporting the
> >> commit that bumps cifs.ko version.  So relying on that version becomes
> >> pointless, IMO.
> >
> > Yes, it is pointless, which is why it really should just be removed.
> > I'll do a sweep of the tree after -rc1 is out and start sending out
> > patches...
>
> Sounds good.  Kernel version and git tree are just enough to figure out
> what a filesystem or driver has in terms of features or fixes.

I ran into weird kernel versions a few times where module version was
useful, so the external "features wiki" for cifs.ko lists both module versi=
on
and kernel version in the list of features.

--=20
Thanks,

Steve
