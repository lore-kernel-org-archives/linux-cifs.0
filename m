Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7556C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Dec 2021 17:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbhLJRhv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Dec 2021 12:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhLJRhu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Dec 2021 12:37:50 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABFCC0617A2
        for <linux-cifs@vger.kernel.org>; Fri, 10 Dec 2021 09:34:15 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so31419158edb.8
        for <linux-cifs@vger.kernel.org>; Fri, 10 Dec 2021 09:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3QIa6rww9jro5nDJeWJFjVScPd67gpaO9LJRBQi9fOg=;
        b=M3iMr1TySf2JhF71PNm9vqUmHaN3ndNQHG/JvqEwurXQFVAc3WLPhhZJWkmxcv/iii
         e3cwFXBPK/cCe5z8o6p2trgcoV9h7Txs5HiF7R/U4M4BIEHcWNhyWg+ifoYKoycIB0+H
         5wF+CXd7RhgARAEG0l0SAd8Fi9xRrg4j8P6mw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3QIa6rww9jro5nDJeWJFjVScPd67gpaO9LJRBQi9fOg=;
        b=lx91kbjlGEG5H36td9Hg5jqKnASbNSYjc6QUy0L+CDxgSn8FCzw1j6R69NeoitJnX4
         fzQZHf3NaRNSlP1w7NZQ6+fF6NBRUaF6andStcsIq6NsXLuY1jXG09Oz6rDiq0LYQ+rZ
         +Pwpka7MkkStNmB2uOQLACloqJe5VuDusEeqpyPckKMpnqL12GuZ4VOE8Pq7AeClIrI1
         mLEiZ/bOKSeNOEwAen+5zIC34nladZ9YePx/qhQUbDz6ZuZsp+Cy5kiXVRQIKxWhNY7C
         4qyBoGKwScz3tpXTgbZhvrWC5pfzUpg3BwZByNOTS8M8gqQU3lOAZZJd2Yf/lk5TKGMy
         ErLw==
X-Gm-Message-State: AOAM533aG7Cd4lgv0hl+qeVyhCPGC1T+4B8v9n9m7S4qWfdIjjz1fOG0
        e7gX2WpKbBJ8Ux988Ah5mDmMDg6n11btFgBXBeI=
X-Google-Smtp-Source: ABdhPJxOrlosdWO1JKZvHzfnUib7NUFst/jXTBPomm4I+54GSkuZNp4cBRqkFSWqBtgFa3GDx06E4Q==
X-Received: by 2002:aa7:d34c:: with SMTP id m12mr41104576edr.269.1639157652736;
        Fri, 10 Dec 2021 09:34:12 -0800 (PST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id e26sm1876642edr.82.2021.12.10.09.34.11
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 09:34:12 -0800 (PST)
Received: by mail-wr1-f53.google.com with SMTP id d24so16270636wra.0
        for <linux-cifs@vger.kernel.org>; Fri, 10 Dec 2021 09:34:11 -0800 (PST)
X-Received: by 2002:a5d:54c5:: with SMTP id x5mr15464416wrv.442.1639157651522;
 Fri, 10 Dec 2021 09:34:11 -0800 (PST)
MIME-Version: 1.0
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
 <163906888735.143852.10944614318596881429.stgit@warthog.procyon.org.uk>
 <CAHk-=wiTquFUu-b5ME=rbGEF8r2Vh1TXGfaZZuXyOutVrgRzfw@mail.gmail.com>
 <159180.1639087053@warthog.procyon.org.uk> <CAHk-=whtkzB446+hX0zdLsdcUJsJ=8_-0S1mE_R+YurThfUbLA@mail.gmail.com>
 <288398.1639147280@warthog.procyon.org.uk>
In-Reply-To: <288398.1639147280@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Dec 2021 09:33:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiHm-rNkeLXcOt4oV_BMzC5DeZ5FYt+yjbA_GjN2wcd5w@mail.gmail.com>
Message-ID: <CAHk-=wiHm-rNkeLXcOt4oV_BMzC5DeZ5FYt+yjbA_GjN2wcd5w@mail.gmail.com>
Subject: Re: [PATCH v2 07/67] fscache: Implement a hash function
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Dec 10, 2021 at 6:41 AM David Howells <dhowells@redhat.com> wrote:
>
> However, since the comparator functions are only used to see if they're the
> same or different, the attached change makes them return bool instead, no
> cast or subtraction required.

Ok, thanks, that resolves my worries.

Which is not to say it all works - I obviously only scanned the
patches rather than testing anything.

                Linus
