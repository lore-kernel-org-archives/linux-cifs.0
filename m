Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74290343889
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 23:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233923; cv=none; b=C6PM+6QxQ7BA9K+JeNna0uSnOen8Cn37HWTQ7sdRu0T4V5A/dPcENcZeH/WiOnVHfUS5wTkY5PBgR+m1vwQ5Z0f2MkjQ8axW2cMZEp1Xm9QQGcdQQm7eS1NCFegBFFctc+bE07t4reSiz9G7I7IuoA+sevX91QGmmXdj4Ry+kN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233923; c=relaxed/simple;
	bh=RLUI9FUvG/gce0UhDYK3r0V6hZ2D8pJVkZ1bk826PoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u5WiB5oqz76RKth6tBOMIz4hQkjuUBlstMki94ICIQCVxuErvuUecaMssQNtKOLLHiEr26SGCVyY6qZY5xS4Fp1xhogrvrC4UyAg3sM9kbbPtADhH8F7h4uKul1AjVSmlHcHqXnEY5DDUhORd7mQRGHU594vbiujCgLzPW/rtm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BfxkeYhK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BfxkeYhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1A21F0089C
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 23:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779233922;
	bh=ojMr8hTKofmEpSd4gQ9hL9ycn2IJSB62y8Cqa85pNdo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BfxkeYhKxbgREA6FQqHURCxWcT2y7onRxkov+qxQXcgVEkz7g782bJA+kgpa7NfU4
	 FvCnsJy35ewIMTZxqMp6gn7GtLeyXMrkqYvE51ZaIRH3mFaIS65LNQtAjUIkx+biaU
	 PuhPxV5VzXW4Cf18a+sJDpeFUdj5Z4aQ1YogIb+Es+QLdskB54k6VsW6K/ieLhACUB
	 OIeW2R/eiC4qK5auNs7PB0m62U9LEln8vmjbKCg7xyu47+YuiyQLbHnn/dO2tt3v3S
	 ewBBxppCIwDF9wK5FSXUXcXEoIxS+nkYfVKfQhixxFxHno5Rh8QcKvXzkzK2PuVRiA
	 3N/JiQJsOtVgQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67e9b3037dcso8663677a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 16:38:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9GI/D04KED5PMvYtRTFNCW1Mt2Rrk8k+YFXvhrcY17YvO2BUR5XSBddtrcdAZJFg3/4vFgzjIkZmQm@vger.kernel.org
X-Gm-Message-State: AOJu0YyFCiFTB8awIoocns6ABRIzBDNQqbZw32q/Rq2yyVu/anr8IZY9
	elJUY0ENq1eWUIBnf2hXTf34X9BSPHUbjC+omwXLcyJJw+VJwqCGx2cnALR7GsRSv4t8l3tt5ao
	RCdNvN2Fb5GRtsgYB8RwBBGZ1dp0PHQ0=
X-Received: by 2002:a05:6402:454e:b0:66a:8002:fe17 with SMTP id
 4fb4d7f45d1cf-683bd0946bcmr8860833a12.13.1779233920712; Tue, 19 May 2026
 16:38:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260518152322.265844-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260518152322.265844-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 20 May 2026 08:38:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9oJw3-SJ5JF2=JBd2+RBW_8C7wayVn7=NyiBefrhULjg@mail.gmail.com>
X-Gm-Features: AVHnY4KmLwLWsTT9ol5zixZVIbtN1ZEtjYUaN6IJq9ixtD6PDTZrcD20OZf84Pg
Message-ID: <CAKYAXd9oJw3-SJ5JF2=JBd2+RBW_8C7wayVn7=NyiBefrhULjg@mail.gmail.com>
Subject: Re: [PATCH] smb/server: promote S_DEL_ON_CLS to S_DEL_PENDING when close
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, Huiwen He <hehuiwen@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 12:24=E2=80=AFAM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. server: systemctl start ksmbd
>   2. client: mount -t cifs //${server_ip}/export /mnt
>   3. client: C program: openat(AT_FDCWD, "/mnt", O_RDWR | O_TMPFILE, 0600=
)
>
> Do not treat `FILE_DELETE_ON_CLOSE_LE` as delete pending while files
> remain open.
>
> This patch fixes xfstests generic/004.
>
> Link: https://chenxiaosong.com/en/smb-xfstests-generic-004.html
> Co-developed-by: Huiwen He <hehuiwen@kylinos.cn>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
