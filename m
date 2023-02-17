Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC62C636D6
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 21:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjBQVQE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 16:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQVQD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 16:16:03 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697785BDB2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Feb 2023 13:16:02 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id z18so3405674lfd.0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Feb 2023 13:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yiFC/5dl9mN3Af8wjd0397xX6yHq5pD1SRM2uMNOPIs=;
        b=VnlQgfpcAl/chLj8NUBJFLD4g6PGs9NTvytHmvfwA8jHBqrQUOL316qHzZMjKMTOzk
         2vK+XTamOmFirz9YSHCXwQUP/1p3kdpPhbj3WZADFcwHDDb5OT/K40o6JBuFXxUvmRxA
         Xc3KSSgzxI4ncbf2VxnLXA5pLUNWydFqYUaSw97O4sNuC8JOW/g83bRx6TPZP+UCYDKI
         y0kxEOmiyOnaVi+CatUgarXgeP83cuc4TuuHF3vTAkHu8NfEEba+v4k2HM0ax4YQ3txC
         tLw3+BlJZ7L6qK9xvBu1mIl8DFEseQKNvWSbQ7uJ7lfJfEe/RZwdAfX51hBB3+z8pvNR
         x/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yiFC/5dl9mN3Af8wjd0397xX6yHq5pD1SRM2uMNOPIs=;
        b=De/vDzSbHOlDsBgxBr9kjuZ9Sqsy1t+4qauHgr5EFMZq3D5zV3U/tHVMzOoztdkSKY
         dwwmGDhkLUSKn3MIdgGMzRMaPFEaCInVEd329rwELfH6K0Tq9gWcmgXZoFMGOsszxuwL
         mf5cWpc72B2cNlh3cCBZD7gLCgzbnyJs4cu3fwwaDEh3VeFwHgr3GTeBKtVAd0srTGmD
         biLtToDj+xzJ/va0N81dJoPyTz5huio6fJTRgbmPiq432964+ReahkD+kUbiIdFIReP2
         LxQIQ7KepVBACpbzhpIcdYMN99slnVG6ITZvGAQenuUkRgmsy29dCTvqkuQ7EkGsVS6o
         c1oA==
X-Gm-Message-State: AO0yUKWxdkbokUp4gdArPhH9Xr7CloyCiKVEFfoMftOnJcwEFSCotvrM
        +6XKGkqEBAnJcjmlv74LaGDT8lzqVh9uHYIIrp0=
X-Google-Smtp-Source: AK7set+S48nwkU10FqVeTMvAb3C5D5lG2fwrx17xGYv24OxqiNQZ1l5ZkijtUprvXFDWPC1gsAxxMUBM99bwcFU+ndY=
X-Received: by 2002:ac2:5a11:0:b0:4db:2554:93a6 with SMTP id
 q17-20020ac25a11000000b004db255493a6mr764522lfn.10.1676668560301; Fri, 17 Feb
 2023 13:16:00 -0800 (PST)
MIME-Version: 1.0
References: <20221118084208.3214951-1-zhangxiaoxu5@huawei.com> <20221118084208.3214951-3-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221118084208.3214951-3-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Feb 2023 15:15:48 -0600
Message-ID: <CAH2r5mtvh0K5-eJqaX8KgUCMP4G_F=7ma_k38Oa2dP6GDKHdYA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: Fix warning and UAF when destroy the MR list
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        longli@microsoft.com, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dave Howells pointed out that around this line (2246 of fs/cifs/smbdirect.c)

           list_add_tail(&smbdirect_mr->list, &info->mr_list);

shouldn't there be locking on that?

