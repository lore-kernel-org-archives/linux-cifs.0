Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478C8C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jan 2022 15:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbiAXP6t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238984AbiAXP6s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jan 2022 10:58:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A44C06173B
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jan 2022 07:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4Nths1xSV07jRDan2+4x2hrZzqY6pCUb+S+NPyH0N7Q=; b=aDq6hz0g2HXOvMKnBqNv0JSidR
        fIGBns1+rDnpAUrBIDng5j08MY90q8Zpgl++CW7pdJo1ZH5H236fNkOd1kxxkoEk0nsnl4u461smw
        vsTO6APAct1axlV2vWeEBgpXzB8ZlPB0NMez9KbeIXDeGR0ny0ppN2vtlE9h83qOfOag94eKHsAkE
        ZrEDHj9MCPJv3nQ5Ls4y+VW2C3kpgh3dV0w4BlZGcEVsWOfJETTGqJd+2saZoEbzGLPxoJgQXSbKd
        4EYfsJhzF43FfLjuZ0rwPc9PWUxoa5JqFaDmmGUWsJQTFtO0QbCsaEPD6fYrzrk0GG3um2EK13hsM
        B1HlX3Wg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nC1jv-000rou-RY; Mon, 24 Jan 2022 15:58:43 +0000
Date:   Mon, 24 Jan 2022 15:58:43 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     smfrench@gmail.com, nspmangalore@gmail.com,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com
Subject: Re: [RFC PATCH] cifs: Transition from ->readpages() to ->readahead()
Message-ID: <Ye7Ms67MA0kycc/x@casper.infradead.org>
References: <Ye7GtNRgxkT9S6sG@casper.infradead.org>
 <Ye61jfhL7K9Ethxz@casper.infradead.org>
 <164303051132.2163193.10493291874899600548.stgit@warthog.procyon.org.uk>
 <2255918.1643037281@warthog.procyon.org.uk>
 <2270964.1643039187@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2270964.1643039187@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 24, 2022 at 03:46:27PM +0000, David Howells wrote:
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > > Would it be possible to make readahead_count() do:
> > > 
> > > 	return rac->_nr_pages - rac->_batch_count;
> > > 
> > > maybe?
> > 
> > Yes, I think that would make sense.  Do we also need to change
> > readhead_length()?  It seems to me that it's only ever called once at
> > initialisation, so it should be possible to keep the two in sync.
> > Can you write & test such a patch?  I'll support it going upstream
> > (either by taking it myself or giving you a R-b to take it through your
> > tree).
> 
> It seems I also have a problem with readahead_index() needing compensation
> too.  I'm guessing that's more of a problem, however, as I think that's
> expected to refer to the beginning of the current batch.

Well, that's the problem isn't it?  You're expecting to mutate the state
and then refer to its previous state instead of its current state,
whereas the other users refer to the current state instead of the
previous state.  Can't you pull readahead_index() out of the ractl
ahead of the mutation?
