Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C828633F7
	for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 16:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708533280; cv=none; b=NszM6O2q2S4c6YYPhulB3Leq6gdHfPtlLX/h6PHm5izmyYlRh5qOvmAO+Hmh4ybUJXMHVHElPAlfYhy6Xb3kPlNufTAnDA5Xd71mHFMS2M/9oo11TycaE1UAY+8WJguk+oCfhPRLgS05gqW3cMo3xG6rpDg0czHN64LuDvKQTEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708533280; c=relaxed/simple;
	bh=tCh8EfGupR/stySfs1KIXEiN5NJgJJ4/TRW+x+mLWx0=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iDVWwXkEgBs7H1uNfKEPcP+omn/2jGDV6apmdKn0fvUzD5OIqLE/qEOGQgvyjdt56+yp8ZquSE1nVdbUiPSf09O5CudTbtqS/ok4J9NRbbbAAOJSIO2JfEsFaJS4WdIddiSef2avv0ilWuclKZU9kIF7rIJhk6ePDw5Z0I8jOvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggAHjApw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggAHjApw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68975C433C7
	for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 16:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708533280;
	bh=tCh8EfGupR/stySfs1KIXEiN5NJgJJ4/TRW+x+mLWx0=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=ggAHjApwdMVlNrO3MAa1lH1TO+VNP64IzdapTMQ0qMRd0d84LgXOowN8WwSSCE2Za
	 4dyzGk19xpUyft5cqqE9NSBZKi7jmSPrbeYRr78Vd+oPz2lK1w9MSx2J900E2ZYOFn
	 6Lb1Q8fMRDQzUIfX8IdmOchkpdu1RFH8fslwNVMfA2kxBC/z3o4FCDyI8M2h2gVkLC
	 aAdU5Vzz2OsycK1/FVSsLwMwBaa3aKDBDVs96f6fFzaO4zCQ+D7cCOarojfCdWpSLk
	 +CViZPdacn7RRPa4dde/DQcIQrUicDZIiB5JxFMUHGZb04qQd5rpzdrAiPODUF9kKi
	 5VZsNfjRkHkDw==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-599fc25071bso4523320eaf.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Feb 2024 08:34:40 -0800 (PST)
X-Gm-Message-State: AOJu0YzdeCpkHJEkdeAEvTJ8FR8pkAxGosbXdHpbqHnviJHWweZotWsS
	GOiscVfMSGUfiNTCcPHVeUwjYh7/YrbhsY+IToaNE5JJsRWMdnyPnQXNOjg6u5Y0B/IzFHSCqoZ
	Xhjm3Ezq+pEab2d2aTdHLjgzVzL8=
X-Google-Smtp-Source: AGHT+IEa4D42TdH/qKL1khWhSJoVtZ5UIz/OB7/80npw3VBIjIdFdlIHovquVGVgt2ROyr8obOOSBP0PZwx9Adb/+mY=
X-Received: by 2002:a4a:6b46:0:b0:59a:e669:a37c with SMTP id
 h6-20020a4a6b46000000b0059ae669a37cmr20248022oof.1.1708533279716; Wed, 21 Feb
 2024 08:34:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a8a:c12:0:b0:51b:642f:123c with HTTP; Wed, 21 Feb 2024
 08:34:38 -0800 (PST)
In-Reply-To: <20240220142601.3624584-2-mmakassikis@freebox.fr>
References: <20240220142601.3624584-1-mmakassikis@freebox.fr> <20240220142601.3624584-2-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Feb 2024 01:34:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9JnrLdULRttM7FApWF1jTaF5+JAm+=dvhO0a6fB1Pizw@mail.gmail.com>
Message-ID: <CAKYAXd9JnrLdULRttM7FApWF1jTaF5+JAm+=dvhO0a6fB1Pizw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: retrieve number of blocks using vfs_getattr in set_file_allocation_info
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024-02-20 23:26 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Use vfs_getattr() as inode->i_blocks may be 0 on some filesystems (XFS
> for example).
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/smb/server/smb2pdu.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 1a594753f606..f4de2198b71b 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -5812,15 +5812,21 @@ static int set_file_allocation_info(struct
> ksmbd_work *work,
>
>  	loff_t alloc_blks;
>  	struct inode *inode;
> +	struct kstat stat;
>  	int rc;
>
>  	if (!(fp->daccess & FILE_WRITE_DATA_LE))
>  		return -EACCES;
>
> +	rc =3D vfs_getattr(&path, &stat, STATX_BASIC_STATS | STATX_BTIME,
> +			 AT_STATX_SYNC_AS_STAT);
fs/smb/server/smb2pdu.c: In function =E2=80=98set_file_allocation_info=E2=
=80=99:
fs/smb/server/smb2pdu.c:5821:20: error: =E2=80=98path=E2=80=99 undeclared (=
first use
in this function)
 5821 |  rc =3D vfs_getattr(&path, &stat, STATX_BASIC_STATS | STATX_BTIME,

There is a build error with your patch.
You need to change it with fp->filp->f_path.
> +	if (rc)
> +		return rc;
> +
>  	alloc_blks =3D (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> =
9;
>  	inode =3D file_inode(fp->filp);
>
> -	if (alloc_blks > inode->i_blocks) {
> +	if (alloc_blks > stat.blocks) {
>  		smb_break_all_levII_oplock(work, fp, 1);
>  		rc =3D vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
>  				   alloc_blks * 512);
> @@ -5828,7 +5834,7 @@ static int set_file_allocation_info(struct ksmbd_wo=
rk
> *work,
>  			pr_err("vfs_fallocate is failed : %d\n", rc);
>  			return rc;
>  		}
> -	} else if (alloc_blks < inode->i_blocks) {
> +	} else if (alloc_blks < stat.blocks) {
>  		loff_t size;
>
>  		/*
> --
> 2.34.1
>
>
>
