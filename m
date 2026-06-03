Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3659538B7CD
	for <linux-cifs@vger.kernel.org>; Wed,  3 Jun 2026 18:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780510514; cv=pass; b=NnuWJbGRsTuCOcESTNwzFmi1g1SKdkJ8KXgwrCE+DPYciPVrBdAOfsQpECCsMwMfs/KvipljtW7DkzlOW20Z+M03S1EGWIJVFNmZYv/FgGhgvtSqA2wHabsthqEPVWFd4Ce/zT5lYcNXwoC3c4xcpWivfBledEgSy6lwHFl2wA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780510514; c=relaxed/simple;
	bh=bc8yf+vDwLYZktVpT0wu1uj2q7kMRTlyg5TCqNOarGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ug8fC6kaU/UXugBx9fhkqeipFrC0Clq7KTcGdAybxYCfoUBGB0ZuKAIz3etOuRZw2WU1SbZ10saOd9z3uHzw5GjMe9f3w6o8BRTVg7CXl/9E+71INpfXtkmjfmLONMIAwiDqZSpjyG5hRbmc9rvc48HYSJPfNufpVomhdjt6zzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aFV+dOeu; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFV+dOeu"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36b95eb4bb4so3337317a91.3
        for <linux-cifs@vger.kernel.org>; Wed, 03 Jun 2026 11:15:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780510512; cv=none;
        d=google.com; s=arc-20240605;
        b=YHDG6hzMRlToE4xd9fRIKxGaeoarxCAN0hOVhPBL0vJ1rS473TSZz8G244a/9/wdFY
         rSqyTOpjqC94LqD6vaxEgsk83EnBfCFLwRWBdK3fWEvGHzxM8sdi5ZLnifIzVnYtDIAS
         v0tDot2ktz/aDBD66fefEny2a7r/rs4KdHUez+jYz+ya0l6bPbW/ouJywhxHt5zeqwcU
         6FAB1ocXMXH/wNVvJ2c7QFx20STY/5q5n1icH+pLIv1S/EFFNKwIII5ciagK2zNKmVB8
         XOeiVSmQyO1rsgDW62gvnPUFcqHrnR7Hd5swLGGN372ugNrzksmw2Hktwrsbny8ZUf1q
         H4pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bc8yf+vDwLYZktVpT0wu1uj2q7kMRTlyg5TCqNOarGo=;
        fh=IGoM//hTGaXA1R4+mq+B45qURDr0XE2Ju1lXuyI+A0U=;
        b=ZbAF8Xx75Bm1cdBRarzu97WrNnYIqrhb1LOKxm10RN3EQZMvtrjw7AcJ3p0KW4IEJI
         WEkkZRZGur5IdYcU4L8tlyzuVT1L3ZMjt0GOx4oJvkeF3we7HVtbqXsKuR4WepiU0lov
         jC/HLHEJmZF39uv4PoLGu7yitilc1cFpUyGSrNges8r/4i1SpaSYv/NMAyrwChPSnGTS
         P5gghwiraE8tEC6sDEiTywg+OjUMAdgvKkaz4lvXaAd7KUVK6fRAm59jKYwun0F4VI5Y
         MBQ5hri9lG8p5R3ja9vXk6xgqQAizJu9QCRT8/fP7rJSuiyFxDSGGL+Q2hWWW1kK/13V
         XYmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780510512; x=1781115312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bc8yf+vDwLYZktVpT0wu1uj2q7kMRTlyg5TCqNOarGo=;
        b=aFV+dOeuTPulqvokDemyQ2rRRI8G9mxnL9EdLVLIxJd3/t1aI6kytBhskmoGD/UNsf
         O0/pKKvF4x9bnPbdZ5ETO3r1VNoVmXGRvFdVpsg2LoHOEieRUbzbuKLitKobkt8GsjMw
         2Xevb6m24RjwsNJ4l/AswTqPq4UosI9zBOL/3kPitQLn4dIvBXCRWh6kw9nimM2p4Qvc
         6qYedgBs4AsnziovFyWghBVZSz+rnnfSc0jlgBhYO4/MfoXelOK66hvE/D+bGgV+Ly7W
         7UTlMRV+loU00xg9kQ+DGGOMcrOYn53JtQyT/bSqfgasiHENPIstoGCBOogt1naxJayi
         MNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780510512; x=1781115312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bc8yf+vDwLYZktVpT0wu1uj2q7kMRTlyg5TCqNOarGo=;
        b=FhhYiCHH4rO2Ho3Iqx2/dB5OPi/8XxPGFPl1sQd66JndQDdKIkTnzKto+6rCOB6XyZ
         jrHQ6N9A93MVTDimPBm6ceu+yDN+vwoKYrO+FdgUNWweB0eUnwLKRrZx8ywP5azCXAJz
         ekcG+nD279yXb1OBvNeKFLXoJV9ySTYXFQN0WGz/c2iFw3OZNV0eSpthQCLvTwY5yX2i
         sMWEVL1p/YEn0+q4ThaM/uD4y7qyOSytqjx/XJEo01+LaCpl+WKVfDsMkM1q1PnL+Hf6
         dos+Rfm/3ktMBxcR4tzyD33uDQQZABMgqkQwnKdEqyTIRL3Qg1qW+9iPZ68lBQwRgsd1
         8B4A==
