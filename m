Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1C141C79;
	Thu, 19 Dec 2024 08:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734597672; cv=none; b=pq5mVZRNkujeBscZ/4ArdVpYRe4mEcUayUaIzASBKJZLIPc5kCA+4RWxpGchzotKWX9ByAOYIDiWZ29KrMZqWp7yJ5H8ofkMRtfFLbpkP+qSAambUR8GY1ieCVaem5qjhp/ZM5HE/R03uzAazA+QbjNyAqaWU7iD8KRcqI5YB+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734597672; c=relaxed/simple;
	bh=b5mug5RQ25JTiWDRJYzP/yEH0BW7CFUb+gLQzTNOtbc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gOKeecmvAA8MKjSXS0WYWIvQO47xwi9Oa8rXgIUaPbG+2wyg+FEDmzMmOsPOurStPhCJonjVue3zqHe2aCL3ABE1XSn5Ou5R8YsVkST/A+eMWxEv2NvIvXnSTfxDqPaRZkdpmcLGW9BIC5VxKTiLPYpW4uVfnCy+S9VlKySTAP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=as94KfJH; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="as94KfJH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1734597670; x=1766133670;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tDlWANgSm8Tq4j8oqCNiy8OB3tJO4YtkktoWpntjrTY=;
  b=as94KfJHSAFnp+dyEDF21rJiOYUwKM//BQ3rrUKNn0edu5mr5JYZoi1y
   Mi8BsNA8WlZqX8sqEzkrAUN6C07XmQNVkrRSLGlKxQhbyofrOX/JwiSDo
   Chpixwf2g/so/+NHkW24d4bIS3Sdj0q8u10LOsGcpCu+ajy0idurKbyvq
   Y=;
X-IronPort-AV: E=Sophos;i="6.12,247,1728950400"; 
   d="scan'208";a="157054696"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 08:41:08 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.38.20:6240]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.210:2525] with esmtp (Farcaster)
 id fbf6d05d-9e13-43ff-bb45-427b0b1e011d; Thu, 19 Dec 2024 08:41:08 +0000 (UTC)
X-Farcaster-Flow-ID: fbf6d05d-9e13-43ff-bb45-427b0b1e011d
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 19 Dec 2024 08:41:06 +0000
Received: from 6c7e67c6786f.amazon.com (10.118.242.62) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 19 Dec 2024 08:41:03 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <smfrench@gmail.com>
CC: <ematsumiya@suse.de>, <kuniyu@amazon.com>, <linux-cifs@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: Re: [PATCH][SMB3 client] fix TCP timers deadlock after rmmod
Date: Thu, 19 Dec 2024 17:41:00 +0900
Message-ID: <20241219084100.33837-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <CAH2r5msqxcvHcbDt0x_eNpbdPxUhgFoOAPchZ16EBZeFhCdAKA@mail.gmail.com>
References: <CAH2r5msqxcvHcbDt0x_eNpbdPxUhgFoOAPchZ16EBZeFhCdAKA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWA003.ant.amazon.com (10.13.139.49) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

Hi,

sorry for the late response.

From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Dec 2024 21:24:12 -0600
> Enzo had an interesting patch, that seems to fix an important problem.
> 
> Here was his repro scenario:
> 
>      tw:~ # mount.cifs -o credentials=/root/wincreds,echo_interval=10
> //someserver/target1 /mnt/test
>      tw:~ # ls /mnt/test
>      abc  dir1  dir3  target1_file.txt  tsub
>      tw:~ # iptables -A INPUT -s someserver -j DROP
> 
> Trigger reconnect and wait for 3*echo_interval:
> 
>      tw:~ # cat /mnt/test/target1_file.txt
>      cat: /mnt/test/target1_file.txt: Host is down
> 
> Then umount and rmmod.  Note that rmmod might take several iterations
> until it properly tears down everything, so make sure you see the "not
> loaded" message before proceeding:
> 
>      tw:~ # umount /mnt/*; rmmod cifs
>      umount: /mnt/az: not mounted.
>      umount: /mnt/dfs: not mounted.
>      umount: /mnt/local: not mounted.
>      umount: /mnt/scratch: not mounted.
>      rmmod: ERROR: Module cifs is in use
>      ...
>      tw:~ # rmmod cifs
>      rmmod: ERROR: Module cifs is not currently loaded
> 
> Then kickoff the TCP internals:
>      tw:~ # iptables -F
> 
> Gets the lockdep warning (requires CONFIG_LOCKDEP=y) + a NULL deref
> later on.

