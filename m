Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6FBC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Feb 2021 16:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF40164E24
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Feb 2021 16:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBSQsq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Feb 2021 11:48:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:38662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhBSQso (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 19 Feb 2021 11:48:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 951EDAC6E;
        Fri, 19 Feb 2021 16:48:02 +0000 (UTC)
Message-ID: <ee53a10aa0bf87445b1ab6be7c2db60aecd568cf.camel@suse.de>
Subject: Re: [PATCH] cifs: Fix inconsistent IS_ERR and PTR_ERR
From:   Samuel Cabrero <scabrero@suse.de>
Reply-To: scabrero@suse.com
To:     YueHaibing <yuehaibing@huawei.com>, sfrench@samba.org,
        dan.carpenter@oracle.com, aaptel@suse.com
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 19 Feb 2021 17:48:01 +0100
In-Reply-To: <20210218092812.20004-1-yuehaibing@huawei.com>
References: <20210218092812.20004-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Yue, it looks good to me.

Reviewed-by: Samuel Cabrero <scabrero@suse.de>

On Thu, 2021-02-18 at 17:28 +0800, YueHaibing wrote:
> Fix inconsistent IS_ERR and PTR_ERR in cifs_find_swn_reg(). The
> proper
> pointer to be passed as argument to PTR_ERR() is share_name.
> 
> This bug was detected with the help of Coccinelle.
> 
> Fixes: bf80e5d4259a ("cifs: Send witness register and unregister
> commands to userspace daemon")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/cifs/cifs_swn.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
> index d35f599aa00e..f2d730fffccb 100644
> --- a/fs/cifs/cifs_swn.c
> +++ b/fs/cifs/cifs_swn.c
> @@ -272,7 +272,7 @@ static struct cifs_swn_reg
> *cifs_find_swn_reg(struct cifs_tcon *tcon)
>         if (IS_ERR(share_name)) {
>                 int ret;
>  
> -               ret = PTR_ERR(net_name);
> +               ret = PTR_ERR(share_name);
>                 cifs_dbg(VFS, "%s: failed to extract share name from
> target '%s': %d\n",
>                                 __func__, tcon->treeName, ret);
>                 kfree(net_name);


