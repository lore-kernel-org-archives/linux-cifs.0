Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D2B137930
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2025 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737048758; cv=none; b=QbC6EfERIdNv8qgWzSbsK2P4/TSg8Ce8EAaXA0Dq7IhEsacUYe0sVIc8w8F0U+/1iG78ls4F0LFXjenjxbRTwNPzy3gCpM58yYR8U+bYaN4qN5ntvbUZDqV5VClzCubrv/EsONsJVrDGEWezh9FiELa3InPgvDqqv0bP6af2reI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737048758; c=relaxed/simple;
	bh=sI/IChu00Fd3OoRQG34PZTNTxwbBRbAF57DCb/TVUD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XZxKphmigqKmrHDS+6T311RnTyMc89QIbj8DUiQQYVa3rf2j8qC4q+wJ9Of29qlPOdr7z+Gonrxx0l9M8efYGkkMKuNqg4yYPHjPL7y0V2R5YSoB9QgTcFdMFPrby7Rc0EmYCdySh7i2MivVPiJqYV46LDxxtn2x4sWSpweT4HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrQfnE4B; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrQfnE4B"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54298ec925bso1372050e87.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jan 2025 09:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737048755; x=1737653555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYf3ZnIRLcaHdRKpjktj+BOON0K3FNyeoL3IDq3UH0w=;
        b=WrQfnE4BfwFML8Uzg1rfKe5+cKdfnGldxdr2cq14UGNebPeEpJ4eaF5H/3bRYMgHoh
         J8rCWXwRrnTNq3iwY8EWezun6ZVtjD3H5piVsTTlgykvNvXEh7N2J0OCvHwA63RH9G+y
         YyEKsEwXDAMLwTJC64VN5IcjftmhQEfD3sq8a71TVcyvFW1TG5V8l6ZIGoAux2D8EZm/
         M80p7ekP+muh+wUDbLOokwBvo2UBOYo63zMuIoQAp1KYRy0oI6BIoxDc+h8w/hWo45Rf
         +5IJUmpns82JGW7b8gywiIx7zzMgCZbE3EPZX8RT5eLqQ/8nsuV8qjEHK7+hB36iImSz
         IJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737048755; x=1737653555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYf3ZnIRLcaHdRKpjktj+BOON0K3FNyeoL3IDq3UH0w=;
        b=Vrx/upsIAkgUCPmxo0jzRPghSkiETs25DBad3KOnWNzdZ1Fy+uUxGbRLvn4/vhs1io
         tTHpvMMFY47Sq+Kw3qiT9b7M9IdT3tdIKdWmPMhvjqIsNEL2Wf9QxGs0+i3XMQ5+mIkK
         1br3SapHG4wUj1rVPsMmJcjkpAbzZ9B0xJdNsy+8ME+JX/12NdtKUH/rf3U++IBSxZsm
         O+1b4TOkj6PdZKdpLKE5zTsH6u5t0ZD815V15zOwTp4e2UnCU/zy6+qI7meOBGDACfJG
         4hYjqODmJTyQlLg36pbWoalT5zA0FtVgL1FjTxWMVyrfwlRGl2bWuq46kLHEuhL5kSSC
         HXTA==
X-Gm-Message-State: AOJu0YzAZWvIh0EBTYW2Z3yEWpdA02ARVHuc45xwug5mhD5Sw80c6sy3
	w+YXempwY8UbMtDQ25eAFZJDNGxJ49e0qw9DIeOXHAsRAM6HZO5pDKZpWAssrge6DZuSZkW25A7
	Q7DKRqNqZ7pYu8JsO6yMDPd5sTw8=
X-Gm-Gg: ASbGncsOGPMQfDDCLt2ChGeF9+WzF7x4H/Mx9l90NKWRDl0JgjrlqmqJ1i4SW6I1N/s
	QZRJsBXgpw+AuvM4u/CT+C8bRqFvUGFKPGiNNfwU=
X-Google-Smtp-Source: AGHT+IGcJNLXFfA4RuWsxHNguqzJLll4EnbazLlLqTq6zo1F2zOqNWg7mMtyI01omv05C1stOXV/9hQj6slxzFtSDMM=
X-Received: by 2002:a05:6512:15a8:b0:541:21f9:45b6 with SMTP id
 2adb3069b0e04-54284801becmr11183999e87.37.1737048754890; Thu, 16 Jan 2025
 09:32:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116172903.666243-1-pc@manguebit.com>
In-Reply-To: <20250116172903.666243-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Jan 2025 11:32:23 -0600
X-Gm-Features: AbW1kvYXKp_j1EkdWlln7jsrMOfkEz8K22AcNqjValrpu2JlZF8FcZeNmsHgbhg
Message-ID: <CAH2r5ms-XiL6nh0gm0zUNMHRupaRKPm-bzQ4HJwiYe3vX9cmHQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix oops due to unset link speed
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Shyam Prasad N <nspmangalore@gmail.com>, 
	Tom Talpey <tom@talpey.com>, Frank Sorenson <sorenson@redhat.com>, Jay Shin <jaeshin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review and testing

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
