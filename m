Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9A018E025
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778695100; cv=pass; b=WXBb+QPxOhyKOu9MjcE93tnQNt17KrEZ9IA/re30+5K7xf/PNJPRqVs3xTqOyXMv9ijbaA510xqxaXQFqtj2gmjC6h2H+sAJJMI891H2aLFERclmmxLaYQCrES4RSH5E83/vHe6GQ7sqquWxikZMNagpB3u3ce52Qz2A+22PgHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778695100; c=relaxed/simple;
	bh=/qZLS81foJzjoDZ03zZEEn4MUWq5kaEvbaqv2Dl8qAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RT+TaNtmY/QfA3RYnAWkB8vVnGE8jucJ6wIgerdk4dhv4eqHLNNm8UmOnQ/f/nzOg0Q87n47DBXlAO16MsTO4T3l/ApbpBte1UbnrL5DaRneS9pjAcx5/T+aSMuW7NxyJcbNmk9C4G+EkZYi7pRtWGf3G4HMLKFcA4qa0lAEiBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nyjX4Kps; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nyjX4Kps"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8b3d6b215cfso107869336d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 10:58:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778695098; cv=none;
        d=google.com; s=arc-20240605;
        b=ONFm/AVlMONqRgBicQqyG0q5FhDpv48pRiYVqAXYK6iGtdCyNf6cKNry2zPQPiPmSQ
         KESJdvcBHQUBpkRqya44MOZJhy2fta64TzQxkFKaae3r7IOSfyovJ5pzXvofcKnwH43c
         g90yt+e5Wwx1I36iU1dDAlUTZGNMlKWSTs14sksK89pZto/yWIY7Ghh95w5rnGfwvkuC
         ZhXiDc+Npzda+qMn4wtQAePvOUofNaq/Bue4NO/UaSFSyzyhyOwIT5QbzrNhmpduiX77
         hwoBQiluC78qAuSG2OqBLs0tw5D2E+lbTtKRHWYZZNKxGRRVQnHPvuBNRLKWDVCWh1Rz
         OOMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v37oMe/XCITtfWAdZvzdK4+5Jbdl40/Yt3lkzTI/kDo=;
        fh=iNpFgOQbnExIYsdDe04BVdhzoxWO6yV+h364vYlSmbY=;
        b=UQ8jPIfwwYkh4+Zkz/QxhOlbyaRtAU6Kr+PSzeNFQcgqQowFEYL1IiqOw4zrtaNDBo
         W1JDO676N6XckFAH5t8xXQSnTMHVwjySGPuIbIHhbiGBJcpi/dcepRJJ1TYGHO3uqfUK
         0VXl1MoItyzwrDT5ZZn//QpMhZZnCya9JEZ1P2Ejaf0XaGK2pOX53WcyW0xPVRoFmr3+
         1SGSHrTG2x+NREvbqIJtj1zS6Xreqvj/igfcm454IywIi4x8ktJauDX7XA32sLlvmLKR
         WV2dYYXO/3H/nOtjryB1LvT38pJLycVmfHvrg/CE4pLhLu3eqrDPewATNDEqzDY4xmqL
         XL/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778695098; x=1779299898; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v37oMe/XCITtfWAdZvzdK4+5Jbdl40/Yt3lkzTI/kDo=;
        b=nyjX4KpszCnv7v1MWBaubUyGneRFZy9g4vGDuVCReLMDVtoMIqJFrFgkGTyYmWvaeF
         yMNd9ni+exFu7X3q+tVa+I8DSfz3vevPrQV5wM1CLfv0db2kJ1izOCH+l0DZSGmgKVLD
         5v23A86DM100JVG3c9ZInxXypLrGx5n4RpiJl+nvAhpHyDkJg8sASTNyn69EOcyuXjLc
         jGaAejvXDHAjJXa9bG5iJx7STFntr0f9ICNW4cNPIghtMLizuE8LuXkrOBL0Ckv0TkXU
         I08WIpCEl9mrYg6bn5y8pVa5HMn2aWV6EzKvOOdnL/LZ6S/frFf9hET42OlfQDzriQjk
         q4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778695098; x=1779299898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v37oMe/XCITtfWAdZvzdK4+5Jbdl40/Yt3lkzTI/kDo=;
        b=rm5HkfQQPZTF0AtOizcHqJ9eGyVmfHkH5YTIqZx82G07e4I/gWXbUQ8ecmKZP9SBep
         yQlQFhK6AfUD33+4/9+SK5w0iPcK/Vo4ezjRnEB28cGWaQlTL3h5YuwvDlXeyBsyEza3
         7dAx5/KdNhyzg9VcKafNTKdXtoEWJIAcJZgAFE5pJ++tbvMdgsWiDyQNn8n9V9PiqCXz
         Mvsu+il9Khz6EbBnZBWH+YmQO/H/aWHleAEYtLXYzLHKm/I8czz33R3LmSck1ePC54qZ
         JJz7yTPKGO8cMCfvZaCeq8Gk/8bGbMcWtarsq6nEnOjcSw36CPzboI70Le017E9HgxbY
         tIEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+UixHxuzNwg0520VmG31hmFlU0ZL73mhu/VAWpd2SrblWNJjF02+louSU+CnItY9X/JYXh3NuE7oyA@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3ZhklkmQwTRmhUnNToTB1RTpoptCBV7rrrDM49c+DEMuxZfZC
	PU98rKnTG7qbcgLX2Nsfj0u2L0RFiV30W+46DaotOwcMP89+jJGqFYeA5l4Ce69SsDVnPX74kUz
	lhY0TuHrRyIPIQiWYJwvPh/SSNITHcTU=
