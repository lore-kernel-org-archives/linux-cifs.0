Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E3ECDB47E
	for <linux-cifs@archiver.kernel.org>; Sat, 14 Oct 2023 03:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjJNDbJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Oct 2023 23:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbjJNDbI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Oct 2023 23:31:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B61BE
        for <linux-cifs@vger.kernel.org>; Fri, 13 Oct 2023 20:31:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A6EC433C7
        for <linux-cifs@vger.kernel.org>; Sat, 14 Oct 2023 03:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697254266;
        bh=O3LbQqg7dQxCV0tAM3KN8ReQP7CBRpKHjYHvzXCFMCo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=cCfqKL5ygQ2SUpQo3AOfdvdprNze+LqD3M0vXEnmLCjggPA83EjAPqtqxwYstrvn1
         1WmmlzuGDHe8bEOtF4hrl0mlR3ElkEifm30zuTFLVqcfz/xr/aXpbH75w+Z2qs9LHT
         TLpaZjVmFP9GHIZ8Ir/k0nkII1RxJnsrOCuNh6EdKSmNOIG9Yqqi/l+87twsmzhVKT
         0ss7RCcxfiZefTAi2uS51VllpfH5dxm+OJBeAyyNK+yzuv28UpWJo/Kq7/bU4WgXcP
         YZfFxXcKrFNawWlZ91dvL85DNzktFBnjB+7/q9y3ji6pm1pdPAPQk2UdmXOd7YDP3T
         sDk5bEWA9F1Zg==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-57b9231e91dso1545214eaf.2
        for <linux-cifs@vger.kernel.org>; Fri, 13 Oct 2023 20:31:06 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy/HRWR8+Ht4UhCma4mjb2h4OsPASogPpol+5VgUJzHii+gKXhj
        K3Sv+gDVi4GOIAftThmmvCQzMS4qUS21yeDWI+s=
X-Google-Smtp-Source: AGHT+IHW/pmdwMxXhqJb7gaA+IZAOzYzbAfdDdoFnfGBQbD/aD0tm079OYN2Ru8oNTo0n2FI4q2GufYpQirWN/0HUUA=
X-Received: by 2002:a4a:2a5a:0:b0:57b:63a6:306d with SMTP id
 x26-20020a4a2a5a000000b0057b63a6306dmr27285930oox.6.1697254265656; Fri, 13
 Oct 2023 20:31:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:7a42:0:b0:4fa:bc5a:10a5 with HTTP; Fri, 13 Oct 2023
 20:31:04 -0700 (PDT)
In-Reply-To: <20231012174349.462290-1-mmakassikis@freebox.fr>
References: <20231012174349.462290-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 14 Oct 2023 12:31:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8qRE6Ux2o9cGhOwGGjCr6Rp683ELOnQ5suJkE1ogsp3w@mail.gmail.com>
Message-ID: <CAKYAXd8qRE6Ux2o9cGhOwGGjCr6Rp683ELOnQ5suJkE1ogsp3w@mail.gmail.com>
Subject: Re: [PATCH] fs/smb: server: fix recursive locking in vfs helpers
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-10-13 2:43 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Running smb2.rename test from Samba smbtorture suite against a kernel built
> with lockdep triggers a "possible recursive locking detected" warning.
>
> This is because mnt_want_write() is called twice with no mnt_drop_write()
> in between:
>   -> ksmbd_vfs_mkdir()
>     -> ksmbd_vfs_kern_path_create()
>        -> kern_path_create()
>           -> filename_create()
>             -> mnt_want_write()
>        -> mnt_want_write()
>
> Fix this by removing the mnt_want_write/mnt_drop_write calls from vfs
> helpers that call kern_path_create().
>
> Full lockdep trace below:
>
> ============================================
> WARNING: possible recursive locking detected
> 6.6.0-rc5 #775 Not tainted
> --------------------------------------------
> kworker/1:1/32 is trying to acquire lock:
> ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: ksmbd_vfs_mkdir+0xe1/0x410
>
> but task is already holding lock:
> ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: filename_create+0xb6/0x260
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(sb_writers#5);
>   lock(sb_writers#5);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 4 locks held by kworker/1:1/32:
>  #0: ffff8880064e4138 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at:
> process_one_work+0x40e/0x980
>  #1: ffff888005b0fdd0 ((work_completion)(&work->work)){+.+.}-{0:0}, at:
> process_one_work+0x40e/0x980
>  #2: ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at:
> filename_create+0xb6/0x260
>  #3: ffff8880057ce760 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at:
> filename_create+0x123/0x260
>
> stack backtrace:
> CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 6.6.0-rc5 #775
> Workqueue: ksmbd-io handle_ksmbd_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4f/0x90
>  dump_stack+0x14/0x20
>  print_deadlock_bug+0x2f0/0x410
>  check_deadlock+0x26b/0x3b0
>  __lock_acquire+0xce2/0x1060
>  ? mark_lock.part.0+0xff/0x720
>  ? __pfx___lock_acquire+0x10/0x10
>  ? mark_held_locks+0x6b/0x90
>  lock_acquire.part.0+0x125/0x2d0
>  ? ksmbd_vfs_mkdir+0xe1/0x410
>  ? __pfx_lock_acquire.part.0+0x10/0x10
>  ? __kmem_cache_free+0x179/0x280
>  ? ____kasan_slab_free+0x15b/0x1d0
>  ? __kasan_slab_free+0x16/0x20
>  ? slab_free_freelist_hook+0xbc/0x180
>  lock_acquire+0x93/0x160
>  ? ksmbd_vfs_mkdir+0xe1/0x410
>  mnt_want_write+0x49/0x220
>  ? ksmbd_vfs_mkdir+0xe1/0x410
>  ksmbd_vfs_mkdir+0xe1/0x410
>  ? __pfx__printk+0x10/0x10
>  ? __pfx_ksmbd_vfs_mkdir+0x10/0x10
>  smb2_open+0x1064/0x38b0
>  ? __pfx___lock_acquire+0x10/0x10
>  ? __pfx_smb2_open+0x10/0x10
>  ? __lock_release+0x13f/0x290
>  ? smb2_validate_credit_charge+0x25d/0x360
>  ? __pfx___lock_release+0x10/0x10
>  ? do_raw_spin_lock+0x127/0x1c0
>  ? __pfx_do_raw_spin_lock+0x10/0x10
>  ? do_raw_spin_unlock+0xac/0x110
>  ? _raw_spin_unlock+0x22/0x50
>  ? smb2_validate_credit_charge+0x25d/0x360
>  ? ksmbd_smb2_check_message+0x3be/0x400
>  ? __pfx_ksmbd_smb2_check_message+0x10/0x10
>  __process_request+0x151/0x310
>  __handle_ksmbd_work+0x33c/0x520
>  ? __pfx___handle_ksmbd_work+0x10/0x10
>  handle_ksmbd_work+0x4a/0xd0
>  process_one_work+0x4a7/0x980
>  ? __pfx_process_one_work+0x10/0x10
>  ? assign_work+0xe1/0x120
>  worker_thread+0x365/0x570
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x18d/0x1d0
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x38/0x70
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1b/0x30
>  </TASK>
>
> Fixes: 40b268d384a2 ("ksmbd: add mnt_want_write to ksmbd vfs functions")
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Applied it to #ksmbd-for-next-next after updating the patch.

Thanks for your patch!
