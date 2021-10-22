Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19307C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Oct 2021 20:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F117E61059
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Oct 2021 20:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhJVUeD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Oct 2021 16:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbhJVUeC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Oct 2021 16:34:02 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5BDC061764
        for <linux-cifs@vger.kernel.org>; Fri, 22 Oct 2021 13:31:44 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id q16so1010120ljg.3
        for <linux-cifs@vger.kernel.org>; Fri, 22 Oct 2021 13:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VL4lca6iHsx6oQ/wg6H7clLpP/uNe7ZsGNa7hBqT+88=;
        b=Xm2NbmUwKJoW+515TkyEWt2nuCvePzoqxLYJAFPnOe+lbdK5JzMmyaBBRaBeBIIVr6
         5Y2Ltv7T1OVUR3yQVc1hEpZ4faavbhalIte0tSbwN89GggYecoOBuJphVvusUfCFdqxX
         UgjPbDpPnxZpf2xYUJtsUcqxyBe+gW6XgMyZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VL4lca6iHsx6oQ/wg6H7clLpP/uNe7ZsGNa7hBqT+88=;
        b=ClOvH+M9CAswPlBWZSaeK8Hai5jruV4kFUltms/e6elQiF7xFgcX3ihsaf4vhHejim
         KT2HdLtAK76nSG0IUcQMEpk16aYcyR8tIyTyPQpUqTD3+ozr3gCat8a3XW6PiNjzUDUE
         IlcrleL8umr2hBgucdWqiQr0kQQ3K7RmHilEgy5zXQApRRnArkD0jBFvLHCjtWByhv3h
         LZkFdqgi+JhRGq058iavaSdHhKEsJVnGnBA/jGfMn2z6kHvd51YJKtGs2EIbYGVfj4Z+
         uONfmZfokwpUCiGSidJYLhxNBtRtvsPISqdzUdyb/UzFbUf7HedRMHMEIq1fhFw4BSkm
         EgqA==
X-Gm-Message-State: AOAM5321KzOdkVTpyZ142xzggEby89w1z+XrLk3Uc9CExMQWRXbSBUbV
        HlNzY9J84uU137bGbyR/e8fwnhVZ6h3CTcBaKgc=
X-Google-Smtp-Source: ABdhPJzdDM6goT56xy8NrC1Im5h2PLxsK1z1B5smHVWh5gRK6bhyWFVsr8jnF/vGAQOl234xaL+GEg==
X-Received: by 2002:a2e:a413:: with SMTP id p19mr2187289ljn.488.1634934702606;
        Fri, 22 Oct 2021 13:31:42 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id r14sm1065319ljj.0.2021.10.22.13.31.42
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 13:31:42 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id e19so1098427ljk.12
        for <linux-cifs@vger.kernel.org>; Fri, 22 Oct 2021 13:31:42 -0700 (PDT)
X-Received: by 2002:a2e:9945:: with SMTP id r5mr2174611ljj.249.1634934297582;
 Fri, 22 Oct 2021 13:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <163492911924.1038219.13107463173777870713.stgit@warthog.procyon.org.uk>
 <CAHk-=wjmx7+PD0hzWj5Bg2b807xYD2KCZApTvFje=ufo+MxBMQ@mail.gmail.com>
 <1041557.1634931616@warthog.procyon.org.uk> <CAHk-=wg2LQtWC3e4Z4EGQzEmsLjmk6jm67Ga6UMLY1MH6iDcNQ@mail.gmail.com>
In-Reply-To: <CAHk-=wg2LQtWC3e4Z4EGQzEmsLjmk6jm67Ga6UMLY1MH6iDcNQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 22 Oct 2021 10:24:41 -1000
X-Gmail-Original-Message-ID: <CAHk-=wi7K64wo4PtROxq_cLhfq-c-3aCbW5CjRfnKYA439YFUw@mail.gmail.com>
Message-ID: <CAHk-=wi7K64wo4PtROxq_cLhfq-c-3aCbW5CjRfnKYA439YFUw@mail.gmail.com>
Subject: Re: [PATCH v2 00/53] fscache: Rewrite index API and management system
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Jeff Layton <jlayton@kernel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 22, 2021 at 9:58 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> and if (c) is the thing that all the network filesystem people want,
> then what the heck is the point in keeping dead code around? At that
> point, all the rename crap is just extra work, extra noise, and only a
> distraction. There's no upside that I can see.

Again, I'm not a fan of (c) as an option, but if done, then the
simplest model would appear to be:

 - remove the old fscache code, obviously disabling the Kconfig for it
for each filesystem, all in one fell swoop.

 - add the new fscache code (possibly preferably in sane chunks that
explains the parts).

 - then do a "convert to new world order and enable" commit
individually for each filesystem

but as mentioned, there's no sane way to bisect things, or have a sane
development history in this kind of situation.

                Linus
