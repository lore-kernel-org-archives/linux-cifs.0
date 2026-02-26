Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADCB38BF72
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 08:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772096162; cv=pass; b=u6qhS40uxSEUfAD8Io8iSVMzaG9z8MUSFTp/LPABmFgjyM/5l9D53qfsb5IGtmoLgIHxsT782GXUOpEHOo39caiPYWs/MWAn5VSEC6fB+gupHM8Rc8lah7xWNqVba1VJiCaCXqRidVNda5GWLjW7pyT+VA0UT6M1HxRi0FICYSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772096162; c=relaxed/simple;
	bh=hUsdsK4bRIL5jxuasDA0P/arDJ9UXWokwgvYrOux0+g=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=oVWShoHJBKOr8ZMW3xLl3t71R7UNaMYxp6I4972QhLdjiENQ1RdEUXEkkNQpXI7bN9hlOVcG/PihYgcUnaST+oGDfN9q4Hx2bu7qgGIdTe1GWDZ5IiaxmLNHO1p0eqB8qlzoAOYIQ2H5QJshabb3BAaVGQj3RJJjb08txZw1c1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gb11G/8d; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gb11G/8d"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so82868966b.2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 00:56:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772096159; cv=none;
        d=google.com; s=arc-20240605;
        b=HU4TQBK/aX1qfMQp5blYZC5VhZuo4TE82a3aa2PF1D7Wckp+gp5YAkg6RYkNS1WVOS
         RPjNMxhr/50YsV5eERd3rCt/gpwSx/hCzY6zJuIAuNrSLFSHOQb7VSohxR2MSVfPz9ZF
         Off5x3kMrxsMhOa6S5RaZkRtEEHU8rI4/I9h50OYIMZMBgs/u693Wdq2xqq9tElEX74Y
         H8998TRxOLjQHu5Dvrw56guMdCnqMwhS/0FUkcWA8eu2gu0+xyL1ke55cllf7VKHIAy5
         pDli6lXhNUaJBQJqlJ1pRaKwRNwq+2K83KWKQdNT8pR+qr73SyegBlysxfXxCZg+9zjb
         QXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=JE/Zh+nyv7Fk9f00ckbM3A24zhkB4+zbdHgKuu9vMLw=;
        fh=ko9MV4PaNXTwxghsz5Rn5dYwKPWR8BjvSfbOHzi1ZkI=;
        b=lCRfhz+G5/q14R7UtB5AENlcmgxk/gkntMELthSnGAl99W18EvEVmgw23tVIjUy4If
         GcRA3CURoDw4LOsc5xhqpy6+bQbv5RRYtGgEncDa8pBO/rsvrDYt2a7yo0yhODsc6VMf
         QOXmKG0wFAfpkmrbBnjJ+sNwsoB7OlZBWdDMtBQvYXYXUbFJcvvCcn6bXoOu4WJCBsZV
         g5rCewN1yEIpxU46V4Dl6FoxuiQTvsBZWXvSedDb9I2n6c181xm/PgUNMzIYGB3kTNAT
         ytgAZY3yXtsYVZmVaAVAHzjcBJ4HAyVpmTUOpIPN+sR28yfnORXYHY4duxnBXAEZ0rm7
         KEVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772096159; x=1772700959; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JE/Zh+nyv7Fk9f00ckbM3A24zhkB4+zbdHgKuu9vMLw=;
        b=Gb11G/8dSTWPAm85y/r3jZinZqockglSVQshP2MfHq3GOk+DHjKfGJLSy3VWpRRY2Y
         yvsO0rh6E3HWAaEN4mXB5Zs+pQFQA5+o7h4B3AEf49v1BVp+oOAo2z/F2jnn+ZvOd35b
         MSsxUHH2x4SlVQEwkOT/mSdfFI0YEinzLk0LW7v23Jp7nr+16nwXtrFbyiQt6e0HV0hX
         pwonzhu9sAE0H0Oo5VlTQtG5sH2woMhQKnhTW8H6hMSIMDeUWCq4qx805L7+W8fvLJPu
         qTTZP1K4ccsc2bgZHKKegQ9U65qWmkxw+nvB1pfY4vFq3rTmtcI8+5MxxdFOLnmtlfSY
         pmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772096159; x=1772700959;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JE/Zh+nyv7Fk9f00ckbM3A24zhkB4+zbdHgKuu9vMLw=;
        b=im/vtrib3ZoikkxsAql7NoZw0Ji8r0oz0geQ1UXYAsczdERKIL3T4MKqAGkvAA2CoR
         8sP4ZO63jUZIwG93fKMfYoME0c4lUGWGLD6TRYxBYPAbksguuI6S2ftuKf2tZQa4MhbU
         kaEKm68utOZOrexNG7xFGhM01B2zcwaqQ2L104lYYpM1zaBAD38hj57afsOTiipBMHEC
         O/23AV4w1Zn1KRmZBk1H5teN92+uVohkDo/7tuObNtrIgVrP+emsimo+TYJDbYMmjIBf
         zrdSWvvD+aEZ/VNF4IMFqN9BOoLmw1KQ3c2AoD48S1A5N4LliXpOaKRjwCwVfLKcTrux
         xPrA==
