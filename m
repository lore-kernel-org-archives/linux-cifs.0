Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4B5137927
	for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713545291; cv=none; b=MEprs3BfNsR0ToF6uoiMEvFWOLgntoYqgcMxgH/K8m8LX94ROnhqVMSN//xz8EYeewCk0v/fyRI9nwZEayOu8q3owWAqlohxt6CWPYdx+MLbP7LHCZ1lh/7YzHqhjgVIq0npQk0clcPv96zCd6aIisfVQVTKOcsKqjMTlg0VBeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713545291; c=relaxed/simple;
	bh=AW2hb1C3fjwFgl13WfpZPGYkEutVCRROK/aP6HxKDlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MXD0aF7qRk4E72ZSbTuhfbY7244z9KOLLekIvtL+xXGdTVMxk7mJg2rvo4gMTf+ToxCHfB+Df2x3zbPlSdZEjBe12u2lpUUXADGU4jIMZ2WmaPYUwwqeR2PIbmKwOSvxyVOaA+ik/5jIsQ0ErpN692TacP+P5o0lPA/KzA2OdxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JtCv6bD2; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtCv6bD2"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2db17e8767cso31755371fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 09:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713545287; x=1714150087; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LnmBJuOEJAYxp5TLjE8lA3NotmO++GfIBIhyvO8ta/g=;
        b=JtCv6bD2iELSJVdbi+lWQaWOmbg5XGo1b5+6EZZW+I3ito0GKz/CH/74rGxOFqBDLt
         Nyo73SAOqhbJAoYIHXaN2GZddW/PO8c43TPyaphQ/4CFY1wqqE/p43LwwcZVuZtZ5mSb
         8F1Gl/YYgzhK8UfPgF2mT1rifWwY/rz5DXslN1wACEIwQ5HO+MwxEU5flQvIXvIT4LIp
         Rw9ZsUVtfvs/6AIfzOexKVoHAi6AD+TvNIjJxvKXY1M+hm1ID3+GVWgqeIKkIJsK8+hq
         KLlTmbFkR4fvhNWpA/qmFiLb51YrEmg73SH+HlDZOkbayvLUf7mmdU7KynwOq1SGA5xK
         UEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713545287; x=1714150087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LnmBJuOEJAYxp5TLjE8lA3NotmO++GfIBIhyvO8ta/g=;
        b=wev5nNp37yQpn3p2hzxB8NPBCtsN3Al9wl1L9IAFT1uofMFJG5vSrlfah/uqrDB6E3
         4lYIaIBtYzerOUMerNrM/aBotq/6uwlLkA/tTg96lzJ0n7RfXKOkAM49hGNex0PfkR3r
         yrOIyIamVJQXodMeo/TE1ktswnmcINO9pourvtHwzjpkmEsuwhujPHBAQn9Jt5FZhiNO
         t+AZCHLvhVqPXBqTf/RNvfOK2RNy+0A2X8ssAFwn7186Nrp8G+tjbvI8px+atvaDFiaW
         ocvN9bJSsRnVM0N0BkQFE8aiyHFDrs6/H37d8o9tWFsFPT8QqVbCK/ZhqilkKXsj+5LM
         fckQ==
X-Gm-Message-State: AOJu0YxFXtIQ6CK+N3Aoosp/78ERKFHOWqkgp/eA+4IOxIDrR68ZubVB
	AezuuwACFI0yMvpEvzMX46vKL5/enYe7fPRtkKB8sJXAPapLUM9Xa7M8WJIg/CubqZjsobVO0rW
	Qqd9sp4KMgCoXuVyrkZdvujmRbhI=
X-Google-Smtp-Source: AGHT+IEp5gJ3wuq9eWJFjH5ecPRC8TDT4E6OoITqeSISKIoDAzK97wwiTXzNytJZSnMqCVWZTf7+0LU9XUkfu50gor8=
X-Received: by 2002:a2e:9895:0:b0:2d7:1a30:e881 with SMTP id
 b21-20020a2e9895000000b002d71a30e881mr1797724ljj.12.1713545287258; Fri, 19
 Apr 2024 09:48:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240419150507.554196-1-pc@manguebit.com>
In-Reply-To: <20240419150507.554196-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 19 Apr 2024 11:47:57 -0500
Message-ID: <CAH2r5mv_pahAs=4VsMEh_Ctajf97W3+JAALve1qmOn7AHNCD9A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix rename(2) regression against samba
To: Paulo Alcantara <pc@manguebit.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I merged this into cifs-2.6.git for-next (pending more testing) but
wasn't able to reproduce
the problem. Would be useful to know if others could repro the problem
without the patch
(and verify that the patch fixes the problem).  Testing it now e.g.:
    http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builder=
s/5/builds/94

Also would like any feedback/testing/comments/opinions on David Howell's pa=
tch:

        cifs: Fix reacquisition of volume cookie on still-live connection

On Fri, Apr 19, 2024 at 10:05=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> After commit 2c7d399e551c ("smb: client: reuse file lease key in
> compound operations") the client started reusing lease keys for
> rename, unlink and set path size operations to prevent it from
> breaking its own leases and thus causing unnecessary lease breaks to
> same connection.
>
> The implementation relies on positive dentries and
> cifsInodeInfo::lease_granted to decide whether reusing lease keys for
> the compound requests.  cifsInodeInfo::lease_granted was introduced by
> commit 0ab95c2510b6 ("Defer close only when lease is enabled.") to
> indicate whether lease caching is granted for a specific file, but
> that can only happen until file is open, so
> cifsInodeInfo::lease_granted was left uninitialised in ->alloc_inode
> and then client started sending random lease keys for files that
> hadn't any leases.
>
> This fixes the following test case against samba:
>
> mount.cifs //srv/share /mnt/1 -o ...,nosharesock
> mount.cifs //srv/share /mnt/2 -o ...,nosharesock
> touch /mnt/1/foo; tail -f /mnt/1/foo & pid=3D$!
> mv /mnt/2/foo /mnt/2/bar # fails with -EIO
> kill $pid
>
> Fixes: 0ab95c2510b6 ("Defer close only when lease is enabled.")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/cifsfs.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index d41eedbff674..8907bbcd9f96 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -389,6 +389,7 @@ cifs_alloc_inode(struct super_block *sb)
>          * server, can not assume caching of file data or metadata.
>          */
>         cifs_set_oplock_level(cifs_inode, 0);
> +       cifs_inode->lease_granted =3D false;
>         cifs_inode->flags =3D 0;
>         spin_lock_init(&cifs_inode->writers_lock);
>         cifs_inode->writers =3D 0;
> --
> 2.44.0
>


--=20
Thanks,

Steve
