Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAECC64ED6
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Feb 2023 15:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjBUP0t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Feb 2023 10:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjBUP0s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Feb 2023 10:26:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8375E2A981;
        Tue, 21 Feb 2023 07:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jd0s7AFEKjvijVoKSZyi5x9Rh1J1ZEczZM+5fLYNmzs=; b=LMJ0Mht8d1yYYLCKIVjISd8rEN
        ngx6STsoHcE/i4dCteGFgovzjx+TEwOadldsErJprBffg9xiCxSiz57k5Mm7pvC+3bdXHOdUZEGVg
        S6b5sfU+9lHhyhWtk71f8YVjQ8a0wezcU2rXra+Itt4JCmtjZv73mlThwwFuDfvGd/5XwfXB9UZjH
        pywwLKTy7/CQna0VturjYQW6BafXsM56h/znMxr2kkAMdzJV/NWNP5vl3JMrZ3sP/4qnOYJN8nc64
        Rl1WpPU/mVKgar4hYHOnR1npCXhtD05b6OQB8ZUBgQu1kPTwQPH5pDyb73CIPe6W7lZe7JrieGoll
        8smevjZw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUUXM-00Chyg-34; Tue, 21 Feb 2023 15:26:36 +0000
Date:   Tue, 21 Feb 2023 15:26:36 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steve French <smfrench@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@cjr.nz>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: manual merge of the mm-stable tree with the cifs tree
Message-ID: <Y/TirOtSETOvh2py@casper.infradead.org>
References: <Y/TbYGXC4HKunymf@casper.infradead.org>
 <20230221184225.0e734f0e@canb.auug.org.au>
 <20230221174401.7198357d@canb.auug.org.au>
 <20230220152933.1ab8fa4a@canb.auug.org.au>
 <Y/N8hVWeR3AjssUC@casper.infradead.org>
 <20230220190157.3b43b9a7@canb.auug.org.au>
 <Y/Pe2xHklSr1hDtz@casper.infradead.org>
 <2351091.1676963957@warthog.procyon.org.uk>
 <2885897.1676990364@warthog.procyon.org.uk>
 <2887475.1676991926@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2887475.1676991926@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 21, 2023 at 03:05:26PM +0000, David Howells wrote:
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > > +			start = folio_pos(folio); /* May regress with THPs */
> > 
> > What does this comment mean?
> 
> "start" may end up going backwards if it's pointing to the middle of a folio.

So that's "regress" in the sense of "May point earlier in the file",
rather than "May cause a bug" (which was how I read it)?

> > > +			/* At this point we hold neither the i_pages lock nor the
> > > +			 * page lock: the page may be truncated or invalidated
> > > +			 * (changing page->mapping to NULL), or even swizzled
> > > +			 * back from swapper_space to tmpfs file mapping
> > 
> > Where does this comment come from?  This is cifs, not tmpfs.  You'll
> > never be asked to writeback a page from the swap cache.  Dirty pages
> > can be truncated, so the first half of the comment is still accurate.
> > I'd rather it moved down to below the folio lock, and was rephrased
> > so it described why we're checking everything again.
> 
> I picked it up into afs from somewhere - nfs maybe?  The same comment is in
> fs/btrfs/extent_io.c.  grep for 'swizzled' in fs/.  You modified the comment
> in b93b016313b3ba8003c3b8bb71f569af91f19fc7 in 2018, so it's been around a
> while.

I was just removing references to ->tree_lock ;-)
