Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497ED7FD;
	Mon, 19 May 2025 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747669311; cv=none; b=R6h+wQxqKEHOs27Uyf+hLvm43DS5PSrHJ3OslMN1GMqiDCB8VD6cWda46uK10hLMWQK69GremEdoepzIJ1+kZpqW7j15kBU0G5ew6blsJTjL4aAZ6vU85kI71+Cc0fmImJHhdKvXQPs9BWG//ZxTn0/aU4dFDoToOo7UblEjHYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747669311; c=relaxed/simple;
	bh=3hl1P+UR6D41tyfJ23WLxxYiV+u0SaA9ZL9rVCwlOpY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I+wnHj34ysqnvYYMAhKOY166t7NIqMeCAUvkmjwilbX/yF3QHj6vrTRafSuOvcMr5as4wo66GdBvcUxED49zEHXadQt8zeNSkIiZVjOmNHhIQiodg/+Mr5SWVnCbSJ6i5waSwYgBE0xDqzgrVIt1jAPGlRO3b2HM2F2m7PLK6d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K7/YwClX; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K7/YwClX"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30effbfaf61so58032261fa.0;
        Mon, 19 May 2025 08:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747669307; x=1748274107; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSIy+2fySJSQutZI2cqUev4NxCK0aKsYVnD2VvMbVvg=;
        b=K7/YwClXGowS+Hq91qTmyoziQdbZOgyELNZK60QB+OyvMMRhHRuuNpNuhqr5Xu4wp4
         UieuP6P0geUga8Ltryljr0U945ppZxg3yboqPwKunZ7xSS3eh16fIQYmX8oAZFUYQ0l7
         d2KuhhgDpjdKulNXFWwU22ujz0Sr9wvGfMF8TTaUhwxPC0hKFYMlMtrG+rVo5pZrATNO
         Z6kLxAmSaZHsTcYpnKUXjd9fWYHxWrFGtW0zqHxD6asO+A4kfftsKyjVigNW0LGNQH2v
         D9VGU7HQ+21DzcNVg2RCr/ZSjmaKaX+y5alcc2InO5QOtTOARZ99KBrksnEKTAmO+VAw
         NPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747669307; x=1748274107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hSIy+2fySJSQutZI2cqUev4NxCK0aKsYVnD2VvMbVvg=;
        b=JHDQhsKRCW6U0x/n4x86e/Jmev2RARxxa9WKRnQtTC+V6mIUJ87trubOwYgjV9lccv
         ugY8ONzn+KXpobCwVKjbb6vRDqnqKFqojdmwJcwxrScvwXgScMiecDeuyOBoemp/K7Cu
         QCATj43iRqyqMybM57HTzgsf0FrdNl/IdBzBzRVGd5bQl4+/4IjcNye600XRv7kjvn6p
         FTnddjXdWe5eWvYOmQV7p/co256zENtwAhZ5Vs0sOQN1dwmE5euQBrB3mL9B5eynMHSS
         wlkQeqzMmQIdLiA6l/sb14u+pvvGQpUEi3ZphiiMcHfmPaYuRNPcmIMna15MylUWFKZ0
         6oSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfuupa881jz/vuAJEYofzdtVkP3hZ0kGGpRBcttTCatDJ+EodMrxraAK4KTJ/ab/4GBK1DRy8rGX28@vger.kernel.org, AJvYcCX/q0o5K1umi9Y6kFfB0sGtaE1OUfBiJulYW0VEEU6HpCaof4ktLGf3Ypgw1BHTUTxsWZxPw4eOZjPja+fc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz51u27/V5u0yVy1sqP5qJWHd8xp8xLrgn3GIBT3Yt9zCFfLDN5
	orK+Diyx1M8CdNfE777GuStjmtabOKXwyOabAT8nDjMJKkUJHPB91c5imS3LbptyzFkQ/7S663W
	Yo+cJKM0MhhFHf0KLOBh9Dk2UI2ZOp2E=
X-Gm-Gg: ASbGncsJ1zItnaw45s1nhEKaOgGKnJSypIwYMkAZlyJkXX9P9Oes6l/8TXYmPOyhVGE
	dtKHihId5Qo/NISXYYZfdf4CzwFvDiGYt0co0WaLbos3NP0pOuWpNSVSR240OUJaLY5dz/m8+WQ
	DnItLTxSxLxXjrHiGILX5X6Jwjj/INMxzcdrpLRb5V8DdHb0WxjvJr8QatAh/EETJzpeXhPdl6N
	mM=
