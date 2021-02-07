Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3E7C4332D
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Feb 2021 04:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C523664EBB
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Feb 2021 04:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBGETG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBGES7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Feb 2021 23:18:59 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490C0C06174A
        for <linux-cifs@vger.kernel.org>; Sat,  6 Feb 2021 20:18:19 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id e132so11125486ybh.8
        for <linux-cifs@vger.kernel.org>; Sat, 06 Feb 2021 20:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=RK3RUkIWBC23RSSrXAJ8H2MDEUI6XouV/SiLk4kz+bg=;
        b=XQ2ACiRwC8qLohptO7Nf6oxzmrVs7O11u7+SOoHWpOZKaubHPGcEppnR+1m8miViSS
         Kt58qUqTwrhs+eJ9VzUtXDM+3o/Ess9D2/Y70rFp8zlX3XV6I6DaRmcO2N6VIAWBujGl
         a4AvQ6NLb5VZ6R6jdJJXB/PNjy6OOWjV7NGzXaWClij6WUFXi8iehgRmO3xRkPGH6q7B
         CBOkghEQeR5AC+rQf2VSLrww+R2WyT8/QjJ7YbnzOnK5yy/cRsk1n+yErfdFXUcwG4Wz
         2SFzpWwTANxySu7rPbVFNYZCyGKKXJdlalzOF5lFaL7LYdV2l7HLAlfZEN47pdlWPYBb
         hxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=RK3RUkIWBC23RSSrXAJ8H2MDEUI6XouV/SiLk4kz+bg=;
        b=rp1bkar0l59jnZE2NgOq/xgEOqmzHhwWTXxXsi8xr3ZLpAqxvmcLLpT9RQJXN1kaHM
         8wa6qwp2NUXReuWJPg7A78xy7nxEfVyoj7vzwvVQJjISMGeSkcMRgUN1cCTqiJjNT47E
         9v1W0z+bPcP89l31qtI1Z/deOn7Id/9htzCf//LTlh7e5B2uoW8Ovta15jgvB5lAoqh+
         lbddiAblybrsls9aNvWC0gcBrTFqWs/XSsqDv1xNkrgXnqz1ncJpl5yDpjIM55g8qGNf
         4DKvexngkLQmeKMfZZaozbq4e3PeYgceQLxHYHPj2fmUVFIjwv0oAVTPa8wnpKLjBX47
         0pdg==
X-Gm-Message-State: AOAM533J970k9xMfirVEvPhXu1q8TAPvGJB+i6aU3DP6mb8CAANWblAQ
        OnsouZ2t8mnB9U/OZTTMYA6jXeHx8mrFuoPF/PQ=
X-Google-Smtp-Source: ABdhPJwkFto/5ajukNnHnQaijUA6g9fWyZjM/w07n7gg5lshWIHmvT1hEV8piDvLvg38AxRnWltvHAYU3E6HfH0thiA=
X-Received: by 2002:a25:7706:: with SMTP id s6mr16802069ybc.3.1612671498546;
 Sat, 06 Feb 2021 20:18:18 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=rUagVpf1aKEDVqL-DiY2+ceYUE7mLD1pGrajN-uopRig@mail.gmail.com>
 <CANT5p=og=n36LmWroyomC7nNdJvVHFpSQqLXtH0XGY1OzvVsCQ@mail.gmail.com>
In-Reply-To: <CANT5p=og=n36LmWroyomC7nNdJvVHFpSQqLXtH0XGY1OzvVsCQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 6 Feb 2021 20:18:07 -0800
Message-ID: <CANT5p=pCdVzrPNx2-6wL7_ewGMSo2Q8y8BM2dRD=5aGFk4TrPQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] cifs: Identify a connection by a conn_id.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Here's an updated version with some formatting changes per checkpatch.pl.
@Pavel Shilovsky @ronnie sahlberg Hoping that one of you can review
this. Particularly the above point.

Regards,
Shyam

On Thu, Feb 4, 2021 at 12:13 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> @@ -97,17 +99,25 @@ smb2_add_credits(struct TCP_Server_Info *server,
> -       if (server->tcpStatus == CifsNeedReconnect
> -           || server->tcpStatus == CifsExiting)
> -               return;
>
> @Pavel Shilovsky This check prevented a tracepoint from getting
> printed. I do not see much value in these lines, since all we do is
> print the tracepoint and exit. Hence removing it. Please let me know
> if that is not okay.
>
> On Thu, Feb 4, 2021 at 12:09 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Regards,
> Shyam



-- 
Regards,
Shyam
