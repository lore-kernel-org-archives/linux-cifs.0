From: Mikko Rasa <tdb-nLh9gj8vv8Q@public.gmane.org>
Subject: kswapd0 refuses to freeze with CIFS homedir
Date: Mon, 8 May 2017 12:27:48 +0300
Message-ID: <ead13a44-cdad-667b-7dfe-36c9f0af6d7e@tdb.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I've been using CIFS for my home directories for maybe 1.5 years now. 
Every now and then I get this problem where one process or another goes 
into uninterruptible sleep and I can't suspend the system anymore. 
Kswapd is pretty much the worst one.  Last night I got this:

[766864.856880] PM: Syncing filesystems ... done.
[766864.859175] Freezing user space processes ... (elapsed 0.001 
seconds) done.
[766864.860338] Freezing remaining freezable tasks ...
[766884.865179] Freezing of tasks failed after 20.004 seconds (1 tasks 
refusing to freeze, wq_busy=0):
[766884.865183] kswapd0         D    0    63      2 0x00000000
[766884.865185]  0000000000000000 ffff88045cf1d3a8 ffff88045cf1cf00 
ffff88046ec55480
[766884.865186]  ffff8803c0a75c00 ffffc9000027b8d8 ffffffff8137f7c9 
ffffc9000027b900
[766884.865187]  ffffffff810e5de4 ffff88045cf1cf00 ffff88046ec55480 
7fffffffffffffff
[766884.865188] Call Trace:
[766884.865192]  [<ffffffff8137f7c9>] ? __schedule+0x189/0x550
[766884.865193]  [<ffffffff810e5de4>] ? free_pcppages_bulk+0x124/0x380
[766884.865194]  [<ffffffff81380210>] ? bit_wait+0x50/0x50
[766884.865195]  [<ffffffff8137fbc1>] schedule+0x31/0x80
[766884.865196]  [<ffffffff81382298>] schedule_timeout+0x1f8/0x240
[766884.865197]  [<ffffffff810e5de4>] ? free_pcppages_bulk+0x124/0x380
[766884.865197]  [<ffffffff810a796c>] ? ktime_get+0x3c/0xb0
[766884.865198]  [<ffffffff81380210>] ? bit_wait+0x50/0x50
[766884.865199]  [<ffffffff8137f5cf>] io_schedule_timeout+0x9f/0x110
[766884.865200]  [<ffffffff81380226>] bit_wait_io+0x16/0x60
[766884.865201]  [<ffffffff8137ff54>] __wait_on_bit_lock+0x54/0xb0
[766884.865203]  [<ffffffff810e0442>] __lock_page+0x72/0x80
[766884.865204]  [<ffffffff810831d0>] ? autoremove_wake_function+0x30/0x30
[766884.865205]  [<ffffffff810efe7c>] truncate_inode_pages_range+0x47c/0x7c0
[766884.865207]  [<ffffffff810f0217>] truncate_inode_pages_final+0x37/0x40
[766884.865210]  [<ffffffffa2dbc244>] cifs_evict_inode+0x14/0x20 [cifs]
[766884.865211]  [<ffffffff8114918b>] evict+0xbb/0x180
[766884.865212]  [<ffffffff81149468>] iput+0x148/0x1d0
[766884.865213]  [<ffffffff811440ff>] dentry_unlink_inode+0xaf/0x150
[766884.865214]  [<ffffffff81145a33>] __dentry_kill+0xb3/0x150
[766884.865214]  [<ffffffff81145f53>] shrink_dentry_list+0x103/0x2a0
[766884.865215]  [<ffffffff81146aa6>] prune_dcache_sb+0x46/0x60
[766884.865216]  [<ffffffff811338b6>] super_cache_scan+0x116/0x1a0
[766884.865217]  [<ffffffff810f0e8f>] 
shrink_slab.part.7.constprop.18+0x17f/0x230
[766884.865219]  [<ffffffff810f3ff1>] shrink_node+0x61/0x1a0
[766884.865220]  [<ffffffff810f4786>] kswapd+0x2a6/0x5a0
[766884.865221]  [<ffffffff810f44e0>] ? shrink_all_memory+0x90/0x90
[766884.865222]  [<ffffffff810684c5>] kthread+0xc5/0xe0
[766884.865223]  [<ffffffff81068400>] ? kthread_park+0x60/0x60
[766884.865223]  [<ffffffff81383262>] ret_from_fork+0x22/0x30
[766884.865248] Restarting kernel threads ... done.
[766884.865311] Restarting tasks ... done.

Can anyone shed light on what's happening here?  Is it possible to 
change CIFS mount options or Samba configuration to prevent these 
lockups from happening?  Are there any debugging tools I could use to 
get more information?

-- 
Mikko
