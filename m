Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8096DC433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 19:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F5E064E8C
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 19:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhBIT4q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 14:56:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233673AbhBITrq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 14:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612899956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=07hMrz2JH7QjjSYxmQ6iVqH/nriv3v/7Q+e4rDzWnzs=;
        b=ZWhxl+yIXM3Z5wT5KCTZnFiR5RRe8oTkXb8ZvOuzP0PYT5R/QEcAimqDdcODJYrCNHkPe6
        OGVHa6D8MXqC4+fV5mUKvEw8KeJz/g1vz7UMe+328/ZfGryTCA214HRphBV6tMD6xahxCP
        lMGhWYcZEtf+Sr+e1brkLIzsCVMSF8I=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-ZWJjmjf9NTCWi3foJ7MC5A-1; Tue, 09 Feb 2021 14:45:53 -0500
X-MC-Unique: ZWJjmjf9NTCWi3foJ7MC5A-1
Received: by mail-qv1-f71.google.com with SMTP id q37so13939980qvf.14
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 11:45:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=07hMrz2JH7QjjSYxmQ6iVqH/nriv3v/7Q+e4rDzWnzs=;
        b=ANR168ZYjEXkhmpt8Q9h2dLEQS9wK72bmNqqm5t3Xknhk3EJ/ITytkt9Oo/WIw2oyC
         WOp2GWOf3DFwFdmv3pqcBnStAVQ+mlNeMKAHNoauFaLtiLqwboL/tFKkrNpai1dUEQRh
         1KlLNa9SZL3RbkINzfA8M9ybyZnidb4tfT4gJTHV1/UokGACFE805JlL5cOtyrU5uxC7
         DxhPawPNzZvqyyP6L8L8fOLQmsuHsZz6kQaqWuJmq7MoVw7l+hOMLjyaNG3wkrLTUj2l
         zF18CIULtDhj93baEHsSTAYXqY/7I+WpZrT+GnlannRzxYmVlARg9oW4Fbmo0BiU9zXK
         qYew==
X-Gm-Message-State: AOAM532y0HiwBAAETsaT8B2QzVnFGgTKXwxpU6gyOgFdqszOOPObVXoK
        1/FWvelyrxQ+YSIuFRlLMnREvvwBr+E0AuDEyn59qm+MvVeoJ+vJ4498ZvNJFu5FjIoJ+8tJkeP
        wyl0ncTGtnPgE7CWg1jVu/w==
X-Received: by 2002:a37:4fcf:: with SMTP id d198mr23988260qkb.277.1612899953138;
        Tue, 09 Feb 2021 11:45:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJybD7SbuYQXGOXd3mMxVBLEZfaSpNELJGXVWAV5LvAAprhYnJ48OVnrJ8zBSJ4tAUenGug78w==
X-Received: by 2002:a37:4fcf:: with SMTP id d198mr23988232qkb.277.1612899952938;
        Tue, 09 Feb 2021 11:45:52 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id p16sm3234618qtq.24.2021.02.09.11.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:45:52 -0800 (PST)
Message-ID: <c9d5464484dc7013eba9f49e88c19712c1276c31.camel@redhat.com>
Subject: Re: [GIT PULL] fscache: I/O API modernisation and netfs helper
 library
From:   Jeff Layton <jlayton@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
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
Date:   Tue, 09 Feb 2021 14:45:51 -0500
In-Reply-To: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
References: <591237.1612886997@warthog.procyon.org.uk>
         <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 2021-02-09 at 11:06 -0800, Linus Torvalds wrote:
> So I'm looking at this early, because I have more time now than I will
> have during the merge window, and honestly, your pull requests have
> been problematic in the past.
> 
> The PG_fscache bit waiting functions are completely crazy. The comment
> about "this will wake up others" is actively wrong, and the waiting
> function looks insane, because you're mixing the two names for
> "fscache" which makes the code look totally incomprehensible. Why
> would we wait for PF_fscache, when PG_private_2 was set? Yes, I know
> why, but the code looks entirely nonsensical.
> 
> So just looking at the support infrastructure changes, I get a big "Hmm".
> 
> But the thing that makes me go "No, I won't pull this", is that it has
> all the same hallmark signs of trouble that I've complained about
> before: I see absolutely zero sign of "this has more developers
> involved".
> 
> There's not a single ack from a VM person for the VM changes. There's
> no sign that this isn't yet another "David Howells went off alone and
> did something that absolutely nobody else cared about".
> 
> See my problem? I need to be convinced that this makes sense outside
> of your world, and it's not yet another thing that will cause problems
> down the line because nobody else really ever used it or cared about
> it until we hit a snag.
> 
>                   Linus
> 

I (and several other developers) have been working with David on this
for the last year or so. Would it help if I gave this on the netfs lib
work and the fscache patches?

    Reviewed-and-tested-by: Jeff Layton <jlayton@redhat.com>

My testing has mainly been with ceph. My main interest is that this
allows us to drop a fairly significant chunk of rather nasty code from
fs/ceph. The netfs read helper infrastructure makes a _lot_ more sense
for a networked filesystem, IMO.

The legacy fscache code has some significant bugs too, and this gives it
a path to making better use of more modern kernel features. It should
also be set up so that filesystems can be converted piecemeal.

I'd really like to see this go in.

Cheers,
Jeff

