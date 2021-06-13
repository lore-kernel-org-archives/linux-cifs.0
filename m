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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA36C48BDF
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Jun 2021 23:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C85E61159
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Jun 2021 23:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhFMXh4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Jun 2021 19:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbhFMXhz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Jun 2021 19:37:55 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B31FC061574;
        Sun, 13 Jun 2021 16:35:44 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j2so17894726lfg.9;
        Sun, 13 Jun 2021 16:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pLASACZgoEcl1P3pbbsnivd00oF00ItQz/xXGbfD/EQ=;
        b=N8yCzvNIgGxKzDVHLs6pGnODwSmKhFqbrXx7BeqkOGVqxPFVXrHPsx25dEJnz4R2ir
         2l7YB6osG/lUkbOXtobn3Fg3xvIgcDDA/6sBX0pOf/U7/DjjTSvA++JEjLQWj87wcv3G
         Va137eXEb97CBLGkVw8XnswjjxV0fBOVrvke1gJxDl40qWrIs2bjqGapG0kXISPuxKYD
         H0+JatL1I3IoYJK4bZW13sdimWAYaKqwHLRq6AD3R8KadOcC1YEJ3S9hr4Q9DzrzbEMF
         Xo4xe4m8GCxXJTWtrql5iTDFo4Xl0rDbmLWlPfelnp/ntLguOR5Q/9K0CVS6DHQm733w
         30/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pLASACZgoEcl1P3pbbsnivd00oF00ItQz/xXGbfD/EQ=;
        b=O6Td3MbYGzkvTyI90Y9MgBST8a4aWru4u44WMtM82AXiyd2Mu8E6dQaCDikqvuiT+8
         jjwlFYZ7rCH0XZrpxns2FL4Zu+pEx1/LAVuOtwS82Jb76YAnwTYyBFW/LF+5CXwa9bFK
         7LM1k8RnD5elDq8Eo3snqIQ3w8G6HG3njPawJ+WChINOg005FVQcFqAMUOTp0vEUMoBW
         pNWsyfyAjGmJRCeVL/cJDEp+qPbaEwP5XnPxVnoP1nTIvujqnY1IG+wHxWr23VIHDl9K
         PLZ4+OGow2NuMCZMra1UMYjbDZV1wUHNkLfa8LEAQiN2hO0SZnA4nfWZPUHncmq5DCZl
         N2HA==
X-Gm-Message-State: AOAM533hPJ8cLaGGGaoCmy9cPAHuSfuYz50BCuHVqfwcBfrzCVMOxRTq
        vg+KQ7keu31OP3rWc746H3OevxmFk2H1JqCOlbY=
X-Google-Smtp-Source: ABdhPJx+Lw4Xbs1wZzyzLdqYERPwT2cOIF0xwW4dXW328s5oJqjcLoZ9f5LbnFns68wyKfnYZ7qu0XXyinSuw7ze+rs=
X-Received: by 2002:ac2:43b2:: with SMTP id t18mr9819944lfl.133.1623627341275;
 Sun, 13 Jun 2021 16:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210610114817.3524037-1-libaokun1@huawei.com>
In-Reply-To: <20210610114817.3524037-1-libaokun1@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 13 Jun 2021 18:35:30 -0500
Message-ID: <CAH2r5mtOfwzNqTmuPhwejk2JBm6YFbF8LgPzyNsKwnrT0V4P2g@mail.gmail.com>
Subject: Re: [PATCH -next] cifs: fix doc warnings in cifs_dfs_ref.c
To:     Baokun Li <libaokun1@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>, yangjihong1@huawei.com,
        yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Jun 10, 2021 at 6:39 AM Baokun Li <libaokun1@huawei.com> wrote:
>
> Add description for `cifs_compose_mount_options` to fix the W=1 warnings:
>
>  fs/cifs/cifs_dfs_ref.c:139: warning: Function parameter or
>   member 'devname' not described in 'cifs_compose_mount_options'
>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  fs/cifs/cifs_dfs_ref.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index c87c37cf2914..ec57cdb1590f 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -125,7 +125,7 @@ cifs_build_devname(char *nodename, const char *prepath)
>   * @sb_mountdata:      parent/root DFS mount options (template)
>   * @fullpath:          full path in UNC format
>   * @ref:               optional server's referral
> - *
> + * @devname:           return the built cifs device name if passed pointer not NULL
>   * creates mount options for submount based on template options sb_mountdata
>   * and replacing unc,ip,prefixpath options with ones we've got form ref_unc.
>   *
> --
> 2.31.1
>


-- 
Thanks,

Steve