X-Google-Smtp-Source: AGHT+IE9+jlljfPXM/88q+TkseTtoiDACRH3uFb0C/2thZeqgCTgo/nVIfR1NuuvdZ2+k3yXMukkoHbLoYvwhWZA0TU=
X-Received: by 2002:a05:651c:f09:b0:308:e956:66e with SMTP id
 38308e7fff4ca-3280831bac4mr30245401fa.0.1747669307054; Mon, 19 May 2025
 08:41:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
 <860a4f7600814b17e48dbabe1ae19f68@manguebit.com> <CAH2r5mvo1e3034LpCWUAuE0=dDBb7R0bMCmt80dGRWKMegRV+Q@mail.gmail.com>
 <c1e693c6-573f-49d4-b6cf-cc308c339f06@huawei.com>
In-Reply-To: <c1e693c6-573f-49d4-b6cf-cc308c339f06@huawei.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 19 May 2025 10:41:33 -0500
X-Gm-Features: AX0GCFtizYdCmu5in-fWZZPBKKx3HOZU4qXQW9kORdVtzaAksj5OdLPKCCuTpXU
Message-ID: <CAH2r5mvoS8Py_M95+i0hB2iP06Uqz5JQbb13schBfdmJ6NzL3g@mail.gmail.com>
Subject: Re: [PATCH V2 0/2] smb: client: Fix use-after-free in readdir
To: Wang Zhaolong <wangzhaolong1@huawei.com>
Cc: Paulo Alcantara <pc@manguebit.com>, sfrench@us.ibm.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I was able to reproduce it by running the reproducer poc much longer

[189335.643181] Key type cifs.idmap unregistered
[189335.643203] Key type cifs.spnego unregistered
[189335.649519] CIFS: VFS: kmem_cache_destroy small req cachep
[189335.656316]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
[189335.656320] BUG cifs_small_rq (Tainted: G    B   W  OE      ):
Objects remaining on __kmem_cache_shutdown()
[189335.656322]
---------------------------------------------------------------------------=
--

