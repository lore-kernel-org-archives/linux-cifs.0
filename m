Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14B77D098;
	Thu, 22 May 2025 12:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747918391; cv=none; b=fEhB2sRDl8Zy2i7Yv1W//j84YMWatDNr20M+fhXuTozd2CbYRBnWVOWLbPCidQ1AzxBz3KJ2TtTYchYvTNry5eYqJJaTCijscp3jDQtgP4icpPZDKJ8n9z5IzXTTCFIQit5cWRYMW1dJj6qDMCtqyV42HzAiX8MVBbLiRMCgYX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747918391; c=relaxed/simple;
	bh=v0j7BCEBYHwYpjXQ14egKJnzntDYAwSddW3wCQPWE7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=peN+W0zdSJuT941fIPIBurFTli80AbKynvTcsTFNPF53EBmAvfpBNdkGdsLMYZAPAWmYWifSeGEUcyi6NGAQ8uHY6mOPZed9bu5afiQ8TUAY1qTmTOHwbVXjrqMYfvw304tualU5B8gs6phdtt/WwqKJyIlRWkuI6PcjCU2Eovo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4b37V33sZwz1jBXD;
	Thu, 22 May 2025 20:52:11 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id DC8B3140109;
	Thu, 22 May 2025 20:53:04 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 22 May 2025 20:53:04 +0800
Message-ID: <353dfc63-2495-4874-a19f-ee124e075888@huawei.com>
Date: Thu, 22 May 2025 20:53:03 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] smb: client: Fix use-after-free in readdir
To: Steve French <smfrench@gmail.com>
CC: Paulo Alcantara <pc@manguebit.com>, <sfrench@us.ibm.com>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<yi.zhang@huawei.com>, <yangerkun@huawei.com>
References: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
 <860a4f7600814b17e48dbabe1ae19f68@manguebit.com>
 <CAH2r5mvo1e3034LpCWUAuE0=dDBb7R0bMCmt80dGRWKMegRV+Q@mail.gmail.com>
 <c1e693c6-573f-49d4-b6cf-cc308c339f06@huawei.com>
 <CAH2r5mvoS8Py_M95+i0hB2iP06Uqz5JQbb13schBfdmJ6NzL3g@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <CAH2r5mvoS8Py_M95+i0hB2iP06Uqz5JQbb13schBfdmJ6NzL3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemg500010.china.huawei.com (7.202.181.71)





> I was able to reproduce it by running the reproducer poc much longer


I was able to reproduce the issue described in the patch within 1-3 minutes by
running POC on a virtual machine with 4 CPU cores, under the CONFIG_KASAN=y.

