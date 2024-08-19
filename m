Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F0315A84A
	for <linux-cifs@vger.kernel.org>; Mon, 19 Aug 2024 22:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105262; cv=none; b=LkSJXgIYu82hEqE3UsryoiCRsRmo5DbpRRuQ0PwKApvilU14+ibJbcOOO4dvAtn5SOVpVudTNaq8wjQsP+WEVUPMwQpKuVnfaDeW4LhzCQk3v95G//LRrant/mrV1qS2a6PyvTYdPAn8INTei1N58FDe9GSeaFv3hL77rAqtrx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105262; c=relaxed/simple;
	bh=91dSMPu8LGw57t87hPuXZ8dHD1o0PYj4pK18/bG1kI8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HYDc+PqNHWNY2dS/ucklWfqMC82nAq3Bier4zYDeIQAOFTPPvKZV+00eunUXYYEWpeAzsKyUBmrh3v7b+IEhA5mRCzWigjrUSx/VRNAlBw8pn+ifaLbM8s6UHQjoD/6756RpSarl2x+q4eYp9Fm3C/j1EEeo+vrFGaVGNKPXAsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEmKgS7p; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEmKgS7p"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5314c6dbaa5so6436101e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 19 Aug 2024 15:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724105258; x=1724710058; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g31SD6D0hDh/XssiYepevcf81paVI0B6X6PBwgyTQ6I=;
        b=QEmKgS7pw/yk7W7DcBKFBCO+N3P8W/1Q1CYmmnJswok5zhRwSh3SIMZUnYdlZ31xKw
         LCd2DbefmblLGTYjcIvMChTf3dCFrLiFmxbDNrZ82sqDj+bPmKEQ2HHyjlJ61vZVPWQJ
         cAAM4bFmvcCHVEGS8DwCdIUjFimlN+HqfFVBZOV32zhtsvhjKx4Tm5lLyVyqqGjNgDx1
         L7xTcsSBKHIrpSxwENNhg0Z79zRuKCg24AU2YhxarOGSvqIZ1Xl9gBTlSi845JgtdZzu
         Tt9ikwuDYAkbI3Q3LH/lsFOdVcouGFc/Yri/F7uy6M6H87S0/8+K1Wb7sFTW7g7MNHMR
         sP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724105258; x=1724710058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g31SD6D0hDh/XssiYepevcf81paVI0B6X6PBwgyTQ6I=;
        b=CX7B1Tuyci8OWxax8pMyCk5zc9EFDNQ4/P6McBxUAouayYzoMEPA07tYtKqk/oBHRR
         xFkLEVYQXzw1RRQvGYV6qJr4hXxs1BO8HyqzQdW3sApGsEKkKAC9YiwtKI2WgM7auQmj
         whkjY2aG51M9PcmYvuHse4LYhhpIj9oZhdoK/gLYp1qIz0+Z5ddFFRNZMKloxzDq7/74
         T6YC1sRiiPzLEBhjD+Q9loYpHG7GP/HYRBizFrNbHbxExdE29bcJ6H1WicduL3zaGArN
         Eo71Drji6+xgWFsGp1mbOwUg2nSZq3yH07MkJTsd/6zR/f3oUOpNxNdLjvJzwCsOKJ4c
         /4xw==
X-Forwarded-Encrypted: i=1; AJvYcCWbuFgCfhtzZFf8UvPKxWQWapoff50MKojCjARWov8zrURKEFpxDRBhoUxTiIUr91TVKBGn+wqaTAE7@vger.kernel.org
X-Gm-Message-State: AOJu0YzjpDsIX83zLVLFEKXSnYCPEgzNJTM8wCoK16dOYFA8sOK7jNrd
	oPf1HC2GsWk34uuRGmuhKlj6BvKwLxdAgxEf5ymmVrEVmqDUJ7gaMEIlvIk4MqoskRLddgfuw56
	u/KFkPyW0ZCYu0LiVAGPPAC0Dh/w=
