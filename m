Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE5146A96
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 11:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720179607; cv=none; b=Q/1bqPWkZAIxrldByiPS3TwwdcuaTeaCbcOfVN4Lql1zxufUZaWv0n6gOtS7xSB7aR9LxJuOJm4NJZmHGvMKE61lG/2oNpAHuNJsK75CVDOTee788vKB66eiNMjNtUu94UDZKGvc3q8I80/Wr9oPVfwWvbtH4G//2oI5Jv1Nh6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720179607; c=relaxed/simple;
	bh=akyj+XXcDymi+EsHrlewWdHBIkMWtc9ROffqZFxNaAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i92Cd1o8zKK2y1LOjJ71g002Sw59qIm53NRRnV9sAKENslk3FQ5CE3E1dzY3tBZ8pf7MRmusH+Wc/dvwRPp1iySZFRZZqtZym7SH2z+ONVB/krrgVIx201ti8Rc75KJ1Zi7bBVpLQPHE4lnJT81xsNkXzQtF2N/oOh21PqgbElA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJ4Cbo20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJ4Cbo20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4208C4AF0B
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720179606;
	bh=akyj+XXcDymi+EsHrlewWdHBIkMWtc9ROffqZFxNaAI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NJ4Cbo20RI5dz8cmF5I0ApQobGWSRfe+gFpMnFIODmZuA7qOYLd7R4pycvkcixHdF
	 Hqnu7xB6SOUgh7X4evEL+xmlA83m81DE/anNL4A3Y6bGNQ6j7fHYcZtR12Nj1JfF86
	 ptfTNZEfulBjwPh25UOIS0a4WQK1k1qro8hW0L8xkOllxPMZQHk+UpY6WDX097N7pL
	 guT8OUcoowjKcOJYbQGwaueGfdJ8QnBTWeUtWTRqQdvpWSjPgY0Ccd73n2ZkY9c27F
	 OpjmG8CchlDdcI/MXzdYH6ZNRDq1qayz5tb0qOvrWzWJJwviXx+WRUxm0uZrST/yjU
	 ib1dNdK82Wvwg==
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5c46c8b0defso776106eaf.1
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2024 04:40:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YzNlAO0wpamsdIefRkWlhW/YIwsm58o3y9cA34nCWIzKD8oAH/h
	QHjg83TCFcbPGv95nxx/uOga4T1m+x56bDKUUhTiPUQbLuzrl116pWSumsKExirCt5XQJc3cdie
	1qO2vV1pLjObDQNREb3HZKl7I2Bg=
X-Google-Smtp-Source: AGHT+IF9k+a8JCsveRlf5HAFfWTWVR8tPLJy2hx/0ateqwna0sNAlYzvBmHtVVrO6eObJiO1Twy4kqx7QzKuWrh/yn4=
X-Received: by 2002:a4a:5105:0:b0:5c4:27f0:ae with SMTP id 006d021491bc7-5c646e55406mr4825855eaf.1.1720179606172;
 Fri, 05 Jul 2024 04:40:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
 <20240705032725.39761-1-hobin.woo@samsung.com>
In-Reply-To: <20240705032725.39761-1-hobin.woo@samsung.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 5 Jul 2024 20:39:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8=im=ONNCMQB=AQa9VzVGzfq1Qc5Zjn8ks_342JS60bw@mail.gmail.com>
Message-ID: <CAKYAXd8=im=ONNCMQB=AQa9VzVGzfq1Qc5Zjn8ks_342JS60bw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmb: discard write access to the directory open
To: Hobin Woo <hobin.woo@samsung.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, sj1557.seo@samsung.com, yoonho.shin@samsung.com, 
	kiras.lee@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 7=EC=9B=94 5=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:27, H=
obin Woo <hobin.woo@samsung.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> may_open() does not allow a directory to be opened with the write access.
> However, some writing flags set by client result in adding write access
> on server, making ksmbd incompatible with FUSE file system. Simply, let's
> discard the write access when opening a directory.
>
> list_add corruption. next is NULL.
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:26!
> pc : __list_add_valid+0x88/0xbc
> lr : __list_add_valid+0x88/0xbc
> Call trace:
> __list_add_valid+0x88/0xbc
> fuse_finish_open+0x11c/0x170
> fuse_open_common+0x284/0x5e8
> fuse_dir_open+0x14/0x24
> do_dentry_open+0x2a4/0x4e0
> dentry_open+0x50/0x80
> smb2_open+0xbe4/0x15a4
> handle_ksmbd_work+0x478/0x5ec
> process_one_work+0x1b4/0x448
> worker_thread+0x25c/0x430
> kthread+0x104/0x1d4
> ret_from_fork+0x10/0x20
>
> Signed-off-by: Yoonho Shin <yoonho.shin@samsung.com>
> Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
> ---
> v2:
>  - Describe 'is_dir' in function parameters of 'smb2_create_open_flags'
Applied it to #ksmbd-for-next-next.
Thanks for your patch!
