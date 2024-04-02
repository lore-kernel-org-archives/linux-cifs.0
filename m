Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38E215E5D9
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 21:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712094061; cv=none; b=lp3tFVOwsT4N+0zf7QqPIzj4ZTPULQSrVCxCmcLaCghYZj/aVw9rANDknmrqFYnZXZstJ4g0UHRXHiWHvkFdS8W9CWkd7sPXUPwFK5GnOxHk2onhFFKE3D5sXgzsKz9cFe933ZYP9u7vMXCTE7GjFr08G7Z6wCYm3i24CQAM35g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712094061; c=relaxed/simple;
	bh=3SU/5RF93BsXTUD+1KFo8HW4+WN9gUT3/JNlsSRF8Eg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=glIvsCISI2TBtAJRQzBdFsTuTeBZojK5LVJo5AqgLeYdkEDa1tNtoyTlVVvMXh0H8XELqso+zpaHArjlb4qpxS+kYi1+aXQ/V4qFKFj/eHsIUytOCd4RzEyiPMJPE8P4pRHu63bElswWzTGbbdwnuVYAPCqvTH85O+KO1Trb3yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBj6fEjR; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBj6fEjR"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d109e82bd0so75556661fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 14:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712094058; x=1712698858; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWMhJ2CSl5pzMEXEEqsnsLbOBqtyJy05X/IyfR0rE2E=;
        b=cBj6fEjR5pXr3GoUi3GA0jBwDq311uj4q254G0bc8mTbSVjbz3EboOV2bHR/ufqfyr
         iUzYGnRuKMwGGem1TFOVPU3Nde5bov6roMVBF66vQtcca8XOOP1bSn2h0/miw+kzZCgg
         m/wkVWTwVAwohVqE4HYXrxQeZYq7iL7DFFeFUIL+XYbllBUco5NVucNM5Un/ZQWyQOMC
         /GmxUcP+woN8SNCagtYsQzdWrhGfJTOTpjH+8hRvD6mcG2BulYYidt5asJvwpG8quhAj
         nxS8d53tzRd67s9Bxcr2LiCyLWV19ueGUodZ7aOYRldQb58Y9znglN9o8NO0szDxda07
         Eqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712094058; x=1712698858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qWMhJ2CSl5pzMEXEEqsnsLbOBqtyJy05X/IyfR0rE2E=;
        b=C8l1KzU3JG77GEcns4BUNGjrPl1UA95KWaCia0DMTC571yG9wlasAgTivvKugpPtA7
         xIS+OffGpO+2wwLNJL1UpVlUOfR2ny3W9amiornJh8+YYFk7QzIU4cElaUAbytgjhiYr
         i8c54a7oAkdNW/DyH8T617sjaqqrdQwaTcdOmw4zfbK13DOId/QAGtRaxnGEdn8wU2Re
         l3J98bAow4qcGfTwrayEQqyvq6O8LxSULWQYj3oYtCA1KCCzk02iXM/p5sDOuGe+igK8
         UCtnOEkQviOBfOERz4BKE5ytIE/y5PYhtHgGY4THcCDPctJZ38rYugGdp3IfbqWuyOLX
         CfMA==
X-Gm-Message-State: AOJu0Yz5mEQhfOBgghsp7FVhUA5FU5tEptU3OPXUQKlA6IkKxg0LztBL
	Y3bmUDC56ZyfG3+ZtBlzKoxued+eAxUAIbxHloLc5AvCNE790Yq7lkA7BtdxjfQHqPYXSrOsUa8
	DJgM7CQUTnO+LzjLQgA1sIXjWQq3DF6Tc
X-Google-Smtp-Source: AGHT+IFO0C7MGJ6ATl8RfpVT1AzIHmFmJDnBlflrkT8HfALI6v73yn+qQ5BqziMLWWe5vzJ6hH5Wk9wE5gYZONS3yNY=
X-Received: by 2002:a2e:9216:0:b0:2d8:2761:a90f with SMTP id
 k22-20020a2e9216000000b002d82761a90fmr3059031ljg.33.1712094057684; Tue, 02
 Apr 2024 14:40:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402193404.236159-1-pc@manguebit.com> <20240402193404.236159-11-pc@manguebit.com>
In-Reply-To: <20240402193404.236159-11-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 2 Apr 2024 16:40:44 -0500
Message-ID: <CAH2r5mut+JkLhMCjeqPDNxLP4mhTa0LnEHTneL66Ktyc6WzVBA@mail.gmail.com>
Subject: Re: [PATCH 11/12] smb: client: fix potential UAF in smb2_get_enc_key()
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Isn't this needed to send the SMB3 Logoff request?

On Tue, Apr 2, 2024 at 2:35=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Skip sessions that are being teared down (status =3D=3D SES_EXITING) to
> avoid UAF.
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/smb2ops.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 1506a0eb10ba..4fd2ffa2ebba 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4188,8 +4188,8 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __=
u64 ses_id, int enc, u8 *key)
>
>         spin_lock(&cifs_tcp_ses_lock);
>         list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
> -               if (ses->Suid =3D=3D ses_id) {
> -                       spin_lock(&ses->ses_lock);
> +               spin_lock(&ses->ses_lock);
> +               if (ses->ses_status !=3D SES_EXITING && ses->Suid =3D=3D =
ses_id) {
>                         ses_enc_key =3D enc ? ses->smb3encryptionkey :
>                                 ses->smb3decryptionkey;
>                         memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
> @@ -4197,6 +4197,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __=
u64 ses_id, int enc, u8 *key)
>                         spin_unlock(&cifs_tcp_ses_lock);
>                         return 0;
>                 }
> +               spin_unlock(&ses->ses_lock);
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
>
> --
> 2.44.0
>
>


--=20
Thanks,

Steve
