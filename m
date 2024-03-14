Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BEFA55
	for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2024 02:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710384560; cv=none; b=mt6rXwppw6G7qwN8sBOt8sT4FsfBHNua1vVV+X/xvX28mghoG9s2sV+Wsi94YFSB+PbmtfWOy/lmnvOLqeB9BK48WzXKTn8jgh8+kyhQn+tZ1U4V+C80icKtJPFdgJeYr5lZC45iu6hsIy2oqEcex7W8XwQ9DnGksf3uKHicXCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710384560; c=relaxed/simple;
	bh=rSn7gYHRJaSTYeK61gZrDpJnAtY30mxdqd/Sf9GwYpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sWCEO9xxyTwytVlh/iRa1P9jCpzgaMNF1W/D71L8W9o3yduBbG8uM7mUygf868m/29uI11YyUhrRAeHUZ1P0QxPQxaVn8ci1dPf7MWK9HHE+sddzjMxqDcB87WHD/XPJYyUZa22Bunq2LrRKEnwPuGVDRdpwJwoTaBTSrHbq24g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aLNeoU6g; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aLNeoU6g"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d109e82bd0so5236441fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 19:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710384557; x=1710989357; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQDC1TFAMkPMJr9wg7EkwiBsIJW8Z9gXpD9ACLzsu2s=;
        b=aLNeoU6gd7YZOEDAaVIaSOuO+T50co3XGEby/GrPE9LOBiHKJmCsw8jFKXf2Mg7eWv
         OgjFwHylqnr7EDqBK/RvbRbkr/2HN+LboqV/YWdrcr2jl0R8vRdM9vdtqPQnVtN9Z+gu
         3+B7pvye6oEDjB3I5pz1T91+it6bQL2gnf/292BxIwwg71fXimMf3XBjiKp3EXE4QMjX
         ipxOvQMKf08swfccZBHGoEmyiHwLvhRmg7/S+O1C8Sc70Gg6Z1Sh1l2FFgl7Qf/wj2tv
         x1z90dtpYZOYOLsDJQafiwEXFpxqwW3li7fJXXQUAaE2QwaSEQCdms5DZLSCzLHaB/hq
         s4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710384557; x=1710989357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQDC1TFAMkPMJr9wg7EkwiBsIJW8Z9gXpD9ACLzsu2s=;
        b=EqhOgJdF2kcQLs03YReqRx9Aeo1879MQdBX5/N/ipwASzZ85edKQi80j1d7IWdCdfL
         I95XoHyLG+DYfImiCM2W51UUwlFbXPJWeNZwrgwNoFtf0eWzqxRuaZtBEhB6bl8o1IzN
         W04Na8GIeE14MppXz4xHyTbuP3xTEH4fs1VB/VI+kykeLKq+WPQoPHEizkz2h6dnH1WC
         YxQ7cX3qnGRDjSdI+kSqIydibTPwmKwEOFRmupPlZcwj42m9J+JGdGDf7X/egKKK4Dqh
         ZIeSyEmqcPJHRgPRhBRSVDfmucXZbMFfkG2XVg4KY0PKXVW0Nz/9J+XjBzR2NLWX0J7n
         Jb7g==
X-Gm-Message-State: AOJu0YygJY6tjWlIyz1YeOQIoFHxQr9wzooIFlRhEIFciP0857bdPJBx
	+jcitIx9yRMsfUiF5rFB4r/g82vB72dxLqrYoZrCsxDeOQQHfQoovpc/mjA3go+DWl25eKk1Y9z
	sqBW1yA1AwsitZJVSqUUlVib7Qgo=
X-Google-Smtp-Source: AGHT+IGflfirgFyFk6iSnnG7L4cdc9TZBc6xmW3fSYroHmehnN9ldJxGoZ8y7gmBQH0+Hfn6GUVm+3DW3as+RiB1Wf8=
X-Received: by 2002:a2e:7806:0:b0:2d4:778c:5edf with SMTP id
 t6-20020a2e7806000000b002d4778c5edfmr163902ljc.13.1710384556909; Wed, 13 Mar
 2024 19:49:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240313150034.165152-1-bharathsm@microsoft.com>
In-Reply-To: <20240313150034.165152-1-bharathsm@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 Mar 2024 21:49:05 -0500
Message-ID: <CAH2r5mvu3Rwbv=b86MwOTYv5W4U4x7+OpM2DMCfwEvyvAEYsEg@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove redundant variable assignment
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, bharathsm@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The second change in this looks a few lines off (didn't you mean to
remove the rc =3D 0 nine lines earlier, ie the one from the EREMOTE not
the EINVAL calse?).  See below:

        case -EREMOTE:
                cifs_create_junction_fattr(&fattr, inode->i_sb);
                rc =3D 0;   /* FIX: shouldn't you remove this one */
                break;
        case -EOPNOTSUPP:
        case -EINVAL:
                /*
                 * FIXME: legacy server -- fall back to path-based call?
                 * for now, just skip revalidating and mark inode for
                 * immediate reval.
                 */
-               rc =3D 0;   /* FIX: and not remove this one ? */
                CIFS_I(inode)->time =3D 0;
                goto cgfi_exit;
        default:
                goto cgfi_exit;
        }

        /*
         * don't bother with SFU junk here -- just mark inode as needing
         * revalidation.
         */
        fattr.cf_uniqueid =3D CIFS_I(inode)->uniqueid;
        fattr.cf_flags |=3D CIFS_FATTR_NEED_REVAL;
        /* if filetype is different, return error */
        rc =3D cifs_fattr_to_inode(inode, &fattr, false);


On Wed, Mar 13, 2024 at 10:01=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> This removes an unnecessary variable assignment. The assigned
> value will be overwritten by cifs_fattr_to_inode before it
> is accessed, making the line redundant.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/inode.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 00aae4515a09..50e939234a8e 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -400,7 +400,6 @@ cifs_get_file_info_unix(struct file *filp)
>                 cifs_unix_basic_to_fattr(&fattr, &find_data, cifs_sb);
>         } else if (rc =3D=3D -EREMOTE) {
>                 cifs_create_junction_fattr(&fattr, inode->i_sb);
> -               rc =3D 0;
>         } else
>                 goto cifs_gfiunix_out;
>
> @@ -852,7 +851,6 @@ cifs_get_file_info(struct file *filp)
>                  * for now, just skip revalidating and mark inode for
>                  * immediate reval.
>                  */
> -               rc =3D 0;
>                 CIFS_I(inode)->time =3D 0;
>                 goto cgfi_exit;
>         default:
> --
> 2.34.1
>


--=20
Thanks,

Steve
