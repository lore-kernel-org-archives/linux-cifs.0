Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4151D5CFE
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 23:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785972370; cv=none; b=pOG6fN3KlP60Z4CEEBJ3OVBI52SXO9N8FGVaRnDQLRmUsVurw1BU/Fl1LzRPIRbugJoXnryaHlUCH0iE/+T+PrCw9x7ItahlwYVX+/emeX4YBiFS0utKiTBkiJpFYRqTW+CexByowNkWlny8mEpnV83Kpu5xlbnzQgLVbJZ+f3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785972370; c=relaxed/simple;
	bh=NBQjhB81Gdnc9QxyA3kFvIYUfrKDvm8G1l42oQUycXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vm0C/kvUkShfyrQcFaRiMVbUCACuGwKMep8YMGPJsxW/et2c2nnqp9OD8ShmyMdUJSJp5f1KMWARCY2yMYLu+zUfRTy/CNIPxTYgFW9DV8QSkv/nmaAh6BspTv7jch5S+WwB51LyqepfDg53BpY7uaClskxHILrBVD9ivoIDfRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwcxlOpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwcxlOpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0681F00A3F
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 23:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785972369;
	bh=t4Qpz943OS/jIxGmiboZuf3Jo//izHI722K1XEESgD4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QwcxlOprZMlRvWuovIBiygjotBD24WlzpBk8NwHSp4wgc/tgbUXhc7zGXDU+xj05e
	 fe72GzW+/8DRNtTgRlpcPmHV3osDlWk6hnhozP448v5Fgnt5o0ctwN4Hv7U/W3et1A
	 jH9hR1947KnqCXarQTPwz+0bciuqYoSMwuYdLVJ+N7pjVQNQeFPpiKtvkfQbBLzmId
	 p5BOJDk1BJMcFSrs1kP7QMrD3RXmRNfxqLOxi+s0We3vx6b+0EhDX9nGS22K/0uE7K
	 uqo6CtZJvtyQ5XLP2G+721SouWBd4aSVHQVlkcagi5n2J6anjkkxkFZwxp7IazVSGj
	 0V/u50P49/nEg==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1677c91969so184904866b.1
        for <linux-cifs@vger.kernel.org>; Wed, 05 Aug 2026 16:26:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoIT2lJXCGNfqJx+R3KT9FoFy4uEIG3IFeAV3Gn+hBDeC9dRwdrhOjSEttMEJfSMiXqcBqdRlZp2w80@vger.kernel.org
X-Gm-Message-State: AOJu0YwIXsDEmPhJL7idwbolK/S2Kz4XCTb1p2Uv1+YidpEYK1WZoyXf
	iGvWPS9/nDuPZ8RTl+WPRg0KO+pLXtCxq8S0cKsWNw1UzQVOmi37JwNr5uw3OjPAZK5aQyZMu4B
	5vWpMcv8SzyOilyF5/maynWoUIddn3dY=
X-Received: by 2002:a17:906:ee88:b0:c20:3042:3887 with SMTP id
 a640c23a62f3a-c2039ca7e50mr463736466b.22.1785972367655; Wed, 05 Aug 2026
 16:26:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260805051112.305078-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 6 Aug 2026 08:25:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd91pPDcSHgJs-_MdBbs0_22Tzb6LL6udVfFMGOYSx9Pbw@mail.gmail.com>
X-Gm-Features: AUfX_mzB5nFg33Ow7kqh7x_9EFMb3RlWffz3eX37ii2KriZc2ZnILQhuaJPCmpY
Message-ID: <CAKYAXd91pPDcSHgJs-_MdBbs0_22Tzb6LL6udVfFMGOYSx9Pbw@mail.gmail.com>
Subject: Re: [PATCH v3 resend 0/3] smb: fix xfstests generic/035
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com, 
	senozhatsky@chromium.org, slow@samba.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 5, 2026 at 2:12=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Resending patchset due to mail server issue.
>
> v2->v3:
>   - Patch #02: iterate over `global_ft.idr`.
>
> v2: https://lore.kernel.org/linux-cifs/20260804123301.285434-1-chenxiaoso=
ng@chenxiaosong.com/
>
> ChenXiaoSong (3):
>   smb/server: rename to ksmbd_has_nonposix_open_child()
>   smb/server: deny overwriting targets with non-POSIX opens
Applied ksmbd's patches to #ksmbd-for-next-next.
Thanks!
