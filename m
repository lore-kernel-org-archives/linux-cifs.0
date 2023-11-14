Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8957C2E85B
	for <linux-cifs@vger.kernel.org>; Tue, 14 Nov 2023 21:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lC3QfUlw"
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90DCDD
	for <linux-cifs@vger.kernel.org>; Tue, 14 Nov 2023 13:59:42 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-991c786369cso924934866b.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Nov 2023 13:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699999181; x=1700603981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5IN65OiKl7djXGKlyHbw87C004q1nn4BxHI5gt7Ui0=;
        b=lC3QfUlwm0F4YeDSOk8mthhY/Q3mEv8zjHlBfUvWJ23ZiFw6j7pQR0FL+0W71AIfKw
         c6wcYvze09wusP8ybX8D8fmx5RjKi43EklyyiK/KoPV5l7zeO9052gcdNqO393QPjcmu
         AC5867v/JRtymfMo7v+QaR6mEFTPIOcNCwP+SwE0Aqx1+qg67u0bdZdC1oTato1iOyDz
         QAWP5+f1wS1a6TFb5WK7kX04HBe76KgAKnIwVCf4e2BmFr1FxICsi7MhRSrdEFekpqz/
         LahTCbKScjT9pKwIwS7EG8+Ka0VYHSlt4/bQ7wO/BYbYUMCkrnEzvsKgRS8Rfe9mg80r
         yi8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699999181; x=1700603981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f5IN65OiKl7djXGKlyHbw87C004q1nn4BxHI5gt7Ui0=;
        b=jp2Yo2ZOTzDSkVi8X6DAK634IF3g0oY8U+ZpLR/JQanBIclYVwcHGvg7EfIWPi2SrW
         ZYsegZ6WpLYAstdTAAawL912aCICuMPKaSQSDwn+ORqPufyc34iY58u29+S94bpJ2dmV
         tHy1csds+hPUWWYdOGYEjye+XPMeGtJKi7/eSX8y3EzWaXgy8rS4jj6uXIiDJNl0V43D
         q0FeOOocPgvkO9q+UnuRIzT0rWewgYLNaYg11jhrUbIJjYIePM8vLJfBx/eaCD+EXuEU
         pPETkW0w+/mwl3tGckUksPBF/AkcFC+NgA2jgNQRV86iQl+ywwj2do8izzMYzinFadiq
         Qgaw==
X-Gm-Message-State: AOJu0YzwCMCRZ08Pf2XxoaYKDL8+RCutofxWvv6Mkcac6NnMR1f90N4R
	hj0wylDLMbS/Uj2X7gzoVuRMBIx5fI82XkHGNOTf6P4p
X-Google-Smtp-Source: AGHT+IGuCc7FyH9n20YUsVBJO9dTDdGPNATKinttL7ZwbunA2QAaNbleoJ9+IBiTmgdEOVblKlCB0Yg6aNC7lZWHn/c=
X-Received: by 2002:a17:906:c9c7:b0:9e6:b485:cb06 with SMTP id
 hk7-20020a170906c9c700b009e6b485cb06mr7690965ejb.16.1699999181016; Tue, 14
 Nov 2023 13:59:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADCRUiNvZuiUZ0VGZZO9HRyPyw6x92kiA7o7Q4tsX5FkZqUkKg@mail.gmail.com>
 <d2c0c53db617b6d2f9b71e734b165b4b.pc@manguebit.com> <CADCRUiNSk7b7jVQrYoD153UmaBdFzpcA1q3DvfwJcNC6Q=gy0w@mail.gmail.com>
 <482ee449a063acf441b943346b85e2d0.pc@manguebit.com>
In-Reply-To: <482ee449a063acf441b943346b85e2d0.pc@manguebit.com>
From: Eduard Bachmakov <e.bachmakov@gmail.com>
Date: Tue, 14 Nov 2023 22:59:11 +0100
Message-ID: <CADCRUiN=tz85t5T00H1RbmwSj_35j9vbe92TaKUrESUyNSK9QA@mail.gmail.com>
Subject: Re: Unexpected additional umh-based DNS lookup in 6.6.0
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed this got pulled into 6.7. Given this is a user-facing
regression, can this be proposed for the next 6.6 point release?
Sorry, if this is already the case and I missed it.

On Thu, Nov 9, 2023 at 6:29=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> Eduard Bachmakov <e.bachmakov@gmail.com> writes:
>
> > I don't see is_dfs_mount() being called so in my scenario we're simply
> > relying on kzalloc initializing dfs_automount to false.
>
> It's expected.  If your share is DFS and client finds a DFS link or
> reparse mount point, the dentry set for automount will get mounted with
> new fs context where where @dfs_automount will be set.

I see, thanks.
