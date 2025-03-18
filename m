Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B68C154425;
	Tue, 18 Mar 2025 19:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742325815; cv=none; b=BNUm+K4hUZCnAOpk2BiheSPjbvGWmxrTyJtOz825oo4vduJCqV29IUlOALxuOLEExdCadM8AvWIwwXDbf8phlvNsU72t+Uw7uQiRFGhoy9Nir+Xhzwah+TCE+1h+/kWZM4IiyhvmIKn0oO1uVcQjqKHiUgPYLMK1eer2Sn0s4uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742325815; c=relaxed/simple;
	bh=vo+Y9M5fZCnxMX7PnQT+6Jbu3+t4H/gTD3k63zpjt9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sluI0uedTlay6CcABqg5PW1zj7St678Ooirewtn3e7zjlXZOVZU3wLcOTrtOIlqmboFi/tZhz8c6BpZzKVLsibfoit+Op20QX9c2fFzfi0xL7Fx8dTd4ldIxYNxzTKq7M1VKrSojBp49qFJNpKM7/KlYEJadnpX+z1McVqKiJaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mOkPv1b6; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOkPv1b6"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-549b116321aso6588530e87.3;
        Tue, 18 Mar 2025 12:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742325812; x=1742930612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcAQOZqccXx0I77tL5o+cupSfQdFfy6XH0pXLyfYY9g=;
        b=mOkPv1b6RAoMRpcrEtO3If7rlU763ppeciBnW2DzU88B6irJYVpTIFPmOupxvyE3bG
         TtkR/8Hp/HKY0exnw5lKyAJq7/O26qQs/WHvj2rm1SWEwyLZvHThjWEVgsC5o+RQUvlF
         iDpR3NOx0UPMq8bE66k07+mB2Ub03rWElsgOSIOmiYxo3rBR2N1pqT+rAyDUKXT95a1m
         5bXY94cjKvlhycem0Ni73cycA8efixJFbjP8zWXw32g7QMPbV1EXepZVlcR8RPk9KOKR
         cbgD9GZwbv6DazGVljSLVjpXCsaLNMMhbaPLUS2cZ0MlpSRUJx62yA/S7PLwpTo06Uvi
         WbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742325812; x=1742930612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HcAQOZqccXx0I77tL5o+cupSfQdFfy6XH0pXLyfYY9g=;
        b=ObJM7nLF/P6zLg/gyvh2MoW9LcKf9MdyALRmJElwkQfEk3uTB50gbqsZj5iT8wGMLn
         8N6Ez7c2j6R05Yla1Cfwt7wDk28OQ5V6hLczvekr7UUVh0fMzMDiLH8gSporgGZgFLHq
         WeOrDJV3xEmLZ1oaTnnCHVqwy2BTM2RkcUhxyPHq9xR+Nz8MKvQFHAhtM3sce5EWalhL
         z/IIqt1GGa6PhmrrfAeUBGcDJVrfkTiHSx5KdEbSsXOsoa7VoelElIn3HpinJGpSZozz
         k+sXeWWzNP5czaHbU1dXrXhqyPYru2FCwudCickJaOfcwk/Gy4qD1+2rXQpO8BOTi1x1
         9f/A==
X-Forwarded-Encrypted: i=1; AJvYcCUmby7ONOvWPZsyOMwfzLJYZTbzL211iGYfzb22CPC1/egmFFY8M6bzn8A4r5RjZG8l08aEmNFDvorN@vger.kernel.org, AJvYcCXj6Pw+l0S45jQ3wjN2qIoEVrOB18ebEpsgO2junoAmxIFO8qznApB6uEmaDHQHnhOJ0Iu1wdIW90hmZxkx@vger.kernel.org
X-Gm-Message-State: AOJu0YyMXjh8Q50aiHG32Oid5ffTmVj4q7LlCuXjiWYB6e836yvOioTE
	wywTteqLL0XOn+gc5k9ZmVtQKK/CYY4mBMmQEs0FZXYRPQYmJDMbqeLPEr6+2mv6avZOK4Ru9uK
	qysFDiogcTmmUl8hCmHCIy/iCUlEf9w==
X-Gm-Gg: ASbGncuPRXs+Yqz+xb/SfWVtSM137C32TScUyl8e6ogLOoammBbwmekP3bYZHweT+r0
	L+ZLRmwpq03sSHObNCMe1kmS+hJjMd2lTFQq9C9m3dKgxwkgAiaH+4jpFHGxF3sjps3RVLxRhgq
	5Z2t7lMyaPXDHthc2bccMhvyG/
X-Google-Smtp-Source: AGHT+IFOLhiQE/d6AlA+tjXhw7+XvaECaCbQ38+34V9DySHBXKzREfXr6Z8MxgWAeMNTdvXYO64bPwLzVzp5ZXLuGv4=
X-Received: by 2002:a05:6512:282c:b0:549:39ca:13fc with SMTP id
 2adb3069b0e04-54ac9cc1605mr128555e87.49.1742325811315; Tue, 18 Mar 2025
 12:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250310140458.249202-1-i.abramov@mt-integration.ru>
In-Reply-To: <20250310140458.249202-1-i.abramov@mt-integration.ru>
From: Steve French <smfrench@gmail.com>
Date: Tue, 18 Mar 2025 14:23:19 -0500
X-Gm-Features: AQ5f1JrmmOMudtqyljKZ_6xAXW64rX_tC4AA0k3-HNQfvMGj1Gew5-5Qs2LWUm0
Message-ID: <CAH2r5msSqt7iJ9rCFDWZqTbG5o85nbM3Ucx73w-YwBLKbr4cXw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Remove redundant check in smb2_is_path_accessible()
To: Ivan Abramov <i.abramov@mt-integration.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged both patches into cifs-2.6.git for-next pending additional testing

On Mon, Mar 10, 2025 at 9:05=E2=80=AFAM Ivan Abramov
<i.abramov@mt-integration.ru> wrote:
>
> There is an unnecessary NULL check of cifs_sb in smb2_is_path_accessible(=
),
> since cifs_sb is dereferenced multiple times prior to it.
>
> It seems that there is no need to introduce any NULL checks of cifs_sb,
> since arguments of smb2_is_path_accessible() are assumed to be non-NULL.
>
> Therefore, this redundant check can be removed.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
> ---
>  fs/smb/client/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 4dd11eafb69d..6958825431af 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -969,7 +969,7 @@ smb2_is_path_accessible(const unsigned int xid, struc=
t cifs_tcon *tcon,
>                         if (islink)
>                                 rc =3D -EREMOTE;
>                 }
> -               if (rc =3D=3D -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCA=
LL) && cifs_sb &&
> +               if (rc =3D=3D -EREMOTE && IS_ENABLED(CONFIG_CIFS_DFS_UPCA=
LL) &&
>                     (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS))
>                         rc =3D -EOPNOTSUPP;
>                 goto out;
> --
> 2.39.5
>
>


--=20
Thanks,

Steve
