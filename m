Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE70234E753
	for <linux-cifs@vger.kernel.org>; Thu, 20 Nov 2025 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763651095; cv=none; b=gkTMHyHiH0pXUQz56KyNO7LHRAHrp0YeTouoREzr15+1O4EUHeKAG44+8TAOzFq5MdxVXxTrBOv6rfLpUJ6kik2y+DaGJpo6vKgHhR7GXgAZ39sHbqBnOXZbWT/ecJq0uYDjAUFOEKQmlWB2mpnVOevvks38EO7yPVHWGApbiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763651095; c=relaxed/simple;
	bh=NbNdR+vY3IqSyNtreeEa3AHm7XvOE71tHIEOstePnBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HUO+tYYb8PW/QUyeTasZ039WkJGvTxQ20+ZZYhSWr7s3TRYCfiPEkqpRFrAAQzWXOS3J/4rtHH11EBooLMseug2EKTR6P/GwlzXOFGrOWPaekm2/KJ4HN6SN0FnlOXSvVzwpDkMqk9abRwg1R408+RKNq9EPeMBhWrM9DUDK59I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KfyhHsTJ; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KfyhHsTJ"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88057f5d041so9077586d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 20 Nov 2025 07:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763651088; x=1764255888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6kRFpPUlL1GMv8pTQgs/uuj/dHi7IU+YUX5w8tOzD2g=;
        b=KfyhHsTJVUsWbCh5qfxTzMUixCdBGEJSE1tMXBOGGS7q9mEUAvx6x5tfLTgTMFwzMt
         iVADJ8PbrUd2QGlOnlwwh5GXt59C8I2VRtju8Nn2onbd/RnDB+BakeGotwT7AguT3C46
         DhflEQj6DNDLwWwLkT0Ci0kjA1YKyJivy25lxh+Hj6Y0Zj1ZvHmZk1qr6mdbS/Gw+e2+
         U38C/0gRuJODxyO87X5043/mUh0lw49jJ1MMbgsnaRqhV56Gw6p3q1ilWI3RxQjDoqdA
         Fw7gaPReXOqUxbcF9qIn7YUtaYbbilYtFoHHXg1hdlhrln9m0z/sgNIQ66HZhv3lTfjN
         B2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651088; x=1764255888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6kRFpPUlL1GMv8pTQgs/uuj/dHi7IU+YUX5w8tOzD2g=;
        b=e/SvaXvGvYriTw6ccuhsK6g1rQvbHKaRxLHw0rd01ksBNCT+p4fy/LLS357chOqKPs
         sGnaPbYAYCtdummerrJA9lk7mNeHEIXbKlkZgMSWaXPiJCj7sfuy1Lmjb2h2jUF6EFHL
         Ljjqt5Zk4Cbcfpl1eA06RewJ1SO6Qs4fRnIFmnKP1i5xVteLO029YXLFlKZH2B4aAkdd
         mQMBe6Ir3EziPKUPJeMmSZ6c3qPJuSfSY8RJtdz/wFLPSq/T4xX/O2+VJdR+vjPFmgpZ
         kFxyI8HOhfnv2B5D1HK8bBrFr9+eWpl8m5C9Fiqvi6fBvdnJ2UtpZgniXmKAaB1xWWFv
         vfYA==
X-Forwarded-Encrypted: i=1; AJvYcCVSlPPwmzuHeGb4ygKW2GAuv7cP6qWGHWILcL1ps1yUP/RdjlWcT+bBLrwN7yCBPDQseATa3J+JJ1Gu@vger.kernel.org
X-Gm-Message-State: AOJu0YxYjAuMNYgoKePaQzsjOHoOx5h1jWrr+fGYsKjlJ+lvC7GbPB+I
	YPrZNLP4E5FtHhj4QHFIQ5Nl+vu97JPR3MKlw+xNj9sO1DpHPSJ+FJ3+gWkhtx4JeblBhscUFU/
	Jdsbj18zQK9g6fJhiT+URKAyMMrEs4nQ=
X-Gm-Gg: ASbGncugP3ERGTcWNiufg4tA7bmMbYJVFcDemyQTr4ACXNO1Ncwi9b5GZTZ4XbLt0Fz
	LS//Vj4fGMgrH8DIFPGEfb0l53MIbEPjaPrk/cJJbrHN4T4lVSEVbCUXCgtvAlFAht9NzxS5qoN
	iQtYJOFd828G6G+/wf1nH410JNDOWqacIK/S7YSx7CSwE7HsUglt/XBKXfOmHcUV7LNjkaFL9CY
	V+MpuBBowLBkXY67MolQae2lz92Q0XkhMpWdzOWS8alVuaIxbKjJSnjt3sA9TvfTQgUmQo6pHVv
	JJJlpLBGgbc9vdw/V66xan7TgsdUYDoO6u5TWulq6Z/slRCT6i4cvuu/8/RiCE3uzX8gN+XlbNh
	+03jHBxj9OhGW+UpHDbNHRd/8vMimvR3Mo5Tr2ryzmHhK3YdYo6UbJcpcbg6BzY0gcGUkPSPXjG
	pGFGrjGH70qQ==