X-Google-Smtp-Source: AGHT+IFaBCpytklBF4j4HWO0tqyQ1uNL7Q1iDg+BEC+QG4OenN3AmJAKfkUJKn0GYDBiu4qcwuLorYg8d8ZIBUoZ/Xo=
X-Received: by 2002:a05:6512:2310:b0:52c:adc4:137c with SMTP id
 2adb3069b0e04-5331c6a20d3mr7831798e87.20.1724105257829; Mon, 19 Aug 2024
 15:07:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv3VKSorLBNZUvUrbiOmTFDFw0YDWkL3iRLjaaRmYVTeA@mail.gmail.com>
 <CAH2r5ms_RiykdukHNefZO2GciuDcLvW6wFhPS37jnrpMtpqYJQ@mail.gmail.com>
In-Reply-To: <CAH2r5ms_RiykdukHNefZO2GciuDcLvW6wFhPS37jnrpMtpqYJQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 19 Aug 2024 17:07:26 -0500
Message-ID: <CAH2r5msT+YbMNMd+sUue69CVDkjuJzubkubYXC8HZA-GFW9Wxw@mail.gmail.com>
Subject: Re: Netfs failure
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I was able to repro the generic/210 regression to Samba server as well

[ 7884.205037] Workqueue: cifsiod smb2_readv_worker [cifs]
[ 7884.205262] RIP: 0010:netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
[ 7884.205299] Code: 01 00 00 e8 02 b4 07 df 4c 8b 4c 24 08 49 89 d8
4c 89 e9 41 8b b4 24 d4 01 00 00 44 89 f2 48 c7 c7 40 10 65 c1 e8 30
a9 b6 de <0f> 0b 48 8b 7c 24 18 4c 8d bd c0 00 00 00 e8 2d b5 07 df 48
8b 7c
[ 7884.205305] RSP: 0018:ff1100010705fce8 EFLAGS: 00010286
[ 7884.205312] RAX: dffffc0000000000 RBX: 0000000000001000 RCX: 00000000000=
00027
[ 7884.205317] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ff110004cb1=
b1a08
[ 7884.205322] RBP: ff11000119450900 R08: ffffffffa03e346e R09: ffe21c00996=
36341
[ 7884.205326] R10: ff110004cb1b1a0b R11: 0000000000000001 R12: ff11000137b=
68a80
[ 7884.205330] R13: 000000000000012c R14: 0000000000000001 R15: ff11000126a=
96f78
[ 7884.205335] FS:  0000000000000000(0000) GS:ff110004cb180000(0000)
knlGS:0000000000000000
[ 7884.205339] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7884.205344] CR2: 00007f0035f0a67c CR3: 000000000f664004 CR4: 00000000003=
71ef0
[ 7884.205354] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 7884.205359] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 7884.205363] Call Trace:
[ 7884.205367]  <TASK>
[ 7884.205373]  ? __warn+0xa4/0x220
[ 7884.205386]  ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
[ 7884.205423]  ? report_bug+0x1d4/0x1e0
[ 7884.205436]  ? handle_bug+0x42/0x80
[ 7884.205442]  ? exc_invalid_op+0x18/0x50
[ 7884.205449]  ? asm_exc_invalid_op+0x1a/0x20
[ 7884.205464]  ? irq_work_claim+0x1e/0x40
[ 7884.205475]  ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
[ 7884.205512]  ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
[ 7884.205554]  process_one_work+0x4cf/0xb80
[ 7884.205573]  ? __pfx_lock_acquire+0x10/0x10
[ 7884.205582]  ? __pfx_process_one_work+0x10/0x10
[ 7884.205599]  ? assign_work+0xd6/0x110
[ 7884.205609]  worker_thread+0x2cd/0x550
[ 7884.205622]  ? __pfx_worker_thread+0x10/0x10
[ 7884.205632]  kthread+0x187/0x1d0
[ 7884.205639]  ? __pfx_kthread+0x10/0x10
[ 7884.205648]  ret_from_fork+0x34/0x60
[ 7884.205655]  ? __pfx_kthread+0x10/0x10
[ 7884.205661]  ret_from_fork_asm+0x1a/0x30
[ 7884.205684]  </TASK>
[ 7884.205688] irq event stamp: 23635
[ 7884.205692] hardirqs last  enabled at (23641): [<ffffffffa022b58b>]
console_unlock+0x15b/0x170
[ 7884.205699] hardirqs last disabled at (23646): [<ffffffffa022b570>]
console_unlock+0x140/0x170
[ 7884.205705] softirqs last  enabled at (23402): [<ffffffffa0131a6e>]
__irq_exit_rcu+0xfe/0x120
[ 7884.205712] softirqs last disabled at (23397): [<ffffffffa0131a6e>]
__irq_exit_rcu+0xfe/0x120
[ 7884.205718] ---[ end trace 0000000000000000 ]---

