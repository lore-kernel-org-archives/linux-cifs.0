Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC5736164B
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 04:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772167401; cv=none; b=OBDOwB0nBXuNhGnMVvGQLG+l3oZKroUiv287QngvZ5gQazIa5TeMfTWDigrZo5AbgI/1vBUfHCb68WiQyL2qmW0jy1aExDxdmGRiQLzm8M3gTlQYpMz1g/hyc8ZqFiBWLpQVT3bUuzTiYqpOr6BVeOLfdpEpXfVD0h6RnQOJeXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772167401; c=relaxed/simple;
	bh=sanhf0On8qaZeoHSuGMubY/IrnKYHLT5kw2Q2gOp7N8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M6sdfrBzYXjEM6sdFobo7/7ShcsFXbM7kThUQ5QuNZRq94TLsAxRA89nE3tloNvHhDEGhupeiokSebmC0Sx2CBszW9lfHUSe1lh8TENMoIElR7cNHY/3Mnt3BQaYgRLrdb/szdcWB6oc2aZyyLZ/13ZZ1iqBHMNQhSo6FUFsCpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MiSUwBMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MiSUwBMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2C2C2BCB2
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 04:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772167401;
	bh=sanhf0On8qaZeoHSuGMubY/IrnKYHLT5kw2Q2gOp7N8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MiSUwBMJus8Ne0pSRAcSLQarlmTOaeEo1M+n6vCxY6wpqdC1y36KpfCdtNtLct0yQ
	 hlUS8RIuEoSBIqHAXBeUsQUfcYwDZ4H5tNuy2QqcSXM2XtICOCZlYgd0REpRfS6j6v
	 LcZr+qj7YR76X9gN3xF3o6du7iV3ZUMOAxXs7LA4H5cqZcv1m9t+oad7M7ykbeZPE7
	 y4J+8634lnGLsJt3la2H+SAErGlUyIM87x41M+qwlwAvAcT8DELSVKvWigsv4+SLGb
	 FF1IUgg7WqhqR7IweLh+Rq/+1NuKdzuveesIIzfRiNffLDI3q1raE+ThPfI/K72BKe
	 ASlBmS4HHRetg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b904e1cd038so218325866b.1
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 20:43:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXXQY28I8rWthV8Ean+dagPI71Ge/rfuM6Grf8YPxOQNUcduPIrSJTq6sxHtE/8VcWfYMT1S1GQSFUF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7f4bd3BtXz2TGPkBQlkhR56eD9DWYpqCICGoAxBLdDOxgzLwm
	HmqfZCaMT1yInbpYKIq4sb9ijKAF8f5aRlPoJ5cte6+qSUDWdjkswbRGcKtJDYtYSibFU+PBCrm
	I+oWCztEI+fxWpIz3t7heinNrDCihKYM=
X-Received: by 2002:a17:907:3f0e:b0:b87:f6fc:aea9 with SMTP id
 a640c23a62f3a-b9376361393mr66167766b.9.1772167399431; Thu, 26 Feb 2026
 20:43:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
 <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net> <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
 <59d5c1a6-7a7f-464a-aa62-e53daff8870d@roeck-us.net> <f3604a74-3caa-4737-bfc0-d93feb988176@chenxiaosong.com>
 <90fdfba1-e0be-4656-87fc-1921d233da37@chenxiaosong.com>
In-Reply-To: <90fdfba1-e0be-4656-87fc-1921d233da37@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 27 Feb 2026 13:43:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8AgR8PcCMsNm6LeCh3uqn3VBkF8+oDH2ffF=baNpMT_g@mail.gmail.com>
X-Gm-Features: AaiRm53UaTQOrfPDsDKnSv2hM_qlgOUv1sDJoLHESf1Llk9KJ9DCwBANmp811TY
Message-ID: <CAKYAXd8AgR8PcCMsNm6LeCh3uqn3VBkF8+oDH2ffF=baNpMT_g@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Guenter Roeck <linux@roeck-us.net>, smfrench@gmail.com, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com, 
	linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 27, 2026 at 1:13=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae,
>
> By the way, smb2_open() is over 900 lines long, and we have already
> encountered several memory leaks in it, and there may be more. Perhaps
> we should consider refactoring it to make it easier to maintain.
>
> What do you think?
Agreed, I think we need to factor it out with a helper function...
Thanks.
>
> Thanks,
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
>
> On 2026/2/27 12:07, ChenXiaoSong wrote:
> > Hi Guenter,
> >
> > Sorry for the late reply. I had some family matters to take care of
> > yesterday.
> >
> > Please see the following process:
> >
> > ```
> > smb2_open
> >    smb2_check_durable_oplock
> >      opinfo_get(fp) // inc refcount
> >    ksmbd_reopen_durable_fd
> >      __open_id(&work->sess->file_table, fp,
> >        idr_alloc_cyclic(ft->idr, fp, ...)
> >        __open_id_set(fp, id, type); // insert into file table
> >    ksmbd_override_fsids // fail
> >    ksmbd_put_durable_fd
> >      __ksmbd_close_fd
> >        __ksmbd_remove_fd  // remove dh_info.fp from file table
> >    // dh_info.fp has already been removed from the file table
> >    ksmbd_fd_put(..., fp) // fp =3D=3D NULL
> > ```
