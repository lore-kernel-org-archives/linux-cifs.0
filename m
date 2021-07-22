Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA25CC636C8
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 04:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CF3361222
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 04:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhGVDej (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jul 2021 23:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhGVDei (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jul 2021 23:34:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCEFC061575
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jul 2021 21:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2YXmoXVPATF/KqyNmSGmoaiuPXg2ieuzzWNfe2dfMhY=; b=XRJUkW9InCrB6Ybp5teM++esWV
        oUOGB3yu8RJzgvXaruOICjIv0u4qMffhtrh1YrBrG5KTZf7KWV+OIJbfi9GXGxP/qSQXVFC4nzmOC
        UJzgzz7JdqsGLI2q9/GkZ377bGf/Epg2rxELDEiBPwSAM+4u5sp26OW4msBf9FvMgiIgZQYcPY7DX
        T6YTkjuMk0tECXMyYFEFG1qA81Ny2VOhQOeU5ZZJGVqbErm0NbC8krrE03J9+l6SWlVNct1jw6A6p
        scGxWRenlTqWAqhgvzup1KLdd13gu6YSNTYCb8wD1BjgIj2VLGw2eSgRRgsH97TxscZwXYKi8kKxA
        90dK60dA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6Q6G-009sQP-Oc; Thu, 22 Jul 2021 04:14:31 +0000
Date:   Thu, 22 Jul 2021 05:14:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Classification of reads within a filesystem
Message-ID: <YPjwnHOFkKFKovI4@infradead.org>
References: <CANT5p=p+f6mrQqKULqJdbyDN-NJoQCsGruvVMH+BUJU0-n62rg@mail.gmail.com>
 <YPhexTyuuE0/Wxf5@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPhexTyuuE0/Wxf5@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 21, 2021 at 06:52:05PM +0100, Matthew Wilcox wrote:
> Oh ... except for swap.  For NFS only, it calls ->readpage, so it really
> wants ->readpage to be async so it can kick off multiple pages and
> then wait for the one it actually needs.  That gets into a conversation
> about how much we really care about swap-over-NFS, whether swap should
> be using ->readpage or ->direct_IO, and whether swap should use the
> file readahead code or its own virtual address based readahead code.
> Most of those discussions are outside my area of expertise.

It really should be using direct I/O.  I think one issue back in the
day was the odd locking requirements for swap, but that's something we
could overcome.
