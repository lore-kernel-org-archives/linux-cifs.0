Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AB3C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Dec 2021 00:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354600AbhLDBDP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 20:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344497AbhLDBDP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 20:03:15 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA707C061751
        for <linux-cifs@vger.kernel.org>; Fri,  3 Dec 2021 16:59:50 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id y5so8667444ual.7
        for <linux-cifs@vger.kernel.org>; Fri, 03 Dec 2021 16:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bN7WUlUOmtupEBlru2DLLwc4SywaT+L0uZbKIij4NnY=;
        b=TtxqnUko+7TmE7y18GuQpF+OqqOsHtxK7hpmnc0o32f/ZwmGimevMsa32xzOpCVtta
         2W+ZZetBHZ0k4HTvUV4UktqxdIkVMJMO/y6j8nsi2T5VnvzVX9sTs0/A/gyRuiZmaQvC
         c8cUr5AfIg2HPmmQ3Jbfu3G5yBI+zomgoNuCssoWR3GY0+X11dK3B2bisTSQayzg2pEF
         mLF8aSckd1N2PXgwZBbAbQQbtVDRPNXwmaCGHm1xUycF9CGUDcjQR0vbm48lVKU4S4X9
         XIL8koD+rTDqTkoff5xtdCJu1Sasnf5xI7sh9m8/0F9BEkDUvT4KqxKDYfBcDgGIEK6M
         f55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bN7WUlUOmtupEBlru2DLLwc4SywaT+L0uZbKIij4NnY=;
        b=5/+CIdbDH10ltrrNrRe7J8t7j1nTE2XgTlZvK9Ar5gp2ROKZKLlaslToud72REw/WQ
         3gVwfGQabUUJx8kP+cN8h8/WvgFNic2g4pz8ZzedLgG6oROVZFh+2nlckYYaJi3D5lhH
         rBfzXLlxXZkuV1oZFGFeeesjah35PoBQbgnmOfln5GAf8iksjuMOHL+LiU6o3XxPJDls
         bbY82Oi9MKdQjyPApTcdskiw9PsDN1OsQ5ww0gRwzMxB5vvP/cZGE8TC9Nb8BV1CGj2S
         QvE2p9X4I7BPeCFuYTp4593GfBBCAKukIDUdu4NnOIn28RHHpfR7LGpFYtn7dlrjNAop
         Yf1w==
X-Gm-Message-State: AOAM531zn7aCiwU0riGGfXiukhGi3RRGeJ+EQHWfnFhYpCAhTk/oy5hH
        YoRPul7XR5pSLT+smFdbE5ccL1PlTIQOWKHyc4ctXlxP/sONcg==
X-Google-Smtp-Source: ABdhPJzeTrr/jLo3HF0zTt284WNFci9upjU0s0nyQ6kO8cYkvPwFPAphXQodgBAVYenhJswS5/uvt+StRoo0D/HDRXQ=
X-Received: by 2002:a67:5f47:: with SMTP id t68mr24896793vsb.56.1638579590016;
 Fri, 03 Dec 2021 16:59:50 -0800 (PST)
MIME-Version: 1.0
References: <20211201204049.3617310-1-mmakassikis@freebox.fr>
In-Reply-To: <20211201204049.3617310-1-mmakassikis@freebox.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 4 Dec 2021 09:59:39 +0900
Message-ID: <CANFS6bZ6dkwoh69O93sgY-kWN7ABmk9iDQsAmjLk-snze0sCLQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Remove unused fields from ksmbd_file struct definition
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 12=EC=9B=94 4=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 1:20, M=
arios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> These fields are remnants of the not upstreamed SMB1 code.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/ksmbd/vfs_cache.h | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/fs/ksmbd/vfs_cache.h b/fs/ksmbd/vfs_cache.h
> index 448576fbe4b7..36239ce31afd 100644
> --- a/fs/ksmbd/vfs_cache.h
> +++ b/fs/ksmbd/vfs_cache.h
> @@ -96,16 +96,6 @@ struct ksmbd_file {
>
>         int                             durable_timeout;
>
> -       /* for SMB1 */
> -       int                             pid;
> -
> -       /* conflict lock fail count for SMB1 */
> -       unsigned int                    cflock_cnt;
> -       /* last lock failure start offset for SMB1 */
> -       unsigned long long              llock_fstart;
> -
> -       int                             dirent_offset;
> -
>         /* if ls is happening on directory, below is valid*/
>         struct ksmbd_readdir_data       readdir_data;
>         int                             dot_dotdot[2];
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
