Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185BB1537A7;
	Thu,  7 Aug 2025 06:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754547730; cv=none; b=T4jXz6UdvQd7VQYQIWC3ynnzRMEGAGGsIOW2wFlN8hVGc3WAGrAT4jl0loL1gkpbPkANoueOnga5mstW3eetGiFyeeTOIhROOc2HsfF//OMYWMfiC4flwasY1yM6yY9x1yJDt9PgXQSZ90IQnTpft7WmvD2co/EQQ4FvWyyl4vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754547730; c=relaxed/simple;
	bh=h4HAzvbNPfu2hlTDaZ1JnlfaRsCsMn3xWXo3/bjYla0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EKV8QETO1McDZleiiFiftD90FoDooKjenJbjLqJTIExgZF7Tv9TliFwLnb0Zc/LFfNX/79jVCmk59JCTk8b1TCaQeH7rtK4GkJhKnyGyeFkS5+eSlYy0fsh/b2xebQvf6D+xYfnsP+HCITWiYyPUbAM3eH4JpSI03PYjNYu0SUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gp5t7iIK; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gp5t7iIK"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-615c8ca53efso1162636a12.2;
        Wed, 06 Aug 2025 23:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754547727; x=1755152527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ktbyr9SzycNcU3hnEzNp337kzitNq3svuSJ+tfB4O4=;
        b=gp5t7iIKpG9B6h+LOBKAN5Q0XdOrT9NDiBE1rAResv4aoDIHqvhZNnmSSil7FIBPyf
         zuYMPDfCkSoyu01csekdll5Zy6Qg8ztZQLVKctA0qMW8HWw9oY6m8Vsi1/pl79dgSx4z
         I7ro5J1VXNJQz3MeHcvWRHESKTkiLUonDHs7fglQminvVwdosC1r9x5s3zwR2DfRaI5b
         9KQX07mbOera0ahH5vC4Wv27wG1JLpw7OQ4dSJAeBkxaio/NQSrRor22oeHggOrjLOLG
         XV/HZpPLGyVJ39dFHQwf7hEf531guTgE/01oy/aYTi++j/Osl1Zy0tO1OrNaqkJRDfux
         N3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754547727; x=1755152527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ktbyr9SzycNcU3hnEzNp337kzitNq3svuSJ+tfB4O4=;
        b=Gaoy0mgc5hWE+rezsjft0GITmi9W0ljfPVjuBzlUcDz6VNieBq4l9pMYijUQr07Vkd
         /BXAaSj0/ySR2Oa2TYf7+GB6qYqJuXJbjqHhj76tfw/APciAV/x88hCE7gG/Wz7y1aqj
         spMMrEWmfbexmfVR2n43mnAusdabYcrSRn7G9msrTs1eaRZjPTYPxhRTwRCIz33leWMm
         L6BCp8pooxsTe6bcPzjMKZRiK2Ki9x17/K9uZqxnoMNXP0eba7LoHMjfRJZHBE4+czbR
         DpRR3uydB8To+KSH2oIg2h6tkXSaBffAgVW5AlQ0YHsfGuw7e51/6Q4391oqzJ96faam
         eLGg==
X-Forwarded-Encrypted: i=1; AJvYcCU6A4M/AXkL+Z9IaCEVXZJvAZjOb/6y1ROiKA60eIZYBL9toY1CNw7g/eAoGdPmFdKSLEQ2nBb0fpuP@vger.kernel.org, AJvYcCWGwm2H8H1yGIZbiYZqTnFkxGsISHe33GyUWTq2KfzBujAkUwUkOVIOtsv7Q1tpe+aWihlJ9XLTejQyMrrW@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8ILA+djbOdvTRMZP6sgadMgTkke5rED4Mec31byj8L/1EpReX
	yUJzlJOwPCbMshGPeAdMuLwgYWloMQFlGD/C7sSP+wgi9WlCBsxl73R0n7xfAgkuJvXXsO2OtUK
	N2nanEkcIjylNJSSp2011jPee6A6JXKA=
