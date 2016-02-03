From: Martin Decker <martin.decker-W6hacnnSDYuikuSvNLsyVV6hYfS7NtTn@public.gmane.org>
Subject: Oracle Backups to CIFS failing
Date: Wed, 3 Feb 2016 10:14:54 +0100
Message-ID: <CABKFteJpRBP9Cgf9PFXYiT-h+rhb1pxesOzqXBHGbi=gQJC=9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear List,

we are having problems with Oracle backups to a cifs share on 2 Nodes:

1)

Linux Host: RHEL 5U6, Kernel 2.6.18-238.el5
modinfo cifs

modinfo cifs
filename:       /lib/modules/2.6.18-238.el5/kernel/fs/cifs/cifs.ko
version:        1.60RH
description:    VFS to access servers complying with the SNIA CIFS
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:     9326EB4A9ECCBAE9A62AE8B
depends:
vermagic:       2.6.18-238.el5 SMP mod_unload gcc-4.1
parm:           CIFSMaxBufSize:Network buffer size (not including
header). Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4
Range: 1 to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default:
30 Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server.
Default: 50 Range: 2 to 256 (int)
module_sig:
883f3504de5f29f43e909ab54b946c1123a1f0a09fbdf3d22c0ce64d38a5d1cf3210bdaf264a20a0b4c43be6224ac24697783fb0e98629bab7cd59


/var/log/messages:

Feb  3 01:05:30 myhost kernel:  CIFS VFS: No response to cmd 5 mid 39189
Feb  3 01:05:30 myhost kernel:  CIFS VFS: Send error in Flush = -11
Feb  3 01:05:51 myhost kernel:  CIFS VFS: No response for cmd 50 mid 39195
Feb  3 01:11:39 myhost kernel:  CIFS VFS: No response to cmd 5 mid 59671
Feb  3 01:11:39 myhost kernel:  CIFS VFS: Send error in Flush = -11
Feb  3 01:15:34 myhost kernel:  CIFS VFS: No response to cmd 5 mid 26833
Feb  3 01:15:34 myhost kernel:  CIFS VFS: Send error in Flush = -11
Feb  3 01:15:55 myhost kernel:  CIFS VFS: No response for cmd 50 mid 26839
Feb  3 01:20:19 myhost kernel:  CIFS VFS: No response to cmd 5 mid 59613
Feb  3 01:20:19 myhost kernel:  CIFS VFS: Send error in Flush = -11
Feb  3 01:24:40 myhost kernel:  CIFS VFS: No response to cmd 5 mid 26754
Feb  3 01:24:40 myhost kernel:  CIFS VFS: Send error in Flush = -11
Feb  3 01:25:01 myhost kernel:  CIFS VFS: No response for cmd 50 mid 26760
Feb  3 01:25:22 myhost kernel:  CIFS VFS: No response for cmd 50 mid 26764
Feb  3 01:25:43 myhost kernel:  CIFS VFS: No response for cmd 50 mid 26768
Feb  3 01:25:43 myhost kernel:  CIFS VFS: Unexpected lookup error -112
Feb  3 02:12:27 myhost kernel:  CIFS VFS: No response to cmd 5 mid 64725
Feb  3 02:12:27 myhost kernel:  CIFS VFS: Send error in Flush = -11
Feb  3 08:24:17 myhost kernel:  CIFS VFS: No response for cmd 114 mid 37457
Feb  3 08:41:26 myhost kernel:  CIFS VFS: No response to cmd 5 mid 30290
Feb  3 08:41:26 myhost kernel:  CIFS VFS: Send error in Flush = -11

cat  /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.60RH
Active VFS Requests: 0
Servers:
1) Name: 10.1.1.6  Domain: MYDOM Uses: 1 OS: Windows Server 2012 R2
Standard 9600
        NOS: Windows Server 2012 R2 Standard 6.3        Capability: 0x1e3fc
        SMB session status: 1   TCP status: 1
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
        Shares:
        1) \\10.1.1.6\backup_export Mounts: 1 Type: NTFS DevInfo:
0x20020 Attributes: 0xc700ef
PathComponentMax: 255 Status: 0x1 type: DISK

/etc/fstab:
//10.1.1.6/backup_export /backup_export cifs
username=myuser,password=mypassword$,_netdev,uid=oracle,gid=oinstall 0
0

df -h:

//10.1.1.67/backup_export
                       24T   15T  9.2T  62% /backup_export


