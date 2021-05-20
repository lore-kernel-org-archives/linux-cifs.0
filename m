Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC00C433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 02:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CCD8611BD
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 02:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhETCOi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 May 2021 22:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhETCOg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 May 2021 22:14:36 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D0CC061574;
        Wed, 19 May 2021 19:12:23 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b26so6054735lfq.4;
        Wed, 19 May 2021 19:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FTCd6+qiif01nDICAPQwlVynjOYjR5IJKwPzRGQKUlc=;
        b=eby5+MG5WOLfBJG5eg8HoCR/ZBM6jNxULHNd3nt/BEVa8feoOsK/QERWdS6sVXR7mX
         z2Z+9m72d/z5eyCeX0LythlCLs9TSv6NIjniPi6vO70ZeYt+1pB154TUa+fxTXxfKnto
         q2jygY4V1DeiFfbI6DxYYI51j0fAVepvIt8ojPfaJRcNSxVQ8BkOqfYCeXMjbwLRTQXO
         OfEmSwJ86BiN58WIGXsSgBXgO4h7dYO/ho0CnpqtakIT1/x1LUgvpCZTMKV9lZqgpGhE
         JGINJ2uoVKUqBsi7CSBcKkhiAVD1S5op+4yyIDijfvQxik9DQky+bkBszloJieSp1CUv
         CkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTCd6+qiif01nDICAPQwlVynjOYjR5IJKwPzRGQKUlc=;
        b=gh5Iv/nIgmONPZ3I81FPjrDGRu0NUeAjkDzkqT2RP/cO+k1cFzk7/QBCCaWDg7cAVr
         VWoDjunZujOqV03KNO7x5euLftCu21A1KLvukAkLbzC0hN/fSyVVZYW/q96OqkaZdEgW
         X3qTulhhVkAIUj+U7jR05eKcnfESH0hTDIM7a4+bVjXXMOtHnH50YLYhg9lxnY09Jl9G
         szCOaabElKSDBj9A8tkQtsaiTVr6gKKRBc5YTMxnlfj+kxNtiRgiph3Vo4lOGAJB4r+P
         B1idkgSLBCPV1JMaZ0CvIvn9eHCIv7DCyma2taqAKZaLc9K5MRHU2v2saAjGdCKaEQ2j
         CGLA==
X-Gm-Message-State: AOAM532prRFMVATkfeZ+oI4bp6aZrpQblrKhaRxPhn8KmLQvBM2hJJMc
        kgwMns6Sldk458c8KBNpXzv/jrR+0gv0dbwoQaL3Qgt5zw4=
X-Google-Smtp-Source: ABdhPJze41Tna3mdxpem1bwA3YO/pMjKiaQ5H13HVKKTehHFnhDyXjRsAc5yKedHyMM3VA8zA62/1UIE1m2QHNnNOtQ=
X-Received: by 2002:a19:c397:: with SMTP id t145mr1755064lff.307.1621476742264;
 Wed, 19 May 2021 19:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <1621421227-34130-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1621421227-34130-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 19 May 2021 21:12:11 -0500
Message-ID: <CAH2r5mvPTFcueM4VotLvQfiNLDeG0_CMXKQdUtyMYstXYznJqQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix inconsistent indenting
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, May 19, 2021 at 2:27 PM Jiapeng Chong
<jiapeng.chong@linux.alibaba.com> wrote:
>
> Eliminate the follow smatch warning:
>
> fs/cifs/fs_context.c:1148 smb3_fs_context_parse_param() warn:
> inconsistent indenting.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  fs/cifs/fs_context.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 5d21cd9..92d4ab0 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -1145,7 +1145,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
>                 /* if iocharset not set then load_nls_default
>                  * is used by caller
>                  */
> -                cifs_dbg(FYI, "iocharset set to %s\n", ctx->iocharset);
> +               cifs_dbg(FYI, "iocharset set to %s\n", ctx->iocharset);
>                 break;
>         case Opt_netbiosname:
>                 memset(ctx->source_rfc1001_name, 0x20,
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
