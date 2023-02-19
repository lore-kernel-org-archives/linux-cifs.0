Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D342C05027
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Feb 2023 21:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjBSVcn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Feb 2023 16:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjBSVcm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Feb 2023 16:32:42 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6DE199F0
        for <linux-cifs@vger.kernel.org>; Sun, 19 Feb 2023 13:32:40 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i31so3009509eda.12
        for <linux-cifs@vger.kernel.org>; Sun, 19 Feb 2023 13:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6YRUXuZXtGmZNWkAAG2zlTr5kTcCy3tXuOEvJdg/Mvk=;
        b=JHT/vfizlpr/HbRD5HmFPunYXRvsKxckiAKA3xqmgVC6Q8+kdozPHWSyQ/VTzOJh26
         8tnNu9+k/IzInh+Pw8SNJH0nNMTXMFkcB0UUuBMwihWerFtuDRW6+XkjFBPhse2UleaS
         PJZg3vbvuKCe6sSi/TA0DNguaVFFx8SOqz2VvRH/Fm/x7+627RpiICzfufmTHlceQyO6
         WzplV9Z/q3qUy73Q6UMxYxNPjkdcARKnoxF0DKZUEH52oAFfWPGQfiT4mSIJFk/y+DBK
         J19wTjJQ21VEF6uXMq79M9BbUzWn+f7/iIavPa4TuUMVfywoCLNRAi/dKpBz7orRzcRO
         yxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6YRUXuZXtGmZNWkAAG2zlTr5kTcCy3tXuOEvJdg/Mvk=;
        b=n/Z5x37J3+nDLPalvpmqfqfIOkjF6umk7y4s3HrVS762OQVgjHUsP2OYXIhGPgwsHy
         y9r571bSUI5sLP0Ayrk5Y0mAapFIHMkj/rwnrrOxW7P0zWM0rmDcjq4mbMG3GlIDAOru
         v3GBhAVCmgi3q6HImtyI8Xx1k3aBqKSRQ50/hKJ24O11joRWZv16XSJIcSOKzNjmogM1
         l/EPBxC5eaorGsylu70iL2R68AN+RNk2cr4cxpesYCoAXUvWzX1feHNEDD4AHTgyf7Tx
         Ij7kfB1LuWotKDlJj6Lk5orHb/8HB1yfxCGEh1JMC/f0+rhvgvymaDeYoO6is1+g5T0y
         YWWw==
X-Gm-Message-State: AO0yUKVLhfdjr7Nwz0myqZoa/vHi14/RZL0w2YSQ77EmAgFZVUiVBzpB
        zxTHEsEAN6zQBPwtD/51lubHgnyxxSIXl5SYhJbHlh9U
X-Google-Smtp-Source: AK7set/9Z8X7mT80PihI+TVbGtIaJm58sEigSd6PyxUhDFUhmOenG7tRPe+d+BXjA5MaKbe+gzqUZbkS/PAdpfzZbgM=
X-Received: by 2002:a17:906:6854:b0:87b:d50f:6981 with SMTP id
 a20-20020a170906685400b0087bd50f6981mr3082373ejs.14.1676842359218; Sun, 19
 Feb 2023 13:32:39 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=oRRbupWDr30fW8TAyZb-_k8XoCO9fY6DWfxJ+kY3vm8g@mail.gmail.com>
In-Reply-To: <CANT5p=oRRbupWDr30fW8TAyZb-_k8XoCO9fY6DWfxJ+kY3vm8g@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 20 Feb 2023 07:32:26 +1000
Message-ID: <CAN05THSbKN0MPN-qVUc2Q8ZnrSMLVM0qEypbcVe5ZC6sT2sGSQ@mail.gmail.com>
Subject: Re: Are we leaking cifs_inode?
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes, I think we are leaking inodes. I also see this from time to time
but have not managed to track down the culprit.
It started happening a while back.

