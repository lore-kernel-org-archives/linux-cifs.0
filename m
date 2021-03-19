Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906BFC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 05:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BD0E64ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 05:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhCSFxI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 01:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhCSFxH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 01:53:07 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85563C06174A;
        Thu, 18 Mar 2021 22:53:06 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id f26so10481203ljp.8;
        Thu, 18 Mar 2021 22:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ieKEg/I8DWyrNnzM2/enM81rs852gdyY9A7m+JJ808U=;
        b=iquAE73D+G5vtFjan5O+JlTPfC66rcUGH/5thoAYHxPmC24aRf/jy+PA3N8+BpHx3u
         g2KmGfunQ6z4ink3IHSgAg1+a+VbCxC5nivZehVhVfMDUa5V0lcH9eHLBAcfktr8HB8c
         JXd/YLFYA/QBhunWB86TPz8WYOP2qb90C5psmvcS/0gnMmftlZJ6VOwD3mMBLpo+g75Y
         9/o+y+Lke2U7b2OXIvaj9v29YDqNG4rRkFWPwNSgCPKmsNJj8FW4AcdIfAvLn89O/ldy
         UlccC/CAB3UN3X1dzXG79XeZn3AByb9CGsFRvnx7RebEg1BJ/cbnVbk/xcJYqH2n8LIF
         4jRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ieKEg/I8DWyrNnzM2/enM81rs852gdyY9A7m+JJ808U=;
        b=WqpnTYz9k2syMObDxb92llGYJPr2Bxo4sYM2EIMXZMbKDDMVps3bcnkIDO/mgyYEZL
         pZ5A+XDb52T5B4Q6d8liyrRQsnprT1wh9V6N4GJsCCGAHiBN45gqkbVFGFM6muHb+dTy
         bVJWa9iYYVLVpil6LbhS1Tn3Wt0aThAW+ke1QwgE+SLhA5G0CCN3JQma3VKvXybXJbQ6
         X59qPqnhqVyF158A5bVJH2DZKLlfQaOHEp11vsziKvhCh1yR/uAlw7PCV9bpqb4I+6Yj
         Af8sg7nGBHUc1MDaM9LSOeH+Bv+2H5jDND6rvrm7/odVley8Jji3zE11ALPcwIxUpiI5
         p8+w==
X-Gm-Message-State: AOAM533/zsnMVPNxvY+sOn2AvBjssJCxScKtomI+un3xrAfFpuZOpnxw
        PwfnNdnM+hqxn4wxaUkQ5KXmjlEEHTo0bgLGMFw=
X-Google-Smtp-Source: ABdhPJydyF85xrIO4j2aR2Wm5nIVy2epWPKLP+h7WXhkpS3H1B7/f3GVCd/4EXVHM/UTaYywdG+DosSaWPia01x72gk=
X-Received: by 2002:a2e:9907:: with SMTP id v7mr3584997lji.256.1616133185055;
 Thu, 18 Mar 2021 22:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210319004657.485503-1-liu.xuzhi@zte.com.cn>
In-Reply-To: <20210319004657.485503-1-liu.xuzhi@zte.com.cn>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 00:52:54 -0500
Message-ID: <CAH2r5mvXw8mdY1b56O6802NoemXMh70P4MJY0E-dr-rZ6=Cu-A@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/: fix misspellings using codespell tool
To:     menglong8.dong@gmail.com
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Liu xuzhi <liu.xuzhi@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Mar 18, 2021 at 7:50 PM <menglong8.dong@gmail.com> wrote:
>
> From: Liu xuzhi <liu.xuzhi@zte.com.cn>
>
> A typo is found out by codespell tool in 251th lines of cifs_swn.c:
>
> $ codespell ./fs/cifs/
> ./cifs_swn.c:251: funciton  ==> function
>
> Fix a typo found by codespell.
>
> Signed-off-by: Liu xuzhi <liu.xuzhi@zte.com.cn>
> ---
>  fs/cifs/cifs_swn.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
> index f2d730fffccb..d829b8bf833e 100644
> --- a/fs/cifs/cifs_swn.c
> +++ b/fs/cifs/cifs_swn.c
> @@ -248,7 +248,7 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
>
>  /*
>   * Try to find a matching registration for the tcon's server name and share name.
> - * Calls to this funciton must be protected by cifs_swnreg_idr_mutex.
> + * Calls to this function must be protected by cifs_swnreg_idr_mutex.
>   * TODO Try to avoid memory allocations
>   */
>  static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
> --
> 2.25.1
>


-- 
Thanks,

Steve
