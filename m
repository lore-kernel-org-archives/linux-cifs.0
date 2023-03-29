Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9720C74A5B
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjC2UZp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjC2UZo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:25:44 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD5840F4
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:25:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id x3so68139979edb.10
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680121542;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UPhJCTYEPdMY6UyrMqZcin+6MgCbiBqOJzAzi1i3AVI=;
        b=ht0rpNhzIFTZ50OQlfYwc2Dyajc99gcg/Uyi3A5GugMI3Km8sbqSZDGrOTYzjCdPYG
         E9YmKg0vs6dSR6i0u/UePxuOGVyI6vhS14ku234PLEeHB83l6GW+p4tOD3jF+2MvFq67
         3UrjBPGMh4GkcjR7L9UaY8H9iM0EvUsfphNhtsJ0ZeabOgHlYWmRJZSiJt+uQcFRroS5
         zecBwcuO+8m/uUa0DPKTscv+/3hQJ/YU2EfhL3Y2ein0kaoJc1FvS5LlvlUxdn7wSqaj
         KsGduViyNEYedKbinAu3sm/XU6ItWUBVj3pRX+OMpvFdLXL8WVLgK1UDJ4vevueilfN4
         MX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680121542;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UPhJCTYEPdMY6UyrMqZcin+6MgCbiBqOJzAzi1i3AVI=;
        b=45BzpnUzN1eafm4JRjGkISUVcCUbdW1gp+9geL7S8ltDtHoiGiV+aCwuFfJGSVXuwL
         Kfd0+nj6ZdWHilRGv+YiK5RW+hvZsDfQyAM8g//58f9OpUOKI0O7uYbHM6PgxWzOClCO
         rgQSW9werJoAjILw11Wt/IdBO8QyYcuzgD2h1KtiDqeyBQp4gMB0gwOxAtfMmHszjcoT
         /Zz6z0bCk00+LgY2FL1/274Eu9s/VFRjU10j8z0WoGoTxJAK0ChB0pJAJq3Io3IU4ZLP
         2lMnYTa6Fq6tuCxxaHBmYRsnj3SCfBaYvf7AVXcksUtG5V8l5vJZS6CJlhFOHc1i1O8r
         Leyw==
X-Gm-Message-State: AAQBX9f8VUzf+RiMjPYCUJXQmTfOpyKp6cJnta7UW0ENt8+MhyM0fqNA
        GEqQ0Kwgr1rSPictBhme6vooVav66rf9/rg/zEo=
X-Google-Smtp-Source: AKy350ZYFmTwKNbNp426jG4Ai2JHzLBt2wgWcd9mMFPEYFbysoy13mMIXy9XMno/+P20fuIGVLRx5eJqU2rRqnmsuF8=
X-Received: by 2002:a17:907:160e:b0:946:a095:b314 with SMTP id
 hb14-20020a170907160e00b00946a095b314mr4246879ejc.2.1680121542239; Wed, 29
 Mar 2023 13:25:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201423.32134-1-pc@manguebit.com> <20230329201423.32134-2-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-2-pc@manguebit.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 30 Mar 2023 06:25:29 +1000
Message-ID: <CAN05THSk5wESDBcc6g4Dtpr4HWkTSsrM-5BzWaTPD403a_3dQg@mail.gmail.com>
Subject: Re: [PATCH 2/5] cifs: get rid of unnecessary ifdef
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Thu, 30 Mar 2023 at 06:20, Paulo Alcantara <pc@manguebit.com> wrote:
>
> No need to ifdef around TCP_Server_Info::{origin,leaf}_fullpath as
> they're declared regardless CONFIG_CIFS_DFS_UPCALL.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/connect.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ef50f603e640..7c3e090a0f13 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -993,10 +993,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>                  */
>         }
>
> -#ifdef CONFIG_CIFS_DFS_UPCALL
>         kfree(server->origin_fullpath);
>         kfree(server->leaf_fullpath);
> -#endif
>         kfree(server);
>
>         length = atomic_dec_return(&tcpSesAllocCount);
> --
> 2.40.0
>
