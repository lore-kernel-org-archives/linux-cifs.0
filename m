Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE925C433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 19:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C9764ECC
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 19:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhBITSe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 14:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbhBITIC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 14:08:02 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709F7C0617AB
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 11:06:59 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id f8so14131304ljk.3
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 11:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tHDrQ7k7QBExa6hxOU6qMztojmSPjc893LQ4fde7dg=;
        b=akIN38EhQAi1EJYSeLBzpY86D4HcP1JFpL9GOZ+0RTnCkorkEfcVrIAVKTL3jMnG1S
         wB2qolfwaFv21H7u2zEEkvnFpGX1nEHeJ1S4J1sfz5c5YnXEdHBQ4kH64G0jT9/l9/e6
         eD4OPnbfiSTjG9KsSbeEkIcjaKRrzYZYK/x80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tHDrQ7k7QBExa6hxOU6qMztojmSPjc893LQ4fde7dg=;
        b=OjQLzZj1ezUlOhQ69nqILwJUI3cdjrOHDeo8ZD49b1ICpQ/su0Zhhh/Xpna5L1co5g
         agqiVcGdFpu5QMOS62dIpCaYXewgB5o3RMdF20Chic2MAIiryhP1dvUOqGYP2Ae1ZSIB
         ZUfd/PRmfHQ+ZHxS/HRd0XJDgcRIxCzsAGLq8BXr4tLK2YqRocYsv2sHDVm06Q0XqNWZ
         6mq8T/9wRWQ4riae4tnurGHxC1suv8M1DesuaKZCY7yYkvZH5eI69ratUaRpEIcKcf8a
         ADDhC7hat1lHVZTBuhsU8VAl3rt/CpSQbhpqGSIXfPJK1LqBqz+6fDT8+uUSSH5ieBlE
         OuGg==
X-Gm-Message-State: AOAM531cC2vfbb60n5lvT3aB/HUu/NyGi00DyyU9bPThQ7L6rESC8IoR
        m3iY8eVPeTrJeP3G934tdiFIOt0rnQaVKA==
X-Google-Smtp-Source: ABdhPJzaopksyd3Tq8wDy5sPoNCu9LY9u93IIxMwfGB+qMCTxAZPvnD8mEmC4WgEIIlz/WBfZZCCRQ==
X-Received: by 2002:a2e:904d:: with SMTP id n13mr15274617ljg.389.1612897617903;
        Tue, 09 Feb 2021 11:06:57 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id b25sm2721161lfi.260.2021.02.09.11.06.57
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 11:06:57 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id j19so9717951lfr.12
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 11:06:57 -0800 (PST)
X-Received: by 2002:a19:c14c:: with SMTP id r73mr13646015lff.201.1612897616810;
 Tue, 09 Feb 2021 11:06:56 -0800 (PST)
MIME-Version: 1.0
References: <591237.1612886997@warthog.procyon.org.uk>
In-Reply-To: <591237.1612886997@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Feb 2021 11:06:41 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
Message-ID: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
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

So I'm looking at this early, because I have more time now than I will
have during the merge window, and honestly, your pull requests have
been problematic in the past.

The PG_fscache bit waiting functions are completely crazy. The comment
about "this will wake up others" is actively wrong, and the waiting
function looks insane, because you're mixing the two names for
"fscache" which makes the code look totally incomprehensible. Why
would we wait for PF_fscache, when PG_private_2 was set? Yes, I know
why, but the code looks entirely nonsensical.

So just looking at the support infrastructure changes, I get a big "Hmm".

But the thing that makes me go "No, I won't pull this", is that it has
all the same hallmark signs of trouble that I've complained about
before: I see absolutely zero sign of "this has more developers
involved".

There's not a single ack from a VM person for the VM changes. There's
no sign that this isn't yet another "David Howells went off alone and
did something that absolutely nobody else cared about".

See my problem? I need to be convinced that this makes sense outside
of your world, and it's not yet another thing that will cause problems
down the line because nobody else really ever used it or cared about
it until we hit a snag.

                  Linus
