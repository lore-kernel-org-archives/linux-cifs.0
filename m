Return-Path: <SRS0=yfaw=UN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B02C31E4B
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 20:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A4462133D
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 20:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfFNUNq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jun 2019 16:13:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:46992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbfFNUNp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 Jun 2019 16:13:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69F1EAD36;
        Fri, 14 Jun 2019 20:13:44 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ben Raven <benr@datapad.co>,
        "linux-cifs\@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: uninterruptible I/O wait on CIFS mounts on Amazon Linux 2 running latest kernel
In-Reply-To: <CAKywueRLUcddaYYVAj1WhWXLE1NYQu-5iQn-yZu7kwGVq3g2LQ@mail.gmail.com>
References: <MN2PR14MB3150D6916DA2C3E399AD57F2A6EE0@MN2PR14MB3150.namprd14.prod.outlook.com> <87zhmk47yq.fsf@suse.com> <CAKywueRLUcddaYYVAj1WhWXLE1NYQu-5iQn-yZu7kwGVq3g2LQ@mail.gmail.com>
Date:   Fri, 14 Jun 2019 22:13:43 +0200
Message-ID: <87woho3oy0.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Pavel Shilovsky <piastryyy@gmail.com> writes:
> Both fixes seem to be legitimate and shouldn't cause the issue
> directly. Please provide the logs (as mentioned by Aurelien above)
> together with mount command options. If you have a small simple repro
> setup/script/program that would help too.

He sent it but I believe linux-cifs dropped it because of the
attachement sizes (capture can get big). I have it since I was in
CC. I'll paste the end of the log directly:

