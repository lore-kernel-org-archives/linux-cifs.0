Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C7E12AAE5
	for <linux-cifs@vger.kernel.org>; Thu,  9 May 2024 12:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715257910; cv=none; b=itGRgwhU5F/w2sOuhHhSaMlEYxzY8bIa4lg9uypQDZDzdmtZ++EFxZ6zz016FWuVQG6SA7s0Esap23XVeo1aN5dsJnHvereqYFZCpYdLJtNrQzMyFvwWd1CtiKgXyLD9ZJH0J/h690+Y4dTmW59ahh/3zl6Y1eL/U2VbMhr3WhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715257910; c=relaxed/simple;
	bh=7n+X5m9ElLP+f6WHRMc3AuMl88Lj7bHvLQuXMoBjSIg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gmmrQ85SDTZM2A1YUbr4QicoR+NBxpfjvpkBqSWwS114Ve9bUF5nkzaEtkQ0+BYr35534InKdvsiufeiQ7e1EtQOvQ+tnglRhP6fYUj+uUNBt3vx/BVi+Y6iAuLQaPGzXjIAAkvr0AaB7CNzLUqdqxvvvzC1TiLPFtY6PBQWUHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rwkwxUTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rwkwxUTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368E8C116B1
	for <linux-cifs@vger.kernel.org>; Thu,  9 May 2024 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715257910;
	bh=7n+X5m9ElLP+f6WHRMc3AuMl88Lj7bHvLQuXMoBjSIg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rwkwxUTjrQB5QEuZP/xC9Z3CXBzt+ZEEkbodEDx+nBYnxJreeme+92mP129/mYmrX
	 NFZCTwh/s4SLmmBRh5/sDRIMr1buWEy4kbeTwVf3RwtQNQl7c8IYsMCtnt9tTYpQOL
	 FWoSYGSEhHuxGLgdxmoVSmt1rB2IhtZkORymntA6dSyWTQ557ROLZUZi4UmE6qtIfU
	 URkVio1a7CWeSNGO6NauwrLKvln/vRpXluVZDx7jurCvEJy6NaFRi3fFz2e2qEz7Mb
	 9SzMIb0yL9RIRYW/d+yfYD/10to8HHn3nHGyYpzfjnz2DBXOOc3DGnvlDU5FnZ0Las
	 WAcxXqmLh8zyA==
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5b27bbcb5f0so74738eaf.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 May 2024 05:31:50 -0700 (PDT)
X-Gm-Message-State: AOJu0YyfSzc6UkoCygPHo/APYf5EE3rNfQ/jxtdxu0EfV48Ns/BZ+qpo
	DkZ7FWJV/yHFCVeuq5uzCZ1Y0Rb/GzuIQPBQxb35HUQm34QrT46Ow418zWmbn41CyvHwZsu+H5j
	E1kxFDKLTxIYqyUfTu72AyidE1EM=
X-Google-Smtp-Source: AGHT+IFCpuV8ZVFfwIt7WQLUlTiAzib11zulEheS7mBPShJx3iHqP2V6Q7XvUvBCJZlEWId94KtXtDjbHVCn9oQORo0=
X-Received: by 2002:a4a:ad4b:0:b0:5a4:9977:446b with SMTP id
 006d021491bc7-5b24d6aba61mr4998876eaf.6.1715257909496; Thu, 09 May 2024
 05:31:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvdQry6-Ba4bUYfDS0Wk3HxKwJ3tGMpWgyoNYPwmhjWMQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvdQry6-Ba4bUYfDS0Wk3HxKwJ3tGMpWgyoNYPwmhjWMQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 9 May 2024 21:31:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9KMU77qgw+uJfm1BEwmHnNaVL7HRWNtG-z_ZwoutLStA@mail.gmail.com>
