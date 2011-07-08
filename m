From: Adam Nielsen <a.nielsen-HxjuLhO6/OPR7s880joybQ@public.gmane.org>
Subject: Re: OOPS in cifs_write_end (3.0-rc5) - NULL pointer dereference
Date: Fri, 08 Jul 2011 13:55:54 +1000
Message-ID: <4E167FCA.50808@shikadi.net>
References: <4E152EF2.7030001@shikadi.net> <20110707083922.57003501@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110707083922.57003501-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks for the quick reply!

> Interesting. I don't seem to be able to reproduce this on a -rc6
> kernel, and I don't recall seeing it happen in any interim kernels
> either. You may want to patch up to the latest kernel and see if the
> problem goes away.

I just compiled 3.0-rc6 (with cifs as a module instead) and I can still 
reproduce it.  Once the copy operation sat there for about five seconds 
before the oops, but all the other times it has oopsed immediately.  I 
am however getting the oops in a different function with -rc6, but still 
via CIFS.  Apart from CIFS I only have local and NFS mounts and they all 
seem to work fine.

> It looks like it hit a NULL pointer reference down in the bowels of the
> generic inode dirtying code. I sort of doubt this is a bug in cifs
> per-se, but it's hard to know without more detail.
>
> It may be helpful to follow the directions here and see if you can get
> a listing of where it oopsed:

Here is the new oops, followed by the gdb output:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff8112d3ae>] __mark_inode_dirty+0x16e/0x250
PGD 126cd4067 PUD 11e26a067 PMD 0
Oops: 0002 [#1] PREEMPT SMP
CPU 0
Modules linked in: cifs coretemp ipt_MASQUERADE iptable_nat nf_nat 
xt_tcpudp xt_comment nf_conntrack_ipv4 nf_defrag_ipv4 xt_state 
iptable_filter iptable_mangle xt_DSCP xt_dscp xt_string xt_owner 
xt_NFQUEUE xt_multiport xt_mark xt_iprange xt_hashlimit xt_conntrack 
xt_connmark ip_tables x_tables ext4 mbcache jbd2 crc16 nf_conntrack_ftp 
nf_conntrack snd_hda_codec_analog snd_hda_intel snd_hda_codec tg3 
firewire_ohci tpm_tis ppdev tpm firewire_core tpm_bios i2c_i801 
parport_pc iTCO_wdt libphy snd_hwdep parport crc_itu_t

Pid: 2851, comm: cp Tainted: G        W   3.0.0-rc6 #2 Dell Inc. 
Precision WorkStation T3400  /0TP412
RIP: 0010:[<ffffffff8112d3ae>]  [<ffffffff8112d3ae>] 
__mark_inode_dirty+0x16e/0x250
RSP: 0018:ffff88011e10bc28  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880124b86850 RCX: ffff88011a16cb38
RDX: ffff88011a16cb38 RSI: 0000000000000000 RDI: ffffffff817e8300
RBP: ffff88011a16cad0 R08: 0000000000000000 R09: 0000000000000004
R10: 00000000ffffffff R11: 0000000000000000 R12: ffff88011a16caf0
R13: ffff880124b869a8 R14: 0000000000000000 R15: ffff880124b86800
FS:  00007f4415492700(0000) GS:ffff88012bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 0000000114178000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cp (pid: 2851, threadinfo ffff88011e10a000, task ffff8801140d2720)
Stack:
  0000000000000000 ffff8801259cd0c0 ffff88011e10bd08 ffff880124266280
  ffff88011a16cad0 ffffffffa01ff5ea ffff88011e10bcf6 ffff88011b06a700
  0000003914052dc0 ffff88011e10bd08 000000000000a068 0000000000000000
Call Trace:
  [<ffffffffa01ff5ea>] ? cifs_setattr+0x51a/0x780 [cifs]
  [<ffffffff81121783>] ? notify_change+0x113/0x300
  [<ffffffff81106de7>] ? do_truncate+0x57/0x80
  [<ffffffff81114f7f>] ? do_last+0x59f/0x780
  [<ffffffff81290d5f>] ? __percpu_counter_add+0x6f/0xc0
  [<ffffffff81116ca9>] ? path_openat+0xd9/0x410
  [<ffffffff8159018f>] ? _raw_spin_lock_irqsave+0x1f/0x50
  [<ffffffff8111711c>] ? do_filp_open+0x4c/0xc0
  [<ffffffff810368a9>] ? get_parent_ip+0x9/0x20
  [<ffffffff81593297>] ? sub_preempt_count+0x87/0xc0
  [<ffffffff8158fe80>] ? _raw_spin_unlock+0x10/0x40
  [<ffffffff81122792>] ? alloc_fd+0x122/0x150
  [<ffffffff81105cc9>] ? do_sys_open+0x169/0x200
  [<ffffffff81596afb>] ? system_call_fastpath+0x16/0x1b
Code: 8b 05 f7 78 73 00 48 8b 55 68 48 89 45 50 48 8d 4d 68 48 8b 45 70 
48 c7 c7 00 83 7e 81 48 89 42 08 48 89 10 48 8b 83 58 01 00 00
  89 48 08 48 89 45 68 4c 89 6d 70 48 89 8b 58 01 00 00 e8 aa
RIP  [<ffffffff8112d3ae>] __mark_inode_dirty+0x16e/0x250
  RSP <ffff88011e10bc28>
CR2: 0000000000000008
---[ end trace e10f67c8a11411b7 ]---
note: cp[2851] exited with preempt_count 1


(gdb) list *(cifs_setattr+0x51a)
0x1a61a is in cifs_setattr (fs/cifs/inode.c:2096).
2091               of the fs types (eg ext3, fat) do not have fine enough
2092               time granularity to match protocol, and we do not have a
2093               a way (yet) to query the server fs's time granularity 
(and
2094               whether it rounds times down).
2095            */
2096            if (attrs->ia_valid & (ATTR_MTIME | ATTR_CTIME))
2097                    cifsInode->time = 0;
2098    out:
2099            kfree(args);
2100            kfree(full_path);

The previous source line to 2096 (ignoring comments) is a call to 
mark_inode_dirty().

(gdb) list *(__mark_inode_dirty+0x16e)
0xffffffff8112d3ae is in __mark_inode_dirty (include/linux/list.h:41).
36      #ifndef CONFIG_DEBUG_LIST
37      static inline void __list_add(struct list_head *new,
38                                    struct list_head *prev,
39                                    struct list_head *next)
40      {
41              next->prev = new;
42              new->next = next;
43              new->prev = prev;
44              prev->next = new;
45      }

Not sure that this is really that helpful, but happy to test further...

Cheers,
Adam.
