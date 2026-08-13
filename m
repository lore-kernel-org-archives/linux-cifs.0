Received: from mta1.migadu.com (out-129.mta1.migadu.com [95.215.58.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5242943BDB1
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 08:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786608018; cv=none; b=ta6zgYFlB8DQxZi3uNTwmla0Kcx5F3UuQf/7AjwzZvDmAYUnpaS7AOmV/cXOiFpTIi/U2xRsMwQvklzaiTS/T5+5I3jL8U+6FBx6CdrkVMXVpPGVutQO10edfW2a61ttX/g2s1AEr7Ng7Tn3gZTDfE1ztlrThjEGNiTa6aqDXdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786608018; c=relaxed/simple;
	bh=LFbVfgcs6PDqUFQAMpCkTzlOHjCbITB4rOeFLSnQvMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fW++mxPVFnP57qQsLs1KzKmFEUYWXcrFjbNNTOqqYPKQYUxqDXl6mWSzXhagu8NWgELvYc6HokyeXmISIJpBQF394f0pDTGxD0+FpGVFbAhliyo5I/LqSvev/WHO5ZUXc1qSrJ49M535f7VtbVxXsIkKXA2rUm9P8ro1pwMc8kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Xps6FQ7C; arc=none smtp.client-ip=95.215.58.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Xps6FQ7C"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LFbVfgcs6PDqUFQAMpCkTzlOHjCbITB4rOeFLSnQvMA=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786608006; v=1; x=1787212806;
 b=Xps6FQ7CB4vFijTwt+5XeTIZ4C/NSnVGuM1LLapKHa5RbdMMO5CyH+3eJMDcSNtAc9hiERl8
 iv0totTnw3XBZrmOrTIG2RC4lHeBS0hk3zVIXsYHzA3LpotCsmoW2iAAsLGuzBzn/f377yVzdgU
 HDX7rKIKH+xbFxBZwbSNosZjIOB+RiJQRH1U1WyUSm6F2ykqU09Chr0X/dhjzFsgyw1aR9dWMTS
 szaX/DiJ2AAPNVfTomWfLNQysPWCAgMzubwSvXEdkQXVzwfuUMy9G4Yz60QyvKb4cmJzEWhCsKv
 NRfDqFMIRvmmP14DgDxlO2csJ7aqQ7AY8T15HnKH2CxiA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 745a77200340b119;
	Thu, 13 Aug 2026 07:59:56 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com>
Date: Thu, 13 Aug 2026 15:59:47 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: Blue bird <obnred@gmail.com>, linkinjeon@kernel.org, smfrench@gmail.com
Cc: senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/13/26 00:09, Blue bird wrote:
> 
> Call trace
> ----------
> 
>    kernel BUG at fs/locks.c:312!
>    Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>    CPU: 4 UID: 0 PID: 1509 Comm: ksmbd:::ffff:12 Not tainted 7.2.0-rc7- 
> gf5bbbfec59b4
>    pc : locks_release_private+0x214/0x2c8
>    Call trace:
>     locks_release_private+0x214/0x2c8 (P)
>     locks_free_lock+0x20/0x40
>     __ksmbd_close_fd+0x67c/0xc28          [ksmbd]
>     __close_file_table_ids+0x430/0x780    [ksmbd]
>     ksmbd_destroy_file_table+0x5c/0xf4    [ksmbd]
>     ksmbd_session_destroy+0xbc/0x38c      [ksmbd]
>     ksmbd_sessions_deregister+0x3fc/0x5c8 [ksmbd]
>     ksmbd_server_terminate_conn+0x20/0x40 [ksmbd]
>     ksmbd_conn_handler_loop+0x4b4/0xd10   [ksmbd]
> 
> fs/locks.c:312 is BUG_ON(!list_empty(&flc->flc_blocked_requests));

Hi Blue,

Thank you for reporting this issue and providing the poc.

I reproduced the same BUG_ON on mainline. However, it could not be 
reproduced on the ksmbd-for-next-next branch, but another UAF issue was 
found, I will continue debugging it.

```
LF_SECONDS=10 python3 -u lockfuzz2.py
t=5s locks_sent=0 faults=0
t=10s locks_sent=0 faults=0

lsmod | grep ksmbd
ksmbd                1236992  0

modprobe -r ksmbd # slab-use-after-free
```

[  170.722187] 
==================================================================
[  170.724724] BUG: KASAN: slab-use-after-free in proc_remove+0x3e/0x80
[  170.726934] Read of size 8 at addr ffff8881044eff98 by task modprobe/1019

[  170.729907] CPU: 5 UID: 0 PID: 1019 Comm: modprobe Not tainted 
7.2.0-rc7+ #5 PREEMPT(full)
[  170.729917] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.17.0-9.fc43 06/10/2025
[  170.729922] Call Trace:
[  170.729926]  <TASK>
[  170.729930]  __dump_stack+0x19/0x30
[  170.729939]  dump_stack_lvl+0x49/0x60
[  170.729945]  print_address_description+0x7b/0x200
[  170.729952]  ? proc_remove+0x3e/0x80
[  170.729958]  print_report+0x5b/0x70
[  170.729980]  kasan_report+0xed/0x130
[  170.729987]  ? proc_remove+0x3e/0x80
[  170.729996]  __asan_report_load8_noabort+0x18/0x20
[  170.730001]  proc_remove+0x3e/0x80
[  170.730006]  ksmbd_conn_transport_destroy+0x2b/0x320 [ksmbd]
[  170.730073]  cleanup_module+0x33/0xe00 [ksmbd]
[  170.730126]  __se_sys_delete_module+0x276/0x400
[  170.730133]  ? fput_close_sync+0x9a/0x110
[  170.730138]  __x64_sys_delete_module+0x5f/0x70
[  170.730143]  x64_sys_call+0x2675/0x3030
[  170.730147]  do_syscall_64+0xf0/0x3b0
[  170.730153]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  170.730157] RIP: 0033:0x7f81a592b02b
[  170.730162] Code: 73 01 c3 48 8b 0d ed ad 0c 00 f7 d8 64 89 01 48 83 
c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d bd ad 0c 00 f7 d8 64 89 01 48
[  170.730166] RSP: 002b:00007fff84d9cdb8 EFLAGS: 00000206 ORIG_RAX: 
00000000000000b0
[  170.730172] RAX: ffffffffffffffda RBX: 000055993a2f5ca0 RCX: 
00007f81a592b02b
[  170.730176] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 
000055993a2f5d08
[  170.730178] RBP: 00007fff84d9cde0 R08: 1999999999999999 R09: 
0000000000000000
[  170.730181] R10: 00007f81a59a5fe0 R11: 0000000000000206 R12: 
0000000000000000
[  170.730184] R13: 00007fff84d9ce10 R14: 0000000000000000 R15: 
0000000000000000
[  170.730188]  </TASK>

[  170.778338] Allocated by task 141:
[  170.779443]  kasan_save_track+0x2f/0x70
[  170.780675]  kasan_save_alloc_info+0x40/0x50
[  170.782044]  __kasan_slab_alloc+0x52/0x70
[  170.783312]  kmem_cache_alloc_noprof+0x168/0x3e0
[  170.784715]  __proc_create+0x20b/0x710
[  170.785846]  proc_create_single_data+0x78/0x150
[  170.786703]  ksmbd_proc_create+0x24/0x30 [ksmbd]
[  170.787525]  ksmbd_conn_transport_init+0x4f/0x80 [ksmbd]
[  170.788525]  server_ctrl_handle_work+0x64/0x2c0 [ksmbd]
[  170.789471]  process_scheduled_works+0x788/0xec0
[  170.790295]  worker_thread+0x894/0xc10
[  170.790986]  kthread+0x2e5/0x3c0
[  170.791548]  ret_from_fork+0x168/0x4f0
[  170.792256]  ret_from_fork_asm+0x1a/0x30

[  170.793241] Freed by task 1019:
[  170.793802]  kasan_save_track+0x2f/0x70
[  170.794411]  kasan_save_free_info+0x4a/0x60
[  170.795155]  __kasan_slab_free+0x47/0x70
[  170.795878]  kmem_cache_free+0x122/0x410
[  170.796556]  pde_put+0xfd/0x160
[  170.797156]  remove_proc_subtree+0x365/0x540
[  170.797910]  proc_remove+0x6a/0x80
[  170.798500]  ksmbd_proc_cleanup+0x1f/0x60 [ksmbd]
[  170.799389]  cleanup_module+0x18/0xe00 [ksmbd]
[  170.800243]  __se_sys_delete_module+0x276/0x400
[  170.801046]  __x64_sys_delete_module+0x5f/0x70
[  170.801827]  x64_sys_call+0x2675/0x3030
[  170.802498]  do_syscall_64+0xf0/0x3b0
[  170.803155]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

[  170.804362] The buggy address belongs to the object at ffff8881044eff00
                 which belongs to the cache proc_dir_entry of size 192
[  170.806657] The buggy address is located 152 bytes inside of
                 freed 192-byte region [ffff8881044eff00, ffff8881044effc0)

[  170.809083] The buggy address belongs to the physical page:
[  170.810057] page: refcount:0 mapcount:0 mapping:0000000000000000 
index:0x0 pfn:0x1044ee
[  170.811450] head: order:1 mapcount:0 entire_mapcount:0 
nr_pages_mapped:0 pincount:0
[  170.812749] flags: 
0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
[  170.813918] page_type: f5(slab)
[  170.814464] raw: 0017ffffc0000040 ffff888100a252c0 dead000000000100 
dead000000000122
[  170.815773] raw: 0000000000000000 0000000800200020 00000000f5000000 
0000000000000000
[  170.817065] head: 0017ffffc0000040 ffff888100a252c0 dead000000000100 
dead000000000122
[  170.818361] head: 0000000000000000 0000000800200020 00000000f5000000 
0000000000000000
[  170.819656] head: 0017ffffc0000001 ffffffffffffff81 00000000ffffffff 
00000000ffffffff
[  170.820991] head: ffffffffffffffff 0000000000000000 00000000ffffffff 
0000000000000002
[  170.822282] page dumped because: kasan: bad access detected

[  170.823477] Memory state around the buggy address:
[  170.824297]  ffff8881044efe80: 00 00 00 00 00 00 00 00 fc fc fc fc fc 
fc fc fc
[  170.825501]  ffff8881044eff00: fa fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[  170.826698] >ffff8881044eff80: fb fb fb fb fb fb fb fb fc fc fc fc fc 
fc fc fc
[  170.827971]                             ^
[  170.828634]  ffff8881044f0000: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[  170.829862]  ffff8881044f0080: 00 fc fc fc fc fc fc fc fc 00 00 00 00 
00 00 00
[  170.831072] 
==================================================================

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

