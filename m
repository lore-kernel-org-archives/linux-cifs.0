Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5C510FD;
	Tue,  5 Aug 2025 02:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754361531; cv=none; b=pRb9uho1XTMvrfu6SJu2ZD2JWDvFORf+HPlfJDbd0BakCeKB5R0hIXmb/hSwKTqHwGq/q6mTOd364mvSHwLmhQejHMA6qJzezI1FQhc8X0BaiPSYwxPGrZSJxf4tToOpDG+KM2TGfGIpJLmd5afTBesDpOJpV1wUZxGvW5Na3pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754361531; c=relaxed/simple;
	bh=ZMGnpqg/HYDa2mdbQPGSpMy/49Ul9fvbniHgFDO/n+M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=p3a1v97FMN2f/XiO9mbEpq0DhPkyzM4bcCWv5/VxIPdTMJ5vwANSWmWpYGqXytTLAetQeEDSJvb1ZO4MVobTGozyyQVDPizPuRPYpJx9zxtOszLs4Vo+3Rf2H8ewX7L/lljTzxYu/78q4/TS5iwas2XgVuwZ2vTky9fMFJgscE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bwyDh6yvHz14MFZ;
	Tue,  5 Aug 2025 10:34:28 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 18A27140144;
	Tue,  5 Aug 2025 10:38:45 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 5 Aug 2025 10:38:44 +0800
Message-ID: <4cd8bc82-5847-45ae-b988-ec45cbe5dda9@huawei.com>
Date: Tue, 5 Aug 2025 10:38:43 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] smb: client: Fix use-after-free in readdir
From: Wang Zhaolong <wangzhaolong1@huawei.com>
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
 <f03b6422-eac8-4998-b516-a3ba34070f0d@huawei.com>
In-Reply-To: <f03b6422-eac8-4998-b516-a3ba34070f0d@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemg500010.china.huawei.com (7.202.181.71)


