Return-Path: <SRS0=yfaw=UN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6E9C31E4B
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 21:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 353FD2183E
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 21:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgEG7oyk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfFNVqo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jun 2019 17:46:44 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43182 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfFNVqo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jun 2019 17:46:44 -0400
Received: by mail-lj1-f194.google.com with SMTP id 16so3771949ljv.10
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jun 2019 14:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IAMHJjLcUhHBx99wrxa03Q+c+INE9fQexDIzx0iOzQs=;
        b=dgEG7oykC9bM+o1j9oJ3jeb9pROcIXDV1ydiYxRVY2B3lfLhwnMbZCcXz3f5N1CGiO
         2l/WyTgw7BqXEiGn3bTEx9brNcDTyI9gsEpV9HHamXSxaXmbzwxl+/hGKpLZ5GVbHJMX
         gd7N4ZSu7aLKHxhVP1Sn2zjsainPXDf9KktQCuxxGwwXzaO9D7uphRb5AlGCDliGGYF9
         mwRtfcbXBWypvcIjq2BoG6Pi8ABEuyCYLTE2K1MQgbgEbqWl57B6TMPYrvzet39ALfeb
         eARjoGVVYqovsCQp8Uni8tpDCFSjIFgPXsbF+G5seYXigl6oql9/QhrDH6UB8I/u4c07
         7VlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IAMHJjLcUhHBx99wrxa03Q+c+INE9fQexDIzx0iOzQs=;
        b=ISrpVt59Lvne3CGDh7q7zqdKl/5juRm+znlyPf8PJ9ORTD7oD4sZ6si0OTel7hI6wO
         mkgomhFuUH1Fn80w42gqY5YvJahuv44ig3NUdPc8h7sKu/IHYxJXmV3YIdSYfATCIpDS
         QsGRml0zGHouUChKspixyfOCN/lY3DzsJytApupeKK9NJljke5xuLcqE/poqQifM9S2x
         BwESP07I6bY0dyBh1+PxQ2LfBkux9UIG9eurpnnwtNJIJrssEMr38k28+8cbF0wfgqBm
         bPU8/DdKyJfheFUckqU//nVjMAFJ1mIH3yefW/Zjl9ERri6O39L9iC04rsZoHAQglcau
         xB8Q==
X-Gm-Message-State: APjAAAXO99DYliqSxkw2MxY/F/h/P+/QHid5PHQ9nDB//mauFQ9jvpq1
        sFdFxfcHZr7LVMOOaVK6Yr2Rhtg/HYNJvaSWnq48dP8=
X-Google-Smtp-Source: APXvYqwlfCQ/n1Q7s716P1BmxmYAN6EIv+P4+o8zG0n2NRU3jDuZq8N342Ptqy+6NgvFJflOsq0ubteFyXSCGv/GCjY=
X-Received: by 2002:a2e:8744:: with SMTP id q4mr5606611ljj.77.1560548801773;
 Fri, 14 Jun 2019 14:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <MN2PR14MB3150D6916DA2C3E399AD57F2A6EE0@MN2PR14MB3150.namprd14.prod.outlook.com>
 <87zhmk47yq.fsf@suse.com> <CAKywueRLUcddaYYVAj1WhWXLE1NYQu-5iQn-yZu7kwGVq3g2LQ@mail.gmail.com>
 <87woho3oy0.fsf@suse.com>
In-Reply-To: <87woho3oy0.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 14 Jun 2019 14:46:30 -0700
Message-ID: <CAKywueTfeYW7dD8dw9aYjqFQrUumrK+vCJJ_ZveocR5HQ5BT-A@mail.gmail.com>
Subject: Re: uninterruptible I/O wait on CIFS mounts on Amazon Linux 2 running
 latest kernel
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ben Raven <benr@datapad.co>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ok, thanks for posting the trace. This is a double free bug.

Originally there were use-after-free bug that was fixed by:

