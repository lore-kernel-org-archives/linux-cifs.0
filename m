Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAAF4229C3
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 13:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690098; cv=none; b=nZ3Y7DWnVeox/2/1uDBnc4wizN+r/LxhSiQblDmQWT4/5ve9aMtbLCv7RH99VfRx3XFMXGz/BdsAz48Aw555ALRrNYAGCCaeRwiLokT1e6Djz+KkWML0gziKz5u9Qhrh+x/BohYYvxrlTBzErywVMnY/8vtFLHD2FK3V4LnvM04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690098; c=relaxed/simple;
	bh=JdAKTYcUzColWk5DegpqpME52ckDiXbCHPCysNDVjE4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Nwww6q3JdUfkH+sZc6K2r1PsTl4f+d92mABYtFgfI90a5dQPOd7MAps0oplUFgWz0Z497L5Df+sS6TI8OUEKwrwn3ZQGZ2V85i3HszLZkHdxIBXSrUyykP8xY0kQQyALW2gFX3fJHlBGiHi1dN5M3RbVVCMveqtaPC1kuyhkzWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KO0yJ6OI; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KO0yJ6OI"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-698bf7a1a2dso1272849a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 06:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783690095; x=1784294895; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JdAKTYcUzColWk5DegpqpME52ckDiXbCHPCysNDVjE4=;
        b=KO0yJ6OIukQYZnRsY5vPTJ/du/tQQsCM9LWBiAC1Wr9Y2lmJcAePiEliegvt/t6J3Q
         TnXLjN8ym70pO4SZnD4zakInCXUMzTdbt8Zv864vJ8l5YjxmfzKKdy7XUMqRZJmU66Qe
         lLiIu+hY/igTEnGUT9g4SJA2QnAlE9AxlTRaCyhlPz/wmIB0Cig5nihSuuqpeE9jPolB
         TOVgllmQiQ/4ipWk4xJ1YLaTS7406QfNoRASn+1ys+id+YjFCB4P8a+vSZcBfy840Pbo
         rO3ssK2tOfF6omR5B1sIazXLrV+3eLL7llQgLD59eRSzp2+HHcTq6kbQeogkwNO6kFZ+
         3cEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783690095; x=1784294895;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JdAKTYcUzColWk5DegpqpME52ckDiXbCHPCysNDVjE4=;
        b=Q57yHbG2EFq9sBoBOFYLYmQz6eqJh8+kS8jJU8j6ktxJhNCKV3fuGTpXzXphDDQoXQ
         fGZfLo4kDWJY9+cvn0Doh+tsI3gkcVUKTk8PxEruN8LSvzWiPvP6qV3i26PNnsHglYAI
         Ws/iu67JwuiID48KSNQPxkBZpKrjenEg3xJD73F0Fgr1+e7jvOTNlND+/dGxa03f5p4W
         UYdldW+P2nIGKlTX9o7boAOcu5FEcSod5nKaWlqLSxoFfnqQ9F3cpzQttelIvOceb5nd
         qaSlT0y0nFFygsaoi41wNF5f/6Tjez4t9y3sR0vlH/21SE1Rn9hK0IudAoTTPcKxEW+q
         Doyg==
X-Forwarded-Encrypted: i=1; AHgh+Rq8Y1rGdccBKsNzboDOynAas6tWmFAp/ul3AUe9mH7yygxDJ9ADJ7tWTeVpbLS93vH3+CIpQetX1bDX@vger.kernel.org
X-Gm-Message-State: AOJu0YxYnbY7yD64Ki8oam2ETJi1bTyGLHh4mH+eQw5I+oBpJobHzs/s
	os+NuRGsovDuDgeiL1NVCuitWUR4Jpl9TMv0rhH4KHMGBR34UyEsTTKcXNEGcA==
X-Gm-Gg: AfdE7ckcNg9tp/U7QLJZ+EHCvXxWrhOJi7atQ0GJZia9Nk8vJ7K8YbeSLTqBcpioOT8
	IJ0lxgl4pcwxDurZ0e2/VHHjcrx72w+/fmTOgZv7lTMZSyz7wi7i/vYZES2/vXzNcZyXdk1o8dT
	qLA1GmgsqpzchTtUzAFSqpmqvV6PjYq7ZDoGjHm3zVMENUVfjzZwxGSm0ndTSVcAE6/sWVOukFT
	yL6QiysUf0hhQiqw1zUAT7SbgQBIoU5wlrSPLifXbx/7ihTUp6CY15dkhZYKnWO18hPRgzvUHzA
	TVvLLeHDHrkUPKp3HRKBCsyLg3Wa2J16get3/vmWYcPXKV8rpF8tTm/KehsIzHuCju7ury3M5dy
	F2h873/VQqk5jGNoiiQ4PMwt5taCilQQ52C1F6YgM+suaufg8PcgtbL8RcxoGVa6W16BOzMMPI3
	SeOMIqw/6epIwob1GFAj5hxgCm2UuWpCEB8A==
X-Received: by 2002:a05:6402:378b:b0:695:822c:1083 with SMTP id 4fb4d7f45d1cf-69ab44ae37bmr4863899a12.28.1783690094648;
        Fri, 10 Jul 2026 06:28:14 -0700 (PDT)
Received: from smtpclient.apple ([82.67.171.69])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19d786e7sm11734652a12.16.2026.07.10.06.28.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Jul 2026 06:28:14 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of
 STATUS_NOT_IMPLEMENTED
From: =?utf-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>
In-Reply-To: <58326ff4-02d7-4db5-8352-dc53a0ef1d09@chenxiaosong.com>
Date: Fri, 10 Jul 2026 15:28:03 +0200
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EEEAF8FF-E421-49D2-B778-06C405B1AF2C@gmail.com>
References: <20260709000618.66534-1-g.blivet@me.com>
 <20260709000618.66534-5-g.blivet@me.com>
 <cb3e2376-88ae-4020-9417-ff925cadd8c0@chenxiaosong.com>
 <36FFCEFB-8E41-4EB6-B835-0B440C9F4A52@gmail.com>
 <882a42e8-bf41-4f7c-a30f-e9d2fe44c49d@chenxiaosong.com>
 <c9a3fe37-c999-4d0d-8ee8-a34157c8a09e@chenxiaosong.com>
 <12AF7BDE-BF1C-40FA-81CD-93DD3AB666AC@gmail.com>
 <58326ff4-02d7-4db5-8352-dc53a0ef1d09@chenxiaosong.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

We can keep that in mind and see in practice how it performs (for =
example with Time Machine, that can open long-running watches).

> Le 10 juil. 2026 =C3=A0 11:15, ChenXiaoSong =
<chenxiaosong@chenxiaosong.com> a =C3=A9crit :
>=20
> Yes, before the cancel response or event notification response is =
sent, the notify request has not completed yet, so the worker will =
remain waiting.
>=20
> If you find that this approach causes any issues, we can refactor it =
and use a better solution.

