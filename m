Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2336C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Mar 2022 11:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbiCJLCZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Mar 2022 06:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiCJLCX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Mar 2022 06:02:23 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF531405FC
        for <linux-cifs@vger.kernel.org>; Thu, 10 Mar 2022 03:01:21 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hw13so10760450ejc.9
        for <linux-cifs@vger.kernel.org>; Thu, 10 Mar 2022 03:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=CCxapD56hUDSNbttDGUvmP5kXDKmmetaOu0Kjihpvuc=;
        b=f+sdPKjUrcfqSD6qHSTEzLl19jl2IXjXKQp25uj8yUHsD5evo0uL/Ui0XN6B40ESR2
         F2VMdc6ZNEavFrVHpkwrZDd4c+E4maBzlyU+BX9rBwjm8NokZ+ueSwwj+iTDUVc9EgD2
         QBdxo/ssqsTd2J6cXiv0yJt+hqCXbGJTBtjnoj6d3WunYqQaHBvL04DiUy9YW1dvC/ON
         1UBpBYtPOkk219WqPjiH7Uqd7307Jhm/b1qPozqDUCWXYH4KHo5VSYaf26qZvBzKCXVC
         jfhoTeVgU8Z1p+aRGc9HKgu2Cmq6TDRboRwA0gCW3JtDMrVfQ60RjoZB8d2+E9x+t+aO
         67dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=CCxapD56hUDSNbttDGUvmP5kXDKmmetaOu0Kjihpvuc=;
        b=r6mkiBKtjzeJtxQ4Z0rXvrxMtYjxv23R456aph2XMA1gtfTgZaumwYh73gQC8ib0NV
         MODlkQMXxR0nG2vhMlNeKVNAUtPnW0n9SlOXf+nRWsnC+3EYBch0eZOxolierrpZY7ac
         +Ot012NUUld5jUZkAXZWhB2q9hkRtKcPrOoGwdBo4fcBfGWwM8GGpqrvDAu3PtIzceci
         aF8HfnVo9ljuG8hkJD9f4AC49qUqZlYu8YoR/GORbS4oMv6daoFaydB/8zYmoPtA0UkZ
         rOdtzkavRA2NCZ7jlbO95eq/iTICr2vuse7zl/5gJa0yyZ0mvLQ0TMDLmunXr9QlzltV
         g9qQ==
X-Gm-Message-State: AOAM530cBcjDFIp234l7m3n1ZIY4wh39PatKCt3a23rZrxC5A6yRG/q7
        xxGbxIhfOOlXL8sAvOkStXEfc8DXlJ65jqkDBoA5Ae+UUaDOsA==
X-Google-Smtp-Source: ABdhPJzyWiU0IPvhjUYfJS1WM93xh0ClPyYQJ7Kpdr+ZfhXQ2SHV8BC54Zmb4sz2Kh5HMy2BiTV2zuRMTlMzWnpUaNI=
X-Received: by 2002:a17:906:d1c4:b0:6d5:83bb:f58a with SMTP id
 bs4-20020a170906d1c400b006d583bbf58amr3754234ejb.672.1646910078251; Thu, 10
 Mar 2022 03:01:18 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 10 Mar 2022 16:31:07 +0530
Message-ID: <CANT5p=q_CB8jyr=ZncRwi+C47xzk-hvN0xL-AueOY=qB76+7-A@mail.gmail.com>
Subject: Invalid wait context in umount
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I saw this during testing on the buildbot VM. Is someone here able to
make sense of it?