Message-ID: <CAKYAXd9KMU77qgw+uJfm1BEwmHnNaVL7HRWNtG-z_ZwoutLStA@mail.gmail.com>
Subject: Re: ksmbd stuck open response
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 5=EC=9B=94 9=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 6:26, St=
eve French <smfrench@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> I saw an example in 6.9-rc6 where ksmbd was failing to send an open
> response repeatedly (it showed up running test cifs/102
Where is cifs/102 test ? I can not find it in xfstests.
>
> On the client I see the call one stuck SMB3.1.1 open request (never
> returns) and call stack of:
>
> [root@fedora29 ~]# cat /proc/5042/stack
> [<0>] wait_for_response+0xd1/0x130 [cifs]
> [<0>] compound_send_recv+0x68e/0x10b0 [cifs]
> [<0>] cifs_send_recv+0x23/0x30 [cifs]
> [<0>] SMB2_open+0x378/0xbd0 [cifs]
> [<0>] smb2_open_file+0x171/0x560 [cifs]
> [<0>] cifs_do_create.isra.0+0x471/0xd40 [cifs]
> [<0>] cifs_atomic_open+0x382/0x780 [cifs]
> [<0>] lookup_open.isra.0+0x6b0/0x930
> [<0>] path_openat+0x491/0x10d0
> [<0>] do_filp_open+0x144/0x250
> [<0>] do_sys_openat2+0xe0/0x110
> [<0>] __x64_sys_openat+0xc1/0x120
> [<0>] do_syscall_64+0x78/0x180
> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> on the server I see lots of failure to send a message on the socket
> every five seconds:
> ...
> [Wed May  8 21:13:59 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:04 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:09 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:14 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:20 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:25 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:30 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:35 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:40 2024] ksmbd: Failed to send message: -11
> [Wed May  8 21:14:45 2024] ksmbd: Failed to send message: -11
>
> doing "ksmbd.control -s" did free that request but hangs on the server
> (and subsequent requests on the client fail).  Nothing obvious in
> dmesg on client or server, except the following (xfs bug?) which was
> logged after the "ksmbd.control -s" on the server:
>
> [24324.546128] Call Trace:
> [24324.546130]  <TASK>
> [24324.546134]  dump_stack_lvl+0x76/0xa0
> [24324.546141]  dump_stack+0x10/0x20
> [24324.546145]  xfs_error_report+0x4a/0x70 [xfs]
> [24324.546298]  ? xfs_remove+0x175/0x300 [xfs]
> [24324.546440]  xfs_trans_cancel+0x14b/0x170 [xfs]
> [24324.546582]  xfs_remove+0x175/0x300 [xfs]
> [24324.546724]  xfs_vn_unlink+0x53/0xb0 [xfs]
> [24324.546866]  vfs_unlink+0x146/0x2e0
> [24324.546872]  ksmbd_vfs_unlink+0xa9/0x140 [ksmbd]
> [24324.546888]  ? __pfx_session_fd_check+0x10/0x10 [ksmbd]
> [24324.546902]  __ksmbd_close_fd+0x2ba/0x2d0 [ksmbd]
> [24324.546916]  ? _raw_spin_unlock+0xe/0x40
> [24324.546920]  ? __pfx_session_fd_check+0x10/0x10 [ksmbd]
> [24324.546936]  __close_file_table_ids+0x60/0xb0 [ksmbd]
> [24324.546950]  ksmbd_destroy_file_table+0x22/0x60 [ksmbd]
> [24324.546966]  ksmbd_session_destroy+0x5a/0x1b0 [ksmbd]
> [24324.546984]  ksmbd_sessions_deregister+0x24c/0x270 [ksmbd]
> [24324.547001]  ksmbd_server_terminate_conn+0x12/0x30 [ksmbd]
> [24324.547016]  ksmbd_conn_handler_loop+0x203/0x370 [ksmbd]
> [24324.547034]  ? __pfx_ksmbd_conn_handler_loop+0x10/0x10 [ksmbd]
> [24324.547050]  kthread+0xe4/0x110
> [24324.547054]  ? __pfx_kthread+0x10/0x10
> [24324.547058]  ret_from_fork+0x47/0x70
> [24324.547062]  ? __pfx_kthread+0x10/0x10
> [24324.547065]  ret_from_fork_asm+0x1a/0x30
> [24324.547070]  </TASK>
>
>
> Any ideas?
> --
> Thanks,
>
> Steve
>
