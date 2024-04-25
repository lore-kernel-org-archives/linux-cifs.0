Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF70F513
	for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 16:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714063969; cv=none; b=nfyXok62ELJ474dILPrWgVlmT9nh2FLFs+1DIg0cjU4pR4R8QED3IMyz2fTE84sggw6lLDlBiLOp82uame41uG6UuDmTKeifZ4r8VBrtKCu26MftcIgb9vpgKXtWrdfFcKSfA3IKJwMPRCDSagPqbOd4a7g6TZTBjeZMIwbaA6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714063969; c=relaxed/simple;
	bh=h5ucqFVd9BxOaSTvDdUMj4SZHc6HLgDQGiib3CqpCgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l8kLohXP/WTrp7aTzalQUiKPKLMetWI24wp8a4Dk5gcyzmpiIii0CEfZseAOuCVXi0oyczjp9F6IHnd5Wol5QfckcRJJOKEs4XiuQlIByfyMBu2rZODwCfOnJmXdSWCp0iBQ6Q9AXHpuM9ORRTGUO9EKe+7rWn5SAzv0B8qi8KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y3EuT51l; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3EuT51l"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5196c755e82so1556325e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2024 09:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714063966; x=1714668766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lIV0QVqv5MX4RsBpVHQVLFs+2NqMrMEgLrBNJ9purw=;
        b=Y3EuT51lUChDSD3bSplf4xmpr8CqaWxr37sTj1WfgncKH8c0FYU8zTHO8I8HUTIwMv
         YXm765nCFBDslUILLkQBOyWl8nqX6PStjhIJ31g17uBPJP58j65weydCmgLdQIShj5Lz
         29V/Z4kkMXfwbWPVWPi9RvftfebXmwZqPpBPnBpX5kwnLS5L3JV2ysiOMw9a9C35xC9Z
         +GH6uf5OAjIeO/BQIy4x942A2RBvfeW0eKvB5u0farIrY9+di0+4SZ7l9cbXQooAjvG1
         JqXZ6p1eNzBnCmzjye60ZeUv7ga4wSxnuV1/smnS/GXgmY55xlYyhSA/SAZ2pvWBDJMV
         V08A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714063966; x=1714668766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7lIV0QVqv5MX4RsBpVHQVLFs+2NqMrMEgLrBNJ9purw=;
        b=GdhOuXS0CN+UaHD36y9jBzayzdzlONYm204TpdVvWcVsO+xpkEixgRR6whF4dj/MBl
         PAiWtYIl+t+JjW+BklnJ6ow0qC2aaoeT56ylgGrJxMCrupi8XtcunJHisep5GBVB4b/X
         S0zccO2u+EvNJi3fWw0Iu7X4wCR+7oi28us92p3YYmiX1bpanS46lH6X2g5lWnnNwXIV
         zgA7Hqs4966WjbLjLh/Y8ivmxrGg76EoB3aSrUdu7G1E4YT/yxak1oA46IdVRVF9qYOX
         cJNZHZ6LGwhNyIf8FivPOEdhUGqLwrkSiRx2Nhvlts+AvEbF8XeLh9Rk2Zsg/b7pcUcd
         Gj5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVo77H1A8SQ6L4tHyx216jQo1hMd1sLV0nUrOZW+mz/Ab22T5kg2hD4MvdyKwUrKbflugKCx2MChp4zclihVhVDkoPTuai0RxUwDQ==
X-Gm-Message-State: AOJu0YxXVDs9SZNMO0pWeQFUmbZFGlko3i5hojgVWVpXRwWPiPhKXWbo
	bf+H+riStf29+bPz5/ToMS3dtOCrMfr9VyYcO4VrZonMxr4L4HdECq+FVPXGG9SjQFCa63TTqHo
	891uUYAP4o/WGDrIAPVLSK7lvPHE9grzi
