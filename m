Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E2E17543
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jul 2024 02:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720060872; cv=none; b=KqQZrvDOa0tF0dGcpbE9ccid8k6m41XlsGky+MJ6ytdjory7c3nkgOFWPjKMyA38wlbC+Tw8ulkjtt5zMP6n1TRAfpyrQL2vWpbO5Ot0AqvRQ8/PHcma/aZZQ2uDNvPDFjeBmT04Ja1+vVsq8rdnu7CVsTYP2SDyJ9zLZdo2hxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720060872; c=relaxed/simple;
	bh=kzD4/Qm53k99M4bTSKf9YWzmSZz39YigZRos2LayluE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GtXyf6cVPpIvrpWkquDHrHrgFmOL4zSUl4xEjyMZOsAoUpZIte9+ltheL06xTdX89PJRWZsNw5pX8202WJs+1sxBN9kWpig2gVzhz21+H2ALDS82Wg6dInlz9y75yUMkiD27MMT3vOJ23fGXzdImOvA7htWjFhB4q3Z9hxRXOFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0cW3dMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0cW3dMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A17C3277B
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jul 2024 02:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720060871;
	bh=kzD4/Qm53k99M4bTSKf9YWzmSZz39YigZRos2LayluE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=c0cW3dMcbF1ttj4icwlGio11bd0TrvdCC5aRnkZbNcoUzxGpnmZsmCr5MYtRqSkoN
	 mX2a0l1I4Er9ckg/VK4YP5kLhCXRjPBRPsCqaSMqqV5nGzyLXLYBFl1MVMM85qdTOm
	 SAWRGBWNy36q25mGDhO0HAbDpD7pu0RPTNJoIcvv9QqsYQneocgVesPOW8RT6eeZvE
	 Cs9oS8bGmbHJGSl4T+EfZ1xM3i8kGclyCLA09t8j+6geYax0+kz2pe1GIz1SnEUbVX
	 Xp2hEhOv3WShPAQQD1/361d4vdFrteJQMklUmoIuY/viYNeReBcR2i0KIUY3Qg/fq1
	 EO5gY7CFTIAVA==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52e9fe05354so188796e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 03 Jul 2024 19:41:11 -0700 (PDT)
X-Gm-Message-State: AOJu0YyDLneDvcPxOEUyemDSSlFN0n2Fyqwie/aN8uWN1Ie6DLgrcyQb
	FqOV6chw+18NrIFrhCFWsIlBQIyDvANGA3Cpnv8Fx4iYGyD2mQKge1HWTd0fY280oYwZWq30FQy
	CDW4Fas9KKaqPReuQch3rqGXRzxw=
X-Google-Smtp-Source: AGHT+IF8NPEchIaziNE5k/8TXwTqDJeTaVVthqFoJsKDTPqGqnKSHu5wMhX9htiQXuGS4fozqkKTbxlXXnYSi4sQJpc=
X-Received: by 2002:ac2:5197:0:b0:52c:f555:8266 with SMTP id
 2adb3069b0e04-52ea0704c60mr111883e87.69.1720060870347; Wed, 03 Jul 2024
 19:41:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240704003542epcas1p15a42d38be6cebe95eaabbd828674d97a@epcas1p1.samsung.com>
 <20240704003537.4690-1-hobin.woo@samsung.com>
In-Reply-To: <20240704003537.4690-1-hobin.woo@samsung.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 4 Jul 2024 11:40:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd92a7WgO-iKy4-_gTFi-FSvZVytrSWDoWWJDiERsW=oow@mail.gmail.com>
Message-ID: <CAKYAXd92a7WgO-iKy4-_gTFi-FSvZVytrSWDoWWJDiERsW=oow@mail.gmail.com>
Subject: Re: [PATCH] ksmb: discard write access to the directory open
To: Hobin Woo <hobin.woo@samsung.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, sj1557.seo@samsung.com, yoonho.shin@samsung.com, 
	kiras.lee@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 7=EC=9B=94 4=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 9:35, Ho=
bin Woo <hobin.woo@samsung.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
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
Applied it to #ksmbd-for-next-next.
Thanks for your patch!