It seems it is indeed the cifs_small_buf_release() change causing this.

  [  423.187103] fs/cifs/dir.c: CIFS VFS: leaving cifs_atomic_open (xid = 1384) rc = 0
  [  423.250168] fs/cifs/smb2pdu.c: async write at 0 1048576 bytes
  [  423.256344] fs/cifs/smb2pdu.c: async write at 1048576 1048576 bytes
  [  423.264481] fs/cifs/smb2pdu.c: async write at 2097152 1048576 bytes
  [  423.493425] fs/cifs/dir.c: CIFS VFS: in cifs_atomic_open as Xid: 1389 with uid: 0
  [  423.493427] fs/cifs/dir.c: parent inode = 0xffff888085cd21a0 name is: Demo.ConstituencyAlias_Data.sql and dentry = 0xffff888085cf1c00
  [  423.494108] fs/cifs/dir.c: CIFS VFS: leaving cifs_atomic_open (xid = 1389) rc = 0
  [  423.598102] fs/cifs/inode.c: In cifs_mkdir, mode = 0x1ed inode = 0xffff888085c8c0a0
  [  423.598104] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1446 with uid: 0
  [  423.600419] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid = 1446) rc = 0
  [  423.657308] fs/cifs/inode.c: In cifs_mkdir, mode = 0x1ed inode = 0xffff888085c8c0a0
  [  423.657311] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1520 with uid: 0
  [  423.658465] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid = 1520) rc = 0
  [  423.658924] fs/cifs/inode.c: In cifs_mkdir, mode = 0x1ed inode = 0xffff888085c8fca0
  [  423.658925] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1523 with uid: 0
  [  423.660218] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid = 1523) rc = 0
  [  423.660920] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 20266198323201206 mapping
  [  423.675405] fs/cifs/inode.c: In cifs_mkdir, mode = 0x1ed inode = 0xffff888085c8fca0
  [  423.675407] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1544 with uid: 0
  [  423.676558] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid = 1544) rc = 0
  [  423.678630] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 20266198323201206 mapping
  [  423.726164] fs/cifs/inode.c: In cifs_mkdir, mode = 0x1ed inode = 0xffff888085c8c0a0
  [  423.726166] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1614 with uid: 0
  [  423.727412] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid = 1614) rc = 0
  [  423.733244] fs/cifs/inode.c: In cifs_mkdir, mode = 0x1ed inode = 0xffff888085c8c0a0
  [  423.733246] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1623 with uid: 0
  [  423.734470] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid = 1623) rc = 0
  [  423.981613] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 14355223812244498 mapping
  [  423.981637] fs/cifs/inode.c: CIFS VFS: in cifs_rename2 as Xid: 1813 with uid: 0
  [  423.984674] fs/cifs/inode.c: CIFS VFS: leaving cifs_rename2 (xid = 1813) rc = 0
  [  423.985672] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 15762598695798811 mapping
  [  423.992712] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 19984723346490282 mapping
  [  424.001682] fs/cifs/inode.c: CIFS VFS: in cifs_rename2 as Xid: 1836 with uid: 0
  [  424.003645] fs/cifs/inode.c: CIFS VFS: leaving cifs_rename2 (xid = 1836) rc = 0
  [  424.008361] fs/cifs/file.c: CIFS VFS: in cifs_file_strict_mmap as Xid: 1845 with uid: 0
  [  424.008363] fs/cifs/file.c: CIFS VFS: leaving cifs_file_strict_mmap (xid = 1845) rc = 0
  [  424.008373] fs/cifs/inode.c: CIFS VFS: in cifs_setattr_nounix as Xid: 1846 with uid: 0
  [  424.008374] fs/cifs/inode.c: setattr on file config.lock attrs->iavalid 0x41
  [  424.008378] fs/cifs/inode.c: CIFS VFS: leaving cifs_setattr_nounix (xid = 1846) rc = 0
  [  424.010437] fs/cifs/inode.c: CIFS VFS: in cifs_rename2 as Xid: 1851 with uid: 0
  [  424.012253] fs/cifs/inode.c: CIFS VFS: leaving cifs_rename2 (xid = 1851) rc = 0
  [  424.012918] fs/cifs/inode.c: cifs_revalidate_cache: invalidating inode 15762598695798811 mapping
  [  424.018105] fs/cifs/file.c: CIFS VFS: in cifs_file_strict_mmap as Xid: 1861 with uid: 0
  [  424.018107] fs/cifs/file.c: CIFS VFS: leaving cifs_file_strict_mmap (xid = 1861) rc = 0
  [  424.018115] fs/cifs/inode.c: CIFS VFS: in cifs_setattr_nounix as Xid: 1862 with uid: 0
  [  424.018117] fs/cifs/inode.c: setattr on file config.lock attrs->iavalid 0x41
  [  424.018120] fs/cifs/inode.c: CIFS VFS: leaving cifs_setattr_nounix (xid = 1862) rc = 0
  [  424.020046] fs/cifs/inode.c: CIFS VFS: in cifs_rename2 as Xid: 1867 with uid: 0
  [  424.022786] fs/cifs/inode.c: CIFS VFS: leaving cifs_rename2 (xid = 1867) rc = 0
  [  424.037190] fs/cifs/file.c: CIFS VFS: in cifs_write_end as Xid: 1889 with uid: 0
  [  424.037193] fs/cifs/file.c: write 175 bytes to offset 187 of HEAD
  [  424.037194] fs/cifs/file.c: CIFS VFS: in cifs_write as Xid: 1890 with uid: 0
  [  424.037454] fs/cifs/file.c: CIFS VFS: leaving cifs_write (xid = 1890) rc = 0
  [  424.037456] fs/cifs/file.c: CIFS VFS: leaving cifs_write_end (xid = 1889) rc = 175
  [  424.039921] fs/cifs/file.c: CIFS VFS: in cifs_readpage as Xid: 1892 with uid: 0
  [  424.039923] fs/cifs/file.c: readpage ffffea0001eaefc0 at offset 0 0x0
  [  424.039924] fs/cifs/file.c: CIFS VFS: in cifs_read as Xid: 1893 with uid: 0
  [  424.040382] ------------[ cut here ]------------
  [  424.044573] kernel BUG at mm/slub.c:294!
  [  424.047933] invalid opcode: 0000 [#1] SMP PTI
  [  424.051382] Modules linked in: nfnetlink_queue nfnetlink_log nfnetlink bluetooth cmac arc4 ecb md4 nls_utf8 cifs ccm dns_resolver fuse uhid uinput talpa_vfshook(OE) talpa_pedconnector(OE) talpa_pedevice(OE) talpa_vcdevice(OE) talpa_core(OE) talpa_linux(OE) talpa_syscallhook(OE) ext4 crc16 mbcache jbd2 fscrypto sb_edac mousedev evdev psmouse button lz4 lz4_compress zram zsmalloc ena auth_rpcgss sunrpc ip_tables x_tables xfs libcrc32c crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc ata_piix xen_blkfront aesni_intel aes_x86_64 crypto_simd glue_helper cryptd libata scsi_mod dm_mirror dm_region_hash dm_log dm_mod dax ipv6 crc_ccitt autofs4
  [  424.089527] CPU: 1 PID: 3350 Comm: savscand Tainted: G           OE   4.14.121-109.96.amzn2.x86_64 #1
  [  424.097077] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
  [  424.103084] task: ffff888109bb25c0 task.stack: ffffc90000a14000
  [  424.110461] RIP: 0010:kmem_cache_free+0x1b1/0x1d0
  [  424.116398] RSP: 0018:ffffc90000a17a28 EFLAGS: 00010246
  [  424.121088] RAX: ffff88807b8db100 RBX: ffff88807b8db100 RCX: ffff88807b8db100
  [  424.127278] RDX: 0000000000001185 RSI: ffff88810b268610 RDI: ffffea0001ee3600
  [  424.133137] RBP: ffff88810a110c00 R08: ffff88807b9bb9c0 R09: ffffffffa05c93b6
  [  424.139641] R10: ffffc90000a17960 R11: 0000000000000001 R12: 00000000ffffffc3
  [  424.145545] R13: ffff88807b9bb9c0 R14: ffffc90000a17b70 R15: 0000000000000000
  [  424.150692] FS:  00007fced692d700(0000) GS:ffff88810b240000(0000) knlGS:0000000000000000
  [  424.157778] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  424.162113] CR2: 00007f79997b9430 CR3: 00000001087a4001 CR4: 00000000001606e0
  [  424.167316] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [  424.173413] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [  424.179693] Call Trace:
  [  424.182557]  cifs_small_buf_release+0x16/0x70 [cifs]
  [  424.187245]  SMB2_read+0x164/0x2e0 [cifs]
  [  424.191147]  ? cifs_readpage_worker+0x1ff/0x700 [cifs]
  [  424.196409]  cifs_readpage_worker+0x1ff/0x700 [cifs]
  [  424.201008]  ? __switch_to_asm+0x41/0x70
  [  424.204740]  cifs_readpage+0x72/0x240 [cifs]
  [  424.208706]  generic_file_read_iter+0x62a/0x970
  [  424.212937]  ? lock_timer_base+0x67/0x80
  [  424.216868]  cifs_strict_readv+0xcb/0xf0 [cifs]
  [  424.221280]  __vfs_read+0xfe/0x150
  [  424.224719]  vfs_read+0x89/0x130
  [  424.227985]  kernel_read+0x2c/0x40
  [  424.231490]  streamReadAt+0xb4/0x120 [talpa_core]
  [  424.235905]  processPacket+0xfe/0x140 [talpa_core]
  [  424.240230]  ddvcWrite+0xad/0xf0 [talpa_vcdevice]
  [  424.244478]  __vfs_write+0x36/0x160
  [  424.248289]  ? __audit_syscall_entry+0xbc/0x110
  [  424.252416]  vfs_write+0xad/0x1a0
  [  424.255884]  SyS_write+0x52/0xc0
  [  424.259418]  do_syscall_64+0x67/0x110
  [  424.263219]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
  [  424.267625] RIP: 0033:0x7fced93c5d0b
  [  424.270991] RSP: 002b:00007fced692c990 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
  [  424.277617] RAX: ffffffffffffffda RBX: 00007fced692ca00 RCX: 00007fced93c5d0b
  [  424.283481] RDX: 000000000000001c RSI: 00007fced692ca00 RDI: 000000000000003c
  [  424.289453] RBP: 000000000000001c R08: 0000000000000000 R09: 0000000000000000
  [  424.295792] R10: 00007fced9e117c0 R11: 0000000000000293 R12: 00007fced872ce90
  [  424.302230] R13: 00007fcec0000bb0 R14: 00007fced692cbc0 R15: 00007fcec0000b58
  [  424.308390] Code: 75 e4 5b 5d 41 5c c3 48 89 c5 e9 89 fe ff ff 48 89 fe 41 b8 01 00 00 00 48 89 d9 48 89 da 48 89 ef e8 f4 f2 ff ff e9 0e ff ff ff <0f> 0b 48 8b 05 e6 d5 de 00 e9 85 fe ff ff 48 8b 15 da d5 de 00 
  [  424.323737] RIP: kmem_cache_free+0x1b1/0x1d0 RSP: ffffc90000a17a28
  [  424.329840] ---[ end trace f930af7108d4e936 ]---
  [  426.028507] cifs_flush: 111 callbacks suppressed
  [  426.028510] fs/cifs/file.c: Flush inode ffff888085c8c3a0 file ffff888107537500 rc 0
  [  426.028554] device eth0 left promiscuous mode

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 21284 (AG Nürnberg)