commit 088aaf17aa79300cab14dbee2569c58cfafd7d6e
Author: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Date:   Sat Apr 6 15:47:39 2019 +0800

    cifs: Fix use-after-free in SMB2_read

    There is a KASAN use-after-free:
    BUG: KASAN: use-after-free in SMB2_read+0x1136/0x1190
    Read of size 8 at addr ffff8880b4e45e50 by task ln/1009

    Should not release the 'req' because it will use in the trace.

    Fixes: eccb4422cf97 ("smb3: Add ftrace tracepoints for improved
SMB3 debugging")

    Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>
    CC: Stable <stable@vger.kernel.org> 4.18+
    Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

Then this fix introduced a memory leak in the error path and it was fixed b=
y:

commit 05fd5c2c61732152a6bddc318aae62d7e436629b
Author: Ronnie Sahlberg <lsahlber@redhat.com>
Date:   Tue Apr 23 16:39:45 2019 +1000

    cifs: fix memory leak in SMB2_read

    Commit 088aaf17aa79300cab14dbee2569c58cfafd7d6e introduced a leak where
    if SMB2_read() returned an error we would return without freeing the
    request buffer.

    Cc: Stable <stable@vger.kernel.org>
    Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>


The problem is that the last commit missed "4.18+" portion on the
stable tag and the patch was backported to v4.14.120 stable kernel.

The problem was actually fixed in the stable kernel v4.14.122:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-4.14.y&id=3Dddbe4b02aeca52900bb6965c533044b59924e37c

Ben, please upgrade your kernel to at least v4.14.122 to avoid the issue.

--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 14 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 13:13, Aur=C3=A9li=
en Aptel <aaptel@suse.com>:
>
> Pavel Shilovsky <piastryyy@gmail.com> writes:
> > Both fixes seem to be legitimate and shouldn't cause the issue
> > directly. Please provide the logs (as mentioned by Aurelien above)
> > together with mount command options. If you have a small simple repro
> > setup/script/program that would help too.
>
> He sent it but I believe linux-cifs dropped it because of the
> attachement sizes (capture can get big). I have it since I was in
> CC. I'll paste the end of the log directly:
>
> It seems it is indeed the cifs_small_buf_release() change causing this.
>
>   [  423.187103] fs/cifs/dir.c: CIFS VFS: leaving cifs_atomic_open (xid =
=3D 1384) rc =3D 0
>   [  423.250168] fs/cifs/smb2pdu.c: async write at 0 1048576 bytes
>   [  423.256344] fs/cifs/smb2pdu.c: async write at 1048576 1048576 bytes
>   [  423.264481] fs/cifs/smb2pdu.c: async write at 2097152 1048576 bytes
>   [  423.493425] fs/cifs/dir.c: CIFS VFS: in cifs_atomic_open as Xid: 138=
9 with uid: 0
>   [  423.493427] fs/cifs/dir.c: parent inode =3D 0xffff888085cd21a0 name =
is: Demo.ConstituencyAlias_Data.sql and dentry =3D 0xffff888085cf1c00
>   [  423.494108] fs/cifs/dir.c: CIFS VFS: leaving cifs_atomic_open (xid =
=3D 1389) rc =3D 0
>   [  423.598102] fs/cifs/inode.c: In cifs_mkdir, mode =3D 0x1ed inode =3D=
 0xffff888085c8c0a0
>   [  423.598104] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1446 wi=
th uid: 0
>   [  423.600419] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid =3D 1=
446) rc =3D 0
>   [  423.657308] fs/cifs/inode.c: In cifs_mkdir, mode =3D 0x1ed inode =3D=
 0xffff888085c8c0a0
>   [  423.657311] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1520 wi=
th uid: 0
>   [  423.658465] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid =3D 1=
520) rc =3D 0
>   [  423.658924] fs/cifs/inode.c: In cifs_mkdir, mode =3D 0x1ed inode =3D=
 0xffff888085c8fca0
