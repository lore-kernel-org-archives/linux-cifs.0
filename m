Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA27481DD
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965201; cv=none; b=jQp3dz7sDBhfZjRNOV+cRU5h2jsupeorJNqEhS4PAJ+/GyCyWTHPHmTusuWHnQ2TyZ6KVfEX/ijTAUeW1+CjSlrVdxjPC7qgSjfX1ywktL3lmh2KK94wEWfjG/b8syAXRH2VuM9ZuKsS8++EJJOiXSk++uIK2OJVbOotRh7slgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965201; c=relaxed/simple;
	bh=UkiIZdxLfwX6Gt6hLLsBVd2fbXn+B9/vB6xr7nGOiLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T5QE/Iy801tjhaRhJCKPh239GfQ/3MG3vpAz4+AE2JqReLYTJZYog2pd/VNdiG4jT9rRltFbsxCufJA9Oqy1wfagKLsSz5LEHArKbcCLCUoxkUwH/ZJxHxhdYg+Oi+y45iShTQP3Rf4ikKvYtKNv3OEg/FbkGPK5IIMysEiuNIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uo8//i12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uo8//i12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1E81F008A0
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 00:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780965196;
	bh=tlDl+CH+zojyuc/Gn16uA0la+Y20amlUc4G6qNd2VFE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Uo8//i12psHP3ARRbLVOpJpLdp4esrEP0CBUuiyjbrQlNt9X0O0Ej6GVOYjxfZYIA
	 Kiz3v01Xt39lQLjH7XvsrIeGO7dhNP+s9ezBMtyOoU+HjOJ/b3ejRl3mre0CK71GHh
	 u22ATFDrnhmchtYbnUGDPpImnKVG5wACUJg3NgV25e4q+vi4SJ3MXalNfimdeEzuZf
	 VyJFWvQT+sUM6UFS/BK/1ipFXi/59c/5O1kdG4MbMmCE2rXT5v8iBymThQGj7sq+8k
	 EihQ7jS2ClPvmqFgzikCrC09RgWzorDKSTAR1gn9JeLrJvPvLt/Dc9haeQAjJRaXif
	 wzHVzy66j7Q1w==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bed2195323cso718583666b.1
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jun 2026 17:33:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8Tt5Tcs2eLbAwdKfpNEtoPqq18T7F/1cNj2LsuAkkYpyi+pBDDEWNppRh97Lwr2X2Y+9ybrFUDrVl1@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt0n1WwitUYjVh9PuXSfMGsHOnukKtrKloLkmtbyrG3JjMi8dn
	qJRtuvb01X4uVnHPgHH++buynhs7DFqNaOjOALppasMv1UWqLzAs1hPIIslsJUwE7nQNsTFCsI7
	woC8bRrpte9DF65RiUXTNTByLumeBo/8=
X-Received: by 2002:a17:907:c486:b0:bee:e2a2:bddc with SMTP id
 a640c23a62f3a-bf373a0010amr827859366b.46.1780965195420; Mon, 08 Jun 2026
 17:33:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 9 Jun 2026 09:33:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-cTS=_OPMpTpuYFvT5jPjRyM1u=+KTRdkqMMwNtorXQA@mail.gmail.com>
X-Gm-Features: AVVi8CcS1BeVlQIp7JVwkOEE-mBqfHvt9pFibEOOE9moI9g8l-W2-vCK0Q0WIPE
Message-ID: <CAKYAXd-cTS=_OPMpTpuYFvT5jPjRyM1u=+KTRdkqMMwNtorXQA@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] smb/server: implement compression fattr handler
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 11:02=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> v2->v3:
>   - Add patch #06 #07: get correct compression format and file size in ge=
t_file_compression_info()
>
> v2: https://lore.kernel.org/linux-cifs/20260607022705.317863-1-chenxiaoso=
ng@chenxiaosong.com/
>
> ChenXiaoSong (7):
>   smb: remove duplicate server/smbfsctl.h
>   smb: move compression definitions into common/fscc.h
>   smb/server: get compression file attribute on open
>   smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
>   smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
>   smb/server: get compression format in get_file_compression_info()
>   smb/server: fix incorrect file size in get_file_compression_info()
Applied them to #ksmbd-for-next-next except 0007 patch.
Thanks!
