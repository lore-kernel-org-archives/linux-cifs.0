Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA7D2913
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737221813; cv=none; b=q76kdPK0Gew7mejx0rFVaigTMrc9E+QwYJi+61109FqxqtlItruCjU60y3MIVEe48sjHrqAkh7S+ufstVNQENsQAHcXLnWsOxg4V9rUvZiXGWcK917HmxKvXijlSqo7hFMMFJP5HDYiVLuNprdG1w1RhJfDvI6ia10mTjb2qv1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737221813; c=relaxed/simple;
	bh=AalQE50/3WHcCTAj2kdPUeIHFTJZYG47KWpeoh9qkyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hsIt3N39quc5WsHnv8bi13bg6zcigf9HLUDn7zk5+wgI9sOqGE1Mq+7atLff31VduCStzOlHODgjlhEP2b8Z6ah4wddcydBoeDC31/1vhN90i2fChpBKWTqIJE26B4lHtnjHc7Ekx20kBfZvE7tUyd8Ffm2eIDmGezFmODtMGu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NFic7/g5; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NFic7/g5"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-542af38ecd6so3357153e87.0
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jan 2025 09:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737221809; x=1737826609; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+vEu5y5W/trriK7BOlYgttH5NYK3ahYbYlvdP+8nzjs=;
        b=NFic7/g5Y4RSAgkr1f1NVH5SpBjMBUPtmWRECjUlajIcgpY/PI/Q/ZFTNHIuBpBtFu
         4JH1wcS42JAtvIaM++IXP7piCTnCamDSUoa5y0nMK2PQbGKlj1vHY3/6BweqUvhYpNHI
         SRXQ9Wtp/Wk8N52Qg+ufFAO+bqnqZQeLBsVJ2Y+pS8U0uoIiY3LWSgUkmezrc/mPtVUH
         hDBVdd68VVF21t/TAMe5ATJz95WtNNU9yiH72eqDShNCQG+xmg8CSh0yXsvZEw3Bwn/w
         syO+RpU5mcHEXCW4WqNwLxEAwJ5aZVLqr0QkUNn7KGNvFH234nx/N4gRY5Aw5SSOiuBm
         +pXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737221809; x=1737826609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+vEu5y5W/trriK7BOlYgttH5NYK3ahYbYlvdP+8nzjs=;
        b=twZnumD62Xt36mtsMU/RwAA3pEjXuKUTKw3z4uEAqr8pPl04Sf8Emw+PfpHO5CXmND
         imroqQ5h+xOc78NFnaF7Rzi3j/T8giyfqSa5zPyBZ+fwDN8fQ85df1LI5oweWGQ1kuQH
         JgzIqjaAdBhUF6pLQFki+u5WIgNdUwCQlBHN03zAfCBI+T+w8lwjGhqxIdIukwKCY9sq
         k9r39twxMlHwgWcEFDdH/7+6MvyDx6q85IVCrVUIQTvDq2EAAjlPoNsyzxV66UM2NEsQ
         UhijqA/Ao2i/rMjAL2WuGcy3crMvmNzGinqYWmM4wDFFhl2Z+0lMP/e3yNqxlvLQJ4a5
         4eew==
X-Gm-Message-State: AOJu0YxRBUWBgtxVwmaPMC5ZLU48qBG3h/f8N4CZyrViGlWdkhxMJq74
	7xNCN3NbEEz+AVfed6FoAG2FlOo2+jY2LXNxj2XpyFSjoxnXgtd14jjEXa+RL/93Qt4IDluHYEV
	0alpgKlHDG9svA7A3geruWG+9GxA=
X-Gm-Gg: ASbGncuIt9y/o9lVDE1BaF9Ls4LXZ9HmlcHhCWO6aZGrgmUcQ7FO02XebsYLKFB/VLf
	XD88yGa5UTv88RZxVchpj6HD2GOXxQJFaPc//ZqRFGMxAsHk4AYTO8d9A+WfYiDjVMHeFiYVzN0
	rDwHjLbJzB
X-Google-Smtp-Source: AGHT+IEUqgxWNSCw+EzUeTqkEoevdNZJj7U2Et2H7202idk51pr+ZHp1RXQZW5/6q2mHyC/9QR2Wa8FCiFzzZXZxuMw=
X-Received: by 2002:a05:6512:1094:b0:53e:2900:89b4 with SMTP id
 2adb3069b0e04-5439c287e97mr2829908e87.49.1737221808928; Sat, 18 Jan 2025
 09:36:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116172903.666243-1-pc@manguebit.com>
In-Reply-To: <20250116172903.666243-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 Jan 2025 11:36:37 -0600
X-Gm-Features: AbW1kvYrecDoKndQh5_2ZKvkKv5blXSO7AhHcTztxjbyyBvubHhMYjHX1mCWs7A
Message-ID: <CAH2r5mugqpmkbh5=TThZqp6XWGGCsOOdfQWvei2JjbKST-J0Nw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix oops due to unset link speed
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Shyam Prasad N <nspmangalore@gmail.com>, 
	Tom Talpey <tom@talpey.com>, Frank Sorenson <sorenson@redhat.com>, Jay Shin <jaeshin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

With current for-next which includes this patch I noticed xfstest
cifs/104 now failing

