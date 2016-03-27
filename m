From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS hang
Date: Sun, 27 Mar 2016 05:03:44 +0300
Message-ID: <CAOE4rSzGegs_ttUsNcd7KPPRcpeZLPCBPMYO9hjuZ2FA+AQUEg@mail.gmail.com>
References: <CAOE4rSwtpUqzLUkUytNBJgTfe5kSKqZeKFgrhAP_TD4ms3wyVA@mail.gmail.com>
	<CAH2r5mshFG2FGaRhXnQ4nVKGd_V+1-eQj1K1JPMBBptdvOJL1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mshFG2FGaRhXnQ4nVKGd_V+1-eQj1K1JPMBBptdvOJL1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2016-03-27 4:30 GMT+03:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> It sounds like you have three machine scenario involving Windows, cifs
> client and Samba server.  Can you describe who is the client to what
> and what the relationship is between Samba server and Windows in your
> scenario.
>
> Are you using default mount options?
>

There's 2 machines, Windows 10 (192.168.1.2 and 192.168.1.3
it have 2 Ethernet ports) with share Data$
And Arch Linux which mounts that share and who also have nmbd,
winbindd and smbd running with several shares

[global]
        server string = Server
        workgroup = WORK
        domain master = Yes
        preferred master = Yes
        log file = /var/log/samba/%m.log
        max log size = 2000
        printcap name = /etc/printcap
        name resolve order = host lmhosts wins bcast
        time server = Yes
        unix extensions = No
        security = USER
        dns proxy = No
        idmap config * : backend = tdb
        store dos attributes = Yes
        map acl inherit = Yes
        hosts allow = 192.168.0. 192.168.1. 127.
        inherit acls = Yes
        inherit permissions = Yes
        vfs objects = streams_xattr

[Share$]
        comment = Share
        path = /mnt/Share
        wide links = Yes
        create mask = 0760
        directory mask = 0750
        read only = No
        valid users = @Share

and so on similar shares.

In Windows 10 then these shares are mapped as drive letters.
So basically both PCs does access and use each other shares in same
time.
There actually are other Windows machines too which also use
these shares and that Windows 10 share but I don't consider them
important for this issue.


Another backtrace is a bit different, but still looks about same:

[47525.047644] INFO: task ls:11662 blocked for more than 120 seconds.
[47525.047649]       Tainted: P           O    4.5.0-ARCH-dirty #1
[47525.047651] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[47525.047653] ls              D ffff8803d0cdb968     0 11662   8840 0x00000004
[47525.047658]  ffff8803d0cdb968 0000000000000000 ffff880612f2d580
ffff88029f8c8000
[47525.047662]  ffff8803d0cdc000 ffff88020d7e9424 ffff88029f8c8000
00000000ffffffff
[47525.047664]  ffff88020d7e9428 ffff8803d0cdb980 ffffffff815947ac
ffff88020d7e9420
[47525.047667] Call Trace:
[47525.047675]  [<ffffffff815947ac>] schedule+0x3c/0x90
[47525.047678]  [<ffffffff81594b85>] schedule_preempt_disabled+0x15/0x20
[47525.047681]  [<ffffffff8159603e>] __mutex_lock_slowpath+0xce/0x140
[47525.047684]  [<ffffffff815960c7>] mutex_lock+0x17/0x30
[47525.047695]  [<ffffffffa144684c>] small_smb2_init+0x18c/0x3f0 [cifs]
[47525.047700]  [<ffffffff811c50ee>] ? kmem_cache_alloc_trace+0x1de/0x200
[47525.047707]  [<ffffffffa14479b9>] SMB2_open+0x79/0x8f0 [cifs]
[47525.047714]  [<ffffffffa1439e56>] ? cifsConvertToUTF16+0x156/0x2f0 [cifs]
[47525.047723]  [<ffffffffa143a0b1>] ? cifs_strndup_to_utf16+0xc1/0x110 [cifs]
[47525.047729]  [<ffffffffa1449ebd>] smb2_open_op_close+0xad/0x1e0 [cifs]
[47525.047732]  [<ffffffff811b9a0c>] ? alloc_pages_current+0x8c/0x110
[47525.047736]  [<ffffffff8116a209>] ? alloc_kmem_pages+0x19/0x90
[47525.047739]  [<ffffffff8118a16e>] ? kmalloc_order_trace+0x2e/0x100
[47525.047746]  [<ffffffffa144a0f5>] smb2_query_path_info+0x85/0x180 [cifs]
[47525.047754]  [<ffffffffa1432f98>] cifs_get_inode_info+0x368/0x660 [cifs]
[47525.047757]  [<ffffffff811f6504>] ? putname+0x54/0x60
[47525.047760]  [<ffffffff811c48be>] ? __kmalloc+0x2e/0x250
[47525.047762]  [<ffffffff811f68e6>] ? filename_lookup+0xc6/0x140
[47525.047770]  [<ffffffffa1429976>] ? build_path_from_dentry+0xb6/0x210 [cifs]
[47525.047777]  [<ffffffffa14299e9>] ? build_path_from_dentry+0x129/0x210 [cifs]
[47525.047785]  [<ffffffffa14349aa>]
cifs_revalidate_dentry_attr+0xda/0xf0 [cifs]
[47525.047793]  [<ffffffffa1434a71>] cifs_getattr+0x51/0x110 [cifs]
[47525.047796]  [<ffffffff811ec2d9>] vfs_getattr_nosec+0x29/0x40
[47525.047798]  [<ffffffff811ec4f6>] vfs_getattr+0x26/0x30
[47525.047801]  [<ffffffff811ec5d8>] vfs_fstatat+0x78/0xc0
[47525.047804]  [<ffffffff811ecb26>] SyS_newlstat+0x36/0x70
[47525.047807]  [<ffffffff811f120e>] ? path_put+0x1e/0x30
[47525.047809]  [<ffffffff8120bd41>] ? path_getxattr+0x71/0xb0
[47525.047813]  [<ffffffff8159832e>] entry_SYSCALL_64_fastpath+0x12/0x6d
