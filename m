Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF8DC05027
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 18:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBQSNi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 13:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjBQSNg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 13:13:36 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CA75B75B
        for <linux-cifs@vger.kernel.org>; Fri, 17 Feb 2023 10:13:35 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id i13so2828631lfe.1
        for <linux-cifs@vger.kernel.org>; Fri, 17 Feb 2023 10:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YIO2roZIqCQKguf/7O6kUnNCLCZ4qsxltWZUf4Tt7SE=;
        b=c7NacBDmBnpSdwBq7RhqeCeSGxaCjCffmP0uAc1IdPJ5qPcFyBjcsyNbsAG9mVf038
         hpyzAu/aSa2TcpHmN6pVY660juq9Kw31bETCVqX8xYJGPFY1vNKJofS9peRoq0AU88Qg
         iNYQX/eWSk3JKFi6qzgUkcWJj17kiu0sgSRBPOfs6f2r+IPQjB0RGMZGfV86JOrFNvNh
         weD6rPrQ9nSiePh0IxnHK6Ed7N+ZdpUpzQT4zgSVcdN8KSozQzr9s4NoXq7kKgwu8gGE
         XGkZsiHHPDy2rUevjQkpskyGOLKv99seoJNKyIapswTvYf39j1r/WNoj7cMrvZOIK5aW
         WlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YIO2roZIqCQKguf/7O6kUnNCLCZ4qsxltWZUf4Tt7SE=;
        b=CZM2Bm4v4FJQqDDJ1zJSPvCSg6vUCWzg3b1WbaOT3CegLHZ+lPNqI1OUOD5zCYg5HY
         Msj74n31WsSki07jMIs9cLTeSmARmYgYHxow/1K7xyLP3KOWHp8WORFATl1sjzuA5S42
         xqBydvHTj+3O4gL3MAZsHheakBOrLbivwyMtcEyIMIxHWgDNETyebqQg+sluDNpFcGPM
         xXWXwtnd/MzGPtZsi4BZgfRS/pcBZNWsZPl9wzRLCcz4QwE+Km4XtNMKkpqa1bjrB790
         4ckJIjVxCi7VymixCwCQtfTyuiPx7yeOgG1U8xOt4CXcniJooO0VqVoTU4HHqXvaS2WB
         lkgg==
X-Gm-Message-State: AO0yUKV7uEkw2qf6oewHcS4Ke+/eRWZCLkXkLMeSGZzPHMEVIqBRZQ9h
        0NUQQxWraYizOQ1YNoFHDUco536isBf6k9jCLcEWLBba
X-Google-Smtp-Source: AK7set/qyQNiEBh65Zkih9tIPxNKaZSrg2YfbbtDwbWH/3p9cZd8CYE8kbGSsdXHu04bfXlHX/kHg4h9tTjYFAu9WaA=
X-Received: by 2002:a05:6512:b0e:b0:4db:b4:c8d7 with SMTP id
 w14-20020a0565120b0e00b004db00b4c8d7mr3204443lfu.2.1676657613694; Fri, 17 Feb
 2023 10:13:33 -0800 (PST)
MIME-Version: 1.0
References: <20221118084208.3214951-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221118084208.3214951-1-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Feb 2023 12:13:22 -0600
Message-ID: <CAH2r5mu4uW+M+kyqgmJdQMt9yqvqqS8VYfbHcwvNT3yrcO6wug@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs: Fix resource leak when MR allocate failed
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I had missed these - let me know if any updates/changes or reviewed by
for these (I added Paulo's Acked-by)

On Fri, Nov 18, 2022 at 1:37 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
>
> Zhang Xiaoxu (2):
>   cifs: Fix lost destroy smbd connection when MR allocate failed
>   cifs: Fix warning and UAF when destroy the MR list
>
>  fs/cifs/smbdirect.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --
> 2.31.1
>


-- 
Thanks,

Steve