> 
>> I was able to reproduce it by running the reproducer poc much longer
>>
>> [189335.643181] Key type cifs.idmap unregistered
>> [189335.643203] Key type cifs.spnego unregistered
>> [189335.649519] CIFS: VFS: kmem_cache_destroy small req cachep
>> [189335.656316]
>> =============================================================================
>> [189335.656320] BUG cifs_small_rq (Tainted: G    B   W  OE      ):
>> Objects remaining on __kmem_cache_shutdown()
>> [189335.656322]
>> -----------------------------------------------------------------------------
>>
>> [189335.656324] Object 0x000000001a39cfef @offset=15232
>> [189335.656326] Slab 0x00000000479475fe objects=36 used=1
>> fp=0x0000000090941d36
>> flags=0x17ffffc0000240(workingset|head|node=0|zone=2|lastcpupid=0x1fffff)
>> [189335.656334] ------------[ cut here ]------------
> 
> After disabling KASAN, I encountered two memory leak issues after
> running the POC for half-hour:
> 
> Phenomenon 1:
> 
> [ 2175.037198] ------------[ cut here ]------------
> [ 2175.038447] WARNING: CPU: 2 PID: 425 at fs/smb/client/smb2ops.c:104 smb2_add_credits+0x2ac/0x6c0 [cifs]
> [ 2175.041927] Modules linked in: cifs cifs_arc4 nls_ucs2_utils cifs_md4
> [ 2175.043736] CPU: 2 UID: 0 PID: 425 Comm: cifsd Not tainted 6.15.0-rc6+ #241 PREEMPT(full)
> [ 2175.046082] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
> [ 2175.048680] RIP: 0010:smb2_add_credits+0x2ac/0x6c0 [cifs]
> [ 2175.050432] Code: ff ff 4c 89 e7 e8 d4 8e ff ff 41 89 c5 e9 99 fe ff ff c7
> 43 08 02 00 00 00 45 8b 8c 24 d8 01 00 00 45 85 c9 0f 85 48 fe ff ff <0f> 0b 80 3d
> 41 6a eb ff 00 0f 84 dc 03 00 00 0f 1f 44 00 00 f
> [ 2175.054563] RSP: 0018:ffffa9a94043fca8 EFLAGS: 00010246
> [ 2175.055716] RAX: 0000000000001ffe RBX: ffffa9a94043fcf0 RCX: 0000000000000000
> [ 2175.057236] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff90b807432a34
> [ 2175.058760] RBP: 0000000000000000 R08: ffff90b80ce60188 R09: 0000000000000000
> [ 2175.060268] R10: 0000000000000000 R11: 0000000000000001 R12: ffff90b807432800
> [ 2175.061730] R13: 0000000000000000 R14: 0000000000000001 R15: ffff90b8074329d0
> [ 2175.063210] FS:  0000000000000000(0000) GS:ffff90b8a9e84000(0000) knlGS:0000000000000000
> [ 2175.064422] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2175.065455] CR2: 00005643543896f8 CR3: 000000000192c000 CR4: 00000000000006f0
> [ 2175.066519] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2175.067561] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 2175.068658] Call Trace:
> [ 2175.069068]  <TASK>
> [ 2175.069402]  cifs_compound_callback+0x77/0xb0 [cifs]
> [ 2175.070214]  cifs_cancelled_callback+0x12/0x40 [cifs]
> [ 2175.071058]  clean_demultiplex_info+0x206/0x420 [cifs]
> [ 2175.071935]  cifs_demultiplex_thread+0x1a6/0xcb0 [cifs]
> [ 2175.072815]  ? dl_server_update_idle_time+0x60/0xa0
> [ 2175.073579]  ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
> [ 2175.074550]  kthread+0x10d/0x200
> [ 2175.075051]  ? __pfx_kthread+0x10/0x10
> [ 2175.075631]  ret_from_fork+0x34/0x50
> [ 2175.076197]  ? __pfx_kthread+0x10/0x10
> [ 2175.076683]  ret_from_fork_asm+0x1a/0x30
> [ 2175.077143]  </TASK>
> [ 2175.077398] ---[ end trace 0000000000000000 ]---
> [ 2175.077919] CIFS: rreq R=00000000[0] Zero in_flight
> [ 2175.285771] ------------[ cut here ]------------
> 
> 
> Phenomenon 2
> 
> [ 2175.287049] kmem_cache_destroy cifs_request: Slab cache still has objects when called from exit_cifs+0x43/0x560 [cifs]
> [ 2175.287205] WARNING: CPU: 0 PID: 3207738 at mm/slab_common.c:525 kmem_cache_destroy+0xfd/0x160
> [ 2175.292071] Modules linked in: cifs(-) cifs_arc4 nls_ucs2_utils cifs_md4
> [ 2175.293796] CPU: 0 UID: 0 PID: 3207738 Comm: modprobe Tainted: G        W           6.15.0-rc6+ #241 PREEMPT(full)
> [ 2175.296519] Tainted: [W]=WARN
> [ 2175.297339] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
> [ 2175.299559] RIP: 0010:kmem_cache_destroy+0xfd/0x160
> [ 2175.300836] Code: de 5b e9 86 bf 05 00 e8 b1 db e4 ff eb b2 48 8b 53 60 48 8b
> 4c 24 08 48 c7 c6 a0 be a2 93 48 c7 c7 10 2e fb 93 e8 a3 9d da ff <0f> 0b 48 8b 53 68
> 48 8b 43 70 48 c7 c7 80 8a 37 94 48 89 42 8
> [ 2175.304313] RSP: 0018:ffffa9a94328beb8 EFLAGS: 00010286
> [ 2175.305261] RAX: 0000000000000000 RBX: ffff90b801c63a00 RCX: 0000000000000000
> [ 2175.306544] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 00000000ffffffff
> [ 2175.307815] RBP: 0000000000000800 R08: 0000000000004ffb R09: 00000000ffffefff
> [ 2175.309077] R10: 00000000ffffefff R11: ffffffff94265060 R12: 0000000000000000
> [ 2175.310353] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [ 2175.311632] FS:  00007fa76803b440(0000) GS:ffff90b8a9d84000(0000) knlGS:0000000000000000
> [ 2175.313063] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2175.314098] CR2: 0000560b6ad2e850 CR3: 000000000deac000 CR4: 00000000000006f0
> [ 2175.315221] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2175.316137] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 2175.317091] Call Trace:
> [ 2175.317433]  <TASK>
> [ 2175.317734]  exit_cifs+0x43/0x560 [cifs]
> [ 2175.318316]  __x64_sys_delete_module+0x1ad/0x2a0
> [ 2175.318958]  ? fpregs_assert_state_consistent+0x25/0x50
> [ 2175.319656]  do_syscall_64+0x4b/0x110
> [ 2175.320184]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 2175.320856] RIP: 0033:0x7fa767927977
> [ 2175.321359] Code: 73 01 c3 48 8b 0d a9 94 0c 00 f7 d8 64 89 01 48 83 c8 ff c3
> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 8b 0d 79 94 0c 00 f7 d8 64 89 8
> [ 2175.323766] RSP: 002b:00007ffd9f24c6f8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
> [ 2175.324766] RAX: ffffffffffffffda RBX: 000056460f617e30 RCX: 00007fa767927977
> [ 2175.325721] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000056460f617e98
> [ 2175.326580] RBP: 0000000000000000 R08: 1999999999999999 R09: 0000000000000000
> [ 2175.327329] R10: 00007fa767999ac0 R11: 0000000000000206 R12: 0000000000000000
> [ 2175.328086] R13: 0000000000000000 R14: 00007ffd9f24c730 R15: 00007ffd9f24dbe8
> [ 2175.328832]  </TASK>
> [ 2175.329090] ---[ end trace 0000000000000000 ]---
> 
> 
> These should be new issues. I'll get to the bottom of them as soon as I can.
> 
> Best regards,
> Wang Zhaolong
> 

I have identified the issue mentioned above. Below is my proposed fix:

https://lore.kernel.org/all/20250804134006.3609555-1-wangzhaolong@huaweicloud.com/

I'd like to kindly invite feedback and discussion from the community on this
issue, particularly regarding the root cause and the correctness of the
proposed solution. Any suggestions, concerns, or alternative approaches are
highly welcome.

Best regards,
Wang Zhaolong
