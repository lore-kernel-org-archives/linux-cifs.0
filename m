From: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: CIFS with multiple inodes referring to the same
	server object? [was Re: BUG while pushing to git on cached CIFS]
Date: Wed, 21 Jan 2015 17:12:31 +0100
Message-ID: <3347573.OiZUvS0ZM7@ws-stein>
References: <12583715.TUUIvBHKl1@ws-stein>
	<6055.1421852678@warthog.procyon.org.uk>
	<CAH2r5mvj2rPsDaMMNxZ+Va9ZQ_9gJnQA27u3duMZD+_OH27P0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, linux-cachefs@redhat.com
To: Steve French <smfrench@gmail.com>
Return-path: <linux-cachefs-bounces@redhat.com>
In-Reply-To: <CAH2r5mvj2rPsDaMMNxZ+Va9ZQ_9gJnQA27u3duMZD+_OH27P0Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-cachefs>
List-Post: <mailto:linux-cachefs@redhat.com>
List-Help: <mailto:linux-cachefs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=subscribe>
Sender: linux-cachefs-bounces@redhat.com
Errors-To: linux-cachefs-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

On Wednesday 21 January 2015 09:07:35, Steve French wrote:
> Do you know if it is reproducible?

Well, it was. As I had to move on, I disabled fscache for now so I guess 
Here are some other logs/backtraces:
CacheFiles: 
CacheFiles: Error: Unexpected object collision
CacheFiles: object: OBJ304
CacheFiles: objstate=LOOK_UP_OBJECT fl=8 wbusy=2 ev=0[0]
CacheFiles: ops=0 inp=0 exc=0
CacheFiles: parent=ffff880006b03b80
CacheFiles: cookie=ffff88007f8f33c0 [pr=ffff8802036b9140 nd=ffff8801685f6d00 fl=27]
CacheFiles: key=[8] '1ea0080501090000'
CacheFiles: xobject: OBJ302
CacheFiles: xobjstate=WAIT_FOR_CMD fl=38 wbusy=0 ev=0[6d]
CacheFiles: xops=0 inp=0 exc=0
CacheFiles: xparent=ffff880006b03b80
CacheFiles: xcookie=ffff88007f8f3370 [pr=ffff8802036b9140 nd=ffff8801685f4870 fl=22]
CacheFiles: xkey=[8] '1ea0080501090000'