[Thu Mar 10 04:53:54 2022] =============================
[Thu Mar 10 04:53:54 2022] [ BUG: Invalid wait context ]
[Thu Mar 10 04:53:54 2022] 5.17.0-rc7 #1 Not tainted
[Thu Mar 10 04:53:54 2022] -----------------------------
[Thu Mar 10 04:53:54 2022] umount/1363 is trying to lock:
[Thu Mar 10 04:53:54 2022] ffff9239c3ac77d8
(&ret_buf->crfid.fid_mutex){+.+.}-{3:3}, at: cifs_kill_sb+0x66/0xc0
[cifs]
[Thu Mar 10 04:53:54 2022] other info that might help us debug this:
[Thu Mar 10 04:53:54 2022] context-{4:4}
[Thu Mar 10 04:53:54 2022] 2 locks held by umount/1363:
[Thu Mar 10 04:53:54 2022]  #0: ffff9239c3ac20e0
(&type->s_umount_key#55){+.+.}-{3:3}, at: deactivate_super+0x33/0x50
[Thu Mar 10 04:53:54 2022]  #1: ffff9239c33bee20
(&cifs_sb->tlink_tree_lock){+.+.}-{2:2}, at: cifs_kill_sb+0x41/0xc0
[cifs]
[Thu Mar 10 04:53:54 2022] stack backtrace:
[Thu Mar 10 04:53:54 2022] CPU: 5 PID: 1363 Comm: umount Not tainted
5.17.0-rc7 #1
[Thu Mar 10 04:53:54 2022] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[Thu Mar 10 04:53:54 2022] Call Trace:
[Thu Mar 10 04:53:54 2022]  <TASK>
[Thu Mar 10 04:53:54 2022]  dump_stack_lvl+0x58/0x71
[Thu Mar 10 04:53:54 2022]  __lock_acquire+0x6c9/0x18d0
[Thu Mar 10 04:53:54 2022]  ? lock_is_held_type+0xec/0x140
[Thu Mar 10 04:53:54 2022]  lock_acquire+0x267/0x330
[Thu Mar 10 04:53:54 2022]  ? cifs_kill_sb+0x66/0xc0 [cifs]
[Thu Mar 10 04:53:54 2022]  ? cifs_kill_sb+0x66/0xc0 [cifs]
[Thu Mar 10 04:53:54 2022]  __mutex_lock+0x80/0x900
[Thu Mar 10 04:53:54 2022]  ? cifs_kill_sb+0x66/0xc0 [cifs]
[Thu Mar 10 04:53:54 2022]  ? cifs_kill_sb+0x66/0xc0 [cifs]
[Thu Mar 10 04:53:54 2022]  cifs_kill_sb+0x66/0xc0 [cifs]
[Thu Mar 10 04:53:54 2022]  deactivate_locked_super+0x3a/0x70
[Thu Mar 10 04:53:54 2022]  cleanup_mnt+0xb8/0x150
[Thu Mar 10 04:53:54 2022]  task_work_run+0x6a/0xa0
[Thu Mar 10 04:53:54 2022]  exit_to_user_mode_prepare+0x2a2/0x2b0
[Thu Mar 10 04:53:54 2022]  syscall_exit_to_user_mode+0x2c/0x60
[Thu Mar 10 04:53:54 2022]  do_syscall_64+0x46/0x80
[Thu Mar 10 04:53:54 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Thu Mar 10 04:53:54 2022] RIP: 0033:0x7f6cb771a54b
[Thu Mar 10 04:53:54 2022] Code: 29 0c 00 f7 d8 64 89 01 48 83 c8 ff
c3 66 90 f3 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa
b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0d 29 0c 00
f7 d8 64 89 01 48
[Thu Mar 10 04:53:54 2022] RSP: 002b:00007ffd96646e68 EFLAGS: 00000246
ORIG_RAX: 00000000000000a6
[Thu Mar 10 04:53:54 2022] RAX: 0000000000000000 RBX: 000056294dd2f970
RCX: 00007f6cb771a54b
[Thu Mar 10 04:53:54 2022] RDX: 0000000000000001 RSI: 0000000000000000
RDI: 000056294dd37780
[Thu Mar 10 04:53:54 2022] RBP: 0000000000000000 R08: 0000000000000000
R09: 0000000000000002
[Thu Mar 10 04:53:54 2022] R10: 000056294dd2f010 R11: 0000000000000246
R12: 000056294dd37780
[Thu Mar 10 04:53:54 2022] R13: 00007f6cb78d11a4 R14: 000056294dd2fb50
R15: 00007ffd966470d8
[Thu Mar 10 04:53:54 2022]  </TASK>


-- 
Regards,
Shyam
