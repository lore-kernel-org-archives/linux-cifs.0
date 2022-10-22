Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BBBC04A95
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Oct 2022 18:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJVSWM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Oct 2022 14:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJVSWL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Oct 2022 14:22:11 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1581412E0E8
        for <linux-cifs@vger.kernel.org>; Sat, 22 Oct 2022 11:22:10 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id mx8so4010692qvb.8
        for <linux-cifs@vger.kernel.org>; Sat, 22 Oct 2022 11:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xJq9Mhsgg0Y56t8u/KTzivxmrLRVEF+0hJd7xwI/CjQ=;
        b=h4A/vOYPbgNuPmr+QMuFOUuMTolC/J2mApaWmizx9rAdTgBZ40AI4NdwbxFUtzyAez
         69fNtfi/urgUdZP3EHeqDum5VdlbPe37nd35GrqGmVDIkVt8+C6TfofyUt/6z12Y8OdS
         kEK8+ZyZvR3Gc2pHk5lBC3ymdZsq1uRFy/cGHPh7/p4l/Nbp7qWWoQywi+AXvl6oAPAY
         T97Ft47QYnOaKh/iNtfvInWvgMqErjtvIJDH7Wilkax6IkSvpHrYLGjxmQu6BYNv3poe
         XDRvdIFZ/Ma6gFnJRNFmYLDAR5PL9avTyUWCeZdOx8oOI6dNPpRaCSWbehNPwfQsDuR4
         WGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xJq9Mhsgg0Y56t8u/KTzivxmrLRVEF+0hJd7xwI/CjQ=;
        b=atw4djfxL69HkQdQvORst+/nF9OezaCYCf+bW/7uRF7xXwE9hE1OUIf/sx6fe/EZn0
         4/HBLVbCFsZGBuYjufxzD0hKb8Hj4zBJT+7G25a7/r+B4C1DCq07Aa2oRdaStICwlLa9
         jGbIi9Bkb/tTOYxPXxB6BuxwkoO8h/YqIopf6pP4rIzVp6Uhg2b1NJ9SlurQbTbIrfFh
         eHt6GCgfuqqiZDpf54o1q100qGC9P3mOjVOac0fwxvUBai81rNW80PdFMO76jOb6oxVE
         2nYSdhYT6JXraZWSpP1Om5azgT7MIWw6QBOWa0SacrN6L+xfl1CQxXsxmbPS++DN1/tb
         w+jQ==
X-Gm-Message-State: ACrzQf1uM7d1aNr9B+h9286DMEH+Rr1owNt3NnTrz810hyTzl7y40XPE
        DawCUGZ1+CEGLVuCYEsNDfRR76Wcx9iNDou9XPW2EO2/
X-Google-Smtp-Source: AMsMyM6OeL9Y9rzTqbMtV9AFeD4Zk2OIrTFFmmxREbq/zD8GT3EAsL7Ggg8hDCV4FiMsebPSlfDCmhChW6n4q2rI9qI=
X-Received: by 2002:a05:6102:23dc:b0:3a7:9b0c:aa8e with SMTP id
 x28-20020a05610223dc00b003a79b0caa8emr15000457vsr.60.1666462918118; Sat, 22
 Oct 2022 11:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221022073521.1660841-1-zhangxiaoxu5@huawei.com> <20221022073521.1660841-3-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221022073521.1660841-3-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 22 Oct 2022 13:21:47 -0500
Message-ID: <CAH2r5msWoNw0694UjqcOAhFwoFTdVwbUmgCA7MtCTbY-FbqujQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: Fix pages array leak when writedata alloc
 failed in cifs_writedata_alloc()
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        longli@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Good catch. Tentatively merged into cifs-2.6.git for-next pending testing.

On Sat, Oct 22, 2022 at 1:32 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> There is a memory leak when writedata alloc failed:
>
>   unreferenced object 0xffff888192364000 (size 8192):
>     comm "sync", pid 22839, jiffies 4297313967 (age 60.230s)
>     hex dump (first 32 bytes):
>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     backtrace:
>       [<0000000027de0814>] __kmalloc+0x4d/0x150
>       [<00000000b21e81ab>] cifs_writepages+0x35f/0x14a0
>       [<0000000076f7d20e>] do_writepages+0x10a/0x360
>       [<00000000d6a36edc>] filemap_fdatawrite_wbc+0x95/0xc0
>       [<000000005751a323>] __filemap_fdatawrite_range+0xa7/0xe0
>       [<0000000088afb0ca>] file_write_and_wait_range+0x66/0xb0
>       [<0000000063dbc443>] cifs_strict_fsync+0x80/0x5f0
>       [<00000000c4624754>] __x64_sys_fsync+0x40/0x70
>       [<000000002c0dc744>] do_syscall_64+0x35/0x80
>       [<0000000052f46bee>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> cifs_writepages+0x35f/0x14a0 is:
>   kmalloc_array at include/linux/slab.h:628
>   (inlined by) kcalloc at include/linux/slab.h:659
>   (inlined by) cifs_writedata_alloc at fs/cifs/file.c:2438
>   (inlined by) wdata_alloc_and_fillpages at fs/cifs/file.c:2527
>   (inlined by) cifs_writepages at fs/cifs/file.c:2705
>
> If writedata alloc failed in cifs_writedata_alloc(), the pages array
> should be freed.
>
> Fixes: 8e7360f67e75 ("CIFS: Add support for direct pages in wdata")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/file.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 87be0223a57a..cd9698209930 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2434,12 +2434,16 @@ cifs_writev_complete(struct work_struct *work)
>  struct cifs_writedata *
>  cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
>  {
> +       struct cifs_writedata *writedata = NULL;
>         struct page **pages =
>                 kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
> -       if (pages)
> -               return cifs_writedata_direct_alloc(pages, complete);
> +       if (pages) {
> +               writedata = cifs_writedata_direct_alloc(pages, complete);
> +               if (!writedata)
> +                       kvfree(pages);
> +       }
>
> -       return NULL;
> +       return writedata;
>  }
>
>  struct cifs_writedata *
> --
> 2.31.1
>


-- 
Thanks,

Steve
