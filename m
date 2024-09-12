Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331DA1AACA
	for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2024 01:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726103344; cv=none; b=HdiYBjWGB+rqBTmxuKb+1vsfM2eciSyLhKJaJXH22bX50zdsFpV0gGvs/4/mnYbc1lExahHwrYCvk7otvzGzOXk0M6TGDcrHfaLyx6qsHrcB2hDyV+uQfBth8pdmXfQUeu4xUO42JlfRN3DGgqTbjHBH6R8IymWu5aARsMpRfWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726103344; c=relaxed/simple;
	bh=hxa06s/XW2isCriVXXEIowyfadQhf06VGDAACN4xrDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IXAPACsjBW4Zrb0okeMysf0dQiDrL+DL012/OAijcq/j8GxuEIE2WIxw8tVQthncvxnmSQT6HCyuMfQ8gLTrPO8bmAi3XNADd9tht/3bSqceAnuhBHv5s/SC+d8omv+E0D+TTNFCZgsNROV+HP+E8xebjGnfaAnKakHHvPBir6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SIQETQst; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SIQETQst"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6c49c9018ebso3874347b3.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Sep 2024 18:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726103341; x=1726708141; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPbkqS0dN/28SdLH5frEKJREaA8MyChfHacympmDNnI=;
        b=SIQETQsts92tY2kftjr38G6HKtv8RhsWYyeJYWEQZkW2q7nR0JVVyibWysiNLtqent
         03yp4DfmRy2xck6k3747cLvX/4WbNCtRDj+M7VfMynjefFngz/DjhAzIcRc1oOwMGq+e
         9EJErDCJhsp2ZJvmbYgz6iXZVp72wZhyrFMwwQc2dVUUYEyhVZC+a4aKcDODlffNC+7f
         bynfeMGddcIJYoN8ivXagBdebIFBolIiNwf5lE1muSVPSFLJx+GQbTA7rgYimSppM4T+
         1fDkOOGqE7sq2UOr4l4deMH8ZJcS8v87Rm93yI9HfuNdz8mHamhmlAHjWRTtkAlLzebT
         N2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726103341; x=1726708141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cPbkqS0dN/28SdLH5frEKJREaA8MyChfHacympmDNnI=;
        b=UF69Qly+ewrzRAWD07H/qwkCGElJx0rRbwsoMIJlHz4IVLsqoNxqP9oZooPdNLZjgd
         unrflvzn6FHwhSZQT81v5LaGaIsy5PbarGRbM5g2wPAtCJ5Jo5tkkmbk2+VEuKL0Of63
         NxsklKzK5X1K/h2+6W/5NGDB1d/3e16aFV/QcOzKg9mc9sbmxbkwfczLo9uz9U6Plxw0
         X0vXBDV8o+g1lxUp/QE3id+OSR1MYJJu1LRwD0IHA4GFdeY6QiLRE3IU/QlhJ2VGRyxg
         bUbDVNlXIfVc9l6BA2taPySUhAr+DEiqtnprJsUFg4BAkAoWmiRRTDgKJTmwu5n8rO1a
         IZwg==
X-Forwarded-Encrypted: i=1; AJvYcCUMZsy3c8r4OU2uDUcqpIfnDmXVhpJ6MgmOh30AeZYAn5YI+MsJ5+WtLTAQSYF8IJdAZab6/c3oqkWP@vger.kernel.org
X-Gm-Message-State: AOJu0YyzB/VdP6+ZSUqqD+DlgDmeZcc5DQGsPzPAKXwOOvsX/vidrSbT
	4kVBFfGsyeGbJ1z8JOIA2s/88UOdqCG4JTtJXy4OOM4OFH9tWkALh5rJmHYWkoofTeUvl50PDXv
	aMnUtVQqPkAsszIT2hsiiPq4+gyA=