[189335.656324] Object 0x000000001a39cfef @offset=3D15232
[189335.656326] Slab 0x00000000479475fe objects=3D36 used=3D1
fp=3D0x0000000090941d36
flags=3D0x17ffffc0000240(workingset|head|node=3D0|zone=3D2|lastcpupid=3D0x1=
fffff)
[189335.656334] ------------[ cut here ]------------
[189335.656335] WARNING: CPU: 1 PID: 84118 at mm/slub.c:1135
__slab_err+0x1d/0x30
....
[189335.656512]  [last unloaded: cifs(OE)]
[189335.656516] CPU: 1 UID: 0 PID: 84118 Comm: rmmod Tainted: G    B
W  OE       6.15.0-061500rc4-generic #202504272253 PREEMPT(voluntary)
[189335.656520] Tainted: [B]=3DBAD_PAGE, [W]=3DWARN, [O]=3DOOT_MODULE,
[E]=3DUNSIGNED_MODULE
[189335.656521] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET70W (1.53 ) 03/11/2024
[189335.656522] RIP: 0010:__slab_err+0x1d/0x30
[189335.656525] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44
00 00 55 48 89 e5 e8 72 ff ff ff be 01 00 00 00 bf 05 00 00 00 e8 33
b2 1c 00 <0f> 0b 5d 31 f6 31 ff c3 cc cc cc cc 0f 1f 80 00 00 00 00 90
90 90
[189335.656527] RSP: 0018:ffffcf3041b33a18 EFLAGS: 00010046
[189335.656529] RAX: 0000000000000000 RBX: ffffcf3041b33a60 RCX:
0000000000000000
[189335.656530] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[189335.656531] RBP: ffffcf3041b33a18 R08: 0000000000000000 R09:
0000000000000000
[189335.656533] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff8c1b49eb7600
[189335.656534] R13: ffff8c1b4ccd9580 R14: dead000000000122 R15:
ffff8c1b4ccd9580
[189335.656535] FS:  00007d912677e080(0000) GS:ffff8c2312b1b000(0000)
knlGS:0000000000000000
[189335.656537] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[189335.656538] CR2: 000061c8bedf4778 CR3: 00000003f2b4a001 CR4:
00000000003726f0
[189335.656540] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[189335.656541] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[189335.656542] Call Trace:
[189335.656543]  <TASK>
[189335.656546]  free_partial.cold+0x137/0x191
[189335.656550]  __kmem_cache_shutdown+0x46/0xa0
[189335.656553]  kmem_cache_destroy+0x3e/0x1c0
[189335.656558]  cifs_destroy_request_bufs+0x5c/0x70 [cifs]
[189335.656618]  exit_cifs+0x3a/0xef0 [cifs]
[189335.656666]  __do_sys_delete_module.isra.0+0x19d/0x2e0
[189335.656671]  __x64_sys_delete_module+0x12/0x20
[189335.656674]  x64_sys_call+0x1765/0x2320
[189335.656677]  do_syscall_64+0x7e/0x210
[189335.656679]  ? __fput+0x1a2/0x2d0
[189335.656681]  ? kmem_cache_free+0x408/0x470
[189335.656684]  ? __fput+0x1a2/0x2d0
[189335.656686]  ? arch_exit_to_user_mode_prepare.isra.0+0x22/0xd0
[189335.656689]  ? syscall_exit_to_user_mode+0x38/0x1d0
[189335.656692]  ? do_syscall_64+0x8a/0x210
[189335.656695]  ? do_read_fault+0xfb/0x230
[189335.656698]  ? do_fault+0x15d/0x220
[189335.656699]  ? handle_pte_fault+0x140/0x210
[189335.656702]  ? __handle_mm_fault+0x3cd/0x790
[189335.656705]  ? __count_memcg_events+0xd3/0x1a0
[189335.656708]  ? count_memcg_events.constprop.0+0x2a/0x50
[189335.656710]  ? handle_mm_fault+0x1ca/0x2e0
[189335.656713]  ? do_user_addr_fault+0x2f8/0x830
[189335.656716]  ? arch_exit_to_user_mode_prepare.isra.0+0x22/0xd0
[189335.656719]  ? irqentry_exit_to_user_mode+0x2d/0x1d0
[189335.656722]  ? irqentry_exit+0x43/0x50
[189335.656724]  ? exc_page_fault+0x96/0x1e0
[189335.656727]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[189335.656729] RIP: 0033:0x7d9125f2ac9b
[189335.656731] Code: 73 01 c3 48 8b 0d 7d 81 0d 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 4d 81 0d 00 f7 d8 64 89
01 48
[189335.656732] RSP: 002b:00007ffe9b9656f8 EFLAGS: 00000206 ORIG_RAX:
00000000000000b0
[189335.656735] RAX: ffffffffffffffda RBX: 00005eb63e457720 RCX:
00007d9125f2ac9b
[189335.656736] RDX: 0000000000000000 RSI: 0000000000000800 RDI:
00005eb63e457788
[189335.656737] RBP: 00007ffe9b965720 R08: 1999999999999999 R09:
0000000000000000
[189335.656738] R10: 00007d9125fb1fc0 R11: 0000000000000206 R12:
0000000000000000
[189335.656740] R13: 00007ffe9b965970 R14: 00005eb63e457720 R15:
0000000000000000
[189335.656743]  </TASK>
[189335.656744] ---[ end trace 0000000000000000 ]---
[189335.656803] ------------[ cut here ]------------
[189335.656804] kmem_cache_destroy cifs_small_rq: Slab cache still has
objects when called from cifs_destroy_request_bufs+0x5c/0x70 [cifs]
[189335.656861] WARNING: CPU: 1 PID: 84118 at mm/slab_common.c:525
kmem_cache_destroy+0x152/0x1c0

....

On Sun, May 18, 2025 at 9:56=E2=80=AFPM Wang Zhaolong <wangzhaolong1@huawei=
.com> wrote:
>
>
>
>
>
> > Merged into cifs-2.6.git for-next
> >
> > I was only able to reproduce the rmmod problem once though (without
> > the patch) so been tricky to test.  What server were you testing
> > against (I tried current Samba and ksmbd)?
> >
>
> I initialized the Samba server using the `samba` package provided by the
> Debian Trixie distribution.
>
> Best regards,
> Wang Zhaolong



--=20
Thanks,

Steve