X-Gm-Message-State: AOJu0YzRulfo6UQxID/quBQCSPMUSbIhGo9caw67wZIMBV0B0UQWka2X
	qgmFZyDkZo0iRQ4rIF+eWBEAdUix0mT15kZPYKOwgau28y6I5Co0MEmjp4TF4Dh23vn9u6y15Uu
	kGc7huyin9EHrKvyI1RjOTZQmPsZv3jWy5jJGOxE=
X-Gm-Gg: ATEYQzykD4CVSoxDKi7s9+fp+9TgmFzPkQ3qTvgnoEv4yn/9DqeuzcUdoReHpeuBKo1
	7td9Nyjh9FRpI41cr97Q2w4hP5WgoTxjcKLrnlnNxpOIieV7TSnvdI+ZmncUcOcBDSOnb40IxT5
	eO++AoZIeW/AF8e+mXzSWuKUa0jkOppLwTUVpDdRl0vRC0yPZd8e7j0E4PqWxaXsf60i0n6GBCH
	W/2kewzndBDZ3K12Crri5ZG6eXAmMWHi6M47KGnbYg2eNgVL0SDCY1fQ4wC3pogV2X7Ckw0WMoC
	F8kl9T8HdtAP6d1c
X-Received: by 2002:a17:907:3c88:b0:b93:3792:4b0a with SMTP id
 a640c23a62f3a-b935b8d28d3mr87478066b.31.1772096158457; Thu, 26 Feb 2026
 00:55:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: RAJASI MANDAL <rajasimandalos@gmail.com>
Date: Thu, 26 Feb 2026 14:25:47 +0530
X-Gm-Features: AaiRm53cEVCb6LBTQKxlesr2EUNC_nkizBCUuByOlHC-bbZKjPMHRiW2KvLuE9k
Message-ID: <CAEY6_V1BXj7pRcvmj4JW2VVdD7EW_74ir00MYJhQdyHokdd6TA@mail.gmail.com>
Subject: xfstests failure on SMB mount due to workqueue flush warning (Azure
 Linux 3.0)
To: linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

I am seeing xfstests failures on SMB mounts on Azure Linux 3.0, caused
by a kernel WARNING emitted during unmount/shutdown paths. I wanted to
check if this is a known issue.

Environment:
Distro: Microsoft Azure Linux 3.0
Kernel:
6.6.121.1-1.azl3
6.6.119.3-1.azl3

Note: the Azure Linux 6.6 kernel is based on the upstream stable-6.6 kernel tree

Mount options:
noperm,nosharesock,vers=3.0,mfsymlinks,acdirmax=30

The failure occurs because dmesg contains the following WARNING:

