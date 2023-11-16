Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Coj8IL+g"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAC01A5
	for <linux-cifs@vger.kernel.org>; Thu, 16 Nov 2023 09:10:14 -0800 (PST)
Message-ID: <7fe9a29a4df9c00e91c7d9eafe588f1c.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700154612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DUrXSOHuSbBo0EOMBxrApMRRa8T2eJ5BIgxz3CMmttc=;
	b=Coj8IL+gKL3TZxIVluDZl/fh/yT+2/Vz0B9/o33pjsdz6LPWwStAY2X3DTQ+FdkGZBvHLG
	JB8z/8Vi/V5bCefC2RHm2/zBaNDMMsA359Y562ZkFUznorR7O0IAAlvSz7YZm6x6mMcWvL
	QPXeVpQ6CSAhUM7yeSd07vCZDgljHNtEwnIoAWCfyhp+g3H9hs+lpEsAfjetrJCHw7q7G3
	ZNL8M6WjaTaXJDYFBzrQOQOn3QycDrqU7dZwatSKT3cCxz5NqOiJUiPasSmnxEF70bHyYQ
	bUbltiXWYgGvfmw4Pm4gK2ZHVZTsdx3B3DMpMeYPY+659r8n5iOTHkyy9cb3ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700154612; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DUrXSOHuSbBo0EOMBxrApMRRa8T2eJ5BIgxz3CMmttc=;
	b=F/JWq5kkGLojESN9fJsCC69v+xtBh63rbDhZGDe/6GjsmiwadIqHC6GQ8leGoktRnw5fhp
	S5fcBiqfT9Pd5qMU0hvxu/8eckI4AiqwA1G9fQ9p3jv3Mfikdi+07MYYg2ulUuK1bTJyOc
	VRjcrnQ+t6h/GCdvipof3EtQZZGPDAkLhUiu85zjVJXtjWJn6jWhziNRdUoveR/0wVcoix
	vBd7Y+3pPMHti0A5/m0l++QtPR4WpteB0gqL1IDiktCwK8N/P9GgJnct2c+mCWAlq9S4pq
	65AsFkuD/CPz4/iESPC9MfQKu4kNWssPbFfqMDYDr5+QqOAsBB6p1kfOcYyuWg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700154612; a=rsa-sha256;
	cv=none;
	b=dg8Z7mgcFB1/3EB92orEHfIzY6eL/WERc9nYbXQV8+SZtAL3ydL3OVQa5xoTd9N7sBcwSy
	vK8c3QNqHDgE7fSXBO6YwHzzijQ1gMAf6+PzJnyQ3lhYDRY6OwADJJ/K6GKwyfsZjKcPTg
	l6QGj+EU+HqoggBychGqRUtPVsEJAHGmXnErRkIiYorNovpAQoN/1+KIeAM393Qt+/NLSJ
	XQAfJcpCk15JH6Ha68Vk76badcGw7UVo83m4RGrzPTswx2Uaab1adIpx0YNYGwg1yL0ayE
	tZyK2GdWwI1Qc1zYGHEFgXiDoqr14xcv+fwb49Jh8RB9YK6tD1seGtxeiiieeg==
From: Paulo Alcantara <pc@manguebit.com>
To: nspmangalore@gmail.com, smfrench@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 10/14] cifs: reconnect work should have reference on
 server struct
In-Reply-To: <20231030110020.45627-10-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-10-sprasad@microsoft.com>
Date: Thu, 16 Nov 2023 14:10:07 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> The delayed work for reconnect takes server struct
> as a parameter. But it does so without holding a ref
> to it. Normally, this may not show a problem as
> the reconnect work is only cancelled on umount.
>
> However, since we now plan to support scaling down of
> channels, and the scale down can happen from reconnect
> work itself, we need to fix it.
>
> This change takes a reference on the server struct
> before it is passed to the delayed work. And drops
> the reference in the delayed work itself. Or if
> the delayed work is successfully cancelled, by the
> process that cancels it.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/connect.c | 27 +++++++++++++++++++++------
>  fs/smb/client/smb2pdu.c | 23 +++++++++++++----------
>  2 files changed, 34 insertions(+), 16 deletions(-)

