Return-Path: <SRS0=j5Ui=VC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D85BC5B57D
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 09:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12ACF20843
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 09:38:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=carrier-im.20150623.gappssmtp.com header.i=@carrier-im.20150623.gappssmtp.com header.b="ncCXpEEa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfGEJim (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jul 2019 05:38:42 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:43616 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbfGEJim (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Jul 2019 05:38:42 -0400
Received: by mail-vs1-f66.google.com with SMTP id j26so3456334vsn.10
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2019 02:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=carrier-im.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=PSujgvV79LbwLd8ZRt2M3DuDxiwGYoO+oqWv1O/Jqc0=;
        b=ncCXpEEaiiUKy6fxyv9eBv4DMXGGjX/QATW18CFkGW7KYHBmXd0MDN6FJ1xhN5AQkK
         WEZCkiXNnZa0i0JEebMjarSVmGQtVnh9FgmuPSTX77oAlf+uuuY/xRa+2HjhRjmFHyxO
         1sRtMEe8mmYKz0iO4hTMRhYAPdHtrMWNRklt9fE36u/qfGc+SRL9hO+b6jlv3xdlsmbq
         ABe8zuLaJWvY/dpNd3vHu//x1hch4tufw35fw7y28ZVuz9Ol3pbVpYzfy9OapGnZJ9BQ
         UaGggZX1OMvyqd1dK0/5bnvu4VLsbRSO9NU9VWnzvBYdLu/zssiSw9oV6EcJdvpBDpsu
         gQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=PSujgvV79LbwLd8ZRt2M3DuDxiwGYoO+oqWv1O/Jqc0=;
        b=lMdA80cahdCgCH3T0odxVY/dH9bzaArwZqXPTt1o89u1hdNhNFchY+5hchqkuy+7Nq
         g8fCF0jdUYKuSs6kTa4Ka+3GMBe2kCrFnCHty0z3QSTZC3aN4Bgq1IQ4rZnIeg3pECUy
         weRz1bHnrHOF3Rvdrr+YuqmbiP2jB48Pu/DJ7B4/lBIhAC3eoiT9o8RpZFgKPA4i85ls
         KKNpbA9+OxdEtKZ2FjG3Ay7ZgR4U1/kUMS07y8gUbBkH8WqDxVKc9zI5N2bZyQeLl1AT
         jVltApE1zft9VI50axKkTN79QoPCO9dcUSBcVnPJoOPvOOBp+GIEnS5u0O3/rjofzMTB
         pXag==
X-Gm-Message-State: APjAAAWHM1g6kNvG41WI2mBBnYHuYU0+FV/JT4mNPOzpaxTEphA11zLc
        CgoNidfcWWheae89F5K7U20Qka+s9PztObGJoVltJPeLHZfatQ==
X-Google-Smtp-Source: APXvYqwl5iOdt9G3o/uwb9wnER98fl6KnL8Euj5besI5l55rUJv70RHoXIRBtUpzUS/1pgjQ7sP0zJ6X9sS5qaVB2A4=
X-Received: by 2002:a67:d410:: with SMTP id c16mr1616316vsj.61.1562319519937;
 Fri, 05 Jul 2019 02:38:39 -0700 (PDT)
MIME-Version: 1.0
From:   Luke Carrier <luke@carrier.im>
Date:   Fri, 5 Jul 2019 10:38:28 +0100
Message-ID: <CAPWvxscPxF-bEy8ybgT5fSjxNbA7tf1_mXEoo5LOr79qRoukmg@mail.gmail.com>
Subject: General protection faults in cifs_reconnect with Azure Files
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Please forgive the support request, but our attempts to escalate this via
Azure support haven't gotten very far.

