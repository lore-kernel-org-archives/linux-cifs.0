Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8A8C433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Oct 2022 03:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJVDWP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJVDWO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 Oct 2022 23:22:14 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B7528E064
        for <linux-cifs@vger.kernel.org>; Fri, 21 Oct 2022 20:22:13 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id p7so3043907vsr.7
        for <linux-cifs@vger.kernel.org>; Fri, 21 Oct 2022 20:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IPS2fhNBFoBZylDMzfLPuRuS/XSVFRtA1MOsO2/tZ1w=;
        b=gnw19NfU0XELxppOTD2q+MKvsM6qSgKsz8b0g+kO2Lje3wV1Jrz0pTjFcZ/V1Vo3io
         zzw7cvrefgjH+HvspNIRitU2/PHhy6wXot0MdBuUaKOhUsBQFME9qP1xn0yg6KvbbhWy
         hWE7UdGYsRdntw5vaCZ5JJFc6pOfEpB+F7r9TPdSysaYVXdfZ/h/UE+ZZoU4bF35fcyD
         eo+z+sqNC8tiaGr2g/fwQOctzsRDY7pNfmftJPyApOUzM6sY60PE/JdBgDgDe0wVn1Pv
         cc+Vse47fdC3RYDmCV/vEys0RsgMZfMBohZz8iawt8r3g6+fzmDFqsBnRxb62BKNZi/I
         58sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IPS2fhNBFoBZylDMzfLPuRuS/XSVFRtA1MOsO2/tZ1w=;
        b=tmU68YWWEIxvfTIumDOJ+L1U/zdJQMyCU2/hxxPWByAnRMOMQ+wClThnGNcbZqOnn7
         oSLt7EsVYA1QSv1kVOq6HbLEsMoPHB7313r+EaXh8/O5utH5l+mFiDZLLrBwQVLFSh2h
         YN87FUHwbHuYUKys9ez72/VtxuuxKQ4itqPDlp2xRu/tQ0OOv1bkEiwjaAlbhWF286+h
         7wwTXgbqS2BvY3/Tkt+30WUozOVbKzJQk3W8GqJsyIxx3tGOidLWp3c8BCA1owf7PqxL
         aX5DxgDlwGev9u+jDedYlrw7Z4IGj4lrEFrh3sqW6BgaY9GEEoAx/eQuyQUHDVw3O86T
         NI4Q==
X-Gm-Message-State: ACrzQf05o5FEG+fLZI4R1C1nGCJc2X9Obm2iPeXnehaSQcKXrBJnKZm0
        SD9rbrDtMF6bR0F8mRJO5dQf3huDL/5rt224SFf5Yx9EFjU=
X-Google-Smtp-Source: AMsMyM4RBEDrytGlBmMMXFQL+IaeOdaG3jp+p2IKWNPCna+2yOLMO75v7S4Mx2278VoEEkP+prPaE7Wdw3veXqnDfho=
X-Received: by 2002:a67:ed59:0:b0:3aa:89d:23e0 with SMTP id
 m25-20020a67ed59000000b003aa089d23e0mr3448465vsp.61.1666408931808; Fri, 21
 Oct 2022 20:22:11 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 Oct 2022 22:22:00 -0500
Message-ID: <CAH2r5muVWCM2yUUZgS-Koknvy1Cc3tV-HBJe6wyRsN6PUFq5yQ@mail.gmail.com>
Subject: oops in fallocate
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed that xfstests (I think it is generic/650 but not 100%
certain) is logging multiple of these:

 1325.744923] CIFS: VFS: Send error in write = -28
[ 1326.134024] x86: Booting SMP configuration:
[ 1326.134027] smpboot: Booting Node 0 Processor 1 APIC 0x2
[ 1327.268582] smpboot: CPU 7 is now offline
[ 1327.511605] fsstress: page allocation failure: order:8,
mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO),
nodemask=(null),cpuset=/,mems_allowed=0
[ 1327.511613] CPU: 6 PID: 6580 Comm: fsstress Tainted: G           OE
     6.1.0-060100rc1-generic #202210162332
[ 1327.511615] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET65W (1.48 ) 08/01/2022
[ 1327.511617] Call Trace:
[ 1327.511618]  <TASK>
[ 1327.511620]  show_stack+0x4e/0x61
[ 1327.511624]  dump_stack_lvl+0x4a/0x6f
[ 1327.511627]  dump_stack+0x10/0x18
[ 1327.511629]  warn_alloc+0x164/0x190
[ 1327.511633]  __alloc_pages_slowpath.constprop.0+0x991/0xa20
[ 1327.511637]  __alloc_pages+0x31d/0x350
[ 1327.511640]  __kmalloc_large_node+0x4d/0xc0
[ 1327.511642]  kmalloc_large+0x22/0xc0
[ 1327.511645]  ? smb3_simple_falloc.isra.0+0x5d6/0x930 [cifs]
[ 1327.511682]  smb3_simple_falloc.isra.0+0x60c/0x930 [cifs]
[ 1327.511712]  smb3_fallocate+0x7a/0xb70 [cifs]
[ 1327.511742]  cifs_fallocate+0x59/0x80 [cifs]
[ 1327.511765]  vfs_fallocate+0x138/0x370
[ 1327.511768]  ioctl_preallocate+0xaf/0xe0
[ 1327.511771]  do_vfs_ioctl+0x8b2/0x8c0
[ 1327.511773]  ? __fget_light+0x9f/0x120
[ 1327.511776]  __x64_sys_ioctl+0x7d/0xe0
[ 1327.511778]  do_syscall_64+0x58/0x90
[ 1327.511780]  ? do_syscall_64+0x67/0x90
[ 1327.511781]  ? do_syscall_64+0x67/0x90
[ 1327.511783]  ? do_syscall_64+0x67/0x90
[ 1327.511784]  ? do_syscall_64+0x67/0x90
[ 1327.511786]  ? sysvec_apic_timer_interrupt+0x4b/0xd0
[ 1327.511788]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[ 1327.511790] RIP: 0033:0x7f6dff91aaff
[ 1327.511793] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24
10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00
00 0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25
28 00
[ 1327.511794] RSP: 002b:00007fff5f8b3b80 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 1327.511796] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6dff91aaff
[ 1327.511798] RDX: 00007fff5f8b3c00 RSI: 000000004030582a RDI: 000000000000000

Ideas?

-- 
Thanks,

Steve
