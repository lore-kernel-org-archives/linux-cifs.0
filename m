Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792804795;
	b=xavicsQl5zpdP/sajoAQgTrtPuuoKawkkIcZgEPJ7+eacxhxudcxY1qx7Th/RjpTDpoy
	 YHaBbFi96uCrlHoWgWJ6h7Gjnsi4hPzd71YwOP3VznnVOjLujpzU0KGGYzQQFbqMggvP1
	 Z5LSoq0bZafrd/erLZt7hPSW70VhWueDeYf6gpWDZ2umikSWdqj46Fl6rFtpe94DJqlDe
	 KUaVEZ/xzB6OLLc7eptsIAdKcQ6Tri5Bgi/S1MBNdjm4pPusaEEWulybbiBXR9iEeXyVc
	 d5mNVz7PLo1wIN9l8IOrrjqtVV9eqqrBAYRftsNNj1sFihUVNWzw28TAiMy87lVUl3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792804795;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=RT08dkW8FxBaFchwPuSHiE6eaEHqdC1KJ6SLXOInNzw=;
	b=QK3L+AMdfq93ywWhRgVC9tL+x3LrLvPVnjiJrzu9fL2UFq9rRDVXRKqqi6tx3X4c8hzQ
	 apHqSf/H6MnCrcQDvDMdGCriMcO3RE7qh5X+MiNoikK+m7hlNWw/cQmpTEYcFzYv0oADT
	 XVO2Vuxzc+MvIbE3kftkIfF+JZS65HDXDfKNupXVUWrUwwC4P3HPR8+nBGmVEPSTuuVtT
	 Gq2iKlbuc11q9fBJv/ST+3H10PnMUCz1dUoFnGJatcKOA2n8p1IiS5H0FfT6oYvEVlm4T
	 yDsDThKvrqQUvBfVH0P5e8lPEGIt9Nw/bVszecULwUdF4Ga3ovDk9RnhLtBqrzTgCGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Ikph/nCc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BA8606A31B
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ikph/nCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79821F01825
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 01:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792804794;
	bh=RT08dkW8FxBaFchwPuSHiE6eaEHqdC1KJ6SLXOInNzw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ikph/nCc1kOs7IXxgqAgYor5jl/nZpyWms3hhoHEjjDyPhWfPKOvGXSQ8CbP3325N
	 He+aGhUPXq8EtFq2dRu0aYohA6n5IYN2k9TmAvrYShX0rmWVuyINhJAYDMVmNCb1Nr
	 9q2WnIJmWVtptRIKzz+ouXyAWM+CGz0M4BlcewGg3uPsjMb8fyJi8wVQjoKbD/D0hh
	 kpBeSmxEVSWuHFg9EHiATYP5oQCpDor8b4h3OaoTVXYvpRHfgFyU3SASfe5W7dwnPa
	 iSMQw4LZ0ajNFyL+S+lh1WXlic1qOKU5EckYbAlLAO9NSE4getRSVFJelZ2FfSjfhH
	 I80rickRnG6xg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c38ac26cc5dso214264866b.2
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 18:19:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw0CPzC+iEQvHyriCZ6wJu+dMvjcsnXmFqHC232J9vpcxHYNfy8W87vb7bmrK7lgJ9r3hA/uCJabcdn@vger.kernel.org
X-Gm-Message-State: AFq9FYJCmbvxzVuGd9qvk3n+r0R1zNdIMSTtkuc9K9bwN9ttDXuChFsg
	+hxpmBNQ+IDWtA6H+ueBA4305DnEV3QHYXwJQxNq4Ow6gwTJa0NoQL+IpkrKGsZdAw/URsg5wr5
	yljscy/EAYeIaFE+NQJb7YnrX0O9TB3o=
X-Received: by 2002:a17:907:94ca:b0:c3e:34fa:611d with SMTP id
 a640c23a62f3a-c46bde7eaf0mr83233866b.35.1792804793341; Fri, 23 Oct 2026
 18:19:53 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023174821.17552-1-mike.michalo@gmail.com>
 <atugaviJxR8nzHQO@suse.de> <47ec7610-9013-4c4b-ae37-f6d88556e59a@talpey.com> <F6CE78FA-AA06-4F00-BAE0-80B0819CE6DE@gmail.com>
In-Reply-To: <F6CE78FA-AA06-4F00-BAE0-80B0819CE6DE@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 24 Oct 2026 10:19:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_zM0K9oAjEMzYinBeZEF=0=ozsd3+LRY6gy_O95btzRw@mail.gmail.com>
X-Gm-Features: AclHuK-WLdDFKY7pNiy2tu6vh0Xvcfdn4F20whBPb-EMN2nOC5566RjM5KUe2Fg
Message-ID: <CAKYAXd_zM0K9oAjEMzYinBeZEF=0=ozsd3+LRY6gy_O95btzRw@mail.gmail.com>
Subject: Re: ksmbd: AES-GMAC signing support?
To: mixalhs <mike.michalo@gmail.com>
Cc: Tom Talpey <tom@talpey.com>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 24, 2026 at 7:36=E2=80=AFAM mixalhs <mike.michalo@gmail.com> wr=
ote:
Hi Michalis,

>
> Hi Enzo, Tom,
>
> On Fri, Oct 23, 2026, Enzo Matsumiya wrote:
> > I did this 4 years ago for cifs:
> >
> > https://github.com/smfrench/smb3-kernel/commits/aes-gmac-v3/
> > ...
> > Feel free to use that code as a reference for your implementation.
>
> Thanks, that's very helpful, and thanks for the quick replies. ksmbd
> already sets up gcm(aes) AEAD transforms for encryption, so the server
> side should be able to reuse most of that. Your branch will save me a
> lot of time, and I'll credit you wherever I build on it.
>
> On Fri, Oct 23, 2026, Tom Talpey wrote:
> > refreshing the numbers for Linux (especially on ARM64) should be part
> > of the discussion.
>
> Agreed. I'll measure GMAC against CMAC signing on x86_64 and arm64 and
> include the numbers with the patches, which as mentioned will be after
> mid-November. Finally have a use for my arm64 machine hehe.
GMAC signing support has been on my TODO list for quite a while. No
one else is currently working on this for ksmbd, so I really
appreciate you taking this on! When you submit the patches, could you
also update the KSMBD Feature Status table in
Documentation/filesystems/smb/ksmbd.rst? The =E2=80=9CSMB3.1.1 GMAC signing
support=E2=80=9D entry is currently marked as =E2=80=9CPlanned for future."