X-Google-Smtp-Source: AGHT+IG4abPtUfMFXPyvj8Ri0Zr9ea1JfcYSSpUrUMcdWJtUr93ir4mRZql7Vv38PnFdd0LRPEhRrECiJxdDiTqEjHI=
X-Received: by 2002:ac2:42ca:0:b0:516:d47d:34b9 with SMTP id
 n10-20020ac242ca000000b00516d47d34b9mr4062251lfl.22.1714063965981; Thu, 25
 Apr 2024 09:52:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+EPQ66bhvV_Wr2PE=bQQwcYbfvXCAn_TyAoHdD9fSfahsgG0Q@mail.gmail.com>
 <CAH2r5msff67=91uRWPXRoyDrAko4EJtqAh0YsHfa_3t4Uxryfw@mail.gmail.com> <CA+EPQ664FHmSU-XW2e63jz1hEYNYVS-RdY6309g7-hvUMdt5Ew@mail.gmail.com>
In-Reply-To: <CA+EPQ664FHmSU-XW2e63jz1hEYNYVS-RdY6309g7-hvUMdt5Ew@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 25 Apr 2024 22:22:33 +0530
Message-ID: <CANT5p=rMOeJjj9B4t_riTtjDqzJ2xad9oNBNwLTpSyacq6A5cg@mail.gmail.com>
Subject: Re: Kernel RIP 0010:cifs_flush_folio
To: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, sprasad@microsoft.com, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 12:05=E2=80=AFPM Ritvik Budhiraja
<budhirajaritviksmb@gmail.com> wrote:
>
> The test that failed was generic/074, with: Output mismatch;
> Write failed at offset 9933824, Write failed at offset 9961472,
> Write failed at offset 9950208. The kernel version for the machine
> was Ubuntu 22.04, 6.5.0-1018-azure
>
> The target server was Azure Files XNFS

Correction. The server for the test that generated this stack would be
Azure Files SMB. Not NFS.

