Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE2D1B3926
	for <linux-cifs@vger.kernel.org>; Fri, 13 Dec 2024 11:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734088050; cv=none; b=tnUn9FMCp6gVgTVLE8bHC2nFP1v4/tFuAoBuQaGfbc0dDv9KAkTQncCfJmyUdjpZNpnkZ/U0TIbJFo+5L7bgcXPfVGRw2ZhUDxAGLMN20YI9Eckl4q/2/cPZ9nntXIt67Of9iBQcOZA2kJSV+ovw1u55M+1E4m6Y0GCzCqY7uQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734088050; c=relaxed/simple;
	bh=9/YuqMnxamvX9okje/FO//soRqI+rZUB9oxjBOC9l08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q5y/YyHeAg2rE4RQE7ffvvF4of6XgeJMGlpAtdjPFpKo30iZ4w2iXB+gJGyEQQHMHasHBKBrRXl0QpjsEh/wS4awL1DoB8NepC9AgnWT1LMy4EuM6jX7XboSan4SMeUVX/yJ5A/v5VaCFmPPXyCs32LDS+jTDio0SbUb8rB3psU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b93rf06w; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b93rf06w"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e3f78f5fc07so1241176276.2
        for <linux-cifs@vger.kernel.org>; Fri, 13 Dec 2024 03:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734088047; x=1734692847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=omJqonO5o8m0ptvNOZZdmIKEiC6sRRWs4zb/9QNb9SY=;
        b=b93rf06wAE3J7ynYu2YqaLpzhJ8zt1kdkWhXZ+ZOAtIFnL21peDOtBohW0YwZAmw2T
         DnYXCX+r83RjoGpM8Tyem2PWjnKwJYWmXDhvN+nAspYRCutk1RLx37RLSovZrfGrs2I7
         qVwCWyf3Jp2zxRVnN2aO4e69uJfmOmcRcyjiN7+IobDcdjDsiPjD8jOpE966WZaWZcah
         wx6eX+evQrw+pjlt1DXIMvLULNkEzQVc2/cX/K0uqkbQTYijrcBtEzXlt88/VlB0H+Ru
         cn22bt6hHtEqtPazRhBjNU8HucKt0++xs+/X2shCk8KzENUGkvgQMF7s6q9vbYxZjQgF
         zAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734088047; x=1734692847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=omJqonO5o8m0ptvNOZZdmIKEiC6sRRWs4zb/9QNb9SY=;
        b=HUkU9hIUGPAAua4q3bSsaHZKDZ8TocBGwI+76d4Wlk03ZTiP+M7OV9GudZvq/XqQ0f
         /LLDS4cf1zm12JzXLMM6D5+KYcXGCc4Z7O3dKdR2wwM1qtqKaNHuE+IxqsvuQaSElG0J
         68XyfPwUD0NXos9d1wdHI+3BgELU09KL2ZbcEOEkYQ3e23hWThlTUUVwTSvtoxccPvCb
         BS/Jew8bxdIOHIG+udoTSjdoFAzXZtSueyyEL5o491T1mpVC2o11cMadBESMycaJoSS/
         5rdGw0PyaU4Az56NfwAplsCS6tXGsrwULH6V12HnHkoyfEDfIhY/8P9ZVV8H7WCZlWOU
         wUig==
X-Forwarded-Encrypted: i=1; AJvYcCX+dxx49jMv6fySus0yJ/C6scnZg/zK77Ws70COUFRqaRhExuEp01Zksy+N+8aAOfNXX57njb/g6sHG@vger.kernel.org
X-Gm-Message-State: AOJu0YxdB7E2313xT984KpJDjgkGyUfNEvofKuuRdauVDCRpNTEoJyNQ
	gg6b+2Wg/nxWsVbk3eeLhLUtY8DOFpeC5pIoo7GmuJVcZQ2xF/HhvHgiv5+EBwz/6kpfntz00fe
	iRSE5K1tXa45uI6iAgFU3KigMeIn43KKADQ==
X-Gm-Gg: ASbGncuU92ndwh/wyZZUZNB/nfNQ4jfiJqsd62wB7i37ZHB8v9LbM8b4DGZp3w1wA6S
	NFX3f3eqpCrtD3fN80uH1GjbJDrFoY1oA6kshDpdEmuuVtcllbmXfDT/NG2P/kZhnNnUfaw==