X-Forwarded-Encrypted: i=1; AFNElJ+htmDh0CqXXLO1rs4HYkJzCPoZR0iHH19eFC3w7U6sBSFkDFYFJOw7qgRCErASOi3sifR8KjFwgAWd@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+25ddqEu1iuNd22zeHqpP+FXr9upyLeMcYkkr6756AU720V2f
	SPnM6Gqj9DI0KszPxa431usfmefkCWc6jp8MoWePoT4SDZ+CFnNbFbpN+KXD2OnEUV36Lt+RtAx
	BuFORLsejEYNn2kfoAl4pndS6Qp4y5EA=
X-Gm-Gg: Acq92OGapccx/OWrGHOSHBN2F8P7z8BlR3Gk0v51GQ/RdAQnuhCsbyA/LPmzpdavh46
	ZxaMsEFVGJmrXFR2zY4WLuF0QN213ZJNLlEFqwtigfbATLFplxw7en+G0tVOxTH8R1nvfXK59r3
	H3hDUGu72mWZTO8Z+kIXvdT0ab9vpl2DTKfFwgVmMB+aszz9y0jzpa5oBN5b8oaSmzdpDcgmNmk
	zeajziyZZdzN9/bFwS2ZZ9K4TmUdeZ+MUZvRuNHLXdP1zGR+yaz3FiweWaSJ3HXYvi25Eyzs6t7
	gnETDpMNX90F1v8uFj3/ymgxyZumdsle0saD7vGlrvudhvgi9OCZMtqyD0/AYEZMwkK989/CZ8k
	d8NiuQy92FTXfJg4clQ==
X-Received: by 2002:a17:90b:3f90:b0:36b:71e6:3de3 with SMTP id
 98e67ed59e1d1-36e308379b2mr4410234a91.3.1780510512536; Wed, 03 Jun 2026
 11:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780232930.git.lucien.xin@gmail.com> <CADvbK_fBbLCwY61HXsNeGCA8MhiBKcbvE0BvSZppohJgtXO+2g@mail.gmail.com>
 <20260602111823.0b1129d6@kernel.org> <CADvbK_e7T=Yfb800TbO+BcpDEp=Sf6rbtiy2daLaskFAjeg=Ww@mail.gmail.com>
 <20260603103924.643f1ea4@kernel.org>
In-Reply-To: <20260603103924.643f1ea4@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 3 Jun 2026 14:15:01 -0400
X-Gm-Features: AVHnY4Iv1uP_QmOrLNz1hlCQg2FIUIb0L_vtpgS-GxknImKiY2MQj6lnEeZbzQ4
Message-ID: <CADvbK_eSh_b7kVRkkgXoRwygCVoxuwB=Dg3qxEbYdW5cscSfHg@mail.gmail.com>
Subject: Re: [PATCH net-next v12 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 1:39=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 3 Jun 2026 10:14:24 -0400 Xin Long wrote:
> > Will address it in v13.
> >
> > BTW, is there a public link to the Coccinelle check results?
> > I don't see them showing up on Patchwork.
>
> They are part of the CI that runs ksft because they are very slow.
> So they should show up if you click on the "contest" check in patchwork.
> (caveat - I haven't actually check if that still works :))

I can see it from "contest" now, and it's a long list.

Thanks!
