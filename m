From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: kernel BUG at fs/dcache.c:873!
Date: Thu, 23 Feb 2012 09:43:47 -0500
Message-ID: <20120223094347.0d4373cb@tlielax.poochiereds.net>
References: <6152d365-04d3-47af-9fb2-3090f2ab1065@zmail14.collab.prod.int.phx2.redhat.com>
	<cf056d77-710e-4ebe-a328-5ae7522cc50b@zmail14.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: CAI Qian <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cf056d77-710e-4ebe-a328-5ae7522cc50b-GT+QyWMFC29+R5eDjrG6zsCp5Q1pQRjfhaY/URYTgi6ny3qCrzbmXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Feb 2012 03:04:44 -0500 (EST)
CAI Qian <caiqian-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> BUG() at the client side during umount. Easy to reproduce using the following
> program from the client running under the mount point.
> 
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <errno.h>
> #include <unistd.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> 
> int main(void)
> {
>    int fd;
>    char buffer[4096];
>    char *file = "/mnt/MYFIFO";
> 
>    unlink(file);
>    perror("unlink");
>    mknod(file, S_IFIFO|0666, 0);
>    perror("mknod");
>    fd = open(file, O_RDWR|O_CREAT, 0777);
>    perror("open");
>    write(fd, buffer, 4096);
>    perror("write");
> 
>    return 0;
> }
> 
> # ./test
> unlink: Success
> mknod: Success
> open: Success
> write: Invalid argument
> 
> # umount /mnt 
> Segmentation fault
> 
> [  278.108849] fs/cifs/inode.c: Update attributes: /MYFIFO inode 0xffff8801005482e0 count 1 dentry: 0xffff8800ca830c00 d_time 0 jiffies 4294945404
> [  278.108851] fs/cifs/inode.c: Getting info on /MYFIFO
> [  278.108853] fs/cifs/cifssmb.c: In QPathInfo (Unix) the path /MYFIFO
> [  278.108860] fs/cifs/transport.c: For smb_command 50
> [  278.108862] fs/cifs/transport.c: Sending smb:  total_len 92
> [  278.109393] fs/cifs/connect.c: rfc1002 length 0xa4
> [  278.109494] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=21 state=4
> [  278.109500] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 2628394
> [  278.109502] fs/cifs/inode.c: cifs_revalidate_cache: inode 2628394 is unchanged
> [  278.109505] fs/cifs/inode.c: inode 0xffff8801005482e0 old_time=4294942124 new_time=4294945405
> [  278.109508] fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry_attr (xid = 23) rc = 0
> [  278.109592] fs/cifs/inode.c: cifs_unlink, dir=0xffff8800ca834050, dentry=0xffff8800ca830c00
> [  278.109595] fs/cifs/inode.c: CIFS VFS: in cifs_unlink as Xid: 24 with uid: 0
> [  278.109598] fs/cifs/cifssmb.c: In POSIX delete
> [  278.109601] fs/cifs/transport.c: For smb_command 50
> [  278.109603] fs/cifs/transport.c: Sending smb:  total_len 96
> [  278.120706] fs/cifs/connect.c: rfc1002 length 0x3e
> [  278.120784] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=22 state=4
> [  278.120789] fs/cifs/inode.c: posix del rc 0
> [  278.120792] fs/cifs/inode.c: CIFS VFS: leaving cifs_unlink (xid = 24) rc = 0
> [  278.120970] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 25 with uid: 0
> [  278.120972] fs/cifs/dir.c: parent inode = 0xffff8800ca834050 name is: MYFIFO and dentry = 0xffff8800d2d67cc0
> [  278.120975] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 25) rc = 0
> [  278.121175] fs/cifs/dir.c: CIFS VFS: in cifs_mknod as Xid: 26 with uid: 0
> [  278.121177] fs/cifs/cifssmb.c: In SetUID/GID/Mode
> [  278.121182] fs/cifs/transport.c: For smb_command 50
> [  278.121190] fs/cifs/transport.c: Sending smb:  total_len 194
> [  278.122010] fs/cifs/connect.c: rfc1002 length 0x3e
> [  278.122078] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=23 state=4
> [  278.122081] fs/cifs/inode.c: Getting info on /MYFIFO
> [  278.122083] fs/cifs/cifssmb.c: In QPathInfo (Unix) the path /MYFIFO
> [  278.122087] fs/cifs/transport.c: For smb_command 50
> [  278.122089] fs/cifs/transport.c: Sending smb:  total_len 92
> [  278.122601] fs/cifs/connect.c: rfc1002 length 0xa4
> [  278.122654] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=24 state=4
> [  278.122659] fs/cifs/inode.c: looking for uniqueid=2628393
> [  278.122696] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 2628393
> [  278.122697] fs/cifs/inode.c: cifs_revalidate_cache: inode 2628393 is new
> [  278.122699] fs/cifs/inode.c: inode 0xffff88010054c050 old_time=0 new_time=4294945418
> [  278.122702] fs/cifs/dir.c: CIFS VFS: leaving cifs_mknod (xid = 26) rc = 0
> [  278.122782] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 27 with uid: 0
> [  278.122784] fs/cifs/dir.c: parent inode = 0xffff8800ca834050 name is: MYFIFO and dentry = 0xffff8800d2d67cc0
> [  278.122786] fs/cifs/dir.c: NULL inode in lookup
> [  278.122787] fs/cifs/dir.c: Full path: /MYFIFO inode = 0x          (null)
> [  278.122789] fs/cifs/file.c: posix open /MYFIFO
> [  278.122791] fs/cifs/cifssmb.c: In POSIX Create
> [  278.122793] fs/cifs/transport.c: For smb_command 50
> [  278.122794] fs/cifs/transport.c: Sending smb:  total_len 112
> [  278.123351] fs/cifs/connect.c: rfc1002 length 0xb0
> [  278.123432] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=25 state=4
> [  278.123435] fs/cifs/cifssmb.c: copying inode info
> [  278.123437] fs/cifs/inode.c: looking for uniqueid=2628393
> [  278.123439] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 2628393
> [  278.123440] fs/cifs/inode.c: cifs_revalidate_cache: inode 2628393 is unchanged
> [  278.123442] fs/cifs/inode.c: inode 0xffff88010054c050 old_time=4294945418 new_time=4294945419
> [  278.123448] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 27) rc = 0
> [  278.123561] fs/cifs/file.c: closing last open instance for inode ffff880100548d20
> [  278.123564] fs/cifs/file.c: CIFS VFS: in cifsFileInfo_put as Xid: 28 with uid: 0
> [  278.123566] fs/cifs/cifssmb.c: In CIFSSMBClose
> [  278.123568] fs/cifs/transport.c: For smb_command 4
> [  278.123569] fs/cifs/transport.c: Sending smb:  total_len 45
> [  278.124322] fs/cifs/connect.c: rfc1002 length 0x27
> [  278.124354] fs/cifs/transport.c: cifs_sync_mid_result: cmd=4 mid=26 state=4
> [  278.124357] fs/cifs/file.c: CIFS VFS: leaving cifsFileInfo_put (xid = 28) rc = 0
> [  280.658202] fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry_attr as Xid: 29 with uid: 0
> [  280.658208] fs/cifs/inode.c: Update attributes:  inode 0xffff8800ca834050 count 1 dentry: 0xffff8800d2ff0b40 d_time 0 jiffies 4294947954
> [  280.658210] fs/cifs/inode.c: Getting info on 
> [  280.658213] fs/cifs/cifssmb.c: In QPathInfo (Unix) the path 
> [  280.658219] fs/cifs/transport.c: For smb_command 50
> [  280.658221] fs/cifs/transport.c: Sending smb:  total_len 78
> [  280.659131] fs/cifs/connect.c: rfc1002 length 0xa4
> [  280.659151] fs/cifs/transport.c: cifs_sync_mid_result: cmd=50 mid=27 state=4
> [  280.659156] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 2621442
> [  280.659158] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 2621442 mapping
> [  280.659161] fs/cifs/inode.c: inode 0xffff8800ca834050 old_time=0 new_time=4294947955
> [  280.659164] fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry_attr (xid = 29) rc = 0
> [  294.478745] BUG: Dentry ffff8800d2d67cc0{i=281b29,n=MYFIFO} still in use (1) [unmount of cifs cifs]
> [  294.481213] ------------[ cut here ]------------
> [  294.482318] kernel BUG at fs/dcache.c:873!
> [  294.483212] invalid opcode: 0000 [#1] SMP 
> [  294.484290] CPU 1 
> [  294.484444] Modules linked in: des_generic md4 nls_utf8 cifs fscache lockd nf_conntrack_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv4 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm i2c_piix4 i2c_core snd_timer snd soundcore snd_page_alloc joydev microcode virtio_net virtio_balloon uinput sunrpc virtio_blk [last unloaded: scsi_wait_scan]
> [  294.496648] 
> [  294.497454] Pid: 1557, comm: umount Not tainted 3.1.0-7.fc16.x86_64 #1 Bochs Bochs
> [  294.499308] RIP: 0010:[<ffffffff8113a000>]  [<ffffffff8113a000>] shrink_dcache_for_umount_subtree+0x91/0x146
> [  294.501161] RSP: 0018:ffff8800da021dd8  EFLAGS: 00010292
> [  294.502657] RAX: 000000000000006d RBX: ffff8800d2d67cc0 RCX: 000000000000b31c
> [  294.503846] RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000246
> [  294.505036] RBP: ffff8800da021e08 R08: 0000000000000000 R09: 0000000000000000
> [  294.506215] R10: 0000ffff00066c0a R11: 0000000000000000 R12: ffffffffa0158a80
> [  294.507478] R13: ffff880036815f40 R14: ffff880036815f00 R15: 0000000000000000
> [  294.508725] FS:  00007f1a479bf800(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
> [  294.511058] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  294.511945] CR2: 00007f1a479e9aa0 CR3: 0000000036acc000 CR4: 00000000000006e0
> [  294.512893] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  294.513831] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  294.514740] Process umount (pid: 1557, threadinfo ffff8800da020000, task ffff880036961730)
> [  294.516381] Stack:
> [  294.517137]  ffff880036b99680 0000000000000001 ffff880036b99400 ffffffffa0158a80
> [  294.519000]  ffff880036815f40 ffff880036815f00 ffff8800da021e28 ffffffff8113a7c8
> [  294.521040]  ffffffff8113f68d ffff880036b99400 ffff8800da021e58 ffffffff8112a901
> [  294.522872] Call Trace:
> [  294.523647]  [<ffffffff8113a7c8>] shrink_dcache_for_umount+0x38/0x49
> [  294.524602]  [<ffffffff8113f68d>] ? free_vfsmnt+0x38/0x3c
> [  294.525553]  [<ffffffff8112a901>] generic_shutdown_super+0x23/0xb9
> [  294.526452]  [<ffffffff8112aa14>] kill_anon_super+0x13/0x1e
> [  294.527339]  [<ffffffffa01341c8>] cifs_kill_sb+0x17/0x23 [cifs]
> [  294.528233]  [<ffffffff8112ace1>] deactivate_locked_super+0x37/0x68
> [  294.529551]  [<ffffffff8112b54f>] deactivate_super+0x37/0x3b
> [  294.530837]  [<ffffffff8114023d>] mntput_no_expire+0xcc/0xd1
> [  294.532155]  [<ffffffff81140dfa>] sys_umount+0x2ac/0x2da
> [  294.533471]  [<ffffffff814bc482>] system_call_fastpath+0x16/0x1b
> [  294.534759] Code: 00 00 48 8b 40 28 4c 8b 08 48 8b 43 30 48 85 c0 74 04 48 8b 50 40 48 89 34 24 48 c7 c7 c5 8f 7c 81 48 89 de 31 c0 e8 a2 2c 37 00 <0f> 0b 4c 8b 63 18 48 8d bb 90 00 00 00 4c 39 e3 75 0a e8 81 56 
> [  294.543795] RIP  [<ffffffff8113a000>] shrink_dcache_for_umount_subtree+0x91/0x146
> [  294.545396]  RSP <ffff8800da021dd8>
> [  294.546185] ---[ end trace e5f76c63d051dca7 ]---
> 
> CAI Qian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for the bug report...

I think I've found the bug and have gone ahead and sent a patch to
Steve. Steve, I think that needs to go into 3.3 and stable, assuming
that it also fixes the problem for Cai.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