>   [  423.658925] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1523 wi=
th uid: 0
>   [  423.660218] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid =3D 1=
523) rc =3D 0
>   [  423.660920] fs/cifs/inode.c: cifs_revalidate_cache: invalidating ino=
de 20266198323201206 mapping
>   [  423.675405] fs/cifs/inode.c: In cifs_mkdir, mode =3D 0x1ed inode =3D=
 0xffff888085c8fca0
>   [  423.675407] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1544 wi=
th uid: 0
>   [  423.676558] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid =3D 1=
544) rc =3D 0
>   [  423.678630] fs/cifs/inode.c: cifs_revalidate_cache: invalidating ino=
de 20266198323201206 mapping
>   [  423.726164] fs/cifs/inode.c: In cifs_mkdir, mode =3D 0x1ed inode =3D=
 0xffff888085c8c0a0
>   [  423.726166] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1614 wi=
th uid: 0
>   [  423.727412] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid =3D 1=
614) rc =3D 0
>   [  423.733244] fs/cifs/inode.c: In cifs_mkdir, mode =3D 0x1ed inode =3D=
 0xffff888085c8c0a0
>   [  423.733246] fs/cifs/inode.c: CIFS VFS: in cifs_mkdir as Xid: 1623 wi=
th uid: 0
>   [  423.734470] fs/cifs/inode.c: CIFS VFS: leaving cifs_mkdir (xid =3D 1=
623) rc =3D 0
>   [  423.981613] fs/cifs/inode.c: cifs_revalidate_cache: invalidating ino=
de 14355223812244498 mapping
>   [  423.981637] fs/cifs/inode.c: CIFS VFS: in cifs_rename2 as Xid: 1813 =
with uid: 0
>   [  423.984674] fs/cifs/inode.c: CIFS VFS: leaving cifs_rename2 (xid =3D=
 1813) rc =3D 0
>   [  423.985672] fs/cifs/inode.c: cifs_revalidate_cache: invalidating ino=
de 15762598695798811 mapping
>   [  423.992712] fs/cifs/inode.c: cifs_revalidate_cache: invalidating ino=
de 19984723346490282 mapping
>   [  424.001682] fs/cifs/inode.c: CIFS VFS: in cifs_rename2 as Xid: 1836 =
with uid: 0
>   [  424.003645] fs/cifs/inode.c: CIFS VFS: leaving cifs_rename2 (xid =3D=
 1836) rc =3D 0
>   [  424.008361] fs/cifs/file.c: CIFS VFS: in cifs_file_strict_mmap as Xi=
d: 1845 with uid: 0
>   [  424.008363] fs/cifs/file.c: CIFS VFS: leaving cifs_file_strict_mmap =
(xid =3D 1845) rc =3D 0
>   [  424.008373] fs/cifs/inode.c: CIFS VFS: in cifs_setattr_nounix as Xid=
: 1846 with uid: 0
>   [  424.008374] fs/cifs/inode.c: setattr on file config.lock attrs->iava=
lid 0x41
>   [  424.008378] fs/cifs/inode.c: CIFS VFS: leaving cifs_setattr_nounix (=
xid =3D 1846) rc =3D 0
>   [  424.010437] fs/cifs/inode.c: CIFS VFS: in cifs_rename2 as Xid: 1851 =
with uid: 0
>   [  424.012253] fs/cifs/inode.c: CIFS VFS: leaving cifs_rename2 (xid =3D=
 1851) rc =3D 0
