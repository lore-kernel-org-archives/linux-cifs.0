Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4942F531B
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782269296; cv=pass; b=I8B7gqAbQlnUyHrpsJM7I4N7YTABg3F7ozKF6J3fCkhzs5PZC29rPUSk+UWSi8aD/oAZPQpWzlSrqY3YURAeDe9vCABoVOA+Bd76ehSuSSFItrMtyDtxLNw3IMdphWA/KS13TzuuHy7+KYx1yKxtzhDr/15I0WuZ7excgTzaiFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782269296; c=relaxed/simple;
	bh=wGESYlejTs+NDuuYMoxQeaMvDxNv1pE0RHPgz8Kg1k8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rCbq51PfqJEIq0GdKrVq7j+ir9FFNTKSqDkMNrXNQ/kLRuk5vo/4rH7VAH3STZgfxxk4kQmEhkTPuNbEGOPD1MwHpy4E8xJZdrsavQxQVKiZlsLstfpO8Zc3Le53N9HrSfuTO5Hvmgu3oCRllOgSXtXaeUls9YRFFxtefHj1uOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CkT2Ef45; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CkT2Ef45"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8db35680d0cso15703826d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 19:48:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782269294; cv=none;
        d=google.com; s=arc-20260327;
        b=SssscZbgGscZpAPDZUELNhcG2ESzyI/CRshxC2BVcPL/drR/NfCOz9uEcc1qNV+0ZR
         LS3V0iI6LOJW/ndEwkl2HltArwyRLBMgjt8sgLwpcgyGsZx7ol34gyPzHF7FpSh0uVY/
         oywKTscNlm1FJzxl7xHu8XrrSUYs+ZFI1Lp9UpdHHMt4HYIynXaoga7RC2EsxPk6Cvcq
         zFFvrwYh0LC/4YHKQqbk0eE+wklKgMN1T9We2tzg9qFf2yT7Q1ZlH9t1ro8vcnu4OCLZ
         nfmTQhdYuYkB9ZquzxukS5U9+s1Qj3Bg2KQO4nDFMqoU9+7+7MdE6WZ+p/7RUXJh4RGo
         prJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j9R8xrCfMV0d213SBRaLTNm7gGDu9+ZI6ZAy9Gpfpno=;
        fh=z9RyfzRomPoTxP3Gd2F+0YSvEVbZopTKEopOGttb2RM=;
        b=FnFD98a+Dt9yWOIT8VHWxU49Vjj/SAsgexYQAGSZ4xtuLkkn57fPFe6ZL/XRnGHuHZ
         htA7yWVhKm/n0NPalcwmbxtMN/P8bPvaX82pMjnUqarGUAfYH/0CFkN37V+vYBsXe5PC
         0rQ26MER5B/JWaGlXzCuF8hnvuoHDhQa5hB01CPEGzJLbXydHfrea30YEJ7mpUN1cInt
         tye4/p9EXSK1xi5js3ikjmlsQVADAUMAKXahruB3Sbw7P64OSs13kjbkIsIr6An/LiEX
         zdxMwz7FEXDOvCWyq62fnSOrW7nWM4TXNxukdUaKtIDy3dDUlqtpYOzczYv5maeX+LT1
         ksBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782269294; x=1782874094; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9R8xrCfMV0d213SBRaLTNm7gGDu9+ZI6ZAy9Gpfpno=;
        b=CkT2Ef45LUhVGrpzvfZ+2xfPbdemjyTk3IWv8N+PVxzncpz3xVXvcg/ievRqeABv9A
         JewrBKAEjjwidrBav+HZfgCNXwaGK7TD8GioQuk3Abb2wjTP7USt70fBPBYMYxIf+FQt
         ZydrmeAF6jucu2BKP2i+iRzQiq5rIK2TEo++xZ6cUUrQUvMJfPswYbs/5Ai6WJTBvQFF
         78sKq64VXbtgQiAs+swc4W2nEH1FQqBMGyAChsSpkkPOJ+LZjuEVlTDXAzjUy1suxZsf
         6+xpP2ZeDem6ZE8neAbw7q/ECA72QrfXxar4fusyATaiAFYDFhmlV9virJ+swg02aABW
         qvWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782269294; x=1782874094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j9R8xrCfMV0d213SBRaLTNm7gGDu9+ZI6ZAy9Gpfpno=;
        b=LjlcnbUKwGxsRGM5usZOcvWcLFhjjAOg+pU/5mXpJ6p/IjMX8WIEYRNLzLkQler8re
         hGCyGrR5Kwhj5mNNMiMsJ9S0GCqfaw8FTPcq2zR4wrlYW124W4UP0hg9xd/TjW9WeemY
         IAYdZkfc7cMRbiJHxpZXYl8WoX6HfYgR5QaXBnMndNRPQ+3cyhsqekBlrbGFcJqivddJ
         2IYER992TFB4XRBvTklsInlrJP+O++hufBHM/g/DJiPUziHZ+ocX9BHDXWOjGXemG7Cr
         edSh+t59zyrMgKAaLybiphXN/3pPYz/J6EOK1adz0xoSWCZZs7vCdx6fm1mrvJ+m/sYc
         Z48g==
