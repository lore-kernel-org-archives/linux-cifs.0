Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876EBC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 09:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ACAE6113D
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 09:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhKJJHr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 04:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhKJJHr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Nov 2021 04:07:47 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65EEC061764
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 01:04:59 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id 13so3889209ljj.11
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 01:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=AzfG3tpSveIZ67afQVcYDXfxw5kxWiT64y9SoThr6yQ=;
        b=B+MQAxRSnfXRR21GQV+rSst12ryA/uHI+/kVJyXxcWIQQ18+4WD6Bhv0Vu+uJCPEld
         otvX1ADPM4rlw7T0OIzeHG2gSHGQvycAi77w0FJQfg5y8FfZbMbLPU51aANeoEN0eFhb
         VYf0maNZsXiW/5EYNsxcInCzgQnJmBZgYdkFyz1CPyCNLcm3zDsEcm21Y9RnQyO5blJJ
         U/2WNuxBo395XHbc6coZsGm0nPLqOG0rcfoY+CEI2dQZ4/GQbZ1DtA9JlCD1cfnIcZPL
         rjmZXMpCstSECbCJaUo72QdOKfPyDym9uvFnNQfitZBcx3TcsaLP/DOXM9AHw32cJKec
         Xw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=AzfG3tpSveIZ67afQVcYDXfxw5kxWiT64y9SoThr6yQ=;
        b=iY16lkRHeApplT+ET+akFBJAnd1yM0lNxMcm+WhybYi/6V8OaWlleJD+jUSc6vvJO9
         CC7mVO/NBsDGx1DpA5T6bQetaMOEPnaeQ2kdVJn7BclZYkpgxFFs0/9y5PBIJHOSrJZ+
         H0JC3+xdsy2vrQK3CD8sGiupXhtPpKvvUkxV2Nl8T0sDD8fiOk+UGfDnqwZI+gpSfcaq
         psa4rfDO7M9AMeqohzJqr7zWWYg8zGgdGT/T85QPIeqXXn4Szuduuh3dqxuN18WY0bkR
         WiBf4YoUYSeHUqynEHYrtlRV/175fnvcQ0T6zxY09V/Qk/Fs3Utrg6F6HdwK/hHGXKmC
         G3zA==
X-Gm-Message-State: AOAM532DB5344MXIdGBblpq/PN8sXm6XoeoMEQyQQs/ujSflhxX2MTQc
        1ID1v4V0cssZQcV/76Kt1eW8hAP9gPZihGDOESMjTyWbkU0=
X-Google-Smtp-Source: ABdhPJziIiaD3cc0IOT9DlcoDFwYt5fcmGupQEE1nXHPNZm68VqsRpp2ePcgq4yrcpbHQsIplXHafurvVrs8sfSXf9Q=
X-Received: by 2002:a2e:7114:: with SMTP id m20mr14376269ljc.229.1636535097921;
 Wed, 10 Nov 2021 01:04:57 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Nov 2021 03:04:47 -0600
Message-ID: <CAH2r5mtVZg1jCCjGfeBgvcN-2iaSBODySkA-B51hx+hfYAatrg@mail.gmail.com>
Subject: oops in fscache
To:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I noticed that if I mount the same share twice (to different target
directories) I get the warning below.  Is that expected?

[  252.630353] CIFS: Attempting to mount \\localhost\test
[  252.633852] CIFS: VFS: res_id 0 create_time 0 serial_num -1431103150
[  265.070509] CIFS: Attempting to mount \\localhost\test
[  265.073639] CIFS: VFS: res_id 536871040 create_time 0 serial_num -1431103150
[  265.073655] FS-Cache: Duplicate cookie detected
[  265.073659] FS-Cache: O-cookie c=0000000a [p=00000008 fl=222 nc=0 na=1]
[  265.073667] FS-Cache: O-cookie d=000000002ca0ccf2{CIFS.super}
n=00000000bcb568a0
[  265.073675] FS-Cache: O-key=[4] '74657374'
[  265.073686] FS-Cache: N-cookie c=0000000b [p=00000008 fl=2 nc=0
na=1][  252.630353] CIFS: Attempting to mount \\localhost\test
[  252.633852] CIFS: VFS: res_id 0 create_time 0 serial_num -1431103150
[  265.070509] CIFS: Attempting to mount \\localhost\test
[  265.073639] CIFS: VFS: res_id 536871040 create_time 0 serial_num -1431103150
[  265.073655] FS-Cache: Duplicate cookie detected
[  265.073659] FS-Cache: O-cookie c=0000000a [p=00000008 fl=222 nc=0 na=1]
[  265.073667] FS-Cache: O-cookie d=000000002ca0ccf2{CIFS.super}
n=00000000bcb568a0
[  265.073675] FS-Cache: O-key=[4] '74657374'
[  265.073686] FS-Cache: N-cookie c=0000000b [p=00000008 fl=2 nc=0 na=1]
[  265.073693] FS-Cache: N-cookie d=000000002ca0ccf2{CIFS.super}
n=00000000bcb568a0
[  265.073698] FS-Cache: N-key=[4] '74657374'

[  265.073693] FS-Cache: N-cookie d=000000002ca0ccf2{CIFS.super}
n=00000000bcb568a0
[  265.073698] FS-Cache: N-key=[4] '74657374'

And then when I do unmount of the first it works, but unmount of the
second oopses.