X-Google-Smtp-Source: AGHT+IFpxNY9E2nkZhPoEjon5CiZDM1iAoR9G7Yoa8K8yMzqlZAwzEwpsoEh9PxXq/jl/hZuuxd+RqW0rb6TY+T1xZg=
X-Received: by 2002:a05:690c:4a02:b0:6b5:916d:597 with SMTP id
 00721157ae682-6dbb6b236d4mr14343747b3.22.1726103341028; Wed, 11 Sep 2024
 18:09:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv3VKSorLBNZUvUrbiOmTFDFw0YDWkL3iRLjaaRmYVTeA@mail.gmail.com>
 <CAH2r5ms_RiykdukHNefZO2GciuDcLvW6wFhPS37jnrpMtpqYJQ@mail.gmail.com>
 <CAH2r5msT+YbMNMd+sUue69CVDkjuJzubkubYXC8HZA-GFW9Wxw@mail.gmail.com> <CADJHv_uWdLBVuaGR12udL-JZ_UQetM4jpLy+Ty-Bk8oFXmLsUA@mail.gmail.com>
In-Reply-To: <CADJHv_uWdLBVuaGR12udL-JZ_UQetM4jpLy+Ty-Bk8oFXmLsUA@mail.gmail.com>
From: Murphy Zhou <jencce.kernel@gmail.com>
Date: Thu, 12 Sep 2024 09:08:50 +0800
Message-ID: <CADJHv_vnQJH9FWRDgRYJrWgTiuo8=hm8knVnPq899d89cp-=Vg@mail.gmail.com>
Subject: Re: Netfs failure
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Dominique Martinet <asmadeus@codewreck.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Still happening after rc5 with Samba server:

[ 3619.698588] run fstests generic/210 at 2024-08-31 15:24:51
[ 3619.945375] ------------[ cut here ]------------
[ 3619.946891] Subreq overread: R9ad9[1] 1500 > 4096 - 3000
[ 3619.946934] WARNING: CPU: 0 PID: 772278 at fs/netfs/io.c:499
netfs_subreq_terminated+0x1fe/0x270 [netfs]
[ 3619.950061] Modules linked in: nls_utf8 cifs cifs_arc4
nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 nfsv4 dns_resolver nfs netfs
rpcrdma rdma_cm iw_cm ib_cm ib_core nfsd auth_rpcgss nfs_acl lockd
grace dm_log_writes rfkill intel_rapl_msr intel_rapl_common
intel_uncore_frequency_common sunrpc kvm_intel snd_hda_codec_generic
snd_hda_intel kvm snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec
snd_hda_core snd_hwdep snd_seq snd_seq_device iTCO_wdt intel_pmc_bxt
snd_pcm iTCO_vendor_support rapl virtio_net pcspkr i2c_i801
net_failover i2c_smbus virtio_balloon failover snd_timer snd soundcore
joydev lpc_ich fuse loop nfnetlink vsock_loopback
vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock zram
vmw_vmci xfs crct10dif_pclmul crc32_pclmul crc32c_intel
polyval_clmulni polyval_generic ghash_clmulni_intel sha512_ssse3
sha256_ssse3 sha1_ssse3 virtio_blk bochs drm_vram_helper
drm_ttm_helper ttm serio_raw qemu_fw_cfg virtio_console
[ 3619.965534] CPU: 0 UID: 0 PID: 772278 Comm: kworker/0:59 Not
tainted 6.11.0-0.rc5.1934261d8974.48.test.fc42.x86_64 #1
[ 3619.967665] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/201=
4
[ 3619.968957] Workqueue: cifsiod smb2_readv_worker [cifs]
[ 3619.970369] RIP: 0010:netfs_subreq_terminated+0x1fe/0x270 [netfs]
[ 3619.971795] Code: 86 f0 01 00 00 e9 fd fe ff ff 41 8b b6 ac 01 00
00 0f b7 83 86 00 00 00 48 c7 c7 7a e3 29 c1 89 d5 89 c2 e8 04 a8 ed
f1 89 ea <0f> 0b 4c 8b 43 70 4c 8b 4b 78 4c 89 c1 4c 29 c9 e9 48 fe ff
ff f3
[ 3619.975758] RSP: 0018:ffffb1f84a2dfe38 EFLAGS: 00010246
[ 3619.977070] RAX: d3c9ec24c7564800 RBX: ffff99330c6c5900 RCX: 00000000000=
00027
[ 3619.978653] RDX: 0000000000000001 RSI: 00000000ffffecb1 RDI: ffff99341a6=
21988
[ 3619.980473] RBP: 0000000000000001 R08: 0000000000000000 R09: 00000000000=
00cb1
[ 3619.981863] R10: ffffffffb54e5818 R11: c0000000ffffecb1 R12: ffff99341a6=
35d40
[ 3619.983499] R13: 0000000000000000 R14: ffff99333cbbec80 R15: ffff99331c8=
e6a00
[ 3619.985295] FS:  0000000000000000(0000) GS:ffff99341a600000(0000)
knlGS:0000000000000000
[ 3619.987063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3619.988321] CR2: 00007fdfe6947000 CR3: 0000000102504002 CR4: 00000000003=
70ef0
[ 3619.989828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 3619.991494] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 3619.993100] Call Trace:
[ 3619.993926]  <TASK>
[ 3619.994691]  ? __warn+0xc9/0x1c0
[ 3619.995796]  ? netfs_subreq_terminated+0x1fe/0x270 [netfs]
[ 3619.997018]  ? report_bug+0x139/0x1e0
[ 3619.998051]  ? handle_bug+0x42/0x70
[ 3619.999157]  ? exc_invalid_op+0x1a/0x50
[ 3620.000209]  ? asm_exc_invalid_op+0x1a/0x20
[ 3620.001277]  ? netfs_subreq_terminated+0x1fe/0x270 [netfs]
[ 3620.002631]  ? netfs_subreq_terminated+0x1fc/0x270 [netfs]
[ 3620.004054]  process_scheduled_works+0x1f6/0x440
[ 3620.005238]  worker_thread+0x221/0x2b0
[ 3620.006320]  ? __pfx_worker_thread+0x10/0x10
[ 3620.007368]  kthread+0xec/0x110
[ 3620.008266]  ? __pfx_kthread+0x10/0x10
[ 3620.009458]  ret_from_fork+0x3a/0x50
[ 3620.010574]  ? __pfx_kthread+0x10/0x10
[ 3620.011596]  ret_from_fork_asm+0x1a/0x30
[ 3620.012753]  </TASK>
[ 3620.013618] ---[ end trace 0000000000000000 ]---