X-Forwarded-Encrypted: i=1; AHgh+RoLBNuFJ15/doQJZD3th9JhwKYhKlV9qibDSyBIPk+QKmTBu91B0wgy0aW3TLxo6X2MocknzIKKlvvv@vger.kernel.org
X-Gm-Message-State: AOJu0YxvkAvYSqX7zczOsVWh+FG9T0yVFCOwFzbdHok+smFkVUGMlJE0
	j6BoKxZU3sDN1bSYk9VQGh4XP83h8QSjMzJDbGy/+OoB5EVuMBvPDfgmNbrdqOVxAtMAaXjM8Jq
	tXj9J/qTbACpYSZ4+ovQXbkcxazOuAJo=
X-Gm-Gg: AfdE7ckXeOlSe7KKN989fKy1nynyo51VP3+TOmbjMKE9wacaTzLzulhPK8C5hELBntm
	HxU9ZpMUB7cviwHlmRLZB8tSHzvtyLswIeogH9/q82XhD0qvN5vcGcnvSospbMm/zwXwRdyFBLK
	to9kD2hR7JPhiRDKZmV+A5FzF91QjwXO+tJelLZOtQq94iaKNLO+p8J3po1rE4uGP+KWRcANdvx
	KOK2rhCyrfO0WvAtWMDjN8MJCl2W2dwiKuS3x5m8ARixn3H9jOYbSCzNWiV0cPiUCVElbzgIJnB
	INUTlT0n6yUAFqhOBxoNqiyY/XtKpYsLeJEeyjHFYl696VgS0kfvwJyiaTcHbo4N+SZU8YX6hzK
	sAsPP0kDua1YTxzMyazXivezLhpv6QhDBR6DmsnbmUiAHHDZeprdZtra8RJfbu5r8PmEUKr9sA8
	gFcFhnKKKYyFA=
X-Received: by 2002:a05:6214:8017:b0:8cc:f3a0:209b with SMTP id
 6a1803df08f44-8e3b664c66dmr99415626d6.17.1782269294373; Tue, 23 Jun 2026
 19:48:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624021550.1548952-1-huiwen.he@linux.dev> <20260624021550.1548952-4-huiwen.he@linux.dev>
In-Reply-To: <20260624021550.1548952-4-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jun 2026 21:48:02 -0500
X-Gm-Features: AVVi8CdIfNbHWNXR6msipGcfyrqe-I0hwWt-gRq20f0I2WpjzaMCm4l6A-_GSa4
Message-ID: <CAH2r5mtLZTXGcCGy5y24CH_uDRr6tPq21i6wS4SZHhqHn7o13w@mail.gmail.com>
Subject: Re: [PATCH v2 3/9] smb/client: handle smb2_set_sparse() failure in
 EOF-extending fallocate
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Would it be possible in Linux to have a sparse file but still with
space reserved beyond end of file?  In other words are there cases
where you could have a file with holes in it in Linux which still
fallocated beyond end of file.  What happens to ext4, xfs, btrfs if
you try that?  Does fallocate beyond of file remove all holes in a
(sparse) file?

On Tue, Jun 23, 2026 at 9:17=E2=80=AFPM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> An EOF-extending fallocate(mode=3D0) can return success while the newly
> extended range remains sparse. A later write into that range may
> therefore still fail with ENOSPC despite fallocate having succeeded.
>
> CIFS clears the sparse attribute before extending EOF so that the
> requested range is allocated. However, it ignores failure from
> smb2_set_sparse() and continues to SetEOF.
>
> Return the smb2_set_sparse() error without extending EOF. This prevents
> CIFS from reporting successful preallocation when the server rejected
> FSCTL_SET_SPARSE.
>
> Fixes: 8bd0d701445e ("cifs: add support for fallocate mode 0 for non-spar=
se files")
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2ops.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 965a4d21dd43..f68c0df1b66e 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3691,8 +3691,11 @@ static long smb3_simple_falloc(struct file *file, =
struct cifs_tcon *tcon,
>                 if (rc)
>                         goto out;
>
> -               if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
> -                       smb2_set_sparse(xid, tcon, cfile, inode, false);
> +               if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) {
> +                       rc =3D smb2_set_sparse(xid, tcon, cfile, inode, f=
alse);
> +                       if (rc)
> +                               goto out;
> +               }
>
>                 new_eof =3D off + len;
>                 rc =3D SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> --
> 2.43.0
>


--=20
Thanks,

Steve
