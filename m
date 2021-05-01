Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43185C433B4
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 18:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F43261476
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 18:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhEASgC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 May 2021 14:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbhEASf7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 May 2021 14:35:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C28C06174A
        for <linux-cifs@vger.kernel.org>; Sat,  1 May 2021 11:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8fGtZCgXLrfHoIn3wA2CrlkfXFlA1H86+Aibc8hx6bA=; b=u6s4yg5rRfcgNHcf1uSsNXepot
        YQAkczgrHcVbcjQ1H1YBZ8D9/tXwljraNvYwwkCL3MPhXUH/4dG8Qh5Rkbn+h/ZXAxSh0zTodfL6n
        sEgenXNZclTOXUz4atcAeD6XUze9IzY5Mu5gfsv01EVGloiu0WaHxHWrxX2r13Blc260bh6JDqJAL
        4JuDWTRKYXxN9H7eO865+pMgPNN3tuK55TNMSEHx6TZRInGS7E1AIzP7qfZs5NDWLILC7Hr4uGrZm
        XdX3LP7Kby9/2WztLA8avNsYgImj6uDapLipCxB12eXQHHXopE4jahpRsjPZSY9+lkPwyXrnXxAPp
        Mc1LJ8qg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lcuSE-00ChoL-5Y; Sat, 01 May 2021 18:35:03 +0000
Date:   Sat, 1 May 2021 19:35:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
Message-ID: <20210501183502.GU1847222@casper.infradead.org>
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org>
 <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
 <20210426115457.GJ235567@casper.infradead.org>
 <CANT5p=rHgmLdHJm_y3CCpb=KoEbnJApce2wx4hORY2CwHP2NbQ@mail.gmail.com>
 <20210430115948.GL1847222@casper.infradead.org>
 <CAH2r5mtE2g=p_rKThrDR_4N6=zqaBiz_KpK+bPpw5Q+qeFuTjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtE2g=p_rKThrDR_4N6=zqaBiz_KpK+bPpw5Q+qeFuTjQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 30, 2021 at 02:22:20PM -0500, Steve French wrote:
> On Fri, Apr 30, 2021 at 7:00 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Apr 30, 2021 at 04:19:27PM +0530, Shyam Prasad N wrote:
> > > Although ideally, I feel that we (cifs.ko) should be able to read in
> > > larger granular "chunks" even for small reads, in expectation that
> > > surrounding offsets will be read soon.
> >
> > Why?  How is CIFS special and different from every other filesystem that
> > means you know what the access pattern of userspace is going to be better
> > than the generic VFS?
> 
> In general small chunks are bad for network file systems since the 'cost' of
> sending a large read or write on the network (and in the call stack on
> the client
> and server, with various task switches etc) is not much more than a small one.
> This can be different on a local file system with less latency between request
> and response and fewer task switches involved on client and server.

Block-based filesystems are often, but not always local.  For example,
we might be using nbd, iSCSI, FCoE or something similar to include
network latency between the filesystem and its storage.  Even without
those possibilities, a NAND SSD looks pretty similar.  Look at the
graphic titled "Idle Average Random Read Latency" on this page:

https://www.intel.ca/content/www/ca/en/architecture-and-technology/optane-technology/balancing-bandwidth-and-latency-article-brief.html

That seems to be showing 5us software latency for an SSD with 80us of
hardware latency.  That says to me we should have 16 outstanding reads
to a NAND SSD in order to keep the pipeline full.

Conversely, a network filesystem might be talking to localhost,
and seeing much lower latency compared to going across the data
center, between data centres or across the Pacific.

So, my point is that Linux's readahead is pretty poor.  Adding
hacks in for individual filesystems isn't a good route to fixing it,
and reading larger chunks has already passed the point of dimnishing
returns for many workloads.

I laid it out in a bit more detail here:
https://lore.kernel.org/linux-fsdevel/20210224155121.GQ2858050@casper.infradead.org/
