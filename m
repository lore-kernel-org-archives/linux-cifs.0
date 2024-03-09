Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com [209.85.208.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9023E2C6A9
	for <linux-cifs@vger.kernel.org>; Sat,  9 Mar 2024 22:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710023547; cv=none; b=nNVBoHNyZ0L3Y9gNke/emYo7gD0GNOB5VldXFhtCLyfCAN5T5uf71Bb99j6Mcyoa9d156tjsq7epTOdUWXNo6qn8dRN9nhl/YmejNJDjZjUlpFgV27sn3yC3XHXKXs7OfwaP4B7MkPUX28XJTn30qypkdSr6LL9IxvGXXeBJFIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710023547; c=relaxed/simple;
	bh=R3GFrcvjk3MEpG4fTB87ZoFMBmB/4bXZeJ+gXQAaHbE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=fkM5H3OTOIQbHuZJL0YFuOixpc1JAlzdhiJUuZmRSNdmCVThS6MSJGFgzojc935rPPkCTVuxJjhllc95HbLsCepRZ/97YKHPJgWki3V/BCTTeQLrSmfQ1MsmjVE52/S79H+bUP8oa0JdLa8iNOlzxBjXGwpXJJcjxmlrH6d1tuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aoZdz14V; arc=none smtp.client-ip=209.85.208.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aoZdz14V"
Received: by mail-lj1-f194.google.com with SMTP id 38308e7fff4ca-2d41f33eb05so21425231fa.0
        for <linux-cifs@vger.kernel.org>; Sat, 09 Mar 2024 14:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710023543; x=1710628343; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IMF9GgKCDXxOtapLXFOYOjC4mXw3A19ipNKKUgm/A2Y=;
        b=aoZdz14V7eDSSG8JPHwJ+WxZHBU5PAe5QgQzf9EZzpzZbdcCC0LhV19Nd7BflggYau
         CM6dFG+tIKWSoHBm0OIAjD1xr4yLN+igf1eAJG+/fZHeLqfySkwF5e2j7RKAAff506KC
         IEL2bYUWJufBi+KNx+Gs9MMAMvrBvnL+7oHsIZbaRb8TZH66eETDH94MCFC3ocPCOXiu
         EpTQYSQdxYGM0X5T7UqPKDPSpNFK2Yr8MK/2hK0CncQ+VF6nctjktvoOiWBwKJzdJqAN
         EJ5oUuwWQWDRd7MD/zX2YAr85OmhPLpc3ueeVA04M+NBSb7rXj46FHauwnSVHRQ/Nk4V
         Bxug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710023543; x=1710628343;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IMF9GgKCDXxOtapLXFOYOjC4mXw3A19ipNKKUgm/A2Y=;
        b=FmMsoIYQQUNarb5UB0r47xQQWbj6EhwrDHiY7qsdNAstNry5urtC4QgTYpPZAEpyu2
         KmD7e6nv2boK+B87/JsRhHgAhw9QLlKuTq/3SuvgcG9XMKqjJG74OJzxh4yvZiFj5hb3
         8J3g5jcWzkdLLIejgMBUyX23RuTEhqDmcqcIBa5og2xtJGpNc8Gu1Q7yWQ0zvFWchMFR
         u2m94QLTmrkQWs+RQImZZNwmBTqBE1bRtJo+UOlsnPiHMjCqSyMA59cNRb5c1nmLuuy3
         pUtQwe/Ap+A2UoE7bT//qsXsUcgHWHuu6Doekcs5EkhfQvyKj+ov8srTrKlyPnJSB6J4
         y5DA==
X-Gm-Message-State: AOJu0Yzkeid+ZEJ1r9V4vBtmpkN0NTnRxAqwpons+/nT611GzNEruBCa
	WkVkwUe5VVAixz7YJL4b27g2o/d+6GzwNv0oNsMI4zAYBIbQM4Fh3C5YGZB3t4B/Tje9LYTcheG
	Rl2384yIGy0z2GlNEbDeu4z9eLJc7pIP+Wte90HHC
X-Google-Smtp-Source: AGHT+IFQOITb1oXNVeYxA3x1YOtLI//u8WfLOivpvkiWA/g+86XuRXBW6v3qPpX1XMsNd+T6Ae6GpcnG928hro4zQLQ=
X-Received: by 2002:a2e:a584:0:b0:2d2:d0ba:2586 with SMTP id
 m4-20020a2ea584000000b002d2d0ba2586mr1594878ljp.24.1710023542987; Sat, 09 Mar
 2024 14:32:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 9 Mar 2024 16:32:11 -0600
Message-ID: <CAH2r5mvsz0ebtqR4W2_rqzkHonKCbb9yR7pvuiUfuuQytcVZ5w@mail.gmail.com>
Subject: hang on tests generic/525 to Azure
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"

I saw the following hang on running generic/525 to Azure (with
multichannel).  Any ideas? Thoughts?

[10820.512212] run fstests generic/524 at 2024-03-09 14:43:18
[10821.207477] CIFS: Attempting to mount
//linuxsmb3testsharesmc.file.core.windows.net/test
[10822.802851] CIFS: Attempting to mount
//linuxsmb3testsharesmc.file.core.windows.net/scratch
[10830.810280] run fstests generic/525 at 2024-03-09 14:43:29
==================================================================
[10831.998037] BUG: KASAN: slab-use-after-free in
_cifsFileInfo_put+0xaf/0x7b0 [cifs]
[10831.998185] Read of size 8 at addr ff1100012ee820a0 by task xfs_io/2391

[10831.998191] CPU: 7 PID: 2391 Comm: xfs_io Not tainted 6.8.0-rc7 #1
[10831.998195] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[10831.998197] Call Trace:
[10831.998200]  <TASK>
[10831.998202]  dump_stack_lvl+0x5c/0x90
[10831.998214]  print_report+0xcc/0x620
[10831.998220]  ? __virt_addr_valid+0x18d/0x2f0
[10831.998227]  ? _cifsFileInfo_put+0xaf/0x7b0 [cifs]
[10831.998347]  kasan_report+0xbe/0xf0
[10831.998353]  ? _cifsFileInfo_put+0xaf/0x7b0 [cifs]
[10831.998479]  _cifsFileInfo_put+0xaf/0x7b0 [cifs]
[10831.998600]  ? lock_acquire+0x157/0x3b0
[10831.998605]  ? fs_reclaim_acquire+0x67/0xf0
[10831.998611]  ? __pfx__cifsFileInfo_put+0x10/0x10 [cifs]
[10831.998733]  ? lock_release+0x1c8/0x390
[10831.998736]  ? kmalloc_trace+0x4d/0x370
[10831.998742]  ? __pfx_lock_release+0x10/0x10
[10831.998746]  ? kasan_unpoison+0x27/0x60
[10831.998750]  ? __kasan_slab_alloc+0x30/0x70
[10831.998754]  ? rcu_is_watching+0x23/0x50
[10831.998759]  ? kmalloc_trace+0x2b4/0x370
[10831.998766]  cifs_close+0xf8/0x320 [cifs]
[10831.998889]  ? task_work_run+0xc7/0x150
[10831.998895]  __fput+0x132/0x4f0
[10831.998902]  task_work_run+0xed/0x150
[10831.998906]  ? __pfx_task_work_run+0x10/0x10
[10831.998909]  ? do_raw_spin_unlock+0x9d/0x100
[10831.998915]  do_exit+0x58d/0x1240
[10831.998920]  ? lock_release+0x1c8/0x390
[10831.998924]  ? __pfx_do_exit+0x10/0x10
[10831.998927]  ? __pfx_lock_release+0x10/0x10
[10831.998931]  ? do_raw_spin_lock+0x10e/0x190
[10831.998935]  ? mark_held_locks+0x24/0x90
[10831.998939]  do_group_exit+0x68/0x110
[10831.998944]  get_signal+0x11c4/0x11d0
[10831.998949]  ? lockdep_hardirqs_on_prepare+0x13a/0x200
[10831.998953]  ? finish_task_switch.isra.0+0x1a7/0x4f0
[10831.998959]  ? __pfx_get_signal+0x10/0x10
[10831.998962]  ? __schedule+0x728/0x1790
[10831.998969]  arch_do_signal_or_restart+0x7a/0x3b0
[10831.998975]  ? __pfx_arch_do_signal_or_restart+0x10/0x10
[10831.998978]  ? __pfx___schedule+0x10/0x10
[10831.998982]  ? lock_release+0x1c8/0x390
[10831.998987]  ? mark_held_locks+0x24/0x90
[10831.998993]  syscall_exit_to_user_mode+0x1f3/0x2a0
[10831.998997]  do_syscall_64+0x8c/0x190
[10831.999003]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[10831.999014] RIP: 0033:0x7f0d79c434b2
[10831.999018] Code: Unable to access opcode bytes at 0x7f0d79c43488.
[10831.999020] RSP: 002b:00007f0d793ffd90 EFLAGS: 00000293 ORIG_RAX:
0000000000000022
[10831.999025] RAX: fffffffffffffdfe RBX: 0000000000000000 RCX: 00007f0d79c434b2
[10831.999028] RDX: 9b1399c5de36a46b RSI: 0000000000000000 RDI: 0000000000000000
[10831.999030] RBP: 0000000000000000 R08: 00007f0d79400700 R09: 00007f0d79400700
[10831.999033] R10: 00007f0d794009d0 R11: 0000000000000293 R12: 00007ffe48be931e
[10831.999035] R13: 00007ffe48be931f R14: 0000000000000000 R15: 00007f0d793ffe80
[10831.999042]  </TASK>

[10831.999045] Allocated by task 2390:
[10831.999047]  kasan_save_stack+0x24/0x50
[10831.999051]  kasan_save_track+0x14/0x30
[10831.999055]  __kasan_kmalloc+0x7f/0x90
[10831.999058]  cifs_new_fileinfo+0xbf/0x9d0 [cifs]
[10831.999213]  cifs_atomic_open+0x49c/0x9c0 [cifs]
[10831.999363]  lookup_open.isra.0+0x5ef/0x8f0
[10831.999368]  path_openat+0x492/0x10e0
[10831.999371]  do_filp_open+0x146/0x250
[10831.999374]  do_sys_openat2+0xe0/0x110
[10831.999379]  __x64_sys_openat+0xc1/0x120
[10831.999382]  do_syscall_64+0x80/0x190
[10831.999386]  entry_SYSCALL_64_after_hwframe+0x6e/0x76

[10831.999391] Freed by task 23873:
[10831.999393]  kasan_save_stack+0x24/0x50
[10831.999396]  kasan_save_track+0x14/0x30
[10831.999399]  kasan_save_free_info+0x3b/0x60
[10831.999402]  __kasan_slab_free+0x106/0x190
[10831.999406]  kfree+0xd7/0x2f0
[10831.999409]  process_one_work+0x452/0x8d0
[10831.999413]  worker_thread+0x36f/0x660
[10831.999417]  kthread+0x18a/0x1d0
[10831.999420]  ret_from_fork+0x34/0x60
[10831.999426]  ret_from_fork_asm+0x1b/0x30

[10831.999432] Last potentially related work creation:
[10831.999433]  kasan_save_stack+0x24/0x50
[10831.999437]  __kasan_record_aux_stack+0x8e/0xa0
[10831.999441]  insert_work+0x25/0xe0
[10831.999444]  __queue_work+0x309/0x810
[10831.999448]  queue_work_on+0x86/0x90
[10831.999451]  _cifsFileInfo_put+0x3d7/0x7b0 [cifs]
[10831.999603]  smb2_compound_op+0x11a4/0x3b10 [cifs]
[10831.999753]  smb2_set_path_size+0x1fa/0x250 [cifs]
[10831.999902]  cifs_set_file_size+0x1a3/0x430 [cifs]
[10832.000053]  cifs_setattr+0x13d0/0x18d0 [cifs]
[10832.000210]  notify_change+0x563/0x780
[10832.000214]  do_truncate+0xd6/0x150
[10832.000217]  do_sys_ftruncate+0x304/0x350
[10832.000221]  do_syscall_64+0x80/0x190
[10832.000225]  entry_SYSCALL_64_after_hwframe+0x6e/0x76

[10832.000230] The buggy address belongs to the object at ff1100012ee82000
                which belongs to the cache kmalloc-1k of size 1024
[10832.000232] The buggy address is located 160 bytes inside of
                freed 1024-byte region [ff1100012ee82000, ff1100012ee82400)

[10832.000237] The buggy address belongs to the physical page:
[10832.000239] page:00000000c3cfb2fc refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x12ee80
[10832.000243] head:00000000c3cfb2fc order:3 entire_mapcount:0
nr_pages_mapped:0 pincount:0
[10832.000246] flags:
0x17ffffc0000840(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
[10832.000250] page_type: 0xffffffff()
[10832.000254] raw: 0017ffffc0000840 ff1100010003cdc0 dead000000000100
dead000000000122
[10832.000258] raw: 0000000000000000 0000000080100010 00000001ffffffff
0000000000000000
[10832.000260] page dumped because: kasan: bad access detected

[10832.000263] Memory state around the buggy address:
[10832.000265]  ff1100012ee81f80: fc fc fc fc fc fc fc fc fc fc fc fc
fc fc fc fc
[10832.000267]  ff1100012ee82000: fa fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[10832.000270] >ff1100012ee82080: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[10832.000272]                                ^
[10832.000274]  ff1100012ee82100: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[10832.000276]  ff1100012ee82180: fb fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[10832.000278] ==================================================================
[10832.000308] Disabling lock debugging due to kernel taint
[10832.000313] list_del corruption, ff1100012ee82010->next is
LIST_POISON1 (dead000000000100)
[10832.000354] ------------[ cut here ]------------
[10832.000355] kernel BUG at lib/list_debug.c:56!
[10832.000422] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
[10832.000470] CPU: 7 PID: 2391 Comm: xfs_io Tainted: G    B
   6.8.0-rc7 #1
[10832.000523] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[10832.000568] RIP: 0010:__list_del_entry_valid_or_report+0xb9/0x100
[10832.000615] Code: e8 9c c4 5b ff 0f 0b 48 89 ee 48 c7 c7 e0 3b d2
ab e8 8b c4 5b ff 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 40 3c d2 ab e8 77
c4 5b ff <0f> 0b 4c 89 ea 48 89 ee 48 c7 c7 a0 3c d2 ab e8 63 c4 5b ff
0f 0b
[10832.000737] RSP: 0018:ff1100010caef978 EFLAGS: 00010282
[10832.000777] RAX: 000000000000004e RBX: ffffffffc19f8960 RCX: 0000000000000027
[10832.000827] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ff110004cb3b19c8
[10832.000875] RBP: ff1100012ee82010 R08: ffffffffaa3f971e R09: ffe21c0099676339
[10832.000924] R10: ff110004cb3b19cb R11: 0000000000000000 R12: dead000000000100
[10832.000973] R13: dead000000000122 R14: ff1100012ee82018 R15: ff1100012ee82010
[10832.001044] FS:  0000000000000000(0000) GS:ff110004cb380000(0000)
knlGS:0000000000000000
[10832.001126] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10832.001178] CR2: 00007ff18b8ec738 CR3: 0000000420660003 CR4: 0000000000371ef0
[10832.001248] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10832.001311] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[10832.001373] Call Trace:
[10832.001397]  <TASK>
[10832.001419]  ? die+0x37/0x90
[10832.001451]  ? do_trap+0x134/0x230
[10832.001487]  ? __list_del_entry_valid_or_report+0xb9/0x100
[10832.001542]  ? do_error_trap+0x94/0x130
[10832.001581]  ? __list_del_entry_valid_or_report+0xb9/0x100
[10832.001632]  ? __list_del_entry_valid_or_report+0xb9/0x100
[10832.001685]  ? handle_invalid_op+0x2c/0x40
[10832.001724]  ? __list_del_entry_valid_or_report+0xb9/0x100
[10832.001775]  ? exc_invalid_op+0x2f/0x50
[10832.001813]  ? asm_exc_invalid_op+0x1a/0x20
[10832.001856]  ? irq_work_claim+0x1e/0x40
[10832.001898]  ? __list_del_entry_valid_or_report+0xb9/0x100
[10832.001950]  ? __list_del_entry_valid_or_report+0xb9/0x100
[10832.002002]  _cifsFileInfo_put+0x233/0x7b0 [cifs]
[10832.002218]  ? __pfx__cifsFileInfo_put+0x10/0x10 [cifs]
[10832.002419]  cifs_close+0xf8/0x320 [cifs]
[10832.002603]  ? task_work_run+0xc7/0x150
[10832.002642]  __fput+0x132/0x4f0
[10832.002677]  task_work_run+0xed/0x150
[10832.002713]  ? __pfx_task_work_run+0x10/0x10
[10832.002754]  ? do_raw_spin_unlock+0x9d/0x100
[10832.002797]  do_exit+0x58d/0x1240
[10832.004329]  ? lock_release+0x1c8/0x390
[10832.005836]  ? __pfx_do_exit+0x10/0x10
[10832.007341]  ? __pfx_lock_release+0x10/0x10
[10832.008831]  ? do_raw_spin_lock+0x10e/0x190
[10832.010712]  ? mark_held_locks+0x24/0x90
[10832.012274]  do_group_exit+0x68/0x110
[10832.013690]  get_signal+0x11c4/0x11d0
[10832.015079]  ? lockdep_hardirqs_on_prepare+0x13a/0x200
[10832.016479]  ? finish_task_switch.isra.0+0x1a7/0x4f0
[10832.017849]  ? __pfx_get_signal+0x10/0x10
[10832.019210]  ? __schedule+0x728/0x1790
[10832.020508]  arch_do_signal_or_restart+0x7a/0x3b0
[10832.021767]  ? __pfx_arch_do_signal_or_restart+0x10/0x10
[10832.023007]  ? __pfx___schedule+0x10/0x10
[10832.024234]  ? lock_release+0x1c8/0x390
[10832.025443]  ? mark_held_locks+0x24/0x90
[10832.026636]  syscall_exit_to_user_mode+0x1f3/0x2a0
[10832.027827]  do_syscall_64+0x8c/0x190
[10832.029007]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[10832.030195] RIP: 0033:0x7f0d79c434b2
[10832.031342] Code: Unable to access opcode bytes at 0x7f0d79c43488.
[10832.032505] RSP: 002b:00007f0d793ffd90 EFLAGS: 00000293 ORIG_RAX:
0000000000000022
[10832.033708] RAX: fffffffffffffdfe RBX: 0000000000000000 RCX: 00007f0d79c434b2
[10832.034933] RDX: 9b1399c5de36a46b RSI: 0000000000000000 RDI: 0000000000000000
[10832.036159] RBP: 0000000000000000 R08: 00007f0d79400700 R09: 00007f0d79400700
[10832.037390] R10: 00007f0d794009d0 R11: 0000000000000293 R12: 00007ffe48be931e
[10832.038635] R13: 00007ffe48be931f R14: 0000000000000000 R15: 00007f0d793ffe80
[10832.039894]  </TASK>
[10832.041129] Modules linked in: loop cmac nls_utf8 cifs cifs_arc4
nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver
nfs lockd grace netfs nf_conntrack_netbios_ns nf_conntrack_broadcast
xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT
nf_reject_ipv4 xt_conntrack ebtable_nat ip6table_nat ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_nat iptable_mangle
iptable_raw iptable_security nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter sunrpc kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul bochs ghash_clmulni_intel
drm_vram_helper sha512_ssse3 drm_ttm_helper sha1_ssse3 ttm
drm_kms_helper drm floppy virtio_balloon ip_tables xfs crc32c_intel
virtio_net virtio_console net_failover sha256_ssse3 virtio_blk
failover qemu_fw_cfg
[10832.051923] ---[ end trace 0000000000000000 ]---
[10832.053867] RIP: 0010:__list_del_entry_valid_or_report+0xb9/0x100
[10832.055636] Code: e8 9c c4 5b ff 0f 0b 48 89 ee 48 c7 c7 e0 3b d2
ab e8 8b c4 5b ff 0f 0b 4c 89 e2 48 89 ee 48 c7 c7 40 3c d2 ab e8 77
c4 5b ff <0f> 0b 4c 89 ea 48 89 ee 48 c7 c7 a0 3c d2 ab e8 63 c4 5b ff
0f 0b
[10832.059161] RSP: 0018:ff1100010caef978 EFLAGS: 00010282
[10832.060769] RAX: 000000000000004e RBX: ffffffffc19f8960 RCX: 0000000000000027
[10832.062562] RDX: 0000000000000027 RSI: 0000000000000004 RDI: ff110004cb3b19c8
[10832.064342] RBP: ff1100012ee82010 R08: ffffffffaa3f971e R09: ffe21c0099676339
[10832.066228] R10: ff110004cb3b19cb R11: 0000000000000000 R12: dead000000000100
[10832.068074] R13: dead000000000122 R14: ff1100012ee82018 R15: ff1100012ee82010
[10832.069816] FS:  0000000000000000(0000) GS:ff110004cb380000(0000)
knlGS:0000000000000000
[10832.071716] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[10832.073581] CR2: 00007ff18b8ec738 CR3: 0000000420660003 CR4: 0000000000371ef0
[10832.075463] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10832.077314] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[10832.079120] note: xfs_io[2391] exited with preempt_count 2
[10832.080875] Fixing recursive fault but reboot is needed!
[10832.083187] BUG: scheduling while atomic: xfs_io/2391/0x00000000
[10832.085515] INFO: lockdep is turned off.
[10832.087412] Modules linked in: loop cmac nls_utf8 cifs cifs_arc4
nls_ucs2_utils cifs_md4 rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver
nfs lockd grace netfs nf_conntrack_netbios_ns nf_conntrack_broadcast
xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT
nf_reject_ipv4 xt_conntrack ebtable_nat ip6table_nat ip6table_mangle
ip6table_raw ip6table_security iptable_nat nf_nat iptable_mangle
iptable_raw iptable_security nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nfnetlink ebtable_filter ebtables
ip6table_filter ip6_tables iptable_filter sunrpc kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul bochs ghash_clmulni_intel
drm_vram_helper sha512_ssse3 drm_ttm_helper sha1_ssse3 ttm
drm_kms_helper drm floppy virtio_balloon ip_tables xfs crc32c_intel
virtio_net virtio_console net_failover sha256_ssse3 virtio_blk
failover qemu_fw_cfg
[10832.103205] CPU: 7 PID: 2391 Comm: xfs_io Tainted: G    B D
   6.8.0-rc7 #1
