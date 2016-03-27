From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS hang
Date: Sun, 27 Mar 2016 00:11:23 -0500
Message-ID: <CADT32eLkS7Fr_TtpoPMnUDQpY13aZKpDEDthz3bEtVZZkDXUWA@mail.gmail.com>
References: <CAOE4rSwtpUqzLUkUytNBJgTfe5kSKqZeKFgrhAP_TD4ms3wyVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOE4rSwtpUqzLUkUytNBJgTfe5kSKqZeKFgrhAP_TD4ms3wyVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I think there is a code path in cifs client where two mutexes can be he=
ld.
So the hung process is waiting for the first mutex.
When the smbd is killed, both the process that holds both the mutexes e=
xits
and the hung process grabs that first mutex and eventually exits and th=
us
hang clears.
Would be nice to if we can obtain stack trace of all the current proces=
ses when
a cifs process hangs.


On Sat, Mar 26, 2016 at 8:21 PM, D=C4=81vis Mos=C4=81ns <davispuh@gmail=
=2Ecom> wrote:
> 2016-02-21 21:07:07 GMT+02:00 Markus Greger:
>> Hi,
>>
>> I've mounted two nas boxes via cifs on a 3.18.25 kernel client. Afte=
r
>> some time these get unavailable from the client and this impacts the
>> system greatly (for example dialogs to save files hang as well). The
>> hang is not limited to 60s or 300s but seems to hang infinitely (alr=
eady
>>> 100 minutes).
>
> I'm also getting CIFS hung, but on Arch Linux with 4.5.0 kernel and
> cifs-utils 6.4
>
> I'm mounting \\192.168.1.2\Data$ (which is a share on Windows 10) on
> /mnt/Data with options
>
> credentials=3D/etc/samba/credentials,iocharset=3Dutf8,vers=3D3.0,uid=3D=
user,gid=3Dgroup,file_mode=3D0770,dir_mode=3D0770,noauto
>
> $ cat /proc/fs/cifs/DebugData
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 2.08
> Features: dfs fscache lanman posix spnego xattr acl
> Active VFS Requests: 0
> Servers:
> 1) entry for 192.168.1.2 not fully displayed
>         TCP status: 1
>         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
>         Shares:
>         1) \\192.168.1.2\Data$ Mounts: 1 DevInfo: 0x60020 Attributes:=
 0xc700ff
>         PathComponentMax: 255 Status: 1 type: DISK
>         Share Capabilities: None Aligned, Partition Aligned,    Share
> Flags: 0x0        Optimal sector size: 0x1000
>         MIDs:
>
> when executing (or any application which tries to access /mnt)
>
> $ ls /mnt
>
> hungs and can't be stopped even with ^C
>
> [47525.047817] INFO: task ls:11878 blocked for more than 120 seconds.
> [47525.047819]       Tainted: P           O    4.5.0-ARCH-dirty #1
> [47525.047820] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [47525.047822] ls              D ffff88029477f968     0 11878      1 =
0x00000004
> [47525.047825]  ffff88029477f968 0000000000000000 ffff880386e8aac0
> ffff88029f8cc740
> [47525.047828]  ffff880294780000 ffff88020d7e9424 ffff88029f8cc740
> 00000000ffffffff
> [47525.047831]  ffff88020d7e9428 ffff88029477f980 ffffffff815947ac
> ffff88020d7e9420
> [47525.047834] Call Trace:
> [47525.047837]  [<ffffffff815947ac>] schedule+0x3c/0x90
> [47525.047840]  [<ffffffff81594b85>] schedule_preempt_disabled+0x15/0=
x20
> [47525.047842]  [<ffffffff8159603e>] __mutex_lock_slowpath+0xce/0x140
> [47525.047845]  [<ffffffff815960c7>] mutex_lock+0x17/0x30
> [47525.047852]  [<ffffffffa144684c>] small_smb2_init+0x18c/0x3f0 [cif=
s]
> [47525.047855]  [<ffffffff811c50ee>] ? kmem_cache_alloc_trace+0x1de/0=
x200
> [47525.047862]  [<ffffffffa14479b9>] SMB2_open+0x79/0x8f0 [cifs]
> [47525.047870]  [<ffffffffa1439e56>] ? cifsConvertToUTF16+0x156/0x2f0=
 [cifs]