X-Gm-Gg: Acq92OHWc2ht2BbFMNQ1/EBW9+jJxV5Kx1GWM/TmljaLGLNzC9BV+GNsKlDNRealkx+
	7kzJLeTOhbZTbl5xC0nVzdBhCCiW+WI9vRfAP0XUHeTbt70knv28zo/aCI6/dovOgSk9qOpC4EP
	zKmFlv+vLFpxzbfgKeL8Y9FeMCHWyhN2SP0GwQAT8Je4xcips45XGhlVL/Tl9m/lLI/4My4bU/9
	Qhy5B31f/XvqdKidLSB59wxvc8j07wP0R+SNThlsJ2jx3UMyS9K2pOXtmbx8i9SVr9nWNSXWRwT
	CbS1d9SXdABYqs7mUrQLYrlJQkj90v5zVKJdC6qYdXJnvi9W+kU5xaltvS3eegnqygVe1pcICMu
	MwE11gC0aR4oPWUw4gnFgc31aDhY152eQ7QLECmJmsWrQi+j+W63yrXKuwhQ8a720s+G93y2XXw
	aOs8b5ma9eSxgr+1+KuNJZRqDnTSTKD0dc
X-Received: by 2002:a05:6214:1306:b0:8ac:a976:f8d with SMTP id
 6a1803df08f44-8c7bb988a4bmr76790756d6.22.1778695097989; Wed, 13 May 2026
 10:58:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513081205.1018080-1-yebin10@huawei.com>
In-Reply-To: <20260513081205.1018080-1-yebin10@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 May 2026 12:58:05 -0500
X-Gm-Features: AVHnY4Kn2Ui3lmmAJM9V7JIE_ynTfZADR3S5MrzZGa5AJdkCKq4unUg_n9zUV6k
Message-ID: <CAH2r5mv8X_1QoMHnRg-r1+uLFvH+W-rh+t93Ne1Xj40wFtmShA@mail.gmail.com>
Subject: Re: [PATCH] smb/client: fix possible infinite loop and oob read in symlink_data()
To: Ye Bin <yebin10@huawei.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, linux-cifs@vger.kernel.org, tom@talpey.com, 
	bharathsm@microsoft.com, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Wed, May 13, 2026 at 3:15=E2=80=AFAM Ye Bin <yebin10@huawei.com> wrote:
>
> On 32-bit architectures, the infinite loop is as follows:
>
>   len =3D p->ErrorDataLength =3D=3D 0xfffffff8
>   u8 *next =3D p->ErrorContextData + len
>   next =3D=3D p
>
> On 32-bit architectures, the out-of-bounds read is as follows:
>
>   len =3D p->ErrorDataLength =3D=3D 0xfffffff0
>   u8 *next =3D p->ErrorContextData + len
>   next =3D=3D (u8 *)p - 8
>
> Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2file.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index b292aa94a593..9d6f342b3f82 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -31,7 +31,7 @@ static struct smb2_symlink_err_rsp *symlink_data(const =
struct kvec *iov)
>         u32 len;
>
>         if (err->ErrorContextCount) {
> -               struct smb2_error_context_rsp *p;
> +               struct smb2_error_context_rsp *p, *next;
>
>                 len =3D (u32)err->ErrorContextCount * (offsetof(struct sm=
b2_error_context_rsp,
>                                                               ErrorContex=
tData) +
> @@ -49,7 +49,10 @@ static struct smb2_symlink_err_rsp *symlink_data(const=
 struct kvec *iov)
>                                  __func__, le32_to_cpu(p->ErrorId));
>
>                         len =3D ALIGN(le32_to_cpu(p->ErrorDataLength), 8)=
;
> -                       p =3D (struct smb2_error_context_rsp *)(p->ErrorC=
ontextData + len);
> +                       next =3D (struct smb2_error_context_rsp *)(p->Err=
orContextData + len);
> +                       if (next <=3D p)
> +                               return ERR_PTR(-EINVAL);
> +                       p =3D next;
>                 }
>         } else if (le32_to_cpu(err->ByteCount) >=3D sizeof(*sym) &&
>                    iov->iov_len >=3D SMB2_SYMLINK_STRUCT_SIZE) {
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
