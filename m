Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85600C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jan 2022 16:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243727AbiAXQZX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jan 2022 11:25:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241069AbiAXQZT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Jan 2022 11:25:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643041518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=45y0rqvL9PrCsPiej5QuHrzUJdmk2PF6mToDPtmFIRs=;
        b=iK/13tqlzb8v6r0NmvF2L8iz2cTjOL6coVtuOK4IkfnrIlc2apu8MilYzyvbxM5N1Kdx9r
        FSNM8G9T+Yt6dU7IOuGZPKaQmUaBttGVXi0Gqx8rgOglh2VWqbeRFL3ekOGVEZOTfx/RZj
        1P5Z1my5bdpAnAupxDWaPnXCCijXq5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-Gd4bdi3KP6OymKjlNpAPNw-1; Mon, 24 Jan 2022 11:25:15 -0500
X-MC-Unique: Gd4bdi3KP6OymKjlNpAPNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3468801B2D;
        Mon, 24 Jan 2022 16:25:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5063D10694E9;
        Mon, 24 Jan 2022 16:25:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Ye7Ms67MA0kycc/x@casper.infradead.org>
References: <Ye7Ms67MA0kycc/x@casper.infradead.org> <Ye7GtNRgxkT9S6sG@casper.infradead.org> <Ye61jfhL7K9Ethxz@casper.infradead.org> <164303051132.2163193.10493291874899600548.stgit@warthog.procyon.org.uk> <2255918.1643037281@warthog.procyon.org.uk> <2270964.1643039187@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, smfrench@gmail.com, nspmangalore@gmail.com,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com
Subject: Re: [RFC PATCH] cifs: Transition from ->readpages() to ->readahead()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2311839.1643041511.1@warthog.procyon.org.uk>
Date:   Mon, 24 Jan 2022 16:25:11 +0000
Message-ID: <2311840.1643041511@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> Well, that's the problem isn't it?  You're expecting to mutate the state
> and then refer to its previous state instead of its current state,

No.  I *don't* want to see the previous state.  That's where the problem is:
The previous state isn't cleared up until the point I ask for a new batch -
but I need to query the ractl to find the remaining window before I can ask
for a new batch.

The first pass through the loop is, in effect, substantially different to the
second and subsequent passes.

> whereas the other users refer to the current state instead of the
> previous state.

Fuse has exactly the same issues:

		nr_pages = readahead_count(rac) - nr_pages;
		if (nr_pages > max_pages)
			nr_pages = max_pages;
		if (nr_pages == 0)
			break;
		ia = fuse_io_alloc(NULL, nr_pages);
		...
		nr_pages = __readahead_batch(rac, ap->pages, nr_pages);

It needs to find out how many pages it needs so that it can allocate its page
array before it can get a new batch, but the ractl is holding the previous
state.

> Can't you pull readahead_index() out of the ractl ahead of the mutation?

I'm not sure what you mean by that.  What I'm now doing is:

	while ((nr_pages = readahead_count(ractl) - ractl->_batch_count)) {
		...
		pgoff_t index = readahead_index(ractl) + ractl->_batch_count;
		...
		rc = cifs_fscache_query_occupancy(
			ractl->mapping->host, index, nr_pages,
		...
		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
						   &rsize, credits);
		...
		nr_pages = min_t(size_t, rsize / PAGE_SIZE, readahead_count(ractl));
		nr_pages = min_t(size_t, nr_pages, next_cached - index);
		...
		rdata = cifs_readdata_alloc(nr_pages, cifs_readv_complete);
		...
		got = __readahead_batch(ractl, rdata->pages, nr_pages);
		...
	}

I need the count to know how many, if any, pages are remaining; I need the
count and index of the window to find out if fscache has any data; I need the
count to allocate a page array.  Only after all that can I crank the next
batch for the server (assuming I didn't delegate to the cache along the way,
but that calls readahead_page()).

(Yes, I would like to remove this code entirely and just call into netfslib.
I have patches to do that, but it involves quite an overhaul of the cifs
driver, but the above might get cifs caching again more quickly pending that.
Maybe I should just take the easy way here and cache the last state so that I
can compensate in the way fuse does).

David

