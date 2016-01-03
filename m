From: Adam Baxter <voltagex-PMccDsTWWeRg9hUCZPvPmw@public.gmane.org>
Subject: umount/lsof hangs after network interruption on 4.1.15 kernel
Date: Mon, 4 Jan 2016 00:39:07 +1100
Message-ID: <CAChFQ9QLfx2hCU9MetvC71FXUAeXOj-=pOg0J=9xt+ha9=i7Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all,

This is on a Raspberry Pi 2, but I've seen similar things on other systems.

After what I'm assuming is a network interruption, I can't umount the
affected CIFS filesystem. lsof hangs too.

Linux kiwi.voltagex.org 4.1.15-v7+ #830 SMP Tue Dec 15 17:02:45 GMT
2015 armv7l GNU/Linux

Affected mount looks like

//icarus/_Recovery on /media/recovery type cifs
(rw,relatime,vers=1.0,cache=strict,username=Adam,domain=ICARUS,uid=1000,noforceuid,gid=1000,noforcegid,addr=xxx,file_mode=0755,dir_mode=0755,nounix,serverino,mapposix,rsize=61440,wsize=65536,actimeo=1)


root@kiwi:/home/voltagex# modinfo cifs
filename:       /lib/modules/4.1.15-v7+/kernel/fs/cifs/cifs.ko
version:        2.06
description:    VFS to access servers complying with the SNIA CIFS
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
alias:          fs-cifs
srcversion:     39F72BC9A2112B80DA1BF12
depends:
intree:         Y
vermagic:       4.1.15-v7+ SMP mod_unload modversions ARMv7
parm:           CIFSMaxBufSize:Network buffer size (not including
header). Default: 16384 Range: 8192 to 130048 (uint)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4
Range: 1 to 64 (uint)
parm:           cifs_min_small:Small network buffers in pool. Default:
30 Range: 2 to 256 (uint)
parm:           cifs_max_pending:Simultaneous requests to server.
Default: 32767 Range: 2 to 32767. (uint)
parm:           enable_oplocks:Enable or disable oplocks. Default: y/Y/1 (bool)


[341644.662448] INFO: task lsof:7421 blocked for more than 120 seconds.
[341644.671778]       Not tainted 4.1.15-v7+ #830
[341644.679134] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[341644.692736] lsof            D 80553e00     0  7421      1 0x00000001
[341644.702047] [<80553e00>] (__schedule) from [<805542c8>] (schedule+0x4c/0xa4)
[341644.712057] [<805542c8>] (schedule) from [<805546a0>]
(schedule_preempt_disabled+0x18/0x1c)
[341644.726005] [<805546a0>] (schedule_preempt_disabled) from
[<80555dc8>] (__mutex_lock_slowpath+0xac/0x168)
[341644.741148] [<80555dc8>] (__mutex_lock_slowpath) from [<80555ee8>]
(mutex_lock+0x64/0x68)
[341644.754944] [<80555ee8>] (mutex_lock) from [<7f0a5b54>]
(cifs_reconnect_tcon+0x8c/0x324 [cifs])
[341644.769435] [<7f0a5b54>] (cifs_reconnect_tcon [cifs]) from
[<7f0a5e8c>] (smb_init+0x30/0x78 [cifs])
[341644.784330] [<7f0a5e8c>] (smb_init [cifs]) from [<7f0ab1e0>]
(CIFSSMBQPathInfo+0x58/0x254 [cifs])
[341644.799182] [<7f0ab1e0>] (CIFSSMBQPathInfo [cifs]) from
[<7f0ca334>] (cifs_query_path_info+0x64/0x14c [cifs])
[341644.815112] [<7f0ca334>] (cifs_query_path_info [cifs]) from
[<7f0bdbd4>] (cifs_get_inode_info+0x1b8/0x4b4 [cifs])
[341644.831253] [<7f0bdbd4>] (cifs_get_inode_info [cifs]) from
[<7f0bf30c>] (cifs_revalidate_dentry_attr+0xd8/0xf0 [cifs])
[341644.847921] [<7f0bf30c>] (cifs_revalidate_dentry_attr [cifs]) from
[<7f0bf3e4>] (cifs_getattr+0x60/0x12c [cifs])
[341644.863960] [<7f0bf3e4>] (cifs_getattr [cifs]) from [<801463f0>]
(vfs_getattr_nosec+0x3c/0x50)
[341644.878414] [<801463f0>] (vfs_getattr_nosec) from [<801464e0>]
(vfs_fstatat+0x68/0xa0)
[341644.892268] [<801464e0>] (vfs_fstatat) from [<80146544>]
(vfs_stat+0x2c/0x30)
[341644.902498] [<80146544>] (vfs_stat) from [<80146c84>] (SyS_stat64+0x24/0x40)
[341644.912627] [<80146c84>] (SyS_stat64) from [<8000f780>]
(ret_fast_syscall+0x0/0x54)

I'd really rather not restart the system to fix this, but I can't
really see another way.

Regards,
Adam