On Thu, Sep 12, 2024 at 9:04=E2=80=AFAM Murphy Zhou <jencce.kernel@gmail.co=
m> wrote:
>
> Still happening after rc5 with Samba server:
>
> [ 3619.698588] run fstests generic/210 at 2024-08-31 15:24:51
> [ 3619.945375] ------------[ cut here ]------------
> [ 3619.946891] Subreq overread: R9ad9[1] 1500 > 4096 - 3000
> [ 3619.946934] WARNING: CPU: 0 PID: 772278 at fs/netfs/io.c:499 netfs_sub=
req_terminated+0x1fe/0x270 [netfs]
> [ 3619.950061] Modules linked in: nls_utf8 cifs cifs_arc4 nls_ucs2_utils =
cifs_md4 rpcsec_gss_krb5 nfsv4 dns_resolver nfs netfs rpcrdma rdma_cm iw_cm=
 ib_cm ib_core nfsd auth_rpcgss nfs_acl lockd grace dm_log_writes rfkill in=
tel_rapl_msr intel_rapl_common intel_uncore_frequency_common sunrpc kvm_int=
el snd_hda_codec_generic snd_hda_intel kvm snd_intel_dspcfg snd_intel_sdw_a=
cpi snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device iTCO_wdt in=
tel_pmc_bxt snd_pcm iTCO_vendor_support rapl virtio_net pcspkr i2c_i801 net=
_failover i2c_smbus virtio_balloon failover snd_timer snd soundcore joydev =
lpc_ich fuse loop nfnetlink vsock_loopback vmw_vsock_virtio_transport_commo=
n vmw_vsock_vmci_transport vsock zram vmw_vmci xfs crct10dif_pclmul crc32_p=
clmul crc32c_intel polyval_clmulni polyval_generic ghash_clmulni_intel sha5=
12_ssse3 sha256_ssse3 sha1_ssse3 virtio_blk bochs drm_vram_helper drm_ttm_h=
elper ttm serio_raw qemu_fw_cfg virtio_console
> [ 3619.965534] CPU: 0 UID: 0 PID: 772278 Comm: kworker/0:59 Not tainted 6=
.11.0-0.rc5.1934261d8974.48.test.fc42.x86_64 #1
> [ 3619.967665] Hardware name: Red Hat KVM/RHEL, BIOS 1.16.1-1.el9 04/01/2=
014
> [ 3619.968957] Workqueue: cifsiod smb2_readv_worker [cifs]
> [ 3619.970369] RIP: 0010:netfs_subreq_terminated+0x1fe/0x270 [netfs]
> [ 3619.971795] Code: 86 f0 01 00 00 e9 fd fe ff ff 41 8b b6 ac 01 00 00 0=
f b7 83 86 00 00 00 48 c7 c7 7a e3 29 c1 89 d5 89 c2 e8 04 a8 ed f1 89 ea <=
0f> 0b 4c 8b 43 70 4c 8b 4b 78 4c 89 c1 4c 29 c9 e9 48 fe ff ff f3
> [ 3619.975758] RSP: 0018:ffffb1f84a2dfe38 EFLAGS: 00010246
> [ 3619.977070] RAX: d3c9ec24c7564800 RBX: ffff99330c6c5900 RCX: 000000000=
0000027
> [ 3619.978653] RDX: 0000000000000001 RSI: 00000000ffffecb1 RDI: ffff99341=
a621988
> [ 3619.980473] RBP: 0000000000000001 R08: 0000000000000000 R09: 000000000=
0000cb1
> [ 3619.981863] R10: ffffffffb54e5818 R11: c0000000ffffecb1 R12: ffff99341=
a635d40
> [ 3619.983499] R13: 0000000000000000 R14: ffff99333cbbec80 R15: ffff99331=
c8e6a00
> [ 3619.985295] FS:  0000000000000000(0000) GS:ffff99341a600000(0000) knlG=
S:0000000000000000
> [ 3619.987063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3619.988321] CR2: 00007fdfe6947000 CR3: 0000000102504002 CR4: 000000000=
0370ef0
> [ 3619.989828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [ 3619.991494] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [ 3619.993100] Call Trace:
> [ 3619.993926]  <TASK>
> [ 3619.994691]  ? __warn+0xc9/0x1c0
> [ 3619.995796]  ? netfs_subreq_terminated+0x1fe/0x270 [netfs]
> [ 3619.997018]  ? report_bug+0x139/0x1e0
> [ 3619.998051]  ? handle_bug+0x42/0x70
> [ 3619.999157]  ? exc_invalid_op+0x1a/0x50
> [ 3620.000209]  ? asm_exc_invalid_op+0x1a/0x20
> [ 3620.001277]  ? netfs_subreq_terminated+0x1fe/0x270 [netfs]
> [ 3620.002631]  ? netfs_subreq_terminated+0x1fc/0x270 [netfs]
> [ 3620.004054]  process_scheduled_works+0x1f6/0x440
> [ 3620.005238]  worker_thread+0x221/0x2b0
> [ 3620.006320]  ? __pfx_worker_thread+0x10/0x10
> [ 3620.007368]  kthread+0xec/0x110
> [ 3620.008266]  ? __pfx_kthread+0x10/0x10
> [ 3620.009458]  ret_from_fork+0x3a/0x50
> [ 3620.010574]  ? __pfx_kthread+0x10/0x10
> [ 3620.011596]  ret_from_fork_asm+0x1a/0x30
> [ 3620.012753]  </TASK>
> [ 3620.013618] ---[ end trace 0000000000000000 ]---
>
>
> On Tue, Aug 20, 2024 at 6:07=E2=80=AFAM Steve French <smfrench@gmail.com>=
 wrote:
>>
>> I was able to repro the generic/210 regression to Samba server as well
>>
>> [ 7884.205037] Workqueue: cifsiod smb2_readv_worker [cifs]
>> [ 7884.205262] RIP: 0010:netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
>> [ 7884.205299] Code: 01 00 00 e8 02 b4 07 df 4c 8b 4c 24 08 49 89 d8
>> 4c 89 e9 41 8b b4 24 d4 01 00 00 44 89 f2 48 c7 c7 40 10 65 c1 e8 30
>> a9 b6 de <0f> 0b 48 8b 7c 24 18 4c 8d bd c0 00 00 00 e8 2d b5 07 df 48
>> 8b 7c
>> [ 7884.205305] RSP: 0018:ff1100010705fce8 EFLAGS: 00010286
>> [ 7884.205312] RAX: dffffc0000000000 RBX: 0000000000001000 RCX: 00000000=
00000027
>> [ 7884.205317] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ff110004=
cb1b1a08
>> [ 7884.205322] RBP: ff11000119450900 R08: ffffffffa03e346e R09: ffe21c00=
99636341
>> [ 7884.205326] R10: ff110004cb1b1a0b R11: 0000000000000001 R12: ff110001=
37b68a80
>> [ 7884.205330] R13: 000000000000012c R14: 0000000000000001 R15: ff110001=
26a96f78
>> [ 7884.205335] FS:  0000000000000000(0000) GS:ff110004cb180000(0000)
>> knlGS:0000000000000000
>> [ 7884.205339] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 7884.205344] CR2: 00007f0035f0a67c CR3: 000000000f664004 CR4: 00000000=
00371ef0
>> [ 7884.205354] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
>> [ 7884.205359] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
>> [ 7884.205363] Call Trace:
>> [ 7884.205367]  <TASK>
>> [ 7884.205373]  ? __warn+0xa4/0x220
>> [ 7884.205386]  ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
>> [ 7884.205423]  ? report_bug+0x1d4/0x1e0
>> [ 7884.205436]  ? handle_bug+0x42/0x80
>> [ 7884.205442]  ? exc_invalid_op+0x18/0x50
>> [ 7884.205449]  ? asm_exc_invalid_op+0x1a/0x20
>> [ 7884.205464]  ? irq_work_claim+0x1e/0x40
>> [ 7884.205475]  ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
>> [ 7884.205512]  ? netfs_subreq_terminated+0x3f0/0x4b0 [netfs]
>> [ 7884.205554]  process_one_work+0x4cf/0xb80
>> [ 7884.205573]  ? __pfx_lock_acquire+0x10/0x10
>> [ 7884.205582]  ? __pfx_process_one_work+0x10/0x10
>> [ 7884.205599]  ? assign_work+0xd6/0x110
>> [ 7884.205609]  worker_thread+0x2cd/0x550
>> [ 7884.205622]  ? __pfx_worker_thread+0x10/0x10
>> [ 7884.205632]  kthread+0x187/0x1d0
>> [ 7884.205639]  ? __pfx_kthread+0x10/0x10
>> [ 7884.205648]  ret_from_fork+0x34/0x60
>> [ 7884.205655]  ? __pfx_kthread+0x10/0x10
>> [ 7884.205661]  ret_from_fork_asm+0x1a/0x30
>> [ 7884.205684]  </TASK>
>> [ 7884.205688] irq event stamp: 23635
>> [ 7884.205692] hardirqs last  enabled at (23641): [<ffffffffa022b58b>]
>> console_unlock+0x15b/0x170
>> [ 7884.205699] hardirqs last disabled at (23646): [<ffffffffa022b570>]
>> console_unlock+0x140/0x170
>> [ 7884.205705] softirqs last  enabled at (23402): [<ffffffffa0131a6e>]
>> __irq_exit_rcu+0xfe/0x120
>> [ 7884.205712] softirqs last disabled at (23397): [<ffffffffa0131a6e>]
>> __irq_exit_rcu+0xfe/0x120
>> [ 7884.205718] ---[ end trace 0000000000000000 ]---
>>
>> On Mon, Aug 19, 2024 at 12:15=E2=80=AFAM Steve French <smfrench@gmail.co=
m> wrote:
>> >
>> > Probably regression in rc4 affecting xfstest generic/125
>> >
>> > it also happened with multichannel with current mainline, but doesn't
>> > look like it happened with rc3
>> >
>> > http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builde=
rs/5/builds/207/steps/57/logs/stdio
>> >
>> > Is it possible it is related to this patch which is in the failing
>> > (rc4) branch but not in rc3 (where the test passes)?
>> >
>> > commit e3786b29c54cdae3490b07180a54e2461f42144c
>> > Author: Dominique Martinet <asmadeus@codewreck.org>
>> > Date:   Thu Aug 8 14:29:38 2024 +0100
>> >
>> >     9p: Fix DIO read through netfs
>> >
>> >     If a program is watching a file on a 9p mount, it won't see any ch=
ange in
>> >     size if the file being exported by the server is changed directly =
in the
>> >     source filesystem, presumably because 9p doesn't have change notif=
ications,
>> >     and because netfs skips the reads if the file is empty.
>> >
>> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>> > index b2405dd4d4d4..3f3842e7b44a 100644
>> > --- a/fs/smb/client/file.c
>> > +++ b/fs/smb/client/file.c
>> > @@ -217,7 +217,8 @@ static void cifs_req_issue_read(struct
>> > netfs_io_subrequest *subreq)
>> >                         goto out;
>> >         }
>> >
>> > -       __set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
>> > +       if (subreq->rreq->origin !=3D NETFS_DIO_READ)
>> > +               __set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
>> >
>> >         rc =3D rdata->server->ops->async_readv(rdata);
>> >  out:
>> > (END)
>> >
>> > On Sun, Aug 18, 2024 at 7:24=E2=80=AFPM Steve French <smfrench@gmail.c=
om> wrote:
>> > >
>> > > Do you recognize this netfs failure (generic/125) that I just saw wi=
th
>> > > current mainline
>> > >
>> > > http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/buil=
ders/9/builds/106/steps/54/logs/stdio
>> > >
>> > > [Sun Aug 18 18:40:43 2024] <TASK>
>> > > [Sun Aug 18 18:40:43 2024] ? __warn+0xa4/0x220
>> > > [Sun Aug 18 18:40:43 2024] ? netfs_subreq_terminated+0x3f0/0x4b0 [ne=
tfs]
>> > > [Sun Aug 18 18:40:43 2024] ? report_bug+0x1d4/0x1e0
>> > > [Sun Aug 18 18:40:43 2024] ? handle_bug+0x42/0x80
>> > > [Sun Aug 18 18:40:43 2024] ? exc_invalid_op+0x18/0x50
>> > > [Sun Aug 18 18:40:43 2024] ? asm_exc_invalid_op+0x1a/0x20
>> > > [Sun Aug 18 18:40:43 2024] ? irq_work_claim+0x1e/0x40
>> > > [Sun Aug 18 18:40:43 2024] ? netfs_subreq_terminated+0x3f0/0x4b0 [ne=
tfs]
>> > >
>> > > $ git log --oneline -3
>> > > b5e99e6c6dcd (HEAD -> for-next, origin/for-next) smb3: fix problem
>> > > unloading module due to leaked refcount on shutdown
>> > > e4be320eeca8 smb3: fix broken cached reads when posix locks
>> > > 47ac09b91bef (tag: v6.11-rc4, origin/master, origin/HEAD,
>> > > linus/master, master) Linux 6.11-rc4
>> > >
>> > >
>> > > Ideas?
>> > >
>> > > --
>> > > Thanks,
>> > >
>> > > Steve
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>>
