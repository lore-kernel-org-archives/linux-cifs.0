Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC84A18FDDE
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786684053; cv=none; b=q65PQdioBzopgEcnIggoNSbi6iH4m79ktPhAmzvXofhZ4omhX/G5A5eqL1E3/yLBV6UAM+DQ2ez9NTr6R/w/QtKXRmdOkNN7FoT2tylizFZwoMaitbO6Y9MlhQTpa2wjYTBtHsiSzJrDsVA4a9ZCwNisUp7YsqKr7Aw3EmJ/INU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786684053; c=relaxed/simple;
	bh=sI0FwBLtcBNqf1HE3VGxcnc2OE7/rde6EQJSahEt40E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e7h7uKMBCelLmaMy2/S+Y+zp/njG4VtS7Y7Pvh8rJXr3jRc9UXkuE+2X9KVH07HMckHjqW4OUJs4fSWC2vzRouE8gge+AZXUa92Od4dcbWTJt5oJa7+A0pV/k5QjsRnb7J7rj9PJi87O13PMUC9GQ7JdK8ldFtS4Odu2O79e7is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZkwnADQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZkwnADQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669091F00A3D
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 05:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786684051;
	bh=DDXiYlAJxFGQioDtz4XpRXVxoH0e7iireZ7iWM4Ma5Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hZkwnADQDu15rYp2M3vd2BKLDC1CyIAkwiSfyEAP6udjUqzMCco/g0kFqh5Vfl+rg
	 elSi3HW1XhJmRpeH0xXryVaOC6rpK+8r0J0/aMx0b1De+XuBvTsuDgeFXOn9YfzSf9
	 4kKgZQu/PGNkaWvI+7quBOTYTqeg3dOwze8C2Jhoq7+jtJFSk5PpfsA0cEfs9iO8cc
	 gjTKBF/U0340XMV0TW1eTka8w1MOvI/gKINhi3YKC5+Z9AwNX6OeL4ak/cIs53xj01
	 VVGXBelW0JFDi0bYS3LxNeZPqnLCZdAnhPs0DSLgGpHnHBhv1M445cw9eYDSH86m5A
	 lndbJTY1uWJvw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c20ce3c118aso107101266b.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 22:07:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro7PfvMNtZZEtsqEMc5D4XyQaP90/L1ZA2JSLsmpvln9/dfQjyxS2Cx+Ix9aNZXG/IQN2w0bONzDUhZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyfLz9E8ipX8ne/q+mXjz2xnf/zVSsQmLFK1S4o2zEGbW6hj8sT
	c+iqkrXmhvR2e4/KCNMXEQJgMJ5FXMgmJBsygKb2srvlmwG5118v+k9PcYlOvQSKK/XR7ryBR/l
	hKVUoQnd3c4wx8zXIJsJg9WFyBuNjUHE=
X-Received: by 2002:a17:907:97d1:b0:c1c:4c72:e6df with SMTP id
 a640c23a62f3a-c2109c5fbbamr441294766b.0.1786684050099; Thu, 13 Aug 2026
 22:07:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813104042.170080-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260813104042.170080-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 14 Aug 2026 14:07:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_wCGpRuiigfnN+QCRntkCkMYOQf++fXiYMme2WDh0ssA@mail.gmail.com>
X-Gm-Features: AUfX_myEwyvzEWqz2vJGisg2xMrAXNwkQ4pf505teYy_XjoueUxUAJNP90g3xJY
Message-ID: <CAKYAXd_wCGpRuiigfnN+QCRntkCkMYOQf++fXiYMme2WDh0ssA@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix use-after-free in ksmbd_conn_transport_destroy()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, tom@talpey.com, senozhatsky@chromium.org, 
	obnred@gmail.com, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 7:41=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer (Link[1]):
>
>   1. Build kernel with CONFIG_KASAN=3Dy
>   2. server: systemctl start ksmbd
>   3. client: mount -t cifs //localhost/export /mnt
>   4. client: umount /mnt
>   5. server: modprobe -r ksmbd
>
> The error message is as follows:
>
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   BUG: KASAN: slab-use-after-free in proc_remove+0x3e/0x80
>   Read of size 8 at addr ffff88810654e098 by task modprobe/785
>   ...
>   Call Trace:
>    <TASK>
>    __dump_stack+0x19/0x30
>    dump_stack_lvl+0x49/0x60
>    print_address_description+0x7b/0x200
>    print_report+0x5b/0x70
>    kasan_report+0xed/0x130
>    __asan_report_load8_noabort+0x18/0x20
>    proc_remove+0x3e/0x80
>    ksmbd_conn_transport_destroy+0x2b/0x320 [ksmbd]
>    cleanup_module+0x33/0xe00 [ksmbd]
>    __se_sys_delete_module+0x276/0x400
>    __x64_sys_delete_module+0x5f/0x70
>    x64_sys_call+0x2675/0x3030
>    do_syscall_64+0xf0/0x3b0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   RIP: 0033:0x7f5b56d2b02b
>   ...
>    </TASK>
>
>   Allocated by task 159:
>    kasan_save_track+0x2f/0x70
>    kasan_save_alloc_info+0x40/0x50
>    __kasan_slab_alloc+0x52/0x70
>    kmem_cache_alloc_noprof+0x168/0x3e0
>    __proc_create+0x20b/0x710
>    proc_create_single_data+0x78/0x150
>    ksmbd_proc_create+0x24/0x30 [ksmbd]
>    ksmbd_conn_transport_init+0x4f/0x80 [ksmbd]
>    server_ctrl_handle_work+0x64/0x2c0 [ksmbd]
>    process_scheduled_works+0x788/0xec0
>    worker_thread+0x894/0xc10
>    kthread+0x2e5/0x3c0
>    ret_from_fork+0x168/0x4f0
>    ret_from_fork_asm+0x1a/0x30
>
>   Freed by task 785:
>    kasan_save_track+0x2f/0x70
>    kasan_save_free_info+0x4a/0x60
>    __kasan_slab_free+0x47/0x70
>    kmem_cache_free+0x122/0x410
>    pde_put+0xfd/0x160
>    remove_proc_subtree+0x365/0x540
>    proc_remove+0x6a/0x80
>    ksmbd_proc_cleanup+0x1f/0x60 [ksmbd]
>    cleanup_module+0x18/0xe00 [ksmbd]
>    __se_sys_delete_module+0x276/0x400
>    __x64_sys_delete_module+0x5f/0x70
>    x64_sys_call+0x2675/0x3030
>    do_syscall_64+0xf0/0x3b0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Reported-by: Kyenghwan Hwang <obnred@gmail.com>
> Link[1]: https://lore.kernel.org/linux-cifs/8ea028f5-90f4-4d21-b1ac-a343f=
0f04d88@chenxiaosong.com/
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
