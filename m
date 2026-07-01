Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5B548AE20
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782919644; cv=pass; b=G5mcvUoh08ymYguK/IsAKQyzleJo45Xp43WLha/O2ispq2XIfNrkN/gNY5N6kTZkd4xir007WISf7HTRM6ilM5mktXhyh4cCZZS918sBUMHinmFlQeKH2x+GweT0jLHGXH+o8IfcV+zeVpGs1zbY2KG34KCdp+1HRw+I/hblbhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782919644; c=relaxed/simple;
	bh=YcJktpGPvHHBPPPXHMux/ba/duu0SHR+ieek7yAsE2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aoKvHEZTVxf4yjWQjWRcx/6KKejiUiZrP8iKpSEm3wRTJEdy4wuD2QOtVK3AcfvNS7FgfTRhVK6LtQGdwK8O7QJ+Z+1PuKK1jgSH7fTHVSiwmred/BZU6yeJPZk+ElkbjjwHUrJVs09Ar5fWmgMIvBCZuhEB2n8m8yrQlbtp25o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C9oiiIfA; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9oiiIfA"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8e5be46f663so5618886d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 08:27:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782919640; cv=none;
        d=google.com; s=arc-20260327;
        b=MVilOCIQKCJ+K7qpHNmfE07ZiEqznR4KdojF3nZJtU+CjVVNXLCmOIxjefeaKtcRk2
         7ZvDiBBYs21P66L4SAtH/NS7GmvxpVaSw6j+It7BDgRTVP4G2pVwIC9JKTE3WRV1FjrX
         lrkz4ScYL/6jWxmDDv9ECQ8EJVm3KLGQFadSwg97F2G6W2dwW3KYHIYHiXJOg875QQq9
         zGv5dTYK1F3Q40VS5Zojwbq0MV4bXhG4F9sIIXthy7/5ihaxrsA5YI1nQrsjWYwPZQAT
         LlZATChRBtmNV+grrajaIFBXHuKS13N2tN79YuuK1rq636Zoa+KzjwWQJ9NOFO6tdCS1
         D3RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OhJ3Lh0CbUpkMLD2vaTkU9BvbWxvKUjlG5M99GVUzCk=;
        fh=I/pfmfmxP4U0xXHB1ycDnEbq4UjWJavJvEndn8u3iKU=;
        b=W4fEkZd+HBUKwgkT+cvyBuyWi8G0HulQgtTV+MLulpwQqKyObjGCTzSJonhjdpthU8
         bwX9oPqQaoC33nP8JTqu4i96IrlSVspu2lOyUbu7EEZ/ap9hC9CGwj8/nBsy0xQXV/gS
         Jsm9thaCzrOVum+ssKuV1IQU68O+1z+dJc0m/pFI32+XEBVnOIeiBQbdlJEA7ERjCD2B
         lTeiSDW6rhEzLepGu0OXhazsqlSpu4BGh/lr7/5VFPW9J4tp1+TgYseU5EsOETmZhBv/
         13Or59qAOG8Om313ITwAwRRA0y8bvfJicXENrs8JEk1C28raBoYKpIyFipFULDL7Edmh
         ntcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782919640; x=1783524440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OhJ3Lh0CbUpkMLD2vaTkU9BvbWxvKUjlG5M99GVUzCk=;
        b=C9oiiIfATie8auiYCTQc26PUri4m5pOMepZjUje1QscIAVbbIkiJrXy56f6jW1DX6D
         JZnADWudC1VVhvh9RteTlOzSJ48GuR03vZL1wx66+SKp9W7PQDFiko2/McYx3mZjgL6/
         8sDzpHbm0LxPLQn9EAxVbLkY4w8/5Kz31uJxnga+WWdBJeG3tVlrAKIk9BsVzlx0M11U
         jxWx3bvvfiDA/azvPBvUBUisWnHRpsQNkp4NevtVfKPIfHc5G7nxSSz79qt6laP2dLI4
         /e67Ck4NBjG41n6Fe2+ugBxNp+MmrwYHgeFKN8nMNkdX4bfG1dbMPQeyXoXVRXLmg6cC
         1IAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782919640; x=1783524440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OhJ3Lh0CbUpkMLD2vaTkU9BvbWxvKUjlG5M99GVUzCk=;
        b=rERB0oe0UaXClca7kNY+XiVYXgL8GBCatGo1d3yxSn5dsZePPMaLcU/ewG8qD+5KVt
         wsLBXGn7Q/6W9PFZR6TVFfG6a2fz0BdzAwuSGjc1mfUnszqOPypvnGuTctwkyMTsoXHH
         Jdg0UUMvpglxf1qgx76YR+zq4YPJmDHLFsgpzSzVqm6uCeQhdXNGmaZTYIpxl+C+fIAN
         TQ5EmaO2vGzilnP2ttLdx/TmmMJVxwTrsaatp76s8/MqS8TRA7Zu56YhUz7jkatvwsZb
         j6LwqX4ms4ZrIDmjEmRRPZVzL514TEDeHdTb/+hAH4YjfP4udFAfFTOsN1kjS/sjEzSb
         HE6w==
