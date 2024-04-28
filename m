Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F510182
	for <linux-cifs@vger.kernel.org>; Sun, 28 Apr 2024 00:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714263023; cv=none; b=bKqAXn3A5tOpjJ+NWztA6NJ9y9+XyMOHIrkv6tFhgnNnSvW/M5axDcdiaY02k+WATEfUxZJ6NLt0TH0ao8CUMToVGNLqtuDMVXfDyCj68/uHZwL5RuyV+/6kssiYDU19TyCbeuPYI6+hEBJMd/ia1FUUAwq55sNQodsN0H5+0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714263023; c=relaxed/simple;
	bh=IWF1XB6+OvXqNQ5F5A2naqZy1e7aj4OQtATpV1FJ9qg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KbqGN8BwNYOjhZoi1SeMOk8Fwm73DqSarxxSUdl9o11js5MM0ExB47xVvQ84iYnQqDeiyTEtzyh4nnc0lSql60mLLHWuLtjaBWudQ5i6T+pbYqtLe8TwQi5fRzCDw4t9hbTKUnBal26RZjZL0mwYKVWUpdmpIUQedLSFiE7Lq9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DztpjcUo; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DztpjcUo"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a58e787130fso116828666b.0
        for <linux-cifs@vger.kernel.org>; Sat, 27 Apr 2024 17:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714263020; x=1714867820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IWF1XB6+OvXqNQ5F5A2naqZy1e7aj4OQtATpV1FJ9qg=;
        b=DztpjcUo1TT7FrLphLBh1lYjmmUvx+1oVzEHH1jglM1l4AZ08UTj91Q/JpWgBNzA2Z
         WDvtCtIsbptQf93T/ibdsKxj+lxNIawp4K0OKXXyXGIVUrh2NQSbX2FVzTgv6vMrZUs9
         Ce2Qcz0LAyOsAMDfECc5/75ai9ALhKNIKw6MvwnVppH/quO7j3jksiFfmRsrHZrv8ugQ
         BzuVGIwdOY3fVftQ2ZsVATFSqkNeavRqRSuKKHM6zbaXihhDQT5y5KomVm/k13R1SdEE
         XO2pSnf7so994uyXMTpNNAiMkpuVYMXj93QM/YGQy2v23+K0MUXvV/n3SXEFpqWOzIYr
         dUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714263020; x=1714867820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IWF1XB6+OvXqNQ5F5A2naqZy1e7aj4OQtATpV1FJ9qg=;
        b=JN3HNmC4bXcYmRr004BUT/b6hPv9QiWIYD7dhwrn4dydls8ynym2pSZqVfxXCHKKBN
         P7wRycu0TAVriIYHIAkg/Lc3499LGhy4siWOWMZGxLGWXW1IV1WXUMyyF3XTTE6bAjZA
         L6OoicH1kx+zmiwc5cA2sX8GG3gf+6nF2bYmcks6dsJqdWridYsiQtEz62kAHXQK0ElD
         2MjVYzkHAijOaAzpOZH65JkMB4YYOYQV1MKZnprF8YYfVBmmr8ORTcFcHXJC8xLzsU1G
         iXNopb+r10/F1E6BJff8c/6lRlwEHq9Bw7LYkTy8bzwyVFd5gK3C3mifhtbO9udV1v11
         GicA==
X-Forwarded-Encrypted: i=1; AJvYcCVq7QVD+LB4Slec5ZO1Xpiliha+t9FYy9+xrFi4vvP9RrYmesk7FMZJotkPLvnDlBeYuA3trdEuAmmKsEjFQIMPtmML3Rfz9LpwLQ==
X-Gm-Message-State: AOJu0YwK3ckL6n/Ro7XAKPHvX7H/8TEg+gu+f5U/WB3EOiDyZSer9+t8
	HAPW5FxRg/2UR+ejRHEGyIPWyuBu2MFLWkDAJm7ldrlj/nOxOYjWAuy4euOAzfwU6GEaLrmGOaB
	p4J0c2rDS3lg8a5b65mKbdYWhxg==
X-Google-Smtp-Source: AGHT+IGKbpc8kBSv7K7JWjjSIMg7bpanMSDglgk8dRE/T0ELtmvNEdKdpmxwTc2ASWgkuydh6+H4NwXRr8a2Ax5RuWM=
X-Received: by 2002:a17:906:3b48:b0:a58:ea69:3f5e with SMTP id
 h8-20020a1709063b4800b00a58ea693f5emr1787131ejf.38.1714263020295; Sat, 27 Apr
 2024 17:10:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403052448.4290-1-david.voit@gmail.com> <20240403052448.4290-2-david.voit@gmail.com>
 <80e09054c9490c359e8534e07f924897@manguebit.com> <CAPmGGo7XogXA8RppeqOtidWsgL84u+J4SUB7-st=A9a2ooPriQ@mail.gmail.com>
 <CAKywueRW3PoAJcfwPWANh-oJeop6VP6BXsSMVR1Xq2LcTmXKDg@mail.gmail.com>
 <6cf617eb193818174f91ccb1a969045f@manguebit.com> <CALe0_77OG0Qq+SW+mC93-NmWvE11P-nSCMTf1aELfX2caWDHSQ@mail.gmail.com>
In-Reply-To: <CALe0_77OG0Qq+SW+mC93-NmWvE11P-nSCMTf1aELfX2caWDHSQ@mail.gmail.com>
From: Pavel Shilovsky <piastryyy@gmail.com>
Date: Sat, 27 Apr 2024 17:10:07 -0700
Message-ID: <CAKywueTycbmAXNLb8=0G3L17hTSfzX9hGPku+hcY+yBJ3OtG2w@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] Implement CLDAP Ping to find the closest site
To: Jacob Shivers <jshivers@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.com>, David Voit <david.voit@gmail.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=D0=B2=D1=82, 23 =D0=B0=D0=BF=D1=80. 2024=E2=80=AF=D0=B3. =D0=B2 04:41, Jac=
ob Shivers <jshivers@redhat.com>:
>
> On Mon, Apr 22, 2024 at 11:10=E2=80=AFAM Paulo Alcantara <pc@manguebit.co=
m> wrote:
> >
> > Pavel Shilovsky <piastryyy@gmail.com> writes:
>
> > > Jacob, Paulo,
> > > Thanks for the testing! Let me know if you want me to add
> > > "Reviewed-and-Tested-by: " tags to the commit.
> >
> > Please feel free to add:
> >
> > Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> >
> Please add:
>
> Reviewed-by: Jacob Shivers <jshivers@redhat.com>

Great, thanks!

The patch is updated with reviewed-by tags and pushed to both repos:
https://git.samba.org/?p=3Dcifs-utils.git;a=3Dcommitdiff;h=3Dc6bf4d9a59809f=
bb0c22ef9eb167c099ab8089fb
https://github.com/piastry/cifs-utils/commit/c6bf4d9a59809fbb0c22ef9eb167c0=
99ab8089fb

--
Best regards,
Pavel Shilovsky