On Mon, Aug 19, 2024 at 12:15=E2=80=AFAM Steve French <smfrench@gmail.com> =
wrote:
>
> Probably regression in rc4 affecting xfstest generic/125
>
> it also happened with multichannel with current mainline, but doesn't
> look like it happened with rc3
>
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
5/builds/207/steps/57/logs/stdio
>
> Is it possible it is related to this patch which is in the failing
> (rc4) branch but not in rc3 (where the test passes)?
>
> commit e3786b29c54cdae3490b07180a54e2461f42144c
> Author: Dominique Martinet <asmadeus@codewreck.org>
> Date:   Thu Aug 8 14:29:38 2024 +0100
>
>     9p: Fix DIO read through netfs
>
>     If a program is watching a file on a 9p mount, it won't see any chang=
e in
>     size if the file being exported by the server is changed directly in =
the
>     source filesystem, presumably because 9p doesn't have change notifica=
tions,
>     and because netfs skips the reads if the file is empty.
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index b2405dd4d4d4..3f3842e7b44a 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -217,7 +217,8 @@ static void cifs_req_issue_read(struct
> netfs_io_subrequest *subreq)
>                         goto out;
>         }
>
> -       __set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
> +       if (subreq->rreq->origin !=3D NETFS_DIO_READ)
> +               __set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
>
>         rc =3D rdata->server->ops->async_readv(rdata);
>  out:
> (END)
>
> On Sun, Aug 18, 2024 at 7:24=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > Do you recognize this netfs failure (generic/125) that I just saw with
> > current mainline
> >
> > http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builder=
s/9/builds/106/steps/54/logs/stdio
> >
> > [Sun Aug 18 18:40:43 2024] <TASK>
> > [Sun Aug 18 18:40:43 2024] ? __warn+0xa4/0x220
> > [Sun Aug 18 18:40:43 2024] ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs=
]
> > [Sun Aug 18 18:40:43 2024] ? report_bug+0x1d4/0x1e0
> > [Sun Aug 18 18:40:43 2024] ? handle_bug+0x42/0x80
> > [Sun Aug 18 18:40:43 2024] ? exc_invalid_op+0x18/0x50
> > [Sun Aug 18 18:40:43 2024] ? asm_exc_invalid_op+0x1a/0x20
> > [Sun Aug 18 18:40:43 2024] ? irq_work_claim+0x1e/0x40
> > [Sun Aug 18 18:40:43 2024] ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs=
]
> >
> > $ git log --oneline -3
> > b5e99e6c6dcd (HEAD -> for-next, origin/for-next) smb3: fix problem
> > unloading module due to leaked refcount on shutdown
> > e4be320eeca8 smb3: fix broken cached reads when posix locks
> > 47ac09b91bef (tag: v6.11-rc4, origin/master, origin/HEAD,
> > linus/master, master) Linux 6.11-rc4
> >
> >
> > Ideas?
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