[10832.105580] Hardware name: Red Hat KVM, BIOS 1.16.1-1.el9 04/01/2014
[10832.108018] Call Trace:
[10832.110493]  <TASK>
[10832.113007]  dump_stack_lvl+0x77/0x90
[10832.115460]  __schedule_bug+0x84/0xa0
[10832.117877]  __schedule+0x148a/0x1790
[10832.120252]  ? __irq_work_queue_local+0x57/0x180
[10832.122601]  ? lock_acquire+0xbf/0x3b0
[10832.124925]  ? __pfx___schedule+0x10/0x10
[10832.127254]  ? do_task_dead+0x43/0x60
[10832.129560]  ? __pfx_lock_release+0x10/0x10
[10832.131863]  ? __pfx_do_raw_spin_lock+0x10/0x10
[10832.134176]  ? __pfx__printk+0x10/0x10
[10832.136450]  ? lockdep_hardirqs_on_prepare+0x12/0x200
[10832.138690]  ? _raw_spin_unlock_irqrestore+0x31/0x60
[10832.140874]  do_task_dead+0x5a/0x60
[10832.142994]  make_task_dead+0x1e3/0x210
[10832.145058]  rewind_stack_and_make_dead+0x17/0x20
[10832.147082] RIP: 0033:0x7f0d79c434b2
[10832.149041] Code: Unable to access opcode bytes at 0x7f0d79c43488.
[10832.150979] RSP: 002b:00007f0d793ffd90 EFLAGS: 00000293 ORIG_RAX:
0000000000000022
[10832.152927] RAX: fffffffffffffdfe RBX: 0000000000000000 RCX: 00007f0d79c434b2
[10832.154873] RDX: 9b1399c5de36a46b RSI: 0000000000000000 RDI: 0000000000000000
[10832.156774] RBP: 0000000000000000 R08: 00007f0d79400700 R09: 00007f0d79400700
[10832.158632] R10: 00007f0d794009d0 R11: 0000000000000293 R12: 00007ffe48be931e
[10832.160469] R13: 00007ffe48be931f R14: 0000000000000000 R15: 00007f0d793ffe80
[10832.162292]  </TASK>


-- 
Thanks,

Steve