During umount, which happens before rmmod, all open files will be
closed so nothing should hold these inodes open/active.
I would suspect possible deferred close. I can not really think of
anything else holding an inode open after all applications have closed
their handles.


On Wed, 15 Feb 2023 at 21:33, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Occasionally, I see this warning during my testing with kasan kernel.
> This happens when I do an rmmod.
> Essentially it's complaining that there are still cifs_inode objects allocated.
>
> [Wed Feb 15 11:08:16 2023]
> =============================================================================
> [Wed Feb 15 11:08:16 2023] BUG cifs_inode_cache (Tainted: G        W
> OE     ): Objects remaining in cifs_inode_cache on
> __kmem_cache_shutdown()
> [Wed Feb 15 11:08:16 2023]
> -----------------------------------------------------------------------------
>
> [Wed Feb 15 11:08:16 2023] Slab 0x000000006876b569 objects=17 used=1
> fp=0x00000000762533d9
> flags=0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> [Wed Feb 15 11:08:16 2023] CPU: 0 PID: 9331 Comm: rmmod Tainted: G
>    W  OE      6.2.0-rc5withkasan #19
> [Wed Feb 15 11:08:16 2023] Hardware name: Microsoft Corporation
> Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0
> 12/17/2019
> [Wed Feb 15 11:08:16 2023] Call Trace:
> [Wed Feb 15 11:08:16 2023]  <TASK>
> [Wed Feb 15 11:08:16 2023]  dump_stack_lvl+0x5a/0x78
> [Wed Feb 15 11:08:16 2023]  dump_stack+0x10/0x16
> [Wed Feb 15 11:08:16 2023]  slab_err+0x95/0xd0
> [Wed Feb 15 11:08:16 2023]  __kmem_cache_shutdown+0x14b/0x2d0
> [Wed Feb 15 11:08:16 2023]  kmem_cache_destroy+0x62/0x170
> [Wed Feb 15 11:08:16 2023]  exit_cifs+0x7e/0xc15 [cifs]
> [Wed Feb 15 11:08:16 2023]  __do_sys_delete_module.constprop.0+0x258/0x410
> [Wed Feb 15 11:08:16 2023]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
> [Wed Feb 15 11:08:16 2023]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
> [Wed Feb 15 11:08:16 2023]  ? __pfx_mem_cgroup_handle_over_high+0x10/0x10
> [Wed Feb 15 11:08:16 2023]  ? lockdep_hardirqs_on_prepare+0x13/0x230
> [Wed Feb 15 11:08:16 2023]  ? trace_hardirqs_on+0x3d/0x130
> [Wed Feb 15 11:08:16 2023]  __x64_sys_delete_module+0x1f/0x30
> [Wed Feb 15 11:08:16 2023]  do_syscall_64+0x59/0x90
> [Wed Feb 15 11:08:16 2023]  ? lockdep_hardirqs_on_prepare+0x13/0x230
> [Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
> [Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
> [Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
> [Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
> [Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
> [Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
> [Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
> [Wed Feb 15 11:08:16 2023]  ? exc_page_fault+0x8e/0x110
> [Wed Feb 15 11:08:16 2023]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [Wed Feb 15 11:08:16 2023] RIP: 0033:0x7f6912726c9b
> [Wed Feb 15 11:08:16 2023] Code: 73 01 c3 48 8b 0d 95 21 0f 00 f7 d8
> 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa
> b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 65 21 0f 00
> f7 d8 64 89 01 48
> [Wed Feb 15 11:08:16 2023] RSP: 002b:00007ffdc4bb6ec8 EFLAGS: 00000206
> ORIG_RAX: 00000000000000b0
> [Wed Feb 15 11:08:16 2023] RAX: ffffffffffffffda RBX: 0000563f8c228760
> RCX: 00007f6912726c9b
> [Wed Feb 15 11:08:16 2023] RDX: 000000000000000a RSI: 0000000000000800
> RDI: 0000563f8c2287c8
> [Wed Feb 15 11:08:16 2023] RBP: 0000000000000000 R08: 0000000000000000
> R09: 0000000000000000
> [Wed Feb 15 11:08:16 2023] R10: 00007f69127beac0 R11: 0000000000000206
> R12: 00007ffdc4bb7120
> [Wed Feb 15 11:08:16 2023] R13: 0000563f8c2282a0 R14: 00007ffdc4bb88f6
> R15: 0000563f8c228760
> [Wed Feb 15 11:08:16 2023]  </TASK>
> [Wed Feb 15 11:08:16 2023] Object 0x0000000094f20a7f @offset=21120
> [Wed Feb 15 11:08:16 2023] ------------[ cut here ]------------
> [Wed Feb 15 11:08:16 2023] kmem_cache_destroy cifs_inode_cache: Slab
> cache still has objects when called from exit_cifs+0x7e/0xc15 [cifs]
> [Wed Feb 15 11:08:16 2023] WARNING: CPU: 0 PID: 9331 at
> mm/slab_common.c:497 kmem_cache_destroy+0x15d/0x170
> [Wed Feb 15 11:08:16 2023] Modules linked in: cifs(OE-) mptcp_diag
> tcp_diag udp_diag raw_diag inet_diag unix_diag tls cmac nls_utf8
> cifs_arc4 rdma_cm iw_cm ib_cm ib_core cifs_md4 sunrpc binfmt_misc
> nls_iso8859_1 intel_rapl_msr intel_rapl_common rapl serio_raw
> hv_balloon hyperv_fb joydev mac_hid sch_fq_codel dm_multipath
> scsi_dh_rdac scsi_dh_emc scsi_dh_alua msr ramoops reed_solomon
> efi_pstore ip_tables x_tables autofs4 btrfs blake2b_generic raid10
> raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> raid6_pq libcrc32c raid1 raid0 multipath linear hyperv_drm
> drm_shmem_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
> hid_generic hv_storvsc hid_hyperv scsi_transport_fc drm hv_netvsc hid
> hv_utils hyperv_keyboard crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd
> hv_vmbus [last unloaded: cifs(OE)]
> [Wed Feb 15 11:08:16 2023] CPU: 0 PID: 9331 Comm: rmmod Tainted: G
> B   W  OE      6.2.0-rc5withkasan #19
> [Wed Feb 15 11:08:16 2023] Hardware name: Microsoft Corporation
> Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.0
> 12/17/2019
> [Wed Feb 15 11:08:16 2023] RIP: 0010:kmem_cache_destroy+0x15d/0x170
> [Wed Feb 15 11:08:16 2023] Code: 49 fa c3 ff e9 6f ff ff ff c3 cc cc
> cc cc 49 8b 54 24 60 48 8b 4d 08 48 c7 c6 40 75 36 91 48 c7 c7 00 a3
> c2 91 e8 46 12 28 01 <0f> 0b e9 47 ff ff ff 66 66 2e 0f 1f 84 00 00 00
> 00 00 90 90 90 90
> [Wed Feb 15 11:08:16 2023] RSP: 0018:ffff88819b6efd18 EFLAGS: 00010282
> [Wed Feb 15 11:08:16 2023] RAX: 0000000000000000 RBX: 000000004c020000
> RCX: 0000000000000000
> [Wed Feb 15 11:08:16 2023] RDX: 0000000000000001 RSI: 0000000000000004
> RDI: ffffed10336ddf95
> [Wed Feb 15 11:08:16 2023] RBP: ffff88819b6efd28 R08: ffffffff8f796e88
> R09: ffff8886841f080b
> [Wed Feb 15 11:08:16 2023] R10: ffffed10d083e101 R11: 0000000000000001
> R12: ffff888109415c80
> [Wed Feb 15 11:08:16 2023] R13: ffff88819b6efe28 R14: ffffffffc134a100
> R15: 0000000000000000
> [Wed Feb 15 11:08:16 2023] FS:  00007f6912e8dc40(0000)
> GS:ffff888684000000(0000) knlGS:0000000000000000
> [Wed Feb 15 11:08:16 2023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [Wed Feb 15 11:08:16 2023] CR2: 00007f8cf7051f40 CR3: 0000000172bdc002
> CR4: 00000000003706f0
> [Wed Feb 15 11:08:16 2023] Call Trace:
> [Wed Feb 15 11:08:16 2023]  <TASK>
> [Wed Feb 15 11:08:16 2023]  exit_cifs+0x7e/0xc15 [cifs]
> [Wed Feb 15 11:08:16 2023]  __do_sys_delete_module.constprop.0+0x258/0x410
> [Wed Feb 15 11:08:16 2023]  ? __pfx___do_sys_delete_module.constprop.0+0x10/0x10
> [Wed Feb 15 11:08:16 2023]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
> [Wed Feb 15 11:08:16 2023]  ? __pfx_mem_cgroup_handle_over_high+0x10/0x10
> [Wed Feb 15 11:08:16 2023]  ? lockdep_hardirqs_on_prepare+0x13/0x230
> [Wed Feb 15 11:08:16 2023]  ? trace_hardirqs_on+0x3d/0x130
> [Wed Feb 15 11:08:16 2023]  __x64_sys_delete_module+0x1f/0x30
> [Wed Feb 15 11:08:16 2023]  do_syscall_64+0x59/0x90
> [Wed Feb 15 11:08:16 2023]  ? lockdep_hardirqs_on_prepare+0x13/0x230
> [Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
> [Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
> [Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
> [Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
> [Wed Feb 15 11:08:16 2023]  ? syscall_exit_to_user_mode+0x37/0x50
> [Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
> [Wed Feb 15 11:08:16 2023]  ? do_syscall_64+0x69/0x90
> [Wed Feb 15 11:08:16 2023]  ? exc_page_fault+0x8e/0x110
> [Wed Feb 15 11:08:16 2023]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [Wed Feb 15 11:08:16 2023] RIP: 0033:0x7f6912726c9b
> [Wed Feb 15 11:08:16 2023] Code: 73 01 c3 48 8b 0d 95 21 0f 00 f7 d8
> 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa
> b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 65 21 0f 00
> f7 d8 64 89 01 48
> [Wed Feb 15 11:08:16 2023] RSP: 002b:00007ffdc4bb6ec8 EFLAGS: 00000206
> ORIG_RAX: 00000000000000b0
> [Wed Feb 15 11:08:16 2023] RAX: ffffffffffffffda RBX: 0000563f8c228760
> RCX: 00007f6912726c9b
> [Wed Feb 15 11:08:16 2023] RDX: 000000000000000a RSI: 0000000000000800
> RDI: 0000563f8c2287c8
> [Wed Feb 15 11:08:16 2023] RBP: 0000000000000000 R08: 0000000000000000
> R09: 0000000000000000
> [Wed Feb 15 11:08:16 2023] R10: 00007f69127beac0 R11: 0000000000000206
> R12: 00007ffdc4bb7120
> [Wed Feb 15 11:08:16 2023] R13: 0000563f8c2282a0 R14: 00007ffdc4bb88f6
> R15: 0000563f8c228760
> [Wed Feb 15 11:08:16 2023]  </TASK>
> [Wed Feb 15 11:08:16 2023] irq event stamp: 0
> [Wed Feb 15 11:08:16 2023] hardirqs last  enabled at (0):
> [<0000000000000000>] 0x0
> [Wed Feb 15 11:08:16 2023] hardirqs last disabled at (0):
> [<ffffffff8f72869a>] copy_process+0xeda/0x3960
> [Wed Feb 15 11:08:16 2023] softirqs last  enabled at (0):
> [<ffffffff8f72869a>] copy_process+0xeda/0x3960
> [Wed Feb 15 11:08:16 2023] softirqs last disabled at (0):
> [<0000000000000000>] 0x0
> [Wed Feb 15 11:08:16 2023] ---[ end trace 0000000000000000 ]---
>
>
> --
> Regards,
> Shyam
