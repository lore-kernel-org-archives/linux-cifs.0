Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF536C4708E
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Jan 2023 01:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjAFB2A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 5 Jan 2023 20:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjAFB1i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 5 Jan 2023 20:27:38 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930B63225D
        for <linux-cifs@vger.kernel.org>; Thu,  5 Jan 2023 17:21:16 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id l184so222223vsc.0
        for <linux-cifs@vger.kernel.org>; Thu, 05 Jan 2023 17:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bZVfcYNGrcIA0zuT9dCvLyeprPvGGEgboYWjoRhrvss=;
        b=hdN59MhNjAoDnl7eeVyrQfC34BbbR7xGowHDyJTvzLUxXRIOj6+tcgQaYLRRbOCzQK
         8lHhj6X3Fb9q680+Nig76J61YCPcXXZyZHlG+U5/bRr+XQyNAOdaha+lY3y48WzEra53
         Z+yXlOG3BzPDx84ijoyWKpYUdkiv3aO3fLZLs9NtrrKF0GVcAfqFP1ZA6yRajCTyOm7+
         dn2GRCloGBseVeGqnQcgG47dYfhc50O+oPF0/1LOmSMJ1wuoJ8kWVIfrgnSpzsQNNARC
         bqvOM1TWH0m7zMzPxfMIHZTqrNBqM02taoI1jVZWtMYvGLgEpkWvRjCPme7az9VTBxZP
         FrVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bZVfcYNGrcIA0zuT9dCvLyeprPvGGEgboYWjoRhrvss=;
        b=ePP5ruhNcrWujgqC4ulcqHPdUaV2oOKxjVLe7OzfFzbwXJ1T7S3ZuH8ZdDDgGGLVOX
         T6/huoMbxa4vX/VSq/+IGcYMA/DrMYDGRmvJzwWATpzu/fr4AWup9/gLlXC///OjPVmi
         dkvJ0u0WUAUTWZ/L15bTLjB40aUTLYLfMNF8cOBI9HzrzK/bgMHxV7se9GBCLrhZur2C
         8EMKONRBCIzXQTDIVzMgoq+vpbAvgpgrGYyq88qMHdtS7ZbKveo9X0NvygWQgc8uQk33
         I+Bgg/ROfd1/FzJFzCqUUq2IfO7yDDNInRMkq4ExNy/u3g0DdHtLKiKcfVxs9N5k8zle
         c3sg==
X-Gm-Message-State: AFqh2krgu6mRxCQ5Gq0DHde99xN9uk3/PiKZxbWWUoSEOeTw4sCE2FGn
        vu9N0yJq/zBoXAS/o7stw0tjBAMAVKgWaQai5pkOWbD5g8o=
X-Google-Smtp-Source: AMrXdXuoXEw7VEVMqMAET+i/LVl6pSw1XNucBexVFy1oe3HRZAT3OwGfZHh6WUHxrO0to2KG5xgLkxlhocqOjPApTDM=
X-Received: by 2002:a05:6102:32d6:b0:3b5:3bd5:2a78 with SMTP id
 o22-20020a05610232d600b003b53bd52a78mr6482426vss.3.1672968073568; Thu, 05 Jan
 2023 17:21:13 -0800 (PST)
MIME-Version: 1.0
From:   Xiaoli Feng <fengxiaoli0714@gmail.com>
Date:   Fri, 6 Jan 2023 09:21:26 +0800
Message-ID: <CAOoqPcSqOZWN7LKmZQzPhu8MWxNsxYoDs2woHotE_te__+MF=w@mail.gmail.com>
Subject: CIFS: kernel BUG at mm/slub.c:435
To:     Steve French <sfrench@samba.org>, lsahlber@redhat.com,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Test the latest kernel in the branch for-next of
git://git.samba.org/sfrench/cifs-2.6.git. Kernel always panic when
mount cifs with option "-o sec=krb5,multiuser".

Bug 216878 - CIFS: kernel BUG at mm/slub.c:435
https://bugzilla.kernel.org/show_bug.cgi?id=216878

