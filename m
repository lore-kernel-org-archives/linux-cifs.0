Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22E5C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Nov 2022 14:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiKUOgC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Nov 2022 09:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiKUOf5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Nov 2022 09:35:57 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6095C6606
        for <linux-cifs@vger.kernel.org>; Mon, 21 Nov 2022 06:35:35 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4FDF27FCED;
        Mon, 21 Nov 2022 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1669041333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XBKuDngjgdpOnvzHCcOGS/+YCqcxuyseHSydEy5Mogc=;
        b=EMVG/dZXnO7PEgMkzhbGPZoV79sMy4P0PIYlkVfwwRh3fjpqpTBow2TM7HosyMk8r3IKad
        zG8rNnsYhBgH3C2QlKwVEhwf7xT9TnMXRSTqhs75CyEB6NNCy13SrRLOKiR+dWAGRiuH4A
        6ngLRkYFuYvr52lAhIKBYIJol7UJ49qJLQs9H8jDH8Ktlqwlv3FVuQcOglx+H+yvKde8XD
        McDdj/HMnH6KVLF+jRW6G90hfULoMvXBuGYpUvO2Ua5WunZWV91YJPArzVjAByGiKLgvmg
        XtjXRCcb2+vrZqXIhIUYL9FoAWBQiis8pptWaKC00a3eI0+LqjytQvrqqHHwEg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        zhangxiaoxu5@huawei.com, sfrench@samba.org, smfrench@gmail.com,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com
Subject: Re: [PATCH v2] cifs: Fix OOB read in parse_server_interfaces()
In-Reply-To: <20221118031222.3072694-1-zhangxiaoxu5@huawei.com>
References: <20221118031222.3072694-1-zhangxiaoxu5@huawei.com>
Date:   Mon, 21 Nov 2022 11:36:56 -0300
Message-ID: <875yf81iif.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:

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

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
