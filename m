From: CAI Qian <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: move check for NULL socket into smb_send_rqst
Date: Tue, 25 Dec 2012 22:48:15 -0500 (EST)
Message-ID: <676270245.5975879.1356493695367.JavaMail.root@redhat.com>
References: <1338651944.5966063.1356490111596.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338651944.5966063.1356490111596.JavaMail.root-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



----- Original Message -----
> From: "CAI Qian" <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "Jeff Layton" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Sent: Wednesday, December 26, 2012 10:48:31 AM
> Subject: Re: [PATCH] cifs: move check for NULL socket into smb_send_rqst
> 
> Thanks for the quick patch, Jeff. I have just reproduced this again,
> so I'll try to test this patch to see how it goes. :)
OK, it is now triggering hung task below after applied this patch. Jeff,
was that the locking issue you mentioned before? I'll see if I can craft out
a straight reproducer.

INFO: task ls:12881 blocked for more than 120 seconds.
[ 1923.104385] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1923.113311] ls              D ffff88085fcd3c40     0 12881      1 0x00000084
[ 1923.121544]  ffff8820482d1c18 0000000000000086 ffff88205b9eb240 ffff8820482d1fd8
[ 1923.130164]  ffff8820482d1fd8 ffff8820482d1fd8 ffff88085c596480 ffff88205b9eb240
[ 1923.138877]  0000000000000022 ffff882032da83c0 ffff882032da83c4 ffff88205b9eb240
[ 1923.147625] Call Trace:
[ 1923.150584]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1923.156321]  [<ffffffff815ca66e>] schedule_preempt_disabled+0xe/0x10
[ 1923.163625]  [<ffffffff815c9273>] __mutex_lock_slowpath+0xc3/0x140
[ 1923.170717]  [<ffffffff815c8daa>] mutex_lock+0x2a/0x50
[ 1923.176646]  [<ffffffff815c2550>] lookup_slow+0x39/0xab
[ 1923.182701]  [<ffffffff8118f906>] link_path_walk+0x816/0x870
[ 1923.189207]  [<ffffffff8117672a>] ? kmem_cache_alloc_trace+0x11a/0x130
[ 1923.196712]  [<ffffffff81192c4f>] path_openat+0x9f/0x4d0
[ 1923.202833]  [<ffffffff811758d0>] ? kmem_cache_free+0x20/0x160
[ 1923.209561]  [<ffffffff8112b477>] ? mempool_free_slab+0x17/0x20
[ 1923.216355]  [<ffffffff8112b724>] ? mempool_free+0x54/0xb0
[ 1923.222665]  [<ffffffff81193351>] do_filp_open+0x41/0xa0
[ 1923.228815]  [<ffffffff8119f932>] ? __alloc_fd+0x42/0x110
[ 1923.235031]  [<ffffffff81183514>] do_sys_open+0xf4/0x1e0
[ 1923.241153]  [<ffffffff810d851c>] ? __audit_syscall_entry+0xcc/0x300
[ 1923.248440]  [<ffffffff81183644>] sys_openat+0x14/0x20
[ 1923.254366]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
[ 1923.261265] INFO: task ls:12894 blocked for more than 120 seconds.
[ 1923.268345] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1923.277269] ls              D ffff88085fcb3c40     0 12894      1 0x00000084
[ 1923.285517]  ffff88105715fc18 0000000000000082 ffff881040d83240 ffff88105715ffd8
[ 1923.294114]  ffff88105715ffd8 ffff88105715ffd8 ffff88205a5b3240 ffff881040d83240
[ 1923.302847]  ffff88205780c200 ffff882032da83c0 ffff882032da83c4 ffff881040d83240
[ 1923.311578] Call Trace:
[ 1923.314501]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1923.320240]  [<ffffffff815ca66e>] schedule_preempt_disabled+0xe/0x10
[ 1923.327521]  [<ffffffff815c9273>] __mutex_lock_slowpath+0xc3/0x140
[ 1923.334596]  [<ffffffff815c8daa>] mutex_lock+0x2a/0x50
[ 1923.340520]  [<ffffffff815c2550>] lookup_slow+0x39/0xab
[ 1923.346537]  [<ffffffff8118f906>] link_path_walk+0x816/0x870
[ 1923.353063]  [<ffffffff8117672a>] ? kmem_cache_alloc_trace+0x11a/0x130
[ 1923.360542]  [<ffffffff81192c4f>] path_openat+0x9f/0x4d0
[ 1923.366675]  [<ffffffffa01e085a>] ? initiate_cifs_search+0x17a/0x250 [cifs]
[ 1923.374631]  [<ffffffff81193351>] do_filp_open+0x41/0xa0
[ 1923.380745]  [<ffffffff8119f932>] ? __alloc_fd+0x42/0x110
[ 1923.386962]  [<ffffffff81183514>] do_sys_open+0xf4/0x1e0
[ 1923.393076]  [<ffffffff810d851c>] ? __audit_syscall_entry+0xcc/0x300
[ 1923.400360]  [<ffffffff81183644>] sys_openat+0x14/0x20
[ 1923.406308]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
[ 1923.413199] INFO: task dd:12957 blocked for more than 120 seconds.
[ 1923.420279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1923.429235] dd              D ffff88105fc33c40     0 12957      1 0x00000086
[ 1923.437466]  ffff882057861a08 0000000000000046 ffff88205c314b60 ffff882057861fd8
[ 1923.446255]  ffff882057861fd8 ffff882057861fd8 ffff88085c559920 ffff88205c314b60
[ 1923.454856]  ffff882057861a08 ffff88205c314b60 ffff88105fc344a8 0000000000000002
[ 1923.463558] Call Trace:
[ 1923.466497]  [<ffffffff81128660>] ? __lock_page+0x70/0x70
[ 1923.472721]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1923.478436]  [<ffffffff815ca4af>] io_schedule+0x8f/0xd0
[ 1923.484476]  [<ffffffff8112866e>] sleep_on_page+0xe/0x20
[ 1923.490597]  [<ffffffff815c8c60>] __wait_on_bit+0x60/0x90
[ 1923.496814]  [<ffffffff81129242>] ? find_get_pages_tag+0x102/0x1b0
[ 1923.503901]  [<ffffffff811287a0>] wait_on_page_bit+0x80/0x90
[ 1923.510410]  [<ffffffff8107f610>] ? autoremove_wake_function+0x50/0x50
[ 1923.517878]  [<ffffffff81128d41>] filemap_fdatawait_range+0x101/0x190
[ 1923.525285]  [<ffffffff81128df7>] filemap_fdatawait+0x27/0x30
[ 1923.531886]  [<ffffffff8112ac84>] filemap_write_and_wait+0x44/0x60
[ 1923.538997]  [<ffffffffa01d2b79>] cifs_flush+0x59/0x80 [cifs]
[ 1923.545600]  [<ffffffff81181faf>] filp_close+0x3f/0xa0
[ 1923.551524]  [<ffffffff8119f7bc>] put_files_struct+0x9c/0xf0
[ 1923.558035]  [<ffffffff8119f8bb>] exit_files+0x4b/0x60
[ 1923.563964]  [<ffffffff81060fc1>] do_exit+0x191/0x8d0
[ 1923.569818]  [<ffffffff81061b4f>] do_group_exit+0x3f/0xa0
[ 1923.576035]  [<ffffffff810706ca>] get_signal_to_deliver+0x1ba/0x5d0
[ 1923.583220]  [<ffffffff81183877>] ? do_sync_write+0xa7/0xe0
[ 1923.589646]  [<ffffffff8101437f>] do_signal+0x3f/0x610
[ 1923.595571]  [<ffffffff810149d5>] do_notify_resume+0x65/0x80
[ 1923.602083]  [<ffffffff810d8b3c>] ? __audit_syscall_exit+0x3ec/0x450
[ 1923.609364]  [<ffffffff815d3e52>] int_signal+0x12/0x17
[ 1923.615289] INFO: task dd:13001 blocked for more than 120 seconds.
[ 1923.622369] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1923.631312] dd              D ffff88085fc73c40     0 13001      1 0x00000084
[ 1923.639570]  ffff88205a1cbcf8 0000000000000082 ffff882048354b60 ffff88205a1cbfd8
[ 1923.648184]  ffff88205a1cbfd8 ffff88205a1cbfd8 ffff88085c56b240 ffff882048354b60
[ 1923.656883]  ffff88205a1cbcf8 ffff882048354b60 ffff88085fc744a8 0000000000000002
[ 1923.665643] Call Trace:
[ 1923.668571]  [<ffffffff81128660>] ? __lock_page+0x70/0x70
[ 1923.674782]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1923.680512]  [<ffffffff815ca4af>] io_schedule+0x8f/0xd0
[ 1923.686528]  [<ffffffff8112866e>] sleep_on_page+0xe/0x20
[ 1923.692642]  [<ffffffff815c8c60>] __wait_on_bit+0x60/0x90
[ 1923.698858]  [<ffffffff81129242>] ? find_get_pages_tag+0x102/0x1b0
[ 1923.705949]  [<ffffffff811287a0>] wait_on_page_bit+0x80/0x90
[ 1923.712450]  [<ffffffff8107f610>] ? autoremove_wake_function+0x50/0x50
[ 1923.719955]  [<ffffffff81128d41>] filemap_fdatawait_range+0x101/0x190
[ 1923.727368]  [<ffffffff81128df7>] filemap_fdatawait+0x27/0x30
[ 1923.733972]  [<ffffffff8112ac84>] filemap_write_and_wait+0x44/0x60
[ 1923.741073]  [<ffffffffa01d2b79>] cifs_flush+0x59/0x80 [cifs]
[ 1923.747677]  [<ffffffff81181faf>] filp_close+0x3f/0xa0
[ 1923.753583]  [<ffffffff8119fb47>] __close_fd+0x77/0x90
[ 1923.759500]  [<ffffffff81181f40>] sys_close+0x20/0x50
[ 1923.765326]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
[ 1923.772204] INFO: task mv:13050 blocked for more than 120 seconds.
[ 1923.779293] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1923.788214] mv              D ffff88185fcf3c40     0 13050      1 0x00000084
[ 1923.796457]  ffff88204e955a18 0000000000000082 ffff88205ac61920 ffff88204e955fd8
[ 1923.805094]  ffff88204e955fd8 ffff88204e955fd8 ffff88085c5ae480 ffff88205ac61920
[ 1923.813822]  ffff88204e955a18 ffff88205ac61920 ffff88185fcf44a8 0000000000000002
[ 1923.822548] Call Trace:
[ 1923.825489]  [<ffffffff81128660>] ? __lock_page+0x70/0x70
[ 1923.831712]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1923.837431]  [<ffffffff815ca4af>] io_schedule+0x8f/0xd0
[ 1923.843447]  [<ffffffff8112866e>] sleep_on_page+0xe/0x20
[ 1923.849562]  [<ffffffff815c8c60>] __wait_on_bit+0x60/0x90
[ 1923.855777]  [<ffffffff8112b375>] ? find_get_pages+0xf5/0x190
[ 1923.862382]  [<ffffffff811287a0>] wait_on_page_bit+0x80/0x90
[ 1923.868886]  [<ffffffff8107f610>] ? autoremove_wake_function+0x50/0x50
[ 1923.876373]  [<ffffffff811369b0>] invalidate_inode_pages2_range+0x170/0x370
[ 1923.884347]  [<ffffffff81136bc7>] invalidate_inode_pages2+0x17/0x20
[ 1923.891539]  [<ffffffffa01d7625>] cifs_invalidate_mapping+0x45/0x90 [cifs]
[ 1923.899418]  [<ffffffffa01d7928>] cifs_revalidate_dentry+0x38/0x40 [cifs]
[ 1923.907196]  [<ffffffffa01cb537>] cifs_d_revalidate+0x27/0xb0 [cifs]
[ 1923.914509]  [<ffffffff8118ebf0>] lookup_fast+0x2e0/0x310
[ 1923.920723]  [<ffffffff8118ff60>] path_lookupat+0x120/0x760
[ 1923.927137]  [<ffffffff811509b5>] ? handle_pte_fault+0x95/0x9e0
[ 1923.933953]  [<ffffffff81176131>] ? kmem_cache_alloc+0x31/0x130
[ 1923.940783]  [<ffffffff811905d4>] filename_lookup+0x34/0xc0
[ 1923.947188]  [<ffffffff8119326e>] user_path_at_empty+0x8e/0x110
[ 1923.953993]  [<ffffffff815cf2c4>] ? __do_page_fault+0x244/0x4e0
[ 1923.960797]  [<ffffffff81193301>] user_path_at+0x11/0x20
[ 1923.966962]  [<ffffffff81188af5>] vfs_fstatat+0x35/0x70
[ 1923.972993]  [<ffffffff81279fa7>] ? file_has_perm+0x97/0xb0
[ 1923.979412]  [<ffffffff81188b6b>] vfs_stat+0x1b/0x20
[ 1923.985137]  [<ffffffff81188d9a>] sys_newstat+0x1a/0x40
[ 1923.991178]  [<ffffffff810d851c>] ? __audit_syscall_entry+0xcc/0x300
[ 1923.998457]  [<ffffffff815cf56e>] ? do_page_fault+0xe/0x10
[ 1924.004775]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
[ 1924.011669] INFO: task ln:13085 blocked for more than 120 seconds.
[ 1924.018754] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1924.027709] ln              D ffff88085fd33c40     0 13085      1 0x00000084
[ 1924.035957]  ffff88185385dbe8 0000000000000082 ffff88185b241920 ffff88185385dfd8
[ 1924.044565]  ffff88185385dfd8 ffff88185385dfd8 ffff88085c5d1920 ffff88185b241920
[ 1924.053331]  ffff882032da8318 ffff882032da83c0 ffff882032da83c4 ffff88185b241920
[ 1924.062052] Call Trace:
[ 1924.064895]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1924.070629]  [<ffffffff815ca66e>] schedule_preempt_disabled+0xe/0x10
[ 1924.077930]  [<ffffffff815c9273>] __mutex_lock_slowpath+0xc3/0x140
[ 1924.085043]  [<ffffffff815c8daa>] mutex_lock+0x2a/0x50
[ 1924.090999]  [<ffffffff815c2550>] lookup_slow+0x39/0xab
[ 1924.097041]  [<ffffffff8119053f>] path_lookupat+0x6ff/0x760
[ 1924.103447]  [<ffffffff811509b5>] ? handle_pte_fault+0x95/0x9e0
[ 1924.110267]  [<ffffffff81176131>] ? kmem_cache_alloc+0x31/0x130
[ 1924.117093]  [<ffffffff811905d4>] filename_lookup+0x34/0xc0
[ 1924.123508]  [<ffffffff8119326e>] user_path_at_empty+0x8e/0x110
[ 1924.130318]  [<ffffffff815cf2c4>] ? __do_page_fault+0x244/0x4e0
[ 1924.137137]  [<ffffffff81193301>] user_path_at+0x11/0x20
[ 1924.143285]  [<ffffffff81188af5>] vfs_fstatat+0x35/0x70
[ 1924.149315]  [<ffffffff81144a28>] ? vm_mmap_pgoff+0x88/0xb0
[ 1924.155715]  [<ffffffff81188b6b>] vfs_stat+0x1b/0x20
[ 1924.161468]  [<ffffffff81188d9a>] sys_newstat+0x1a/0x40
[ 1924.167491]  [<ffffffff810d851c>] ? __audit_syscall_entry+0xcc/0x300
[ 1924.174774]  [<ffffffff815cf56e>] ? do_page_fault+0xe/0x10
[ 1924.181098]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
[ 1924.187990] INFO: task mkdir:13087 blocked for more than 120 seconds.
[ 1924.195365] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1924.204288] mkdir           D ffff88105fcf3c40     0 13087      1 0x00000084
[ 1924.212561]  ffff88084b30fb78 0000000000000082 ffff88085b213240 ffff88084b30ffd8
[ 1924.221134]  ffff88084b30ffd8 ffff88084b30ffd8 ffff88085c5b8000 ffff88085b213240
[ 1924.229889]  ffff88084b30fb78 ffff88085b213240 ffff88105fcf44a8 0000000000000002
[ 1924.238829] Call Trace:
[ 1924.241753]  [<ffffffff81128660>] ? __lock_page+0x70/0x70
[ 1924.247998]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1924.253750]  [<ffffffff815ca4af>] io_schedule+0x8f/0xd0
[ 1924.259795]  [<ffffffff8112866e>] sleep_on_page+0xe/0x20
[ 1924.265935]  [<ffffffff815c8b0b>] __wait_on_bit_lock+0x5b/0xc0
[ 1924.272632]  [<ffffffff8112b375>] ? find_get_pages+0xf5/0x190
[ 1924.279256]  [<ffffffff81128657>] __lock_page+0x67/0x70
[ 1924.285274]  [<ffffffff8107f610>] ? autoremove_wake_function+0x50/0x50
[ 1924.292743]  [<ffffffff8113698b>] invalidate_inode_pages2_range+0x14b/0x370
[ 1924.300706]  [<ffffffff81136bc7>] invalidate_inode_pages2+0x17/0x20
[ 1924.307922]  [<ffffffffa01d7625>] cifs_invalidate_mapping+0x45/0x90 [cifs]
[ 1924.315820]  [<ffffffffa01d7928>] cifs_revalidate_dentry+0x38/0x40 [cifs]
[ 1924.323599]  [<ffffffffa01cb537>] cifs_d_revalidate+0x27/0xb0 [cifs]
[ 1924.330860]  [<ffffffff8118d780>] lookup_dcache+0x80/0xd0
[ 1924.337108]  [<ffffffff815c927b>] ? __mutex_lock_slowpath+0xcb/0x140
[ 1924.344409]  [<ffffffff8118d7f3>] __lookup_hash+0x23/0x50
[ 1924.350649]  [<ffffffff8118d839>] lookup_hash+0x19/0x20
[ 1924.356674]  [<ffffffff8119079b>] kern_path_create+0x8b/0x170
[ 1924.363279]  [<ffffffff8118ee76>] ? getname_flags.part.32+0x86/0x150
[ 1924.370576]  [<ffffffff811908ca>] user_path_create+0x4a/0x70
[ 1924.377106]  [<ffffffff81193691>] sys_mkdirat+0x21/0x80
[ 1924.383128]  [<ffffffff81193709>] sys_mkdir+0x19/0x20
[ 1924.388982]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
[ 1924.395905] INFO: task mkdir:13090 blocked for more than 120 seconds.
[ 1924.403263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1924.412217] mkdir           D ffff88185fd73c40     0 13090      1 0x00000084
[ 1924.420443]  ffff8808565b9da8 0000000000000082 ffff88085b6e3240 ffff8808565b9fd8
[ 1924.429024]  ffff8808565b9fd8 ffff8808565b9fd8 ffff88105b928000 ffff88085b6e3240
[ 1924.437772]  ffff8808565b9e18 ffff882032da83c0 ffff882032da83c4 ffff88085b6e3240
[ 1924.446695] Call Trace:
[ 1924.449647]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1924.455375]  [<ffffffff815ca66e>] schedule_preempt_disabled+0xe/0x10
[ 1924.462670]  [<ffffffff815c9273>] __mutex_lock_slowpath+0xc3/0x140
[ 1924.469756]  [<ffffffff815c8daa>] mutex_lock+0x2a/0x50
[ 1924.475709]  [<ffffffff8119078f>] kern_path_create+0x7f/0x170
[ 1924.482312]  [<ffffffff8118ee76>] ? getname_flags.part.32+0x86/0x150
[ 1924.489595]  [<ffffffff811908ca>] user_path_create+0x4a/0x70
[ 1924.496098]  [<ffffffff81193691>] sys_mkdirat+0x21/0x80
[ 1924.502123]  [<ffffffff81193709>] sys_mkdir+0x19/0x20
[ 1924.507973]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
[ 1924.514887] INFO: task ln:13100 blocked for more than 120 seconds.
[ 1924.521992] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1924.530942] ln              D ffff88185fd53c40     0 13100      1 0x00000084
[ 1924.539189]  ffff88184e6f7be8 0000000000000086 ffff88184a136480 ffff88184e6f7fd8
[ 1924.547796]  ffff88184e6f7fd8 ffff88184e6f7fd8 ffff88085c5e9920 ffff88184a136480
[ 1924.556757]  ffff882032da8318 ffff882032da83c0 ffff882032da83c4 ffff88184a136480
[ 1924.565375] Call Trace:
[ 1924.568300]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1924.574034]  [<ffffffff815ca66e>] schedule_preempt_disabled+0xe/0x10
[ 1924.581298]  [<ffffffff815c9273>] __mutex_lock_slowpath+0xc3/0x140
[ 1924.588379]  [<ffffffff815c8daa>] mutex_lock+0x2a/0x50
[ 1924.594332]  [<ffffffff815c2550>] lookup_slow+0x39/0xab
[ 1924.600363]  [<ffffffff8119053f>] path_lookupat+0x6ff/0x760
[ 1924.606751]  [<ffffffff811509b5>] ? handle_pte_fault+0x95/0x9e0
[ 1924.613551]  [<ffffffff81176131>] ? kmem_cache_alloc+0x31/0x130
[ 1924.620378]  [<ffffffff811905d4>] filename_lookup+0x34/0xc0
[ 1924.626785]  [<ffffffff8119326e>] user_path_at_empty+0x8e/0x110
[ 1924.633587]  [<ffffffff815cf2c4>] ? __do_page_fault+0x244/0x4e0
[ 1924.640380]  [<ffffffff81193301>] user_path_at+0x11/0x20
[ 1924.646497]  [<ffffffff81188af5>] vfs_fstatat+0x35/0x70
[ 1924.652513]  [<ffffffff81144a28>] ? vm_mmap_pgoff+0x88/0xb0
[ 1924.658939]  [<ffffffff81188b6b>] vfs_stat+0x1b/0x20
[ 1924.664698]  [<ffffffff81188d9a>] sys_newstat+0x1a/0x40
[ 1924.670743]  [<ffffffff810d851c>] ? __audit_syscall_entry+0xcc/0x300
[ 1924.678047]  [<ffffffff815cf56e>] ? do_page_fault+0xe/0x10
[ 1924.684358]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
[ 1924.691277] INFO: task ln:13101 blocked for more than 120 seconds.
[ 1924.698385] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1924.707314] ln              D ffff88105fc73c40     0 13101      1 0x00000084
[ 1924.715544]  ffff881856663a18 0000000000000082 ffff88185ae8b240 ffff881856663fd8
[ 1924.724185]  ffff881856663fd8 ffff881856663fd8 ffff88085c56e480 ffff88185ae8b240
[ 1924.732906]  ffff881856663a18 ffff88185ae8b240 ffff88105fc744a8 0000000000000002
[ 1924.741629] Call Trace:
[ 1924.744544]  [<ffffffff81128660>] ? __lock_page+0x70/0x70
[ 1924.750762]  [<ffffffff815ca3d9>] schedule+0x29/0x70
[ 1924.756487]  [<ffffffff815ca4af>] io_schedule+0x8f/0xd0
[ 1924.762536]  [<ffffffff8112866e>] sleep_on_page+0xe/0x20
[ 1924.768678]  [<ffffffff815c8c60>] __wait_on_bit+0x60/0x90
[ 1924.774919]  [<ffffffff8112b375>] ? find_get_pages+0xf5/0x190
[ 1924.781533]  [<ffffffff811287a0>] wait_on_page_bit+0x80/0x90
[ 1924.788047]  [<ffffffff8107f610>] ? autoremove_wake_function+0x50/0x50
[ 1924.795548]  [<ffffffff811369b0>] invalidate_inode_pages2_range+0x170/0x370
[ 1924.803530]  [<ffffffff81136bc7>] invalidate_inode_pages2+0x17/0x20
[ 1924.810728]  [<ffffffffa01d7625>] cifs_invalidate_mapping+0x45/0x90 [cifs]
[ 1924.818621]  [<ffffffffa01d7928>] cifs_revalidate_dentry+0x38/0x40 [cifs]
[ 1924.826387]  [<ffffffffa01cb537>] cifs_d_revalidate+0x27/0xb0 [cifs]
[ 1924.833676]  [<ffffffff8118ebf0>] lookup_fast+0x2e0/0x310
[ 1924.839881]  [<ffffffff8118ff60>] path_lookupat+0x120/0x760
[ 1924.846301]  [<ffffffff811509b5>] ? handle_pte_fault+0x95/0x9e0
[ 1924.853129]  [<ffffffff81176131>] ? kmem_cache_alloc+0x31/0x130
[ 1924.859926]  [<ffffffff811905d4>] filename_lookup+0x34/0xc0
[ 1924.866352]  [<ffffffff8119326e>] user_path_at_empty+0x8e/0x110
[ 1924.873152]  [<ffffffff815cf2c4>] ? __do_page_fault+0x244/0x4e0
[ 1924.879944]  [<ffffffff81193301>] user_path_at+0x11/0x20
[ 1924.886101]  [<ffffffff81188af5>] vfs_fstatat+0x35/0x70
[ 1924.892145]  [<ffffffff81144a28>] ? vm_mmap_pgoff+0x88/0xb0
[ 1924.898551]  [<ffffffff81188b6b>] vfs_stat+0x1b/0x20
[ 1924.904279]  [<ffffffff81188d9a>] sys_newstat+0x1a/0x40
[ 1924.910328]  [<ffffffff810d851c>] ? __audit_syscall_entry+0xcc/0x300
[ 1924.917617]  [<ffffffff815cf56e>] ? do_page_fault+0xe/0x10
[ 1924.923924]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
> 
> ----- Original Message -----
> > From: "Jeff Layton" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> > Cc: caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Wednesday, December 26, 2012 10:37:58 AM
> > Subject: [PATCH] cifs: move check for NULL socket into
> > smb_send_rqst
> > 
> > Cai reported this oops:
> > 
> > [90701.616664] BUG: unable to handle kernel NULL pointer
> > dereference
> > at 0000000000000028
> > [90701.625438] IP: [<ffffffff814a343e>] kernel_setsockopt+0x2e/0x60
> > [90701.632167] PGD fea319067 PUD 103fda4067 PMD 0
> > [90701.637255] Oops: 0000 [#1] SMP
> > [90701.640878] Modules linked in: des_generic md4 nls_utf8 cifs
> > dns_resolver binfmt_misc tun sg igb iTCO_wdt iTCO_vendor_support
> > lpc_ich pcspkr i2c_i801 i2c_core i7core_edac edac_core ioatdma dca
> > mfd_core coretemp kvm_intel kvm crc32c_intel microcode sr_mod cdrom
> > ata_generic sd_mod pata_acpi crc_t10dif ata_piix libata
> > megaraid_sas
> > dm_mirror dm_region_hash dm_log dm_mod
> > [90701.677655] CPU 10
> > [90701.679808] Pid: 9627, comm: ls Tainted: G        W    3.7.1+
> > #10
> > QCI QSSC-S4R/QSSC-S4R
> > [90701.688950] RIP: 0010:[<ffffffff814a343e>]  [<ffffffff814a343e>]
> > kernel_setsockopt+0x2e/0x60
> > [90701.698383] RSP: 0018:ffff88177b431bb8  EFLAGS: 00010206
> > [90701.704309] RAX: ffff88177b431fd8 RBX: 00007ffffffff000 RCX:
> > ffff88177b431bec
> > [90701.712271] RDX: 0000000000000003 RSI: 0000000000000006 RDI:
> > 0000000000000000
> > [90701.720223] RBP: ffff88177b431bc8 R08: 0000000000000004 R09:
> > 0000000000000000
> > [90701.728185] R10: 0000000000000001 R11: 0000000000000000 R12:
> > 0000000000000001
> > [90701.736147] R13: ffff88184ef92000 R14: 0000000000000023 R15:
> > ffff88177b431c88
> > [90701.744109] FS:  00007fd56a1a47c0(0000)
> > GS:ffff88105fc40000(0000)
> > knlGS:0000000000000000
> > [90701.753137] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [90701.759550] CR2: 0000000000000028 CR3: 000000104f15f000 CR4:
> > 00000000000007e0
> > [90701.767512] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> > [90701.775465] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > 0000000000000400
> > [90701.783428] Process ls (pid: 9627, threadinfo ffff88177b430000,
> > task ffff88185ca4cb60)
> > [90701.792261] Stack:
> > [90701.794505]  0000000000000023 ffff88177b431c50 ffff88177b431c38
> > ffffffffa014fcb1
> > [90701.802809]  ffff88184ef921bc 0000000000000000 00000001ffffffff
> > ffff88184ef921c0
> > [90701.811123]  ffff88177b431c08 ffffffff815ca3d9 ffff88177b431c18
> > ffff880857758000
> > [90701.819433] Call Trace:
> > [90701.822183]  [<ffffffffa014fcb1>] smb_send_rqst+0x71/0x1f0
> > [cifs]
> > [90701.828991]  [<ffffffff815ca3d9>] ? schedule+0x29/0x70
> > [90701.834736]  [<ffffffffa014fe6d>] smb_sendv+0x3d/0x40 [cifs]
> > [90701.841062]  [<ffffffffa014fe96>] smb_send+0x26/0x30 [cifs]
> > [90701.847291]  [<ffffffffa015801f>] send_nt_cancel+0x6f/0xd0
> > [cifs]
> > [90701.854102]  [<ffffffffa015075e>] SendReceive+0x18e/0x360 [cifs]
> > [90701.860814]  [<ffffffffa0134a78>] CIFSFindFirst+0x1a8/0x3f0
> > [cifs]
> > [90701.867724]  [<ffffffffa013f731>] ?
> > build_path_from_dentry+0xf1/0x260 [cifs]
> > [90701.875601]  [<ffffffffa013f731>] ?
> > build_path_from_dentry+0xf1/0x260 [cifs]
> > [90701.883477]  [<ffffffffa01578e6>] cifs_query_dir_first+0x26/0x30
> > [cifs]
> > [90701.890869]  [<ffffffffa015480d>]
> > initiate_cifs_search+0xed/0x250
> > [cifs]
> > [90701.898354]  [<ffffffff81195970>] ? fillonedir+0x100/0x100
> > [90701.904486]  [<ffffffffa01554cb>] cifs_readdir+0x45b/0x8f0
> > [cifs]
> > [90701.911288]  [<ffffffff81195970>] ? fillonedir+0x100/0x100
> > [90701.917410]  [<ffffffff81195970>] ? fillonedir+0x100/0x100
> > [90701.923533]  [<ffffffff81195970>] ? fillonedir+0x100/0x100
> > [90701.929657]  [<ffffffff81195848>] vfs_readdir+0xb8/0xe0
> > [90701.935490]  [<ffffffff81195b9f>] sys_getdents+0x8f/0x110
> > [90701.941521]  [<ffffffff815d3b99>] system_call_fastpath+0x16/0x1b
> > [90701.948222] Code: 66 90 55 65 48 8b 04 25 f0 c6 00 00 48 89 e5
> > 53
> > 48 83 ec 08 83 fe 01 48 8b 98 48 e0 ff ff 48 c7 80 48 e0 ff ff ff
> > ff
> > ff ff 74 22 <48> 8b 47 28 ff 50 68 65 48 8b 14 25 f0 c6 00 00 48 89
> > 9a 48 e0
> > [90701.970313] RIP  [<ffffffff814a343e>]
> > kernel_setsockopt+0x2e/0x60
> > [90701.977125]  RSP <ffff88177b431bb8>
> > [90701.981018] CR2: 0000000000000028
> > [90701.984809] ---[ end trace 24bd602971110a43 ]---
> > 
> > This is likely due to a race vs. a reconnection event.
> > 
> > The current code checks for a NULL socket in smb_send_kvec, but
> > that's
> > too late. By the time that check is done, the socket will already
> > have
> > been passed to kernel_setsockopt. Move the check into
> > smb_send_rqst,
> > so
> > that it's checked earlier.
> > 
> > In truth, this is a bit of a half-assed fix. The -ENOTSOCK error
> > return here looks like it could bubble back up to userspace. The
> > locking
> > rules around the ssocket pointer are really unclear as well. There
> > are
> > cases where the ssocket pointer is changed without holding the
> > srv_mutex,
> > but I'm not clear whether there's a potential race here yet or not.
> > 
> > This code seems like it could benefit from some fundamental
> > re-think
> > of
> > how the socket handling should behave. Until then though, this
> > patch
> > should at least fix the above oops in most cases.
> > 
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.7+
> > Reported-by: CAI Qian <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/transport.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 0ed7bc2..3e3b19f 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -144,9 +144,6 @@ smb_send_kvec(struct TCP_Server_Info *server,
> > struct kvec *iov, size_t n_vec,
> >  
> >  	*sent = 0;
> >  
> > -	if (ssocket == NULL)
> > -		return -ENOTSOCK; /* BB eventually add reconnect code here */
> > -
> >  	smb_msg.msg_name = (struct sockaddr *) &server->dstaddr;
> >  	smb_msg.msg_namelen = sizeof(struct sockaddr);
> >  	smb_msg.msg_control = NULL;
> > @@ -291,6 +288,9 @@ smb_send_rqst(struct TCP_Server_Info *server,
> > struct smb_rqst *rqst)
> >  	struct socket *ssocket = server->ssocket;
> >  	int val = 1;
> >  
> > +	if (ssocket == NULL)
> > +		return -ENOTSOCK;
> > +
> >  	cFYI(1, "Sending smb: smb_len=%u", smb_buf_length);
> >  	dump_smb(iov[0].iov_base, iov[0].iov_len);
> >  
> > --
> > 1.7.11.7
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
