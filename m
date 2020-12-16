Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F353C4361B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 07:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BBD12313F
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 07:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgLPH0s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 02:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgLPH0s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 02:26:48 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30078C061794
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 23:26:08 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id y128so1825964ybf.10
        for <linux-cifs@vger.kernel.org>; Tue, 15 Dec 2020 23:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3UXlQcuuU//j/08/XtA398+N5x6JFHog4NPLskuReRg=;
        b=k3vkNJi83ujEW8/UVTcSou4IsPqxy/ZPG5HXg923IpIa0rXtrBr2ItKj4NMe3lDBjj
         pNT88mhgTNVm7Ribxs4erlFJlN97CbCyT6bZQSoodic8xgbDG4H83EvJYccDOasnDa5m
         FD6V2nvuHj7DGtxPX4HNjQWGWgxkft/6YPvE0oscF2Odyh2fEM9OXZu85g50wNXEVEg1
         Un9YBV6KZY/QeFZqXkpFbcrpJ3FZrK0Or5mt/0N+68LcLrxJLTJTZKJGhz71V20cW2Lr
         r4LznFJu4OfudF2moIeGbK1kMcUxk1p3yO2xo/n4A5XSWbBA7oxJRkuFc3NpuUEs9jiY
         Dx2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3UXlQcuuU//j/08/XtA398+N5x6JFHog4NPLskuReRg=;
        b=cDn9IiqL6rK29DS1qDxza9tWppxa2Cas5iKgXUoh0G/Eb42YFOXVAEEhKOl9wZeO/b
         ADZh75JDLoynQgORLUf3ynStzGH0ch1drcePuZ0pNuX2z6U2S644DMr6+LvaW2P1JWK2
         C+/cWjenyqSbQSnJjhF60R6KORrXIJmkWUdumzTG/xtQEtEMPkFK0CiVWfNfnixsRzSf
         GwWZpwHNeeQAkL0x9fnktpFuJKWMAi16smTyFsqSvv3b0cTs3CjlczEmbTRdtJfKwECI
         pIsEHfyNdUM+KGoOlpPDxQw+qulTYtODLQmtZOoYBy/kaFT+89FZ9knmntvc92Hlot//
         T5Dg==
X-Gm-Message-State: AOAM530L/VPKMpGyFxyoYUFlpYpUZfCq28/RUH/QGR7IzwKRboVjxkDK
        FBS5SMNqA8RskoWdlZePwlSQ7M2bduoF/7mdMbg=
X-Google-Smtp-Source: ABdhPJy3E7/FmvzLNf/44XGbqBMQD3NSrdJKfKBAH5qIMfvcDDN9kjXW+8VKxJjGxGVjLcfXaN6jZ8thwsXiOUNN9sg=
X-Received: by 2002:a25:33c2:: with SMTP id z185mr49479275ybz.331.1608103567414;
 Tue, 15 Dec 2020 23:26:07 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvV1mrdsXhLeE+og4TS13mP5q6Cri+epqUjU1Pq7JrHSg@mail.gmail.com>
In-Reply-To: <CAH2r5mvV1mrdsXhLeE+og4TS13mP5q6Cri+epqUjU1Pq7JrHSg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 16 Dec 2020 12:55:58 +0530
Message-ID: <CANT5p=qGOEgvS7gRSib=+wrDf0snfuqQaocf03yiGQc8TOujyA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] add additional tracepoints for logging credit changes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Steve.

On Wed, Dec 16, 2020 at 3:15 AM Steve French <smfrench@gmail.com> wrote:
>
> Shyam,
> I made minor changes to your patch to avoid two places where scredits
> could be uninitialized
>
>
>
> --
> Thanks,
>
> Steve



-- 
-Shyam