X-Google-Smtp-Source: AGHT+IFsKkXhYMhdtsra+P/p8EP0e3W7i7D0GhBHrYUlEp2ymhejSmkE+PNaMgkvA7xkNx/rrZIboeX4ZOKJeFtVYLU=
X-Received: by 2002:a05:6214:4903:b0:880:5279:98e9 with SMTP id
 6a1803df08f44-8846e131c85mr49130116d6.40.1763651088222; Thu, 20 Nov 2025
 07:04:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118022655.126994-1-rajasimandalos@gmail.com>
 <20251118022655.126994-2-rajasimandalos@gmail.com> <7mc3cpg6qojvq7hak6jvkud7xgynmaki554tgn2jic2y52onzm@ugw7wsq43wsp>
In-Reply-To: <7mc3cpg6qojvq7hak6jvkud7xgynmaki554tgn2jic2y52onzm@ugw7wsq43wsp>
From: Steve French <smfrench@gmail.com>
Date: Thu, 20 Nov 2025 09:04:37 -0600
X-Gm-Features: AWmQ_blXfBEk2RwNC6znsiMRxvr5QE5e_9rCamPn7heku5OMDZrkh4jsUebDcd4
Message-ID: <CAH2r5msVd2Ygtfmp_9L-tuPUMT7pcW1aQxobHuOjtgYEWRgZ6A@mail.gmail.com>
Subject: Re: [PATCH] cifs: client: enforce consistent handling of multichannel
 and max_channels
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Rajasi Mandal <rajasimandalos@gmail.com>, Rajasi Mandal <rajasimandal@microsoft.com>, 
	linux-cifs@vger.kernel.org, sprasad@microsoft.com, pc@manguebit.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	sfrench@samba.org, bharathsm@microsoft.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 8:01=E2=80=AFAM Enzo Matsumiya via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> On 11/18, Rajasi Mandal wrote:
> >From: Rajasi Mandal <rajasimandal@microsoft.com>
> >
> >Previously, the behavior of the multichannel and max_channels mount
> >options was inconsistent and order-dependent. For example, specifying
> >"multichannel,max_channels=3D1" would result in 2 channels, while
> >"max_channels=3D1,multichannel" would result in 1 channel. Additionally,
> >conflicting combinations such as "nomultichannel,max_channels=3D3" or
> >"multichannel,max_channels=3D1" did not produce errors and could lead to
> >unexpected channel counts.
> >
> >This commit introduces two new fields in smb3_fs_context to explicitly
> >track whether multichannel and max_channels were specified during
> >mount. The option parsing and validation logic is updated to ensure:
> >- The outcome is no longer dependent on the order of options.
> >- Conflicting combinations (e.g., "nomultichannel,max_channels=3D3" or
> >  "multichannel,max_channels=3D1") are detected and result in an error.
> >- The number of channels created is consistent with the specified
> >  options.
> >
> >This improves the reliability and predictability of mount option
> >handling for SMB3 multichannel support.
> >
> >Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> >Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
>
> It's conflicting because it's already too complex for something that
> should've been simple.  This patch introduces a new field + unnecessary
> logic on top if it all.
>
> cf. a PoC patch I sent a while ago, we can (ab)use fsparam with same key
> name, but different key types, so we could only deal with:
>
> 'nomultichannel', 'multichannel=3D{0,1,off,no}' as multichannel disabled
> 'multichannel' as ctx->max_channels=3D2 (multichannel enabled, obviously)
> 'multichannel=3DX' as ctx->max_channels=3DX (ditto)
>
> Makes 0 sense to have both multichannel and max_channels mount options.

We can't regress customers who use common mount options without
warning them for multiple releases that parm is going to be removed.

I don't object to changing Opt_max_channels parsing so
ctx->max_channels in fs_context fgoes rom a # to a combination of
number and something which can be mapped to on/off (for on client
picks default on the fly while for off sets channels to 1) and
removing ctx->multichannel - so if you specify "multichannel" it sets
ctx->max_channels to something like -1  (or whatever max # is) and if
you set nomultichannel it sets ctx->max_channels to 1

--=20
Thanks,

Steve
