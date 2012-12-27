From: CAI Qian <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: move check for NULL socket into smb_send_rqst
Date: Thu, 27 Dec 2012 02:39:57 -0500 (EST)
Message-ID: <2134461783.6371057.1356593997808.JavaMail.root@redhat.com>
References: <20121226065307.27a6350b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121226065307.27a6350b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



----- Original Message -----
> From: "Jeff Layton" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> To: "CAI Qian" <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Sent: Wednesday, December 26, 2012 7:53:07 PM
> Subject: Re: [PATCH] cifs: move check for NULL socket into smb_send_rqst
> 
> On Tue, 25 Dec 2012 22:48:15 -0500 (EST)
> CAI Qian <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > 
> > 
> > ----- Original Message -----
> > > From: "CAI Qian" <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > To: "Jeff Layton" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> > > Sent: Wednesday, December 26, 2012 10:48:31 AM
> > > Subject: Re: [PATCH] cifs: move check for NULL socket into
> > > smb_send_rqst
> > > 
> > > Thanks for the quick patch, Jeff. I have just reproduced this
> > > again,
> > > so I'll try to test this patch to see how it goes. :)
> > OK, it is now triggering hung task below after applied this patch.
> > Jeff,
> > was that the locking issue you mentioned before? I'll see if I can
> > craft out
> > a straight reproducer.
> > 
> 
> Nope, that looks unrelated to the original problem. It almost looks
> like there might be 2 deadlocks involved here. One involving the page
> lock and one on the i_mutex? It's possible that those are related to
> one another, but I can't tell just from the hung task warnings below.
OK, thanks for looking. After some extensive testing (xfstests, ltp,
Connectathon), the oops could not be triggered anymore. Feel free to
take my tested-by tag if necessary. :)