[Thu Feb  5 10:01:08 2026] ------------[ cut here ]------------
[Thu Feb  5 10:01:08 2026] workqueue: WQ_MEM_RECLAIM
deferredclose:smb2_deferred_work_close [cifs] is flushing
!WQ_MEM_RECLAIM inode_switch_wbs:0x0
[Thu Feb  5 10:01:08 2026] WARNING: CPU: 0 PID: 696237 at
kernel/workqueue.c:2975 check_flush_dependency.part.0+0xb8/0x100
[Thu Feb  5 10:01:08 2026] Modules linked in: ccm cmac cifs cifs_arc4
nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver
nfs lockd grace sunrpc netfs fscache binfmt_misc udp_diag tcp_diag
inet_diag xt_MASQUERADE nf_conntrack_netlink xfrm_user xfrm_algo
xt_addrtype br_netfilter bridge xt_owner tls xt_conntrack nft_compat
nft_masq nft_nat nft_fib_ipv4 nft_fib nft_chain_nat nf_tables xt_LOG
nf_log_syslog mlx5_ib ib_uverbs ib_core mlx5_core mlxfw cfg80211 8021q
garp mrp stp llc intel_rapl_msr intel_rapl_common kvm_intel kvm
irqbypass rapl hyperv_fb evdev mousedev sch_fq_codel fuse configfs
dmi_sysfs crc32c_intel sha512_ssse3 hid_generic hid_hyperv
sha256_ssse3 hid sha1_ssse3 ebt_ip ip6table_nat ip6table_mangle
ip6table_filter ip6_tables iptable_security iptable_nat nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle
iptable_filter ip_tables autofs4
[Thu Feb  5 10:01:08 2026] CPU: 0 PID: 696237 Comm: kworker/0:1 Not
tainted 6.6.119.3-1.azl3 #1
[Thu Feb  5 10:01:08 2026] Hardware name: Microsoft Corporation
Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1
08/23/2024
[Thu Feb  5 10:01:08 2026] Workqueue: deferredclose
smb2_deferred_work_close [cifs]
[Thu Feb  5 10:01:08 2026] RIP: 0010:check_flush_dependency.part.0+0xb8/0x100
[Thu Feb  5 10:01:08 2026] Code: e0 49 8b 54 24 18 49 8d 8d b0 00 00
00 4d 89 f0 48 81 c6 b0 00 00 00 48 c7 c7 f0 6c 77 85 c6 05 ea 0f 1c
02 01 e8 48 a3 fd ff <0f> 0b eb b3 80 3d db 0f 1c 02 00 75 8c 8b b0 70
09 00 00 49 8d 8d
[Thu Feb  5 10:01:08 2026] RSP: 0000:ffffc9000738bb70 EFLAGS: 00010286
[Thu Feb  5 10:01:08 2026] RAX: 0000000000000000 RBX: 0000000000000000
RCX: 0000000000000027
[Thu Feb  5 10:01:08 2026] RDX: ffff8882b7c21488 RSI: 0000000000000001
RDI: ffff8882b7c21480
[Thu Feb  5 10:01:08 2026] RBP: ffffc9000738bb90 R08: 0000000000000000
R09: ffffc9000738b9d8
[Thu Feb  5 10:01:08 2026] R10: 0000000000000003 R11: ffffffff86140928
R12: ffff88819a90c540
[Thu Feb  5 10:01:08 2026] R13: ffff8881008ffa00 R14: 0000000000000000
R15: dead000000000100
[Thu Feb  5 10:01:08 2026] FS:  0000000000000000(0000)
GS:ffff8882b7c00000(0000) knlGS:0000000000000000
[Thu Feb  5 10:01:08 2026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Thu Feb  5 10:01:08 2026] CR2: 000072545172a818 CR3: 000000022dd2c003
CR4: 0000000000370ef0
[Thu Feb  5 10:01:08 2026] Call Trace:
[Thu Feb  5 10:01:08 2026]  <TASK>
[Thu Feb  5 10:01:08 2026]  __flush_workqueue+0x179/0x420
[Thu Feb  5 10:01:08 2026]  ? rcu_barrier+0x27b/0x300
[Thu Feb  5 10:01:08 2026]  cgroup_writeback_umount+0x33/0x40
[Thu Feb  5 10:01:08 2026]  generic_shutdown_super+0x38/0x110
[Thu Feb  5 10:01:08 2026]  kill_anon_super+0x1c/0x50
[Thu Feb  5 10:01:08 2026]  cifs_kill_sb+0x4e/0x60 [cifs]
[Thu Feb  5 10:01:08 2026]  deactivate_locked_super+0x39/0xb0
[Thu Feb  5 10:01:08 2026]  deactivate_super+0x44/0x50
[Thu Feb  5 10:01:08 2026]  cifs_sb_deactive+0x24/0x30 [cifs]
[Thu Feb  5 10:01:08 2026]  cifsFileInfo_put_final+0x12d/0x160 [cifs]
[Thu Feb  5 10:01:08 2026]  _cifsFileInfo_put+0x352/0x4b0 [cifs]
[Thu Feb  5 10:01:08 2026]  smb2_deferred_work_close+0x63/0x70 [cifs]
[Thu Feb  5 10:01:08 2026]  process_one_work+0x18e/0x3a0
[Thu Feb  5 10:01:08 2026]  worker_thread+0x285/0x3c0
[Thu Feb  5 10:01:08 2026]  ? _raw_spin_unlock_irqrestore+0x12/0x40
[Thu Feb  5 10:01:08 2026]  ? __pfx_worker_thread+0x10/0x10
[Thu Feb  5 10:01:08 2026]  kthread+0xf6/0x130
[Thu Feb  5 10:01:08 2026]  ? __pfx_kthread+0x10/0x10
[Thu Feb  5 10:01:08 2026]  ret_from_fork+0x41/0x60
[Thu Feb  5 10:01:08 2026]  ? __pfx_kthread+0x10/0x10
[Thu Feb  5 10:01:08 2026]  ret_from_fork_asm+0x1b/0x30
[Thu Feb  5 10:01:08 2026]  </TASK>
[Thu Feb  5 10:01:08 2026] ---[ end trace 0000000000000000 ]---


Is someone here familiar with what's going on here?

Regards,
Rajasi