[Sat Jan 18 00:17:13 2025] CIFS: Attempting to mount //win16.vm.test/Scratc=
h
[Sat Jan 18 00:17:13 2025] CIFS: VFS: Error connecting to socket.
Aborting operation.
[Sat Jan 18 00:17:13 2025] CIFS: VFS: failed to open extra channel on
iface:fe80:0000:0000:0000:a435:84a7:df37:4e6b rc=3D-22
[Sat Jan 18 00:17:13 2025] CIFS: VFS: too many channel open attempts
(2 channels left to open)

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/3/=
builds/350/steps/26/logs/stdio

Thoughts?

On Thu, Jan 16, 2025 at 11:29=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> It isn't guaranteed that NETWORK_INTERFACE_INFO::LinkSpeed will always
> be set by the server, so the client must handle any values and then
> prevent oopses like below from happening:
>
> Oops: divide error: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 1323 Comm: cat Not tainted 6.13.0-rc7 #2
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-3.fc41
> 04/01/2014
> RIP: 0010:cifs_debug_data_proc_show+0xa45/0x1460 [cifs] Code: 00 00 48
> 89 df e8 3b cd 1b c1 41 f6 44 24 2c 04 0f 84 50 01 00 00 48 89 ef e8
> e7 d0 1b c1 49 8b 44 24 18 31 d2 49 8d 7c 24 28 <48> f7 74 24 18 48 89
> c3 e8 6e cf 1b c1 41 8b 6c 24 28 49 8d 7c 24
> RSP: 0018:ffffc90001817be0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88811230022c RCX: ffffffffc041bd99
> RDX: 0000000000000000 RSI: 0000000000000567 RDI: ffff888112300228
> RBP: ffff888112300218 R08: fffff52000302f5f R09: ffffed1022fa58ac
> R10: ffff888117d2c566 R11: 00000000fffffffe R12: ffff888112300200
> R13: 000000012a15343f R14: 0000000000000001 R15: ffff888113f2db58
> FS: 00007fe27119e740(0000) GS:ffff888148600000(0000)
> knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe2633c5000 CR3: 0000000124da0000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ? __die_body.cold+0x19/0x27
>  ? die+0x2e/0x50
>  ? do_trap+0x159/0x1b0
>  ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
>  ? do_error_trap+0x90/0x130
>  ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
>  ? exc_divide_error+0x39/0x50
>  ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
>  ? asm_exc_divide_error+0x1a/0x20
>  ? cifs_debug_data_proc_show+0xa39/0x1460 [cifs]
>  ? cifs_debug_data_proc_show+0xa45/0x1460 [cifs]
>  ? seq_read_iter+0x42e/0x790
>  seq_read_iter+0x19a/0x790
>  proc_reg_read_iter+0xbe/0x110
>  ? __pfx_proc_reg_read_iter+0x10/0x10
>  vfs_read+0x469/0x570
>  ? do_user_addr_fault+0x398/0x760
>  ? __pfx_vfs_read+0x10/0x10
>  ? find_held_lock+0x8a/0xa0
>  ? __pfx_lock_release+0x10/0x10
>  ksys_read+0xd3/0x170
>  ? __pfx_ksys_read+0x10/0x10
>  ? __rcu_read_unlock+0x50/0x270
>  ? mark_held_locks+0x1a/0x90
>  do_syscall_64+0xbb/0x1d0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe271288911
> Code: 00 48 8b 15 01 25 10 00 f7 d8 64 89 02 b8 ff ff ff ff eb bd e8
> 20 ad 01 00 f3 0f 1e fa 80 3d b5 a7 10 00 00 74 13 31 c0 0f 05 <48> 3d
> 00 f0 ff ff 77 4f c3 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec
> RSP: 002b:00007ffe87c079d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000040000 RCX: 00007fe271288911
> RDX: 0000000000040000 RSI: 00007fe2633c6000 RDI: 0000000000000003
> RBP: 00007ffe87c07a00 R08: 0000000000000000 R09: 00007fe2713e6380
> R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000040000
> R13: 00007fe2633c6000 R14: 0000000000000003 R15: 0000000000000000
>  </TASK>
>
> Fix this by setting cifs_server_iface::speed to a sane value (1Gbps)
> by default when link speed is unset.
>
> Cc: Shyam Prasad N <nspmangalore@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based o=
n speed")
> Reported-by: Frank Sorenson <sorenson@redhat.com>
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/smb2ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 87cb1872db28..9790ff2cc5b3 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -658,7 +658,8 @@ parse_server_interfaces(struct network_interface_info=
_ioctl_rsp *buf,
>
>         while (bytes_left >=3D (ssize_t)sizeof(*p)) {
>                 memset(&tmp_iface, 0, sizeof(tmp_iface));
> -               tmp_iface.speed =3D le64_to_cpu(p->LinkSpeed);
> +               /* default to 1Gbps when link speed is unset */
> +               tmp_iface.speed =3D le64_to_cpu(p->LinkSpeed) ?: 10000000=
00;
>                 tmp_iface.rdma_capable =3D le32_to_cpu(p->Capability & RD=
MA_CAPABLE) ? 1 : 0;
>                 tmp_iface.rss_capable =3D le32_to_cpu(p->Capability & RSS=
_CAPABLE) ? 1 : 0;
>
> --
> 2.47.1
>


--=20
Thanks,

Steve