>From another boot (I kept the times as it seems here were 2 problems):
Jan 14 18:05:20 ws-stein kernel: kernel BUG at fs/fscache/internal.h:317!
Jan 14 18:05:20 ws-stein kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Jan 14 18:05:20 ws-stein kernel: Modules linked in: fuse nls_iso8859_1 nls_cp437 vfat fat udf crc_itu_t binfmt_misc isofs loop ftdi_sio arc4 ecb md4 hmac can_raw can nfsd auth_rpcgss oid_registry nfs_acl lockd gra
Jan 14 18:05:20 ws-stein kernel:  vboxdrv(O) microcode cifs
Jan 14 18:05:20 ws-stein kernel: CPU: 1 PID: 8278 Comm: kworker/u16:0 Tainted: G        W  O   3.18.0-gentoo #3
Jan 14 18:05:20 ws-stein kernel: Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z77-D3H, BIOS F18 08/21/2012
Jan 14 18:05:20 ws-stein kernel: Workqueue: fscache_object fscache_object_work_func
Jan 14 18:05:20 ws-stein kernel: task: ffff88015df5c900 ti: ffff880138390000 task.ti: ffff880138390000
Jan 14 18:05:20 ws-stein kernel: RIP: 0010:[<ffffffff881c3d4a>]  [<ffffffff881c3d4a>] fscache_object_destroy+0x3a/0x40
Jan 14 18:05:20 ws-stein kernel: RSP: 0018:ffff880138393de8  EFLAGS: 00010246
Jan 14 18:05:20 ws-stein kernel: RAX: 0000000000000000 RBX: ffff88020f55b2c0 RCX: 000000030d210a0a
Jan 14 18:05:20 ws-stein kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801c99198c0
Jan 14 18:05:20 ws-stein kernel: RBP: ffff88014acf2600 R08: 0000000000000000 R09: ffffffff8862f2c0
Jan 14 18:05:20 ws-stein kernel: R10: 0000000000000004 R11: 0000000000000005 R12: ffff880216011000
Jan 14 18:05:20 ws-stein kernel: R13: ffff880214d01100 R14: 0000000000000000 R15: 0ffff880214d0110
Jan 14 18:05:20 ws-stein kernel: FS:  0000000000000000(0000) GS:ffff88021ec40000(0000) knlGS:0000000000000000
Jan 14 18:05:20 ws-stein kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 14 18:05:20 ws-stein kernel: CR2: 00007ffd0a172058 CR3: 0000000008a11000 CR4: 00000000001407e0
Jan 14 18:05:20 ws-stein kernel: Stack:
Jan 14 18:05:20 ws-stein kernel:  ffff88020f55b2c0 ffffffffc0e9af53 ffff880214d01100 ffff88020f55b350
Jan 14 18:05:20 ws-stein kernel:  ffff8800d09f7540 ffffffff8805cd74 ffff880032a11c10 0000000032a11b50
Jan 14 18:05:20 ws-stein kernel:  0000000000000082 ffff880216011000 ffff8800d09f7570 ffff880216011018
Jan 14 18:05:20 ws-stein kernel: Call Trace:
Jan 14 18:05:20 ws-stein kernel:  [<ffffffffc0e9af53>] ? cachefiles_put_object+0xf3/0x330 [cachefiles]
Jan 14 18:05:20 ws-stein kernel:  [<ffffffff8805cd74>] ? process_one_work+0x134/0x3b0
Jan 14 18:05:20 ws-stein kernel:  [<ffffffff8805d694>] ? worker_thread+0x114/0x470
Jan 14 18:05:20 ws-stein kernel:  [<ffffffff8805d580>] ? cancel_delayed_work_sync+0x10/0x10
Jan 14 18:05:20 ws-stein kernel:  [<ffffffff88061cdc>] ? kthread+0xbc/0xe0
Jan 14 18:05:20 ws-stein kernel:  [<ffffffff88060000>] ? alloc_pid+0x140/0x4a0
Jan 14 18:05:20 ws-stein kernel:  [<ffffffff88061c20>] ? kthread_create_on_node+0x180/0x180
Jan 14 18:05:20 ws-stein kernel:  [<ffffffff884eb82c>] ? ret_from_fork+0x7c/0xb0
Jan 14 18:05:20 ws-stein kernel:  [<ffffffff88061c20>] ? kthread_create_on_node+0x180/0x180
Jan 14 18:05:20 ws-stein kernel: Code: 7e 29 f0 ff 0f 74 12 48 c7 83 80 00 00 00 00 00 00 00 5b c3 0f 1f 44 00 00 e8 83 e7 ff ff 48 c7 83 80 00 00 00 00 00 00 00 5b c3 <0f> 0b 0f 1f 40 00 48 8b 8f 80 00 00 00 48 8
Jan 14 18:05:20 ws-stein kernel: RIP  [<ffffffff881c3d4a>] fscache_object_destroy+0x3a/0x40
Jan 14 18:05:23 ws-stein kernel:  RSP <ffff880138393de8>
Jan 14 18:05:23 ws-stein kernel: ------------[ cut here ]------------
Jan 14 18:05:23 ws-stein kernel: kernel BUG at fs/fscache/cookie.c:633!
Jan 14 18:05:23 ws-stein kernel: ---[ end trace a78b470ffc9c5689 ]---
Jan 14 18:05:23 ws-stein kernel: invalid opcode: 0000 [#2] PREEMPT SMP 
Jan 14 18:05:23 ws-stein kernel: Modules linked in: fuse nls_iso8859_1 nls_cp437 vfat fat udf crc_itu_t binfmt_misc isofs loop ftdi_sio arc4 ecb md4 hmac can_raw can nfsd auth_rpcgss oid_registry nfs_acl lockd gra
Jan 14 18:05:23 ws-stein kernel:  vboxdrv(O) microcode cifs
Jan 14 18:05:23 ws-stein kernel: CPU: 6 PID: 10048 Comm: umount Tainted: G      D W  O   3.18.0-gentoo #3
Jan 14 18:05:23 ws-stein kernel: Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z77-D3H, BIOS F18 08/21/2012
Jan 14 18:05:23 ws-stein kernel: task: ffff880139ee9240 ti: ffff880117e24000 task.ti: ffff880117e24000
Jan 14 18:05:23 ws-stein kernel: RIP: 0010:[<ffffffff881c254b>]  [<ffffffff881c254b>] __fscache_cookie_put+0x8b/0xf0
Jan 14 18:05:23 ws-stein kernel: RSP: 0018:ffff880117e27e38  EFLAGS: 00010286
Jan 14 18:05:23 ws-stein kernel: RAX: 0000000000000000 RBX: ffff88021475a000 RCX: 0000000000000034
Jan 14 18:05:23 ws-stein kernel: RDX: ffff880139ee9240 RSI: ffff8801c9919900 RDI: ffff8801c99198c0
Jan 14 18:05:23 ws-stein kernel: RBP: ffff8801c99198c0 R08: 0000000000200008 R09: ffff88021514db40
Jan 14 18:05:23 ws-stein kernel: R10: 0000000000000006 R11: ffffffffc026eb5e R12: ffff880139ee97f8
Jan 14 18:05:23 ws-stein kernel: R13: ffff880139ee9240 R14: 0000000001c0e2e0 R15: 0000000000000000
Jan 14 18:05:23 ws-stein kernel: FS:  00007f7874152780(0000) GS:ffff88021ed80000(0000) knlGS:0000000000000000
Jan 14 18:05:23 ws-stein kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 14 18:05:23 ws-stein kernel: CR2: 0000000001c15018 CR3: 0000000209fe8000 CR4: 00000000001407e0
Jan 14 18:05:23 ws-stein kernel: Stack:
Jan 14 18:05:23 ws-stein kernel:  ffff8801c99198c0 0000000000000000 ffff8800cc499c08 ffffffff881c2658
Jan 14 18:05:23 ws-stein kernel:  ffff8800cc499c00 ffff8800cc499c08 ffff8802147eec00 ffff8802147eec00
Jan 14 18:05:23 ws-stein kernel:  ffff8800cc499c00 ffffffffc0274b80 ffff8802147eec00 ffffffffc02548ee
Jan 14 18:05:23 ws-stein kernel: Call Trace:
Jan 14 18:05:23 ws-stein kernel:  [<ffffffff881c2658>] ? __fscache_relinquish_cookie+0xa8/0x1f0
Jan 14 18:05:23 ws-stein kernel:  [<ffffffffc0274b80>] ? cifs_fscache_release_client_cookie+0x20/0x60 [cifs]
Jan 14 18:05:23 ws-stein kernel:  [<ffffffffc02548ee>] ? cifs_put_tcp_session+0x8e/0x100 [cifs]
Jan 14 18:05:23 ws-stein kernel:  [<ffffffffc0256712>] ? cifs_put_tlink+0x42/0x50 [cifs]
Jan 14 18:05:23 ws-stein kernel:  [<ffffffffc0258755>] ? cifs_umount+0x55/0xa0 [cifs]
Jan 14 18:05:23 ws-stein kernel:  [<ffffffff8815480f>] ? deactivate_locked_super+0x3f/0x60
Jan 14 18:05:23 ws-stein kernel:  [<ffffffff8816ea36>] ? cleanup_mnt+0x36/0x80
Jan 14 18:05:23 ws-stein kernel:  [<ffffffff880606cc>] ? task_work_run+0xac/0xd0
Jan 14 18:05:23 ws-stein kernel:  [<ffffffff88002ad6>] ? do_notify_resume+0x76/0x80
Jan 14 18:05:23 ws-stein kernel:  [<ffffffff884ebb3f>] ? int_signal+0x12/0x17
Jan 14 18:05:23 ws-stein kernel: Code: 5d 41 5c c3 0f 1f 40 00 8b 05 6a 22 a6 00 48 89 dd eb b5 48 89 ea 4c 89 e6 48 c7 c7 b1 96 7a 88 31 c0 e8 0d 1b 32 00 eb a3 0f 0b <0f> 0b 48 89 f9 48 c7 c2 c0 eb 62 88 31 c0 6
Jan 14 18:05:23 ws-stein kernel: RIP  [<ffffffff881c254b>] __fscache_cookie_put+0x8b/0xf0
Jan 14 18:05:24 ws-stein kernel:  RSP <ffff880117e27e38>

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
Am Windrad 2
08468 Heinsdorfergrund
Tel.: 03765 38600-1156
Fax: 03765 38600-4100
Email: alexander.stein@systec-electronic.com
Website: www.systec-electronic.com
 
Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Chemnitz, HRB 28082
