Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BF2C0650E
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 12:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45137213F2
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 12:32:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=carrier-im.20150623.gappssmtp.com header.i=@carrier-im.20150623.gappssmtp.com header.b="1JCBJjPc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfGFMci (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Jul 2019 08:32:38 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:40277 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGFMci (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Jul 2019 08:32:38 -0400
Received: by mail-vs1-f68.google.com with SMTP id a186so5379157vsd.7
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jul 2019 05:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=carrier-im.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5tqZenwoD51mdqTZkT9J/te3A95QzRnt5ZalI059V3U=;
        b=1JCBJjPcGwCfzSfJUMszQHHO7LoakRk0++6FPEa4XEZxlXY0jHwdQvfJx7aOi/W0w7
         02ycVgxCbXtmUeIRLDZBCTWfSMJKi6CvEXnrs3rAdwK4aGd081v2kGVnt+K7q+UQeuRh
         7IUUNONY9OBi1QFqEngnI11ljhZNwiLeBMfEBMaXn85L86PAbUSGNWczrNg5gkKJ7AwK
         jbL6QXHAih3+npSY21nDDJ3mUGMOywO1MNuHb0gKS5Zs4wdMnadYAJwocDeqroal78J+
         691qBcFHAIotV4FKoMQrxxGLoZ05wG1Z+2rYATodYJeo+BRyHPOIn1XUHBaD/Gwta0DT
         GTsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5tqZenwoD51mdqTZkT9J/te3A95QzRnt5ZalI059V3U=;
        b=dp18yduLN3raBesx61PTo4dAeZKIp2TOdz6unYj5KE6lHIir9fblnA2lKLHENwQcxI
         mqVOT1b9Tb6heS2EkThgkxsE0ot8PO7oOCpnWAzHj7PcN/h6HaRpKqwaUCZFP5gqy+z3
         59RdXHTg6D00rpiLBVIpZXscbBoshPro8o+4t85XVuSSg7YFcYGeP1t4oAuwe41CLwbM
         g7SxDnAxtDOl6GTAeAuB/VToZl62UZxrwuWe8W9m8dhHSsloTETNOloISAgQC08FQ+ld
         7sXvcKzlC+AdxmKm4W4gZCayKVIN21HI2GcOuJoJxkn46vfaGHLDjgapjZHvFf2P2qbP
         Bzbg==
X-Gm-Message-State: APjAAAX3Q8QlvNDghiBj3d+sWuj5ofRECszbSmgIC+c8RiuQBAk9HDXp
        N9Tu9xVL//H85IF1DPYyuzXSS4cYTUv05vQmiAXPAg==
X-Google-Smtp-Source: APXvYqxySuTP32iXY5W2mz1Y59J8M/GMHPa6nETlo2kZOd9o9k0W47N4H2+WXfE7+6cO+X7HtQuShdpYOdmtLIofr2Q=
X-Received: by 2002:a67:e355:: with SMTP id s21mr4867582vsm.12.1562416356400;
 Sat, 06 Jul 2019 05:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAPWvxscPxF-bEy8ybgT5fSjxNbA7tf1_mXEoo5LOr79qRoukmg@mail.gmail.com>
 <CAKywueQnekHWsAzo4s+5ON2W9siLiPh8G-FHB0aCN+xrgJt4vA@mail.gmail.com>
In-Reply-To: <CAKywueQnekHWsAzo4s+5ON2W9siLiPh8G-FHB0aCN+xrgJt4vA@mail.gmail.com>
From:   Luke Carrier <luke@carrier.im>
Date:   Sat, 6 Jul 2019 13:32:25 +0100
Message-ID: <CAPWvxsdTbq8jwTN+2syjsiZwCGGNMvmr+j8sS_ucnKe-TNLDzA@mail.gmail.com>
Subject: Re: General protection faults in cifs_reconnect with Azure Files
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

Thanks for the prompt response.

Under the 5.1.0 kernel we observed slightly different oopses, again
during reconnection:

