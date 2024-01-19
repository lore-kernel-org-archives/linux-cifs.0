Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20C63CF
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jan 2024 04:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705639523; cv=none; b=FHDax21pE4B4PttifaDDnaQEQt2e0om1vsTbb16Rjhk4ObXW7ZSEc1T00V2fGhx++MoFdpVo7LB79QGZ9ah9rUguAbvuJbzhF8ZFmP0z82gDCyJtLRJDZSpO8GksO+A+TpJG9VEXjHge/MrFT+5tdMWjHWOdztYo2G2mjYpJkGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705639523; c=relaxed/simple;
	bh=btkcjHTZXKO1tlAbvh0wNM0GoPYNwyuPJQaWbb0fYaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MjFuP1Y1HvQfAlDdUrMHQJiHtFAOuqxzv9EOV8tnclsMkZ8iCAAg9Ciy0ZqC6vuUPV+qTdPQbB5p5PuhW42NR1x7rN1hZytuGmcY8lPbU1m7YzmtZs7Ka+PB84wXKCzbBgcXTiqcclJ/SnlbT0WpwrwMCexv2rYoi6D+iTYudK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KeaMKL9N; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KeaMKL9N"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2cc9fa5e8e1so4546901fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jan 2024 20:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705639519; x=1706244319; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6nl0OlxMVOwb860OgbFr+vrFzUySrE/uYS/VWIBC4Y=;
        b=KeaMKL9Nfi+5Y/U4mL+JrFaTLlVc+82QCD4xaZGsrQ13ulnyq6j+j6vXJ3BY2XkIrN
         ZoKQo4avmVJSBetNHkrkrrCRKWvF+GkbTJaXIxkcqK2yQw8KDckd3sR2eJtKUaUHJU5K
         tk4zckUCioX7Ek1GoCBGPUluGsVmYE5NJLwX0x6CaPaOS/2PE3OQe/yeSS8wd/EKp7+F
         BYhE8qN8/kRUtBWzhtSG6u7ITBOLi9/nNKKCCqxs3suqxj2rYi7NOwnuEDDutaTIGrOM
         We+HVZM6gjeG5P/t4Zg/SXmldpoiONR0rsJMzyj/zMobap7QjYHr1j1Y4iL2ecPrAMlE
         FIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705639519; x=1706244319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z6nl0OlxMVOwb860OgbFr+vrFzUySrE/uYS/VWIBC4Y=;
        b=gWe1lmOFioKN4sXJRWX/Qi4qHexuChiPcHxxTW1CPYx7kzQW5LrK7BsWXDelXnUsC/
         dVVmggVRf8yfMOhqtIMXn0nFD4Qp8r7NVyuo5uk9euJVZ02/yd/XBL162bILtEeq1djB
         v4bvgFEJBKBPQHnSn4HyxiDgwV4bO3Ogwn7fNV/BBCWtkt4EJItmDkg23gAi2UI1a0ih
         P0dOMqjPgo9CVyjY7YJ0OTuzgTPmX04Z8ScUPdW7stMxARV1efVpZeQZnQvMTLC7OeZu
         uzMEt6sB79Fipph6mvWK5lbUGwIRYkTnpOHPgpVyk55Xkd+ARq9OQiqcr/hFE9DLCX2g
         qTPg==
X-Gm-Message-State: AOJu0YyRt2RehoIjvn2zBPbTKQYxCC8OeqD4ZJ99vlTOFtJjid9rZz/u
	IgJx6aMns1GUotGANEMGXfEtq23Z0EC/5m2ISQ5DBNuiv5LllV496ZUjbvhIkh1i7TsWTtepBkR
	2s41gIXqX6217usnNrExWHy+zvAuTMY5p9TQ=
X-Google-Smtp-Source: AGHT+IE7aSLzucWbnEbOXA31GFNhW4iorRMGGq2/CrrR0ztXIo0c/ZrbWsB+0/L5aLvJwdK6ZKsEf0LQFHbuwe9o0F0=
X-Received: by 2002:a2e:8682:0:b0:2cc:db17:64af with SMTP id
 l2-20020a2e8682000000b002ccdb1764afmr925424lji.93.1705639519265; Thu, 18 Jan
 2024 20:45:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240119040829.18428-1-pc@manguebit.com>
In-Reply-To: <20240119040829.18428-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 18 Jan 2024 22:45:08 -0600
Message-ID: <CAH2r5murawfUdwaqYQBim5xervxvwgFatYox92NyiHRtuQWa6w@mail.gmail.com>
Subject: Re: [PATCH 1/4] smb: client: fix parsing of SMB3.1.1 POSIX create context
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged this 4 patch series into cifs-2.6.git for-next pending
additional review and testing


On Thu, Jan 18, 2024 at 10:08=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> The data offset for the SMB3.1.1 POSIX create context will always be
> 8-byte aligned so having the check 'noff + nlen >=3D doff' in
> smb2_parse_contexts() is wrong as it will lead to -EINVAL because noff
> + nlen =3D=3D doff.
>
> Fix the sanity check to correctly handle aligned create context data.
>
> Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_conte=
xts()")
> Signed-off-by: Paulo Alcantara <pc@manguebit.com>
> ---
>  fs/smb/client/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 44abd4deb9eb..288199f0b987 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2308,7 +2308,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *ser=
ver,
>
>                 noff =3D le16_to_cpu(cc->NameOffset);
>                 nlen =3D le16_to_cpu(cc->NameLength);
> -               if (noff + nlen >=3D doff)
> +               if (noff + nlen > doff)
>                         return -EINVAL;
>
>                 name =3D (char *)cc + noff;
> --
> 2.43.0
>


--=20
Thanks,

Steve
