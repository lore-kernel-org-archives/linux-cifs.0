Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0934EC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jan 2022 15:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiAXPdO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiAXPdO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jan 2022 10:33:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BDDC06173B
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jan 2022 07:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yUUkWxbLlRqVBAMJJzNS0zsqboRsJTfNewHgjQkkKnI=; b=Wfe6ggQ5DQaKQGuHgmtCz+UveI
        VFaRirBAuUGCQ0RLm0gN6FMSqV6oD7G0Io74fSlorBqFepqGZ4h51BBwJoiHFku2/o6t2mankGkJa
        0gqlR1rGfKYAQWK2bOTb+b1Al/SpfE9v1auzDXyHTo7mdCKNjHashrjbC7Y3L1kS97xFYfKzNatDT
        BfEcEFqPwnIwi+GWxsHlzGKQWXidGQqqsE4k5vtLYnaVP/PgehHsT02B7n49jbKXXAnFUa6nWoR4N
        9sAlj0uITUAZpakbrvfdgH9qXSEIYiON+WS8u+XdVh2DMK+EjNugrvrdvxE4P2Yj3YklD1F6ZwiU1
        gldOShaw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nC1LA-000pgD-TO; Mon, 24 Jan 2022 15:33:08 +0000
Date:   Mon, 24 Jan 2022 15:33:08 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     smfrench@gmail.com, nspmangalore@gmail.com,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com
Subject: Re: [RFC PATCH] cifs: Transition from ->readpages() to ->readahead()
Message-ID: <Ye7GtNRgxkT9S6sG@casper.infradead.org>
References: <Ye61jfhL7K9Ethxz@casper.infradead.org>
 <164303051132.2163193.10493291874899600548.stgit@warthog.procyon.org.uk>
 <2255918.1643037281@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2255918.1643037281@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 24, 2022 at 03:14:41PM +0000, David Howells wrote:
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > > Questions for Willy:
> > >  - Can we get a function to return the number of pages in a readahead
> > >    batch?
> > > 
> > >  - Can we get a function to commit a readahead batch?  Currently, this is
> > >    done when we call __readahead_batch(), but that means ractl->_nr_pages
> > >    isn't up to date at the point we need it to be.  However, we want to
> > >    check to see if the ractl is empty, then get server credits and only
> > >    *then* call __readahead_batch() as we don't know how big a batch we're
> > >    allowed till we have the credits.
> > 
> > If you insist on using the primitives in a way that nobody else uses
> > them, you're going to find they don't work.  What's wrong with the
> > way that FUSE uses them in fuse_readahead()?
> 
> You mean doing this?
> 
> 		nr_pages = readahead_count(rac) - nr_pages;
> 
> that would seem to indicate that the readahead interface is wrong.  Why should
> readahead_count() need correction?  I think I can see *why* the batching stuff
> is hidden, but it seems that the comment for readahead_count() needs to
> mention this if you aren't going to fix it.
> 
> Would it be possible to make readahead_count() do:
> 
> 	return rac->_nr_pages - rac->_batch_count;
> 
> maybe?

Yes, I think that would make sense.  Do we also need to change
readhead_length()?  It seems to me that it's only ever called once at
initialisation, so it should be possible to keep the two in sync.
Can you write & test such a patch?  I'll support it going upstream
(either by taking it myself or giving you a R-b to take it through your
tree).
