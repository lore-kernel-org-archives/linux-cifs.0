Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8E417A584;
	Thu, 22 Aug 2024 11:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327344; cv=none; b=jSodZPYGUlXmtMzh5iSKIY6Y8KjndYNa5ImGn4P2tKf+fTOM57vJDNO6G9TbbzRkqXvq8zGEVisEqZEENClZQ6UW7NAIslzAtkuXorpDAw7zbaW0rH1c1PxzbSMM3coQp3ecKoSOiHmJYvQDlaFY+dPxBy/uv1lNAxSsmMzCdEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327344; c=relaxed/simple;
	bh=TjVpZFtF4o9A6699x4gEKx/H+ag92cqsOEMzu99Q/R8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JgsQK1A4nvoyJE4w+NHr6AYDZLNMbulNk+UtH/q1HhGjbzj63R1MHdzEJU6Xb0ue+h1DmNIyLWeV14IEycM2Abvceq+MTzGExwDEO0uyTiGiQcrfKUuwydvo3QCdTybKdW/mjqj89AXnE0+lst1WZSg3ZqaWBxwPhPdsZmJrBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJxhandw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJxhandw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF19C4AF14;
	Thu, 22 Aug 2024 11:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327343;
	bh=TjVpZFtF4o9A6699x4gEKx/H+ag92cqsOEMzu99Q/R8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KJxhandw23zfHwQh2a+6N7i/5WlBdGi/kpj49vrBnXbjsi6jxVdvKeBKTRfpdLbUp
	 JpmYdMCgD21277bnEWZG0/+lF00bGw0Puz7dWeOnDmjuEPuF7TwceunPVtwg+M0eyD
	 khrDsJGlRCoDCcALmFRNiEAnLXkFkaNsKST0Wi6l6PWe1NiBhFn5QiNnjP44G23CM6
	 qmuCqT/LA5VzlgaPe+0TnSqEX45QqQ9TdCoyeqaF7bZJGhqDQQNOfe3ngWePgnKovb
	 OUvyu2YojVEmTur7DBEs1Y7in9ap1SBaQKZ2CxAj8lQZyRGZPu2DbgNHfyYnAYjPNa
	 vQTg5/u746lYQ==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f3ffc7841dso6414711fa.0;
        Thu, 22 Aug 2024 04:49:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVbVBlhYem8ePb19TMsWtJgXR9c11IMpi1cYGLhbt307YHb+idRmTreiD8MrMUlL7NUELL1/C6Tytozs4CB@vger.kernel.org, AJvYcCWBKpPEEYponbzBZkyCdmMazBlpvf5FXc71NpgrO7flb5Cc6SHDBxwdtosdw6l+2Yqin7IuoO3V8HOc@vger.kernel.org
X-Gm-Message-State: AOJu0YyUJ/qrIhGbrHOFgtJsUJhPyc2nR9OuiaJFm4aoC4lZCe2lfkey
	yHkP8eQxQc0Wm4C66jQ/eFc6hazyNSrlgp3iBtAHV3Iv8IiFVEST735dQGit33WAROG3AZBu6Mv
	NoR2294jXoogg76i4EGvf18DgOfw=
X-Google-Smtp-Source: AGHT+IHZTQrh2EhVHGqy2EsoHabkA9xWKcFI6tHOJgEwo6Bim8ClWMUDrfLKNI9hcs0RwklJAj02ktrvRwtePRCP5pc=
X-Received: by 2002:a2e:be9e:0:b0:2ef:2016:262e with SMTP id
 38308e7fff4ca-2f3f8721e0fmr47100151fa.0.1724327341684; Thu, 22 Aug 2024
 04:49:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-3-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:48:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_e3kpanj2-B-KneDbk_qPcy6Pte_kKHVeMx2-h-k+XhA@mail.gmail.com>
Message-ID: <CAKYAXd_e3kpanj2-B-KneDbk_qPcy6Pte_kKHVeMx2-h-k+XhA@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] smb/server: fix potential null-ptr-deref of
 lease_ctx_info in smb2_open()
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 5:22=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> null-ptr-deref will occur when (req_op_level =3D=3D SMB2_OPLOCK_LEVEL_LEA=
SE)
> and parse_lease_state() return NULL.
>
> Fix this by check if 'lease_ctx_info' is NULL.
>
> Additionally, remove the redundant parentheses in
> parse_durable_handle_context().
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks.