On Fri, Nov 18, 2022 at 1:37 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> If the MR allocate failed, the MR recovery work not initialized
> and list not cleared. Then will be warning and UAF when release
> the MR:
>
>   WARNING: CPU: 4 PID: 824 at kernel/workqueue.c:3066 __flush_work.isra.0+0xf7/0x110
>   CPU: 4 PID: 824 Comm: mount.cifs Not tainted 6.1.0-rc5+ #82
>   RIP: 0010:__flush_work.isra.0+0xf7/0x110
>   Call Trace:
>    <TASK>
>    __cancel_work_timer+0x2ba/0x2e0
>    smbd_destroy+0x4e1/0x990
>    _smbd_get_connection+0x1cbd/0x2110
>    smbd_get_connection+0x21/0x40
>    cifs_get_tcp_session+0x8ef/0xda0
>    mount_get_conns+0x60/0x750
>    cifs_mount+0x103/0xd00
>    cifs_smb3_do_mount+0x1dd/0xcb0
>    smb3_get_tree+0x1d5/0x300
>    vfs_get_tree+0x41/0xf0
>    path_mount+0x9b3/0xdd0
>    __x64_sys_mount+0x190/0x1d0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
>   BUG: KASAN: use-after-free in smbd_destroy+0x4fc/0x990
>   Read of size 8 at addr ffff88810b156a08 by task mount.cifs/824
>   CPU: 4 PID: 824 Comm: mount.cifs Tainted: G        W          6.1.0-rc5+ #82
>   Call Trace:
>    dump_stack_lvl+0x34/0x44
>    print_report+0x171/0x472
>    kasan_report+0xad/0x130
>    smbd_destroy+0x4fc/0x990
>    _smbd_get_connection+0x1cbd/0x2110
>    smbd_get_connection+0x21/0x40
>    cifs_get_tcp_session+0x8ef/0xda0
>    mount_get_conns+0x60/0x750
>    cifs_mount+0x103/0xd00
>    cifs_smb3_do_mount+0x1dd/0xcb0
>    smb3_get_tree+0x1d5/0x300
>    vfs_get_tree+0x41/0xf0
>    path_mount+0x9b3/0xdd0
>    __x64_sys_mount+0x190/0x1d0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
>   Allocated by task 824:
>    kasan_save_stack+0x1e/0x40
>    kasan_set_track+0x21/0x30
>    __kasan_kmalloc+0x7a/0x90
>    _smbd_get_connection+0x1b6f/0x2110
>    smbd_get_connection+0x21/0x40
>    cifs_get_tcp_session+0x8ef/0xda0
>    mount_get_conns+0x60/0x750
>    cifs_mount+0x103/0xd00
>    cifs_smb3_do_mount+0x1dd/0xcb0
>    smb3_get_tree+0x1d5/0x300
>    vfs_get_tree+0x41/0xf0
>    path_mount+0x9b3/0xdd0
>    __x64_sys_mount+0x190/0x1d0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
>   Freed by task 824:
>    kasan_save_stack+0x1e/0x40
>    kasan_set_track+0x21/0x30
>    kasan_save_free_info+0x2a/0x40
>    ____kasan_slab_free+0x143/0x1b0
>    __kmem_cache_free+0xc8/0x330
>    _smbd_get_connection+0x1c6a/0x2110
>    smbd_get_connection+0x21/0x40
>    cifs_get_tcp_session+0x8ef/0xda0
>    mount_get_conns+0x60/0x750
>    cifs_mount+0x103/0xd00
>    cifs_smb3_do_mount+0x1dd/0xcb0
>    smb3_get_tree+0x1d5/0x300
>    vfs_get_tree+0x41/0xf0
>    path_mount+0x9b3/0xdd0
>    __x64_sys_mount+0x190/0x1d0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> Let's initialize the MR recovery work before MR allocate to prevent
> the warning, remove the MRs from the list to prevent the UAF.
>
> Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/smbdirect.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index a874c2e1ae41..7013fdb4ea51 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -2217,6 +2217,7 @@ static int allocate_mr_list(struct smbd_connection *info)
>         atomic_set(&info->mr_ready_count, 0);
>         atomic_set(&info->mr_used_count, 0);
>         init_waitqueue_head(&info->wait_for_mr_cleanup);
> +       INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
>         /* Allocate more MRs (2x) than hardware responder_resources */
>         for (i = 0; i < info->responder_resources * 2; i++) {
>                 smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
> @@ -2244,13 +2245,13 @@ static int allocate_mr_list(struct smbd_connection *info)
>                 list_add_tail(&smbdirect_mr->list, &info->mr_list);
>                 atomic_inc(&info->mr_ready_count);
>         }
> -       INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
>         return 0;
>
>  out:
>         kfree(smbdirect_mr);
>
>         list_for_each_entry_safe(smbdirect_mr, tmp, &info->mr_list, list) {
> +               list_del(&smbdirect_mr->list);
>                 ib_dereg_mr(smbdirect_mr->mr);
>                 kfree(smbdirect_mr->sgl);
>                 kfree(smbdirect_mr);
> --
> 2.31.1
>


-- 
Thanks,

Steve
