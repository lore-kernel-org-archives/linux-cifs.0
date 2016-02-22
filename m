From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS hang
Date: Sun, 21 Feb 2016 22:36:47 -0600
Message-ID: <CADT32eLCELt9gO_6jW5iB+uTZZdCjULa=5BPsOx3OVZTZjDz9g@mail.gmail.com>
References: <56C9EF36.7010301@gmx.net>
	<56CA0ADB.5070303@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Markus Greger <Markus.Greger-hi6Y0CQ0nG0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56CA0ADB.5070303-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There may be some kind of deadlock, that is why soft mount option is
not responding,
otherwise you would seen something like "host is down"
All of the shares show DISCONNECTED in file DebugData.
Can you use crash utility and see the stack trace of the ls command that hangs?
What if you mounted from just one share/server (1.1.1.22 e.g.), do you
see the same problem?


On Sun, Feb 21, 2016 at 1:07 PM, Markus Greger <Markus.Greger-hi6Y0CQ0nG0@public.gmane.org> wrote:
> Hi,
>
> I've mounted two nas boxes via cifs on a 3.18.25 kernel client. After
> some time these get unavailable from the client and this impacts the
> system greatly (for example dialogs to save files hang as well). The
> hang is not limited to 60s or 300s but seems to hang infinitely (already
>> 100 minutes).
>
> Here is some more information I can provide:
>
>   * mount options
>
>     noauto,user,soft,iocharset=utf8,cache=none,username=Name,sec=ntlmv2
>
>   * ps for hanging process
>
>     ps -lp 20510
>     F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
>     0 D     0 20510 20386  0  80   0 -  4936 cifs_r pts/7    00:00:00 ls
>
>   * cat /proc/fs/cifs/DebugData
>
>     cat  /proc/fs/cifs/DebugData
>     Display Internal CIFS Data Structures for Debugging
>     ---------------------------------------------------
>     CIFS Version 2.05
>     Features: dfs lanman posix spnego xattr acl
>     Active VFS Requests: 4
>     Servers:
>     1) Name: 1.1.1.22  Domain: STORM Uses: 1 OS: Unix
>             NOS: Samba 3.0.32       Capability: 0x80f3fd
>             SMB session status: 1   TCP status: 4
>             Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0 In
>     Send: 0 In MaxReq Wait: 0
>             Shares:
>             1) \\nas-box2\share Mounts: 1 Type: NTFS DevInfo: 0x0
>     Attributes: 0x2f
>             PathComponentMax: 255 Status: 1 type: 0         DISCONNECTED
>
>             MIDs:
>
>     2) Name: 1.1.1.120  Domain: STORM Uses: 2 OS: Unix
>             NOS: Samba 4.1.18-3.33.2-3407-SUSE-oS13.1-x86_64
>     Capability: 0x80f3fd
>             SMB session status: 1   TCP status: 1
>             Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0 In
>     Send: 0 In MaxReq Wait: 0
>             Shares:
>             1) \\server\share1 Mounts: 1 Type: NTFS DevInfo: 0x20
>     Attributes: 0x1002f
>             PathComponentMax: 255 Status: 1 type: DISK      DISCONNECTED
>
>             2) \\server\share2 Mounts: 1 Type: NTFS DevInfo: 0x20
>     Attributes: 0x1002f
>             PathComponentMax: 255 Status: 1 type: DISK
>
>             MIDs:
>
>     3) Name: 1.1.1.25  Domain: STORM Uses: 3 OS: Unix
>             NOS: Samba 3.0.32       Capability: 0x80f3fd
>             SMB session status: 1   TCP status: 3
>             Local Users To Server: 1 SecMode: 0x3 Req On Wire: 1 In
>     Send: 0 In MaxReq Wait: 0
>             Shares:
>             1) \\nas-box1\share1 Mounts: 1 Type: NTFS DevInfo: 0x0
>     Attributes: 0x2f
>             PathComponentMax: 255 Status: 1 type: 0         DISCONNECTED
>
>             2) \\nas-box1\share2 Mounts: 1 Type: NTFS DevInfo: 0x0
>     Attributes: 0x2f
>             PathComponentMax: 255 Status: 1 type: 0         DISCONNECTED
>
>             3) \\nas-box1\share3 Mounts: 1 Type: NTFS DevInfo: 0x0
>     Attributes: 0x2f
>             PathComponentMax: 255 Status: 1 type: 0         DISCONNECTED
>
>             MIDs:
>
>   * messages
>
>     2016-02-21T16:49:21.432423+01:00 client kernel: [549835.920336]
>     INFO: task ls:20510 blocked for more than 10 seconds.
>     2016-02-21T16:49:21.432424+01:00 client kernel:
>     [549835.920337]       Tainted: G        W      3.18.25-desktop #4
>     2016-02-21T16:49:21.432425+01:00 client kernel: [549835.920338]
>     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
>     message.
>     2016-02-21T16:49:21.432426+01:00 client kernel: [549835.920340]
>     ls              D ffff8801bfc12f00     0 20510  20386 0x00000000
>     2016-02-21T16:49:21.432427+01:00 client kernel: [549835.920342]
>     ffff88012f48fa98 0000000000000086 ffff8801b4f24150 ffff88012f48ffd8
>     2016-02-21T16:49:21.432428+01:00 client kernel: [549835.920344]
>     0000000000012f00 0000000000012f00 ffff88015ced2710 ffff8801b4f24150
>     2016-02-21T16:49:21.432429+01:00 client kernel: [549835.920346]
>     0000000000000000 ffff88005d65ca20 ffff88005d65ca24 ffff8801b4f24150
>     2016-02-21T16:49:21.432430+01:00 client kernel: [549835.920349] Call
>     Trace:
>     2016-02-21T16:49:21.432431+01:00 client kernel: [549835.920352]
>     [<ffffffff816ae43c>] schedule_preempt_disabled+0x2c/0x80
>     2016-02-21T16:49:21.432433+01:00 client kernel: [549835.920355]
>     [<ffffffff816afd55>] __mutex_lock_slowpath+0xc5/0x130
>     2016-02-21T16:49:21.432434+01:00 client kernel: [549835.920357]
>     [<ffffffff816afdd6>] mutex_lock+0x16/0x2a
>     2016-02-21T16:49:21.432435+01:00 client kernel: [549835.920362]
>     [<ffffffffc0cb3feb>] cifs_reconnect_tcon+0x15b/0x2e0 [cifs]
>     2016-02-21T16:49:21.432436+01:00 client kernel: [549835.920366]
>     [<ffffffff81093f45>] ? set_next_entity+0x95/0xb0
>     2016-02-21T16:49:21.432437+01:00 client kernel: [549835.920370]
>     [<ffffffffc0cb4219>] smb_init+0x29/0x50 [cifs]
>     2016-02-21T16:49:21.432438+01:00 client kernel: [549835.920375]
>     [<ffffffffc0cba50a>] CIFSSMBUnixQPathInfo+0x6a/0x2b0 [cifs]
>     2016-02-21T16:49:21.432439+01:00 client kernel: [549835.920382]
>     [<ffffffffc0ccfe47>] cifs_get_inode_info_unix+0x77/0x1c0 [cifs]
>     2016-02-21T16:49:21.432440+01:00 client kernel: [549835.920385]
>     [<ffffffff811b52f6>] ? path_lookupat+0x66/0x740
>     2016-02-21T16:49:21.432441+01:00 client kernel: [549835.920391]
>     [<ffffffffc0cc53e1>] ? build_path_from_dentry+0xb1/0x2b0 [cifs]
>     2016-02-21T16:49:21.432442+01:00 client kernel: [549835.920397]
>     [<ffffffffc0cc5473>] ? build_path_from_dentry+0x143/0x2b0 [cifs]
>     2016-02-21T16:49:21.432443+01:00 client kernel: [549835.920404]
>     [<ffffffffc0cd21c8>] cifs_revalidate_dentry_attr+0xa8/0x1a0 [cifs]
>     2016-02-21T16:49:21.432444+01:00 client kernel: [549835.920411]
>     [<ffffffffc0cd2372>] cifs_getattr+0x52/0x130 [cifs]
>     2016-02-21T16:49:21.432445+01:00 client kernel: [549835.920414]
>     [<ffffffff810586ac>] ? __do_page_fault+0x22c/0x580
>     2016-02-21T16:49:21.432446+01:00 client kernel: [549835.920416]
>     [<ffffffff811ad5b7>] vfs_getattr_nosec+0x27/0x40
>     2016-02-21T16:49:21.432447+01:00 client kernel: [549835.920419]
>     [<ffffffff811ad668>] vfs_getattr+0x28/0x30
>     2016-02-21T16:49:21.432448+01:00 client kernel: [549835.920421]
>     [<ffffffff811ad72d>] vfs_fstatat+0x5d/0xa0
>     2016-02-21T16:49:21.432449+01:00 client kernel: [549835.920424]
>     [<ffffffff811adb62>] SYSC_newlstat+0x22/0x40
>     2016-02-21T16:49:21.432450+01:00 client kernel: [549835.920426]
>     [<ffffffff81058a22>] ? do_page_fault+0x22/0x30
>     2016-02-21T16:49:21.432451+01:00 client kernel: [549835.920429]
>     [<ffffffff816b4398>] ? page_fault+0x28/0x30
>     2016-02-21T16:49:21.432452+01:00 client kernel: [549835.920432]
>     [<ffffffff811add69>] SyS_newlstat+0x9/0x10
>     2016-02-21T16:49:21.432453+01:00 client kernel: [549835.920434]
>     [<ffffffff816b234d>] system_call_fastpath+0x16/0x1b
>
>   * wireshark didn't show any traffic from client to nas-box1 - only
>     some membership broadcasts, name queries and other broadcast
>     messages. Specifically there was no SMB (ECHO) message from the
>     client to the nas-box1.
>
> My questions are:
>
>   * Why did the "soft" option not result in my processes (like ls)
>     returning errors? (strace on ls showed nothing at all, kill -9 won't
>     work)
>   * What could cause this state?
>     I've got the feeling dns sometimes "forgets" about these boxes, at
>     least nslookup won't return any ip. The boxes are ok however and can
>     be pinged successfully, too.
>   * Is it possible to reactivate these "dead" connections, or do I have
>     to umount them (e.g. via umount -a -f -t cifs) and then remount?
>
> Thanks,
>
> Markus
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