Tested-by: CAI Qian <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> 
> > INFO: task ls:12881 blocked for more than 120 seconds.
> > [ 1923.104385] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1923.113311] ls              D ffff88085fcd3c40     0 12881
> >      1 0x00000084
> > [ 1923.121544]  ffff8820482d1c18 0000000000000086 ffff88205b9eb240
> > ffff8820482d1fd8
> > [ 1923.130164]  ffff8820482d1fd8 ffff8820482d1fd8 ffff88085c596480
> > ffff88205b9eb240
> > [ 1923.138877]  0000000000000022 ffff882032da83c0 ffff882032da83c4
> > ffff88205b9eb240
> > [ 1923.147625] Call Trace:
> > [ 1923.150584]  [] schedule+0x29/0x70
> > [ 1923.156321]  []
> > schedule_preempt_disabled+0xe/0x10
> > [ 1923.163625]  []
> > __mutex_lock_slowpath+0xc3/0x140
> > [ 1923.170717]  [] mutex_lock+0x2a/0x50
> > [ 1923.176646]  [] lookup_slow+0x39/0xab
> > [ 1923.182701]  [] link_path_walk+0x816/0x870
> > [ 1923.189207]  [] ?
> > kmem_cache_alloc_trace+0x11a/0x130
> > [ 1923.196712]  [] path_openat+0x9f/0x4d0
> > [ 1923.202833]  [] ? kmem_cache_free+0x20/0x160
> > [ 1923.209561]  [] ? mempool_free_slab+0x17/0x20
> > [ 1923.216355]  [] ? mempool_free+0x54/0xb0
> > [ 1923.222665]  [] do_filp_open+0x41/0xa0
> > [ 1923.228815]  [] ? __alloc_fd+0x42/0x110
> > [ 1923.235031]  [] do_sys_open+0xf4/0x1e0
> > [ 1923.241153]  [] ?
> > __audit_syscall_entry+0xcc/0x300
> > [ 1923.248440]  [] sys_openat+0x14/0x20
> > [ 1923.254366]  [] system_call_fastpath+0x16/0x1b
> > [ 1923.261265] INFO: task ls:12894 blocked for more than 120
> > seconds.
> > [ 1923.268345] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1923.277269] ls              D ffff88085fcb3c40     0 12894
> >      1 0x00000084
> > [ 1923.285517]  ffff88105715fc18 0000000000000082 ffff881040d83240
> > ffff88105715ffd8
> > [ 1923.294114]  ffff88105715ffd8 ffff88105715ffd8 ffff88205a5b3240
> > ffff881040d83240
> > [ 1923.302847]  ffff88205780c200 ffff882032da83c0 ffff882032da83c4
> > ffff881040d83240
> > [ 1923.311578] Call Trace:
> > [ 1923.314501]  [] schedule+0x29/0x70
> > [ 1923.320240]  []
> > schedule_preempt_disabled+0xe/0x10
> > [ 1923.327521]  []
> > __mutex_lock_slowpath+0xc3/0x140
> > [ 1923.334596]  [] mutex_lock+0x2a/0x50
> > [ 1923.340520]  [] lookup_slow+0x39/0xab
> > [ 1923.346537]  [] link_path_walk+0x816/0x870
> > [ 1923.353063]  [] ?
> > kmem_cache_alloc_trace+0x11a/0x130
> > [ 1923.360542]  [] path_openat+0x9f/0x4d0
> > [ 1923.366675]  [] ?
> > initiate_cifs_search+0x17a/0x250 [cifs]
> > [ 1923.374631]  [] do_filp_open+0x41/0xa0
> > [ 1923.380745]  [] ? __alloc_fd+0x42/0x110
> > [ 1923.386962]  [] do_sys_open+0xf4/0x1e0
> > [ 1923.393076]  [] ?
> > __audit_syscall_entry+0xcc/0x300
> > [ 1923.400360]  [] sys_openat+0x14/0x20
> > [ 1923.406308]  [] system_call_fastpath+0x16/0x1b
> > [ 1923.413199] INFO: task dd:12957 blocked for more than 120
> > seconds.
> > [ 1923.420279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1923.429235] dd              D ffff88105fc33c40     0 12957
> >      1 0x00000086
> > [ 1923.437466]  ffff882057861a08 0000000000000046 ffff88205c314b60
> > ffff882057861fd8
> > [ 1923.446255]  ffff882057861fd8 ffff882057861fd8 ffff88085c559920
> > ffff88205c314b60
> > [ 1923.454856]  ffff882057861a08 ffff88205c314b60 ffff88105fc344a8
> > 0000000000000002
> > [ 1923.463558] Call Trace:
> > [ 1923.466497]  [] ? __lock_page+0x70/0x70
> > [ 1923.472721]  [] schedule+0x29/0x70
> > [ 1923.478436]  [] io_schedule+0x8f/0xd0
> > [ 1923.484476]  [] sleep_on_page+0xe/0x20
> > [ 1923.490597]  [] __wait_on_bit+0x60/0x90
> > [ 1923.496814]  [] ?
> > find_get_pages_tag+0x102/0x1b0
> > [ 1923.503901]  [] wait_on_page_bit+0x80/0x90
> > [ 1923.510410]  [] ?
> > autoremove_wake_function+0x50/0x50
> > [ 1923.517878]  []
> > filemap_fdatawait_range+0x101/0x190
> > [ 1923.525285]  [] filemap_fdatawait+0x27/0x30
> > [ 1923.531886]  []
> > filemap_write_and_wait+0x44/0x60
> > [ 1923.538997]  [] cifs_flush+0x59/0x80 [cifs]
> > [ 1923.545600]  [] filp_close+0x3f/0xa0
> > [ 1923.551524]  [] put_files_struct+0x9c/0xf0
> > [ 1923.558035]  [] exit_files+0x4b/0x60
> > [ 1923.563964]  [] do_exit+0x191/0x8d0
> > [ 1923.569818]  [] do_group_exit+0x3f/0xa0
> > [ 1923.576035]  []
> > get_signal_to_deliver+0x1ba/0x5d0
> > [ 1923.583220]  [] ? do_sync_write+0xa7/0xe0
> > [ 1923.589646]  [] do_signal+0x3f/0x610
> > [ 1923.595571]  [] do_notify_resume+0x65/0x80
> > [ 1923.602083]  [] ?
> > __audit_syscall_exit+0x3ec/0x450
> > [ 1923.609364]  [] int_signal+0x12/0x17
> > [ 1923.615289] INFO: task dd:13001 blocked for more than 120
> > seconds.
> > [ 1923.622369] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1923.631312] dd              D ffff88085fc73c40     0 13001
> >      1 0x00000084
> > [ 1923.639570]  ffff88205a1cbcf8 0000000000000082 ffff882048354b60
> > ffff88205a1cbfd8
> > [ 1923.648184]  ffff88205a1cbfd8 ffff88205a1cbfd8 ffff88085c56b240
> > ffff882048354b60
> > [ 1923.656883]  ffff88205a1cbcf8 ffff882048354b60 ffff88085fc744a8
> > 0000000000000002
> > [ 1923.665643] Call Trace:
> > [ 1923.668571]  [] ? __lock_page+0x70/0x70
> > [ 1923.674782]  [] schedule+0x29/0x70
> > [ 1923.680512]  [] io_schedule+0x8f/0xd0
> > [ 1923.686528]  [] sleep_on_page+0xe/0x20
> > [ 1923.692642]  [] __wait_on_bit+0x60/0x90
> > [ 1923.698858]  [] ?
> > find_get_pages_tag+0x102/0x1b0
> > [ 1923.705949]  [] wait_on_page_bit+0x80/0x90
> > [ 1923.712450]  [] ?
> > autoremove_wake_function+0x50/0x50
> > [ 1923.719955]  []
> > filemap_fdatawait_range+0x101/0x190
> > [ 1923.727368]  [] filemap_fdatawait+0x27/0x30
> > [ 1923.733972]  []
> > filemap_write_and_wait+0x44/0x60
> > [ 1923.741073]  [] cifs_flush+0x59/0x80 [cifs]
> > [ 1923.747677]  [] filp_close+0x3f/0xa0
> > [ 1923.753583]  [] __close_fd+0x77/0x90
> > [ 1923.759500]  [] sys_close+0x20/0x50
> > [ 1923.765326]  [] system_call_fastpath+0x16/0x1b
> > [ 1923.772204] INFO: task mv:13050 blocked for more than 120
> > seconds.
> > [ 1923.779293] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1923.788214] mv              D ffff88185fcf3c40     0 13050
> >      1 0x00000084
> > [ 1923.796457]  ffff88204e955a18 0000000000000082 ffff88205ac61920
> > ffff88204e955fd8
> > [ 1923.805094]  ffff88204e955fd8 ffff88204e955fd8 ffff88085c5ae480
> > ffff88205ac61920
> > [ 1923.813822]  ffff88204e955a18 ffff88205ac61920 ffff88185fcf44a8
> > 0000000000000002
> > [ 1923.822548] Call Trace:
> > [ 1923.825489]  [] ? __lock_page+0x70/0x70
> > [ 1923.831712]  [] schedule+0x29/0x70
> > [ 1923.837431]  [] io_schedule+0x8f/0xd0
> > [ 1923.843447]  [] sleep_on_page+0xe/0x20
> > [ 1923.849562]  [] __wait_on_bit+0x60/0x90
> > [ 1923.855777]  [] ? find_get_pages+0xf5/0x190
> > [ 1923.862382]  [] wait_on_page_bit+0x80/0x90
> > [ 1923.868886]  [] ?
> > autoremove_wake_function+0x50/0x50
> > [ 1923.876373]  []
> > invalidate_inode_pages2_range+0x170/0x370
> > [ 1923.884347]  []
> > invalidate_inode_pages2+0x17/0x20
> > [ 1923.891539]  []
> > cifs_invalidate_mapping+0x45/0x90 [cifs]
> > [ 1923.899418]  []
> > cifs_revalidate_dentry+0x38/0x40 [cifs]
> > [ 1923.907196]  [] cifs_d_revalidate+0x27/0xb0
> > [cifs]
> > [ 1923.914509]  [] lookup_fast+0x2e0/0x310
> > [ 1923.920723]  [] path_lookupat+0x120/0x760
> > [ 1923.927137]  [] ? handle_pte_fault+0x95/0x9e0
> > [ 1923.933953]  [] ? kmem_cache_alloc+0x31/0x130
> > [ 1923.940783]  [] filename_lookup+0x34/0xc0
> > [ 1923.947188]  [] user_path_at_empty+0x8e/0x110
> > [ 1923.953993]  [] ? __do_page_fault+0x244/0x4e0
> > [ 1923.960797]  [] user_path_at+0x11/0x20
> > [ 1923.966962]  [] vfs_fstatat+0x35/0x70
> > [ 1923.972993]  [] ? file_has_perm+0x97/0xb0
> > [ 1923.979412]  [] vfs_stat+0x1b/0x20
> > [ 1923.985137]  [] sys_newstat+0x1a/0x40
> > [ 1923.991178]  [] ?
> > __audit_syscall_entry+0xcc/0x300
> > [ 1923.998457]  [] ? do_page_fault+0xe/0x10
> > [ 1924.004775]  [] system_call_fastpath+0x16/0x1b
> > [ 1924.011669] INFO: task ln:13085 blocked for more than 120
> > seconds.
> > [ 1924.018754] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1924.027709] ln              D ffff88085fd33c40     0 13085
> >      1 0x00000084
> > [ 1924.035957]  ffff88185385dbe8 0000000000000082 ffff88185b241920
> > ffff88185385dfd8
> > [ 1924.044565]  ffff88185385dfd8 ffff88185385dfd8 ffff88085c5d1920
> > ffff88185b241920
> > [ 1924.053331]  ffff882032da8318 ffff882032da83c0 ffff882032da83c4
> > ffff88185b241920
> > [ 1924.062052] Call Trace:
> > [ 1924.064895]  [] schedule+0x29/0x70
> > [ 1924.070629]  []
> > schedule_preempt_disabled+0xe/0x10
> > [ 1924.077930]  []
> > __mutex_lock_slowpath+0xc3/0x140
> > [ 1924.085043]  [] mutex_lock+0x2a/0x50
> > [ 1924.090999]  [] lookup_slow+0x39/0xab
> > [ 1924.097041]  [] path_lookupat+0x6ff/0x760
> > [ 1924.103447]  [] ? handle_pte_fault+0x95/0x9e0
> > [ 1924.110267]  [] ? kmem_cache_alloc+0x31/0x130
> > [ 1924.117093]  [] filename_lookup+0x34/0xc0
> > [ 1924.123508]  [] user_path_at_empty+0x8e/0x110
> > [ 1924.130318]  [] ? __do_page_fault+0x244/0x4e0
> > [ 1924.137137]  [] user_path_at+0x11/0x20
> > [ 1924.143285]  [] vfs_fstatat+0x35/0x70
> > [ 1924.149315]  [] ? vm_mmap_pgoff+0x88/0xb0
> > [ 1924.155715]  [] vfs_stat+0x1b/0x20
> > [ 1924.161468]  [] sys_newstat+0x1a/0x40
> > [ 1924.167491]  [] ?
> > __audit_syscall_entry+0xcc/0x300
> > [ 1924.174774]  [] ? do_page_fault+0xe/0x10
> > [ 1924.181098]  [] system_call_fastpath+0x16/0x1b
> > [ 1924.187990] INFO: task mkdir:13087 blocked for more than 120
> > seconds.
> > [ 1924.195365] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1924.204288] mkdir           D ffff88105fcf3c40     0 13087
> >      1 0x00000084
> > [ 1924.212561]  ffff88084b30fb78 0000000000000082 ffff88085b213240
> > ffff88084b30ffd8
> > [ 1924.221134]  ffff88084b30ffd8 ffff88084b30ffd8 ffff88085c5b8000
> > ffff88085b213240
> > [ 1924.229889]  ffff88084b30fb78 ffff88085b213240 ffff88105fcf44a8
> > 0000000000000002
> > [ 1924.238829] Call Trace:
> > [ 1924.241753]  [] ? __lock_page+0x70/0x70
> > [ 1924.247998]  [] schedule+0x29/0x70
> > [ 1924.253750]  [] io_schedule+0x8f/0xd0
> > [ 1924.259795]  [] sleep_on_page+0xe/0x20
> > [ 1924.265935]  [] __wait_on_bit_lock+0x5b/0xc0
> > [ 1924.272632]  [] ? find_get_pages+0xf5/0x190
> > [ 1924.279256]  [] __lock_page+0x67/0x70
> > [ 1924.285274]  [] ?
> > autoremove_wake_function+0x50/0x50
> > [ 1924.292743]  []
> > invalidate_inode_pages2_range+0x14b/0x370
> > [ 1924.300706]  []
> > invalidate_inode_pages2+0x17/0x20
> > [ 1924.307922]  []
> > cifs_invalidate_mapping+0x45/0x90 [cifs]
> > [ 1924.315820]  []
> > cifs_revalidate_dentry+0x38/0x40 [cifs]
> > [ 1924.323599]  [] cifs_d_revalidate+0x27/0xb0
> > [cifs]
> > [ 1924.330860]  [] lookup_dcache+0x80/0xd0
> > [ 1924.337108]  [] ?
> > __mutex_lock_slowpath+0xcb/0x140
> > [ 1924.344409]  [] __lookup_hash+0x23/0x50
> > [ 1924.350649]  [] lookup_hash+0x19/0x20
> > [ 1924.356674]  [] kern_path_create+0x8b/0x170
> > [ 1924.363279]  [] ?
> > getname_flags.part.32+0x86/0x150
> > [ 1924.370576]  [] user_path_create+0x4a/0x70
> > [ 1924.377106]  [] sys_mkdirat+0x21/0x80
> > [ 1924.383128]  [] sys_mkdir+0x19/0x20
> > [ 1924.388982]  [] system_call_fastpath+0x16/0x1b
> > [ 1924.395905] INFO: task mkdir:13090 blocked for more than 120
> > seconds.
> > [ 1924.403263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1924.412217] mkdir           D ffff88185fd73c40     0 13090
> >      1 0x00000084
> > [ 1924.420443]  ffff8808565b9da8 0000000000000082 ffff88085b6e3240
> > ffff8808565b9fd8
> > [ 1924.429024]  ffff8808565b9fd8 ffff8808565b9fd8 ffff88105b928000
> > ffff88085b6e3240
> > [ 1924.437772]  ffff8808565b9e18 ffff882032da83c0 ffff882032da83c4
> > ffff88085b6e3240
> > [ 1924.446695] Call Trace:
> > [ 1924.449647]  [] schedule+0x29/0x70
> > [ 1924.455375]  []
> > schedule_preempt_disabled+0xe/0x10
> > [ 1924.462670]  []
> > __mutex_lock_slowpath+0xc3/0x140
> > [ 1924.469756]  [] mutex_lock+0x2a/0x50
> > [ 1924.475709]  [] kern_path_create+0x7f/0x170
> > [ 1924.482312]  [] ?
> > getname_flags.part.32+0x86/0x150
> > [ 1924.489595]  [] user_path_create+0x4a/0x70
> > [ 1924.496098]  [] sys_mkdirat+0x21/0x80
> > [ 1924.502123]  [] sys_mkdir+0x19/0x20
> > [ 1924.507973]  [] system_call_fastpath+0x16/0x1b
> > [ 1924.514887] INFO: task ln:13100 blocked for more than 120
> > seconds.
> > [ 1924.521992] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1924.530942] ln              D ffff88185fd53c40     0 13100
> >      1 0x00000084
> > [ 1924.539189]  ffff88184e6f7be8 0000000000000086 ffff88184a136480
> > ffff88184e6f7fd8
> > [ 1924.547796]  ffff88184e6f7fd8 ffff88184e6f7fd8 ffff88085c5e9920
> > ffff88184a136480
> > [ 1924.556757]  ffff882032da8318 ffff882032da83c0 ffff882032da83c4
> > ffff88184a136480
> > [ 1924.565375] Call Trace:
> > [ 1924.568300]  [] schedule+0x29/0x70
> > [ 1924.574034]  []
> > schedule_preempt_disabled+0xe/0x10
> > [ 1924.581298]  []
> > __mutex_lock_slowpath+0xc3/0x140
> > [ 1924.588379]  [] mutex_lock+0x2a/0x50
> > [ 1924.594332]  [] lookup_slow+0x39/0xab
> > [ 1924.600363]  [] path_lookupat+0x6ff/0x760
> > [ 1924.606751]  [] ? handle_pte_fault+0x95/0x9e0
> > [ 1924.613551]  [] ? kmem_cache_alloc+0x31/0x130
> > [ 1924.620378]  [] filename_lookup+0x34/0xc0
> > [ 1924.626785]  [] user_path_at_empty+0x8e/0x110
> > [ 1924.633587]  [] ? __do_page_fault+0x244/0x4e0
> > [ 1924.640380]  [] user_path_at+0x11/0x20
> > [ 1924.646497]  [] vfs_fstatat+0x35/0x70
> > [ 1924.652513]  [] ? vm_mmap_pgoff+0x88/0xb0
> > [ 1924.658939]  [] vfs_stat+0x1b/0x20
> > [ 1924.664698]  [] sys_newstat+0x1a/0x40
> > [ 1924.670743]  [] ?
> > __audit_syscall_entry+0xcc/0x300
> > [ 1924.678047]  [] ? do_page_fault+0xe/0x10
> > [ 1924.684358]  [] system_call_fastpath+0x16/0x1b
> > [ 1924.691277] INFO: task ln:13101 blocked for more than 120
> > seconds.
> > [ 1924.698385] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [ 1924.707314] ln              D ffff88105fc73c40     0 13101
> >      1 0x00000084
> > [ 1924.715544]  ffff881856663a18 0000000000000082 ffff88185ae8b240
> > ffff881856663fd8
> > [ 1924.724185]  ffff881856663fd8 ffff881856663fd8 ffff88085c56e480
> > ffff88185ae8b240
> > [ 1924.732906]  ffff881856663a18 ffff88185ae8b240 ffff88105fc744a8
> > 0000000000000002
> > [ 1924.741629] Call Trace:
> > [ 1924.744544]  [] ? __lock_page+0x70/0x70
> > [ 1924.750762]  [] schedule+0x29/0x70
> > [ 1924.756487]  [] io_schedule+0x8f/0xd0
> > [ 1924.762536]  [] sleep_on_page+0xe/0x20
> > [ 1924.768678]  [] __wait_on_bit+0x60/0x90
> > [ 1924.774919]  [] ? find_get_pages+0xf5/0x190
> > [ 1924.781533]  [] wait_on_page_bit+0x80/0x90
> > [ 1924.788047]  [] ?
> > autoremove_wake_function+0x50/0x50
> > [ 1924.795548]  []
> > invalidate_inode_pages2_range+0x170/0x370
> > [ 1924.803530]  []
> > invalidate_inode_pages2+0x17/0x20
> > [ 1924.810728]  []
> > cifs_invalidate_mapping+0x45/0x90 [cifs]
> > [ 1924.818621]  []
> > cifs_revalidate_dentry+0x38/0x40 [cifs]
> > [ 1924.826387]  [] cifs_d_revalidate+0x27/0xb0
> > [cifs]
> > [ 1924.833676]  [] lookup_fast+0x2e0/0x310
> > [ 1924.839881]  [] path_lookupat+0x120/0x760
> > [ 1924.846301]  [] ? handle_pte_fault+0x95/0x9e0
> > [ 1924.853129]  [] ? kmem_cache_alloc+0x31/0x130
> > [ 1924.859926]  [] filename_lookup+0x34/0xc0
> > [ 1924.866352]  [] user_path_at_empty+0x8e/0x110
> > [ 1924.873152]  [] ? __do_page_fault+0x244/0x4e0
> > [ 1924.879944]  [] user_path_at+0x11/0x20
> > [ 1924.886101]  [] vfs_fstatat+0x35/0x70
> > [ 1924.892145]  [] ? vm_mmap_pgoff+0x88/0xb0
> > [ 1924.898551]  [] vfs_stat+0x1b/0x20
> > [ 1924.904279]  [] sys_newstat+0x1a/0x40
> > [ 1924.910328]  [] ?
> > __audit_syscall_entry+0xcc/0x300
> > [ 1924.917617]  [] ? do_page_fault+0xe/0x10
> > [ 1924.923924]  [] system_call_fastpath+0x16/0x1b
> > > 
> 
> 
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
