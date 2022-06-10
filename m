Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724E4C43334
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Jun 2022 23:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbiFJXUB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Jun 2022 19:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347331AbiFJXUA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Jun 2022 19:20:00 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FFBF3F92
        for <linux-cifs@vger.kernel.org>; Fri, 10 Jun 2022 16:19:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d14so691315eda.12
        for <linux-cifs@vger.kernel.org>; Fri, 10 Jun 2022 16:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mFUZ/4X/JukFzJtRWCj5IwVqnR0commkjm8Ld9IJoQA=;
        b=AoxxrgfmaiG7fB01rWVX7//fR7hc8pfPaO6KuFkmEJpDpFR/HpqhwLdFQM6dVgzan3
         DB7+Ryy9LWRyARZSjDc1y62fbB3v6E3HNwslaXd4JIbxny9dkIOf8ftYNIIBC41esAeu
         4Gv6sMSeEfJjJ4Ad3imZr/QdI/L/mCWsQLeaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mFUZ/4X/JukFzJtRWCj5IwVqnR0commkjm8Ld9IJoQA=;
        b=Pup5KEZ/lM1Mp7w40m4RcA8o/y23qneTYnFrB63PkJzE5ztf6oY24MXcaS48aVyVjV
         OXaq0ZG7ePa1Ynjfoc/C4VTz5SseOwOcqBkOkm7HoJRwTeGC4sZ4ezD+R5kccANQUfVg
         rTcYMWGY8Bya/LiVIrKVc6keVgdUJQCDKNgGmxUgEAmxo6wSPcebLSbAcufTKeCnpqwH
         e7uokpyIF0Yjy2ua+Qbav+SYgCWxMKR4o8mSNi2gkyBlITtUG89LvJnmlgPd7u0aOpXx
         N5xTtunZjX03yQ0I/BGxtELRImUZZUpyjGUOffb3IVz8AN53hI1le8N2kqmsGhymS+//
         wjWg==
X-Gm-Message-State: AOAM530DRIKJsQQnPm72kytlxr+6c/ORE0z4VF99a54AlGZpr8Zlr+S7
        wzHUJb26grb6WFEv9zB4nKzfGU+JGzX2Zl4o
X-Google-Smtp-Source: ABdhPJzEIwpPRLUfSZJzvAG6X4cHy9ur/7YoXWrMQa/molDredw99zxzmjs5NTyYeEVALRns0TlpqA==
X-Received: by 2002:aa7:dbd7:0:b0:433:55a6:e3c4 with SMTP id v23-20020aa7dbd7000000b0043355a6e3c4mr5811640edt.74.1654903196039;
        Fri, 10 Jun 2022 16:19:56 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id m23-20020a170906161700b0071216de7710sm188826ejd.153.2022.06.10.16.19.55
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 16:19:55 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id a10so193058wmj.5
        for <linux-cifs@vger.kernel.org>; Fri, 10 Jun 2022 16:19:55 -0700 (PDT)
X-Received: by 2002:a05:600c:3485:b0:39c:7db5:f0f7 with SMTP id
 a5-20020a05600c348500b0039c7db5f0f7mr2015707wmq.8.1654903194928; Fri, 10 Jun
 2022 16:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <165489100590.703883.11054313979289027590.stgit@warthog.procyon.org.uk>
In-Reply-To: <165489100590.703883.11054313979289027590.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Jun 2022 16:19:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgeW2nF5MZzmx6cPmS8mbq0kjP+VF5V76LNDLDjJ64hUA@mail.gmail.com>
Message-ID: <CAHk-=wgeW2nF5MZzmx6cPmS8mbq0kjP+VF5V76LNDLDjJ64hUA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] netfs, afs: Cleanups
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        Jeff Layton <jlayton@kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-erofs@lists.ozlabs.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 10, 2022 at 12:56 PM David Howells <dhowells@redhat.com> wrote:
>
> Here are some cleanups, one for afs and a couple for netfs:

Pulled,

               Linus
