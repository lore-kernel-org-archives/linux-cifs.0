Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D3040C03
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 06:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714026227; cv=none; b=cFPkFjyrJJVBIrQHallautZTrs3f+mnc8Q38ss+3kgz0Fqir9+R/AIm2y89f9B/6KiQ5sHkeFCuZCibbWdWVvUqV/aTjoDW6ZdKAXQiCLTwZhRB9Uco5I+Yzj/4YRg/pi61h9ib30o8RJg0j2vf1z0SdyVGwP39wLiGe9QoHV2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714026227; c=relaxed/simple;
	bh=oG9S5Zd67gL2kShmJTtBPtw/6rQjCpKDBRHWjsmmaXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AsJIUfO5jDFZ8fru6GzXg64+wuMnhJ5XM3vMcS2mU+dHCHdkWnakh/b0NuxvDRKiv3uUG5F2cm6iuAEEjEKZpTd7RlGg/+FYIn3fYRsctKgDiS16BRX0fy8qrM9wV/1qJAksy6nEwTyZVS9NxhZbuoyUqgcrc6gEkvhLRIFboRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyLb+D4w; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyLb+D4w"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-51abd9fcbf6so922324e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 Apr 2024 23:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714026223; x=1714631023; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TxKP0V34umaeD6YbFD6ur8Hg9X4fYL4qiDVXET3dqHU=;
        b=CyLb+D4wADBNlWVNpjV4auenDmKAHAUm2ykUSoJKSHnnkjv2X8JyuEd0cAXw7BkFE6
         SZtTnXQ5THRBWxO3AHdaz8Ww8QMYb3j40QYASNr8iBiyQKUXIXjtnFm7vHJ+6tK57N4R
         Kz3I8Rgw+Nfso3IiDfneQv53XL01trJ9x4mNVQeqFNp/EY3iVR9nvQBtRcXUpZghIZ2c
         MajeMlghtCjRH/oIbUSwEkJgOezCUG7CAMY0PyV6rpPZE5GdgAZ+IK+5xi3ItQWIe0B4
         Dp5b1jQr2EKB42gtmFlqZZEcrcw3PthNnlzdhVQU+77dVKRqNfqZ8YkHU5IV/w2ig2i1
         zK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714026223; x=1714631023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TxKP0V34umaeD6YbFD6ur8Hg9X4fYL4qiDVXET3dqHU=;
        b=LOqFFlPbqUrtDpCPeVeHuLrbqyfIpwFU9ZD4idiNsAyppM8Iz4Ga2iI7egsuxEdJ7+
         CCAXlWr2nowSPwicaZj9wQCsKV1R259jgGe/C6yytWRdyqgJPN/FQow7ePoWKy2heGru
         iUVSWhhow0dTtpHc9lN79BpNM6Zgtz/2p5uf/hemeg1cfBszFl2090d/gbjrcjSIh3zm
         ke5rft06LV6G08kCcq69pU42zdPI31x+Q4fUNvK1gIvCZtSL4gf+Oo2A1NCjn5AF8/Lj
         XNz4m12H7NbWSrtG9SVnPYVpw++8j4ZGEA/lAihy7wGME4T6vL64XaoYr2lDpuD0TqMI
         BLvA==
X-Gm-Message-State: AOJu0YzxcDhUDDVukobvKE484dCq7ByqeX08A5QgY02Af3Ji3NFKHzI8
	qOke/ydTCoy6QdalRg3ZqcQojSlvSzPjB0oH5fxybt7RVWswxPMe5eD9iTfsv/h8e6Sf98rTCVX
	oxxZG3ANsC31vUsMnr4wkpmF7Ins=
X-Google-Smtp-Source: AGHT+IF9FdsWBJacGar/+LDo08Al1LEZl5bf8E2OUpO7N4YLYfcp9JvP+hOQJ0A8zTcDUs5CBRiu3u+Ea9TYl3EODTE=
X-Received: by 2002:a19:8c44:0:b0:519:76aa:5e68 with SMTP id
 i4-20020a198c44000000b0051976aa5e68mr3831416lfj.39.1714026223050; Wed, 24 Apr
 2024 23:23:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+EPQ66bhvV_Wr2PE=bQQwcYbfvXCAn_TyAoHdD9fSfahsgG0Q@mail.gmail.com>
In-Reply-To: <CA+EPQ66bhvV_Wr2PE=bQQwcYbfvXCAn_TyAoHdD9fSfahsgG0Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 25 Apr 2024 01:23:31 -0500
Message-ID: <CAH2r5msff67=91uRWPXRoyDrAko4EJtqAh0YsHfa_3t4Uxryfw@mail.gmail.com>
Subject: Re: Kernel RIP 0010:cifs_flush_folio
To: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Cc: linux-cifs@vger.kernel.org, Shyam Prasad <nspmangalore@gmail.com>, 
	sprasad@microsoft.com, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That is plausible that it is the same bug as in the report.  What
kernel version is the xfstest failure on (and which xfstest)?

Presumably this does not fail with recent kernels (e.g. 6.7 or later) corre=
ct?

Since this is clone range (which not all servers support), what is the
target server (ksmbd? Samba on btrfs? Windows on REFS?)

On Thu, Apr 25, 2024 at 1:14=E2=80=AFAM Ritvik Budhiraja
<budhirajaritviksmb@gmail.com> wrote:
>
> Hi Steve,
> While investigating xnfstest results I came across the below kernel oops.=
 I have seen this in some of the xfstest failures. I wanted to know if this=
 is a known issue?
