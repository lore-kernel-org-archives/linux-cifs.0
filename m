Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA814C433DB
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 01:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8A664DFF
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 01:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhBMBHQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Feb 2021 20:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbhBMBHK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Feb 2021 20:07:10 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50942C061222
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:06:06 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id b16so1128024lji.13
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6jTxP9hlbcUR9+3iPNQ9HmsqF25QNS6zvjTzXBH5E4=;
        b=WUNxTILAYi3Kk+wVUIaUVhIr3oaiaHaDjKr023ekUsCD6VQNr+/uPlhMEL6q29t3EB
         7gNdhrTjI0bG4chV1tfJBSEWmnvTFlDxKHjMtcZld38+fszGfI/ow6zlOY5oPPFVrq11
         U9kc9/PviiJUNwLPvQe5fwcbGhKWs2MNkDWS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6jTxP9hlbcUR9+3iPNQ9HmsqF25QNS6zvjTzXBH5E4=;
        b=kEbFsCbzAoaVFVyErJ6J5Dpa8IGLAwPEobBSs6cIYCvDRL4gHrjeF79uz80iRalhU7
         VoYWxIVZSi8fBNX+RHvDIeKMec6meRBe010aXXVbo84tKolO2OuBFg7ASXSAHOAacQvI
         nLChrw+Lb4e+GWLrfXKSgt2FvTcCkpyo0iF6VIGLGJ3KWIS2U/bz5G9Z83jK82zqlikZ
         TIa9MWA8sJEtcFkDl9e25CDxdFq0X2NOf936TWyYisbutZ28bo3m0Lrqzz0eQZGNAtNI
         4YOxxHx+y1YVCQqYh0FLybKx+NBWFubR2wasVY5rJTAGLMagtrMWWGQe+45+m08xr45y
         eQxQ==
X-Gm-Message-State: AOAM531snkE4MlqI3kpIbIlwGfeNkJdrDvccENXhCCdN1wdhBw5mwHqg
        Aw4XCqsUL6zC53JCfNWgwdOlUWe+YLz68Q==
X-Google-Smtp-Source: ABdhPJxGM2w6CyIKWqGr9VyGpxtxL8sYoP27trvdF9s6TEkL6U7/kTdh5Gr7Ugz0n5fljAt9E9LoNg==
X-Received: by 2002:a2e:b179:: with SMTP id a25mr3248006ljm.351.1613178364801;
        Fri, 12 Feb 2021 17:06:04 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id b25sm1898371ljk.74.2021.02.12.17.06.04
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:06:04 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id c17so148371ljn.0
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 17:06:04 -0800 (PST)
X-Received: by 2002:a2e:8049:: with SMTP id p9mr3052102ljg.411.1613178363694;
 Fri, 12 Feb 2021 17:06:03 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
 <591237.1612886997@warthog.procyon.org.uk> <1330473.1612974547@warthog.procyon.org.uk>
 <1330751.1612974783@warthog.procyon.org.uk> <CAHk-=wjgA-74ddehziVk=XAEMTKswPu1Yw4uaro1R3ibs27ztw@mail.gmail.com>
 <27816.1613085646@warthog.procyon.org.uk>
In-Reply-To: <27816.1613085646@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 17:05:47 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi68OpbwBm6RCodhNUyg6x8N7vi5ufjRtosQSPy_EYqLA@mail.gmail.com>
Message-ID: <CAHk-=wi68OpbwBm6RCodhNUyg6x8N7vi5ufjRtosQSPy_EYqLA@mail.gmail.com>
Subject: Re: [GIT PULL] fscache: I/O API modernisation and netfs helper library
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        ceph-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cachefs@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Feb 11, 2021 at 3:21 PM David Howells <dhowells@redhat.com> wrote:
>
> Most of the development discussion took place on IRC and waving snippets of
> code about in pastebin rather than email - the latency of email is just too
> high.  There's not a great deal I can do about that now as I haven't kept IRC
> logs.  I can do that in future if you want.

No, I really don't.

IRC is fine for discussing ideas about how to solve things.

But no, it's not a replacement for actual code review after the fact.

If you think email has too long latency for review, and can't use
public mailing lists and cc the people who are maintainers, then I
simply don't want your patches.

You need to fix your development model. This whole "I need to get
feedback from whoever still uses irc and is active RIGHT NOW" is not a
valid model. It's fine for brainstorming for possible approaches, and
getting ideas, sure.

               Linus
