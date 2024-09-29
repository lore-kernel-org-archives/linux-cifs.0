Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F26A94D;
	Sun, 29 Sep 2024 00:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727569121; cv=none; b=QHufotYcff3AupDwF0CSjUqdKU7+rOQZcCoLpFDLlhXiqVsd/r0G/GVU6+uvxa+TsvaWJGfv/AsqzQ24qlHZd2iX2g5QwLO7OBOHQgOOhROwGFjPxBKBRusqmqSJ3ZCHqWvM8kzaA2JYIfxsxQAIwd9nqOg8W+IuPFV8inQmTQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727569121; c=relaxed/simple;
	bh=Zb4e2sGbh/e7495W3IqMVOr8SEUk5brHdj+foAOfywI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HqibSm+Pw3rmqgMoVQ5q9NVwNxFg0xLHKVL9LNdBInBnH2HnKxgBwTGU75Kl/k579yKkpAnBrGCWJ5BBxHOf5RB6fN+AOAiIt5fgbK1jjA0e726G36qL3L1aKq+o8eZ8zjO9dGCh1hZ0o+n+7ylBM9aAOVPYgsWzq1hTOnuaK6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZMVzK3Q8; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMVzK3Q8"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2f77be8ffecso34868841fa.1;
        Sat, 28 Sep 2024 17:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727569118; x=1728173918; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGYwbUpBvfcrkh8mE1WIfBUKHU4KirhfOEZIdVl5kN4=;
        b=ZMVzK3Q8uqBun4qGsBeP+ztAv/huFe3cE02rdu7O0juViB0Eyr5dZijcbCi3yqCLnH
         UujltUJLWikgawJ66S2aPmMDs5BxCsDU4PLlct+8x3K82JH1oh35Wgv6YckMgNXHxZyh
         kbdPtwfzqPXQKa2n2aLHiDCPR+yTsumWTBkYiJUNKxyKO7+2XW0yemrR6kprsrRgLYX6
         CFTpCGVZd0K5BeU6umH97aml6eLr6mGjui2Svd1aq5w+IA0yWArx8x+pg1FhJmdRuKlR
         u/9SS4xaXZAw8v244Zivwh4guvqMRvOMNwoQfm0d7Ux8nXDICAUNHiusPDW0j1LRDck1
         Klkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727569118; x=1728173918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XGYwbUpBvfcrkh8mE1WIfBUKHU4KirhfOEZIdVl5kN4=;
        b=ih9Va4GLePBukvWD2u36xG4/wylU7F5KmOd9kdZ2b3kguqZqtUYP6y+u+tjP+T4SQx
         TAnnrS+0lPtW59zzTy7EIquzn2fgk6WYD4cTQsKq7H1nTDUDYUIXPUWo5HA/hbW+y7ef
         RuUP3bUYIkMjRCpFCGs31r72mwDRRTZ0gdrfa+rLfXKyjJ4eEGrKcE7J6nk4phQsKrG8
         v4uZJhUdgb4wX4uDWSKubhIEqJaVBSsTBEG08d6GpaNNcSlE2nKKFxzOp6lVUhlJCrl+
         JiWFcS5GgH+mbZyGa20yStvdPEP9XCSt1ZbNCLBCtlGymv8Hq/rSJwE9cYJzWQx1CiPq
         nNBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUu5+qvvZXM2Cp0l2MIAzDPPoTA6eCW89Ksz6Lr8apYn+xWj6p1UWXsDKLVjL2sWTZGdOcXfYTrLm3Rj7cs@vger.kernel.org, AJvYcCWwnW0EIKuZjc8ZCG94eCkMQa4ggPneEICb/ZGrfarkYLQ/3fSDDotShDGvm5mtCkMcCsPct0aiyJdl@vger.kernel.org
X-Gm-Message-State: AOJu0YztH6wpBjWo0+0N9kiD93fMqHvWJlJQJkcp8/HMoVzdSBgp4ILI
	leo98IgdLyyH58aAVJXb8c6fCbSL5RnAmoMhw/FicXipo2jSSZhMRGUw9ExNjeMnEWKHv+qTjyX
	5t3xBY5d4IXDJNrozfLgmeEHkZEU=
X-Google-Smtp-Source: AGHT+IE77Ww4FH50m/l6cN3+M/ELkqgxoK3+gMe/A/0iPznks2YcvAoTKYV4KkBHrQNKI3MaSA/Kww/ce479ghRrxOU=
X-Received: by 2002:a05:6512:3087:b0:539:91b8:edc0 with SMTP id
 2adb3069b0e04-53991b8f90fmr279747e87.50.1727569117333; Sat, 28 Sep 2024
 17:18:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928215948.4494-1-pali@kernel.org> <20240928215948.4494-5-pali@kernel.org>
In-Reply-To: <20240928215948.4494-5-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 28 Sep 2024 19:18:26 -0500
Message-ID: <CAH2r5mvvNO4NjnBKd1R_wemJ34t=N+iL023c2Op+LPuYw3UcZw@mail.gmail.com>
Subject: Re: [PATCH 4/8] cifs: Fix creating NFS-style char/block devices
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks like a duplicate of Paulo's earlier already merged patch, so
will skip this one.  Reviewing the others in the series now.

commit a9de67336a4aa3ff2e706ba023fb5f7ff681a954
Author: Paulo Alcantara <pc@manguebit.com>
Date:   Wed Sep 18 21:53:35 2024 -0300

    smb: client: set correct device number on nfs reparse points

    Fix major and minor numbers set on special files created with NFS
    reparse points.

On Sat, Sep 28, 2024 at 5:02=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Linux SMB client currently creates NFS-style char and block devices with
> swapped major and minor numbers.
>
> Per MS-FSCC 2.1.2.6 NFS_SPECFILE_CHR and NFS_SPECFILE_BLK DataBuffer's
> field contains two 32-bit integers that represent major and minor device
> numbers.
>
> So the first one 32-bit integer in DataBuffer is major number and second
> one in DataBuffer is minor number. Microsoft Windows NFS server reads the=
m
> in this order too.
>
> But Linux CIFS client creates new reparse point DataBuffer with minor
> number first and major number second.
>
> Fix this problem in Linux SMB client and puts major and minor number in
> the correct order into DataBuffer.
>
> This change fixes interoperability of char and block devices on Windows
> share which is exported over both SMB and NFS protocols.
>
> Fixes: 102466f303ff ("smb: client: allow creating special files via repar=
se points")
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 48c27581ec51..63984796721a 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -108,8 +108,8 @@ static int nfs_set_reparse_buf(struct reparse_posix_d=
ata *buf,
>         buf->InodeType =3D cpu_to_le64(type);
>         buf->ReparseDataLength =3D cpu_to_le16(len + dlen -
>                                              sizeof(struct reparse_data_b=
uffer));
> -       *(__le64 *)buf->DataBuffer =3D cpu_to_le64(((u64)MAJOR(dev) << 32=
) |
> -                                                MINOR(dev));
> +       *(__le64 *)buf->DataBuffer =3D cpu_to_le64(((u64)MINOR(dev) << 32=
) |
> +                                                MAJOR(dev));
>         iov->iov_base =3D buf;
>         iov->iov_len =3D len + dlen;
>         return 0;
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