Several DFS tests are failing with current for-next (5eef12c4e323),
either crashing or leaking server connections.

I've managed to reproduce one of the problems without multichannel
against Windows Server 2022.  Can't reproduce it on v6.6.

DFS layout:

  //dom/dfs
    -> /srv1/dfs
    -> /srv2/dfs

$ mount //dom/dfs /mnt -o ...,vers=3.1.1,echo_interval=10
# disconnect root server that client connected first (srv1 or srv2)
$ ls /mnt/1
ls: cannot access '/mnt/1': Host is down
ls /mnt/1

[   54.455794] CIFS: No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1) specify vers=1.0 on mount.
[   54.958219] CIFS: VFS: Autodisabling the use of server inode numbers on new server
[   54.959049] CIFS: VFS: The server doesn't seem to support them properly or the files might be on different servers (DFS)
[   54.960031] CIFS: VFS: Hardlinks will not be recognized on this mount. Consider mounting with the "noserverino" option to silence this message.
[  100.935813] CIFS: VFS: \\W22-ROOT1.GANDALF.TEST has not responded in 30 seconds. Reconnecting...
[  106.258652] ls (899) used greatest stack depth: 21920 bytes left
[  113.252212] ==================================================================
[  113.253154] BUG: KASAN: slab-use-after-free in cifs_get_fattr+0x546/0xe70 [cifs]
[  113.254721] Read of size 8 at addr ffff88800aa76088 by task ls/942
[  113.255508] 
[  113.255720] CPU: 2 PID: 942 Comm: ls Not tainted 6.7.0-rc1 #4
[  113.256451] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
[  113.257809] Call Trace:
[  113.258132]  <TASK>
[  113.258413]  dump_stack_lvl+0x4a/0x80
[  113.258897]  print_report+0xcf/0x650
[  113.259368]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.259980]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.260375]  ? __phys_addr+0x46/0x90
[  113.260676]  kasan_report+0xd8/0x110
[  113.260976]  ? cifs_get_fattr+0x546/0xe70 [cifs]
[  113.261745]  ? cifs_get_fattr+0x546/0xe70 [cifs]
[  113.262521]  cifs_get_fattr+0x546/0xe70 [cifs]
[  113.263284]  ? __pfx_cifs_get_fattr+0x10/0x10 [cifs]
[  113.264079]  ? irq_work_queue+0xe/0x40
[  113.264391]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.264785]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.265177]  ? vprintk_emit+0xf8/0x310
[  113.265496]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.265886]  ? _printk+0xc0/0xf0
[  113.266159]  ? __pfx__printk+0x10/0x10
[  113.266479]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.266870]  ? __dynamic_pr_debug+0x1f5/0x260
[  113.267232]  ? __pfx___dynamic_pr_debug+0x10/0x10
[  113.267616]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.268011]  cifs_get_inode_info+0x157/0x210 [cifs]
[  113.268807]  ? __pfx_cifs_get_inode_info+0x10/0x10 [cifs]
[  113.269642]  ? __pfx____ratelimit+0x10/0x10
[  113.269994]  cifs_revalidate_dentry_attr+0x2c5/0x450 [cifs]
[  113.270836]  ? __pfx_cifs_revalidate_dentry_attr+0x10/0x10 [cifs]
[  113.271720]  cifs_getattr+0x28f/0x450 [cifs]
[  113.272473]  vfs_statx+0x1f6/0x240
[  113.272760]  ? __pfx_vfs_statx+0x10/0x10
[  113.273083]  ? lock_acquire+0x14a/0x3a0
[  113.273405]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.273797]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.274192]  do_statx+0xac/0x110
[  113.274466]  ? __pfx_do_statx+0x10/0x10
[  113.274783]  ? __pfx_lock_release+0x10/0x10
[  113.275138]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.275532]  ? getname_flags.part.0+0xd6/0x260
[  113.275896]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.276289]  __x64_sys_statx+0xa0/0xc0
[  113.276603]  do_syscall_64+0x47/0xf0
[  113.276904]  entry_SYSCALL_64_after_hwframe+0x6f/0x77
[  113.277315] RIP: 0033:0x7f844366c8de
[  113.277611] Code: a5 fd ff ff e8 b1 e4 01 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 90 90 41 89 ca b8 4c 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2a 89 c1 85 c0 74 0f 48 8b 05 0d 05 0e 00 64
[  113.279073] RSP: 002b:00007fff09d8cdb8 EFLAGS: 00000246 ORIG_RAX: 000000000000014c
[  113.279677] RAX: ffffffffffffffda RBX: 000055f7065b37b8 RCX: 00007f844366c8de
[  113.280244] RDX: 0000000000000800 RSI: 00007fff09d8eb1c RDI: 00000000ffffff9c
[  113.280811] RBP: 0000000000000002 R08: 00007fff09d8cdc0 R09: 0000000000000001
[  113.281378] R10: 0000000000000002 R11: 0000000000000246 R12: 000055f7065b37b8
[  113.281946] R13: 000000000000002f R14: 00007fff09d8eb1a R15: 000055f7065b37a0
[  113.282525]  </TASK>
[  113.282713] 
[  113.282847] Allocated by task 880:
[  113.283128]  kasan_save_stack+0x33/0x60
[  113.283446]  kasan_set_track+0x25/0x30
[  113.283756]  __kasan_kmalloc+0x8f/0xa0
[  113.284065]  cifs_get_tcp_session+0xbc/0xc70 [cifs]
[  113.284850]  cifs_mount_get_session+0x70/0x220 [cifs]
[  113.285651]  dfs_mount_share+0xa60/0x1060 [cifs]
[  113.286420]  cifs_mount+0xda/0x4c0 [cifs]
[  113.287141]  cifs_smb3_do_mount+0x1e5/0xcc0 [cifs]
[  113.287919]  smb3_get_tree+0x16d/0x380 [cifs]
[  113.288670]  vfs_get_tree+0x4d/0x190
[  113.288973]  path_mount+0x3c4/0xf90
[  113.289265]  __x64_sys_mount+0x1aa/0x1f0
[  113.289589]  do_syscall_64+0x47/0xf0
[  113.289892]  entry_SYSCALL_64_after_hwframe+0x6f/0x77
[  113.290311] 
[  113.290447] Freed by task 893:
[  113.290702]  kasan_save_stack+0x33/0x60
[  113.291019]  kasan_set_track+0x25/0x30
[  113.291329]  kasan_save_free_info+0x2b/0x50
[  113.291673]  ____kasan_slab_free+0x126/0x170
[  113.292025]  slab_free_freelist_hook+0x9d/0x1e0
[  113.292400]  __kmem_cache_free+0x9d/0x190
[  113.292731]  clean_demultiplex_info+0x3bb/0x640 [cifs]
[  113.293536]  cifs_demultiplex_thread+0x3de/0x1270 [cifs]
[  113.294346]  kthread+0x18d/0x1d0
[  113.294616]  ret_from_fork+0x34/0x60
[  113.294912]  ret_from_fork_asm+0x1b/0x30
[  113.295234] 
[  113.295366] Last potentially related work creation:
[  113.295759]  kasan_save_stack+0x33/0x60
[  113.296075]  __kasan_record_aux_stack+0x94/0xa0
[  113.296442]  __queue_work+0x334/0x8a0
[  113.296746]  mod_delayed_work_on+0xa5/0x100
[  113.297087]  smb2_reconnect+0x735/0xcb0 [cifs]
[  113.297836]  SMB2_open_init+0xf8/0x13f0 [cifs]
[  113.298584]  smb2_compound_op+0x620/0x35b0 [cifs]
[  113.299363]  smb2_query_path_info+0x1c7/0x470 [cifs]
[  113.300154]  cifs_get_fattr+0x580/0xe70 [cifs]
[  113.300899]  cifs_get_inode_info+0x157/0x210 [cifs]
[  113.301677]  cifs_revalidate_dentry_attr+0x2c5/0x450 [cifs]
[  113.302512]  cifs_getattr+0x28f/0x450 [cifs]
[  113.303244]  vfs_statx+0x1f6/0x240
[  113.303523]  do_statx+0xac/0x110
[  113.303791]  __x64_sys_statx+0xa0/0xc0
[  113.304099]  do_syscall_64+0x47/0xf0
[  113.304395]  entry_SYSCALL_64_after_hwframe+0x6f/0x77
[  113.304803] 
[  113.304934] Second to last potentially related work creation:
[  113.305390]  kasan_save_stack+0x33/0x60
[  113.305711]  __kasan_record_aux_stack+0x94/0xa0
[  113.306078]  __queue_work+0x334/0x8a0
[  113.306380]  mod_delayed_work_on+0xa5/0x100
[  113.306722]  reconnect_dfs_server+0x69f/0x6b0 [cifs]
[  113.307505]  cifs_readv_from_socket+0x335/0x490 [cifs]
[  113.308300]  cifs_read_from_socket+0xb5/0x100 [cifs]
[  113.309085]  cifs_demultiplex_thread+0x274/0x1270 [cifs]
[  113.309894]  kthread+0x18d/0x1d0
[  113.310163]  ret_from_fork+0x34/0x60
[  113.310456]  ret_from_fork_asm+0x1b/0x30
[  113.310779] 
[  113.310912] The buggy address belongs to the object at ffff88800aa76000
[  113.310912]  which belongs to the cache kmalloc-4k of size 4096
[  113.311884] The buggy address is located 136 bytes inside of
[  113.311884]  freed 4096-byte region [ffff88800aa76000, ffff88800aa77000)
[  113.312845] 
[  113.312979] The buggy address belongs to the physical page:
[  113.313420] page:00000000c46c12fc refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xaa70
[  113.314141] head:00000000c46c12fc order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  113.314775] flags: 0x100000000000840(slab|head|node=0|zone=1)
[  113.315234] page_type: 0xffffffff()
[  113.315525] raw: 0100000000000840 ffff888006443040 ffffea0000430400 dead000000000002
[  113.316138] raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
[  113.316747] page dumped because: kasan: bad access detected
[  113.317195] 
[  113.317329] Memory state around the buggy address:
[  113.317721]  ffff88800aa75f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  113.318305]  ffff88800aa76000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  113.318889] >ffff88800aa76080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  113.319468]                       ^
[  113.319758]  ffff88800aa76100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  113.320342]  ffff88800aa76180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  113.320926] ==================================================================
[  113.321531] Kernel panic - not syncing: kasan.fault=panic set ...
[  113.322029] CPU: 2 PID: 942 Comm: ls Not tainted 6.7.0-rc1 #4
[  113.322507] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
[  113.323393] Call Trace:
[  113.323604]  <TASK>
[  113.323787]  dump_stack_lvl+0x4a/0x80
[  113.324099]  panic+0x41f/0x460
[  113.324363]  ? __pfx_panic+0x10/0x10
[  113.324665]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.325070]  ? check_panic_on_warn+0x2f/0x80
[  113.325437]  end_report+0x125/0x130
[  113.325737]  kasan_report+0xe8/0x110
[  113.326043]  ? cifs_get_fattr+0x546/0xe70 [cifs]
[  113.326827]  ? cifs_get_fattr+0x546/0xe70 [cifs]
[  113.327612]  cifs_get_fattr+0x546/0xe70 [cifs]
[  113.328408]  ? __pfx_cifs_get_fattr+0x10/0x10 [cifs]
[  113.329221]  ? irq_work_queue+0xe/0x40
[  113.329538]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.329935]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.330332]  ? vprintk_emit+0xf8/0x310
[  113.330650]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.331046]  ? _printk+0xc0/0xf0
[  113.331323]  ? __pfx__printk+0x10/0x10
[  113.331646]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.332046]  ? __dynamic_pr_debug+0x1f5/0x260
[  113.332416]  ? __pfx___dynamic_pr_debug+0x10/0x10
[  113.332807]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.333208]  cifs_get_inode_info+0x157/0x210 [cifs]
[  113.334013]  ? __pfx_cifs_get_inode_info+0x10/0x10 [cifs]
[  113.334859]  ? __pfx____ratelimit+0x10/0x10
[  113.335213]  cifs_revalidate_dentry_attr+0x2c5/0x450 [cifs]
[  113.336074]  ? __pfx_cifs_revalidate_dentry_attr+0x10/0x10 [cifs]
[  113.336973]  cifs_getattr+0x28f/0x450 [cifs]
[  113.337727]  vfs_statx+0x1f6/0x240
[  113.338017]  ? __pfx_vfs_statx+0x10/0x10
[  113.338343]  ? lock_acquire+0x14a/0x3a0
[  113.338665]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.339064]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.339463]  do_statx+0xac/0x110
[  113.339737]  ? __pfx_do_statx+0x10/0x10
[  113.340057]  ? __pfx_lock_release+0x10/0x10
[  113.340417]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.340813]  ? getname_flags.part.0+0xd6/0x260
[  113.341186]  ? srso_alias_return_thunk+0x5/0xfbef5
[  113.341585]  __x64_sys_statx+0xa0/0xc0
[  113.341903]  do_syscall_64+0x47/0xf0
[  113.342211]  entry_SYSCALL_64_after_hwframe+0x6f/0x77
[  113.342628] RIP: 0033:0x7f844366c8de
[  113.342926] Code: a5 fd ff ff e8 b1 e4 01 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 90 90 41 89 ca b8 4c 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2a 89 c1 85 c0 74 0f 48 8b 05 0d 05 0e 00 64
[  113.344532] RSP: 002b:00007fff09d8cdb8 EFLAGS: 00000246 ORIG_RAX: 000000000000014c
[  113.345218] RAX: ffffffffffffffda RBX: 000055f7065b37b8 RCX: 00007f844366c8de
[  113.345854] RDX: 0000000000000800 RSI: 00007fff09d8eb1c RDI: 00000000ffffff9c
[  113.346482] RBP: 0000000000000002 R08: 00007fff09d8cdc0 R09: 0000000000000001
[  113.347243] R10: 0000000000000002 R11: 0000000000000246 R12: 000055f7065b37b8
[  113.347984] R13: 000000000000002f R14: 00007fff09d8eb1a R15: 000055f7065b37a0
[  113.348624]  </TASK>
[  113.348974] Kernel Offset: disabled
[  113.349272] ---[ end Kernel panic - not syncing: kasan.fault=panic set ... ]---

~/g/linux (cifs.work)> ./scripts/faddr2line --list fs/smb/client/cifs.o cifs_get_fattr+0x546
cifs_get_fattr+0x546/0xe70:

cifs_get_fattr at /home/pc/g/linux/fs/smb/client/inode.c:1089
 1084           /*
 1085            * 1. Fetch file metadata if not provided (data)
 1086            */
 1087 
 1088           if (!data) {
>1089<                  rc = server->ops->query_path_info(xid, tcon, cifs_sb,
 1090                                                     full_path, &tmp_data);
 1091                   data = &tmp_data;
 1092           }
 1093 
 1094           /*

Bisect lead to this patch, which is

	19a4b9d6c372 ("cifs: reconnect work should have reference on server struct")

in v6.7-rc1.