X-Google-Smtp-Source: AGHT+IFDZxH6PF/361HeiL0FZ0dTMPDzpQIlARqbl5gWnCwocZxy3XAUKVgXNIONbL1ghg9ULmSrA3hX1Y4U/OGggQo=
X-Received: by 2002:a05:6902:2413:b0:e38:8a2e:e3bc with SMTP id
 3f1490d57ef6-e4348b31398mr1786217276.5.1734088047453; Fri, 13 Dec 2024
 03:07:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241025072356.56093-1-wenjia@linux.ibm.com> <20241027201857.GA1615717@unreal>
 <8d17b403-aefa-4f36-a913-7ace41cf2551@linux.ibm.com> <20241105112313.GE311159@unreal>
 <20241106102439.4ca5effc.pasic@linux.ibm.com> <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com> <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal>
In-Reply-To: <20241108175906.GB189042@unreal>
From: Kangjing Huang <huangkangjing@gmail.com>
Date: Fri, 13 Dec 2024 11:07:11 +0000
Message-ID: <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using ib_device_get_netdev()
To: Leon Romanovsky <leon@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi there,

I am the original author of commit ecce70cf17d9 ("ksmbd: fix missing
RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"),
as mentioned in the thread.

I am working on modifying the patch to take care of the layering
violation. The original patch was meant to fix an issue with ksmbd,
where an IPoIB netdev was not recognized as RDMA-capable. The original
version of the capability evaluation tries to match each netdev to
ib_device by calling get_netdev in ib verbs. However this only works
in cases where the ib_device is the upper layer of netdev (e.g. RoCE),
and since with IPoIB it is the other way around (netdev is the upper
layer of ib_device), get_netdev won't work anymore.

I tried to replicate the behavior of device matching reversely in the
original version of my patch using GID, which ended up as the layering
violation. However I am unaware of any exported functions from the
IPoIB driver that could do the reverse lookup from netdev to the lower
layer ib_device. Actually it seems that the IPoIB driver does not have
any exported symbols at all.

It might be that the device matching in reverse just does not make any
sense and does not need to be done at all. As long as it is an IPoIB
device (netdev->type =3D=3D ARPHRD_INFINIBAND) it might be ok to just
automatically assume it is RDMA-capable. I am not 100% sure about this
though.

I am uncertain about how to proceed at this point and would like to
know your thoughts and opinions on this.

Thanks,
Kangjing

On Fri, Nov 8, 2024 at 5:59=E2=80=AFPM Leon Romanovsky <leon@kernel.org> wr=
ote:
>
> On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
> > On Thu, Nov 7, 2024 at 9:00=E2=80=AFPM Halil Pasic <pasic@linux.ibm.com=
> wrote:
> > >
> > > On Wed, 6 Nov 2024 15:59:10 +0200
> > > Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > > > Does  fs/smb/server/transport_rdma.c qualify as inside of RDMA co=
re code?
> > > >
> > > > RDMA core code is drivers/infiniband/core/*.
> > >
> > > Understood. So this is a violation of the no direct access to the
> > > callbacks rule.
> > >
> > > >
> > > > > I would guess it is not, and I would not actually mind sending a =
patch
> > > > > but I have trouble figuring out the logic behind  commit ecce70cf=
17d9
> > > > > ("ksmbd: fix missing RDMA-capable flag for IPoIB device in
> > > > > ksmbd_rdma_capable_netdev()").
> > > >
> > > > It is strange version of RDMA-CM. All other ULPs use RDMA-CM to avo=
id
> > > > GID, netdev and fabric complexity.
> > >
> > > I'm not familiar enough with either of the subsystems. Based on your
> > > answer my guess is that it ain't outright bugous but still a layering
> > > violation. Copying linux-cifs@vger.kernel.org so that
> > > the smb are aware.
> > Could you please elaborate what the violation is ?
>
> There are many, but the most screaming is that ksmbd has logic to
> differentiate IPoIB devices. These devices are pure netdev devices
> and should be treated like that. ULPs should treat them exactly
> as they treat netdev devices.
>
> > I would also appreciate it if you could suggest to me how to fix this.
> >
> > Thanks.
> > >
> > > Thank you very much for all the explanations!
> > >
> > > Regards,
> > > Halil
> > >



--=20
Kangjing "Chaser" Huang