>
> On Thu, 25 Apr 2024 at 11:53, Steve French <smfrench@gmail.com> wrote:
>>
>> That is plausible that it is the same bug as in the report.  What
>> kernel version is the xfstest failure on (and which xfstest)?
>>
>> Presumably this does not fail with recent kernels (e.g. 6.7 or later) co=
rrect?
>>
>> Since this is clone range (which not all servers support), what is the
>> target server (ksmbd? Samba on btrfs? Windows on REFS?)
>>
>> On Thu, Apr 25, 2024 at 1:14=E2=80=AFAM Ritvik Budhiraja
>> <budhirajaritviksmb@gmail.com> wrote:
>> >
>> > Hi Steve,
>> > While investigating xnfstest results I came across the below kernel oo=
ps. I have seen this in some of the xfstest failures. I wanted to know if t=
his is a known issue?
>> >
>> > I have identified a similar ubuntu bug:  Bug #2060919 =E2=80=9Ccifs: C=
opying file to same directory results in pa...=E2=80=9D : Bugs : linux pack=
age : Ubuntu (launchpad.net)
>> >
>> > Reference dmesg logs:
>> > BUG: unable to handle page fault for address: fffffffffffffffe
>> > [Tue Apr 23 09:22:02 2024] #PF: supervisor read access in kernel mode
>> > [Tue Apr 23 09:22:02 2024] #PF: error_code(0x0000) - not-present page
>> > [Tue Apr 23 09:22:02 2024] PGD 19d43b067 P4D 19d43b067 PUD 19d43d067 P=
MD 0
>> > [Tue Apr 23 09:22:02 2024] Oops: 0000 [#68] SMP NOPTI
>> > [Tue Apr 23 09:22:02 2024] CPU: 1 PID: 3856364 Comm: fsstress Tainted:=
 G      D            6.5.0-1018-azure #19~22.04.2-Ubuntu
>> > [Tue Apr 23 09:22:03 2024] Hardware name: Microsoft Corporation Virtua=
l Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 11/28/2023
>> > [Tue Apr 23 09:22:03 2024] RIP: 0010:cifs_flush_folio+0x41/0xe0 [cifs]
>> > [Tue Apr 23 09:22:03 2024] Code: 49 89 cd 31 c9 41 54 53 48 89 f3 48 c=
1 ee 0c 48 83 ec 10 48 8b 7f 30 44 89 45 d4 e8 29 61 8e c6 49 89 c4 31 c0 4=
d 85 e4 74 7d <49> 8b 14 24 b8 00 10 00 00 f7 c2 00 00 01 00 74 12 41 0f b6=
 4c 24
>> > [Tue Apr 23 09:22:03 2024] RSP: 0018:ffffb182c3d3fcc0 EFLAGS: 00010282
>> > [Tue Apr 23 09:22:03 2024] RAX: 0000000000000000 RBX: 0000000011d00000=
 RCX: 0000000000000000
>> > [Tue Apr 23 09:22:03 2024] RDX: 0000000000000000 RSI: 0000000000011d00=
 RDI: ffffb182c3d3fc10
>> > [Tue Apr 23 09:22:03 2024] RBP: ffffb182c3d3fcf8 R08: 0000000000000001=
 R09: 0000000000000000
>> > [Tue Apr 23 09:22:03 2024] R10: 0000000011cfffff R11: 0000000000000000=
 R12: fffffffffffffffe
>> > [Tue Apr 23 09:22:03 2024] R13: ffffb182c3d3fd48 R14: ffff994311023c30=
 R15: ffffb182c3d3fd40
>> > [Tue Apr 23 09:22:03 2024] FS:  00007c82b3e10740(0000) GS:ffff9944b7d0=
0000(0000) knlGS:0000000000000000
>> > [Tue Apr 23 09:22:03 2024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080=
050033
>> > [Tue Apr 23 09:22:03 2024] CR2: fffffffffffffffe CR3: 00000001acb52000=
 CR4: 0000000000350ee0
>> > [Tue Apr 23 09:22:03 2024] Call Trace:
>> > [Tue Apr 23 09:22:03 2024]  <TASK>
>> > [Tue Apr 23 09:22:03 2024]  ? show_regs+0x6a/0x80
>> > [Tue Apr 23 09:22:03 2024]  ? __die+0x25/0x70
>> > [Tue Apr 23 09:22:03 2024]  ? page_fault_oops+0x79/0x180
>> > [Tue Apr 23 09:22:03 2024]  ? srso_return_thunk+0x5/0x10
>> > [Tue Apr 23 09:22:03 2024]  ? search_exception_tables+0x61/0x70
>> > [Tue Apr 23 09:22:03 2024]  ? srso_return_thunk+0x5/0x10
>> > [Tue Apr 23 09:22:03 2024]  ? kernelmode_fixup_or_oops+0xa2/0x120
>> > [Tue Apr 23 09:22:03 2024]  ? __bad_area_nosemaphore+0x16f/0x280
>> > [Tue Apr 23 09:22:03 2024]  ? terminate_walk+0x97/0xf0
>> > [Tue Apr 23 09:22:03 2024]  ? bad_area_nosemaphore+0x16/0x20
>> > [Tue Apr 23 09:22:03 2024]  ? do_kern_addr_fault+0x62/0x80
>> > [Tue Apr 23 09:22:03 2024]  ? exc_page_fault+0xdb/0x160
>> > [Tue Apr 23 09:22:03 2024]  ? asm_exc_page_fault+0x27/0x30
>> > [Tue Apr 23 09:22:03 2024]  ? cifs_flush_folio+0x41/0xe0 [cifs]
>> > [Tue Apr 23 09:22:03 2024]  cifs_remap_file_range+0x16c/0x5e0 [cifs]
>> > [Tue Apr 23 09:22:03 2024]  do_clone_file_range+0x107/0x290
>> > [Tue Apr 23 09:22:03 2024]  vfs_clone_file_range+0x3f/0x120
>> > [Tue Apr 23 09:22:03 2024]  ioctl_file_clone+0x4d/0xa0
>> > [Tue Apr 23 09:22:03 2024]  do_vfs_ioctl+0x35c/0x860
>> > [Tue Apr 23 09:22:03 2024]  __x64_sys_ioctl+0x73/0xd0
>> > [Tue Apr 23 09:22:03 2024]  do_syscall_64+0x5c/0x90
>> > [Tue Apr 23 09:22:03 2024]  ? srso_return_thunk+0x5/0x10
>> > [Tue Apr 23 09:22:03 2024]  ? exc_page_fault+0x80/0x160
>> > [Tue Apr 23 09:22:03 2024]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve

I reviewed the launchpad bug. This problem seems to be well understood.
The problem seems to be well understood:
>>> Since the Ubuntu mantic kernel consumes both 6.1.y and 6.7.y / 6.8.y st=
able patches, this patch was applied to mantic's 6.5 kernel by mistake, and=
 contains the wrong logic for how __filemap_get_folio() works in 6.5.
So the order of backport application seems to have led to this problem.

--=20
Regards,
Shyam