X-Gm-Gg: ASbGncsT6ni+x7ZkDFiAiXAC8sHTKaFUaQvCkuYFsfvjWnNAyZ7BidqPCMOcT4bnYNt
	QY5O5CYDoKColgon25S+IZ93f8J7gPFEdK9nmyHSYaih0AcadFdpdYsB8sBMqrWZAFS00NofS9C
	ZoGhgDeIhbHs9Q5yIOQdtmU8wzv2G5Ik4H/DMAX0Vl911qqy3J1rQFzrOFeRZvhMQZIjsmwu3eY
	FE8AA==
X-Google-Smtp-Source: AGHT+IGtyMCANSoiLMOF/IIteuE7iwefk4ZGp11or1k1vGqtVJL/BQwhSDgSaVpXdy8jhiEdCUzZxU9t5Mg5Ti4BG0s=
X-Received: by 2002:a05:6402:5106:b0:615:80eb:76ba with SMTP id
 4fb4d7f45d1cf-61796141a85mr4669366a12.17.1754547727161; Wed, 06 Aug 2025
 23:22:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806132211.94686-2-ysk@kzalloc.com> <CAH2r5mt97q_jtjtAT0DVDySU0jnk9=KeTDYha-KgOip_CAT_iw@mail.gmail.com>
In-Reply-To: <CAH2r5mt97q_jtjtAT0DVDySU0jnk9=KeTDYha-KgOip_CAT_iw@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 7 Aug 2025 11:51:55 +0530
X-Gm-Features: Ac12FXwD7pQ3n-0mANzi1TD_ZDrU4JcAARE48kDt7Tfj-YuFN3HIKcB-7hMpqHE
Message-ID: <CANT5p=qiuF0=PZaN9eCzrps=azamWjkh9U19zu2B5dRADUrP1g@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix null-ptr-deref by static initializing global lock
To: Steve French <smfrench@gmail.com>
Cc: Yunseong Kim <ysk@kzalloc.com>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 1:44=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> merged into cifs-2.6.git for-next
>
> On Wed, Aug 6, 2025 at 8:23=E2=80=AFAM Yunseong Kim <ysk@kzalloc.com> wro=
te:
> >
> > A kernel panic can be triggered by reading /proc/fs/cifs/debug_dirs.
> > The crash is a null-ptr-deref inside spin_lock(), caused by the use of =
the
> > uninitialized global spinlock cifs_tcp_ses_lock.
> >
> > init_cifs()
> >  =E2=94=94=E2=94=80=E2=94=80 cifs_proc_init()
> >       =E2=94=94=E2=94=80=E2=94=80 // User can access /proc/fs/cifs/debu=
g_dirs here
> >            =E2=94=94=E2=94=80=E2=94=80 cifs_debug_dirs_proc_show()
> >                 =E2=94=94=E2=94=80=E2=94=80 spin_lock(&cifs_tcp_ses_loc=
k); // Uninitialized!
> >
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > Mem abort info:
> > ESR =3D 0x0000000096000005
> > EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > SET =3D 0, FnV =3D 0
> > EA =3D 0, S1PTW =3D 0
> > FSC =3D 0x05: level 1 translation fault
> > Data abort info:
> > ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
> > CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> > GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> > [dfff800000000000] address between user and kernel address ranges
> > Internal error: Oops: 0000000096000005 [#1] SMP
> > Modules linked in:
> > CPU: 3 UID: 0 PID: 16435 Comm: stress-ng-procf Not tainted 6.16.0-10385=
-g79f14b5d84c6 #37 PREEMPT
> > Hardware name: QEMU KVM Virtual Machine, BIOS 2025.02-8ubuntu1 06/11/20=
25
> > pstate: 23400005 (nzCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=3D--)
> > pc : do_raw_spin_lock+0x84/0x2cc
> > lr : _raw_spin_lock+0x24/0x34
> > sp : ffff8000966477e0
> > x29: ffff800096647860 x28: ffff800096647b88 x27: ffff0001c0c22070
> > x26: ffff0003eb2b60c8 x25: ffff0001c0c22018 x24: dfff800000000000
> > x23: ffff0000f624e000 x22: ffff0003eb2b6020 x21: ffff0000f624e768
> > x20: 0000000000000004 x19: 0000000000000000 x18: 0000000000000000
> > x17: 0000000000000000 x16: ffff8000804b9600 x15: ffff700012cc8f04
> > x14: 1ffff00012cc8f04 x13: 0000000000000004 x12: ffffffffffffffff
> > x11: 1ffff00012cc8f00 x10: ffff80008d9af0d2 x9 : f3f3f304f1f1f1f1
> > x8 : 0000000000000000 x7 : 7365733c203e6469 x6 : 20656572743c2023
> > x5 : ffff0000e0ce0044 x4 : ffff80008a4deb6e x3 : ffff8000804b9718
> > x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
> > Call trace:
> > do_raw_spin_lock+0x84/0x2cc (P)
> > _raw_spin_lock+0x24/0x34
> > cifs_debug_dirs_proc_show+0x1ac/0x4c0
> > seq_read_iter+0x3b0/0xc28
> > proc_reg_read_iter+0x178/0x2a8
> > vfs_read+0x5f8/0x88c
> > ksys_read+0x120/0x210
> > __arm64_sys_read+0x7c/0x90
> > invoke_syscall+0x98/0x2b8
> > el0_svc_common+0x130/0x23c
> > do_el0_svc+0x48/0x58
> > el0_svc+0x40/0x140
> > el0t_64_sync_handler+0x84/0x12c
> > el0t_64_sync+0x1ac/0x1b0
> > Code: aa0003f3 f9000feb f2fe7e69 f8386969 (38f86908)
> > ---[ end trace 0000000000000000 ]---
> >
> > The root cause is an initialization order problem. The lock is declared
> > as a global variable and intended to be initialized during module start=
up.
> > However, the procfs entry that uses this lock can be accessed by usersp=
ace
> > before the spin_lock_init() call has run. This creates a race window wh=
ere
> > reading the proc file will attempt to use the lock before it is
> > initialized, leading to the crash.
> >
> > For a global lock with a static lifetime, the correct and robust approa=
ch
> > is to use compile-time initialization.
> >
> > Fixes: 844e5c0eb176 ("smb3 client: add way to show directory leases for=
 improved debugging")
> > Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
> > ---
> >  fs/smb/client/cifsfs.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index 31930b7266db..3bd85ab2deb1 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -77,7 +77,7 @@ unsigned int global_secflags =3D CIFSSEC_DEF;
> >  unsigned int GlobalCurrentXid; /* protected by GlobalMid_Lock */
> >  unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Lock */
> >  unsigned int GlobalMaxActiveXid;       /* prot by GlobalMid_Lock */
> > -spinlock_t GlobalMid_Lock; /* protects above & list operations on midQ=
 entries */
> > +DEFINE_SPINLOCK(GlobalMid_Lock); /* protects above & list operations o=
n midQ entries */
> >
> >  /*
> >   *  Global counters, updated atomically
> > @@ -97,7 +97,7 @@ atomic_t total_buf_alloc_count;
> >  atomic_t total_small_buf_alloc_count;
> >  #endif/* STATS2 */
> >  struct list_head       cifs_tcp_ses_list;
> > -spinlock_t             cifs_tcp_ses_lock;
> > +DEFINE_SPINLOCK(cifs_tcp_ses_lock);
> >  static const struct super_operations cifs_super_ops;
> >  unsigned int CIFSMaxBufSize =3D CIFS_MAX_MSGSIZE;
> >  module_param(CIFSMaxBufSize, uint, 0444);
> > @@ -1863,8 +1863,6 @@ init_cifs(void)
> >         GlobalCurrentXid =3D 0;
> >         GlobalTotalActiveXid =3D 0;
> >         GlobalMaxActiveXid =3D 0;
> > -       spin_lock_init(&cifs_tcp_ses_lock);
> > -       spin_lock_init(&GlobalMid_Lock);
> >
> >         cifs_lock_secret =3D get_random_u32();
> >
> > --
> > 2.50.0
> >
> >
>
>
> --
> Thanks,
>
> Steve
>

Good catch.
But the problem is that cifs_proc_init gets called very early on in init_ci=
fs.
That call should be moved to just before (or possibly after)
registering the filesystem.

--=20
Regards,
Shyam