> [47525.047878]  [<ffffffffa143a0b1>] ? cifs_strndup_to_utf16+0xc1/0x1=
10 [cifs]
> [47525.047884]  [<ffffffffa1449ebd>] smb2_open_op_close+0xad/0x1e0 [c=
ifs]
> [47525.047887]  [<ffffffff811b9a0c>] ? alloc_pages_current+0x8c/0x110
> [47525.047890]  [<ffffffff8116a209>] ? alloc_kmem_pages+0x19/0x90
> [47525.047893]  [<ffffffff8118a16e>] ? kmalloc_order_trace+0x2e/0x100
> [47525.047899]  [<ffffffffa144a0f5>] smb2_query_path_info+0x85/0x180 =
[cifs]
> [47525.047907]  [<ffffffffa1432f98>] cifs_get_inode_info+0x368/0x660 =
[cifs]
> [47525.047910]  [<ffffffff811f6504>] ? putname+0x54/0x60
> [47525.047913]  [<ffffffff811c48be>] ? __kmalloc+0x2e/0x250
> [47525.047915]  [<ffffffff811f68e6>] ? filename_lookup+0xc6/0x140
> [47525.047923]  [<ffffffffa1429976>] ? build_path_from_dentry+0xb6/0x=
210 [cifs]
> [47525.047930]  [<ffffffffa14299e9>] ? build_path_from_dentry+0x129/0=
x210 [cifs]
> [47525.047938]  [<ffffffffa14349aa>]
> cifs_revalidate_dentry_attr+0xda/0xf0 [cifs]
> [47525.047945]  [<ffffffffa1434a71>] cifs_getattr+0x51/0x110 [cifs]
> [47525.047948]  [<ffffffff811ec2d9>] vfs_getattr_nosec+0x29/0x40
> [47525.047951]  [<ffffffff811ec4f6>] vfs_getattr+0x26/0x30
> [47525.047953]  [<ffffffff811ec5d8>] vfs_fstatat+0x78/0xc0
> [47525.047956]  [<ffffffff811ecb26>] SyS_newlstat+0x36/0x70
> [47525.047959]  [<ffffffff8159832e>] entry_SYSCALL_64_fastpath+0x12/0=
x6d
>
> Note that this happens only sometimes and seems it's related to Samba
> because as soon as I stop smbd then it unhungs and I get message abou=
t host
> down but then when I try "ls" again it works and successfully shows s=
hare's
> files/folders.
>
> Also I don't know who hangs first, but in same time Windows 10 is als=
o basically
> unusable because a lot of things/processes hangs/crashes/stop working=
 like
> explorer.exe, task manger, PowerShell and all other which try to acce=
ss this
> Arch Linux shares. But that happens only when shares are accessed by =
computer
> name and when IP address is used directly then it works fine. Also as=
 soon as I
> stop smbd then Windows starts to respond again and everything works. =
And then
> after starting smbd again all shares start to working. But one day th=
at didn't
> solved it and even after smbd restart Windows explorer still hung whe=
n tried to
> access Arch Linux shares by computer name and only rebooting Linux fi=
xed it.
>
> It really happens randomly and not often so I've no idea what causes =
it
> and I don't know what/who hangs who.
> But I see some possible bugs here, CIFS shouldn't hang even if
> remote host isn't responding/have hung and same for Windows it should=
n't
> wait forever on shares as it freezes basically all applications which=
 are
> accessing them. Also there might be some Samba bug too...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