2)  On second node , the CIFS share is even hanging:

RHEL 6U6
Kernel:  2.6.32-504.23.4.el6.x86_64
modinfo cifs:

filename:       /lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/cifs/cifs.ko
version:        1.68
description:    VFS to access servers complying with the SNIA CIFS
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:     6A099079DA5C8D2B7A710D3
depends:
vermagic:       2.6.32-504.23.4.el6.x86_64 SMP mod_unload modversions
parm:           CIFSMaxBufSize:Network buffer size (not including
header). Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4
Range: 1 to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default:
30 Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server.
Default: 32767 Range: 2 to 32767. (int)
parm:           enable_oplocks:Enable or disable oplocks (bool).
Default:y/Y/1 (bool)



df -h hangs

In /var/


[root@myhost02 log]# ps -ef |grep cifs
root      9515     2  0  2015 ?        00:00:01 [cifsiod]
root     12818 12398  0 09:46 pts/6    00:00:00 grep cifs
root     22144     2  0 Jan08 ?        03:18:51 [cifsd]
[root@myhost02 log]# cat /proc/22144/stack
[<ffffffff8144c539>] sk_wait_data+0xd9/0xe0
[<ffffffff814a77f7>] tcp_recvmsg+0x347/0x10f0
[<ffffffff814c922a>] inet_recvmsg+0x5a/0x90
[<ffffffff8144a5d3>] sock_recvmsg+0x133/0x160
[<ffffffff8144a644>] kernel_recvmsg+0x44/0x60
[<ffffffffa0378749>] cifs_readv_from_socket+0x1a9/0x260 [cifs]
[<ffffffffa0378827>] cifs_read_from_socket+0x27/0x30 [cifs]
[<ffffffffa0378983>] cifs_demultiplex_thread+0x153/0xe20 [cifs]
[<ffffffff8109e78e>] kthread+0x9e/0xc0
[<ffffffff8100c28a>] child_rip+0xa/0x20
[<ffffffffffffffff>] 0xffffffffffffffff
[root@myhost02 log]# cat /proc/9515/sta
cat: /proc/9515/sta: No such file or directory
[root@myhost02 log]# cat /proc/9515/stack
[<ffffffff8109818c>] worker_thread+0x1fc/0x2a0
[<ffffffff8109e78e>] kthread+0x9e/0xc0
[<ffffffff8100c28a>] child_rip+0xa/0x20
[<ffffffffffffffff>] 0xffffffffffffffff

[root@myhost02 log]# cat  /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 1.68
Active VFS Requests: 10
Servers:
1) Name: 10.1.1.67  Domain: MYDOM Uses: 1 OS: Windows Server 2012 R2
Standard 9600
        NOS: Windows Server 2012 R2 Standard 6.3        Capability: 0x1e3fc
        SMB session status: 1   TCP status: 4
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 1
        Shares:
        1) \\10.1.1.67\backup_export Mounts: 1 Type: NTFS DevInfo:
0x20020 Attributes: 0xc700ef
PathComponentMax: 255 Status: 0x2 type: DISK    DISCONNECTED

        MIDs:
        State: 2 com: 114 pid: 4816 cbdata: ffff880106ab2040 mid 24743

