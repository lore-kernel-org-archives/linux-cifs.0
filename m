Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4873DC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jan 2022 14:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389022AbiAYOoo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Jan 2022 09:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580005AbiAYOlf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Jan 2022 09:41:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256C0C061749
        for <linux-cifs@vger.kernel.org>; Tue, 25 Jan 2022 06:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SxzwNPb+8L5l7COlADYOY1zE/U72F31PI7I+27pXwO4=; b=OWQZRSF3LlklJweEVKYwrMRQ/r
        k2TZDHWleJpOjcaJMzDiEV0dciekgMcKb0oAfZK1etsgfQH7vIM2z+IfhkK/JrFW8/EIWIbo8kROh
        lEmbfqBNcMueTaN+dti2HXSKY4JSSJlZkz+GDQV9k+fDUS3c8BgNr+5xqp43/LTkZkrenbcI77EtK
        7mvmTJMyfuZV8FjyP+kgkQvFpvtyZoBIlEBX0vZcZA9xUqU+sPqSJs7ifB4O0K4ocGcFs40IDoONb
        4c+nAXTEFdfuIzd9vhVutUyxOpe3CGDPr2WwYZ4UASmieGvEfSUYVzhhgNCE/eNsv7MurXxHnnrWv
        ej8PdtXg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nCN0h-002ytE-Rg; Tue, 25 Jan 2022 14:41:27 +0000
Date:   Tue, 25 Jan 2022 14:41:27 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     smfrench@gmail.com, nspmangalore@gmail.com,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com
Subject: Re: [RFC PATCH] cifs: Transition from ->readpages() to ->readahead()
Message-ID: <YfAMF/azs+59zNiU@casper.infradead.org>
References: <Ye7Ms67MA0kycc/x@casper.infradead.org>
 <Ye7GtNRgxkT9S6sG@casper.infradead.org>
 <Ye61jfhL7K9Ethxz@casper.infradead.org>
 <164303051132.2163193.10493291874899600548.stgit@warthog.procyon.org.uk>
 <2255918.1643037281@warthog.procyon.org.uk>
 <2270964.1643039187@warthog.procyon.org.uk>
 <2311840.1643041511@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2311840.1643041511@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 24, 2022 at 04:25:11PM +0000, David Howells wrote:
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > Well, that's the problem isn't it?  You're expecting to mutate the state
> > and then refer to its previous state instead of its current state,
> 
> No.  I *don't* want to see the previous state.  That's where the problem is:
> The previous state isn't cleared up until the point I ask for a new batch -
> but I need to query the ractl to find the remaining window before I can ask
> for a new batch.

Oh, right, even worse -- you want to know the _future_ state of the
iterator before you mutate it (it's kind of the same thing though
if you haven't looked at how the iterator works internally).

> > whereas the other users refer to the current state instead of the
> > previous state.
> 
> Fuse has exactly the same issues:

... and yet you refuse to solve it the same way as fuse ...

> > Can't you pull readahead_index() out of the ractl ahead of the mutation?
> 
> I'm not sure what you mean by that.  What I'm now doing is:
> 
> 	while ((nr_pages = readahead_count(ractl) - ractl->_batch_count)) {
> 		...
> 		pgoff_t index = readahead_index(ractl) + ractl->_batch_count;
> 		...
> 		rc = cifs_fscache_query_occupancy(
> 			ractl->mapping->host, index, nr_pages,
> 		...
> 		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
> 						   &rsize, credits);
> 		...
> 		nr_pages = min_t(size_t, rsize / PAGE_SIZE, readahead_count(ractl));
> 		nr_pages = min_t(size_t, nr_pages, next_cached - index);
> 		...
> 		rdata = cifs_readdata_alloc(nr_pages, cifs_readv_complete);
> 		...
> 		got = __readahead_batch(ractl, rdata->pages, nr_pages);
> 		...
> 	}
> 
> I need the count to know how many, if any, pages are remaining; I need the
> count and index of the window to find out if fscache has any data; I need the
> count to allocate a page array.  Only after all that can I crank the next
> batch for the server (assuming I didn't delegate to the cache along the way,
> but that calls readahead_page()).

The problem is that the other users very much want to refer to the
pre-mutation state.  eg, btrfs:

        while ((nr = readahead_page_batch(rac, pagepool))) {
                u64 contig_start = readahead_pos(rac);
                u64 contig_end = contig_start + readahead_batch_length(rac) - 1;

                contiguous_readpages(pagepool, nr, contig_start, contig_end,
                                &em_cached, &bio_ctrl, &prev_em_start);
        }

The API isn't designed to work the way you want it to work.  So either
we redesign it (... and change all the existing users ...) or you use
it the way that FUSE does, which is admittedly suboptimal, but you're
also saying it's temporary.
