Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FB52BE637;
	Wed,  6 Aug 2025 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510965; cv=none; b=O8spuUcMKHmuWSmvx+HKVWTR4hUHeNwVxBova6UFz4Ld0lKRDr3dVnjF5sMpDg1wLJ0dvu7rW69LgxWiuhzeCET1me+CvNCamwXwWWZCEc221vku5r0z3+ctdS58Lqx9skxd7Nm9awg7FKz+/wXPVBvLioBP2kzeNOk66ZKHTuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510965; c=relaxed/simple;
	bh=VyDO5ZhtuL7IRiMZQwyRW6uJplVwASxn1a04NIcNPEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RznkKV3ssj55riTtTTQP68lPmCsg8gtfmzxu3h9NnMknLbiUB5Zt9B+dN10+L1NZcIvnM+lnI6sCfg6T/Pz/5KIKe0BIt0YUDmsFu04vT9qsPRudG2LzlawTCC40A0Ltaq+NSEMNBvU3vZTeFYPXghiO795xxX6V+SqlQIi0t0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Be1+/dRN; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Be1+/dRN"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-7074bad0523so3279146d6.3;
        Wed, 06 Aug 2025 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754510963; x=1755115763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0NsfejOBCPj7fEMocq9Brx1pj66mrF83zI2fkkvvzc=;
        b=Be1+/dRNs7xIb2RvugdMVhRCCCXYLCVH2i1ODVqLXV8XkxLU2bcUQ8Hrdb6WxfTdjA
         TItsqeKZFZ4OhuFcy8eptGLeVI2f4mrHvPB3R1AQI5nSM+69YSfThsb3CWhC643zU4wj
         AdAmpX8S9u97cc8U0jN6ZbymKYUOLZgZUnosrl7b0yi/vDeIeUuSQV7uP4MxSfVswlBt
         POmv/c0kKzBniKYn1XQFALTS2yacnRW8VnP8XApfmX2jmwNlXi9Y9H2AlXUumDRgX/8v
         PoHTPC/Owks8FikGvFKkCF0D4fwSgpU0wEab0zG2Tmyw57z/P/9Jy2TB+JQeJd0x5m2c
         88KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510963; x=1755115763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0NsfejOBCPj7fEMocq9Brx1pj66mrF83zI2fkkvvzc=;
        b=uauKv4q9RhawxK6W99rMPRaBSV5rt8xflCq1i/DC1rgdH6WwSmx0jlf7B8ZcNYiIgN
         KKEjGTywS8n1C77/YJ6eo/4ZoHIv2IGOt2VsEjZV7nI02DS8S0mbbytoxzV1ruo3IaFS
         q13kQH5pAUBaWDAqiAfzwQRPXPmewas7O0Xg7gCIyt31jWIpcMDaq/+yZEqsHTxO6ReT
         4oIvbytqlT56VeU0hf+5N8Zgn5ko7vFM5kxEcvFnBUQK0Arxp0a8Lc7SCDyVsbiy+BUs
         83tsDg+FdqyH2mv1tepzMtov9/imOOEfcGvxLLEfpFrE5XY87uO9LG83o+kqakJB5Hx0
         +yBA==
X-Forwarded-Encrypted: i=1; AJvYcCVKoPIVBfZWbe3GNe+uNiHl2rB4YPxIzxVi2t8WSF7Tum6dQh1d3mVqUZ+QBs+69OQrjwDrkJUFIBt6xgJ3@vger.kernel.org, AJvYcCVfOO8hw638iRt7CPPKcenPyKFv+piP0eTzRDjtTvp5ihfIvbbWi/bKC5BmwlBX8QwCTReSwSm15EJG@vger.kernel.org
X-Gm-Message-State: AOJu0YxM9T4g4P8HSLqrksFBnwNt6zP9cIHBsWDhCbenpRbk5EyNJAdg
	LdkB70qBbs1m6PB+Pd3fLW29Nu9wmw8q8genXsD8cnysYkdDvT4awTinaQ74A18UkkXLr47waps
	eimx9RvIANfKdLdQgoBCrbncZF6qE0ow=
