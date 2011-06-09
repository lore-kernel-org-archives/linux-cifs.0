From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: oops in fscache code when running cifs with -o fsc
Date: Thu, 09 Jun 2011 23:00:57 +0530
Message-ID: <4DF10351.10309@suse.de>
References: <20110607142922.0816bfae@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110607142922.0816bfae-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/07/2011 11:59 PM, Jeff Layton wrote:
> While toying with the idea of backporting and enabling fsc support in
> RHEL6, I did some testing of the fsc code in 2.6.39. I mounted a
> filesystem with the following mount options "sec=krb5i,multiuser,fsc".
> I then logged in as an unprivileged user and got a krb5 ticket and ran
> the fsstress program from LTP on the filesystem:
> 
>     $ fsstress -d /mnt/cifs/fsstress -n1000 -p8 -l0
> 
> ...a few seconds later, the box crashed with the following oopses. This
> is easily reproducible, and seems to crash within a few seconds of
> kicking off the program:

While trying to reproduce this issue, I'm seeing a "Bad page state in
process fsstress" error. This error is due to page flag "PG_private_2"
still being set for the page when we try to evict the inode. FS-Cache
uses PG_private2 to indicate that the page is known to the cache.
Though cifs_invalidate_page tries to uncache the page (by calling
cifs_fscache_invalidate_page) it does not try to cancel writes that
have not started. I think that is the problem here.

Here is a stack trace captured when the problem was reproducible:

[  890.392445] fs/cifs/file.c: CIFS VFS: leaving cifsFileInfo_put (xid = 3045) rc = 0
[  890.403656] fs/cifs/connect.c: rfc1002 length 0x27
[  890.407941] fs/cifs/connect.c: rfc1002 length 0x27
[  890.411476] fs/cifs/transport.c: cifs_sync_mid_result: cmd=4 mid=2992 state=4
[  890.417742] fs/cifs/transport.c: SendRcvNoRsp flags 64 rc 0
[  890.428281] fs/cifs/file.c: CIFS VFS: leaving cifsFileInfo_put (xid = 3046) rc = 0
[  890.435533] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450f98/0x          (null))
[  890.453526] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450f60/0x          (null))
[  890.466450] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450f28/0x          (null))
[  890.481009] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450ef0/0x          (null))
[  890.498421] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450eb8/0x          (null))
[  890.510801] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450e80/0x          (null))
[  890.526044] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450e48/0x          (null))
[  890.549643] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450e10/0x          (null))
[  890.574903] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450dd8/0x          (null))
[  890.591636] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450da0/0x          (null))
[  890.615393] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450d68/0x          (null))
[  890.638427] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450d30/0x          (null))
[  890.661675] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450cf8/0x          (null))
[  890.689057] fs/cifs/fscache.c: CIFS: fscache invalidatepage (0xffffea0000450cc0/0x          (null))
[  890.729306] BUG: Bad page state in process fsstress  pfn:13ba8
[  890.743297] page:ffffea0000450cc0 count:0 mapcount:0 mapping:          (null) index:0x150
[  890.758439] page flags: 0x2000000000100c(referenced|uptodate|private_2)
[  890.782264] Pid: 4780, comm: fsstress Not tainted 3.0.0-rc1-12-default+ #6
[  890.793971] Call Trace:
[  890.804777]  [<ffffffff810e93f3>] ? dump_page+0x93/0xd0
[  890.817221]  [<ffffffff810e94f9>] bad_page+0xc9/0x120
[  890.835998]  [<ffffffff810e960d>] free_pages_prepare+0xbd/0x100
[  890.889885]  [<ffffffff810eac04>] free_hot_cold_page+0x44/0x470
[  890.924965]  [<ffffffff810eb075>] __pagevec_free+0x45/0xa0
[  890.928862]  [<ffffffff810ee6fd>] release_pages+0x20d/0x2c0
[  890.938960]  [<ffffffff810eef61>] __pagevec_release+0x21/0x30
[  890.952214]  [<ffffffff810ef88b>] truncate_inode_pages_range+0x1eb/0x450
[  890.963341]  [<ffffffff810efb00>] truncate_inode_pages+0x10/0x20
[  890.977037]  [<ffffffffa0363bea>] cifs_evict_inode+0x1a/0x40 [cifs]
[  891.000547]  [<ffffffff8114c2eb>] evict+0x7b/0x150
[  891.017301]  [<ffffffff8114c4ea>] iput+0xda/0x1a0
[  891.024691]  [<ffffffff81149188>] d_kill+0xf8/0x130
[  891.036880]  [<ffffffff81149bc2>] dput+0xc2/0x180
[  891.044544]  [<ffffffff8113593f>] fput+0x15f/0x210
[  891.047528]  [<ffffffff81131d41>] filp_close+0x61/0x90
[  891.059951]  [<ffffffff81057220>] put_files_struct+0x80/0xf0
[  891.070590]  [<ffffffff81057336>] exit_files+0x46/0x60
[  891.081010]  [<ffffffff81057822>] do_exit+0x1a2/0x8a0
[  891.088572]  [<ffffffff8105479e>] ? vprintk+0x24e/0x430
[  891.095035]  [<ffffffff810581c1>] do_group_exit+0x51/0xc0
[  891.112728]  [<ffffffff810679d5>] get_signal_to_deliver+0x225/0x460
[  891.117800]  [<ffffffff81002070>] do_signal+0x70/0x790
[  891.130115]  [<ffffffffa0381eda>] ? cifs_put_link+0x1a/0x20 [cifs]
[  891.140693]  [<ffffffff81001707>] ? __switch_to+0x157/0x2f0
[  891.164680]  [<ffffffff8142a57b>] ? schedule+0x3bb/0x900
[  891.176570]  [<ffffffff81002805>] do_notify_resume+0x55/0x70
[  891.198634]  [<ffffffff81434920>] int_signal+0x12/0x17
[  891.205534] Disabling lock debugging due to kernel taint
[  891.225908] BUG: Bad page state in process fsstress  pfn:13ba9
[  891.231592] page:ffffea0000450cf8 count:0 mapcount:0 mapping:          (null) index:0x14f
[  891.248629] page flags: 0x2000000000100c(referenced|uptodate|private_2)
[  891.260647] Pid: 4780, comm: fsstress Tainted: G    B       3.0.0-rc1-12-default+ #6
[  891.276944] Call Trace:
[  891.280782]  [<ffffffff810e93f3>] ? dump_page+0x93/0xd0
[  891.296810]  [<ffffffff810e94f9>] bad_page+0xc9/0x120
[  891.305605]  [<ffffffff810e960d>] free_pages_prepare+0xbd/0x100
[  891.319260]  [<ffffffff810eac04>] free_hot_cold_page+0x44/0x470
[  891.330604]  [<ffffffff810eb075>] __pagevec_free+0x45/0xa0
[  891.350687]  [<ffffffff810ee6fd>] release_pages+0x20d/0x2c0
[  891.365931]  [<ffffffff810eef61>] __pagevec_release+0x21/0x30
[  891.392176]  [<ffffffff810ef88b>] truncate_inode_pages_range+0x1eb/0x450
[  891.409883]  [<ffffffff810efb00>] truncate_inode_pages+0x10/0x20
[  891.421483]  [<ffffffffa0363bea>] cifs_evict_inode+0x1a/0x40 [cifs]
[  891.426334]  [<ffffffff8114c2eb>] evict+0x7b/0x150
[  891.435785]  [<ffffffff8114c4ea>] iput+0xda/0x1a0
[  891.446477]  [<ffffffff81149188>] d_kill+0xf8/0x130
[  891.450610]  [<ffffffff81149bc2>] dput+0xc2/0x180
[  891.471871]  [<ffffffff8113593f>] fput+0x15f/0x210
[  891.482804]  [<ffffffff81131d41>] filp_close+0x61/0x90
[  891.492800]  [<ffffffff81057220>] put_files_struct+0x80/0xf0
[  891.500350]  [<ffffffff81057336>] exit_files+0x46/0x60
[  891.507801]  [<ffffffff81057822>] do_exit+0x1a2/0x8a0
[  891.514657]  [<ffffffff8105479e>] ? vprintk+0x24e/0x430
[  891.528522]  [<ffffffff810581c1>] do_group_exit+0x51/0xc0
[  891.536977]  [<ffffffff810679d5>] get_signal_to_deliver+0x225/0x460
[  891.554680]  [<ffffffff81002070>] do_signal+0x70/0x790
[  891.559300]  [<ffffffffa0381eda>] ? cifs_put_link+0x1a/0x20 [cifs]
[  891.563988]  [<ffffffff81001707>] ? __switch_to+0x157/0x2f0
[  891.578695]  [<ffffffff8142a57b>] ? schedule+0x3bb/0x900
[  891.603360]  [<ffffffff81002805>] do_notify_resume+0x55/0x70
[  891.611511]  [<ffffffff81434920>] int_signal+0x12/0x17


