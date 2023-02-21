Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD0FC61DA3
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Feb 2023 14:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbjBUOzz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Feb 2023 09:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbjBUOzy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Feb 2023 09:55:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80394298C3;
        Tue, 21 Feb 2023 06:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GJ/lGaiDep3rI6o4zuif/LYm8VGuPp/Xyo4Q403/+AY=; b=itvDGE7OyiwtJnUFZGW72WFl3Q
        aN9oxHPb8Sg+o5BEQa9qjUIDPJT6mqFkhnKXt5BVO6i20AugV7v2NUCf/jxK1TucEiLbz4mI3ofDJ
        etJwCGBJR9na9yTI3F7BO2XQCE2lTXPOjXxrqfKK+9wvUrDgmvw+5nn83aeV183j6xpwryXj18Xnf
        MQr6xCT7y/H59ztpr4guMzQEuOA1SdDV+oAwoupwjab3Xpti3dXz4lU+2jiiOaxK9Up/1ACc2BCI/
        PJtpHU/1SAZ3B5ZarJ4m3PL4fVgVVusXk54KHW7UXmOZGTXURaZ1rbmyzTX8xfF/ktftkjipMVPBm
        NThVXqhA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUU3E-00Cgmo-C1; Tue, 21 Feb 2023 14:55:28 +0000
Date:   Tue, 21 Feb 2023 14:55:28 +0000
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
Message-ID: <Y/TbYGXC4HKunymf@casper.infradead.org>
References: <20230221184225.0e734f0e@canb.auug.org.au>
 <20230221174401.7198357d@canb.auug.org.au>
 <20230220152933.1ab8fa4a@canb.auug.org.au>
 <Y/N8hVWeR3AjssUC@casper.infradead.org>
 <20230220190157.3b43b9a7@canb.auug.org.au>
 <Y/Pe2xHklSr1hDtz@casper.infradead.org>
 <2351091.1676963957@warthog.procyon.org.uk>
 <2885897.1676990364@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2885897.1676990364@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 21, 2023 at 02:39:24PM +0000, David Howells wrote:
> -		folio = page_folio(head_page);
> -		start = folio_pos(folio); /* May regress with THPs */
> +		for (i = 0; i < n; i++) {
> +			folio = fbatch.folios[i];
> +			start = folio_pos(folio); /* May regress with THPs */

What does this comment mean?

> +			/* At this point we hold neither the i_pages lock nor the
> +			 * page lock: the page may be truncated or invalidated
> +			 * (changing page->mapping to NULL), or even swizzled
> +			 * back from swapper_space to tmpfs file mapping

Where does this comment come from?  This is cifs, not tmpfs.  You'll
never be asked to writeback a page from the swap cache.  Dirty pages
can be truncated, so the first half of the comment is still accurate.
I'd rather it moved down to below the folio lock, and was rephrased
so it described why we're checking everything again.

The actual code looks right.
