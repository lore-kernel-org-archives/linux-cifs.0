Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A6D3AB5CA
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025293; cv=none; b=YpCj6JZCL/+ztxsG25o690NRbgWIeUbiKK2SIh1FJyG6MaGTwAshfD1A/M38GMRY8TpyVLT2hbf48qmIEImv0sLnnnl4Spdcoa8+T76nhLqelpl0Fd/8+I9by9DjV70eqL1cHFx1PpKpY9LvCunicZOlCJ7LHAmy8/lCL4ew+lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025293; c=relaxed/simple;
	bh=cFPMW0P7cKdRbO9CQTPEJSWd5zRICj6UCMpcicFbZpQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pd5vF5B9JPIz73Ro+JjtV6d5qyETxP8XvLd/qE6x1g7A2Dkh8ipVJ1GYhXd5GIXfSk9VTrzoz0QH+BZOeB3xe0zYLJ8IBDg5Tw2Y9M9I51+09c+67tySjby3nWfaFfCfK7LkByRrYHrk8CAD7ifIBQ+c//IOuIScsFKDYtoQ8Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHFEVE1+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHFEVE1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7771F00A3E
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 03:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787025290;
	bh=P9qb7xvAuUOkdFU66SJ8ITM/vrJ+hW86QuRO22LcwPk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SHFEVE1+elm52nvo6RlLl7IhkdSJ2Aw3MN10RwcrAeOyuuZdnYFftMUjCHFaN9Zjx
	 lLfOi6QI32T8JZoQr5R56UHwDwErdj1NtnBLD7yjemsO+TiZjZ+RtHTkwk+A2gQOTq
	 3oTzpHSLwfXR4LXuSHGV9q2nzgCsXAKgMtx4coiY5Rbvb7UXFshQrDJ7oE8HABMW8K
	 BWbn+/owAwlBjg15EbqzumTXxR8R8D7bPtdJKV4oksA9KNnkf5tm9xMOxatQx6WLz6
	 DuADVyrmmV7dX9/ervirYzS2nDNCkjTTZ20faAjMS2V10OV1X8O86ufn4v5dgF+hMb
	 A/uQfptYRUmeQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c167aa9500dso581104366b.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 20:54:50 -0700 (PDT)
X-Gm-Message-State: AOJu0YzCkLGjLyR9omx0JFmLiBZOpLawFqbqxu9hvkmGJedX8SWf74Nw
	at52cKng5GhaxyTyVgBJIKdvgdxeLa+3bpqLLJRCUnE1doas5oZ0Qy2gNhV9FdlNhC/QmUGmfOH
	PKsCa4btSWdi5q7ZCdORHHE+4YtzeDfo=
X-Received: by 2002:a17:907:9814:b0:c19:45df:1856 with SMTP id
 a640c23a62f3a-c2188a9c1dcmr281676266b.17.1787025289432; Mon, 17 Aug 2026
 20:54:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804234205.72986-1-stfrench@microsoft.com>
In-Reply-To: <20260804234205.72986-1-stfrench@microsoft.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 12:54:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8_Su3e-7UbF4gWVhWzRecXxZckRNGD9XcYEkt9GPaf=w@mail.gmail.com>
X-Gm-Features: AcwNN1UQ5XOHAtXqglUZKM5PhLxRR51QoE7DERphKXkrkqowgB_LEot5ZiW3Wgk
Message-ID: <CAKYAXd8_Su3e-7UbF4gWVhWzRecXxZckRNGD9XcYEkt9GPaf=w@mail.gmail.com>
Subject: Re: [PATCH] smb/client: fix nlink of an overwritten open file
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 5, 2026 at 8:44=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. server: systemctl start ksmbd
>   2. client: mount with `posix` option
>      mount -t cifs -o posix //${server_ip}/export /mnt
>   3. client: touch /mnt/file1 /mnt/file2
>   4. client: C program: int fd =3D open("/mnt/file2", O_RDONLY);
>   5. client: C program: rename("/mnt/file1", "/mnt/file2");
>   6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
>                         stbuf.st_nlink is 1, should be 0
>
> This patch fixes xfstests generic/035 when mounted with `posix` option.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: Steve French <stfrench@microsoft.com>
Will apply it to #for-next.
Thanks!