[   64.118926] CIFS VFS: Send error in SessSetup = -11
[  107.638988] CIFS VFS: Send error in SessSetup = -11
[  138.487142] CIFS VFS: Send error in SessSetup = -11
[  148.599239] CIFS VFS: Send error in SessSetup = -11
[  186.685967] CIFS VFS: Send error in SessSetup = -11
[  193.450272] CIFS VFS: Send error in SessSetup = -11
[  364.918259] INFO: task kworker/3:2:271 blocked for more than 120 seconds.
[  364.924765]       Not tainted 5.1.0-050100-generic #201905052130
[  364.931458] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  364.939006] kworker/3:2     D    0   271      2 0x80000000
[  364.939043] Workqueue: cifsiod smb2_reconnect_server [cifs]
[  364.939049] Call Trace:
[  364.939057]  __schedule+0x2d3/0x840
[  364.939061]  ? wake_up_klogd+0x34/0x40
[  364.939063]  schedule+0x2c/0x70
[  364.939066]  schedule_preempt_disabled+0xe/0x10
[  364.939071]  __mutex_lock.isra.10+0x2e4/0x4c0
[  364.939074]  ? printk+0x58/0x6f
[  364.939079]  __mutex_lock_slowpath+0x13/0x20
[  364.939081]  mutex_lock+0x2c/0x30
[  364.939098]  smb2_reconnect.part.22+0xea/0x7c0 [cifs]
[  364.939103]  ? lock_timer_base+0x6b/0x90
[  364.939116]  ? cifs_put_tcon.part.45+0x162/0x1e0 [cifs]
[  364.939149]  smb2_reconnect_server+0x190/0x2a0 [cifs]
[  364.939154]  process_one_work+0x20f/0x410
[  364.939155]  worker_thread+0x34/0x400
[  364.939157]  kthread+0x120/0x140
[  364.939158]  ? process_one_work+0x410/0x410
[  364.939160]  ? __kthread_parkme+0x70/0x70
[  364.939161]  ret_from_fork+0x35/0x40
[  364.939184] INFO: task php-fpm7.2:1913 blocked for more than 120 seconds.
[  364.944595]       Not tainted 5.1.0-050100-generic #201905052130
[  364.949987] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  364.957078] php-fpm7.2      D    0  1913   1325 0x00000000
[  364.957079] Call Trace:
[  364.957083]  __schedule+0x2d3/0x840
[  364.957086]  ? __d_alloc+0x122/0x1d0
[  364.957090]  schedule+0x2c/0x70
[  364.957094]  d_alloc_parallel+0x3df/0x490
[  364.957096]  ? __switch_to_asm+0x34/0x70
[  364.957100]  ? wake_up_q+0x80/0x80
[  364.957105]  __lookup_slow+0x71/0x150
[  364.957107]  lookup_slow+0x3a/0x60
[  364.957108]  walk_component+0x1bf/0x330
[  364.957110]  ? link_path_walk.part.42+0x61/0x540
[  364.957112]  path_lookupat.isra.45+0x6d/0x220
[  364.957114]  filename_lookup.part.61+0xa0/0x170
[  364.957118]  ? __check_object_size+0x166/0x192
[  364.957121]  ? strncpy_from_user+0x56/0x1b0
[  364.957123]  user_path_at_empty+0x3e/0x50
[  364.957125]  vfs_statx+0x76/0xe0
[  364.957126]  __do_sys_newstat+0x3d/0x70
[  364.957129]  ? handle_mm_fault+0xe1/0x210
[  364.957133]  ? __do_page_fault+0x259/0x4b0
[  364.957136]  __x64_sys_newstat+0x16/0x20
[  364.957141]  do_syscall_64+0x5a/0x110
[  364.957145]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  364.957165] RIP: 0033:0x7f3a2ff5f775
[  364.957171] Code: Bad RIP value.
[  364.957171] RSP: 002b:00007ffdada63d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000004
[  364.957173] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f3a2ff5f775
[  364.957173] RDX: 00007ffdada63ed0 RSI: 00007ffdada63ed0 RDI: 00007f3a16eeff78
[  364.957174] RBP: 00007f3a16eeff78 R08: 000000000000ffff R09: 0000000000000020
[  364.957174] R10: 00007f3a2ffdd2e0 R11: 0000000000000246 R12: 0000000000000000
[  364.957175] R13: 00007ffdada63ed0 R14: 00000000fffffffb R15: 0000000000000000
[  364.957179] INFO: task php-fpm7.2:1926 blocked for more than 120 seconds.
[  364.963025]       Not tainted 5.1.0-050100-generic #201905052130
[  364.968886] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  364.976107] php-fpm7.2      D    0  1926   1325 0x00000000
[  364.976109] Call Trace:
[  364.976113]  __schedule+0x2d3/0x840
[  364.976115]  schedule+0x2c/0x70
[  364.976119]  schedule_preempt_disabled+0xe/0x10
[  364.976123]  __mutex_lock.isra.10+0x2e4/0x4c0
[  364.976127]  ? del_timer_sync+0x39/0x40
[  364.976130]  __mutex_lock_slowpath+0x13/0x20
[  364.976132]  mutex_lock+0x2c/0x30
[  364.976188]  smb2_reconnect.part.22+0xea/0x7c0 [cifs]
[  364.976210]  ? wait_woken+0x80/0x80
[  364.976223]  smb2_plain_req_init+0x3e/0x270 [cifs]
[  364.976238]  SMB2_open_init+0x69/0x760 [cifs]
[  364.976249]  ? cifs_get_inode_info+0x28f/0xb30 [cifs]
[  364.976263]  open_shroot+0x21e/0x4a0 [cifs]
[  364.976277]  smb2_query_path_info+0x133/0x1f0 [cifs]
[  364.976291]  ? smb2_query_path_info+0x133/0x1f0 [cifs]
[  364.976294]  ? _cond_resched+0x19/0x30
[  364.976297]  ? kmem_cache_alloc_trace+0x150/0x1d0
[  364.976308]  cifs_get_inode_info+0x2df/0xb30 [cifs]
[  364.976319]  ? build_path_from_dentry_optional_prefix+0xc4/0x400 [cifs]
[  364.976351]  cifs_revalidate_dentry_attr+0xd5/0x360 [cifs]
[  364.976362]  cifs_getattr+0x5a/0x1a0 [cifs]
[  364.976365]  vfs_getattr_nosec+0x98/0xc0
[  364.976366]  vfs_getattr+0x36/0x40
[  364.976368]  vfs_statx+0x8d/0xe0
[  364.976369]  __do_sys_newstat+0x3d/0x70
[  364.976370]  __x64_sys_newstat+0x16/0x20
[  364.976372]  do_syscall_64+0x5a/0x110
[  364.976374]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  364.976375] RIP: 0033:0x7f3a2ff5f775
[  364.976377] Code: Bad RIP value.
[  364.976378] RSP: 002b:00007ffdada62ec8 EFLAGS: 00000246 ORIG_RAX:
0000000000000004
[  364.976379] RAX: ffffffffffffffda RBX: 00007f3a16eeff78 RCX: 00007f3a2ff5f775
[  364.976379] RDX: 00007ffdada62ef0 RSI: 00007ffdada62ef0 RDI: 00007ffdada62f80
[  364.976380] RBP: 0000000000000021 R08: 0000000000c3dfc8 R09: 000000000000017b
[  364.976381] R10: 00007ffdada60e10 R11: 0000000000000246 R12: 00007ffdada62f81
[  364.976381] R13: 0000000000000000 R14: 00007ffdada62f99 R15: 00007ffdada62f80
[  364.976384] INFO: task php-fpm7.2:1933 blocked for more than 120 seconds.
[  364.981953]       Not tainted 5.1.0-050100-generic #201905052130
[  364.986915] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  364.993572] php-fpm7.2      D    0  1933   1325 0x80000000
[  364.993574] Call Trace:
[  364.993578]  __schedule+0x2d3/0x840
[  364.993598]  schedule+0x2c/0x70
[  364.993600]  schedule_preempt_disabled+0xe/0x10
[  364.993601]  __mutex_lock.isra.10+0x2e4/0x4c0
[  364.993603]  __mutex_lock_slowpath+0x13/0x20
[  364.993605]  mutex_lock+0x2c/0x30
[  364.993617]  cifs_mark_open_files_invalid+0x5b/0xa0 [cifs]
[  364.993633]  smb2_reconnect.part.22+0x131/0x7c0 [cifs]
[  364.993638]  ? kmem_cache_alloc_trace+0x150/0x1d0
[  364.993641]  ? char2uni+0x29/0x70 [nls_utf8]
[  364.993658]  smb2_plain_req_init+0x3e/0x270 [cifs]
[  364.993673]  SMB2_open_init+0x69/0x760 [cifs]
[  364.993687]  ? cifs_convert_path_to_utf16+0x7a/0xb0 [cifs]
[  364.993701]  smb2_compound_op+0x189/0x1930 [cifs]
[  364.993706]  ? prep_new_page+0x99/0x130
[  364.993709]  ? get_page_from_freelist+0xeed/0x1350
[  364.993711]  ? __alloc_pages_nodemask+0x16a/0x330
[  364.993724]  smb2_query_path_info+0xc8/0x1f0 [cifs]
[  364.993737]  ? smb2_query_path_info+0xc8/0x1f0 [cifs]
[  364.993740]  ? _cond_resched+0x19/0x30
[  364.993741]  ? kmem_cache_alloc_trace+0x150/0x1d0
[  364.993752]  cifs_get_inode_info+0x2df/0xb30 [cifs]
[  364.993753]  ? kmem_cache_alloc+0x15c/0x1c0
[  364.993795]  ? build_path_from_dentry_optional_prefix+0x12f/0x400 [cifs]
[  364.993819]  cifs_lookup+0xf3/0x7b0 [cifs]
[  364.993823]  __lookup_slow+0x9b/0x150
[  364.993825]  lookup_slow+0x3a/0x60
[  364.993826]  walk_component+0x1bf/0x330
[  364.993828]  ? link_path_walk.part.42+0x61/0x540
[  364.993830]  path_lookupat.isra.45+0x6d/0x220
[  364.993833]  filename_lookup.part.61+0xa0/0x170
[  364.993835]  ? __check_object_size+0x166/0x192
[  364.993837]  ? strncpy_from_user+0x56/0x1b0
[  364.993839]  user_path_at_empty+0x3e/0x50
[  364.993841]  vfs_statx+0x76/0xe0
[  364.993843]  __do_sys_newstat+0x3d/0x70
[  364.993845]  __x64_sys_newstat+0x16/0x20
[  364.993847]  do_syscall_64+0x5a/0x110
[  364.993850]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  364.993851] RIP: 0033:0x7f3a2ff5f775
[  364.993862] Code: Bad RIP value.
[  364.993862] RSP: 002b:00007ffdada63d48 EFLAGS: 00000246 ORIG_RAX:
0000000000000004
[  364.993864] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f3a2ff5f775
[  364.993865] RDX: 00007ffdada63ed0 RSI: 00007ffdada63ed0 RDI: 00007f3a16eeff78
[  364.993866] RBP: 00007f3a16eeff78 R08: 000000000000ffff R09: 0000000000000020
[  364.993867] R10: 00007f3a2ffdd2e0 R11: 0000000000000246 R12: 0000000000000000
[  364.993867] R13: 00007ffdada63ed0 R14: 00000000fffffffb R15: 0000000000000000

