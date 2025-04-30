Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199741E1C09;
	Wed, 30 Apr 2025 05:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745991803; cv=none; b=TbguiqMITTODzRb9mcZ6efRg9jt1buPr+jeaV3W9Nfw74a4eumUJLgIsJtmfg/fT0eqNfXkJyeg6tIoGf1BXb+7gzOtl0eFrnL8amYW6OHMlzZ0Z6NWOI1H0yqPXfUlH6/MwT+BWR7NuOGeu/iXnFn6oXDwe41g6I96zE03DmI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745991803; c=relaxed/simple;
	bh=bpXDU+gweh9z6xj+SXIhRaMgkoTWhzq35HoewDDC3nU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hKtTW1PoxczUxbeVktx2qMOrWw86JbWh/8Jd+BTG6JMPyKhwLA5R9JjX7d+tI3XfnnZLA7mSy/4NyW4yAeFfnGwLR+nHdnTMKI46zA0OOFc+oB6PaKxIF3p5ImplSk2I58mCyGHZiuOxwiQCf/nTebNBV24elU/L2RrUtCqKkdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzACvTNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzACvTNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B929C4AF09;
	Wed, 30 Apr 2025 05:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745991802;
	bh=bpXDU+gweh9z6xj+SXIhRaMgkoTWhzq35HoewDDC3nU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UzACvTNuqq8mWejCtaqGllCoiNXTCuDvIw4xR1A+VPQFF165/FWcM2WOm9UVieL1G
	 MIbMW3o+dFKgDS/zR5Aza10TK7bMAOyhn+1qmwJQf7QqRkV40P8N+mOzcS0bZm6Ta2
	 TyCmUxl2uIkd/G10gH0Se+lYdLO020D6Jn54mQBTlkdXQq6xyaLDYa081chA2yrQyw
	 MbU9CxpmKcFa1st4/b65gg8rX+lR9th1L4ye9b8qgsRN35q5Zb76IzKjD6xSWrGdkq
	 Dykg2vr7GsIklb/OX1P0LkATHKsEpRT702UgwDiuyXT3e/HMPdsXX4/oiCpazhSVhe
	 GNMlA4T6V++hg==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2c76a1b574cso1950465fac.2;
        Tue, 29 Apr 2025 22:43:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVrgv0uSJPgrXN9+4TeKdxCo93qibz7OjCL/dbmdD9XaNA7KIXQsmdVGKjoGED+nqdlNYLxep36Fj9F@vger.kernel.org, AJvYcCXNGfUiE9VFMU2rHgPvx3nEEt8nm+BGaklVNTn5NAcIIEMgnkkxFg1L835bkOoELoaZX4yaezahkpkwju0Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyvudOjcSPCtV14302BfOz/gE1MBkN53ATrz8XybQJskw2Qzd85
	Vkvn9gR0+HRK6AVYwq58Om/bNUynDE3UnLSONBsrJmYR9zHTSI5MiZXmY16GLTJPTPDaeCm0/3s
	eS3C7GUVxpHOLeGZreOToiFgt3R4=
X-Google-Smtp-Source: AGHT+IFNrHoCJUNzteY1+zligzTVVkoapNf8nHRZAynxF8K7vgoMoPwGRLvHKihvSRnHE9Bau78NKYUhWwkvAu0ysrk=
X-Received: by 2002:a05:6870:200d:b0:29f:97af:a1a0 with SMTP id
 586e51a60fabf-2da6d1922c2mr607992fac.24.1745991801725; Tue, 29 Apr 2025
 22:43:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430031623.744547-1-wangzhaolong1@huawei.com>
In-Reply-To: <20250430031623.744547-1-wangzhaolong1@huawei.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 30 Apr 2025 14:43:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9q4Ax-6rwOzEooWpGJkonw1mjO_TKgMmB8Em+XR7zp_g@mail.gmail.com>
X-Gm-Features: ATxdqUE2d37O_efGdmPJffYnXVuQ9QxeCRpgbnwWHVbfQ1oVvhTmapE8oCccFSA
Message-ID: <CAKYAXd9q4Ax-6rwOzEooWpGJkonw1mjO_TKgMmB8Em+XR7zp_g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix memory leak in parse_lease_state()
To: Wang Zhaolong <wangzhaolong1@huawei.com>
Cc: smfrench@gmail.com, norbert@doyensec.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	chengzhihao1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 12:16=E2=80=AFPM Wang Zhaolong <wangzhaolong1@huawe=
i.com> wrote:
>
> The previous patch that added bounds check for create lease context
> introduced a memory leak. When the bounds check fails, the function
> returns NULL without freeing the previously allocated lease_ctx_info
> structure.
>
> This patch fixes the issue by adding kfree(lreq) before returning NULL
> in both boundary check cases.
>
> Fixes: bab703ed8472 ("ksmbd: add bounds check for create lease context")
> Signed-off-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Applied it to #ksmbd-for-next-next.
Thanks!
