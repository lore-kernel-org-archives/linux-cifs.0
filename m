Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73805C4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Nov 2022 20:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiKSUIr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Nov 2022 15:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiKSUIo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Nov 2022 15:08:44 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B421414D3C
        for <linux-cifs@vger.kernel.org>; Sat, 19 Nov 2022 12:08:42 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b3so13387502lfv.2
        for <linux-cifs@vger.kernel.org>; Sat, 19 Nov 2022 12:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ypZLnWgcWIWwCSOSTMU0vzAfpI0RUIzYB4UqIyVRu94=;
        b=TROrTMvD9IacMhhI0z4uhL9OwK6Pkstw4e/XQgfbQWr19xAUynIdsAY0S34q+LrTP0
         SCSDj7k2pIpTaGbrwYZKFwYYed6nu2vUn3c7afdvXkdso+d23m83mnr7NjqyCXQAz/GY
         5r0GSCkMe2Nmx/DPbAi9SlIcfQm+pCPpusBv/Kh/sNGx4Hckj8OIwvRT545XLb7DgIXh
         QPM+KBsieyM6tchkW+OMt4tpHC6j6I7difox5JMZZg4dszGT8028ARV5ArWteT9vUq39
         T3igzmjAth0on8kI4Z2yB9Ssavlco0jHjDaYSNSq9fWQRhh4U/5xOvq7SljouevNO+i9
         eEpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ypZLnWgcWIWwCSOSTMU0vzAfpI0RUIzYB4UqIyVRu94=;
        b=4FzL4xLSd3bfOOkiCdWaWjSsMntyx/sFHq6R4Jfsp6rAC7dYG9kXd1iskwMnIqeTkr
         Ysyg1gt7rHZ+Yrue0H7bdee09N0s34R6OJl2CrhtmC8CdO+v6niZanuRoHYF/VYwypo0
         uqYdbnkRvFGMF2EV4SG447OUJeho/6ACI8vXM0R/ht4wmh+0WQAqk6nv6JPJ2x5Ebk+f
         ph4Qf+q+vIy33ksupb91w9/+bWc18RpW9GDwB2YaGFKDg3vQUdFN53gDnUtWO8VYopj3
         IsZP4shGZDPGQmTr8w4ewrk8MkRY3VBMZ6ECkUQTuBoYgfjOumNPcFqBel4FEqxCIsDP
         YQ6g==
X-Gm-Message-State: ANoB5plc0zXPLgA14O1lm28RP9lHnXb5JAcuRUdjaCxkMHi60C+CknKY
        zpdc/2o55yDe4FgbKmHMpmznW8BU3UhDHg/5jas=
X-Google-Smtp-Source: AA0mqf7R8oyb3kdActdz9PDEX5d/fYExpftgYIRxJwNRPh7t4k5p2E1S0Y2Zp94pD58DcU9+5/YXMqnnQLMEJK65bKE=
X-Received: by 2002:a05:6512:3e2a:b0:4ab:534b:1b2c with SMTP id
 i42-20020a0565123e2a00b004ab534b1b2cmr3785504lfv.426.1668888520903; Sat, 19
 Nov 2022 12:08:40 -0800 (PST)
MIME-Version: 1.0
References: <20221118031222.3072694-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221118031222.3072694-1-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Nov 2022 14:08:29 -0600
Message-ID: <CAH2r5mta=v_hWn6AvBawX_e5inKL8FNXxfY3-19ZeQvHJVK0JA@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: Fix OOB read in parse_server_interfaces()
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing and any
additional reviews

On Thu, Nov 17, 2022 at 8:07 PM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> There is a OOB read in when decode the server interfaces response:
>
>   BUG: KASAN: slab-out-of-bounds in parse_server_interfaces+0x9ca/0xb80
>   Read of size 4 at addr ffff8881711f2f98 by task mount.cifs/1402
>
>   CPU: 6 PID: 1402 Comm: mount.cifs Not tainted 6.1.0-rc5+ #69
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x34/0x44
>    print_report+0x171/0x472
>    kasan_report+0xad/0x130
>    kasan_check_range+0x145/0x1a0
>    parse_server_interfaces+0x9ca/0xb80
>    SMB3_request_interfaces+0x174/0x1e0
>    smb3_qfs_tcon+0x150/0x2a0
>    mount_get_conns+0x218/0x750
>    cifs_mount+0x103/0xd00
>    cifs_smb3_do_mount+0x1dd/0xcb0
>    smb3_get_tree+0x1d5/0x300
>    vfs_get_tree+0x41/0xf0
>    path_mount+0x9b3/0xdd0
>    __x64_sys_mount+0x190/0x1d0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
>   Allocated by task 1402:
>    kasan_save_stack+0x1e/0x40
>    kasan_set_track+0x21/0x30
>    __kasan_kmalloc+0x7a/0x90
>    __kmalloc_node_track_caller+0x60/0x140
>    kmemdup+0x22/0x50
>    SMB2_ioctl+0x58d/0x5d0
>    SMB3_request_interfaces+0xcd/0x1e0
>    smb3_qfs_tcon+0x150/0x2a0
>    mount_get_conns+0x218/0x750
>    cifs_mount+0x103/0xd00
>    cifs_smb3_do_mount+0x1dd/0xcb0
>    smb3_get_tree+0x1d5/0x300
>    vfs_get_tree+0x41/0xf0
>    path_mount+0x9b3/0xdd0
>    __x64_sys_mount+0x190/0x1d0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> It can be reproduce with mount.cifs over rdma.
>
> When decode ioctl(FSCTL_QUERY_NETWORK_INTERFACE_INFO) response complete,
> still try to decode the 'p->Next' check whether has interface not decode.
> Since no more data in the response, then OOB read occurred.
>
> Let's just check the bytes still not decode to determine whether has
> uncomplete interface in the response.
>
> Fixes: fe856be475f7 ("CIFS: parse and store info on iface queries")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
> v2: Update commit message and fixes tag.
>
>  fs/cifs/smb2ops.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 880cd494afea..39c7bee87556 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -673,8 +673,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
>                 goto out;
>         }
>
> -       /* Azure rounds the buffer size up 8, to a 16 byte boundary */
> -       if ((bytes_left > 8) || p->Next)
> +       if (bytes_left > 0)
>                 cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
>
>
> --
> 2.31.1
>


-- 
Thanks,

Steve
