Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D13280A56
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 03:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880805; cv=none; b=sW+nJ+WeusVTipqR8oLxqLJmvJIuZolZfyX4zk6NBa5e6bBSSYDWluQJEGIin441BQ8mXp1NY8oM5y/13GgRi9GblIpifa9FyKq0LrSg9eDUNynor3nDLVHNiN3AKwL3XCsnERgunbZH3ZsbVQP5oHDW+YgDqvIZhTglaHPgsLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880805; c=relaxed/simple;
	bh=3HhVbz+oiX23cNqSPXcAtTtA3p7J7LV43TxhWjxngIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnKYa819sds8Tfx+ZFHI7KYhRBwqsxpoBGYCgil6oZNVZbn0ezqtS8MX0GnHdYHzwOmpeTf2zreASEun9rvV2cLDk7A2AjvHmcId0wQIq66UCE44J8vE9otN2xbrTDNayOaheve95VMXROLO0rQN6RSsk1R/VVChTmYjPk5ydTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wd6QFjYn; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wd6QFjYn"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640741cdda7so1271157a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 20:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761880802; x=1762485602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6hdlfh4APZvyYNBzW9B962sErA2WCFAnDLAh5iqxCGE=;
        b=Wd6QFjYnQ9W+K75y+zK/dY4T2rspo6n1ECfUhqfpmtlv28OtNQKHbbrYyKFeTbYjsR
         eheGGwlop2QxKTV1hOJDiIV4XblLu9g6relGBpZmRS9TqqWTTtnPN60980HUtuMCg0dp
         hGAakOf+170k8fftpPAzL5p2BwfRZcFmsYrAuztJ5f3OoHezcm57AFpZyaz0ik5XowGD
         D3U8dqof5myGLoucr+Qtk20Dt5vxM4mPVw2b/KZKid/kQQzP9zUIGcVm+Vy7GQ8JuIfN
         S5xPD7mSzaEQIxEXFYs8g60O5gSSEYVFN3Ga1KbmF2DluZ+JTDd62WsAkqkI520ZZo7n
         kKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761880802; x=1762485602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hdlfh4APZvyYNBzW9B962sErA2WCFAnDLAh5iqxCGE=;
        b=sBOkAc3nLD9CPwXg9fFhaRsK7COEvQUBjVJ9077vMToUtyXjtxE3e7mLAhuFKlI8ot
         LKTaacRP/1BGwp7BXWACY2r2HzgQV/9fsgFLwZWpzg5v32IyXJHAta8cErrKyrIXoR2X
         R9xR2LkxdVWeQ8mQvpxaeSGIge8IaxG5U5nwigyndmZDNn6r06rwFKeFQXtKooXT2k5Z
         Kq04z2+drKwlzfHCxU3KyZqoJkp1EcA/MC0IBJeYXma6MgZERVKd+VIKR1TZUS/0bkXH
         xI40yqlj7mRg9selWvKlZaLwECGDnK2Y5OeNU6Hh//3Bf1AvEktx0JF4mYBVD+4iEY+T
         5uwg==
X-Forwarded-Encrypted: i=1; AJvYcCXwEaX5slRyBT36lh3fjRNkx9KCg46S9RXG0/Wa3fMY1B9G7NfPvKrxaoO+NA+pG3tb8g3pek7ygwXo@vger.kernel.org
X-Gm-Message-State: AOJu0YxE5nkGMBRR5DZjj8TTKjpID57ph0JycbEwKw9x4f0khUBiIPpX
	OHHL1ICfuDfhA1ArtpMRBFxVnbsDpPu7BldCqQSU8GgVBE/HIBju7JaU37cthCpgTCWEYJdwQNc
	9owo3LsEYPIqYU4AJQqfQITCVvQjWrfk=
X-Gm-Gg: ASbGnctvvmzNo7TF7rEbpceY8iGLK59+eAVto9rv1RIg6K2y9QtM5YpBm65IC62dxdj
	sEIWXj/3ZdFEXvQjb5co09Lkw3cPpezgrlRpLoTM2RJI0k2PJKkB6jKRQewLke5T0H+74axTTP5
	7bG57apJ19egQ0JX68AsqONtLXH50D/Kjz4z+w4+TcUyeKn19ua8G4IPME19B6JSG87R1u0Mmh8
	YykZWsAd07agqqRg3lWbrWLvJCLsd/PsVERUCqzrizPVdDxAYvSuwekgBM=
X-Google-Smtp-Source: AGHT+IHRq0Y4FPtYm+Wq2az0RAL1jAfKfa12KLvOtgIMEIe3B0ddlN11aIOCOqF970xmRnO3oZgnZ9G5EsN1LziiIto=
X-Received: by 2002:a05:6402:27d1:b0:63c:4f2:2131 with SMTP id
 4fb4d7f45d1cf-640770161a3mr1454654a12.22.1761880801868; Thu, 30 Oct 2025
 20:20:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251030170116.31239-1-bharathsm@microsoft.com>
 <20251030170116.31239-3-bharathsm@microsoft.com> <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
In-Reply-To: <b3ced9ba1cc2a3d8e451c2e9d7ed460c@manguebit.org>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 31 Oct 2025 08:49:50 +0530
X-Gm-Features: AWmQ_bnK5M9LEhBS2Bwp_KrtQ8PAQnwg2dKdcCIITIS1cKjn7FN9k9gsJSTqCZE
Message-ID: <CANT5p=pbEAKBm3K26AxtZV9+UwXvfrrk-fYs7LsSD3nHdZptNw@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: client: show directory lease state in /proc/fs/cifs/open_dirs
To: Paulo Alcantara <pc@manguebit.org>
Cc: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org, 
	sprasad@microsoft.com, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2025 at 3:28=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Bharath SM <bharathsm.hsk@gmail.com> writes:
>
> > Expose the SMB directory lease bits in the cached-dir proc
> > output for debugging purposes.
> >
> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> > ---
> >  fs/smb/client/cached_dir.c |  7 +++++++
> >  fs/smb/client/cached_dir.h |  1 +
> >  fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
> >  3 files changed, 27 insertions(+), 4 deletions(-)
>
> Are you increasing cached_fid structure just for debugging purposes?
> That makes no sense.
>
> cached_fid structure has a dentry pointer, so what about accessing lease
> flags as below
>
>         u8 lease_state =3D CIFS_I(d_inode(cfid->dentry))->oplock;
>
I agree with Paulo here. We should avoid duplicating data if it's
already available elsewhere.

--=20
Regards,
Shyam
