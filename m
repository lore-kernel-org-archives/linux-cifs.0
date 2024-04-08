Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A342D148FEE
	for <linux-cifs@vger.kernel.org>; Mon,  8 Apr 2024 22:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712614155; cv=none; b=IcwwtdY0+EuGy5niamCDAAyQu8iuwLi1SmpMPqvLrfMVi0hLcDXdxSYXxKPAOjpqitvXJ3ir/63k/mMbW7RhT715hnKwolEZr9RUAoCffoNqspEa8FPCloODW3zat6MbbNGm8ipZy8neq/BeLlapZlsd4Whvk4nQi1zCaf2wqBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712614155; c=relaxed/simple;
	bh=rtPrMWIzapfWxgEeczXXivprqf4zcHIy35BqlTx+8JY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LyFQByO4qN4t7kiqaFdMySyrK1THOUZcLCAXBdNZXbwXV8RXCL6tJOFAt/RDrXrBOssiNvj6D+vlZMd4Od+zZkBTaIL3O7aQEhqhxjlW2ZUXqU4ocpmr3jyIjjthW9JE7i5CPDy7tyGjra0I3108YzDLgxSBsmmhPit+WUDCGik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JJyO9QW8; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JJyO9QW8"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-516d0161e13so5380484e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 08 Apr 2024 15:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712614152; x=1713218952; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqYcCD9ubvBCKhqSwO9b7E9294mELBo2qeULSBGVcqA=;
        b=JJyO9QW8EyxFzWYHhnERzT5uY1KhBE67nclMDrCZCMdkl6S8AdNldT9AeHgbN+XAAX
         9fN9M8dpHp9u0oduuF5q9Bmu2UtVDouj0u0Ebe0dzNcUSZbjDDEkQbUa9Js+d693GYqP
         iAvCcKMIyZZNHXSc1BtMZT5A4YM5+f/0bdKm8VXPZlyBF90zMOluJoxD1f5anklXv628
         S5/kcr9fDuexBdyXI0dqzD55+Z69zZ3M04cIxwxyNGqZC3cz0ub80YXcUgRWd01KFqeV
         hr1sPUIkcbAoiHUok32IT8suJ4JuJCN9Pgi/3dmEr/7cOfT1XMfdHGRV/gpCKISwo0Do
         u1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712614152; x=1713218952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jqYcCD9ubvBCKhqSwO9b7E9294mELBo2qeULSBGVcqA=;
        b=qIv/3GHJIzBoSWn7Z5lAzLQrGgWB6cYEczQxEdymmSIpkKgnHjEIet83my9pHRKWpu
         h01vmezfYxKJcL77CWbiz5uiGU6CYKxKlrHnFwexfRAI3kgu3sJr+BVQ7svgz9KqPYsm
         xDr9w98LpWkv4pGXBXRwahAgfUu6FE8nHr3XU5oGSEGdHOz56dxNv/5NeatHAdv71r6k
         3H6NDOos6sHGwpuUW7KRtxgp0p7GNdu8L1hAkrUzs8chVAyEzHNzqQxNgY1nCVR3AF8s
         3aToos1DUe+s36QfMJFJns7VbxzxijbiliCSphj1B7b8uFIZw7c9pgJiIcQGtnCI/23F
         ctpw==
X-Gm-Message-State: AOJu0YwQPrnqyPULH1OnqgvnYjdEMS7aGlB5PIRxykVZHyrrA5WgjRE6
	I78WI1Gbpnl1C6QbrW+7OLKdEY4c6hMxKoDJB5nslfTgrjd5rzgeSKsJ/xk8tgMQyKgWJROKI6F
	gW6BwcEeY4p1ZX1GrHtEFnfRfF3I=
X-Google-Smtp-Source: AGHT+IFYQ87BgC4Edha36DkkN5ASn94ag1NQjVcSvJ99oodwy8E39dOkClZvpRyFtRaG4ypxeCNg0CQnLOfaBKJQ930=
X-Received: by 2002:a19:6a11:0:b0:516:d8df:2e0 with SMTP id
 u17-20020a196a11000000b00516d8df02e0mr5975973lfu.45.1712614151571; Mon, 08
 Apr 2024 15:09:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240408213217.241887-1-pc@manguebit.com>
