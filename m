Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F141F8F1A
	for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2024 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732727542; cv=none; b=dcXD12mfD8q6yCE4i3qWtsWxli6KjVF+rNu6RNp3jJvvsyteA9taoS30w0vJCaGP/ULi+ZEBuS26w9UqCwv+Bcc38h/FK5DCzHavGcQBUYaXea6LHVuIkRNMO74/aydrOb4/AprWvEmLh6MMDLAXQCRfYPz5ruF5IIWQwERlrBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732727542; c=relaxed/simple;
	bh=dn1peMP/zWb6BG2Mcwg2Cev6BMwSA8iW1rSGVAMMNPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uMVvyW9dNqngiH+vMc/1dY68NgGxQekdBSJGWmZKiV/GtpxI8YseHZsbX2GgePPvy8b8S8r/kLEt0pyQ/nVFtI7kH1RD4lkwKLgL3VVxudLmXOpNy4CCXCwtrVm5/8RAw9XBqJUQki4wkKdiLSgWm1WwzbLDktvJR/mNUktHgus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeeF3sYl; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeeF3sYl"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53dd57589c8so1117370e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2024 09:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732727539; x=1733332339; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vvCKpmcEvqvIZh4e0NIcovBLoe8p98fysY7W937IDE=;
        b=WeeF3sYlyQDipYfXRaRCdkJ9C3sMCsC65MmtV4NniGg7xaKAsVGKQTPduyWc6M32WM
         ZDibQM76hF7Iwg0lKOKOG2TYDgCh8WWNjiALKAgI69Kf3pFSQrhCugM2Ei16C7A6pCAb
         AEzN2Im+9kF/hjLXWDaq5oL+iMuMg6wWZwr6eoQ0REhmIExnXqGqF8zAmKrxJqmnSEDI
         E7inVTSEpM5sD7Tu/QWl3+/JQJ1zFHlCDWnoNwJYxnXbVe6kqd18VhB0Cw8EUkZUI2XC
         8eWDxbUrJNnMNBKZq39R6Ll8Fk5m8iRtHjaB0UXP1xdcj5vBs5ndw/LLpkFHPSWl+Goj
         /Emg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732727539; x=1733332339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vvCKpmcEvqvIZh4e0NIcovBLoe8p98fysY7W937IDE=;
        b=T74rlQ6Jbyqel+2NBwBAvlUpESsI+A+yJlwvIHoRmSCNT0JqsZaKdiQj6iEhjTJsSH
         xK0T0Q2+CMTCjpMepzTahRot+2UXuyqLzsXZVyA7Lc9rYDtBB6tesK4EXgIU2bWlKQRO
         tPIGrDiUtkOcSD94qrMV9a1sd1yzC8ScV3gLZOUIxN8bpBmThB750D3mTbLpTPvxBKoY
         5ESrApFa/UrnN/Vc901560VakUU4z2rXbCwv//NM1OzAVvq+1ttISgzLQ4vH1iSyRWSv
         gVvwYhBmRbJ45UYbQ8vHO+D7TiTeuqUXxzWVOWAcOBCAjoqX4i49exzSb6h7bjF+30XJ
         +how==
X-Forwarded-Encrypted: i=1; AJvYcCXjB5RcYXBjnM2M+sTHxBqn10v8PhpyFjUovpICqSFZ0y0mrLrt0fEc25gaWm+K0RQHoXOtXqIRFo7w@vger.kernel.org
X-Gm-Message-State: AOJu0YxkB7o5Bae6XHiM+2hbGMrSfYxU0UKHpi7TyoLl5V2UlkOT2Hpd
	T23rbLgezWVNkplFUnYeMmclyYd0h0UWgSdevxGF0Re+A7sUBj2rqOJKHOExOi2tBrBnSM9j7jp
	6HAYuLx0Jtv7DMRMOEU6sioJs9mo=
X-Gm-Gg: ASbGncuTPeoKVEsUoM4VSXa4N99eg8M6dRNhMQHsYD9PSwJVo7DkffvIjOKeMDsvZxQ
	fwTYa7QRMehda3Kte4ZZt1yRYzECJLUBRwiL7go2GrTI9/1LAW56mw91v1JlpfTfmYQ==
X-Google-Smtp-Source: AGHT+IGFkIDpNUJuZvXB6abdVwE+V2+Nh2CYY1ppw7XFMnTvHy2UR15wCQMfhP1x6mG9inLHwVLTFOU00PnyemDQVC8=
X-Received: by 2002:a05:6512:1387:b0:53d:e8ed:2b08 with SMTP id
 2adb3069b0e04-53df507805amr58757e87.20.1732727538632; Wed, 27 Nov 2024
 09:12:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118215028.1066662-1-paul@darkrain42.org> <20241118215028.1066662-5-paul@darkrain42.org>
 <2a818d91e9f3c392b2739a4c2a018085@manguebit.com> <Z0FL4kIUiCMFDVfe@vaarsuvius.home.arpa>
 <Z0Y_o2nH16BynCO5@haley.home.arpa> <CAH2r5ms8TmNZ+7DCY8RzUoL+v4Yhnu7BVh--H+PoYrdFDji5+g@mail.gmail.com>
 <l6dfqnk6w5lq55e57uosgntpdtyr7gxpv5kshjanpbvons7y6c@mh77z33tl63n>