We're running an Ubuntu mainline kernel on these hosts at the moment and are
willing to try running future mainline kernels to help test:

    $ cat /etc/*release
    DISTRIB_ID=Ubuntu
    DISTRIB_RELEASE=18.04
    DISTRIB_CODENAME=bionic
    DISTRIB_DESCRIPTION="Ubuntu 18.04.2 LTS"
    NAME="Ubuntu"
    VERSION="18.04.2 LTS (Bionic Beaver)"
    ID=ubuntu
    ID_LIKE=debian
    PRETTY_NAME="Ubuntu 18.04.2 LTS"
    VERSION_ID="18.04"
    HOME_URL="https://www.ubuntu.com/"
    SUPPORT_URL="https://help.ubuntu.com/"
    BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
    PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
    VERSION_CODENAME=bionic
    UBUNTU_CODENAME=bionic

    $ uname -a
    Linux lp-prod-combi0 5.2.0-050200rc7-generic #201906300430 SMP Sun
Jun 30 04:32:31 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

We're running 6 application servers which each have 5 Azure Files shares
mounted. Periodically we see the following in the kernel ring buffer, followed
by one of the mount points becoming inaccessible (note DISCONNECTED below).

    [  863.501076] general protection fault: 0000 [#1] SMP PTI
    [  863.504674] CPU: 0 PID: 1166 Comm: cifsd Not tainted
5.2.0-050200rc7-generic #201906300430
    [  863.504674] Hardware name: Microsoft Corporation Virtual
Machine/Virtual Machine, BIOS 090007  06/02/2017
    [  863.504674] RIP: 0010:cifs_reconnect+0x2ff/0xc40 [cifs]
    [  863.504674] Code: b7 f7 c2 da f6 05 64 05 0b 00 01 74 05 0f 1f
44 00 00 48 8b 7d a8 48 8b 07 49 89 c4 4c 39 f7 75 05 eb 2a 49 89 c4
48 8b 57 08 <48> 89 50 08 48 89 02 48 8b 47 48 48 89 3f 48 89 7f 08 e8
aa 84 fa
    [  863.504674] RSP: 0018:ffffbda3c1fa3d38 EFLAGS: 00010297
    [  863.551092] RAX: 21e5544f6ba67674 RBX: ffff99e9efdf6800 RCX:
0000000000000000
    [  863.551092] RDX: ffff99e91a831400 RSI: 0000000000000246 RDI:
ffff99e91a831400
    [  863.551092] RBP: ffffbda3c1fa3da0 R08: ffff99e9f20a5c00 R09:
0000000000000029
    [  863.551092] R10: 0000000000102da5 R11: 0000000000000000 R12:
21e5544f6ba67674
    [  863.551092] R13: ffff99e9efdf69c0 R14: ffffbda3c1fa3d48 R15:
ffff99e9ec019a00
    [  863.551092] FS:  0000000000000000(0000)
GS:ffff99e9f2400000(0000) knlGS:0000000000000000
    [  863.551092] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  863.551092] CR2: 00007fad6a304000 CR3: 00000002ab8b0004 CR4:
00000000003606f0
    [  863.551092] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
    [  863.551092] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
    [  863.551092] Call Trace:
    [  863.551092]  ? mempool_alloc_slab+0x19/0x20
    [  863.551092]  ? smb2_calc_size+0x72/0x160 [cifs]
    [  863.551092]  cifs_handle_standard+0x170/0x190 [cifs]
    [  863.551092]  smb3_receive_transform+0x2b0/0x740 [cifs]
    [  863.551092]  cifs_demultiplex_thread+0x249/0xbc0 [cifs]
    [  863.551092]  ? __switch_to_asm+0x34/0x70
    [  863.551092]  kthread+0x124/0x140
    [  863.551092]  ? cifs_handle_standard+0x190/0x190 [cifs]
    [  863.551092]  ? __kthread_parkme+0x70/0x70
    [  863.551092]  ret_from_fork+0x35/0x40
    [  863.551092] Modules linked in: binfmt_misc xt_owner
xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
iptable_security bpfilter arc4 md4 cmac nls_utf8 cifs ccm fscache
nls_iso8859_1 sb_edac intel_rapl_perf hv_balloon input_leds joydev
serio_raw mac_hid sch_fq_codel ib_iser rdma_cm iw_cm ib_cm ib_core
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables
x_tables autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1
raid0 multipath linear crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel hid_generic aes_x86_64 hid_hyperv
hyperv_keyboard crypto_simd hv_netvsc hv_utils hv_storvsc hid
scsi_transport_fc cryptd hyperv_fb glue_helper psmouse i2c_piix4
pata_acpi hv_vmbus floppy
    [  863.717962] ---[ end trace 0704863ed727667d ]---
    [  863.722689] RIP: 0010:cifs_reconnect+0x2ff/0xc40 [cifs]
    [  863.728117] Code: b7 f7 c2 da f6 05 64 05 0b 00 01 74 05 0f 1f
44 00 00 48 8b 7d a8 48 8b 07 49 89 c4 4c 39 f7 75 05 eb 2a 49 89 c4
48 8b 57 08 <48> 89 50 08 48 89 02 48 8b 47 48 48 89 3f 48 89 7f 08 e8
aa 84 fa
    [  863.747129] RSP: 0018:ffffbda3c1fa3d38 EFLAGS: 00010297
    [  863.751705] RAX: 21e5544f6ba67674 RBX: ffff99e9efdf6800 RCX:
0000000000000000
    [  863.757375] RDX: ffff99e91a831400 RSI: 0000000000000246 RDI:
ffff99e91a831400
    [  863.764302] RBP: ffffbda3c1fa3da0 R08: ffff99e9f20a5c00 R09:
0000000000000029
    [  863.771351] R10: 0000000000102da5 R11: 0000000000000000 R12:
21e5544f6ba67674
    [  863.777115] R13: ffff99e9efdf69c0 R14: ffffbda3c1fa3d48 R15:
ffff99e9ec019a00
    [  863.783435] FS:  0000000000000000(0000)
GS:ffff99e9f2400000(0000) knlGS:0000000000000000
    [  863.791343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  863.797087] CR2: 00007fad6a304000 CR3: 00000002ab8b0004 CR4:
00000000003606f0
    [  863.803622] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
    [  863.809918] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

Later, during shut down, we see the following:

    [ 7362.017756] BUG: unable to handle kernel NULL pointer
dereference at 0000000000000808
    [ 7362.029916] #PF error: [WRITE]
    [ 7362.029916] PGD 0 P4D 0
    [ 7362.029916] Oops: 0002 [#2] SMP PTI
    [ 7362.029916] CPU: 2 PID: 27282 Comm: umount Tainted: G      D
       5.1.0-050100-generic #201905052130
    [ 7362.029916] Hardware name: Microsoft Corporation Virtual
Machine/Virtual Machine, BIOS 090007  06/02/2017
    [ 7362.053217] RIP: 0010:_raw_spin_lock_irqsave+0x22/0x40
    [ 7362.053217] Code: 64 ff 5d c3 0f 1f 40 00 0f 1f 44 00 00 55 48
89 e5 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba
01 00 00 00 <f0> 0f b1 17 75 06 48 89 d8 5b 5d c3 89 c6 e8 7b 0c 6a ff
66 90 eb
    [ 7362.053217] RSP: 0000:ffff9bb28168bd20 EFLAGS: 00010046
    [ 7362.053217] RAX: 0000000000000000 RBX: 0000000000000286 RCX:
0000000080400037
    [ 7362.053217] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
0000000000000808
    [ 7362.053217] RBP: ffff9bb28168bd28 R08: 0000000000000000 R09:
ffffffffc0723d00
    [ 7362.053217] R10: ffff889c7158d800 R11: 0000000000000001 R12:
ffffffffc07adb98
    [ 7362.053217] R13: 0000000000000000 R14: 0000000000000001 R15:
0000000000000009
    [ 7362.053217] FS:  00007f973e272080(0000)
GS:ffff889c75c80000(0000) knlGS:0000000000000000
    [ 7362.053217] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 7362.125214] CR2: 0000000000000808 CR3: 000000028b40e004 CR4:
00000000003606e0
    [ 7362.125214] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
    [ 7362.125214] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
    [ 7362.125214] Call Trace:
    [ 7362.125214]  force_sig_info+0x2e/0xe0
    [ 7362.125214]  force_sig+0x16/0x20
    [ 7362.125214]  cifs_put_tcp_session+0xf5/0x120 [cifs]
    [ 7362.125214]  cifs_put_smb_ses+0x14f/0x4e0 [cifs]
    [ 7362.161231]  cifs_put_tcon.part.45+0xc1/0x1e0 [cifs]
    [ 7362.161231]  cifs_put_tlink+0x49/0x70 [cifs]
    [ 7362.161231]  cifs_umount+0x57/0xc0 [cifs]
    [ 7362.161231]  cifs_kill_sb+0x1e/0x30 [cifs]
    [ 7362.177657]  deactivate_locked_super+0x3a/0x80
    [ 7362.177657]  deactivate_super+0x51/0x60
    [ 7362.177657]  cleanup_mnt+0x3f/0x80
    [ 7362.177657]  __cleanup_mnt+0x12/0x20
    [ 7362.177657]  task_work_run+0x9d/0xc0
    [ 7362.177657]  exit_to_usermode_loop+0xf2/0x100
    [ 7362.177657]  do_syscall_64+0xda/0x110
    [ 7362.177657]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [ 7362.177657] RIP: 0033:0x7f973db398c7
    [ 7362.177657] Code: 95 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f
1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00
00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 91 95 2c 00 f7 d8 64
89 01 48
    [ 7362.177657] RSP: 002b:00007ffdf199a088 EFLAGS: 00000246
ORIG_RAX: 00000000000000a6
    [ 7362.177657] RAX: 0000000000000000 RBX: 0000556bb9680a40 RCX:
00007f973db398c7
    [ 7362.177657] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
0000556bb96819c0
    [ 7362.177657] RBP: 0000000000000000 R08: 0000556bb96812c0 R09:
0000000000000004
    [ 7362.177657] R10: 000000000000000b R11: 0000000000000246 R12:
0000556bb96819c0
    [ 7362.177657] R13: 00007f973e05b8a4 R14: 0000556bb9681b40 R15:
0000556bb7f3d0e0
    [ 7362.177657] Modules linked in: binfmt_misc xt_owner
xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
iptable_security bpfilter arc4 md4 cmac nls_utf8 cifs ccm fscache
nls_iso8859_1 sb_edac intel_rapl_perf input_leds serio_raw hv_balloon
joydev mac_hid sch_fq_codel ib_iser rdma_cm iw_cm ib_cm ib_core
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables
x_tables autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1
raid0 multipath linear crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel hid_generic aesni_intel hid_hyperv hv_netvsc
hv_utils hid hyperv_keyboard aes_x86_64 hv_storvsc crypto_simd
scsi_transport_fc cryptd glue_helperhyperv_fb psmouse i2c_piix4
pata_acpi hv_vmbus floppy
    [ 7362.317204] CR2: 0000000000000808
    [ 7362.317204] ---[ end trace 46b80f1e560d279a ]---
    [ 7362.317204] RIP: 0010:cifs_reconnect+0x2e1/0xc30 [cifs]
    [ 7362.317204] Code: 35 df 14 f0 f6 05 02 f5 0a 00 01 74 05 0f 1f
44 00 00 48 8b 7d a8 48 8b 07 49 89 c4 4c 39 f7 75 05 eb 2a 49 89 c4
48 8b 57 08 <48> 89 50 08 48 89 02 48 8b 47 48 48 89 3f 48 89 7f 08 e8
38 26 50
    [ 7362.317204] RSP: 0018:ffff9bb28176fd38 EFLAGS: 00010297
    [ 7362.317204] RAX: e2e73c7acd608da8 RBX: ffff889c72c7a000 RCX:
0000000000000000
    [ 7362.317204] RDX: ffff889b90912700 RSI: 0000000000000246 RDI:
ffff889b90912700
    [ 7362.317204] RBP: ffff9bb28176fda0 R08: ffff889c74490000 R09:
0000000000000090
    [ 7362.317204] R10: 0000000000385a61 R11: 0000000000000001 R12:
e2e73c7acd608da8
    [ 7362.317204] R13: ffff889c72c7a1c0 R14: ffff9bb28176fd48 R15:
ffff889c71031000
    [ 7362.317204] FS:  00007f973e272080(0000)
GS:ffff889c75c80000(0000) knlGS:0000000000000000
    [ 7362.317204] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 7362.317204] CR2: 0000000000000808 CR3: 000000028b40e004 CR4:
00000000003606e0
    [ 7362.317204] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
    [ 7362.317204] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

Mount configuration is as follows:

    $ mount | grep 'type cifs'
    //[storage account name].file.core.windows.net/[share 1] on [home
1]/data/base type cifs
(rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
1],uid=[uid 1],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
    //[storage account name].file.core.windows.net/[share 2] on [home
2]/data/base type cifs
(rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
2],uid=[uid 2],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
    //[storage account name].file.core.windows.net/[share 3] on [home
3]/data/base type cifs
(rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
3],uid=[uid 3],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
    //[storage account name].file.core.windows.net/[share 4] on [home
4]/data/base type cifs
(rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
4],uid=[uid 4],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
    //[storage account name].file.core.windows.net/[share 5] on [home
5]/data/base type cifs
(rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
5],uid=[uid 5],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)

What limited debugging information I know to provide:

    $ cat /proc/fs/cifs/Stats
    Resources in use
    CIFS Session: 5
    Share (unique mount targets): 10
    SMB Request/Response Buffer: 5 Pool size: 9
    SMB Small Req/Resp Buffer: 48 Pool size: 30
    Operations (MIDs): 0

    42 session 84 share reconnects
    Total vfs operations: 1836 maximum at one time: 10

    1) \\[storage account name].file.core.windows.net\[share 1]
    SMBs: 259
    Bytes read: 506972  Bytes written: 0
    Open files: 0 total (local), 0 open on server
    TreeConnects: 11 total 0 failed
    TreeDisconnects: 0 total 0 failed
    Creates: 77 total 0 failed
    Closes: 69 total 0 failed
    Flushes: 0 total 0 failed
    Reads: 11 total 0 failed
    Writes: 0 total 0 failed
    Locks: 0 total 0 failed
    IOCTLs: 11 total 1 failed
    QueryDirectories: 0 total 0 failed
    ChangeNotifies: 0 total 0 failed
    QueryInfos: 81 total 0 failed
    SetInfos: 0 total 0 failed
    OplockBreaks: 0 sent 0 failed
    2) \\[storage account name].file.core.windows.net\[share 2]    DISCONNECTED
    SMBs: 2372
    Bytes read: 24424415  Bytes written: 0
    Open files: 0 total (local), 0 open on server
    TreeConnects: 25 total 0 failed
    TreeDisconnects: 0 total 0 failed
    Creates: 731 total 0 failed
    Closes: 709 total 0 failed
    Flushes: 0 total 0 failed
    Reads: 148 total 0 failed
    Writes: 0 total 0 failed
    Locks: 0 total 0 failed
    IOCTLs: 25 total 1 failed
    QueryDirectories: 0 total 0 failed
    ChangeNotifies: 0 total 0 failed
    QueryInfos: 735 total 0 failed
    SetInfos: 0 total 0 failed
    OplockBreaks: 0 sent 0 failed
    3) \\[storage account name].file.core.windows.net\[share 3]
    SMBs: 20
    Bytes read: 0  Bytes written: 0
    Open files: 0 total (local), 0 open on server
    TreeConnects: 3 total 0 failed
    TreeDisconnects: 0 total 0 failed
    Creates: 4 total 0 failed
    Closes: 3 total 0 failed
    Flushes: 0 total 0 failed
    Reads: 0 total 0 failed
    Writes: 0 total 0 failed
    Locks: 0 total 0 failed
    IOCTLs: 3 total 1 failed
    QueryDirectories: 0 total 0 failed
    ChangeNotifies: 0 total 0 failed
    QueryInfos: 8 total 0 failed
    SetInfos: 0 total 0 failed
    OplockBreaks: 0 sent 0 failed
    4) \\[storage account name].file.core.windows.net\[share 4]
    SMBs: 1018
    Bytes read: 2225080  Bytes written: 0
    Open files: 0 total (local), 0 open on server
    TreeConnects: 11 total 0 failed
    TreeDisconnects: 0 total 0 failed
    Creates: 310 total 0 failed
    Closes: 303 total 0 failed
    Flushes: 0 total 0 failed
    Reads: 69 total 0 failed
    Writes: 0 total 0 failed
    Locks: 0 total 0 failed
    IOCTLs: 11 total 1 failed
    QueryDirectories: 0 total 0 failed
    ChangeNotifies: 0 total 0 failed
    QueryInfos: 314 total 0 failed
    SetInfos: 0 total 0 failed
    OplockBreaks: 1 sent 0 failed
    5) \\[storage account name].file.core.windows.net\[share 5]
    SMBs: 12
    Bytes read: 0  Bytes written: 0
    Open files: 0 total (local), 0 open on server
    TreeConnects: 1 total 0 failed
    TreeDisconnects: 0 total 0 failed
    Creates: 2 total 0 failed
    Closes: 1 total 0 failed
    Flushes: 0 total 0 failed
    Reads: 0 total 0 failed
    Writes: 0 total 0 failed
    Locks: 0 total 0 failed
    IOCTLs: 2 total 1 failed
    QueryDirectories: 0 total 0 failed
    ChangeNotifies: 0 total 0 failed
    QueryInfos: 6 total 0 failed
    SetInfos: 0 total 0 failed
    OplockBreaks: 0 sent 0 failed

    $ cat /proc/fs/cifs/DebugData
    Display Internal CIFS Data Structures for Debugging
    ---------------------------------------------------
    CIFS Version 2.20
    Features: DFS,FSCACHE,STATS,DEBUG,ALLOW_INSECURE_LEGACY,WEAK_PW_HASH,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
    CIFSMaxBufSize: 16384
    Active VFS Requests: 1
    Servers:
    Number of credits: 188 Dialect 0x300 signed
    1) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
Status: 1 TCP status: 1 Instance: 10
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
SessionId: 0x83e20c012c000701 encrypted signed
        Shares:
        0) IPC: \\[storage account name].file.core.windows.net\IPC$
Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
        tid: 0x5    Maximal Access: 0x12019f

        1) \\[storage account name].file.core.windows.net\[share 1]
Mounts: 1 DevInfo: 0x20 Attributes: 0xe
        PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0x83265083 Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
Partition Aligned,    Share Flags: 0x0
        tid: 0x1    Optimal sector size: 0x200    Maximal Access: 0x11f01ff

        MIDs:

    Number of credits: 509 Dialect 0x300 signed
    2) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
Status: 1 TCP status: 3 Instance: 24
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 2
SessionId: 0x84d10c0164000069 encrypted signed
        Shares:
        0) IPC: \\[storage account name].file.core.windows.net\IPC$
Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
        tid: 0x5    Maximal Access: 0x12019f    DISCONNECTED

        1) \\[storage account name].file.core.windows.net\[share 2]
Mounts: 1 DevInfo: 0x20 Attributes: 0xe
        PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0x412c087a Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
Partition Aligned,    Share Flags: 0x0
        tid: 0x1    Optimal sector size: 0x200    Maximal Access:
0x11f01ff    DISCONNECTED

        MIDs:

    Number of credits: 124 Dialect 0x300 signed
    3) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
Status: 1 TCP status: 1 Instance: 2
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
SessionId: 0x8291000264000049 encrypted signed
        Shares:
        0) IPC: \\[storage account name].file.core.windows.net\IPC$
Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
        tid: 0x5    Maximal Access: 0x12019f

        1) \\[storage account name].file.core.windows.net\[share 3]
Mounts: 1 DevInfo: 0x20 Attributes: 0xe
        PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0x5b29f8e4 Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
Partition Aligned,    Share Flags: 0x0
        tid: 0x1    Optimal sector size: 0x200    Maximal Access: 0x11f01ff

        MIDs:

    Number of credits: 298 Dialect 0x300 signed
    4) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
Status: 1 TCP status: 1 Instance: 10
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
SessionId: 0x8161000088000045 encrypted signed
        Shares:
        0) IPC: \\[storage account name].file.core.windows.net\IPC$
Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
        tid: 0x5    Maximal Access: 0x12019f

        1) \\[storage account name].file.core.windows.net\[share 4]
Mounts: 1 DevInfo: 0x20 Attributes: 0xe
        PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0x832fa96c Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
Partition Aligned,    Share Flags: 0x0
        tid: 0x1    Optimal sector size: 0x200    Maximal Access: 0x11f01ff

        MIDs:

    Number of credits: 185 Dialect 0x300 signed
    5) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
Status: 1 TCP status: 1 Instance: 1
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
SessionId: 0x809100009c00001d encrypted signed
        Shares:
        0) IPC: \\[storage account name].file.core.windows.net\IPC$
Mounts: 1 DevInfo: 0x0 Attributes: 0x0
        PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
        tid: 0x1    Maximal Access: 0x12019f

        1) \\[storage account name].file.core.windows.net\[share 5]
Mounts: 1 DevInfo: 0x20 Attributes: 0xe
        PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0xab3138f8 Encrypted
        Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
Partition Aligned,    Share Flags: 0x0
        tid: 0x5    Optimal sector size: 0x200    Maximal Access: 0x11f01ff

        MIDs:

Is there any other information I can provide to aid in troubleshooting?

Regards,
Luke
