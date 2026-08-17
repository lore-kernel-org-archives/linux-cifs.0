Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB493D412C
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786970016; cv=none; b=jEjSpseLnrMsHvLb8yfxYx9wUGhbwYarkrSBO30th8mOdDHMlJLMrr2RRLcnXxH8OE0/i/lmJHfcozKVk8MgG+B7wVE2XvjNEfMabYu3NSGIYDF29Z0sZ/zLRbyN1JOTl7B1i4YP9yR6NkKeUKfuA6vi/bYN7qNEaqSVDp5r7HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786970016; c=relaxed/simple;
	bh=PhtdsDLPADwsezdjYp2j5pw+HxKUrVUc4gKwKunIlSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nwoArUGcksXSFJkD60Po8xKahkejhkwke9JFB8KR+ZmrAcc+wv8XSNE9zhnpH5k9e2RCSo0VmC+Vq3i2hUniZtFTWmjZtKer2Cxm0ns9Mp8PL6IfXPWwiiu75wWTy/XQripKtDtxJT/SnC1vE/3q5l9nDKAreZzAJmfxzbNxytk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQ+x6+sw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQ+x6+sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CA51F00A3A
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786970014;
	bh=PhtdsDLPADwsezdjYp2j5pw+HxKUrVUc4gKwKunIlSY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KQ+x6+swbbkL2z0tAqf3pzHBm8GJ8a4FYawdPK9OOCquKP6p10Om23zMXs9IOnrGg
	 PeXhXpQscOL21xNSjy9IAGWFcTVQavsd7oOQpCOuMMyx/SFueumcmGDyfrEewCmPCJ
	 UeI4h9U1PtgBRj54qJVKziuCTZ3Ey9MEOdn2hyvYN8oZMbFDeIYkotAjt4X03nRhSq
	 yRUrEc86rcTFyBxE33sl0aGiRvWYFpAldQKYPLKkXtkcWdEWBy27f2zx4XJ0XNsBG9
	 PdTpbtWXyqG5GVkMDIVjbVnuoiOYdsU4thLlT5TYGtfCt53Pmk1OHu/Q5iLAQw/i6D
	 nj/6cUdtpyqDw==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6679d88abdcso4706355d50.2
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 05:33:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrpXFM2EtK3g0gDU3k09tpkc+xdAiDwqXWmxgp1Go6ZlmjUwSCk80XQQnm/58Kha+Eyh14pAyaphF93@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp0Juz/GLIo/YIjShgBcnOSQjyIzF7rVzHK3b/+Ob3WrxDVOev
	DewNFjtH+NSCRxKH5cus+ndHsfN02rKjDBR/Y6MGKQbPpvVyy9dE6rnFgrHnYQC5LIrcWLM75L8
	wt1la9n3+VhgMB/aA5q0ZNlrjueeRzKw=
X-Received: by 2002:a05:690e:408a:b0:667:770c:f88e with SMTP id
 956f58d0204a3-66c72d6ab0dmr9413895d50.45.1786970014189; Mon, 17 Aug 2026
 05:33:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260814135144.302443-1-tanze@kylinos.cn> <20260814135144.302443-2-tanze@kylinos.cn>
In-Reply-To: <20260814135144.302443-2-tanze@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 17 Aug 2026 21:33:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9xyjfB8SQf_ar0Zd9jEMW-jymGd3xmCj2zHdwGYCGjCQ@mail.gmail.com>
X-Gm-Features: AcwNN1VU1albs0FT_ezlMfElm8HzB0n8-MOEkWvm2SLL8f_tmtfoSobFJdwAi54
Message-ID: <CAKYAXd9xyjfB8SQf_ar0Zd9jEMW-jymGd3xmCj2zHdwGYCGjCQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] smb/server: warn if ksmbd_proc_create() fails
To: Ze Tan <tanze@kylinos.cn>
Cc: smfrench@gmail.com, tom@talpey.com, senozhatsky@chromium.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 10:52=E2=80=AFPM Ze Tan <tanze@kylinos.cn> wrote:
>
> Print a warning if the sessions procfs entry cannot be created.
>
> Signed-off-by: Ze Tan <tanze@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied 4 patches to #ksmbd-for-next.
Thanks!