In-Reply-To: <l6dfqnk6w5lq55e57uosgntpdtyr7gxpv5kshjanpbvons7y6c@mh77z33tl63n>
From: Steve French <smfrench@gmail.com>
Date: Wed, 27 Nov 2024 11:12:07 -0600
Message-ID: <CAH2r5mtNmSFSgDBBVtfGuXQvDdFFF8FLrivS1zLZHQCJ=vvf+g@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] smb: During unmount, ensure all cached dir
 instances drop their dentry
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, 
	Steve French <sfrench@samba.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 11:07=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de=
> wrote:
>
> On 11/27, Steve French wrote:
> >I did see the generic/241 failure again with current for-next
> >(unrelated to this patch though).  Will try to repro it again - but
> >any ideas how to narrow it down or fix it would be helpful.
>
> We're seeing this too when backporting that patch series to SLE15-SP6,
> by only running generic/072, so I don't think it's unrelated.
>
> We also hit, also with generic/072, but only once, the WARN() in
> cached_dir_offload_close() (introduced in this same patch):
>
>      [  526.946722] WARNING: CPU: 2 PID: 23778 at fs/smb/client/cached_di=
r.c:555 cached_dir_offload_close+0x90/0xa0 [cifs]
>      [  526.948561] Modules linked in: cifs cifs_arc4 cifs_md4
>      [  526.949385] CPU: 2 PID: 23778 Comm: kworker/2:1 Kdump: loaded Not=
 tainted 6.4.0-lku #91 SLE15-SP6 (unreleased)
>      [  526.949394] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), B=
IOS rel-1.16.3-2-gc13ff2cd-prebuilt.qemu.org 04/01/2014
>      [  526.949398] Workqueue: serverclose cached_dir_offload_close [cifs=
]
>      [  526.951938] RIP: 0010:cached_dir_offload_close+0x90/0xa0 [cifs]
>      [  526.953827] Code: e8 a5 fb ff ff 4c 89 e7 5b 5d 41 5c e9 99 57 fc=
 ff 48 89 ef be 03 00 00 00 e8 5c d4 c5 c9 4c 89 e7 5b 5d 41 5c e9 80 57 fc=
 ff <0f> 0b eb 99 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
>      [  526.953836] RSP: 0018:ffff888108b7fdd8 EFLAGS: 00010202
>      [  526.953844] RAX: 0000000000000000 RBX: ffff888100de68d0 RCX: ffff=
ffffc042e7d4
>      [  526.953849] RDX: 1ffff110201bcd04 RSI: 0000000000000008 RDI: ffff=
888100de6820
>      [  526.953854] RBP: ffff8881063d8a00 R08: 0000000000000001 R09: ffff=
ed10201bcd1a
>      [  526.953858] R10: ffff888100de68d7 R11: 0000000000000000 R12: ffff=
888100a2b000
>      [  526.953862] R13: 0000000000000080 R14: ffff88814f336ea8 R15: ffff=
888100de68d8
>      [  526.953872] FS:  0000000000000000(0000) GS:ffff88814f300000(0000)=
 knlGS:0000000000000000
>      [  526.965888] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>      [  526.965897] CR2: 00007f841e6ea698 CR3: 0000000106c68000 CR4: 0000=
000000750ee0
>      [  526.965904] PKRU: 55555554
>      [  526.965908] Call Trace:
>      [  526.965912]  <TASK>
>      [  526.965917]  ? __warn+0x92/0xf0
>      [  526.965932]  ? cached_dir_offload_close+0x90/0xa0 [cifs]
>      [  526.972634]  ? report_bug+0x163/0x190
>      [  526.972652]  ? handle_bug+0x3a/0x70
>      [  526.972665]  ? exc_invalid_op+0x17/0x40
>      [  526.972674]  ? asm_exc_invalid_op+0x1a/0x20
>      [  526.972688]  ? cached_dir_offload_close+0x24/0xa0 [cifs]
>      [  526.977239]  ? cached_dir_offload_close+0x90/0xa0 [cifs]
>      [  526.978831]  ? cached_dir_offload_close+0x24/0xa0 [cifs]
>      [  526.979133]  process_one_work+0x42c/0x730
>      [  526.979176]  worker_thread+0x8e/0x700
>      [  526.979190]  ? __pfx_worker_thread+0x10/0x10
>      [  526.979200]  kthread+0x197/0x1d0
>      [  526.979208]  ? kthread+0xeb/0x1d0
>      [  526.979216]  ? __pfx_kthread+0x10/0x10
>      [  526.979225]  ret_from_fork+0x29/0x50
>      [  526.979237]  </TASK>
>      [  526.979241] ---[ end trace 0000000000000000 ]---
>
> Will update here if we find a fix/root cause.
>
>
> Cheers,
>
> Enzo

Presumably it is related to the dir lease series but one of the
earlier ones not the most recent one, since we saw it running before -
but without the patch series we saw the unmount crash when racing with
freeing cached dentries so would be helpful to narrow the bug down so
we can fix the original problem that has been around for quite a while
now - especially important now that more servers will be enabling
directory leases (e.g. Samba can now be tested against)




--=20
Thanks,

Steve