Feb  3 05:46:33 atfkora02 kernel: CIFS VFS: Server 10.10.10.67 has not
responded in 120 seconds. Reconnecting...
Feb  3 05:53:39 atfkora02 kernel: INFO: task bdi-default:69 blocked
for more than 120 seconds.
Feb  3 05:53:39 atfkora02 kernel:      Not tainted 2.6.32-504.23.4.el6.x86_64 #1
Feb  3 05:53:39 atfkora02 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb  3 05:53:39 atfkora02 kernel: bdi-default   D 000000000000000b
0    69      2 0x00000000
Feb  3 05:53:39 atfkora02 kernel: ffff881029bef930 0000000000000046
0000000000000000 0000000700000007
Feb  3 05:53:39 atfkora02 kernel: ffff881000000000 0000000000000400
003841dbe1cae16f 0000000000000000
Feb  3 05:53:39 atfkora02 kernel: 0000000000000007 00000004b02fe0f9
ffff881029be7068 ffff881029beffd8
Feb  3 05:53:39 atfkora02 kernel: Call Trace:
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8152b3a6>]
__mutex_lock_slowpath+0x96/0x210
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81215f39>] ? find_nls+0x59/0x100
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8152aecb>] mutex_lock+0x2b/0x50
Feb  3 05:53:39 atfkora02 kernel: [<ffffffffa03664b2>]
cifs_reconnect_tcon+0x152/0x320 [cifs]
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81064c35>] ?
wake_up_process+0x15/0x20
Feb  3 05:53:39 atfkora02 kernel: [<ffffffffa0366837>]
small_smb_init+0x37/0x90 [cifs]
Feb  3 05:53:39 atfkora02 kernel: [<ffffffffa0370e7c>]
cifs_async_writev+0x7c/0x280 [cifs]
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81139cd9>] ?
test_set_page_writeback+0xe9/0x1a0
Feb  3 05:53:39 atfkora02 kernel: [<ffffffffa037ef9f>]
cifs_writepages+0x43f/0x700 [cifs]
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8105ca84>] ?
find_busiest_group+0x244/0x9e0
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81139871>] do_writepages+0x21/0x40
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff811bafbd>]
writeback_single_inode+0xdd/0x290
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff811bb3bd>]
writeback_sb_inodes+0xbd/0x170
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff811bb51b>]
writeback_inodes_wb+0xab/0x1b0
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff811bb913>] wb_writeback+0x2f3/0x410
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81529a1e>] ?
thread_return+0x4e/0x7d0
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff811bbbd5>]
wb_do_writeback+0x1a5/0x240
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81087540>] ?
process_timeout+0x0/0x10
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff811482da>]
bdi_forker_task+0x6a/0x310
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81148270>] ?
bdi_forker_task+0x0/0x310
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8109e78e>] kthread+0x9e/0xc0
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8100c28a>] child_rip+0xa/0x20
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8109e6f0>] ? kthread+0x0/0xc0
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8100c280>] ? child_rip+0x0/0x20
Feb  3 05:53:39 atfkora02 kernel: INFO: task kslowd002:4819 blocked
for more than 120 seconds.
Feb  3 05:53:39 atfkora02 kernel:      Not tainted 2.6.32-504.23.4.el6.x86_64 #1
Feb  3 05:53:39 atfkora02 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb  3 05:53:39 atfkora02 kernel: kslowd002     D 0000000000000007
0  4819      2 0x00000080
Feb  3 05:53:39 atfkora02 kernel: ffff8801100f3bf0 0000000000000046
0000000000000000 0000000000000286
Feb  3 05:53:39 atfkora02 kernel: ffff8801100f3b70 ffffffff8108742c
003841deeab11af3 00000000ffffffff
Feb  3 05:53:39 atfkora02 kernel: ffff882029f1c000 00000004b03013f5
ffff88102584f068 ffff8801100f3fd8
Feb  3 05:53:39 atfkora02 kernel: Call Trace:
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8108742c>] ?
lock_timer_base+0x3c/0x70
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8152b3a6>]
__mutex_lock_slowpath+0x96/0x210
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81215f39>] ? find_nls+0x59/0x100
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8152aecb>] mutex_lock+0x2b/0x50
Feb  3 05:53:39 atfkora02 kernel: [<ffffffffa03664b2>]
cifs_reconnect_tcon+0x152/0x320 [cifs]
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8109ec20>] ?
autoremove_wake_function+0x0/0x40
Feb  3 05:53:39 atfkora02 kernel: [<ffffffffa0366837>]
small_smb_init+0x37/0x90 [cifs]
Feb  3 05:53:39 atfkora02 kernel: [<ffffffffa0370e7c>]
cifs_async_writev+0x7c/0x280 [cifs]
Feb  3 05:53:39 atfkora02 kernel: [<ffffffffa0371208>]
cifs_writev_complete+0x188/0x270 [cifs]
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff811180f3>]
slow_work_execute+0x233/0x310
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff81118327>]
slow_work_thread+0x157/0x360
Feb  3 05:53:39 atfkora02 kernel: [<ffffffff8109ec20>] ?
autoremove_wake_function+0x0/0x40



Questions:
1) These might be two independent problems. What additional
information do I have to gather to find the root cause?
2) How can I fix the hanging CIFS mount without bouncing the linux
node? umount -f does not work - says "Device or resource busy".
3) Are there any recommendations on how to set up a big CIFS share for
backups from different Linux Nodes? (Directory-structure, etc.)

Thank you in advance,
Martin




-- 
--



Martin Decker