> 
> [  417.277296] CacheFiles: Error: Unexpected object collision
> [  417.278586] object: OBJ92
> [  417.279594] objstate=OBJECT_LOOKING_UP fl=0 wbusy=2 ev=0[7b]
> [  417.286253] ops=0 inp=0 exc=0
> [  417.286986] parent=ffff880018384180
> [  417.287896] cookie=ffff88002bb8d8c0 [pr=ffff88002bb8d0a0 nd=ffff88002af01020 fl=7]
> [  417.290298] key=[8] '2501020000000000'
> [  417.291548] xobject: OBJ91
> [  417.292636] xobjstate=OBJECT_RECYCLING fl=0 wbusy=2 ev=20[1]
> [  417.297511] xops=0 inp=0 exc=0
> [  417.298875] xparent=ffff880018384180
> [  417.300769] xcookie=NULL
> [  417.302635] ------------[ cut here ]------------
> [  417.304903] kernel BUG at fs/cachefiles/namei.c:201!
> [  417.307613] invalid opcode: 0000 [#1] SMP 
> [  417.309860] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> [  417.313868] CPU 1 
> [  417.314855] Modules linked in: fuse nls_utf8 cifs sunrpc cachefiles fscache ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables joydev microcode i2c_piix4 virtio_balloon i2c_core virtio_net ipv6 virtio_blk [last unloaded: mperf]
> [  417.328983] 
> [  417.329923] Pid: 5, comm: kworker/u:0 Not tainted 2.6.38.7-30.fc15.x86_64 #1 Bochs Bochs
> [  417.333928] RIP: 0010:[<ffffffffa00bebe4>]  [<ffffffffa00bebe4>] cachefiles_walk_to_object+0x436/0x745 [cachefiles]
> [  417.338967] RSP: 0018:ffff88002ce6dd00  EFLAGS: 00010282
> [  417.341761] RAX: ffff88002ef165f0 RBX: ffff88001811f500 RCX: 0000000000000000
> [  417.344943] RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000282
> [  417.348639] RBP: ffff88002ce6dda0 R08: 0000000000000100 R09: ffffffff81b3a300
> [  417.351813] R10: 0000ffff00066c0a R11: 0000000000000003 R12: ffff88002ae54840
> [  417.355522] R13: ffff88002ae54840 R14: ffff880029c29c00 R15: ffff88001811f4b0
> [  417.358879] FS:  00007f394dd32720(0000) GS:ffff88002ef00000(0000) knlGS:0000000000000000
> [  417.362780] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  417.365651] CR2: 00007fffcb62ddf8 CR3: 000000001825f000 CR4: 00000000000006e0
> [  417.368830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  417.372688] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  417.375876] Process kworker/u:0 (pid: 5, threadinfo ffff88002ce6c000, task ffff88002ce55cc0)
> [  417.379863] Stack:
> [  417.380891]  0000000000000246 ffff88002ce55cc0 ffff88002ce6dd58 ffff88001815dc00
> [  417.384864]  ffff8800185246c0 ffff88001811f618 ffff880029c29d18 ffff88001811f380
> [  417.388935]  ffff88002ce6dd50 ffffffff814757e4 ffff88002ce6dda0 ffffffff8106ac56
> [  417.392907] Call Trace:
> [  417.394580]  [<ffffffff814757e4>] ? _raw_spin_unlock_irqrestore+0x17/0x19
> [  417.397739]  [<ffffffff8106ac56>] ? __queue_work+0x256/0x265
> [  417.400607]  [<ffffffffa00bd91f>] cachefiles_lookup_object+0x78/0xd4 [cachefiles]
> [  417.403898]  [<ffffffffa00a9977>] ? fscache_object_work_func+0x0/0x669 [fscache]
> [  417.407659]  [<ffffffffa00a95da>] fscache_lookup_object+0x131/0x16d [fscache]
> [  417.410832]  [<ffffffffa00a9b33>] fscache_object_work_func+0x1bc/0x669 [fscache]
> [  417.414598]  [<ffffffffa00a9977>] ? fscache_object_work_func+0x0/0x669 [fscache]
> [  417.417956]  [<ffffffff8106afb6>] process_one_work+0x186/0x298
> [  417.420876]  [<ffffffff8106b343>] worker_thread+0xda/0x15d
> [  417.423693]  [<ffffffff8106b269>] ? worker_thread+0x0/0x15d
> [  417.426546]  [<ffffffff8106b269>] ? worker_thread+0x0/0x15d
> [  417.428877]  [<ffffffff8106ebaf>] kthread+0x84/0x8c
> [  417.431712]  [<ffffffff8100a9e4>] kernel_thread_helper+0x4/0x10
> [  417.434615]  [<ffffffff8106eb2b>] ? kthread+0x0/0x8c
> [  417.436809]  [<ffffffff8100a9e0>] ? kernel_thread_helper+0x0/0x10
> [  417.439746] Code: 05 77 2a 48 c7 c7 ce 1c 0c a0 31 c0 e8 c6 db 3a e1 48 c7 c7 77 1f 0c a0 31 c0 e8 b8 db 3a e1 48 8b 75 98 48 89 df e8 ae 23 00 00 <0f> 0b 48 8b 55 98 f0 ff 82 20 01 00 00 48 8b 7d 90 e8 86 f5 ff 
> [  417.453802] RIP  [<ffffffffa00bebe4>] cachefiles_walk_to_object+0x436/0x745 [cachefiles]
> [  417.457781]  RSP <ffff88002ce6dd00>
> [  417.459638] ---[ end trace 1d481c9af1804caa ]---
> [  417.462614] BUG: unable to handle kernel paging request at fffffffffffffff8
> [  417.462726] IP: [<ffffffff8106ee03>] kthread_data+0x11/0x16
> [  417.462726] PGD 1a05067 PUD 1a06067 PMD 0 
> [  417.462726] Oops: 0000 [#2] SMP 
> [  417.462726] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> [  417.462726] CPU 1 
> [  417.462726] Modules linked in: fuse nls_utf8 cifs sunrpc cachefiles fscache ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables joydev microcode i2c_piix4 virtio_balloon i2c_core virtio_net ipv6 virtio_blk [last unloaded: mperf]
> [  417.462726] 
> [  417.462726] Pid: 5, comm: kworker/u:0 Tainted: G      D     2.6.38.7-30.fc15.x86_64 #1 Bochs Bochs
> [  417.462726] RIP: 0010:[<ffffffff8106ee03>]  [<ffffffff8106ee03>] kthread_data+0x11/0x16
> [  417.462726] RSP: 0018:ffff88002ce6d9a0  EFLAGS: 00010002
> [  417.462726] RAX: 0000000000000000 RBX: ffff88002ef13840 RCX: ffff88002ce55cc0
> [  417.462726] RDX: ffff88002ce55cc0 RSI: 0000000000000001 RDI: ffff88002ce55cc0
> [  417.462726] RBP: ffff88002ce6d9c8 R08: dead000000200200 R09: dead000000200200
> [  417.462726] R10: dead000000200200 R11: ffffea00009d2500 R12: 0000000000000001
> [  417.462726] R13: 0000000000000000 R14: ffff88002ce56078 R15: 0000000000000001
> [  417.462726] FS:  00007f585ab51700(0000) GS:ffff88002ef00000(0000) knlGS:0000000000000000
> [  417.462726] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  417.462726] CR2: fffffffffffffff8 CR3: 000000002b29b000 CR4: 00000000000006e0
> [  417.462726] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  417.462726] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  417.462726] Process kworker/u:0 (pid: 5, threadinfo ffff88002ce6c000, task ffff88002ce55cc0)
> [  417.462726] Stack:
> [  417.462726]  ffffffff8106bb62 dead000000200200 ffff88002ef13840 ffff88002ce56290
> [  417.462726]  0000000000000000 ffff88002ce6da58 ffffffff81473c8c 0000000000000000
> [  417.462726]  ffff88002ce55cc0 ffff88002ce6dfd8 ffff88002ce6dfd8 0000000000013840
> [  417.462726] Call Trace:
> [  417.462726]  [<ffffffff8106bb62>] ? wq_worker_sleeping+0x18/0x82
> [  417.462726]  [<ffffffff81473c8c>] schedule+0x181/0x66a
> [  417.462726]  [<ffffffff81072ffa>] ? switch_task_namespaces+0x48/0x61
> [  417.462726]  [<ffffffff81058b4d>] do_exit+0x730/0x732
> [  417.462726]  [<ffffffff81476ace>] oops_end+0xbc/0xc5
> [  417.462726]  [<ffffffff8100d454>] die+0x5a/0x66
> [  417.462726]  [<ffffffff814763c8>] do_trap+0x121/0x130
> [  417.462726]  [<ffffffff8100aeaa>] do_invalid_op+0x94/0x9d
> [  417.462726]  [<ffffffffa00bebe4>] ? cachefiles_walk_to_object+0x436/0x745 [cachefiles]
> [  417.462726]  [<ffffffff8146c7e1>] ? printk+0x51/0x53
> [  417.462726]  [<ffffffff8100a85b>] invalid_op+0x1b/0x20
> [  417.462726]  [<ffffffffa00bebe4>] ? cachefiles_walk_to_object+0x436/0x745 [cachefiles]
> [  417.462726]  [<ffffffff814757e4>] ? _raw_spin_unlock_irqrestore+0x17/0x19
> [  417.462726]  [<ffffffff8106ac56>] ? __queue_work+0x256/0x265
> [  417.462726]  [<ffffffffa00bd91f>] cachefiles_lookup_object+0x78/0xd4 [cachefiles]
> [  417.462726]  [<ffffffffa00a9977>] ? fscache_object_work_func+0x0/0x669 [fscache]
> [  417.462726]  [<ffffffffa00a95da>] fscache_lookup_object+0x131/0x16d [fscache]
> [  417.462726]  [<ffffffffa00a9b33>] fscache_object_work_func+0x1bc/0x669 [fscache]
> [  417.462726]  [<ffffffffa00a9977>] ? fscache_object_work_func+0x0/0x669 [fscache]
> [  417.462726]  [<ffffffff8106afb6>] process_one_work+0x186/0x298
> [  417.462726]  [<ffffffff8106b343>] worker_thread+0xda/0x15d
> [  417.462726]  [<ffffffff8106b269>] ? worker_thread+0x0/0x15d
> [  417.462726]  [<ffffffff8106b269>] ? worker_thread+0x0/0x15d
> [  417.462726]  [<ffffffff8106ebaf>] kthread+0x84/0x8c
> [  417.462726]  [<ffffffff8100a9e4>] kernel_thread_helper+0x4/0x10
> [  417.462726]  [<ffffffff8106eb2b>] ? kthread+0x0/0x8c
> [  417.462726]  [<ffffffff8100a9e0>] ? kernel_thread_helper+0x0/0x10
> [  417.462726] Code: 29 e6 f3 a5 c7 83 ac 01 00 00 01 00 00 00 81 4b 14 00 00 00 04 5b 41 5c 5d c3 55 48 89 e5 66 66 66 66 90 48 8b 87 60 03 00 00 5d 
> [  417.462726]  8b 40 f8 c3 55 48 89 e5 41 56 41 55 41 54 53 48 83 ec 50 66 
> [  417.462726] RIP  [<ffffffff8106ee03>] kthread_data+0x11/0x16
> [  417.462726]  RSP <ffff88002ce6d9a0>
> [  417.462726] CR2: fffffffffffffff8
> [  417.462726] ---[ end trace 1d481c9af1804cab ]---
> [  417.462726] Fixing recursive fault but reboot is needed!
> 
> 


-- 
Suresh Jayaraman
