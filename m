From: Adam Nielsen <a.nielsen-HxjuLhO6/OPR7s880joybQ@public.gmane.org>
Subject: OOPS in cifs_write_end (3.0-rc5) - NULL pointer dereference
Date: Thu, 07 Jul 2011 13:58:42 +1000
Message-ID: <4E152EF2.7030001@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

Just updated my kernel from an old 2.6 one and I can no longer copy 
files on CIFS mounts.  Running "cp a b" creates a file called 'b' but 
then the kernel crashes and the system freezes before any data can be 
placed into the file.  The problem can be reproduced 100% of the time.

The messages logged via a serial console are below.  I can try again 
without the nvidia module if you want but I don't think it will make a 
difference.  There are some more 'BUG' messages about 'scheduling while 
atomic' (one per CPU core) but I'm not sure they are relevant so I only 
included one here.

For reference, the share was mounted from an old server apparently 
running Samba 3.0.37.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff8112d3ae>] __mark_inode_dirty+0x16e/0x250
PGD 113cbb067 PUD 113d07067 PMD 0
Oops: 0002 [#1] PREEMPT SMP
CPU 0
Modules linked in: coretemp iptable_mangle xt_tcpudp xt_state 
iptable_filter ipt_MASQUERADE xt_comment iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_DSCP xt_dscp xt_string xt_owner 
xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack 
xt_connmark ip_tables x_tables ext4 mbcache jbd2 crc16 nf_conntrack_ftp 
nf_conntrack nvidia(P) snd_hda_codec_analog firewire_ohci i2c_i801 
firewire_core snd_hda_intel tpm_tis tg3 tpm ppdev tpm_bios libphy 
snd_hda_codec parport_pc iTCO_wdt parport crc_itu_t snd_hwdep

Pid: 2792, comm: cp Tainted: P        W   3.0.0-rc5 #1 Dell Inc. 
Precision WorkStation T3400  /0TP412
RIP: 0010:[<ffffffff8112d3ae>]  [<ffffffff8112d3ae>] 
__mark_inode_dirty+0x16e/0x250
RSP: 0018:ffff880113d31b58  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8801259ec050 RCX: ffff88012132dd78
RDX: ffff88012132dd78 RSI: 0000000000000000 RDI: ffffffff81822300
RBP: ffff88012132dd10 R08: 0000000000000000 R09: 0000000000000004
R10: 00000000ffffffff R11: 0000000000000000 R12: ffff88012132dd30
R13: ffff8801259ec1a8 R14: 0000000000000000 R15: ffff88012132dd10
FS:  00007ff6fbcee700(0000) GS:ffff88012bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000124c95000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cp (pid: 2792, threadinfo ffff880113d30000, task ffff8801265a4d70)
Stack:
  ffffea0003ec9810 ffff88012132de58 ffff88012132de58 ffff88012132de70
  0000000000001000 ffffffff810c874f 0000000000000000 ffffea0003ec9810
  0000000000000c99 0000000000000c99 ffff880124dad2c0 ffffffff811e98dc
Call Trace:
  [<ffffffff810c874f>] ? __set_page_dirty_nobuffers+0xdf/0x180
  [<ffffffff811e98dc>] ? cifs_write_end+0x9c/0x280
  [<ffffffff810be6a2>] ? generic_file_buffered_write+0xd2/0x270
  [<ffffffff810c0598>] ? __generic_file_aio_write+0x278/0x460
  [<ffffffff810c07d8>] ? generic_file_aio_write+0x58/0xd0
  [<ffffffff811d307f>] ? cifs_file_aio_write+0x1f/0x80
  [<ffffffff81107680>] ? do_sync_write+0xc0/0x100
  [<ffffffff8110817b>] ? vfs_write+0xcb/0x170
  [<ffffffff81108323>] ? sys_write+0x53/0xa0
  [<ffffffff815be53b>] ? system_call_fastpath+0x16/0x1b
Code: 8b 05 f7 18 77 00 48 8b 55 68 48 89 45 50 48 8d 4d 68 48 8b 45 70 
48 c7 c7 00 23 82 81 48 89 42 08 48 89 10 48 8b 83 58 01 00 00
  89 48 08 48 89 45 68 4c 89 6d 70 48 89 8b 58 01 00 00 e8 ca
RIP  [<ffffffff8112d3ae>] __mark_inode_dirty+0x16e/0x250
  RSP <ffff880113d31b58>
CR2: 0000000000000008
---[ end trace 315678c984b698f2 ]---
note: cp[2792] exited with preempt_count 1
BUG: scheduling while atomic: cp/2792/0x10000002
Modules linked in: coretemp iptable_mangle xt_tcpudp xt_state 
iptable_filter ipt_MASQUERADE xt_comment iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_DSCP xt_dscp xt_string xt_owner 
xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack 
xt_connmark ip_tables x_tables ext4 mbcache jbd2 crc16 nf_conntrack_ftp 
nf_conntrack nvidia(P) snd_hda_codec_analog firewire_ohci i2c_i801 
firewire_core snd_hda_intel tpm_tis tg3 tpm ppdev tpm_bios libphy 
snd_hda_codec parport_pc iTCO_wdt parport crc_itu_t snd_hwdep
Pid: 2792, comm: cp Tainted: P      D W   3.0.0-rc5 #1
Call Trace:
  [<ffffffff815b5690>] ? schedule+0x7b0/0x930
  [<ffffffff8107f2e4>] ? kallsyms_lookup+0xe4/0x120
  [<ffffffff810ca134>] ? lru_add_drain+0x84/0x110
  [<ffffffff810f1729>] ? free_pages_and_swap_cache+0x19/0xc0
  [<ffffffff8103a6a3>] ? __cond_resched+0x13/0x30
  [<ffffffff815b5a45>] ? _cond_resched+0x35/0x50
  [<ffffffff810e3f29>] ? unmap_vmas+0x5c9/0x960
  [<ffffffff810e64b2>] ? exit_mmap+0xb2/0x120
  [<ffffffff8103df49>] ? mmput+0x49/0x120
  [<ffffffff8104281a>] ? exit_mm+0x11a/0x150
  [<ffffffff815b7b6f>] ? _raw_spin_lock_irq+0xf/0x30
  [<ffffffff81044a88>] ? do_exit+0x828/0x890
  [<ffffffff81040bd3>] ? kmsg_dump+0xd3/0x110
  [<ffffffff815b8ced>] ? oops_end+0x9d/0xa0
  [<ffffffff81025470>] ? no_context+0x100/0x270
  [<ffffffff81025745>] ? __bad_area_nosemaphore+0x165/0x210
  [<ffffffff815b4ac8>] ? printk+0x4e/0x56
  [<ffffffff81079749>] ? __module_text_address+0x9/0x70
  [<ffffffff8112d483>] ? __mark_inode_dirty+0x243/0x250
  [<ffffffff815b4ac8>] ? printk+0x4e/0x56
  [<ffffffff815baa7e>] ? do_page_fault+0x39e/0x570
  [<ffffffff815b48b4>] ? dump_stack+0x69/0x6f
  [<ffffffff8112d483>] ? __mark_inode_dirty+0x243/0x250
  [<ffffffff81040329>] ? print_oops_end_marker+0x9/0x30
  [<ffffffff8112d483>] ? __mark_inode_dirty+0x243/0x250
  [<ffffffff8104055d>] ? warn_slowpath_common+0x8d/0xd0
  [<ffffffff815b80cf>] ? page_fault+0x1f/0x30
  [<ffffffff8112d3ae>] ? __mark_inode_dirty+0x16e/0x250
  [<ffffffff8112d382>] ? __mark_inode_dirty+0x142/0x250
  [<ffffffff810c874f>] ? __set_page_dirty_nobuffers+0xdf/0x180
  [<ffffffff811e98dc>] ? cifs_write_end+0x9c/0x280
  [<ffffffff810be6a2>] ? generic_file_buffered_write+0xd2/0x270
  [<ffffffff810c0598>] ? __generic_file_aio_write+0x278/0x460
  [<ffffffff810c07d8>] ? generic_file_aio_write+0x58/0xd0
  [<ffffffff811d307f>] ? cifs_file_aio_write+0x1f/0x80
  [<ffffffff81107680>] ? do_sync_write+0xc0/0x100
  [<ffffffff8110817b>] ? vfs_write+0xcb/0x170
  [<ffffffff81108323>] ? sys_write+0x53/0xa0
  [<ffffffff815be53b>] ? system_call_fastpath+0x16/0x1b

Please let me know if you need me to do any additional testing.

Thanks,
Adam.
