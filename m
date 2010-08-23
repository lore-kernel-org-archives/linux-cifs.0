From: Vijai Baskar <cristalmaze-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: smbd blocks for 120 secs and then hangs in D state
Date: Mon, 23 Aug 2010 10:40:34 +0530
Message-ID: <AANLkTik=70UfQue+WL=NWLtni7NiajZiXqUZ-4xg2rPs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

I am running a samba copy of a 4GB file from my local hard disk to a
remote hard disk and then find md5sum of the same file in the remote
hard disk through samba read. I do the following to accomplish this:

1. mount -t cifs //ip-addr/data /mnt
2. cp /home/4g /mnt
3. md5sum /mnt/4g

After a few iterations of the above operation I get the following
warning on the board:

echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6122.450000] smbd          D c0204908     0  9712    372 0x00000000
[ 6122.480000] [<c0204908>] (schedule+0x2dc/0x328) from [<c0204980>]
(io_schedule+0x2c/0x48)
[ 6122.500000] [<c0204980>] (io_schedule+0x2c/0x48) from [<c0072064>]
(sync_page+0x44/0x50)
[ 6122.530000] [<c0072064>] (sync_page+0x44/0x50) from [<c0204dd4>]
(__wait_on_bit_lock+0x5c/0xa8)
[ 6122.560000] [<c0204dd4>] (__wait_on_bit_lock+0x5c/0xa8) from
[<c0071ff0>] (__lock_page+0x88/0xa0)
[ 6122.590000] [<c0071ff0>] (__lock_page+0x88/0xa0) from [<c007b530>]
(truncate_inode_pages_range+0x2e4/0x38c)
[ 6122.620000] [<c007b530>] (truncate_inode_pages_range+0x2e4/0x38c)
from [<c007b5f0>] (truncate_inode_pages+0x18/0x20)
[ 6122.640000] [<c007b5f0>] (truncate_inode_pages+0x18/0x20) from
[<c0085acc>] (vmtruncate+0xe4/0x14c)
[ 6122.670000] [<c0085acc>] (vmtruncate+0xe4/0x14c) from [<c00a43a8>]
(inode_setattr+0x48/0x148)
[ 6122.700000] [<c00a43a8>] (inode_setattr+0x48/0x148) from
[<c00a4630>] (notify_change+0x188/0x1dc)
[ 6122.730000] [<c00a4630>] (notify_change+0x188/0x1dc) from
[<c0091440>] (do_truncate+0x6c/0x88)
[ 6122.760000] [<c0091440>] (do_truncate+0x6c/0x88) from [<c00915c0>]
(do_sys_ftruncate+0x164/0x170)
[ 6122.800000] [<c00915c0>] (do_sys_ftruncate+0x164/0x170) from
[<c00915e0>] (sys_ftruncate64+0x14/0x1c)
[ 6122.830000] [<c00915e0>] (sys_ftruncate64+0x14/0x1c) from
[<c0027fa0>] (ret_fast_syscall+0x0/0x2c)

After this samba daemon hangs in the D state. I changed the values of
/proc/sys/vm/dirty_writeback_centisecs to 250 (default 500) and
/proc/sys/vm/dirty_expire_centisecs to 1000 (default 3000). But this
only delays the problem. ps-ax shows smbd in D state. This problem
seems to occur only during samba read.

Can someone please provide me a solution for the above problem?

regards,
vijai

--
The prizes in life u fail to win only if u doubt the power within
