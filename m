Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E97728C5CB
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 21:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782337801; cv=pass; b=sQ69DGkYPkIcIDGwIDUxSAtI7J3J6zf8YmhrNL4dWlj9SNS22jY93RSE1aZeWBkyymO6yg2uYTwzVm7Lz/QzHdG8gHvaO8hBMoexmyMIR5aQ52awm9EYVhsPEs44G3ZHt9Izv74ZpDApllBgvyequRPAKw896b/BwqCtuki9zf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782337801; c=relaxed/simple;
	bh=lhThN8YcWYNQxQ4jLUtz/c+87kIoSXRl0savXNOsZZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l88DB0ZjDGlvYrLGdCtPJJZAk3CdUaPEWIQ021ZOmZYMhzCMUt//FURlakyiL8SOWtQ4sG3sEpUBeFv74TontMrjLIsp/76aJnEctLjAPVHJ236PupISdzuKAELyMQPsrVxXeAHj9oQrGs2WH2rd1LiqF0uJ7gLFQftiXl5lVDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nwE69A6g; arc=pass smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nwE69A6g"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-915d64fead9so31920585a.0
        for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 14:50:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782337799; cv=none;
        d=google.com; s=arc-20260327;
        b=Usg2d9F7cBcogAu6TgYS0WZeYRLNrEa1n7a6nycMv9PIaLXuNDl2Q/NuVLmhnUF/zY
         wWueQmRD0k32bKWIv4ilDxhqO/mgoH9mgeqJTV5LGmiSzvQE9BLCPJH8AyTxr4XJXElU
         b2z5SG5B3N1kJuxJ8m/ZUuwQBa1Pth5rVT6fSf85fcE8HUfVtujnJzZLbHHUw7Ihqp1c
         79BLoR6XQdNG50P4OnozafYoaa7Icq3NL3Nb8Gx1CF3NiReDDxixIHtgLlgebqPuzEzK
         2J4tHzhgez8aQUSpHLaixArBbhpcDsrM8aMgywYqvAO4GV70q5ZJPgRbBY/GrszWUrGE
         qZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FNZfJM0oIpqSd/mZDdXT3nYzIbY4qJcZx1VSkcV6AKU=;
        fh=gTYp8yml5XdlOhkmNXtKS46HJe5SsvyA+dwrGXFBB0Y=;
        b=HMTYljbwF9VfUL/xhBgVtpj+syOy1EGbkU8jLfrdDhqKJdSwlQBO5VTGcTPj6EQpI3
         VHzRIBoEU3MdFB+jVgYBVLuHBVE20K9I1To/89+Ukua5tUULgPm8lRphASKYCKXCTwr/
         EBHVSakvyabtMxjxkTb0GvCS/jO8u5X3n/WExv6mNb1qFJIhXRrJibueXzHCJ5DOBclH
         5R9QwB5r/FzQkmu1YdjGgpu0zznBHm2cXLlFtG0L9dQCXBr/+jdj4VaTo0+kCaHaJtzZ
         3hFD+QCypgZtPWY2a1j/qIVobM5mP8wghqWStCm5qhStuKvGkHgvofO3k8+fmR9RaLpJ
         ZkeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782337799; x=1782942599; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNZfJM0oIpqSd/mZDdXT3nYzIbY4qJcZx1VSkcV6AKU=;
        b=nwE69A6gnmJMGLPEuNvpAOzEdyGNjw+MhbLyfVY3Xg/D2iPggNfC8+HoRKyYk5/e7P
         vXVtbGKlfVnzjxk5gWGlT2yvctEbKAdPY2TkxhWw0K7JHCsKtbiHPJ54WHjqVsKIkBNP
         Y48Zs07ogG+/3tw85veGhSEWEzc5YsJZJ+OmHfGZpwJTadxdOV5NqbxwPbykp3jG8t+E
         11HL8rUV0I5WpecOr/gQjbg42NH1L0s1uWH+y47WUbbILlCkOFi0tSjUiku5WcjofEQG
         gsCH7ehqd3AKZMIe3Qyy5zop2Inn+jZ58ZMt0xne5UwnlkKJvFl0mL/VfMHeKsb47ziH
         gCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782337799; x=1782942599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FNZfJM0oIpqSd/mZDdXT3nYzIbY4qJcZx1VSkcV6AKU=;
        b=AgTYTudGrsN8p0b/mjGnLBU/1F+nIh7a8Nd0eT2t5ZoWKhkzDiXgwHUtka7TH6p+rt
         nQ/rBLrtDoVXSKk+18MVLYATPYPUQzFqngzc9YFjvPy0C/lX6e8FgopXaEStDwUb4W/3
         lJ1cyd/G04426B9Pf/kq2kKxzAMVbmI6CDLVHnlvotDA5fDp7J707zCiJBEq1c8AKRTh
         xiOQ1KQWArdaO3IRojupC2YaSdBedR8zMbtZo1H+Pss+YMjBUHiQUBbYsDC6S/bZUHpz
         NDRmBgXXg0hCfmPIWin8jHqBOkZuIxtJrOlxgCy8a+hBsW6jnNswydRAr9llRG5QGt5Q
         ptVQ==
