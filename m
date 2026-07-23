Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D683BA253
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 06:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789176; cv=none; b=I1CYQZ36s3+Pc/MVkrZN9EUrnTk9rKP3NC38QwfSpJ4eEyZFsDVKWvdWO6x5URg4RvYcT8r/jfXN6wRxv3GBGvKBLdz8rcfJ3MHzjkZoGq6EzyoULC592419WOwo9gcGox1KVPDCOc3l5bf/LXxL61l7k5F0uutavhE1BhJLKII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789176; c=relaxed/simple;
	bh=r7c5D+jSGi/m2/H6mVmoDJXLCVHFh5zMB1X188PNLM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nf8AgL+T5ln2oBLSD4PHqYsGncu3iWVWZHSDPoGOCbr/slaoxKTO7kCPPOMhxWHtPOtn3qyO3ofLLf+j30YFgcG6K0LdmX1u8DYrXfTXCTE3vS+EYc0nb1Gm/WSx04/mKi3uuTb5CNc4XdBRwuB8AGKx+0Xd+Z8K/JJLF77pRvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTf7OJNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTf7OJNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8C51F00A3E
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 06:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784789175;
	bh=QH0lyKCszn5nmSOsVZmuUhk1NmYVorF8/P1NXrUwebw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VTf7OJNHW3xth+YR9rVLAB5GD4Wt378gcqkUFB51ZuE0988v4Kz3peB2mdY65Z+vz
	 SASK8gtaUeyDQd7STAojuFlyRLJqHZFF4W4qlCS5GMOKEMGgWWTxqijf6zxJbbOZ0j
	 RKPD/Y0vjbRnMnvLvHACXzRdv++Wtx5c1rWA2By1HnmISpXK9jxRJMqhg6FyZv5/Uc
	 nXsrVJIEAfSxlw0mP+xNCTglmOXxsX1zqxt38GpO+MzdTll6Mn41r7+NCWPRnP0Z0V
	 /oRLFgowykTxSIct8vDpd/soLaO/Wdjz7RPjP7RRsG0LP4ljz35Rx/nfIoo+IJwkWT
	 DJw/A2HFkE12g==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so36633466b.3
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 23:46:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpHIYoXOybA+Tpbdh3nTfSh+KfG6J9trtlcS7dFSckIWWoq0M9cWDgCUuTx/KMjvzWPwTVDuAwrZ24w@vger.kernel.org
X-Gm-Message-State: AOJu0YxxMdUZOYksnrY3yfiQR20PzTlfvbbVgfDw0iQkolGSO2YHBlZo
	ReyBvlHLkyU/KZdk0BwUC5+ctUXm/26vj2vGGQc4/upGpyNk4KwSSHZhTO4e9UNXNUjmkfKJF8G
	K+BIfmpg3uYKcTEL+/A4LrR0Mr1kSxvE=
X-Received: by 2002:a17:907:980d:b0:c19:80ed:cb2f with SMTP id
 a640c23a62f3a-c1c508d2124mr89454766b.8.1784789170702; Wed, 22 Jul 2026
 23:46:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 Jul 2026 15:45:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd991Gom48RKi+5ScWY+RMvaqeTOM=Gt4VRSiugtHXaaaw@mail.gmail.com>
X-Gm-Features: AUfX_my-e1n2XVo08eyhXlgNKIyRXtyRC8SiF0NcOZJh-FebYV2BZgwSkAFsWGo
Message-ID: <CAKYAXd991Gom48RKi+5ScWY+RMvaqeTOM=Gt4VRSiugtHXaaaw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] smb/server: fix some bugs in preparation for
 change notify support
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, andriy.shevchenko@linux.intel.com, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 1:12=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> v2->v3:
>   - Patch#01: use WARN_ON_ONCE(1).
>   - Patch#02: use list_for_each_entry_safe().
>
> v2: https://lore.kernel.org/linux-cifs/20260716001156.671587-1-chenxiaoso=
ng@chenxiaosong.com/
>
> I have implemented the ksmbd change notify feature, please see the follow=
ing link:
> https://chenxiaosong.com/lkml/ksmbd-notify
>
> However, to make this feature work properly, some pre-existing bugs need =
to be fixed first.
>
> ChenXiaoSong (3):
>   smb/server: fix signing when a response uses more than one iov
>   smb/server: cancel async requests when closing connection
>   smb/server: stop new async work when closing connection
Applied 0001 and 0002 patch to #ksmbd-for-next-next.
Thanks!