[332881.480892] kernel BUG at mm/slub.c:435!
[332881.481816] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[332881.482958] CPU: 0 PID: 144956 Comm: mount.cifs Kdump: loaded Not
tainted 6.2.0-rc1 #1
[332881.484714] Hardware name: Red Hat KVM, BIOS 1.15.0-1.el9 04/01/2014
[332881.486121] RIP: 0010:__kmem_cache_free+0x2bb/0x2e0
[332881.487231] Code: 5e e9 19 e8 ff ff 49 8b 46 08 f0 48 83 28 01 0f
85 96 fe ff ff 49 8b 46 08 4c 89 f7 48 8b 40 08 e8 4a 62 8c 00 e9 81
fe ff ff <0f> 0b 4c 8b 32 4d 85 f6 0f 85 1d fe ff ff e9 b2 fe ff ff 48
8b 15
[332881.491300] RSP: 0018:ffffa20cc33b7bb0 EFLAGS: 00010246
[332881.492472] RAX: ffff93dcb0bd0060 RBX: ffff93dcb0bd0060 RCX:
ffff93dcb0bd0070
[332881.494049] RDX: 00000000da820000 RSI: ffffebe380000000 RDI:
ffff93dc40042400
[332881.495584] RBP: ffff93dc40042400 R08: 0000000000000000 R09:
ffff93dcb0bd0060
[332881.497155] R10: ffffa20cc33b7a90 R11: ffffffffad3e4b48 R12:
ffffebe385c2f400
[332881.498709] R13: ffffffffc0f3c0a5 R14: ffff93dca323b800 R15:
ffff93dca323ba10
[332881.500267] FS:  00007f1798617780(0000) GS:ffff93dd1a600000(0000)
knlGS:0000000000000000
[332881.502038] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[332881.503324] CR2: 00007f2c31de1000 CR3: 000000010334e006 CR4:
0000000000370ef0
[332881.504889] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[332881.506463] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[332881.508024] Call Trace:
[332881.508608]  <TASK>
[332881.509118]  sesInfoFree+0x85/0x1a0 [cifs]
[332881.510347]  cifs_get_smb_ses+0x3ce/0x980 [cifs]
[332881.511468]  cifs_mount_get_session+0x65/0x1e0 [cifs]
[332881.512701]  dfs_mount_share+0x33/0x140 [cifs]
[332881.513840]  cifs_mount+0x60/0x2d0 [cifs]
[332881.514874]  cifs_smb3_do_mount+0xf8/0x310 [cifs]
[332881.516059]  smb3_get_tree+0x3d/0x70 [cifs]
[332881.517127]  vfs_get_tree+0x25/0xc0
[332881.518369]  do_new_mount+0x17a/0x310
[332881.519612]  __x64_sys_mount+0x107/0x140
[332881.520920]  do_syscall_64+0x5c/0x90
[332881.522184]  ? __do_sys_capset+0x14d/0x220
[332881.523498]  ? syscall_exit_work+0x103/0x130
[332881.524832]  ? syscall_exit_to_user_mode+0x12/0x30
[332881.526288]  ? do_syscall_64+0x69/0x90
[332881.527509]  ? exc_page_fault+0x62/0x150
[332881.528752]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[332881.530237] RIP: 0033:0x7f179843f7be
[332881.531420] Code: 48 8b 0d 65 a6 1b 00 f7 d8 64 89 01 48 83 c8 ff
c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 32 a6 1b 00 f7 d8 64 89
01 48
[332881.536167] RSP: 002b:00007ffe73666a18 EFLAGS: 00000206 ORIG_RAX:
00000000000000a5
[332881.538195] RAX: ffffffffffffffda RBX: 0000555761170eb0 RCX:
00007f179843f7be
[332881.540121] RDX: 000055575f65d473 RSI: 000055575f65d4da RDI:
00007ffe7366803b
[332881.542054] RBP: 0000000000000000 R08: 0000555761170eb0 R09:
0000000000000000
[332881.543983] R10: 0000000000000000 R11: 0000000000000206 R12:
00007ffe73668030
[332881.545903] R13: 00007f179862b000 R14: 00007f179862d90f R15:
0000555761171ee0
