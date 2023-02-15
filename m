Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38ADFC636CC
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Feb 2023 11:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjBOLPd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Feb 2023 06:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbjBOLPc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Feb 2023 06:15:32 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE70367D5
        for <linux-cifs@vger.kernel.org>; Wed, 15 Feb 2023 03:15:29 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id d8so21734069ljq.9
        for <linux-cifs@vger.kernel.org>; Wed, 15 Feb 2023 03:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iwl5N1UEcZnB71HWHaStV/h8Qez5W0HKuwpopz3uNUE=;
        b=ab7nJj8WaLfzOQKUu1MGzUR3QkV2ZKOU9Oo62Q9FDqDvu2pPETd9fbuvgDLSGQaRg3
         OuZVmk5fA/I/5mN8Y4ldfZ3I+hz6HkIZNyQRG7NWJz3TK14JzE5VssyfjmwIy/n9YShj
         xZTCvKWdjB/1T76Z9bTy/LWX5sTLQ5TQyDNQzhqmNhLigijaHBL2hx2QNzn/lDmzO+qD
         QRbW4LUjS4GYpTruVqmrKjBcX3u8/zZnhSOEdnXDHH3I9Obs0F427TflA1A+GOLRLxvO
         6Fto2joEvepjYAfwZaJ9j4UFPIyXKfwIJn0VYskKpueocOg8d98+Lj18StQDCBvwR3yK
         7RZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iwl5N1UEcZnB71HWHaStV/h8Qez5W0HKuwpopz3uNUE=;
        b=optkESh37vz3w9dAcQrL3KDe8kZEQllSKPrS4CC2IGZ0L9N7JGzFGAv0EGx0EWao0Q
         /MWOuWhYflS02LkUBBfy6GhsBmG9++GCTtFezNRnYP2/rMqZbBd7lZ4el0qIyjkaXheK
         QGpKp/qMzCwbHeTAwa5O5+yrl434UNYKjBJeMuyo7/IBGk47Xad5hnHeHYFCLS5y7vBH
         SxicDEy0vmtZnR+rlLpxTYPI410/U0gFaGGhm4ZbnBFxIp09C2FWJDEN2MaSnSRV5tC+
         1EsrEVlUKwkHCDekZB2b/Ln4iCE5Ka7dAUfuXsKd66y/LsYm4fp4YxbK9deJLaIyt0My
         KfWA==
X-Gm-Message-State: AO0yUKVzfcoqJ1lghFi3YhYSzvYfMFBa5ot9pdcuhw0ejGqyUGI6L/wv
        H2Zc85vIjbKrmeLXcbc12PT18HWmWFXTfTk2Sq8q+Y7Z+kFcGJ9l
X-Google-Smtp-Source: AK7set/sQaapF48aONE2akXhiW71mA6kkdJtteYEZUlFkIFUWHtEGjMCwexfAFGoLVAwpZYzPBYUcsp5MHJWTTZOF4k=
X-Received: by 2002:a2e:a4b7:0:b0:293:4be3:9e6c with SMTP id
 g23-20020a2ea4b7000000b002934be39e6cmr459573ljm.1.1676459727715; Wed, 15 Feb
 2023 03:15:27 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 15 Feb 2023 16:45:16 +0530
Message-ID: <CANT5p=oRRbupWDr30fW8TAyZb-_k8XoCO9fY6DWfxJ+kY3vm8g@mail.gmail.com>
Subject: Are we leaking cifs_inode?
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Occasionally, I see this warning during my testing with kasan kernel.
This happens when I do an rmmod.
Essentially it's complaining that there are still cifs_inode objects allocated.

[Wed Feb 15 11:08:16 2023]
=============================================================================
[Wed Feb 15 11:08:16 2023] BUG cifs_inode_cache (Tainted: G        W
OE     ): Objects remaining in cifs_inode_cache on
__kmem_cache_shutdown()
[Wed Feb 15 11:08:16 2023]
-----------------------------------------------------------------------------

[Wed Feb 15 11:08:16 2023] Slab 0x000000006876b569 objects=17 used=1
fp=0x00000000762533d9
flags=0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
[Wed Feb 15 11:08:16 2023] CPU: 0 PID: 9331 Comm: rmmod Tainted: G
   W  OE      6.2.0-rc5withkasan #19
