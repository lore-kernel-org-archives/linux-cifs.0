From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 14 Mar 2012 20:30:53 +0000
Message-ID: <1331757053.3054.5.camel@localhost>
References: <4F5A2CCD.6010808@gmail.com>
	 <24dc471d-42ca-45cf-89eb-26dc3117fa1a@zmail17.collab.prod.int.phx2.redhat.com>
	 <20120314151811.65838f6b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120314151811.65838f6b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2012-03-14 at 15:18 -0400, Jeff Layton wrote:
> On Wed, 14 Mar 2012 14:17:26 -0400 (EDT)
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Thanks Scott,
> > 
> > Steve/Jeff, can I get your comments on this patch please.
> > 
> > Sachin Prabhu
> > 
> 
> Does it address the oops that we saw with Scott's patch? Here's what I
> wrote when I hit that oops before.
> 

Jeff, 

The patch here was a complete re-write. I have tested it with similar
mount options on my local system and it didn't crash.

Sachin Prabhu


> ----------------------------[snip]---------------------------
> 
> Finally got around to trying this out and I get the following oops when
> mounting a share with these options:
> 
>     sec=krb5i,multises,noauto
> 
> general protection fault: 0000 [#1] SMP 
> last sysfs file: /sys/devices/virtual/bdi/cifs-1/uevent
> CPU 0 
> Modules linked in: cifs nfsd lockd nfs_acl exportfs rpcsec_gss_krb5 auth_rpcgss des_generic sunrpc ipv6 microcode i2c_piix4 i2c_core virtio_net joydev virtio_balloon virtio_blk virtio_pci virtio_ring virtio [last unloaded: mperf]
> 
> Pid: 1542, comm: mount.cifs Not tainted 2.6.35-0.2.rc3.git0.fc14.x86_64 #1 /
> RIP: 0010:[<ffffffff8123728c>]  [<ffffffff8123728c>] strchr+0x14/0x1d
> RSP: 0018:ffff880039a65bd8  EFLAGS: 00010246
> RAX: 7365735f626d735f RBX: 0000000000000000 RCX: ffff88003cb4d041
> RDX: ffff880039a65c6d RSI: 0000000000000025 RDI: 7365735f626d735f
> RBP: ffff880039a65bd8 R08: 000000000000002c R09: 000000000000002c
> R10: 00000000000080d0 R11: ffffffff8113bc6c R12: ffff88003cb4d041
> R13: ffffffffa0219d40 R14: 0000000000000000 R15: 7365735f626d735f
> FS:  00007f1fbcba6720(0000) GS:ffff880004600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000001a31818 CR3: 000000003a287000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount.cifs (pid: 1542, threadinfo ffff880039a64000, task ffff880039adc8a0)
> Stack:
>  ffff880039a65c48 ffffffff8123b1ee ffff88003a18b990 ffff880039a65cd8
> <0> ffff88003cb4d041 ffffffff8111cd42 ffffffffa0202f86 7365735f626d735f
> <0> ffff88003997de30 ffff88003997de30 ffff88003cc94840 00000000ffffffff
> Call Trace:
>  [<ffffffff8123b1ee>] match_token+0x4b/0x1a8
>  [<ffffffff8111cd42>] ? __kmalloc+0x17c/0x18e
>  [<ffffffffa0202f86>] ? cifs_mount+0x639/0x1737 [cifs]
>  [<ffffffffa0202c11>] cifs_mount+0x2c4/0x1737 [cifs]
>  [<ffffffffa01f5aa4>] ? cifs_get_sb+0x110/0x2e4 [cifs]
>  [<ffffffffa01f5b00>] cifs_get_sb+0x16c/0x2e4 [cifs]
>  [<ffffffff8112c946>] vfs_kern_mount+0xbd/0x19b
>  [<ffffffff8112ca8c>] do_kern_mount+0x4d/0xed
>  [<ffffffff8114368a>] do_mount+0x776/0x7ed
>  [<ffffffff811128aa>] ? alloc_pages_current+0xa7/0xca
>  [<ffffffff81143789>] sys_mount+0x88/0xc2
>  [<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
> Code: 14 84 c0 74 0e 48 ff c7 48 ff c6 48 ff ca 48 85 d2 75 e1 31 c0 c9 c3 55 48 89 f8 48 89 e5 eb 0b 84 d2 75 04 31 c0 eb 0a 48 ff c0 <8a> 10 40 38 f2 75 ee c9 c3 55 48 89 f8 48 89 e5 eb 03 48 ff c0 
> RIP  [<ffffffff8123728c>] strchr+0x14/0x1d
>  RSP <ffff880039a65bd8>
> ---[ end trace 50d173d44b64b1d9 ]---
> 
> It's crashing in this match_token() call:
> 
> gdb) list *(cifs_mount+0x2c4)
> 0xdcf7 is in cifs_mount (fs/cifs/connect.c:1094).
> 1089		while ((data = strsep(&options, separator)) != NULL) {
> 1090			if (!*data)
> 1091				continue;
> 1092			if ((value = strchr(data, '=')) != NULL)
> 1093				*value++ = '\0';
> 1094			switch (match_token(data, cifs_mount_options, args)) {
> 1095			case Opt_user_xattr:
> 1096				vol->no_xattr = 0;
> 1097				break;
> 1098			case Opt_nouser_xattr:
> (gdb) quit
> 
