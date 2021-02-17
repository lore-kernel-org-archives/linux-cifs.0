Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6923C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Feb 2021 14:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 888AD64E2E
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Feb 2021 14:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhBQOiT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Feb 2021 09:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbhBQOiR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Feb 2021 09:38:17 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7754FC06178A
        for <linux-cifs@vger.kernel.org>; Wed, 17 Feb 2021 06:37:08 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id s6so4500096otk.4
        for <linux-cifs@vger.kernel.org>; Wed, 17 Feb 2021 06:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=omnibond-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KRNZjZzTqfrWLRx1QJmelJFfxfPUcehdqwqj+L7mkPQ=;
        b=R8hCb4eKqdCpoFdkYTrVn7FoN33zUtyi/ljWByVLrm0nNn3tup4D+Hft33LDzdElis
         n16SrG3viJflBxrjVIN2QmmXO/BgPFSDWJe1ljVa2OopffyUF0+G8Fh9aoQpou3/MlTR
         6lOKbNE6+B3j4d5dwhv33gPtGhtt8L27dc4EMEm0vGnJ/TAunXib+QvZcOCi9i0mwM86
         k3prqX0Oe/sUpTqzEgE3HcERBdh4YwNsSjrGveT+xsSircuhGURdlWmXiZnYI5Mz2W8Z
         jNhEhauvpFlyX/F69JD4IZFRmykIsAN3vuO7r6enaGZ5EvFYprDuRwGgQKV+8pJmk5aD
         UJew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KRNZjZzTqfrWLRx1QJmelJFfxfPUcehdqwqj+L7mkPQ=;
        b=iBbYlL7G7oGtEjdE0MVyHIN8NYkprrq5mkHCHrwZBSeeP8xF/SKlRxaajWiSMYrdkb
         fqQmBtLGfUEUqrOTenxEnZ2rwuE8uOr9BtdxGMnnt9iYGGdGlPmj4kaoGX1Xa95CLYLV
         omfGWZJsiECfEVRJru3LlQHHOCAygjeDSSl/w5cRRErudJqOZ1WapFN6kqqkGkt7u/68
         eVlg8N/q7ZjL02X501HJ1e8BLlUJjGNYKiNoZJxKoODW3pzXSSOCNk7FMk5npaCaXIZU
         z4iCQFpU9JC+MWuCPOpnR01UIZkOgsJod2DhWs5OIZrXTV23IRDLlkPkkn6ZiafHb2Zc
         I7/w==
X-Gm-Message-State: AOAM531PhPonTygk4dy02B4unutEvJ6ZUQ/gi0YyS0jplJlPhUnRTEX3
        90Ebu/nBUTlBHLutDuXNIdeSffJ5a+bWLP/dv1VHSQ==
X-Google-Smtp-Source: ABdhPJy4hyW/PUrDPGqVg3UI4ZfJfCb8Vr2cdTNl0Mc8udn+hWDu9ZRGdP0xDV4oyRaIVmDhAucDgP/5yXuHdlUvdPs=
X-Received: by 2002:a05:6830:2424:: with SMTP id k4mr7412732ots.352.1613572627726;
 Wed, 17 Feb 2021 06:37:07 -0800 (PST)
MIME-Version: 1.0
References: <161340385320.1303470.2392622971006879777.stgit@warthog.procyon.org.uk>
 <161340389201.1303470.14353807284546854878.stgit@warthog.procyon.org.uk>
 <20210216103215.GB27714@lst.de> <20210216132251.GI2858050@casper.infradead.org>
In-Reply-To: <20210216132251.GI2858050@casper.infradead.org>
From:   Mike Marshall <hubcap@omnibond.com>
Date:   Wed, 17 Feb 2021 09:36:56 -0500
Message-ID: <CAOg9mSQYBjnMsDj5pMd6MOGTY5w_ZR=pw7VRYKfP5ZwmHBj2=Q@mail.gmail.com>
Subject: Re: [PATCH 03/33] mm: Implement readahead_control pageset expansion
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-mm <linux-mm@kvack.org>, linux-cachefs@redhat.com,
        linux-afs@lists.infradead.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        ceph-devel <ceph-devel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I plan to try and use readahead_expand in Orangefs...

-Mike

On Tue, Feb 16, 2021 at 8:28 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Feb 16, 2021 at 11:32:15AM +0100, Christoph Hellwig wrote:
> > On Mon, Feb 15, 2021 at 03:44:52PM +0000, David Howells wrote:
> > > Provide a function, readahead_expand(), that expands the set of pages
> > > specified by a readahead_control object to encompass a revised area with a
> > > proposed size and length.
> > >
> > > The proposed area must include all of the old area and may be expanded yet
> > > more by this function so that the edges align on (transparent huge) page
> > > boundaries as allocated.
> > >
> > > The expansion will be cut short if a page already exists in either of the
> > > areas being expanded into.  Note that any expansion made in such a case is
> > > not rolled back.
> > >
> > > This will be used by fscache so that reads can be expanded to cache granule
> > > boundaries, thereby allowing whole granules to be stored in the cache, but
> > > there are other potential users also.
> >
> > So looking at linux-next this seems to have a user, but that user is
> > dead wood given that nothing implements ->expand_readahead.
> >
> > Looking at the code structure I think netfs_readahead and
> > netfs_rreq_expand is a complete mess and needs to be turned upside
> > down, that is instead of calling back from netfs_readahead to the
> > calling file system, split it into a few helpers called by the
> > caller.
>
> That's funny, we modelled it after iomap.
>
> > But even after this can't we just expose the cache granule boundary
> > to the VM so that the read-ahead request gets setup correctly from
> > the very beginning?
>
> The intent is that this be usable by filesystems which want to (for
> example) compress variable sized blocks.  So they won't know which pages
> they want to readahead until they're in their iomap actor routine,
> see that the extent they're in is compressed, and find out how large
> the extent is.
