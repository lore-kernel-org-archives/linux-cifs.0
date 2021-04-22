Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CC2C433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Apr 2021 22:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91B40608FE
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Apr 2021 22:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhDVWRe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Apr 2021 18:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbhDVWRc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Apr 2021 18:17:32 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA45C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 22 Apr 2021 15:16:56 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i3so29615944edt.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Apr 2021 15:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RKilX3qohNIwUEMirvtf+1d+omhXJdcQrgZYKoNJp6w=;
        b=MbN/2Yj5BE7OZau9swwA3wfBo9iuX8K3NNnJUbM3TEMYb7v53hoLjW2ohST69RmOGO
         l4S4Gws85sxhk2/C4jqCZ6YnUXilMrCQlHQbPPFw753ODKCxeeqykCnSvynu0Vq2dyud
         jOVfBzC+YPDShAwrxZ4QucLfQ2RZ4txuXKJ6ysBAOWgUBVClMEvXOMGEVcCDCHvwI5J8
         NdPGFgWC7IPxtoQkESyY1N32pHp5fPLyX0pORBk/eZLOIWWJ3/qhLmS46Z3dAOSzF9Z1
         Sr2Gx6U08SmDSuywgmbwmimPoS2kfnlAbWq4f2CMAJodBxRa8+PcNCPKZmeBOaAEp8FC
         VvSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RKilX3qohNIwUEMirvtf+1d+omhXJdcQrgZYKoNJp6w=;
        b=JUAsjtFRmOupMs+nDGfM1GTNCdQAMMBET1xrLpAqCq89gJlS3Dx5EhOinOmca6Ljxj
         Yb4ZIJPRFMENUsWN2TNRCJdNffxOtdZADhCbsJFN7TXCI+a9GkkK43U9Bena1J0CetU/
         RxRYOj7B0cLQ9peo3yvlw8XZZCUiaWd8F9DDLgIWXuhILiOENddKdvTgXUxLdCbE9XVQ
         hyq55yRbpfQ4OqKTB2L+f7RNjWFOJJiMqRU/wFdUc07DQm1tdaeSF/54nmYBdkpg7gKQ
         PnDi5WE0ldGkewmKJt9gPy7uRBW9d8yGieU2prFX6+a74t87A8Q9NZvCbNIpobChTZrk
         QEyQ==
X-Gm-Message-State: AOAM531kGB/yqJyfmbmjBZAm1eyonU1NPmufl2DfmKIYzbqu+RXfXpgT
        CAnwlZq0PtyGK3yYkghMFVv0Mre26nE5SNCj/cRhSF2y
X-Google-Smtp-Source: ABdhPJzzsgrUWsj44xBsBid89gMWkiLM77UdN1e32qlJ8XhsR1DUjr9302lwxTx9XqQmniH9iEaUeWX5Htw6I0NYiVU=
X-Received: by 2002:a50:ee0b:: with SMTP id g11mr790031eds.218.1619129814971;
 Thu, 22 Apr 2021 15:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210422221403.13617-1-ddiss@suse.de>
In-Reply-To: <20210422221403.13617-1-ddiss@suse.de>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 23 Apr 2021 08:16:43 +1000
Message-ID: <CAN05THTvRT8Hst0fGmzgSe5WgDct+oTvAxk=NuhvCt=2_NCzxQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix leak in cifs_smb3_do_mount() ctx
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by me

On Fri, Apr 23, 2021 at 8:14 AM David Disseldorp <ddiss@suse.de> wrote:
>
> cifs_smb3_do_mount() calls smb3_fs_context_dup() and then
> cifs_setup_volume_info(). The latter's subsequent smb3_parse_devname()
> call overwrites the cifs_sb->ctx->UNC string already dup'ed by
> smb3_fs_context_dup(), resulting in a leak. E.g.
>
> unreferenced object 0xffff888002980420 (size 32):
>   comm "mount", pid 160, jiffies 4294892541 (age 30.416s)
>   hex dump (first 32 bytes):
>     5c 5c 31 39 32 2e 31 36 38 2e 31 37 34 2e 31 30  \\192.168.174.10
>     34 5c 72 61 70 69 64 6f 2d 73 68 61 72 65 00 00  4\rapido-share..
>   backtrace:
>     [<00000000069e12f6>] kstrdup+0x28/0x50
>     [<00000000b61f4032>] smb3_fs_context_dup+0x127/0x1d0 [cifs]
>     [<00000000c6e3e3bf>] cifs_smb3_do_mount+0x77/0x660 [cifs]
>     [<0000000063467a6b>] smb3_get_tree+0xdf/0x220 [cifs]
>     [<00000000716f731e>] vfs_get_tree+0x1b/0x90
>     [<00000000491d3892>] path_mount+0x62a/0x910
>     [<0000000046b2e774>] do_mount+0x50/0x70
>     [<00000000ca7b64dd>] __x64_sys_mount+0x81/0xd0
>     [<00000000b5122496>] do_syscall_64+0x33/0x40
>     [<000000002dd397af>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> This change is a bandaid until the cifs_setup_volume_info() TODO and
> error handling issues are resolved.
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  fs/cifs/cifsfs.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 5ddd20b62484..34c125798ad3 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -834,6 +834,12 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
>                 goto out;
>         }
>
> +       /* cifs_setup_volume_info->smb3_parse_devname() redups UNC & prepath */
> +       kfree(cifs_sb->ctx->UNC);
> +       cifs_sb->ctx->UNC = NULL;
> +       kfree(cifs_sb->ctx->prepath);
> +       cifs_sb->ctx->prepath = NULL;
> +
>         rc = cifs_setup_volume_info(cifs_sb->ctx, NULL, old_ctx->UNC);
>         if (rc) {
>                 root = ERR_PTR(rc);
> --
> 2.26.2
>