We had been experiencing different faults under 4.18 (the current stable in
Ubuntu 18.04 LTS), but had never seen a call trace that directly implicated
memory management. If it's worth sharing these oopses I can, but I suspect
it's better to work backwards through the Ubuntu mainline kernel images to
try and isolate this fault than to dig through fairly ancient kernels?

Cheers,
Luke

On Fri, 5 Jul 2019 at 23:27, Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> On Fri, Jul 5, 2019 at 02:59, Luke Carrier <luke@carrier.im>:
>
> >
> > Hi,
> >
> > Please forgive the support request, but our attempts to escalate this via
> > Azure support haven't gotten very far.
> >
> > We're running an Ubuntu mainline kernel on these hosts at the moment and are
> > willing to try running future mainline kernels to help test:
> >
> >     $ cat /etc/*release
> >     DISTRIB_ID=Ubuntu
> >     DISTRIB_RELEASE=18.04
> >     DISTRIB_CODENAME=bionic
> >     DISTRIB_DESCRIPTION="Ubuntu 18.04.2 LTS"
> >     NAME="Ubuntu"
> >     VERSION="18.04.2 LTS (Bionic Beaver)"
> >     ID=ubuntu
> >     ID_LIKE=debian
> >     PRETTY_NAME="Ubuntu 18.04.2 LTS"
> >     VERSION_ID="18.04"
> >     HOME_URL="https://www.ubuntu.com/"
> >     SUPPORT_URL="https://help.ubuntu.com/"
> >     BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
> >     PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
> >     VERSION_CODENAME=bionic
> >     UBUNTU_CODENAME=bionic
> >
> >     $ uname -a
> >     Linux lp-prod-combi0 5.2.0-050200rc7-generic #201906300430 SMP Sun
> > Jun 30 04:32:31 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
> >
> > We're running 6 application servers which each have 5 Azure Files shares
> > mounted. Periodically we see the following in the kernel ring buffer, followed
> > by one of the mount points becoming inaccessible (note DISCONNECTED below).
> >
> >     [  863.501076] general protection fault: 0000 [#1] SMP PTI
> >     [  863.504674] CPU: 0 PID: 1166 Comm: cifsd Not tainted
> > 5.2.0-050200rc7-generic #201906300430
> >     [  863.504674] Hardware name: Microsoft Corporation Virtual
> > Machine/Virtual Machine, BIOS 090007  06/02/2017
> >     [  863.504674] RIP: 0010:cifs_reconnect+0x2ff/0xc40 [cifs]
> >     [  863.504674] Code: b7 f7 c2 da f6 05 64 05 0b 00 01 74 05 0f 1f
> > 44 00 00 48 8b 7d a8 48 8b 07 49 89 c4 4c 39 f7 75 05 eb 2a 49 89 c4
> > 48 8b 57 08 <48> 89 50 08 48 89 02 48 8b 47 48 48 89 3f 48 89 7f 08 e8
> > aa 84 fa
> >     [  863.504674] RSP: 0018:ffffbda3c1fa3d38 EFLAGS: 00010297
> >     [  863.551092] RAX: 21e5544f6ba67674 RBX: ffff99e9efdf6800 RCX:
> > 0000000000000000
> >     [  863.551092] RDX: ffff99e91a831400 RSI: 0000000000000246 RDI:
> > ffff99e91a831400
> >     [  863.551092] RBP: ffffbda3c1fa3da0 R08: ffff99e9f20a5c00 R09:
> > 0000000000000029
> >     [  863.551092] R10: 0000000000102da5 R11: 0000000000000000 R12:
> > 21e5544f6ba67674
> >     [  863.551092] R13: ffff99e9efdf69c0 R14: ffffbda3c1fa3d48 R15:
> > ffff99e9ec019a00
> >     [  863.551092] FS:  0000000000000000(0000)
> > GS:ffff99e9f2400000(0000) knlGS:0000000000000000
> >     [  863.551092] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     [  863.551092] CR2: 00007fad6a304000 CR3: 00000002ab8b0004 CR4:
> > 00000000003606f0
> >     [  863.551092] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> >     [  863.551092] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > 0000000000000400
> >     [  863.551092] Call Trace:
> >     [  863.551092]  ? mempool_alloc_slab+0x19/0x20
> >     [  863.551092]  ? smb2_calc_size+0x72/0x160 [cifs]
> >     [  863.551092]  cifs_handle_standard+0x170/0x190 [cifs]
> >     [  863.551092]  smb3_receive_transform+0x2b0/0x740 [cifs]
> >     [  863.551092]  cifs_demultiplex_thread+0x249/0xbc0 [cifs]
> >     [  863.551092]  ? __switch_to_asm+0x34/0x70
> >     [  863.551092]  kthread+0x124/0x140
> >     [  863.551092]  ? cifs_handle_standard+0x190/0x190 [cifs]
> >     [  863.551092]  ? __kthread_parkme+0x70/0x70
> >     [  863.551092]  ret_from_fork+0x35/0x40
> >     [  863.551092] Modules linked in: binfmt_misc xt_owner
> > xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> > iptable_security bpfilter arc4 md4 cmac nls_utf8 cifs ccm fscache
> > nls_iso8859_1 sb_edac intel_rapl_perf hv_balloon input_leds joydev
> > serio_raw mac_hid sch_fq_codel ib_iser rdma_cm iw_cm ib_cm ib_core
> > iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables
> > x_tables autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov
> > async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1
> > raid0 multipath linear crct10dif_pclmul crc32_pclmul
> > ghash_clmulni_intel aesni_intel hid_generic aes_x86_64 hid_hyperv
> > hyperv_keyboard crypto_simd hv_netvsc hv_utils hv_storvsc hid
> > scsi_transport_fc cryptd hyperv_fb glue_helper psmouse i2c_piix4
> > pata_acpi hv_vmbus floppy
> >     [  863.717962] ---[ end trace 0704863ed727667d ]---
> >     [  863.722689] RIP: 0010:cifs_reconnect+0x2ff/0xc40 [cifs]
> >     [  863.728117] Code: b7 f7 c2 da f6 05 64 05 0b 00 01 74 05 0f 1f
> > 44 00 00 48 8b 7d a8 48 8b 07 49 89 c4 4c 39 f7 75 05 eb 2a 49 89 c4
> > 48 8b 57 08 <48> 89 50 08 48 89 02 48 8b 47 48 48 89 3f 48 89 7f 08 e8
> > aa 84 fa
> >     [  863.747129] RSP: 0018:ffffbda3c1fa3d38 EFLAGS: 00010297
> >     [  863.751705] RAX: 21e5544f6ba67674 RBX: ffff99e9efdf6800 RCX:
> > 0000000000000000
> >     [  863.757375] RDX: ffff99e91a831400 RSI: 0000000000000246 RDI:
> > ffff99e91a831400
> >     [  863.764302] RBP: ffffbda3c1fa3da0 R08: ffff99e9f20a5c00 R09:
> > 0000000000000029
> >     [  863.771351] R10: 0000000000102da5 R11: 0000000000000000 R12:
> > 21e5544f6ba67674
> >     [  863.777115] R13: ffff99e9efdf69c0 R14: ffffbda3c1fa3d48 R15:
> > ffff99e9ec019a00
> >     [  863.783435] FS:  0000000000000000(0000)
> > GS:ffff99e9f2400000(0000) knlGS:0000000000000000
> >     [  863.791343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     [  863.797087] CR2: 00007fad6a304000 CR3: 00000002ab8b0004 CR4:
> > 00000000003606f0
> >     [  863.803622] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> >     [  863.809918] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > 0000000000000400
> >
> > Later, during shut down, we see the following:
> >
> >     [ 7362.017756] BUG: unable to handle kernel NULL pointer
> > dereference at 0000000000000808
> >     [ 7362.029916] #PF error: [WRITE]
> >     [ 7362.029916] PGD 0 P4D 0
> >     [ 7362.029916] Oops: 0002 [#2] SMP PTI
> >     [ 7362.029916] CPU: 2 PID: 27282 Comm: umount Tainted: G      D
> >        5.1.0-050100-generic #201905052130
> >     [ 7362.029916] Hardware name: Microsoft Corporation Virtual
> > Machine/Virtual Machine, BIOS 090007  06/02/2017
> >     [ 7362.053217] RIP: 0010:_raw_spin_lock_irqsave+0x22/0x40
> >     [ 7362.053217] Code: 64 ff 5d c3 0f 1f 40 00 0f 1f 44 00 00 55 48
> > 89 e5 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba
> > 01 00 00 00 <f0> 0f b1 17 75 06 48 89 d8 5b 5d c3 89 c6 e8 7b 0c 6a ff
> > 66 90 eb
> >     [ 7362.053217] RSP: 0000:ffff9bb28168bd20 EFLAGS: 00010046
> >     [ 7362.053217] RAX: 0000000000000000 RBX: 0000000000000286 RCX:
> > 0000000080400037
> >     [ 7362.053217] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
> > 0000000000000808
> >     [ 7362.053217] RBP: ffff9bb28168bd28 R08: 0000000000000000 R09:
> > ffffffffc0723d00
> >     [ 7362.053217] R10: ffff889c7158d800 R11: 0000000000000001 R12:
> > ffffffffc07adb98
> >     [ 7362.053217] R13: 0000000000000000 R14: 0000000000000001 R15:
> > 0000000000000009
> >     [ 7362.053217] FS:  00007f973e272080(0000)
> > GS:ffff889c75c80000(0000) knlGS:0000000000000000
> >     [ 7362.053217] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     [ 7362.125214] CR2: 0000000000000808 CR3: 000000028b40e004 CR4:
> > 00000000003606e0
> >     [ 7362.125214] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> >     [ 7362.125214] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > 0000000000000400
> >     [ 7362.125214] Call Trace:
> >     [ 7362.125214]  force_sig_info+0x2e/0xe0
> >     [ 7362.125214]  force_sig+0x16/0x20
> >     [ 7362.125214]  cifs_put_tcp_session+0xf5/0x120 [cifs]
> >     [ 7362.125214]  cifs_put_smb_ses+0x14f/0x4e0 [cifs]
> >     [ 7362.161231]  cifs_put_tcon.part.45+0xc1/0x1e0 [cifs]
> >     [ 7362.161231]  cifs_put_tlink+0x49/0x70 [cifs]
> >     [ 7362.161231]  cifs_umount+0x57/0xc0 [cifs]
> >     [ 7362.161231]  cifs_kill_sb+0x1e/0x30 [cifs]
> >     [ 7362.177657]  deactivate_locked_super+0x3a/0x80
> >     [ 7362.177657]  deactivate_super+0x51/0x60
> >     [ 7362.177657]  cleanup_mnt+0x3f/0x80
> >     [ 7362.177657]  __cleanup_mnt+0x12/0x20
> >     [ 7362.177657]  task_work_run+0x9d/0xc0
> >     [ 7362.177657]  exit_to_usermode_loop+0xf2/0x100
> >     [ 7362.177657]  do_syscall_64+0xda/0x110
> >     [ 7362.177657]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >     [ 7362.177657] RIP: 0033:0x7f973db398c7
> >     [ 7362.177657] Code: 95 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f
> > 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00
> > 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 91 95 2c 00 f7 d8 64
> > 89 01 48
> >     [ 7362.177657] RSP: 002b:00007ffdf199a088 EFLAGS: 00000246
> > ORIG_RAX: 00000000000000a6
> >     [ 7362.177657] RAX: 0000000000000000 RBX: 0000556bb9680a40 RCX:
> > 00007f973db398c7
> >     [ 7362.177657] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
> > 0000556bb96819c0
> >     [ 7362.177657] RBP: 0000000000000000 R08: 0000556bb96812c0 R09:
> > 0000000000000004
> >     [ 7362.177657] R10: 000000000000000b R11: 0000000000000246 R12:
> > 0000556bb96819c0
> >     [ 7362.177657] R13: 00007f973e05b8a4 R14: 0000556bb9681b40 R15:
> > 0000556bb7f3d0e0
> >     [ 7362.177657] Modules linked in: binfmt_misc xt_owner
> > xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> > iptable_security bpfilter arc4 md4 cmac nls_utf8 cifs ccm fscache
> > nls_iso8859_1 sb_edac intel_rapl_perf input_leds serio_raw hv_balloon
> > joydev mac_hid sch_fq_codel ib_iser rdma_cm iw_cm ib_cm ib_core
> > iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables
> > x_tables autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov
> > async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1
> > raid0 multipath linear crct10dif_pclmul crc32_pclmul
> > ghash_clmulni_intel hid_generic aesni_intel hid_hyperv hv_netvsc
> > hv_utils hid hyperv_keyboard aes_x86_64 hv_storvsc crypto_simd
> > scsi_transport_fc cryptd glue_helperhyperv_fb psmouse i2c_piix4
> > pata_acpi hv_vmbus floppy
> >     [ 7362.317204] CR2: 0000000000000808
> >     [ 7362.317204] ---[ end trace 46b80f1e560d279a ]---
> >     [ 7362.317204] RIP: 0010:cifs_reconnect+0x2e1/0xc30 [cifs]
> >     [ 7362.317204] Code: 35 df 14 f0 f6 05 02 f5 0a 00 01 74 05 0f 1f
> > 44 00 00 48 8b 7d a8 48 8b 07 49 89 c4 4c 39 f7 75 05 eb 2a 49 89 c4
> > 48 8b 57 08 <48> 89 50 08 48 89 02 48 8b 47 48 48 89 3f 48 89 7f 08 e8
> > 38 26 50
> >     [ 7362.317204] RSP: 0018:ffff9bb28176fd38 EFLAGS: 00010297
> >     [ 7362.317204] RAX: e2e73c7acd608da8 RBX: ffff889c72c7a000 RCX:
> > 0000000000000000
> >     [ 7362.317204] RDX: ffff889b90912700 RSI: 0000000000000246 RDI:
> > ffff889b90912700
> >     [ 7362.317204] RBP: ffff9bb28176fda0 R08: ffff889c74490000 R09:
> > 0000000000000090
> >     [ 7362.317204] R10: 0000000000385a61 R11: 0000000000000001 R12:
> > e2e73c7acd608da8
> >     [ 7362.317204] R13: ffff889c72c7a1c0 R14: ffff9bb28176fd48 R15:
> > ffff889c71031000
> >     [ 7362.317204] FS:  00007f973e272080(0000)
> > GS:ffff889c75c80000(0000) knlGS:0000000000000000
> >     [ 7362.317204] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >     [ 7362.317204] CR2: 0000000000000808 CR3: 000000028b40e004 CR4:
> > 00000000003606e0
> >     [ 7362.317204] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> >     [ 7362.317204] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > 0000000000000400
> >
> > Mount configuration is as follows:
> >
> >     $ mount | grep 'type cifs'
> >     //[storage account name].file.core.windows.net/[share 1] on [home
> > 1]/data/base type cifs
> > (rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
> > 1],uid=[uid 1],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
> >     //[storage account name].file.core.windows.net/[share 2] on [home
> > 2]/data/base type cifs
> > (rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
> > 2],uid=[uid 2],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
> >     //[storage account name].file.core.windows.net/[share 3] on [home
> > 3]/data/base type cifs
> > (rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
> > 3],uid=[uid 3],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
> >     //[storage account name].file.core.windows.net/[share 4] on [home
> > 4]/data/base type cifs
> > (rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
> > 4],uid=[uid 4],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
> >     //[storage account name].file.core.windows.net/[share 5] on [home
> > 5]/data/base type cifs
> > (rw,relatime,vers=3.0,sec=ntlmsspi,cache=strict,username=[user
> > 5],uid=[uid 5],forceuid,gid=0,noforcegid,addr=[endpoint],file_mode=0755,dir_mode=0755,soft,persistenthandles,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,bsize=1048576,echo_interval=60,actimeo=1)
> >
> > What limited debugging information I know to provide:
> >
> >     $ cat /proc/fs/cifs/Stats
> >     Resources in use
> >     CIFS Session: 5
> >     Share (unique mount targets): 10
> >     SMB Request/Response Buffer: 5 Pool size: 9
> >     SMB Small Req/Resp Buffer: 48 Pool size: 30
> >     Operations (MIDs): 0
> >
> >     42 session 84 share reconnects
> >     Total vfs operations: 1836 maximum at one time: 10
> >
> >     1) \\[storage account name].file.core.windows.net\[share 1]
> >     SMBs: 259
> >     Bytes read: 506972  Bytes written: 0
> >     Open files: 0 total (local), 0 open on server
> >     TreeConnects: 11 total 0 failed
> >     TreeDisconnects: 0 total 0 failed
> >     Creates: 77 total 0 failed
> >     Closes: 69 total 0 failed
> >     Flushes: 0 total 0 failed
> >     Reads: 11 total 0 failed
> >     Writes: 0 total 0 failed
> >     Locks: 0 total 0 failed
> >     IOCTLs: 11 total 1 failed
> >     QueryDirectories: 0 total 0 failed
> >     ChangeNotifies: 0 total 0 failed
> >     QueryInfos: 81 total 0 failed
> >     SetInfos: 0 total 0 failed
> >     OplockBreaks: 0 sent 0 failed
> >     2) \\[storage account name].file.core.windows.net\[share 2]    DISCONNECTED
> >     SMBs: 2372
> >     Bytes read: 24424415  Bytes written: 0
> >     Open files: 0 total (local), 0 open on server
> >     TreeConnects: 25 total 0 failed
> >     TreeDisconnects: 0 total 0 failed
> >     Creates: 731 total 0 failed
> >     Closes: 709 total 0 failed
> >     Flushes: 0 total 0 failed
> >     Reads: 148 total 0 failed
> >     Writes: 0 total 0 failed
> >     Locks: 0 total 0 failed
> >     IOCTLs: 25 total 1 failed
> >     QueryDirectories: 0 total 0 failed
> >     ChangeNotifies: 0 total 0 failed
> >     QueryInfos: 735 total 0 failed
> >     SetInfos: 0 total 0 failed
> >     OplockBreaks: 0 sent 0 failed
> >     3) \\[storage account name].file.core.windows.net\[share 3]
> >     SMBs: 20
> >     Bytes read: 0  Bytes written: 0
> >     Open files: 0 total (local), 0 open on server
> >     TreeConnects: 3 total 0 failed
> >     TreeDisconnects: 0 total 0 failed
> >     Creates: 4 total 0 failed
> >     Closes: 3 total 0 failed
> >     Flushes: 0 total 0 failed
> >     Reads: 0 total 0 failed
> >     Writes: 0 total 0 failed
> >     Locks: 0 total 0 failed
> >     IOCTLs: 3 total 1 failed
> >     QueryDirectories: 0 total 0 failed
> >     ChangeNotifies: 0 total 0 failed
> >     QueryInfos: 8 total 0 failed
> >     SetInfos: 0 total 0 failed
> >     OplockBreaks: 0 sent 0 failed
> >     4) \\[storage account name].file.core.windows.net\[share 4]
> >     SMBs: 1018
> >     Bytes read: 2225080  Bytes written: 0
> >     Open files: 0 total (local), 0 open on server
> >     TreeConnects: 11 total 0 failed
> >     TreeDisconnects: 0 total 0 failed
> >     Creates: 310 total 0 failed
> >     Closes: 303 total 0 failed
> >     Flushes: 0 total 0 failed
> >     Reads: 69 total 0 failed
> >     Writes: 0 total 0 failed
> >     Locks: 0 total 0 failed
> >     IOCTLs: 11 total 1 failed
> >     QueryDirectories: 0 total 0 failed
> >     ChangeNotifies: 0 total 0 failed
> >     QueryInfos: 314 total 0 failed
> >     SetInfos: 0 total 0 failed
> >     OplockBreaks: 1 sent 0 failed
> >     5) \\[storage account name].file.core.windows.net\[share 5]
> >     SMBs: 12
> >     Bytes read: 0  Bytes written: 0
> >     Open files: 0 total (local), 0 open on server
> >     TreeConnects: 1 total 0 failed
> >     TreeDisconnects: 0 total 0 failed
> >     Creates: 2 total 0 failed
> >     Closes: 1 total 0 failed
> >     Flushes: 0 total 0 failed
> >     Reads: 0 total 0 failed
> >     Writes: 0 total 0 failed
> >     Locks: 0 total 0 failed
> >     IOCTLs: 2 total 1 failed
> >     QueryDirectories: 0 total 0 failed
> >     ChangeNotifies: 0 total 0 failed
> >     QueryInfos: 6 total 0 failed
> >     SetInfos: 0 total 0 failed
> >     OplockBreaks: 0 sent 0 failed
> >
> >     $ cat /proc/fs/cifs/DebugData
> >     Display Internal CIFS Data Structures for Debugging
> >     ---------------------------------------------------
> >     CIFS Version 2.20
> >     Features: DFS,FSCACHE,STATS,DEBUG,ALLOW_INSECURE_LEGACY,WEAK_PW_HASH,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
> >     CIFSMaxBufSize: 16384
> >     Active VFS Requests: 1
> >     Servers:
> >     Number of credits: 188 Dialect 0x300 signed
> >     1) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
> > Status: 1 TCP status: 1 Instance: 10
> >         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
> > SessionId: 0x83e20c012c000701 encrypted signed
> >         Shares:
> >         0) IPC: \\[storage account name].file.core.windows.net\IPC$
> > Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
> >         tid: 0x5    Maximal Access: 0x12019f
> >
> >         1) \\[storage account name].file.core.windows.net\[share 1]
> > Mounts: 1 DevInfo: 0x20 Attributes: 0xe
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0x83265083 Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
> > Partition Aligned,    Share Flags: 0x0
> >         tid: 0x1    Optimal sector size: 0x200    Maximal Access: 0x11f01ff
> >
> >         MIDs:
> >
> >     Number of credits: 509 Dialect 0x300 signed
> >     2) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
> > Status: 1 TCP status: 3 Instance: 24
> >         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 2
> > SessionId: 0x84d10c0164000069 encrypted signed
> >         Shares:
> >         0) IPC: \\[storage account name].file.core.windows.net\IPC$
> > Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
> >         tid: 0x5    Maximal Access: 0x12019f    DISCONNECTED
> >
> >         1) \\[storage account name].file.core.windows.net\[share 2]
> > Mounts: 1 DevInfo: 0x20 Attributes: 0xe
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0x412c087a Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
> > Partition Aligned,    Share Flags: 0x0
> >         tid: 0x1    Optimal sector size: 0x200    Maximal Access:
> > 0x11f01ff    DISCONNECTED
> >
> >         MIDs:
> >
> >     Number of credits: 124 Dialect 0x300 signed
> >     3) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
> > Status: 1 TCP status: 1 Instance: 2
> >         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
> > SessionId: 0x8291000264000049 encrypted signed
> >         Shares:
> >         0) IPC: \\[storage account name].file.core.windows.net\IPC$
> > Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
> >         tid: 0x5    Maximal Access: 0x12019f
> >
> >         1) \\[storage account name].file.core.windows.net\[share 3]
> > Mounts: 1 DevInfo: 0x20 Attributes: 0xe
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0x5b29f8e4 Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
> > Partition Aligned,    Share Flags: 0x0
> >         tid: 0x1    Optimal sector size: 0x200    Maximal Access: 0x11f01ff
> >
> >         MIDs:
> >
> >     Number of credits: 298 Dialect 0x300 signed
> >     4) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
> > Status: 1 TCP status: 1 Instance: 10
> >         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
> > SessionId: 0x8161000088000045 encrypted signed
> >         Shares:
> >         0) IPC: \\[storage account name].file.core.windows.net\IPC$
> > Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
> >         tid: 0x5    Maximal Access: 0x12019f
> >
> >         1) \\[storage account name].file.core.windows.net\[share 4]
> > Mounts: 1 DevInfo: 0x20 Attributes: 0xe
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0x832fa96c Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
> > Partition Aligned,    Share Flags: 0x0
> >         tid: 0x1    Optimal sector size: 0x200    Maximal Access: 0x11f01ff
> >
> >         MIDs:
> >
> >     Number of credits: 185 Dialect 0x300 signed
> >     5) Name: [endpoint] Uses: 1 Capability: 0x300077    Session
> > Status: 1 TCP status: 1 Instance: 1
> >         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
> > SessionId: 0x809100009c00001d encrypted signed
> >         Shares:
> >         0) IPC: \\[storage account name].file.core.windows.net\IPC$
> > Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY,    Share Flags: 0x30
> >         tid: 0x1    Maximal Access: 0x12019f
> >
> >         1) \\[storage account name].file.core.windows.net\[share 5]
> > Mounts: 1 DevInfo: 0x20 Attributes: 0xe
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0xab3138f8 Encrypted
> >         Share Capabilities: CONTINUOUS AVAILABILITY, Aligned,
> > Partition Aligned,    Share Flags: 0x0
> >         tid: 0x5    Optimal sector size: 0x200    Maximal Access: 0x11f01ff
> >
> >         MIDs:
> >
> > Is there any other information I can provide to aid in troubleshooting?
> >
> > Regards,
> > Luke
>
> Hi Luke,
>
> Thanks for reporting the issue.
>
> There was a bunch of code changes that went to the cifs module
> recently that may be a reason for memory problems you are reporting.
> Did you try your workload on any older kernels (e.g. 4.19, 4.20 or
> 5.0) ? If yes, please provide kernel versions to help narrowing down
> the problem.
>
> --
> Best regards,
> Pavel Shilovsky