X-Gm-Gg: ASbGnct8iGOKPoaiHG2fir6Yg4W2k/Kamh3rhBSPGUnZkBcAuEfeM3C0lKOqvE6fkmH
	qblA1WgLFo+ZczP/RF7QeW0o3IOJzNxvkLjdueeaA6STdUbGtPfGQahI6+m8jJ9vfDWc7WE8t5t
	c8LkS286mVaeSghZaV3KsWZtfDjZvvFUg6UuG3eyPTZGdTp3iAhqo/1pNDGkjQcM8inI4h+v3Ft
	70jaEyNiyUqSIJBnEk8niTbuyyIZCx/WFL5uvlC
X-Google-Smtp-Source: AGHT+IHEfWCf9FgFlsU3iye3qm8Ip4wtA2MK5FUn4GvujbXpbuIjRI1HJBF//AzMmN63soHvgm+K+PUPuxeqeoXaFwU=
X-Received: by 2002:a05:6214:f0b:b0:707:5495:abe6 with SMTP id
 6a1803df08f44-709795203b7mr67212486d6.12.1754510962490; Wed, 06 Aug 2025
 13:09:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806132211.94686-2-ysk@kzalloc.com>
In-Reply-To: <20250806132211.94686-2-ysk@kzalloc.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 6 Aug 2025 15:09:10 -0500
X-Gm-Features: Ac12FXxPL5hoUGXqzan50qLzGpk3hra2GhpaxIMwaBNUwL-jJ1H6j-8cugQNT3c
Message-ID: <CAH2r5mt97q_jtjtAT0DVDySU0jnk9=KeTDYha-KgOip_CAT_iw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix null-ptr-deref by static initializing global lock
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Wed, Aug 6, 2025 at 8:23=E2=80=AFAM Yunseong Kim <ysk@kzalloc.com> wrote=
:
>
> A kernel panic can be triggered by reading /proc/fs/cifs/debug_dirs.
> The crash is a null-ptr-deref inside spin_lock(), caused by the use of th=
e
> uninitialized global spinlock cifs_tcp_ses_lock.
>
> init_cifs()
>  =E2=94=94=E2=94=80=E2=94=80 cifs_proc_init()
>       =E2=94=94=E2=94=80=E2=94=80 // User can access /proc/fs/cifs/debug_=
dirs here
>            =E2=94=94=E2=94=80=E2=94=80 cifs_debug_dirs_proc_show()
>                 =E2=94=94=E2=94=80=E2=94=80 spin_lock(&cifs_tcp_ses_lock)=
; // Uninitialized!
>
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> Mem abort info:
> ESR =3D 0x0000000096000005
> EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> SET =3D 0, FnV =3D 0
> EA =3D 0, S1PTW =3D 0
> FSC =3D 0x05: level 1 translation fault
> Data abort info:
> ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
> CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> [dfff800000000000] address between user and kernel address ranges
> Internal error: Oops: 0000000096000005 [#1] SMP
> Modules linked in:
> CPU: 3 UID: 0 PID: 16435 Comm: stress-ng-procf Not tainted 6.16.0-10385-g=
79f14b5d84c6 #37 PREEMPT
> Hardware name: QEMU KVM Virtual Machine, BIOS 2025.02-8ubuntu1 06/11/2025
> pstate: 23400005 (nzCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=3D--)
> pc : do_raw_spin_lock+0x84/0x2cc
> lr : _raw_spin_lock+0x24/0x34
> sp : ffff8000966477e0
> x29: ffff800096647860 x28: ffff800096647b88 x27: ffff0001c0c22070
> x26: ffff0003eb2b60c8 x25: ffff0001c0c22018 x24: dfff800000000000
> x23: ffff0000f624e000 x22: ffff0003eb2b6020 x21: ffff0000f624e768
> x20: 0000000000000004 x19: 0000000000000000 x18: 0000000000000000
> x17: 0000000000000000 x16: ffff8000804b9600 x15: ffff700012cc8f04
> x14: 1ffff00012cc8f04 x13: 0000000000000004 x12: ffffffffffffffff
> x11: 1ffff00012cc8f00 x10: ffff80008d9af0d2 x9 : f3f3f304f1f1f1f1
> x8 : 0000000000000000 x7 : 7365733c203e6469 x6 : 20656572743c2023
> x5 : ffff0000e0ce0044 x4 : ffff80008a4deb6e x3 : ffff8000804b9718
> x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
> do_raw_spin_lock+0x84/0x2cc (P)
> _raw_spin_lock+0x24/0x34
> cifs_debug_dirs_proc_show+0x1ac/0x4c0
> seq_read_iter+0x3b0/0xc28
> proc_reg_read_iter+0x178/0x2a8
> vfs_read+0x5f8/0x88c
> ksys_read+0x120/0x210
> __arm64_sys_read+0x7c/0x90
> invoke_syscall+0x98/0x2b8
> el0_svc_common+0x130/0x23c
> do_el0_svc+0x48/0x58
> el0_svc+0x40/0x140
> el0t_64_sync_handler+0x84/0x12c
> el0t_64_sync+0x1ac/0x1b0
> Code: aa0003f3 f9000feb f2fe7e69 f8386969 (38f86908)
> ---[ end trace 0000000000000000 ]---
>
> The root cause is an initialization order problem. The lock is declared
> as a global variable and intended to be initialized during module startup=
.
> However, the procfs entry that uses this lock can be accessed by userspac=
e
> before the spin_lock_init() call has run. This creates a race window wher=
e
> reading the proc file will attempt to use the lock before it is
> initialized, leading to the crash.
>
> For a global lock with a static lifetime, the correct and robust approach
> is to use compile-time initialization.
>
> Fixes: 844e5c0eb176 ("smb3 client: add way to show directory leases for i=
mproved debugging")
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
> ---
>  fs/smb/client/cifsfs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 31930b7266db..3bd85ab2deb1 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -77,7 +77,7 @@ unsigned int global_secflags =3D CIFSSEC_DEF;
>  unsigned int GlobalCurrentXid; /* protected by GlobalMid_Lock */
>  unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Lock */
>  unsigned int GlobalMaxActiveXid;       /* prot by GlobalMid_Lock */
> -spinlock_t GlobalMid_Lock; /* protects above & list operations on midQ e=
ntries */
> +DEFINE_SPINLOCK(GlobalMid_Lock); /* protects above & list operations on =
midQ entries */
>
>  /*
>   *  Global counters, updated atomically
> @@ -97,7 +97,7 @@ atomic_t total_buf_alloc_count;
>  atomic_t total_small_buf_alloc_count;
>  #endif/* STATS2 */
>  struct list_head       cifs_tcp_ses_list;
> -spinlock_t             cifs_tcp_ses_lock;
> +DEFINE_SPINLOCK(cifs_tcp_ses_lock);
>  static const struct super_operations cifs_super_ops;
>  unsigned int CIFSMaxBufSize =3D CIFS_MAX_MSGSIZE;
>  module_param(CIFSMaxBufSize, uint, 0444);
> @@ -1863,8 +1863,6 @@ init_cifs(void)
>         GlobalCurrentXid =3D 0;
>         GlobalTotalActiveXid =3D 0;
>         GlobalMaxActiveXid =3D 0;
> -       spin_lock_init(&cifs_tcp_ses_lock);
> -       spin_lock_init(&GlobalMid_Lock);
>
>         cifs_lock_secret =3D get_random_u32();
>
> --
> 2.50.0
>
>


--=20
Thanks,

Steve