X-Gm-Message-State: AOJu0YyHvNu0yDZP7SG8e9Asg5avNDhbwJTO1D4Xj6gfYkDKH5H9W6kx
	YZTO8P3fRinrmgZ4FPbJu2pdI4v8UiMFhTVI5R74UkYK9tohCScrgJpFY4rPadOI9Xmm42XR2m6
	LYQn5mKRdQM1kRA3pUgZdRiCJTSmhKck=
X-Gm-Gg: AfdE7cl4dEpzt+tN+JL+nOFZWdvvL3yanNdWwVTtcVoSHxztot8yAfBda1Cvr/qzqee
	vHM1yrPbXi5tiVA7k1KXGaAuKzCIB81uzoESddzqBPhJUaqkwCl4nPiejRG2Bg26kPUgJmrmnWB
	X0GHvIb488YuvUBwIBuVvr09ZzF83a8sQN04kIsS3ysHU+XiCP9nF0s+j4qho3O8bl02fen4r97
	ORpGye/wznzwVPgy1yNqePcsUrLVJAaQkHNi2Q0Z5OHnHFqO2GeRwZDJdt+UzHHI8vyCVKbZD2u
	TgR+U068MnhBnFqXw8j1qAm+WdiEGKvjsg9qPSh2f2u9lh5JBnSvUeeBfwMG3+ysLMwz7lib4MR
	lByIHeivgPkcGuNMGerqvsYojiXhl6f9gueS3ieNE/Dv4XjSaTypWD8UrU3by9GFbgspb6Mhhjt
	zbKR9WWtsuQ1w=
X-Received: by 2002:a05:6214:3210:b0:8ec:26a9:17d3 with SMTP id
 6a1803df08f44-8f4249c9d60mr16875956d6.41.1782919640349; Wed, 01 Jul 2026
 08:27:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1782898568.git.xizh2024@lzu.edu.cn> <d1893e4279c8c53777eeb1bbc018b0bdbb36f471.1782898568.git.xizh2024@lzu.edu.cn>
In-Reply-To: <d1893e4279c8c53777eeb1bbc018b0bdbb36f471.1782898568.git.xizh2024@lzu.edu.cn>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Jul 2026 10:27:08 -0500
X-Gm-Features: AVVi8CdD49RRXldXYzCllgvJKOhVswogc7TS4o0ZgBq6-YDdBj1_ZcGEtV4CRcQ
Message-ID: <CAH2r5mthz8f_ASpFONw7X9L2mA--HSPT13+gmcm+cdzBW8Dbyw@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: client: use unaligned read for POSIX info name length
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	aaptel@suse.com, xizh2024@lzu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

owner sid sizes are variable but they look like always a multiple of 4
so should be aligned already, right?

See posix_info_sid_size() function

On Wed, Jul 1, 2026 at 5:26=E2=80=AFAM Ren Wei <n05ec@lzu.edu.cn> wrote:
>
> From: Zihan Xi <xizh2024@lzu.edu.cn>
>
> posix_info_parse() reads the trailing name length via an aligned le32
> cast at beg + total_len. Owner and group SID sizes are variable, so
> that offset may be misaligned on strict-alignment architectures.
>
> Fixes: 349e13ad30b4 ("cifs: add smb2 POSIX info level")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  fs/smb/client/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index ed782d219d55..43d514ee555d 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5450,7 +5450,7 @@ int posix_info_parse(const void *beg, const void *e=
nd,
>         /* check name len */
>         if (beg + total_len + 4 > end)
>                 return -1;
> -       name_len =3D le32_to_cpu(*(__le32 *)(beg + total_len));
> +       name_len =3D get_unaligned_le32((u8 *)beg + total_len);
>         if (name_len < 1 || name_len > 0xFFFF)
>                 return -1;
>         total_len +=3D 4;
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