>   [  424.012918] fs/cifs/inode.c: cifs_revalidate_cache: invalidating ino=
de 15762598695798811 mapping
>   [  424.018105] fs/cifs/file.c: CIFS VFS: in cifs_file_strict_mmap as Xi=
d: 1861 with uid: 0
>   [  424.018107] fs/cifs/file.c: CIFS VFS: leaving cifs_file_strict_mmap =
(xid =3D 1861) rc =3D 0
>   [  424.018115] fs/cifs/inode.c: CIFS VFS: in cifs_setattr_nounix as Xid=
: 1862 with uid: 0
>   [  424.018117] fs/cifs/inode.c: setattr on file config.lock attrs->iava=
lid 0x41
>   [  424.018120] fs/cifs/inode.c: CIFS VFS: leaving cifs_setattr_nounix (=
xid =3D 1862) rc =3D 0
>   [  424.020046] fs/cifs/inode.c: CIFS VFS: in cifs_rename2 as Xid: 1867 =
with uid: 0
>   [  424.022786] fs/cifs/inode.c: CIFS VFS: leaving cifs_rename2 (xid =3D=
 1867) rc =3D 0
>   [  424.037190] fs/cifs/file.c: CIFS VFS: in cifs_write_end as Xid: 1889=
 with uid: 0
>   [  424.037193] fs/cifs/file.c: write 175 bytes to offset 187 of HEAD
>   [  424.037194] fs/cifs/file.c: CIFS VFS: in cifs_write as Xid: 1890 wit=
h uid: 0
>   [  424.037454] fs/cifs/file.c: CIFS VFS: leaving cifs_write (xid =3D 18=
90) rc =3D 0
>   [  424.037456] fs/cifs/file.c: CIFS VFS: leaving cifs_write_end (xid =
=3D 1889) rc =3D 175
>   [  424.039921] fs/cifs/file.c: CIFS VFS: in cifs_readpage as Xid: 1892 =
with uid: 0
>   [  424.039923] fs/cifs/file.c: readpage ffffea0001eaefc0 at offset 0 0x=
0
>   [  424.039924] fs/cifs/file.c: CIFS VFS: in cifs_read as Xid: 1893 with=
 uid: 0