In-Reply-To: <20240408213217.241887-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Apr 2024 17:09:00 -0500
Message-ID: <CAH2r5msiCzzP-cHcnzqHuAM23N5a_55TLMg3crt=Z0F=bS=xcA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix NULL ptr deref in cifs_mark_open_handles_for_deleted_file()
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

Good catch


On Mon, Apr 8, 2024 at 4:32=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> cifs_get_fattr() may be called with a NULL inode, so check for a
> non-NULL inode before calling
> cifs_mark_open_handles_for_deleted_file().
>
> This fixes the following oops:
>
>   mount.cifs //srv/share /mnt -o ...,vers=3D3.1.1
>   cd /mnt
>   touch foo; tail -f foo &
>   rm foo
>   cat foo
>
>   BUG: kernel NULL pointer dereference, address: 00000000000005c0
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP NOPTI
>   CPU: 2 PID: 696 Comm: cat Not tainted 6.9.0-rc2 #1
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>   1.16.3-1.fc39 04/01/2014
>   RIP: 0010:__lock_acquire+0x5d/0x1c70
>   Code: 00 00 44 8b a4 24 a0 00 00 00 45 85 f6 0f 84 bb 06 00 00 8b 2d
>   48 e2 95 01 45 89 c3 41 89 d2 45 89 c8 85 ed 0 0 <48> 81 3f 40 7a 76
>   83 44 0f 44 d8 83 fe 01 0f 86 1b 03 00 00 31 d2
>   RSP: 0018:ffffc90000b37490 EFLAGS: 00010002
>   RAX: 0000000000000000 RBX: ffff888110021ec0 RCX: 0000000000000000
>   RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000005c0
>   RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
>   R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
>   R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000200
>   FS: 00007f2a1fa08740(0000) GS:ffff888157a00000(0000)
>   knlGS:0000000000000000 CS: 0010 DS: 0000 ES: 0000 CR0:
>   0000000080050033
>   CR2: 00000000000005c0 CR3: 000000011ac7c000 CR4: 0000000000750ef0
>   PKRU: 55555554
>   Call Trace:
>    <TASK>
>    ? __die+0x23/0x70
>    ? page_fault_oops+0x180/0x490
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? exc_page_fault+0x70/0x230
>    ? asm_exc_page_fault+0x26/0x30
>    ? __lock_acquire+0x5d/0x1c70
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    lock_acquire+0xc0/0x2d0
>    ? cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? kmem_cache_alloc+0x2d9/0x370
>    _raw_spin_lock+0x34/0x80
>    ? cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
>    cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
>    cifs_get_fattr+0x24c/0x940 [cifs]
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    cifs_get_inode_info+0x96/0x120 [cifs]
>    cifs_lookup+0x16e/0x800 [cifs]
>    cifs_atomic_open+0xc7/0x5d0 [cifs]
>    ? lookup_open.isra.0+0x3ce/0x5f0
>    ? __pfx_cifs_atomic_open+0x10/0x10 [cifs]
>    lookup_open.isra.0+0x3ce/0x5f0
>    path_openat+0x42b/0xc30
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    ? srso_alias_return_thunk+0x5/0xfbef5
>    do_filp_open+0xc4/0x170
>    do_sys_openat2+0xab/0xe0
>    __x64_sys_openat+0x57/0xa0
>    do_syscall_64+0xc1/0x1e0
>    entry_SYSCALL_64_after_hwframe+0x72/0x7a
>
> Fixes: ffceb7640cbf ("smb: client: do not defer close open handles to del=
eted files")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 91b07ef9e25c..60afab5c83d4 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1105,7 +1105,8 @@ static int cifs_get_fattr(struct cifs_open_info_dat=
a *data,
>                 } else {
>                         cifs_open_info_to_fattr(fattr, data, sb);
>                 }
> -               if (!rc && fattr->cf_flags & CIFS_FATTR_DELETE_PENDING)
> +               if (!rc && *inode &&
> +                   (fattr->cf_flags & CIFS_FATTR_DELETE_PENDING))
>                         cifs_mark_open_handles_for_deleted_file(*inode, f=
ull_path);
>                 break;
>         case -EREMOTE:
> --
> 2.44.0
>


--=20
Thanks,

Steve
