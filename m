Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F5E15A8;
	Thu, 22 Aug 2024 00:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724286104; cv=none; b=RF0kmHM/mthI3jmwcjqgteltv58HhF0BqyDZXo7memqxDaqRz9AYkhp8/aMEiMLWw2nPPq4kHQ8BaGst7+qiC6OlIGRWVyJXDx2YLV4J+qUv1hLdhScGo5PwcXbLYns4wuinN5VqLnBOoUObNPMg8ti/OAi67IWBizQuptZbrfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724286104; c=relaxed/simple;
	bh=0fdYC8epQtw7sJ6wMxiVPa6Kz0imlRjqQorsIfe1mLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m0IlU/v0BVLGELaZFuqg0I2Boo1K71YJfEVqX0keOu88PMEVWkX8BmNJuDd4VR2tJWCDB1bPrAFN3hN0dZR2Ma/69ZwP+9gid52E37+TgAXwNXoT0o+/WX8+9LNnbT4xd0fInkK+xgkZErHCvOOI0E81AnoHQ6BgRXtu+gfH42E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8Bxko9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8Bxko9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2710AC4AF15;
	Thu, 22 Aug 2024 00:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724286104;
	bh=0fdYC8epQtw7sJ6wMxiVPa6Kz0imlRjqQorsIfe1mLo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=P8Bxko9bzOCqmb/gBOW+dDFXQyG5mHAodXC4PAcxD1VFcSNiB/Ln5kEfaF7Vi445k
	 atSK9X+GuA+euyEoTgl+Fw/7h1PrBDu5OARFZ44CDi8hgUrO6Smusto3brzIAnhDDm
	 ZglMHJSS/VxaWHLDugjZH2qbq8XczL4v0Uero5EbnHzTMD3QDctjXyv6zipyTzknGA
	 2n/s1o7lBX7a07I4yN06Dh2/htwLqg4NT7nSpmKnJs5P3Jof9IGHVBbNsXaubNGXLB
	 H/0lJhSncvXGzLsegZDb3VMt0tZpnCsGeNCLge4l8sLuCpxZ7kY4jeP1eUwnxZwppl
	 rAuYbn3dF8sDA==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2703967b10cso153487fac.0;
        Wed, 21 Aug 2024 17:21:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWE/RzWLyL1dlZRDE7GnRQml8cRZ1JqLA4cyRXFcQsrYSA+Er4iGkE/ixTumhm1Eav6GDPS07LfwThQ@vger.kernel.org, AJvYcCWeWgkG110v/TRqDEu2QGGV2tApeccnddicXsKjkY0thjaaArj50TNqOIBUMCQE4MLh93cosTn/Su6pMD/g@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6ZIZRGJf9FkKu1LL4+8yyU+YJYbqqEkgwhu+L6mgZ8d5WZl5W
	z6l9VDQnRBQC6gD4K8wN/tnX92oWcIbOuhsO0V7ar4MeRXsmG3Ddd8/6D/baeSXqMir0bxRTHkf
	M2iCcZkb72pTEccUd/eOzBi4NFFs=
X-Google-Smtp-Source: AGHT+IFtjFHw5PTQqXRyVAp0mv9pNe/HA26lF7u2iDD7OOXbTvmC5g/xKX1F3ClYr4B1dz26Ht+paoe8zS9APHMk/Pw=
X-Received: by 2002:a05:6870:c085:b0:260:f495:5492 with SMTP id
 586e51a60fabf-2738be2d9edmr4222478fac.39.1724286103466; Wed, 21 Aug 2024
 17:21:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-5-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-5-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 09:21:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_n=69i8HrUZpwYq2iXGXAv0fnOTH5J_mvSFm=icXeWrw@mail.gmail.com>
Message-ID: <CAKYAXd_n=69i8HrUZpwYq2iXGXAv0fnOTH5J_mvSFm=icXeWrw@mail.gmail.com>
Subject: Re: [PATCH 4/8] smb/client: fix typo: GlobalMid_Sem -> GlobalMid_Lock
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 11:35=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wr=
ote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> The comments have typos, fix that to not confuse readers.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Looks ok.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks.
