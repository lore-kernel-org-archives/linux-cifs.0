From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: kernel crash using smb2
Date: Mon, 20 Sep 2010 14:51:05 -0700
Message-ID: <4C97D749.7080608@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I got smb2 to work against the Vista machine..just had to turn on
SMB2 in the interface settings for vista.

It wrote files to the share for a short time, and then crashed.

This does have my srcaddr patch applied, so it could be my fault,
but I'm curious if anyone has seen similar?


general protection fault: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda1/stat
CPU 4
Modules linked in: cifs bluetooth nls_utf8 smb2 xt_CT iptable_raw ipt_addrtype xt_DSCP xt_dscp xt_string xt_owner xt_NFQUEUE xt_multiport xt_mark xt_iprange 
xt_hashlimit xt_connmark 8021q garp bridge stp llc veth fuse arc4 michael_mic macvlan pktgen iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nfs lockd 
fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput ixgbe ghes e1000e i2c_i801 mdio hed i2c_core ioatdma iTCO_wdt pcspkr microcode i7core_edac edac_core dca 
iTCO_vendor_support shpchp [last unloaded: ipt_addrtype]

Pid: 1806, comm: ip Not tainted 2.6.36-rc4+ #2 X8STi/X8STi
RIP: 0010:[<ffffffff810d9995>]  [<ffffffff810d9995>] kmem_cache_alloc_node+0xf1/0xfa
RSP: 0018:ffff88030cf81738  EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000008010 RCX: 0000000000000000
RDX: 007400610064002d RSI: 00000000000006a5 RDI: ffffffff810d98fc
RBP: ffff88030cf81778 R08: ffff880002511758 R09: 0000000000000000
R10: ffffffff811d4aaa R11: ffff88030cf81728 R12: ffffffff8182bf48
R13: 00000000ffffffff R14: ffffffff811d6fa1 R15: 0000000000000202
FS:  0000000000000000(0000) GS:ffff880002500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000037e26a6d60 CR3: 0000000001843000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ip (pid: 1806, threadinfo ffff88030cf80000, task ffff88032f05b000)
Stack:
  ffff88030cf81758 ffffffff811cb6e8 ffff88030cf81758 0000000000000000
<0> ffff880330337000 ffff88032fc58000 0000000000000000 ffff88032f95c168
<0> ffff88030cf81808 ffffffff811d6fa1 ffff88030cf81818 ffffffff810a735b
Call Trace:
  [<ffffffff811cb6e8>] ? current_io_context+0x23/0x33
  [<ffffffff811d6fa1>] cfq_set_request+0xb3/0x416
  [<ffffffff810a735b>] ? mempool_alloc+0x67/0x119
  [<ffffffff811c5794>] elv_set_request+0x16/0x27
  [<ffffffff811c837e>] get_request+0x1e2/0x27c
  [<ffffffff811c8445>] get_request_wait+0x2d/0x139
  [<ffffffff814051b0>] ? _raw_spin_lock_irq+0x4a/0x51
  [<ffffffff811c7892>] ? spin_lock_irq+0x9/0xb
  [<ffffffff811c95a6>] __make_request+0x28f/0x3c1
  [<ffffffff811c7541>] generic_make_request+0x1b8/0x222
  [<ffffffff811c7672>] submit_bio+0xc7/0xd0
  [<ffffffff811088a7>] submit_bh+0xdd/0xff
  [<ffffffff8110ae85>] __block_write_full_page+0x1cb/0x2ac
  [<ffffffff8115dbd5>] ? noalloc_get_block_write+0x0/0x22
  [<ffffffff81109a3a>] ? end_buffer_async_write+0x0/0x14d
  [<ffffffff81109a3a>] ? end_buffer_async_write+0x0/0x14d
  [<ffffffff8115dbd5>] ? noalloc_get_block_write+0x0/0x22
  [<ffffffff8110afea>] block_write_full_page_endio+0x84/0x91
  [<ffffffff8110b007>] block_write_full_page+0x10/0x12
  [<ffffffff8115c5bd>] ext4_writepage+0x2cc/0x2e1
  [<ffffffff8115c26a>] mpage_da_submit_io+0xed/0x15f
  [<ffffffff8115f821>] ? mpage_da_map_blocks+0x29e/0x2b1
  [<ffffffff811682f3>] ? ext4_journal_start_sb+0xdc/0x111
  [<ffffffff8115ff35>] ext4_da_writepages+0x2a4/0x423
  [<ffffffff810aa934>] ? free_pages_prepare+0xda/0xeb
  [<ffffffff810aac43>] ? __free_pages+0x1b/0x24
  [<ffffffff810accb4>] do_writepages+0x1f/0x28
  [<ffffffff810a659a>] __filemap_fdatawrite_range+0x4e/0x50
  [<ffffffff810a6a9f>] filemap_flush+0x17/0x19
  [<ffffffff8115c6ff>] ext4_alloc_da_blocks+0x2b/0x2d
  [<ffffffff81156e88>] ext4_release_file+0x28/0xa6
  [<ffffffff810e86fb>] fput+0x11b/0x1c3
  [<ffffffff810e55a7>] filp_close+0x63/0x6d
  [<ffffffff81045c73>] put_files_struct+0xc1/0x17e
  [<ffffffff81045d66>] exit_files+0x36/0x3b
  [<ffffffff810476af>] do_exit+0x21c/0x6f6
  [<ffffffff8105f128>] ? up_read+0x1e/0x36
  [<ffffffff81404f62>] ? lockdep_sys_exit_thunk+0x35/0x67
  [<ffffffff81047c01>] do_group_exit+0x78/0xa3
  [<ffffffff81047c3e>] sys_exit_group+0x12/0x16
  [<ffffffff81009a42>] system_call_fastpath+0x16/0x1b
Code: d2 74 11 66 85 db 79 0c 49 63 4c 24 14 31 c0 48 89 d7 f3 aa 48 83 c4 18 48 89 d0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 49 63 44 24 18 <48> 8b 04 02 49 89 00 eb 
95 55 48 89 e5 41 57 41 56 41 55 41 54
RIP  [<ffffffff810d9995>] kmem_cache_alloc_node+0xf1/0xfa
  RSP <ffff88030cf81738>
---[ end trace 64cf1db253cef104 ]---
Fixing recursive fault but reboot is needed!

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