I tried the repro and confirmed it triggers null deref.

It happens in LOCKDEP internal, so for me it looks like a problem in
LOCKDEP rather than CIFS or TCP.

I think LOCKDEP should hold a module reference and prevent related
modules from being unloaded.

[  242.144225][    C0] ------------[ cut here ]------------
[  242.144562][    C0] DEBUG_LOCKS_WARN_ON(1)
[  242.144575][    C0] WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:232 hlock_class+0xf9/0x130
[  242.145435][    C0] Modules linked in: [last unloaded: cifs]
[  242.145820][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.0-rc4-01014-g835f27aa21c9 #25
[  242.146426][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[  242.147197][    C0] RIP: 0010:hlock_class+0xf9/0x130
[  242.147529][    C0] Code: b6 14 11 38 d0 7c 04 84 d2 75 47 8b 05 54 a5 6b 04 85 c0 75 19 90 48 c7 c6 e0 e1 46 84 48 c7 c7 c0 dd 46 84 e8 88 6d eb ff 90 <0f> 0b 90 90 90 31 c0 5b c3 cc cc cc cc e8 05 91 4d 00 e9 19 ff ff
[  242.148779][    C0] RSP: 0018:ff1100006c009138 EFLAGS: 00010082
[  242.149168][    C0] RAX: 0000000000000000 RBX: 00000000000004e4 RCX: 0000000000000027
[  242.149673][    C0] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ff1100006c1e8a08
[  242.150180][    C0] RBP: 0000000000000000 R08: 0000000000000001 R09: ffe21c000d83d141
[  242.150688][    C0] R10: ff1100006c1e8a0b R11: 0000000000000017 R12: 0000000000000000
[  242.151199][    C0] R13: ffffffff8502e6c0 R14: ffffffff8502f150 R15: 00000000000424e4
[  242.151706][    C0] FS:  0000000000000000(0000) GS:ff1100006c000000(0000) knlGS:0000000000000000
[  242.152275][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  242.152693][    C0] CR2: 00007ffd0d2666b8 CR3: 0000000010002002 CR4: 0000000000771ef0
[  242.153197][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  242.153698][    C0] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  242.154200][    C0] PKRU: 55555554
[  242.154426][    C0] Call Trace:
[  242.154636][    C0]  <IRQ>
[  242.154817][    C0]  ? __warn+0xcc/0x2e0
[  242.155086][    C0]  ? hlock_class+0xf9/0x130
[  242.155378][    C0]  ? report_bug+0x28c/0x2d0
[  242.155678][    C0]  ? handle_bug+0x54/0xa0
[  242.155954][    C0]  ? exc_invalid_op+0x18/0x50
[  242.156250][    C0]  ? asm_exc_invalid_op+0x1a/0x20
[  242.156579][    C0]  ? hlock_class+0xf9/0x130
[  242.156867][    C0]  ? hlock_class+0xf8/0x130
[  242.157154][    C0]  __lock_acquire+0x4d8/0x3c30
[  242.157459][    C0]  ? find_held_lock+0x33/0x120
[  242.157766][    C0]  ? __pfx___lock_acquire+0x10/0x10
[  242.158095][    C0]  ? __pfx_lock_release+0x10/0x10
[  242.158414][    C0]  lock_acquire+0x196/0x520
[  242.158699][    C0]  ? tcp_v4_rcv+0x2695/0x3b70
[  242.158999][    C0]  ? __pfx_lock_acquire+0x10/0x10
[  242.159325][    C0]  ? __pfx_tcp_inbound_hash+0x10/0x10
[  242.159673][    C0]  ? __pfx_sk_filter_trim_cap+0x10/0x10
[  242.160039][    C0]  ? kasan_quarantine_put+0x84/0x1d0
[  242.160382][    C0]  _raw_spin_lock_nested+0x2e/0x70
[  242.160707][    C0]  ? tcp_v4_rcv+0x2695/0x3b70
[  242.161004][    C0]  tcp_v4_rcv+0x2695/0x3b70
[  242.161292][    C0]  ? __pfx_tcp_v4_rcv+0x10/0x10
[  242.161598][    C0]  ? ip_local_deliver_finish+0x204/0x490
[  242.161960][    C0]  ? __pfx_raw_local_deliver+0x10/0x10
[  242.162308][    C0]  ? hlock_class+0x4e/0x130
[  242.162598][    C0]  ? lock_release+0x5d5/0xb00
[  242.162898][    C0]  ? lock_is_held_type+0xa0/0x120
[  242.163223][    C0]  ip_protocol_deliver_rcu+0x8e/0x330
[  242.163568][    C0]  ip_local_deliver_finish+0x2bd/0x490
[  242.163922][    C0]  ip_local_deliver+0x198/0x450
[  242.164236][    C0]  ? __pfx_ip_local_deliver+0x10/0x10
[  242.164579][    C0]  ? lock_is_held_type+0xa0/0x120
[  242.164896][    C0]  ? __pfx_ip_local_deliver_finish+0x10/0x10
[  242.165273][    C0]  ? lock_is_held_type+0xa0/0x120
[  242.165594][    C0]  ? lock_is_held_type+0xa0/0x120
[  242.165921][    C0]  ip_sublist_rcv_finish+0x1e7/0x410
[  242.166260][    C0]  ip_sublist_rcv+0x380/0x760
[  242.166564][    C0]  ? __pfx_ip_sublist_rcv+0x10/0x10
[  242.166898][    C0]  ? hlock_class+0x4e/0x130
[  242.167187][    C0]  ? __lock_acquire+0x15e6/0x3c30
[  242.167506][    C0]  ? ip_fast_csum+0xc/0x20
[  242.167789][    C0]  ? ip_rcv_core+0x5dd/0xd30
[  242.168084][    C0]  ip_list_rcv+0x26e/0x380
[  242.168367][    C0]  ? __pfx_ip_list_rcv+0x10/0x10
[  242.168684][    C0]  __netif_receive_skb_list_core+0x5c2/0x830
[  242.169063][    C0]  ? __pfx___netif_receive_skb_list_core+0x10/0x10
[  242.169470][    C0]  ? lockdep_hardirqs_on_prepare+0x12b/0x3f0
[  242.169844][    C0]  ? kvm_clock_get_cycles+0x18/0x30
[  242.170174][    C0]  ? ktime_get_with_offset+0xe3/0x240
[  242.170520][    C0]  netif_receive_skb_list_internal+0x595/0xc70
[  242.170905][    C0]  ? __pfx_netif_receive_skb_list_internal+0x10/0x10
[  242.171321][    C0]  ? __kasan_mempool_unpoison_object+0x11e/0x1e0
[  242.171721][    C0]  ? napi_gro_receive+0x792/0x9d0
[  242.172040][    C0]  napi_complete_done+0x19d/0x700
[  242.172359][    C0]  ? __pfx_napi_complete_done+0x10/0x10
[  242.172709][    C0]  ? __pfx_e1000_clean_rx_irq+0x10/0x10
[  242.173061][    C0]  e1000_clean+0x85f/0x23e0
[  242.173347][    C0]  ? hlock_class+0x4e/0x130
[  242.173636][    C0]  ? __pfx_e1000_clean+0x10/0x10
[  242.173953][    C0]  __napi_poll.constprop.0+0x9b/0x430
[  242.174296][    C0]  net_rx_action+0x8d4/0xc90
[  242.174594][    C0]  ? __pfx_net_rx_action+0x10/0x10
[  242.174919][    C0]  ? handle_irq_event+0x10d/0x1c0
[  242.175246][    C0]  ? find_held_lock+0x33/0x120
[  242.175556][    C0]  ? hlock_class+0x4e/0x130
[  242.175855][    C0]  ? lock_release+0x5d5/0xb00
[  242.176157][    C0]  ? __pfx_lock_release+0x10/0x10
[  242.176478][    C0]  ? kvm_guest_apic_eoi_write+0x1e/0x40
[  242.176831][    C0]  handle_softirqs+0x1ae/0x770
[  242.177137][    C0]  irq_exit_rcu+0x94/0xc0
[  242.177413][    C0]  common_interrupt+0x7e/0x90
[  242.177716][    C0]  </IRQ>
[  242.177904][    C0]  <TASK>
[  242.178093][    C0]  asm_common_interrupt+0x26/0x40
[  242.178415][    C0] RIP: 0010:default_idle+0xf/0x20
[  242.178738][    C0] Code: 4c 01 c7 4c 29 c2 e9 72 ff ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 13 df 32 00 fb f4 <fa> c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
[  242.179958][    C0] RSP: 0018:ffffffff85007e30 EFLAGS: 00000206
[  242.180341][    C0] RAX: 000000000007b609 RBX: 0000000000000000 RCX: ffffffff840f7d25
[  242.180849][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8125f83d
[  242.181357][    C0] RBP: dffffc0000000000 R08: 0000000000000001 R09: ffe21c000d83ecb8
[  242.181864][    C0] R10: ff1100006c1f65c3 R11: 0000000000000000 R12: ffffffff8595b388
[  242.182371][    C0] R13: 1ffffffff0a00fcb R14: 0000000000000000 R15: 0000000000000000
[  242.182877][    C0]  ? ct_kernel_exit.constprop.0+0xc5/0xf0
[  242.183240][    C0]  ? do_idle+0x2fd/0x3b0
[  242.183508][    C0]  default_idle_call+0x6d/0xb0
[  242.183811][    C0]  do_idle+0x2fd/0x3b0
[  242.184072][    C0]  ? __pfx_do_idle+0x10/0x10
[  242.184368][    C0]  cpu_startup_entry+0x4f/0x60
[  242.184673][    C0]  rest_init+0x139/0x200
[  242.184945][    C0]  ? acpi_subsystem_init+0x50/0x140
[  242.185280][    C0]  start_kernel+0x374/0x3f0
[  242.185573][    C0]  x86_64_start_reservations+0x18/0x30
[  242.185925][    C0]  x86_64_start_kernel+0xcf/0xe0
[  242.186236][    C0]  common_startup_64+0x12c/0x138
[  242.186551][    C0]  </TASK>
[  242.186740][    C0] irq event stamp: 505362
[  242.187010][    C0] hardirqs last  enabled at (505362): [<ffffffff81171ea1>] __local_bh_enable_ip+0xa1/0x110
[  242.187632][    C0] hardirqs last disabled at (505361): [<ffffffff81171eca>] __local_bh_enable_ip+0xca/0x110
[  242.188252][    C0] softirqs last  enabled at (505348): [<ffffffff81171a8c>] handle_softirqs+0x50c/0x770
[  242.188851][    C0] softirqs last disabled at (505355): [<ffffffff81172174>] irq_exit_rcu+0x94/0xc0
[  242.189424][    C0] ---[ end trace 0000000000000000 ]---
[  242.189778][    C0] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000018: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  242.190575][    C0] KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
[  242.191097][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G        W          6.12.0-rc4-01014-g835f27aa21c9 #25
[  242.191782][    C0] Tainted: [W]=WARN
[  242.192023][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[  242.192788][    C0] RIP: 0010:__lock_acquire+0x4f0/0x3c30
[  242.193137][    C0] Code: 84 24 40 01 00 00 4c 89 f7 41 89 46 34 e8 e8 27 ff ff 48 ba 00 00 00 00 00 fc ff df 48 8d b8 c4 00 00 00 48 89 f9 48 c1 e9 03 <0f> b6 14 11 48 89 f9 83 e1 07 38 ca 7f 08 84 d2 0f 85 b6 29 00 00
[  242.194860][    C0] RSP: 0018:ff1100006c009148 EFLAGS: 00010007
[  242.195251][    C0] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000018
[  242.195758][    C0] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 00000000000000c4
[  242.196253][    C0] RBP: 0000000000000000 R08: 0000000000000001 R09: ffe21c000d83d141
[  242.196750][    C0] R10: ff1100006c1e8a0b R11: 0000000000000017 R12: 0000000000000000
[  242.197245][    C0] R13: ffffffff8502e6c0 R14: ffffffff8502f150 R15: 00000000000424e4
[  242.197742][    C0] FS:  0000000000000000(0000) GS:ff1100006c000000(0000) knlGS:0000000000000000
[  242.198301][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  242.198715][    C0] CR2: 00007ffd0d2666b8 CR3: 0000000010002002 CR4: 0000000000771ef0
[  242.199212][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  242.199703][    C0] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  242.200200][    C0] PKRU: 55555554
[  242.200424][    C0] Call Trace:
[  242.200635][    C0]  <IRQ>
[  242.200816][    C0]  ? die_addr+0x3c/0xa0
[  242.201084][    C0]  ? exc_general_protection+0x14d/0x230
[  242.201433][    C0]  ? asm_exc_general_protection+0x26/0x30
[  242.201793][    C0]  ? __lock_acquire+0x4f0/0x3c30
[  242.202103][    C0]  ? __lock_acquire+0x4d8/0x3c30
[  242.202414][    C0]  ? find_held_lock+0x33/0x120
[  242.202715][    C0]  ? __pfx___lock_acquire+0x10/0x10
[  242.203040][    C0]  ? __pfx_lock_release+0x10/0x10
[  242.203355][    C0]  lock_acquire+0x196/0x520
[  242.203639][    C0]  ? tcp_v4_rcv+0x2695/0x3b70
[  242.203934][    C0]  ? __pfx_lock_acquire+0x10/0x10
[  242.204246][    C0]  ? __pfx_tcp_inbound_hash+0x10/0x10
[  242.204577][    C0]  ? __pfx_sk_filter_trim_cap+0x10/0x10
[  242.204923][    C0]  ? kasan_quarantine_put+0x84/0x1d0
[  242.205257][    C0]  _raw_spin_lock_nested+0x2e/0x70
[  242.205586][    C0]  ? tcp_v4_rcv+0x2695/0x3b70
[  242.205883][    C0]  tcp_v4_rcv+0x2695/0x3b70
[  242.206170][    C0]  ? __pfx_tcp_v4_rcv+0x10/0x10
[  242.206475][    C0]  ? ip_local_deliver_finish+0x204/0x490
[  242.206828][    C0]  ? __pfx_raw_local_deliver+0x10/0x10
[  242.207166][    C0]  ? hlock_class+0x4e/0x130
[  242.207446][    C0]  ? lock_release+0x5d5/0xb00
[  242.207736][    C0]  ? lock_is_held_type+0xa0/0x120
[  242.208047][    C0]  ip_protocol_deliver_rcu+0x8e/0x330
[  242.208380][    C0]  ip_local_deliver_finish+0x2bd/0x490
[  242.208719][    C0]  ip_local_deliver+0x198/0x450
[  242.209021][    C0]  ? __pfx_ip_local_deliver+0x10/0x10
[  242.209351][    C0]  ? lock_is_held_type+0xa0/0x120
[  242.209661][    C0]  ? __pfx_ip_local_deliver_finish+0x10/0x10
[  242.210030][    C0]  ? lock_is_held_type+0xa0/0x120
[  242.210342][    C0]  ? lock_is_held_type+0xa0/0x120
[  242.210655][    C0]  ip_sublist_rcv_finish+0x1e7/0x410
[  242.210982][    C0]  ip_sublist_rcv+0x380/0x760
[  242.211274][    C0]  ? __pfx_ip_sublist_rcv+0x10/0x10
[  242.211594][    C0]  ? hlock_class+0x4e/0x130
[  242.211873][    C0]  ? __lock_acquire+0x15e6/0x3c30
[  242.212186][    C0]  ? ip_fast_csum+0xc/0x20
[  242.212460][    C0]  ? ip_rcv_core+0x5dd/0xd30
[  242.212746][    C0]  ip_list_rcv+0x26e/0x380
[  242.213021][    C0]  ? __pfx_ip_list_rcv+0x10/0x10
[  242.213328][    C0]  __netif_receive_skb_list_core+0x5c2/0x830
[  242.213699][    C0]  ? __pfx___netif_receive_skb_list_core+0x10/0x10
[  242.214103][    C0]  ? lockdep_hardirqs_on_prepare+0x12b/0x3f0
[  242.214477][    C0]  ? kvm_clock_get_cycles+0x18/0x30
[  242.214807][    C0]  ? ktime_get_with_offset+0xe3/0x240
[  242.215139][    C0]  netif_receive_skb_list_internal+0x595/0xc70
[  242.215520][    C0]  ? __pfx_netif_receive_skb_list_internal+0x10/0x10
[  242.215934][    C0]  ? __kasan_mempool_unpoison_object+0x11e/0x1e0
[  242.216324][    C0]  ? napi_gro_receive+0x792/0x9d0
[  242.216633][    C0]  napi_complete_done+0x19d/0x700
[  242.216941][    C0]  ? __pfx_napi_complete_done+0x10/0x10
[  242.217280][    C0]  ? __pfx_e1000_clean_rx_irq+0x10/0x10
[  242.217618][    C0]  e1000_clean+0x85f/0x23e0
[  242.217897][    C0]  ? hlock_class+0x4e/0x130
[  242.218173][    C0]  ? __pfx_e1000_clean+0x10/0x10
[  242.218477][    C0]  __napi_poll.constprop.0+0x9b/0x430
[  242.218807][    C0]  net_rx_action+0x8d4/0xc90
[  242.219092][    C0]  ? __pfx_net_rx_action+0x10/0x10
[  242.219406][    C0]  ? handle_irq_event+0x10d/0x1c0
[  242.219719][    C0]  ? find_held_lock+0x33/0x120
[  242.220014][    C0]  ? hlock_class+0x4e/0x130
[  242.220293][    C0]  ? lock_release+0x5d5/0xb00
[  242.220581][    C0]  ? __pfx_lock_release+0x10/0x10
[  242.220887][    C0]  ? kvm_guest_apic_eoi_write+0x1e/0x40
[  242.221227][    C0]  handle_softirqs+0x1ae/0x770
[  242.221527][    C0]  irq_exit_rcu+0x94/0xc0
[  242.221793][    C0]  common_interrupt+0x7e/0x90
[  242.222081][    C0]  </IRQ>
[  242.222262][    C0]  <TASK>
[  242.222443][    C0]  asm_common_interrupt+0x26/0x40
[  242.222754][    C0] RIP: 0010:default_idle+0xf/0x20
[  242.223063][    C0] Code: 4c 01 c7 4c 29 c2 e9 72 ff ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 13 df 32 00 fb f4 <fa> c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
[  242.224245][    C0] RSP: 0018:ffffffff85007e30 EFLAGS: 00000206
[  242.224619][    C0] RAX: 000000000007b609 RBX: 0000000000000000 RCX: ffffffff840f7d25
[  242.225113][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8125f83d
[  242.225596][    C0] RBP: dffffc0000000000 R08: 0000000000000001 R09: ffe21c000d83ecb8
[  242.226077][    C0] R10: ff1100006c1f65c3 R11: 0000000000000000 R12: ffffffff8595b388
[  242.226560][    C0] R13: 1ffffffff0a00fcb R14: 0000000000000000 R15: 0000000000000000
[  242.227044][    C0]  ? ct_kernel_exit.constprop.0+0xc5/0xf0
[  242.227393][    C0]  ? do_idle+0x2fd/0x3b0
[  242.227655][    C0]  default_idle_call+0x6d/0xb0
[  242.227948][    C0]  do_idle+0x2fd/0x3b0
[  242.228201][    C0]  ? __pfx_do_idle+0x10/0x10
[  242.228486][    C0]  cpu_startup_entry+0x4f/0x60
[  242.228781][    C0]  rest_init+0x139/0x200
[  242.229043][    C0]  ? acpi_subsystem_init+0x50/0x140
[  242.229361][    C0]  start_kernel+0x374/0x3f0
[  242.229637][    C0]  x86_64_start_reservations+0x18/0x30
[  242.229969][    C0]  x86_64_start_kernel+0xcf/0xe0
[  242.230268][    C0]  common_startup_64+0x12c/0x138
[  242.230570][    C0]  </TASK>
[  242.230757][    C0] Modules linked in: [last unloaded: cifs]
[  242.231113][    C0] ---[ end trace 0000000000000000 ]---
[  242.231443][    C0] RIP: 0010:__lock_acquire+0x4f0/0x3c30
[  242.231778][    C0] Code: 84 24 40 01 00 00 4c 89 f7 41 89 46 34 e8 e8 27 ff ff 48 ba 00 00 00 00 00 fc ff df 48 8d b8 c4 00 00 00 48 89 f9 48 c1 e9 03 <0f> b6 14 11 48 89 f9 83 e1 07 38 ca 7f 08 84 d2 0f 85 b6 29 00 00
[  242.232952][    C0] RSP: 0018:ff1100006c009148 EFLAGS: 00010007
[  242.233322][    C0] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000018
[  242.233800][    C0] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 00000000000000c4
[  242.234277][    C0] RBP: 0000000000000000 R08: 0000000000000001 R09: ffe21c000d83d141
[  242.234756][    C0] R10: ff1100006c1e8a0b R11: 0000000000000017 R12: 0000000000000000
[  242.235239][    C0] R13: ffffffff8502e6c0 R14: ffffffff8502f150 R15: 00000000000424e4
[  242.235721][    C0] FS:  0000000000000000(0000) GS:ff1100006c000000(0000) knlGS:0000000000000000
[  242.236257][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  242.236655][    C0] CR2: 00007ffd0d2666b8 CR3: 0000000010002002 CR4: 0000000000771ef0
[  242.237140][    C0] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  242.237621][    C0] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  242.238101][    C0] PKRU: 55555554
[  242.238317][    C0] Kernel panic - not syncing: Fatal exception in interrupt
[  242.239006][    C0] Kernel Offset: disabled
[  242.239320][    C0] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---



> 
> 
> Any thoughts on his patch?  See below (and attached)
> 
>     Commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
> namespace.")
>     fixed a netns UAF by manually enabled socket refcounting
>     (sk->sk_net_refcnt=1 and sock_inuse_add(net, 1)).
> 
>     The reason the patch worked for that bug was because we now hold
>     references to the netns (get_net_track() gets a ref internally)
>     and they're properly released (internally, on __sk_destruct()),
>     but only because sk->sk_net_refcnt was set.
> 
>     Problem:
>     (this happens regardless of CONFIG_NET_NS_REFCNT_TRACKER and regardless
>     if init_net or other)
> 
>     Setting sk->sk_net_refcnt=1 *manually* and *after* socket creation is not
>     only out of cifs scope, but also technically wrong -- it's set conditionally
>     based on user (=1) vs kernel (=0) sockets.  And net/ implementations
>     seem to base their user vs kernel space operations on it.
> 
>     e.g. upon TCP socket close, the TCP timers are not cleared because
>     sk->sk_net_refcnt=1:
>     (cf. commit 151c9c724d05 ("tcp: properly terminate timers for
> kernel sockets"))
> 
>     net/ipv4/tcp.c:
>         void tcp_close(struct sock *sk, long timeout)
>         {
>             lock_sock(sk);
>             __tcp_close(sk, timeout);
>             release_sock(sk);
>             if (!sk->sk_net_refcnt)
>                     inet_csk_clear_xmit_timers_sync(sk);
>             sock_put(sk);
>         }
> 
>     Which will throw a lockdep warning and then, as expected, deadlock on

I wondered how the deadlock happens when I read this, but it seems this
'deadlock' means literally 'dead' (freed) lock, not something like ABBA
deadlock.


>     tcp_write_timer().
> 
>     A way to reproduce this is by running the reproducer from ef7134c7fc48
>     and then 'rmmod cifs'.  A few seconds later, the deadlock/lockdep
>     warning shows up.
> 
>     Fix:
>     We shouldn't mess with socket internals ourselves, so do not set
>     sk_net_refcnt manually.
> 
>     Also change __sock_create() to sock_create_kern() for explicitness.
> 
>     As for non-init_net network namespaces, we deal with it the best way
>     we can -- hold an extra netns reference for server->ssocket and drop it
>     when it's released.  This ensures that the netns still exists whenever
>     we need to create/destroy server->ssocket, but is not directly tied to
>     it.
> 
>     Fixes: ef7134c7fc48 ("smb: client: Fix use-after-free of network
> namespace.")
> 