X-Forwarded-Encrypted: i=1; AFNElJ9DeCVfT54ZX58UsB4w4OhdOFI/Z2tB3oBR+NjLxGr3C0SSqI7Nz1JSsgcmdMtZP92gDn95drnhJKl+@vger.kernel.org
X-Gm-Message-State: AOJu0YzsqWPnglWoL5UXAdjG4brrE5X0NRE0lgeUz3hpCJVq+7K0Ehpk
	dI/DyheZMoZ2AUEmUOTUIt6tGcd7/BefCvsByeQzt/1y93zCKdiTuFajvYUQXy8HlPZsPRKZ/ec
	qsKYa3VWVkb0Qv2i7zKyw0B5UMBSTjsk=
X-Gm-Gg: AfdE7cmYZG/KYop7BcsfHaxAJwc/jGyCfta6E2O5X/FiI9iLSWyHnjnIVE0+jgjB9Ka
	pqk0TX8/lN9cbYFgoyTDb6ahoCVdVc1OyK9mrnJSQpKhB8nR+AlYNOw1ariUSn+quohBsQInhJM
	4fq6gEtdksRw98rsogKNhq/SAsSG5LIRVb/HA2PyM9IRCnnnk5z5FApgsjHyqN1IhsINmeJfVxm
	cKkmFmvgtBBeNkC815kXfAFJ7NQkNEcXYeih0358M8HcfMV1K74ebRqNmDY0Xi8xfO4bBsb8az1
	Mdcn1I0I/BS6w+uErtEzmVEd2RjH5X2LXTueg81ixoeIocQ/q7hr/oGkYWCM/fn0haHFHbMvBtg
	buQDXqTpClDIanEwYgZQgyuIMh+PZOr9MFdw9oX1hmF/36vaNvHjqu4GZvn01qNuwUqCXIK3xgp
	sXo36tIq+nQCg=
X-Received: by 2002:a05:620a:2601:b0:91e:df9f:7804 with SMTP id
 af79cd13be357-926031d323bmr1465819785a.38.1782337799347; Wed, 24 Jun 2026
 14:49:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624021550.1548952-1-huiwen.he@linux.dev> <20260624021550.1548952-6-huiwen.he@linux.dev>
In-Reply-To: <20260624021550.1548952-6-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Wed, 24 Jun 2026 16:49:46 -0500
X-Gm-Features: AVVi8CeUzpmanzzZE6jOh42XXdrQdYpVYXC_A01Jcil3wSpk6kHauI18NvV5h_0
Message-ID: <CAH2r5mtTp09rMTuA_2Bp2BamMzOz1Uc4C=FNnToMESaFn=1MkA@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] smb/client: do not account EOF extension as allocation
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next


On Tue, Jun 23, 2026 at 9:17=E2=80=AFPM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> cifs_setsize() updates the local inode size after SetEOF succeeds. It als=
o
> used the new EOF as a local i_blocks estimate, but extending EOF does not
> prove that the intervening range was allocated.
>
> For example, after writing 1 MiB and then extending EOF to 10 MiB, the
> client can report the file as fully allocated even though the server stil=
l
> reports a much smaller AllocationSize:
>
>         $ dd if=3D/dev/zero of=3Dtest bs=3D1M count=3D1
>         $ truncate -s 10M test && stat -c 'size=3D%s blocks=3D%b' test
>         $ stat --cached=3Dnever -c 'size=3D%s blocks=3D%b' test
>
>         client stat:                    size=3D10485760 blocks=3D20480
>         server stat:                    size=3D10485760 blocks=3D2056
>         client stat after revalidation: size=3D10485760 blocks=3D2056
>
> A later attribute revalidation may correct i_blocks, but callers such as
> xfstests generic/495 invoke swapon immediately after truncate. The swapfi=
le
> hole check can therefore observe the inflated local i_blocks value and
> accept a sparse file.
>
> Do not grow i_blocks from cifs_setsize() on EOF extension.  Only clamp it
> on shrink; allocation growth must come from write completion or from
> server-reported AllocationSize.
>
> With this change, EOF extension no longer makes a sparse file appear
> fully allocated before the next attribute revalidation, and xfstests
> generic/495 no longer accepts it through the inflated local i_blocks valu=
e.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/inode.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 0af93e881608..84d95d2c3ed9 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -3038,13 +3038,20 @@ int cifs_fiemap(struct inode *inode, struct fiema=
p_extent_info *fei, u64 start,
>
>  void cifs_setsize(struct inode *inode, loff_t offset)
>  {
> +       loff_t old_size;
> +       u64 blocks =3D CIFS_INO_BLOCKS(offset);
> +
>         spin_lock(&inode->i_lock);
> +       old_size =3D i_size_read(inode);
>         i_size_write(inode, offset);
> +
>         /*
> -        * Until we can query the server for actual allocation size,
> -        * this is best estimate we have for blocks allocated for a file.
> +        * Extending EOF does not allocate the intervening range. Only cl=
amp
> +        * i_blocks on shrink; allocation growth comes from writes or fro=
m the
> +        * server-reported AllocationSize.
>          */
> -       inode->i_blocks =3D CIFS_INO_BLOCKS(offset);
> +       if (offset < old_size && (u64)inode->i_blocks > blocks)
> +               inode->i_blocks =3D blocks;
>         spin_unlock(&inode->i_lock);
>         inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
>         truncate_pagecache(inode, offset);
> --
> 2.43.0
>


--=20
Thanks,

Steve