[  395.748231] ------------[ cut here ]------------
[  395.748235] kernel BUG at fs/fscache/cookie.c:730!
[  395.748252] invalid opcode: 0000 [#1] SMP PTI
[  395.748265] CPU: 9 PID: 3940 Comm: umount Tainted: G           OE
  5.15.0-051500-generic #202110312130
[  395.748278] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET54W (1.37 ) 06/20/2020
[  395.748285] RIP: 0010:__fscache_disable_cookie.cold+0x10/0x3e [fscache]
[  395.748334] Code: 81 fc cc 0f b6 73 70 ba 01 00 00 00 48 c7 c7 18
c6 64 c1 e8 7b 81 fc cc 0f 0b 48 8b 73 20 48 c7 c7 60 c6 64 c1 e8 69
81 fc cc <0f> 0b 48 c7 c7 c8 cf 64 c1 e8 5b 81 fc cc 48 c7 c7 d6 cf 64
c1 e8
[  395.748346] RSP: 0018:ffffb4c381ee7c48 EFLAGS: 00010246
[  395.748359] RAX: 0000000000000031 RBX: ffff910337d4df30 RCX: 0000000000000000
[  395.748368] RDX: 0000000000000000 RSI: ffff910a7bc589c0 RDI: ffff910a7bc589c0
[  395.748377] RBP: ffffb4c381ee7cc0 R08: 0000000000000000 R09: ffffb4c381ee7a48
[  395.748385] R10: ffffb4c381ee7a40 R11: ffffffff8f956108 R12: 0000000000000000
[  395.748393] R13: 0000000000000000 R14: 0000000000000019 R15: 0000000000000000
[  395.748401] FS:  00007fe4482b0800(0000) GS:ffff910a7bc40000(0000)
knlGS:0000000000000000
[  395.748412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  395.748421] CR2: 0000562446871c08 CR3: 00000001ba3a2006 CR4: 00000000003706e0
[  395.748430] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  395.748437] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  395.748445] Call Trace:
[  395.748454]  ? kfree+0x346/0x3c0
[  395.748473]  ? cifs_crypto_secmech_release+0x155/0x170 [cifs]
[  395.748660]  __fscache_relinquish_cookie+0x50/0x100 [fscache]
[  395.748694]  cifs_fscache_release_client_cookie+0x2d/0x90 [cifs]
[  395.748892]  cifs_put_tcp_session+0xe7/0x180 [cifs]
[  395.749048]  cifs_put_smb_ses+0x156/0x3e0 [cifs]
[  395.749205]  cifs_put_tcon.part.0+0xdd/0x220 [cifs]
[  395.749360]  cifs_put_tlink+0x4a/0x70 [cifs]
[  395.749516]  cifs_umount+0x5b/0xb0 [cifs]
[  395.749671]  cifs_kill_sb+0x89/0xa0 [cifs]
[  395.749823]  deactivate_locked_super+0x3b/0xb0
[  395.749838]  deactivate_super+0x40/0x50
[  395.749850]  cleanup_mnt+0x146/0x1a0
[  395.749861]  __cleanup_mnt+0x12/0x20
[  395.749870]  task_work_run+0x6d/0xa0
[  395.749882]  exit_to_user_mode_loop+0x150/0x160
[  395.749896]  exit_to_user_mode_prepare+0x9c/0xb0
[  395.749908]  syscall_exit_to_user_mode+0x27/0x50
[  395.749921]  do_syscall_64+0x69/0xc0
[  395.749935]  ? irqentry_exit+0x19/0x30
[  395.749945]  ? exc_page_fault+0x89/0x160
[  395.749955]  ? asm_exc_page_fault+0x8/0x30
[  395.749968]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  395.749981] RIP: 0033:0x7fe4484d2a1b
[  395.749992] Code: 1b f4 0e 00 f7 d8 64 89 01 48 83 c8 ff c3 90 f3
0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 e1 f3 0e 00
f7 d8
[  395.750003] RSP: 002b:00007ffe50d84af8 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[  395.750017] RAX: 0000000000000000 RBX: 000055de5eefcc60 RCX: 00007fe4484d2a1b
[  395.750025] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055de5ef00910
[  395.750033] RBP: 000055de5eefca30 R08: 0000000000000000 R09: 00007ffe50d83880
[  395.750041] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  395.750048] R13: 000055de5ef00910 R14: 000055de5eefcb40 R15: 000055de5eefca30



[36461.874600] RIP: 0010:__fscache_disable_cookie.cold+0x10/0x3e [fscache]
[36461.874643] Code: c1 fe da 0f b6 73 70 ba 01 00 00 00 48 c7 c7 18
86 62 c1 e8 7b c1 fe da 0f 0b 48 8b 73 20 48 c7 c7 60 86 62 c1 e8 69
c1 fe da <0f> 0b 48 c7 c7 c8 8f 62 c1 e8 5b c1 fe da 48 c7 c7 d6 8f 62
c1 e8
[36461.874646] RSP: 0018:ffffaf6e8256bbd8 EFLAGS: 00010246
[36461.874648] RAX: 0000000000000031 RBX: ffff8dd26e381d80 RCX: 0000000000000000
[36461.874650] RDX: 0000000000000000 RSI: ffff8dd87bb189c0 RDI: ffff8dd87bb189c0
[36461.874651] RBP: ffffaf6e8256bc50 R08: 0000000000000000 R09: ffffaf6e8256b9d8
[36461.874653] R10: ffffaf6e8256b9d0 R11: ffffffff9d92f468 R12: 0000000000000000
[36461.874654] R13: 0000000000000000 R14: 0000000000000017 R15: 0000000000000000
[36461.874655] FS:  00007f6d6f3a1800(0000) GS:ffff8dd87bb00000(0000)
knlGS:0000000000000000
[36461.874657] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[36461.874659] CR2: 0000555ca5b280d0 CR3: 00000001828e8006 CR4: 00000000003706e0
[36461.874660] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[36461.874661] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000000040

--
Thanks,

Steve