>
> I have identified a similar ubuntu bug:  Bug #2060919 =E2=80=9Ccifs: Copy=
ing file to same directory results in pa...=E2=80=9D : Bugs : linux package=
 : Ubuntu (launchpad.net)
>
> Reference dmesg logs:
> BUG: unable to handle page fault for address: fffffffffffffffe
> [Tue Apr 23 09:22:02 2024] #PF: supervisor read access in kernel mode
> [Tue Apr 23 09:22:02 2024] #PF: error_code(0x0000) - not-present page
> [Tue Apr 23 09:22:02 2024] PGD 19d43b067 P4D 19d43b067 PUD 19d43d067 PMD =
0
> [Tue Apr 23 09:22:02 2024] Oops: 0000 [#68] SMP NOPTI
> [Tue Apr 23 09:22:02 2024] CPU: 1 PID: 3856364 Comm: fsstress Tainted: G =
     D            6.5.0-1018-azure #19~22.04.2-Ubuntu
> [Tue Apr 23 09:22:03 2024] Hardware name: Microsoft Corporation Virtual M=
achine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 11/28/2023
> [Tue Apr 23 09:22:03 2024] RIP: 0010:cifs_flush_folio+0x41/0xe0 [cifs]
> [Tue Apr 23 09:22:03 2024] Code: 49 89 cd 31 c9 41 54 53 48 89 f3 48 c1 e=
e 0c 48 83 ec 10 48 8b 7f 30 44 89 45 d4 e8 29 61 8e c6 49 89 c4 31 c0 4d 8=
5 e4 74 7d <49> 8b 14 24 b8 00 10 00 00 f7 c2 00 00 01 00 74 12 41 0f b6 4c=
 24
> [Tue Apr 23 09:22:03 2024] RSP: 0018:ffffb182c3d3fcc0 EFLAGS: 00010282
> [Tue Apr 23 09:22:03 2024] RAX: 0000000000000000 RBX: 0000000011d00000 RC=
X: 0000000000000000
> [Tue Apr 23 09:22:03 2024] RDX: 0000000000000000 RSI: 0000000000011d00 RD=
I: ffffb182c3d3fc10
> [Tue Apr 23 09:22:03 2024] RBP: ffffb182c3d3fcf8 R08: 0000000000000001 R0=
9: 0000000000000000
> [Tue Apr 23 09:22:03 2024] R10: 0000000011cfffff R11: 0000000000000000 R1=
2: fffffffffffffffe
> [Tue Apr 23 09:22:03 2024] R13: ffffb182c3d3fd48 R14: ffff994311023c30 R1=
5: ffffb182c3d3fd40
> [Tue Apr 23 09:22:03 2024] FS:  00007c82b3e10740(0000) GS:ffff9944b7d0000=
0(0000) knlGS:0000000000000000
> [Tue Apr 23 09:22:03 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033
> [Tue Apr 23 09:22:03 2024] CR2: fffffffffffffffe CR3: 00000001acb52000 CR=
4: 0000000000350ee0
> [Tue Apr 23 09:22:03 2024] Call Trace:
> [Tue Apr 23 09:22:03 2024]  <TASK>
> [Tue Apr 23 09:22:03 2024]  ? show_regs+0x6a/0x80
> [Tue Apr 23 09:22:03 2024]  ? __die+0x25/0x70
> [Tue Apr 23 09:22:03 2024]  ? page_fault_oops+0x79/0x180
> [Tue Apr 23 09:22:03 2024]  ? srso_return_thunk+0x5/0x10
> [Tue Apr 23 09:22:03 2024]  ? search_exception_tables+0x61/0x70
> [Tue Apr 23 09:22:03 2024]  ? srso_return_thunk+0x5/0x10
> [Tue Apr 23 09:22:03 2024]  ? kernelmode_fixup_or_oops+0xa2/0x120
> [Tue Apr 23 09:22:03 2024]  ? __bad_area_nosemaphore+0x16f/0x280
> [Tue Apr 23 09:22:03 2024]  ? terminate_walk+0x97/0xf0
> [Tue Apr 23 09:22:03 2024]  ? bad_area_nosemaphore+0x16/0x20
> [Tue Apr 23 09:22:03 2024]  ? do_kern_addr_fault+0x62/0x80
> [Tue Apr 23 09:22:03 2024]  ? exc_page_fault+0xdb/0x160
> [Tue Apr 23 09:22:03 2024]  ? asm_exc_page_fault+0x27/0x30
> [Tue Apr 23 09:22:03 2024]  ? cifs_flush_folio+0x41/0xe0 [cifs]
> [Tue Apr 23 09:22:03 2024]  cifs_remap_file_range+0x16c/0x5e0 [cifs]
> [Tue Apr 23 09:22:03 2024]  do_clone_file_range+0x107/0x290
> [Tue Apr 23 09:22:03 2024]  vfs_clone_file_range+0x3f/0x120
> [Tue Apr 23 09:22:03 2024]  ioctl_file_clone+0x4d/0xa0
> [Tue Apr 23 09:22:03 2024]  do_vfs_ioctl+0x35c/0x860
> [Tue Apr 23 09:22:03 2024]  __x64_sys_ioctl+0x73/0xd0
> [Tue Apr 23 09:22:03 2024]  do_syscall_64+0x5c/0x90
> [Tue Apr 23 09:22:03 2024]  ? srso_return_thunk+0x5/0x10
> [Tue Apr 23 09:22:03 2024]  ? exc_page_fault+0x80/0x160
> [Tue Apr 23 09:22:03 2024]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8



--=20
Thanks,

Steve
