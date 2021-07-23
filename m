Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B29C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jul 2021 10:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023A760EE6
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jul 2021 10:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhGWJ44 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jul 2021 05:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhGWJ4z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jul 2021 05:56:55 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3744C061575
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jul 2021 03:37:29 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id f26so1619212ybj.5
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jul 2021 03:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y1oEEb2YB06siB9/sdZKD9h7wf32Hffq1f5yLHxoIZ8=;
        b=NJURzmB57P4lTryPCH+kec+7mzAxTDBbP/qriqMPfppTKKGVQ9G3faElJTRZgLJ6bK
         mjAPYvSoqkd5Ha1SNhBLaS8WMkqcYxO2yJ7FJC39T2f5a+X16wLYg/Vu9W8mob01fvRe
         ykLNZ7/qoIPPlYnJmB0B0HrNl8xnyD0BdP7Cc2nHjhgIx1y32a/481ElGNB2MDP5svVH
         XfKoRQVjUOMWv291A2Sdi3h18cDr1Xnf4Z4lMgjWXnBEHxTiFSfbCSWr/DyI1rcN5kkT
         zMYqfRxGv/dHR30dYSvE2FvKvw5jiXNY42p4YcO4XWBPTxvb1KwX+TWF9F8l6KzOkzql
         7ZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y1oEEb2YB06siB9/sdZKD9h7wf32Hffq1f5yLHxoIZ8=;
        b=G7KRUSsUX1hhyKwmmJWQjnst4bwNbOvQa8l4irWzk4SlEKHk0kn+DdN/LbghPTEc7o
         p5OpfVzB2NamXVKpHZpn8AtWnS90VJ4BtkfLZDe5MCftVFUr7UWVQ07bD98opjfqVVnp
         t++sDUtehj3pXyPCzQXZSyc+Gt2nJXgDzVo3wkk0LOXoTZtKoF3RLxltX9Q1y73KgRTG
         QFYcu3N91XDIkuLg/o7pRpYz4vt91oS1Q/KbKJn1jvMtFp2T4BhD9Sa2xFzfwacUDbwE
         6kiHYMbs5i3Esw7gaCzuS8tlItgbgarN0wLFT7M+gN/dDXuPZmywQtVIfLqo6bHQcXBi
         qhEA==
X-Gm-Message-State: AOAM5332ZQFUhlcaMl92rVG49hZcLt6+aamwVj7FVrG9Jzg2LgmWzRGI
        Isdt2+NN4RkfcUbrmujlnRjDngg7wsEHEp/SIfs=
X-Google-Smtp-Source: ABdhPJz7S/kVjy67sHbMErj73eTFR+J73ROyfoPzQM5KuMlioGpr2R7xnDXSoAOW2RH4fUvyelGFNKbCgJ350ZMQsVM=
X-Received: by 2002:a05:6902:690:: with SMTP id i16mr2896137ybt.327.1627036648822;
 Fri, 23 Jul 2021 03:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=p+f6mrQqKULqJdbyDN-NJoQCsGruvVMH+BUJU0-n62rg@mail.gmail.com>
 <YPhexTyuuE0/Wxf5@casper.infradead.org>
In-Reply-To: <YPhexTyuuE0/Wxf5@casper.infradead.org>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 23 Jul 2021 16:07:17 +0530
Message-ID: <CANT5p=rCCoP3ScU80giZmGvM225e4u_W4hqB892vpNhj2J=auw@mail.gmail.com>
Subject: Re: Classification of reads within a filesystem
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 21, 2021 at 11:22 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Jul 21, 2021 at 10:38:59PM +0530, Shyam Prasad N wrote:
> > In a scenario where a user/application issues a readahead/fadvise for
> > large data ranges in advance (informing the kernel that they intend to
> > read these data ranges soon). Depending on how much data ranges these
> > calls cover, it could keep the network quite busy for a network
> > filesystem (or the disk for a block filesystem).
> >
> > I see some value if filesystems have the ability to differentiate the
> > reads from regular buffered reads by users. In such cases, the
> > filesystem can choose to throttle the readahead reads, so that there's
> > a specified bandwidth that's still available for regular reads.
> >
> > I wanted to get your opinions about this. And whether this can be done
> > already in VFS ->readahead and ->readpage calls in the filesystems?
>
> This is something I have an interest in, but haven't had time to pursue.
> The readahead code gets this information because the page cache
> calls page_cache_sync_ra() if it needs this page right now, and calls
> page_cache_async_ra() if it thinks it will need the page in the future.
>
> ondemand_readahead() currently gets a true/false parameter
> (hit_readahead_marker), although my folio patches change it to pass in
> a folio or NULL.  That is then *not* passed to the filesystem, but it
> could be information passed in the ractl.
>


Hi Matthew,

I don't yet know if this can be useful in other scenarios.
But for the above scenario (of eagerly calling readahead), I thought
that this info can be used by a filesystem for throttling, which it
doesn't get today.
I was also thinking that there could potentially be other
classifications, apart from sync vs async, for example the process IO
priority.
Today, I don't see the process IO priority used by block layer, and
not in vfs or the individual filesystems.
Do you think this is also another info that could/should trickle down
to individual filesystems?

CCing fsdevel also to get more inputs on this.

> There's also some tidying-up to be done around faulting.  Currently
> fault-around doesn't have a way to express "read me all the pages around
> page N".  Instead it just assumes that pages N-R/2 to N+R/2 are the
> right ones to fetch when it should be left up to the filesystem or the
> readahead code to determine what window of pages to fetch.
>
> Another thing I have an interest in doing but not had opportunity to
> pursue is making ->readpage synchronous.  The current MM code always
> calls ->readahead first and only calls ->readpage if ->readahead fails.
> That means that all the async ->readpage work is actually wrong; we
> want to return the best error possible from ->readpage, even if that
> means sleeping.
>
> Oh ... except for swap.  For NFS only, it calls ->readpage, so it really
> wants ->readpage to be async so it can kick off multiple pages and
> then wait for the one it actually needs.  That gets into a conversation
> about how much we really care about swap-over-NFS, whether swap should
> be using ->readpage or ->direct_IO, and whether swap should use the
> file readahead code or its own virtual address based readahead code.
> Most of those discussions are outside my area of expertise.



-- 
Regards,
Shyam