>   [  424.040382] ------------[ cut here ]------------
>   [  424.044573] kernel BUG at mm/slub.c:294!
>   [  424.047933] invalid opcode: 0000 [#1] SMP PTI
>   [  424.051382] Modules linked in: nfnetlink_queue nfnetlink_log nfnetli=
nk bluetooth cmac arc4 ecb md4 nls_utf8 cifs ccm dns_resolver fuse uhid uin=
put talpa_vfshook(OE) talpa_pedconnector(OE) talpa_pedevice(OE) talpa_vcdev=
ice(OE) talpa_core(OE) talpa_linux(OE) talpa_syscallhook(OE) ext4 crc16 mbc=
ache jbd2 fscrypto sb_edac mousedev evdev psmouse button lz4 lz4_compress z=
ram zsmalloc ena auth_rpcgss sunrpc ip_tables x_tables xfs libcrc32c crc32_=
pclmul crc32c_intel ghash_clmulni_intel pcbc ata_piix xen_blkfront aesni_in=
tel aes_x86_64 crypto_simd glue_helper cryptd libata scsi_mod dm_mirror dm_=
region_hash dm_log dm_mod dax ipv6 crc_ccitt autofs4
>   [  424.089527] CPU: 1 PID: 3350 Comm: savscand Tainted: G           OE =
  4.14.121-109.96.amzn2.x86_64 #1
>   [  424.097077] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
>   [  424.103084] task: ffff888109bb25c0 task.stack: ffffc90000a14000
>   [  424.110461] RIP: 0010:kmem_cache_free+0x1b1/0x1d0
>   [  424.116398] RSP: 0018:ffffc90000a17a28 EFLAGS: 00010246
>   [  424.121088] RAX: ffff88807b8db100 RBX: ffff88807b8db100 RCX: ffff888=
07b8db100
>   [  424.127278] RDX: 0000000000001185 RSI: ffff88810b268610 RDI: ffffea0=
001ee3600
>   [  424.133137] RBP: ffff88810a110c00 R08: ffff88807b9bb9c0 R09: fffffff=
fa05c93b6
>   [  424.139641] R10: ffffc90000a17960 R11: 0000000000000001 R12: 0000000=
0ffffffc3
>   [  424.145545] R13: ffff88807b9bb9c0 R14: ffffc90000a17b70 R15: 0000000=
000000000
>   [  424.150692] FS:  00007fced692d700(0000) GS:ffff88810b240000(0000) kn=
lGS:0000000000000000
>   [  424.157778] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [  424.162113] CR2: 00007f79997b9430 CR3: 00000001087a4001 CR4: 0000000=
0001606e0
>   [  424.167316] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
>   [  424.173413] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
>   [  424.179693] Call Trace:
>   [  424.182557]  cifs_small_buf_release+0x16/0x70 [cifs]
>   [  424.187245]  SMB2_read+0x164/0x2e0 [cifs]
>   [  424.191147]  ? cifs_readpage_worker+0x1ff/0x700 [cifs]
>   [  424.196409]  cifs_readpage_worker+0x1ff/0x700 [cifs]
>   [  424.201008]  ? __switch_to_asm+0x41/0x70
>   [  424.204740]  cifs_readpage+0x72/0x240 [cifs]
>   [  424.208706]  generic_file_read_iter+0x62a/0x970
>   [  424.212937]  ? lock_timer_base+0x67/0x80
>   [  424.216868]  cifs_strict_readv+0xcb/0xf0 [cifs]
>   [  424.221280]  __vfs_read+0xfe/0x150
>   [  424.224719]  vfs_read+0x89/0x130
>   [  424.227985]  kernel_read+0x2c/0x40
>   [  424.231490]  streamReadAt+0xb4/0x120 [talpa_core]
>   [  424.235905]  processPacket+0xfe/0x140 [talpa_core]
>   [  424.240230]  ddvcWrite+0xad/0xf0 [talpa_vcdevice]
>   [  424.244478]  __vfs_write+0x36/0x160
>   [  424.248289]  ? __audit_syscall_entry+0xbc/0x110
>   [  424.252416]  vfs_write+0xad/0x1a0
>   [  424.255884]  SyS_write+0x52/0xc0
>   [  424.259418]  do_syscall_64+0x67/0x110
>   [  424.263219]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>   [  424.267625] RIP: 0033:0x7fced93c5d0b
>   [  424.270991] RSP: 002b:00007fced692c990 EFLAGS: 00000293 ORIG_RAX: 00=
00000000000001
>   [  424.277617] RAX: ffffffffffffffda RBX: 00007fced692ca00 RCX: 00007fc=
ed93c5d0b
>   [  424.283481] RDX: 000000000000001c RSI: 00007fced692ca00 RDI: 0000000=
00000003c
>   [  424.289453] RBP: 000000000000001c R08: 0000000000000000 R09: 0000000=
000000000
>   [  424.295792] R10: 00007fced9e117c0 R11: 0000000000000293 R12: 00007fc=
ed872ce90
>   [  424.302230] R13: 00007fcec0000bb0 R14: 00007fced692cbc0 R15: 00007fc=
ec0000b58
>   [  424.308390] Code: 75 e4 5b 5d 41 5c c3 48 89 c5 e9 89 fe ff ff 48 89=
 fe 41 b8 01 00 00 00 48 89 d9 48 89 da 48 89 ef e8 f4 f2 ff ff e9 0e ff ff=
 ff <0f> 0b 48 8b 05 e6 d5 de 00 e9 85 fe ff ff 48 8b 15 da d5 de 00
>   [  424.323737] RIP: kmem_cache_free+0x1b1/0x1d0 RSP: ffffc90000a17a28
>   [  424.329840] ---[ end trace f930af7108d4e936 ]---
>   [  426.028507] cifs_flush: 111 callbacks suppressed
>   [  426.028510] fs/cifs/file.c: Flush inode ffff888085c8c3a0 file ffff88=
8107537500 rc 0
>   [  426.028554] device eth0 left promiscuous mode
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=
=BCrnberg)
