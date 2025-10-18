Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883A8189906
	for <linux-cifs@vger.kernel.org>; Sat, 18 Oct 2025 01:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760750065; cv=none; b=hnet330BATGPdki1Lg5n0Bd3kVao18hNfTqSoxS1lFjiFNl27oMW7NmpM6Ji0dOadLhpJ+lhJfusavGECR03Q3KZKJAofBTPO0OjjtHdEMKXfH29FI6kCInBDfTUPfZTiUY2d/H+jHil4b3uFI7feI0E0/0sm2XW/IMUiRLaeNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760750065; c=relaxed/simple;
	bh=6v9JrvQsPFybALvBmLT/GeyJQdxeUhOnHL8fO9QP2Ng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E0N0yrL6Y0AEr64kopGGsMrbLCDAeib6sCZvPcRUcr8HSVYXUUZkP6IPB1Bn9xG8mpfTrEeoveVrKBcnKYL0HisuXB4s+v6jekSd34B1jE764N7BuDj1sqLjZLEfe0wfnfEdc3SwfDt+aomGSAirxSQuFOg52rm8kVrFTLPuF+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OuXKvYYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OuXKvYYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C169C4AF09
	for <linux-cifs@vger.kernel.org>; Sat, 18 Oct 2025 01:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760750065;
	bh=6v9JrvQsPFybALvBmLT/GeyJQdxeUhOnHL8fO9QP2Ng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OuXKvYYXs81sgOQ1JRCBGQjFKR0A54pFpkAB1RwmvLSTm3IDPG99Zc89CxMDHFhgz
	 2Zm+YPWlmd+u8IwBxjcThaLDbnbQ2PPTsFZyVhH5Gx6kfWEr+9YwmW6AFV7iWnqu2b
	 aBQvOm/b4b+MtoVXxIJ39umhy4dM+DEbinypTncaOnM0rIStocG/rrw81Th3my/RIo
	 phbZfN7wI2cRxccCqbHs9dhflcb2rV4cxXn+bIv6Raq8VTwQr2thKNsl21d1xl61Bf
	 GDsc1F1IJCj6Wp2BGkov01AfN8FjOXc0e/ngfsKj/I6vB+ZQR1F4WE4VSdKJOU9MB1
	 k/XeGb0UBjtlw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3e9d633b78so589654666b.1
        for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 18:14:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXp5jDdampfxeF1TM0OtxEJ57qcdVJFKsBEVt7ysZ75h8uNBct7j9oyLd/MDc+P4pQez+ycTdAgfT4H@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/lLBBaJWZ+ZMFlvfOYSPqJ9k0EzlkdjWljElbdYO86N/hvms
	xemXVbe3hC0bV9ZFJE/i5rS1kOtB3NxV4xyXFEIXMeMbH14nqZ5dGdEFvohsYcYCQmzJ75TvesH
	k9R/p3IHnQwHMVbVmMSltqTv8NQgVE+I=
X-Google-Smtp-Source: AGHT+IFNOoNKIqJZb/Wu3oG0d9wHBg5D7b2gLVqnTee9g4CiKNIvsw8JPiYTTffBUU5Me+rI/MgYFGzhp8lZK2XCI0I=
X-Received: by 2002:a17:907:a78a:b0:b3e:fc83:fa83 with SMTP id
 a640c23a62f3a-b6054cdd5e0mr1076191066b.26.1760750063629; Fri, 17 Oct 2025
 18:14:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev> <287b5c2b-3cb2-4115-a16a-bd1ff85f5071@linux.dev>
In-Reply-To: <287b5c2b-3cb2-4115-a16a-bd1ff85f5071@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 18 Oct 2025 10:14:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_zBVZKM8ZqJwg5HcdfW-3Ln6LrCehaVNYm6CJ6LFc7VQ@mail.gmail.com>
X-Gm-Features: AS18NWDLrGWQ_9gBH-uDHoHrpf-nfX0D1-zewFfpRYE_YLecaIUeOwNEO2zSpmU
Message-ID: <CAKYAXd_zBVZKM8ZqJwg5HcdfW-3Ln6LrCehaVNYm6CJ6LFc7VQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] smb/server: fix return values of
 smb2_0_server_cmds proc
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 11:56=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Hi Namjae,
>
> v1 has typos, and I've already sent this v2.
I have applied v2 patch-set.
Please check the ksmbd-for-next-next branch and let me know if you
find any issues.
Thanks.
>
> Thanks.
>
> On 10/17/25 6:46 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >
> > These functions should return error code when an error occurs,
> > then __process_request() will print the error messages.
> >
> > v1->v2: Update patch #01 #02 due to typos.
> >
> > v1: https://lore.kernel.org/all/20251017084610.3085644-1-chenxiaosong.c=
henxiaosong@linux.dev/
> >
> > ChenXiaoSong (6):
> >    smb/server: fix return value of smb2_read()
> >    smb/server: fix return value of smb2_notify()
> >    smb/server: fix return value of smb2_query_dir()
> >    smb/server: fix return value of smb2_ioctl()
> >    smb/server: fix return value of smb2_oplock_break()
> >    smb/server: update some misguided comment of smb2_0_server_cmds proc
> >
> >   fs/smb/server/smb2pdu.c | 30 +++++++++++++++++-------------
> >   1 file changed, 17 insertions(+), 13 deletions(-)
> >
>