> 
> [189335.643181] Key type cifs.idmap unregistered
> [189335.643203] Key type cifs.spnego unregistered
> [189335.649519] CIFS: VFS: kmem_cache_destroy small req cachep
> [189335.656316]
> =============================================================================
> [189335.656320] BUG cifs_small_rq (Tainted: G    B   W  OE      ):
> Objects remaining on __kmem_cache_shutdown()
> [189335.656322]
> -----------------------------------------------------------------------------
> 
> [189335.656324] Object 0x000000001a39cfef @offset=15232
> [189335.656326] Slab 0x00000000479475fe objects=36 used=1
> fp=0x0000000090941d36
> flags=0x17ffffc0000240(workingset|head|node=0|zone=2|lastcpupid=0x1fffff)
> [189335.656334] ------------[ cut here ]------------
> [189335.656335] WARNING: CPU: 1 PID: 84118 at mm/slub.c:1135
> __slab_err+0x1d/0x30
> ....
> [189335.656512]  [last unloaded: cifs(OE)]
> [189335.656516] CPU: 1 UID: 0 PID: 84118 Comm: rmmod Tainted: G    B
> W  OE       6.15.0-061500rc4-generic #202504272253 PREEMPT(voluntary)
> [189335.656520] Tainted: [B]=BAD_PAGE, [W]=WARN, [O]=OOT_MODULE,
> [E]=UNSIGNED_MODULE
> [189335.656521] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
> N2CET70W (1.53 ) 03/11/2024
> [189335.656522] RIP: 0010:__slab_err+0x1d/0x30
> [189335.656525] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44
> 00 00 55 48 89 e5 e8 72 ff ff ff be 01 00 00 00 bf 05 00 00 00 e8 33
> b2 1c 00 <0f> 0b 5d 31 f6 31 ff c3 cc cc cc cc 0f 1f 80 00 00 00 00 90
> 90 90
> [189335.656527] RSP: 0018:ffffcf3041b33a18 EFLAGS: 00010046
> [189335.656529] RAX: 0000000000000000 RBX: ffffcf3041b33a60 RCX:
> 0000000000000000
> [189335.656530] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 0000000000000000
> [189335.656531] RBP: ffffcf3041b33a18 R08: 0000000000000000 R09:
> 0000000000000000
> [189335.656533] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff8c1b49eb7600
> [189335.656534] R13: ffff8c1b4ccd9580 R14: dead000000000122 R15:
> ffff8c1b4ccd9580
> [189335.656535] FS:  00007d912677e080(0000) GS:ffff8c2312b1b000(0000)
> knlGS:0000000000000000
> [189335.656537] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [189335.656538] CR2: 000061c8bedf4778 CR3: 00000003f2b4a001 CR4:
> 00000000003726f0
> [189335.656540] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [189335.656541] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [189335.656542] Call Trace:
> [189335.656543]  <TASK>
> [189335.656546]  free_partial.cold+0x137/0x191
> [189335.656550]  __kmem_cache_shutdown+0x46/0xa0
> [189335.656553]  kmem_cache_destroy+0x3e/0x1c0
> [189335.656558]  cifs_destroy_request_bufs+0x5c/0x70 [cifs]
> [189335.656618]  exit_cifs+0x3a/0xef0 [cifs]
> [189335.656666]  __do_sys_delete_module.isra.0+0x19d/0x2e0
> [189335.656671]  __x64_sys_delete_module+0x12/0x20
> [189335.656674]  x64_sys_call+0x1765/0x2320
> [189335.656677]  do_syscall_64+0x7e/0x210
> [189335.656679]  ? __fput+0x1a2/0x2d0
> [189335.656681]  ? kmem_cache_free+0x408/0x470
> [189335.656684]  ? __fput+0x1a2/0x2d0
> [189335.656686]  ? arch_exit_to_user_mode_prepare.isra.0+0x22/0xd0
> [189335.656689]  ? syscall_exit_to_user_mode+0x38/0x1d0
> [189335.656692]  ? do_syscall_64+0x8a/0x210
> [189335.656695]  ? do_read_fault+0xfb/0x230
> [189335.656698]  ? do_fault+0x15d/0x220
> [189335.656699]  ? handle_pte_fault+0x140/0x210
> [189335.656702]  ? __handle_mm_fault+0x3cd/0x790
> [189335.656705]  ? __count_memcg_events+0xd3/0x1a0
> [189335.656708]  ? count_memcg_events.constprop.0+0x2a/0x50
> [189335.656710]  ? handle_mm_fault+0x1ca/0x2e0
> [189335.656713]  ? do_user_addr_fault+0x2f8/0x830
> [189335.656716]  ? arch_exit_to_user_mode_prepare.isra.0+0x22/0xd0
> [189335.656719]  ? irqentry_exit_to_user_mode+0x2d/0x1d0
> [189335.656722]  ? irqentry_exit+0x43/0x50
> [189335.656724]  ? exc_page_fault+0x96/0x1e0
> [189335.656727]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [189335.656729] RIP: 0033:0x7d9125f2ac9b

This call trace seems to look like a memory leak or a reference
counting management issue. Can it still be reproduced even after my
patch is applied?

Best regards,
Wang Zhaolong
