Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EB91F03D8
	for <linux-cifs@vger.kernel.org>; Thu,  9 Oct 2025 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760023813; cv=none; b=GzKPTnSp6hr/Dsk11GO3FxuNLYNMBbwA2NdkVZBJiLbHV14i+58wNtpa83YApZ583szQJeWVY2+myZYOSBZw5Tk/c33FItndFmQy/SVv15cuKoWWPU/fGDCNyRf5qhnA0s/XxPghdLZJtRNrKcd+0S7DRpTO9jX8aPBN0VZNHns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760023813; c=relaxed/simple;
	bh=xKdHY98uifDCA/ZQ54Qd29uwoqQwdPCP6AZELTJbBvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=coy7Db496toU9rdDMFwSjzlNNWGPX2XPlB8RnqpZoZf29SJS8gUOeUTwFv/vyRtQISoBk64Bv687umP2p7IXaROMYjkbhZMGHmv1avalXoNXE123402V2jooT38RAf2XYg/bvnsCCcerSqhhggun79F1pMc1+xaaTISikGdF6PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lihEbgME; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lihEbgME"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7e3148a8928so10536526d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Oct 2025 08:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760023810; x=1760628610; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3K/OkTfxaQVQjtAI923mEKQkdyC4/Ch4flZGg5G+nto=;
        b=lihEbgMEpSlA5LSNoA9Qp9VepM65F3cxM6NZN/eNaRMWaYFu7pQlUnnNl6K5bw/0EX
         trWDdJ6Ke3Mv/19+6xR1t5SDsu8TFJgaUdkFHyCly7Cif7zgmjUdVf6x2XWS6A621If1
         BmU4PoYpgxl0BhbALg0FqpIdWpRV5L4l/QNAGjFOu5kjyhrY3OnB3Tej+z8in8B3xrdH
         dE93j/mteX93Ud8/ily/c5XJXe1wqj2fxiEV4bmflkX3+oI6jFB/s3P5dj/h52X+VxQ0
         FeqX1w3/BJYvM9fepsETt32d+dyVIo099qaKTkrB0uzC+yZy/GoJwCPrxgl4obz25q0s
         10uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760023810; x=1760628610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3K/OkTfxaQVQjtAI923mEKQkdyC4/Ch4flZGg5G+nto=;
        b=tT0ospJLniGeoO+r+5YR+93xm2pYg8UTmvfogzJm8HlkVe64AuRUhvYTIA8V30Riqb
         y860bFqC0hfnhqS96lr3AaabKgupvdiwsMOfo26U1GZ9tFbj1RNgNKgU3uRukuROSf5Q
         T+17U18v9UPkxViMR+xW/PkddugJwOKn/M7qn2kR7a2t1uZNFyOu1D9P+Wn9Tdsrw9T3
         upGM+vSnAM2Om4XK5rNipalTd6uNWlNXBEQ6lEaOSn6kIUCja6Mxp7pRCN4pmkKYtCmC
         9AOTiY7ZOFrzKIfyFlcGAPL0zkFIXGvVwH6JaShLYtiM9h5HHcOB2s0dQW15nuoWiqNp
         7dmA==
X-Gm-Message-State: AOJu0Yw01/IyXpk5Ub1J9G6H5aptZio5bbEGsKFQDpHXFyc3dbLqJ+gA
	Y479ZBONZwxaY6ZbgaiRfQuNOSE0ztGP851fRCny2J12SDLmV9fTWq5LxMt+htxU30AS11IAR48
	R7hxnGA+lWoDwZE39BR7J+y5EQX0WOWs=
X-Gm-Gg: ASbGnct3Ol5Si36oLtPT5uLKhokEQt4wXRIaP3Dw8WdSmHJAAxTycA68WEVZR4y1Y11
	4upgN3gr7YXqqOa4Gu5wpsr21zo4GxrowMIFcQgvv5hv59wBSccYNiwsfDopr/v76u4hFJvBBfB
	kQPWjhSRXFQm7OLNJOtD4xeiPqP3tCYAhZT+/55INkxqHeP+LmYR+8KuEPhAHypupylsjtM0CIC
	K1X7hWY1pijcvmPRmLLx3vOY+VFMFRHATt1f7ajF9RLY748rxRxy39cbJjAfNz7JPTFMjMhHKbI
	KBYtb9v+fPkcXchWYzBPTztPmtSpeRlMA/UBwtrf5bGgAXbO4LmYdCYm9pvN0uiX6ZHiawOEprU
	rn4M+/X+wbd2MMzQ3Vy2eeoThI3vJYs/7hCCeqnnXmNlaPW+AwPHXMg/Q
X-Google-Smtp-Source: AGHT+IGJdcJchywsY80gAXJqF2Dh5hkmMc+nT1QmiKbYTO/FxvtFxR8ICSKzlj+TOaws0AV2aAY8SzOBjdCxSsbgzqY=
X-Received: by 2002:a05:6214:484:b0:7cd:91ff:6215 with SMTP id
 6a1803df08f44-87b2efc2c6dmr99245676d6.61.1760023809944; Thu, 09 Oct 2025
 08:30:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
In-Reply-To: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Oct 2025 10:29:57 -0500
X-Gm-Features: AS18NWC3ORxIiPJ-wdFN48myFn8Rs2UbLqRS_MIq9LzeT2xWYlDBUeIINdVmdKk
Message-ID: <CAH2r5mvg=kqPyA2nYF=Nhjr3vkt4dT1R4p-Bk_MBQtddjx_EhA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Simplify a return statement in get_smb2_acl_by_path()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>, LKML <linux-kernel@vger.kernel.org>, 
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As pointed out by the kernel test robot a few minutes ago, this patch
would introduce a regression (uninitialized rc variable in free_xid
macro), so will remove this patch from for-next.


On Wed, Oct 8, 2025 at 3:02=E2=80=AFPM Markus Elfring <Markus.Elfring@web.d=
e> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Oct 2025 21:56:34 +0200
>
> Return an error pointer without referencing another local variable
> in an if branch of this function implementation.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/smb/client/smb2ops.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 7c3e96260fd4..bb5eda032aa4 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3216,9 +3216,8 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
>
>         utf16_path =3D cifs_convert_path_to_utf16(path, cifs_sb);
>         if (!utf16_path) {
> -               rc =3D -ENOMEM;
>                 free_xid(xid);
> -               return ERR_PTR(rc);
> +               return ERR_PTR(-ENOMEM);
>         }
>
>         oparms =3D (struct cifs_open_parms) {
> --
> 2.51.0
>
>


--=20
Thanks,

Steve
