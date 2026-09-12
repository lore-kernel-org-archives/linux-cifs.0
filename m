Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714D52C032E
	for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 01:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789175685; cv=none; b=Hiair1sLtOga15qgoRs30dscxXf8iLwOULHRCfqke+Ou/bxTqouAykQKilNnZV6WKXQjLrl7ZDP3q7BCb4Lw1v2M2NUUENrtYFW/DIM8FxZYr9nmPkiJyvvG6MoTA3bNY2mqjQqQee2QIiQGg0ljdUbpERqGLe62D1kA86dAgtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789175685; c=relaxed/simple;
	bh=d3D3a7/73jdFJEMa1Ir1py9KmvVaxw9gG9/znoYEZn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2KG0UP0RdIxbkxORMXIcLRwp7Ylufnk9V/IAJORii3ICuC7qd6l32JvweG/Ssglc4SH//+Ie0+XRahrauBAKBzgun6gJ9T2zNDimX9mkZBKnjYq2oFVOtvpxm6VKzIxQgADQHpGPIk7BkGYQAP/xlIDQglPxw7anitZaewGmXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtWAEfBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtWAEfBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE541F00898
	for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 01:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789175684;
	bh=v73DhW4aS5+p4CEDwTW5FmMhbU7a5oBaZz8Gi/7erXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dtWAEfBvHVJVNibNKpIIafZ7kdUPwsYeeNVQBHpPFyiiAv/5RjJ/FRpJ1B0tx3f/y
	 afkYKP6WgYkkyBdwvoG8diIKDT5yZ+VYrDlnhTArr4qkJ56je3lZHp33Ht2LY+JBxc
	 dcteUmC9RT0ip2MrDoYaat0VNhJqzT+HlUcHYlIG23rChqiOguJyqX+l6fG3VGIXpV
	 UiVLWzpq0eKAIhggTMhnJOOiAl2gnKM0em2X0HKvqHk3x4DSlhEpF9eMNq+GlQwj6E
	 p77N4umfFTJ88BIEmey0UFquUHmcnfA8u0v3CjUZBnc2LaWyBkyXfXWPNAQsqfbejZ
	 lCuzfUzlLdhtw==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a60591bb18so335924a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 18:14:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzM/pSWuQEafpb9l6OQRX9r2nOYg09I0fvDoHjSF6oWQmcmy5dOnl3OkXjKZaodJ+ssB+x1hpH5/9uu@vger.kernel.org
X-Gm-Message-State: AFuF++nMYR4aoH0ZJiccvxs3HNBv817lATilVs07FabIMReaC0oGxD+h
	aDgp8nbNGWsQUJWu++u0nr4upjkCleZv/ZtzDQoNDA/Z/WeiMoSWY2jj6U9QmLDiCHVWR4jIaAB
	aV/jDBgBrvVu18fZo7k/4x611geeMsY0=
X-Received: by 2002:a17:907:3f20:b0:c29:58ae:8327 with SMTP id
 a640c23a62f3a-c2962c8a439mr393034766b.19.1789175682756; Fri, 11 Sep 2026
 18:14:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260912000817.763001-1-gkobakhi@asu.edu>
In-Reply-To: <20260912000817.763001-1-gkobakhi@asu.edu>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 12 Sep 2026 10:14:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd__LjM025c=ucjKMBQu15ZWbxuTsm2=a3tpNpqPMFttUw@mail.gmail.com>
X-Gm-Features: AcwNN1UbzYVPtXNFBNoU69WCU6xyiDi5V3gFppGXRCt36C6xeXBjeBCaOvAOhvM
Message-ID: <CAKYAXd__LjM025c=ucjKMBQu15ZWbxuTsm2=a3tpNpqPMFttUw@mail.gmail.com>
Subject: Re: [PATCH ksmbd-for-next] ksmbd: fix overflow in dacloffset bounds
 check in build_sec_desc()
To: Giorgi Kobakhia <gkobakhi@asu.edu>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, xmei5@asu.edu, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 9:09=E2=80=AFAM Giorgi Kobakhia <gkobakhi@asu.edu> =
wrote:
>
> When the large dacl_offset is provided, dacl_offset + sizeof(struct
> smb_acl) overflows on 32-bit builds and the check is passed,
> Which makes le16_to_cpu(ppdacl_ptr->size) read out-of-bounds. This
> only happens for dacl_offset in range [0xFFFFFFF8, 0xFFFFFFFF]. So
> the oob read is max 8 bytes preceding the allocated ppntsd.
>
>     unsigned int dacl_offset =3D le32_to_cpu(ppntsd->dacloffset);
>     int ppdacl_size, ntacl_size =3D ppntsd_size - dacl_offset;
>
>     if (!dacl_offset ||
>         (dacl_offset + sizeof(struct smb_acl) > ppntsd_size))
>             goto out;
>
> Commit beff0bc9d69b ("ksmbd: fix overflow in dacloffset bounds check")
> fixes similar checks in other functions. But leaves this one out,
> because it is only valid for 32-bit builds.
>
> Reproduced on 32-bit ARM with KASAN, by a client sending SMB2
> SET_INFO(SEC) with dacloffset=3D0xfffffff8, then QUERY_INFO(SEC) on the
> same file:
>
>  BUG: KASAN: slab-out-of-bounds in build_sec_desc (fs/smb/server/smbacl.c=
:1105)
>  Read of size 2 at addr c2a273fa by task kworker/1:1/35
>  CPU: 1 UID: 0 PID: 35 Comm: kworker/1:1 Not tainted 7.3.0-rc2+ #5
>  Workqueue: ksmbd-io handle_ksmbd_work
>  Call trace:
>   kasan_check_range from build_sec_desc (fs/smb/server/smbacl.c:1105)
>   build_sec_desc from smb2_query_info (fs/smb/server/smb2pdu.c:7676)
>   smb2_query_info from handle_ksmbd_work (fs/smb/server/server.c:160)
>   handle_ksmbd_work from process_one_work (kernel/workqueue.c:3401)
>   process_one_work from worker_thread (kernel/workqueue.c:3473)
>   worker_thread from kthread (kernel/kthread.c:436)
>
> Add overflow check.
>
> Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()"=
)
> Cc: stable@vger.kernel.org
> Assisted-by: LLM claude
> Tested-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Applied it to #ksmbd-for-next.
Thanks!
