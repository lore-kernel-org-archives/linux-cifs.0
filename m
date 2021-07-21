Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01293C636C9
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 17:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58146121F
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jul 2021 17:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhGURMC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jul 2021 13:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhGURMC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jul 2021 13:12:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F80C061575
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jul 2021 10:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PLDV3KPiBnbLIxraVn//g4kOgYAF2S8s9GAYsctJ7t4=; b=hNdFQfBEYOh3EBcM0eAizxqE5M
        S9CYp8nGWBEgkqCkGu7Hx2l6nrIJDNfgQc0awMKQfreSjYr358OKdqJHHoKS7It1NVYn7ZIhUXZwI
        zpwZC8DJsSYV9SrKV8KCKynWpdzpKtYc2K1PDC3EvMwtTlyyj423Dbw3u6DcHm0nIK7dHfs0mKnfQ
        xcfrrPHNg/YE4pHaRGTinnH0wS1dk8B/MxOTov3tMh0/pnzUW/aeyGSZFQDg4RVWxMOyr6ngDF/Vb
        /OMpr4i4pvrE5CpILCg2+I8uH/2YFrdW2qqSyBAeUjJ6MRQywrWkhkBc0jPZXR26oF04+S1fJxtOR
        V8e8n6FQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6GO5-009SFA-Mc; Wed, 21 Jul 2021 17:52:10 +0000
Date:   Wed, 21 Jul 2021 18:52:05 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Classification of reads within a filesystem
Message-ID: <YPhexTyuuE0/Wxf5@casper.infradead.org>
References: <CANT5p=p+f6mrQqKULqJdbyDN-NJoQCsGruvVMH+BUJU0-n62rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANT5p=p+f6mrQqKULqJdbyDN-NJoQCsGruvVMH+BUJU0-n62rg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 21, 2021 at 10:38:59PM +0530, Shyam Prasad N wrote:
> In a scenario where a user/application issues a readahead/fadvise for
> large data ranges in advance (informing the kernel that they intend to
> read these data ranges soon). Depending on how much data ranges these
> calls cover, it could keep the network quite busy for a network
> filesystem (or the disk for a block filesystem).
> 
> I see some value if filesystems have the ability to differentiate the
> reads from regular buffered reads by users. In such cases, the
> filesystem can choose to throttle the readahead reads, so that there's
> a specified bandwidth that's still available for regular reads.
> 
> I wanted to get your opinions about this. And whether this can be done
> already in VFS ->readahead and ->readpage calls in the filesystems?

This is something I have an interest in, but haven't had time to pursue.
The readahead code gets this information because the page cache
calls page_cache_sync_ra() if it needs this page right now, and calls
page_cache_async_ra() if it thinks it will need the page in the future.

ondemand_readahead() currently gets a true/false parameter
(hit_readahead_marker), although my folio patches change it to pass in
a folio or NULL.  That is then *not* passed to the filesystem, but it
could be information passed in the ractl.

There's also some tidying-up to be done around faulting.  Currently
fault-around doesn't have a way to express "read me all the pages around
page N".  Instead it just assumes that pages N-R/2 to N+R/2 are the
right ones to fetch when it should be left up to the filesystem or the
readahead code to determine what window of pages to fetch.

Another thing I have an interest in doing but not had opportunity to
pursue is making ->readpage synchronous.  The current MM code always
calls ->readahead first and only calls ->readpage if ->readahead fails.
That means that all the async ->readpage work is actually wrong; we
want to return the best error possible from ->readpage, even if that
means sleeping.

Oh ... except for swap.  For NFS only, it calls ->readpage, so it really
wants ->readpage to be async so it can kick off multiple pages and
then wait for the one it actually needs.  That gets into a conversation
about how much we really care about swap-over-NFS, whether swap should
be using ->readpage or ->direct_IO, and whether swap should use the
file readahead code or its own virtual address based readahead code.
Most of those discussions are outside my area of expertise.