[Wed Feb 15 11:08:16 2023] Hardware name: Microsoft Corporation
Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0
12/17/2019
[Wed Feb 15 11:08:16 2023] Call Trace:
[Wed Feb 15 11:08:16 2023]  <TASK>
[Wed Feb 15 11:08:16 2023]  dump_stack_lvl+0x5a/0x78
[Wed Feb 15 11:08:16 2023]  dump_stack+0x10/0x16
[Wed Feb 15 11:08:16 2023]  slab_err+0x95/0xd0
[Wed Feb 15 11:08:16 2023]  __kmem_cache_shutdown+0x14b/0x2d0
[Wed Feb 15 11:08:16 2023]  kmem_cache_destroy+0x62/0x170
[Wed Feb 15 11:08:16 2023]  exit_cifs+0x7e/0xc15 [cifs]
[Wed Feb 15 11:08:16 2023]  __do_sys_delete_module.constprop.0+0x258/0x410
[Wed Feb 15 11:08:16 2023]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[Wed Feb 15 11:08:16 2023]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
[Wed Feb 15 11:08:16 2023]  ? __pfx_mem_cgroup_handle_over_high+0x10/0x10
[Wed Feb 15 11:08:16 2023]  ? lockdep_hardirqs_on_prepare+0x13/0x230
[Wed Feb 15 11:08:16 2023]  ? trace_hardirqs_on+0x3d/0x130
[Wed Feb 15 11:08:16 2023]  __x64_sys_delete_module+0x1f/0x30
[Wed Feb 15 11:08:16 2023]  do_syscall_64+0x59/0x90
[Wed Feb 15 11:08:16 2023]  ? lockdep_hardirqs_on_prepare+0x13/0x230
[Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
[Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
[Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
[Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
[Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
[Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
[Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
[Wed Feb 15 11:08:16 2023]  ? exc_page_fault+0x8e/0x110
[Wed Feb 15 11:08:16 2023]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[Wed Feb 15 11:08:16 2023] RIP: 0033:0x7f6912726c9b
[Wed Feb 15 11:08:16 2023] Code: 73 01 c3 48 8b 0d 95 21 0f 00 f7 d8
64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa
b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 65 21 0f 00
f7 d8 64 89 01 48
[Wed Feb 15 11:08:16 2023] RSP: 002b:00007ffdc4bb6ec8 EFLAGS: 00000206
ORIG_RAX: 00000000000000b0
[Wed Feb 15 11:08:16 2023] RAX: ffffffffffffffda RBX: 0000563f8c228760
RCX: 00007f6912726c9b
[Wed Feb 15 11:08:16 2023] RDX: 000000000000000a RSI: 0000000000000800
RDI: 0000563f8c2287c8
[Wed Feb 15 11:08:16 2023] RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000000000
[Wed Feb 15 11:08:16 2023] R10: 00007f69127beac0 R11: 0000000000000206
R12: 00007ffdc4bb7120
[Wed Feb 15 11:08:16 2023] R13: 0000563f8c2282a0 R14: 00007ffdc4bb88f6
R15: 0000563f8c228760
[Wed Feb 15 11:08:16 2023]  </TASK>
[Wed Feb 15 11:08:16 2023] Object 0x0000000094f20a7f @offset=21120
[Wed Feb 15 11:08:16 2023] ------------[ cut here ]------------
[Wed Feb 15 11:08:16 2023] kmem_cache_destroy cifs_inode_cache: Slab
cache still has objects when called from exit_cifs+0x7e/0xc15 [cifs]
[Wed Feb 15 11:08:16 2023] WARNING: CPU: 0 PID: 9331 at
mm/slab_common.c:497 kmem_cache_destroy+0x15d/0x170
[Wed Feb 15 11:08:16 2023] Modules linked in: cifs(OE-) mptcp_diag
tcp_diag udp_diag raw_diag inet_diag unix_diag tls cmac nls_utf8
cifs_arc4 rdma_cm iw_cm ib_cm ib_core cifs_md4 sunrpc binfmt_misc
nls_iso8859_1 intel_rapl_msr intel_rapl_common rapl serio_raw
hv_balloon hyperv_fb joydev mac_hid sch_fq_codel dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua msr ramoops reed_solomon
efi_pstore ip_tables x_tables autofs4 btrfs blake2b_generic raid10
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq libcrc32c raid1 raid0 multipath linear hyperv_drm
drm_shmem_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
hid_generic hv_storvsc hid_hyperv scsi_transport_fc drm hv_netvsc hid
hv_utils hyperv_keyboard crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd
hv_vmbus [last unloaded: cifs(OE)]
[Wed Feb 15 11:08:16 2023] CPU: 0 PID: 9331 Comm: rmmod Tainted: G
B   W  OE      6.2.0-rc5withkasan #19
[Wed Feb 15 11:08:16 2023] Hardware name: Microsoft Corporation
Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0
12/17/2019
[Wed Feb 15 11:08:16 2023] RIP: 0010:kmem_cache_destroy+0x15d/0x170
[Wed Feb 15 11:08:16 2023] Code: 49 fa c3 ff e9 6f ff ff ff c3 cc cc
cc cc 49 8b 54 24 60 48 8b 4d 08 48 c7 c6 40 75 36 91 48 c7 c7 00 a3
c2 91 e8 46 12 28 01 <0f> 0b e9 47 ff ff ff 66 66 2e 0f 1f 84 00 00 00
00 00 90 90 90 90
[Wed Feb 15 11:08:16 2023] RSP: 0018:ffff88819b6efd18 EFLAGS: 00010282
[Wed Feb 15 11:08:16 2023] RAX: 0000000000000000 RBX: 000000004c020000
RCX: 0000000000000000
[Wed Feb 15 11:08:16 2023] RDX: 0000000000000001 RSI: 0000000000000004
RDI: ffffed10336ddf95
[Wed Feb 15 11:08:16 2023] RBP: ffff88819b6efd28 R08: ffffffff8f796e88
R09: ffff8886841f080b
[Wed Feb 15 11:08:16 2023] R10: ffffed10d083e101 R11: 0000000000000001
R12: ffff888109415c80
[Wed Feb 15 11:08:16 2023] R13: ffff88819b6efe28 R14: ffffffffc134a100
R15: 0000000000000000
[Wed Feb 15 11:08:16 2023] FS:  00007f6912e8dc40(0000)
GS:ffff888684000000(0000) knlGS:0000000000000000
[Wed Feb 15 11:08:16 2023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Wed Feb 15 11:08:16 2023] CR2: 00007f8cf7051f40 CR3: 0000000172bdc002
CR4: 00000000003706f0
[Wed Feb 15 11:08:16 2023] Call Trace:
[Wed Feb 15 11:08:16 2023]  <TASK>
[Wed Feb 15 11:08:16 2023]  exit_cifs+0x7e/0xc15 [cifs]
[Wed Feb 15 11:08:16 2023]  __do_sys_delete_module.constprop.0+0x258/0x410
[Wed Feb 15 11:08:16 2023]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
[Wed Feb 15 11:08:16 2023]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
[Wed Feb 15 11:08:16 2023]  ? __pfx_mem_cgroup_handle_over_high+0x10/0x10
[Wed Feb 15 11:08:16 2023]  ? lockdep_hardirqs_on_prepare+0x13/0x230
[Wed Feb 15 11:08:16 2023]  ? trace_hardirqs_on+0x3d/0x130
[Wed Feb 15 11:08:16 2023]  __x64_sys_delete_module+0x1f/0x30
[Wed Feb 15 11:08:16 2023]  do_syscall_64+0x59/0x90
[Wed Feb 15 11:08:16 2023]  ? lockdep_hardirqs_on_prepare+0x13/0x230
[Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
[Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
[Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
[Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
[Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
[Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
[Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
[Wed Feb 15 11:08:16 2023]  ? exc_page_fault+0x8e/0x110
[Wed Feb 15 11:08:16 2023]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[Wed Feb 15 11:08:16 2023] RIP: 0033:0x7f6912726c9b
[Wed Feb 15 11:08:16 2023] Code: 73 01 c3 48 8b 0d 95 21 0f 00 f7 d8
64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa
b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 65 21 0f 00
f7 d8 64 89 01 48
[Wed Feb 15 11:08:16 2023] RSP: 002b:00007ffdc4bb6ec8 EFLAGS: 00000206
ORIG_RAX: 00000000000000b0
[Wed Feb 15 11:08:16 2023] RAX: ffffffffffffffda RBX: 0000563f8c228760
RCX: 00007f6912726c9b
[Wed Feb 15 11:08:16 2023] RDX: 000000000000000a RSI: 0000000000000800
RDI: 0000563f8c2287c8
[Wed Feb 15 11:08:16 2023] RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000000000
[Wed Feb 15 11:08:16 2023] R10: 00007f69127beac0 R11: 0000000000000206
R12: 00007ffdc4bb7120
[Wed Feb 15 11:08:16 2023] R13: 0000563f8c2282a0 R14: 00007ffdc4bb88f6
R15: 0000563f8c228760
[Wed Feb 15 11:08:16 2023]  </TASK>
[Wed Feb 15 11:08:16 2023] irq event stamp: 0
[Wed Feb 15 11:08:16 2023] hardirqs last  enabled at (0):
[<0000000000000000>] 0x0
[Wed Feb 15 11:08:16 2023] hardirqs last disabled at (0):
[<ffffffff8f72869a>] copy_process+0xeda/0x3960
[Wed Feb 15 11:08:16 2023] softirqs last  enabled at (0):
[<ffffffff8f72869a>] copy_process+0xeda/0x3960
[Wed Feb 15 11:08:16 2023] softirqs last disabled at (0):
[<0000000000000000>] 0x0
[Wed Feb 15 11:08:16 2023] ---[ end trace 0000000000000000 ]---


-- 
Regards,
Shyam
