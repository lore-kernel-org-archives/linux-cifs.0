Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65901865F6;
	Sun, 27 Oct 2024 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730072008; cv=none; b=eEZ0xELCfpn9oYr17V+fxuGMGmCFMwmKbhFusZxUNSlwZS9fW2nbjhD2SkEBeWlC/zfo6UfV9Tmj9tufyy02Rn61SDmT7C1jC5soBWQBbopzKJv/1YcU7GJGGGcmcDmJeQSiCUJ6WQdqExvxTtFSSf4aR4ITjhbkMj8qhLvsonY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730072008; c=relaxed/simple;
	bh=beKxMlT5b66BGo5NTosJeYD+LSXSmOMabs8Am/ym11I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VB+hP4VsKLwCUhMJMaZ2o1/W9OnlT014Y27v5cHzlWhqWPtCdBxeneOa7g/xwtQdXRZJzBEmTQjYYRFzdJ+H7X439fnSnj4COOjhLLfnoOF8zsDMyvx1mp6CV59NSIqdAFCbLHCr0c7mzEIKFS3tT68a217bKv3zF9+uzeCbAMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGyFhEIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGyFhEIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7B8C4CEE5;
	Sun, 27 Oct 2024 23:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730072007;
	bh=beKxMlT5b66BGo5NTosJeYD+LSXSmOMabs8Am/ym11I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LGyFhEIVQA9m9x0QViPi/qZubVOdZhHb71v7jDqY0rybkTcuMbAeAATQE8d1MO0yG
	 +i5vYtdLQ7QxV2+F2BmYtAmRm9agxrdV2k3/BbIpL0F51xHLTGQQlJhrmwMyVUflso
	 vQQzQbBO7xDY1ipBlhb7ql0sXrZvxd2+4NMg0RdTFLqhbymLdSQB6tF3KJWqPy2bFx
	 4Fgh2DY2QdbnFsj/0nRfiI4iPDjnSxsI9YDkwBM/L+yeCqG6mfiIWHy0o+JfHj+ZuK
	 IVNe/5zNloUJK0mK5eENtx8GCiOHK5djp2I0ERIphdqS+3qNVlSw84T9kHGPmjEWDp
	 a0uNEaAc1niLA==
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2884a6b897cso1905720fac.3;
        Sun, 27 Oct 2024 16:33:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVTel4/w0LxVUbZ75K/FxWLsefLJ90ilpu41eqP3ru8NSTx2zQTzY6FhTSMrj/78Zg4wgngeAp5VSFY4x4J@vger.kernel.org, AJvYcCXgZjr2WXgVXMR4UzsUyDj7xTt7rvoeBazVr4sbfzOYoacaCaP5xkGGBM4fjh/3fo8E4C2wpAM5++s5@vger.kernel.org
X-Gm-Message-State: AOJu0YxQuUoD9dHZQMK5YERGkmpiRhaL5xSKTeTlyeZUpRWkLtx8xMw3
	i1ect3YpA+Oq7TfmgiumCT3FnjRgt+lm7gmPhu4Rlby3SEav/hpDy+Q7E+miWma2g0tTH15rmFa
	2RThQ4wEgMtbQpyVy/5rR77sgoJs=
X-Google-Smtp-Source: AGHT+IEgFLkXtmx1f1u2oOtwtHGuyeH7nU8FZQrfUAeDT3tRajH+Npn5/YmKew//beG04HCrDPZW/qGiRyUSkqT+73s=
X-Received: by 2002:a05:6870:568b:b0:277:ecd2:7b7 with SMTP id
 586e51a60fabf-29051af11a9mr4083851fac.7.1730072006843; Sun, 27 Oct 2024
 16:33:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241026071002.118260-1-ruanjinjie@huawei.com>
In-Reply-To: <20241026071002.118260-1-ruanjinjie@huawei.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 28 Oct 2024 08:33:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-wvsibuLMw+nkLX6vD+u_yYsnv+YE3ikMFGXBquU5t-w@mail.gmail.com>
Message-ID: <CAKYAXd-wvsibuLMw+nkLX6vD+u_yYsnv+YE3ikMFGXBquU5t-w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Fix the missing xa_store error check
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	set_pte_at@outlook.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 26, 2024 at 4:10=E2=80=AFPM Jinjie Ruan <ruanjinjie@huawei.com>=
 wrote:
>
> xa_store() can fail, it return xa_err(-EINVAL) if the entry cannot
> be stored in an XArray, or xa_err(-ENOMEM) if memory allocation failed,
> so check error for xa_store() to fix it.
>
> Cc: stable@vger.kernel.org
> Fixes: b685757c7b08 ("ksmbd: Implements sess->rpc_handle_list as xarray")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Applied it to #ksmbd-for-next-next.
Thanks!
