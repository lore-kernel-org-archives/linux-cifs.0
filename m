From: "Alexander E. Patrakov" <patrakov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: CIFS-related deadlock in 3.10-rc7
Date: Sun, 7 Jul 2013 22:39:11 +0600
Message-ID: <CAN_LGv2zhu3zWd+7Jmi9FZd728W5T5kte2P0FMWABzENmyKJ5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While playing a file from a CIFS-mounted samba share (over wireless,
if that matters), I got this deadlock:

[ 2164.132440] =============================================
[ 2164.132443] [ INFO: possible recursive locking detected ]
[ 2164.132446] 3.10.0-rc7-rafael+ #26 Tainted: G         C
[ 2164.132448] ---------------------------------------------
[ 2164.132452] vlc/2370 is trying to acquire lock:
[ 2164.132454]  (&cifsi->lock_sem){++++.+}, at: [<ffffffffa0913110>]
cifs_reopen_file+0x270/0x5b0 [cifs]
[ 2164.132472]
but task is already holding lock:
[ 2164.132475]  (&cifsi->lock_sem){++++.+}, at: [<ffffffffa0918ca8>]
cifs_strict_readv+0x88/0x160 [cifs]
[ 2164.132488]
other info that might help us debug this:
[ 2164.132491]  Possible unsafe locking scenario:

[ 2164.132494]        CPU0
[ 2164.132496]        ----
[ 2164.132498]   lock(&cifsi->lock_sem);
[ 2164.132502]   lock(&cifsi->lock_sem);
[ 2164.132505]
 *** DEADLOCK ***

[ 2164.132508]  May be due to missing lock nesting notation

[ 2164.132511] 1 lock held by vlc/2370:
[ 2164.132513]  #0:  (&cifsi->lock_sem){++++.+}, at:
[<ffffffffa0918ca8>] cifs_strict_readv+0x88/0x160 [cifs]
[ 2164.132526]
stack backtrace:
[ 2164.132531] CPU: 3 PID: 2370 Comm: vlc Tainted: G         C
3.10.0-rc7-rafael+ #26
[ 2164.132534] Hardware name: Sony Corporation VPCZ23A4R/VAIO, BIOS
R1013H5 05/21/2012
[ 2164.132537]  ffff880235033f80 ffff8802281fb958 ffffffff8165b7ae
ffff8802281fba48
[ 2164.132544]  ffffffff810a0042 ffff8802281fb978 ffffffff826360d0
ffff8802281fb9c8
[ 2164.132550]  0000000000000000 0000000000000000 00000000000389b0
ffff880200000542
[ 2164.132556] Call Trace:
[ 2164.132564]  [<ffffffff8165b7ae>] dump_stack+0x19/0x1b
[ 2164.132569]  [<ffffffff810a0042>] __lock_acquire+0x1522/0x1ee0
[ 2164.132579]  [<ffffffffa091aa41>] ? cifs_get_inode_info+0x181/0x690 [cifs]
[ 2164.132587]  [<ffffffffa0913110>] ? cifs_reopen_file+0x270/0x5b0 [cifs]
[ 2164.132591]  [<ffffffff810a1027>] lock_acquire+0x87/0x150
[ 2164.132598]  [<ffffffffa0913110>] ? cifs_reopen_file+0x270/0x5b0 [cifs]
[ 2164.132604]  [<ffffffff8165ed3f>] down_write+0x3f/0x70
[ 2164.132612]  [<ffffffffa0913110>] ? cifs_reopen_file+0x270/0x5b0 [cifs]
[ 2164.132622]  [<ffffffffa0927a76>] ? cifs_set_fid+0x26/0x40 [cifs]
[ 2164.132632]  [<ffffffffa0913110>] cifs_reopen_file+0x270/0x5b0 [cifs]
[ 2164.132642]  [<ffffffffa0913d0b>] cifs_readpage_worker+0x1ab/0x4e0 [cifs]
[ 2164.132652]  [<ffffffffa091427e>] cifs_readpage+0x5e/0x160 [cifs]
[ 2164.132660]  [<ffffffff81109b87>] generic_file_aio_read+0x217/0x760
[ 2164.132670]  [<ffffffffa0918d51>] cifs_strict_readv+0x131/0x160 [cifs]
[ 2164.132675]  [<ffffffff8116fff5>] do_sync_read+0x75/0xb0
[ 2164.132681]  [<ffffffff81170ef7>] vfs_read+0xa7/0x180
[ 2164.132686]  [<ffffffff81171170>] SyS_read+0x50/0xa0
[ 2164.132691]  [<ffffffff81668e16>] system_call_fastpath+0x1a/0x1f

-- 
Alexander E. Patrakov
