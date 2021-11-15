Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EA7C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Nov 2021 05:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF4563211
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Nov 2021 05:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhKOFQc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Nov 2021 00:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhKOFQZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 15 Nov 2021 00:16:25 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33420C061746;
        Sun, 14 Nov 2021 21:13:29 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id k37so40284247lfv.3;
        Sun, 14 Nov 2021 21:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZoE+xQ2U7qWcLCwPm3BWxfe1Es+mpw14CoOgK3M7Ok=;
        b=mwm1VjQ772gRZ4PuPgObB+pw+oQgHGo0gH8xXfY20IrpKUmrCNqdtnQD17BsNf6flb
         fqYRtMBtI8ssq47EvKK7k7me43tk/1EnUxRmYFUbhTTxtJNsECVuv6H+9l7mM2L8kMHl
         Ti1HfiRu2dIiAJWG/R1O7ne2eNsNFDVJi1P42Sqihk2iGMQOmkczpZQDvo5Ck1SHfRH1
         8d5la2PFPHcSPqrjh8OdXiQmYMw9LKgpnjowZpsrK7pAMT1Yo1gYkbvcuzvt1WvNazI/
         EJgF9gNnwRrNIyAXiwWOYHO5F0ojNXbNmrbx5TX26Oem6zIYnrkUfhFQ8gbRfhcbUyI0
         VenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZoE+xQ2U7qWcLCwPm3BWxfe1Es+mpw14CoOgK3M7Ok=;
        b=YMAP2cksaI9sJcedQDl5tOxbW3nXe/CAsagNXham2KLfh1CTrx8YEtgdiaJIp3RUM9
         2VLcIkj0ueX0iDOKD27UyCncnOO1b6h9X0Ze3/22vkVtfAe9Ez+EKdD60IZp5FsKJ8l4
         2W/SjnMsOmb4i8UHmwVSPJyTpkdD+sNJ5g7SjNNeOlXyKlhoyAriGtBTDx2J0fADK61L
         W0vSKDPgo6wrp4YOy64a7VgfvqsXm3+yjki2czWU28JXDd7BawzX+dUdF1vw5j/jZqaV
         qWquxWQsCEUwemU8PTa0f0zGFc4CGbc6C6VkGk2sxlJluE0yIJvKodM2qw7m2Jhm/bMd
         vI+Q==
X-Gm-Message-State: AOAM533B1Fovs5PTaiRJY8t4hUtCKbhAWLnT3rE88MaZy+5V7xcSBRbd
        99cHTPlJhrfiPXmxjYuQ/0OIJwFaXfjo2XthMEw=
X-Google-Smtp-Source: ABdhPJxXns1wG+psRT62X8UPM7sHi3HbTaMCW/uGnIXCXyY36drmrlPsz+a6JG96myvs8cZdB598PP5mo7jAIvMlvZs=
X-Received: by 2002:a19:770a:: with SMTP id s10mr34265127lfc.234.1636953207366;
 Sun, 14 Nov 2021 21:13:27 -0800 (PST)
MIME-Version: 1.0
References: <20211112093051.9366-1-chi.minghao@zte.com.cn>
In-Reply-To: <20211112093051.9366-1-chi.minghao@zte.com.cn>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 14 Nov 2021 23:13:16 -0600
Message-ID: <CAH2r5muJ14DbEax2N2p30MD_wWcteeHfH4TCJM4K_eSDsU2dBQ@mail.gmail.com>
Subject: Re: [PATCH] fs:cifs: convert from atomic_t to refcount_t on tlink->tl_count
To:     cgel.zte@gmail.com
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending testing

On Fri, Nov 12, 2021 at 3:32 AM <cgel.zte@gmail.com> wrote:
>
> From: chiminghao <chi.minghao@zte.com.cn>
>
> use refcount_t instead of atomic_t
> which prevents reference counter overflows.
>
> Reported-by: Zeal Robot <zealci@zte.com.cm>
> Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
> ---
>  fs/cifs/cifsglob.h | 4 ++--
>  fs/cifs/connect.c  | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 41e97df4e0e5..a8edaada0fea 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -8,7 +8,7 @@
>   */
>  #ifndef _CIFS_GLOB_H
>  #define _CIFS_GLOB_H
> -
> +#include <linux/refcount.h>
>  #include <linux/in.h>
>  #include <linux/in6.h>
>  #include <linux/inet.h>
> @@ -1115,7 +1115,7 @@ struct tcon_link {
>  #define TCON_LINK_PENDING      1
>  #define TCON_LINK_IN_TREE      2
>         unsigned long           tl_time;
> -       atomic_t                tl_count;
> +       refcount_t              tl_count;
>         struct cifs_tcon        *tl_tcon;
>  };
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 9637465d23db..4aad8c9acf2e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2318,7 +2318,7 @@ cifs_put_tlink(struct tcon_link *tlink)
>         if (!tlink || IS_ERR(tlink))
>                 return;
>
> -       if (!atomic_dec_and_test(&tlink->tl_count) ||
> +       if (!refcount_dec_and_test(&tlink->tl_count) ||
>             test_bit(TCON_LINK_IN_TREE, &tlink->tl_flags)) {
>                 tlink->tl_time = jiffies;
>                 return;
> --
> 2.25.1
>


-- 
Thanks,

Steve
