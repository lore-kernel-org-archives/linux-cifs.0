Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AF3C6379F
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Feb 2023 15:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbjBUPIj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Feb 2023 10:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbjBUPIh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Feb 2023 10:08:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE1C527C
        for <linux-cifs@vger.kernel.org>; Tue, 21 Feb 2023 07:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676992073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nRbZSwTHEqvgaS+hpisyueNsusAq0MvEujgh1o0fe7Y=;
        b=FxoqN+mKmIWaEXkOSVNxHvyuzA09FBRz0Nkrrj9wd5xlBpmjZU25gMJeK5u0zajK4D43gG
        3oXgXTm3xUYpzEXYaZkibXcr0/a9nItMHMF/poI7uojpFxLiQepqgwSK9T9yhz/jIglA/2
        bMplsuXl8g5NvrJu8MalqY+EnFb33Vk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-ZnrB6bV6Ogi6AgxSPHU7VA-1; Tue, 21 Feb 2023 10:07:49 -0500
X-MC-Unique: ZnrB6bV6Ogi6AgxSPHU7VA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B81FD3C1834B;
        Tue, 21 Feb 2023 15:05:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16C99C15BA0;
        Tue, 21 Feb 2023 15:05:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y/TbYGXC4HKunymf@casper.infradead.org>
References: <Y/TbYGXC4HKunymf@casper.infradead.org> <20230221184225.0e734f0e@canb.auug.org.au> <20230221174401.7198357d@canb.auug.org.au> <20230220152933.1ab8fa4a@canb.auug.org.au> <Y/N8hVWeR3AjssUC@casper.infradead.org> <20230220190157.3b43b9a7@canb.auug.org.au> <Y/Pe2xHklSr1hDtz@casper.infradead.org> <2351091.1676963957@warthog.procyon.org.uk> <2885897.1676990364@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2887474.1676991926.1@warthog.procyon.org.uk>
Date:   Tue, 21 Feb 2023 15:05:26 +0000
Message-ID: <2887475.1676991926@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> > +			start = folio_pos(folio); /* May regress with THPs */
> 
> What does this comment mean?

"start" may end up going backwards if it's pointing to the middle of a folio.

> > +			/* At this point we hold neither the i_pages lock nor the
> > +			 * page lock: the page may be truncated or invalidated
> > +			 * (changing page->mapping to NULL), or even swizzled
> > +			 * back from swapper_space to tmpfs file mapping
> 
> Where does this comment come from?  This is cifs, not tmpfs.  You'll
> never be asked to writeback a page from the swap cache.  Dirty pages
> can be truncated, so the first half of the comment is still accurate.
> I'd rather it moved down to below the folio lock, and was rephrased
> so it described why we're checking everything again.

I picked it up into afs from somewhere - nfs maybe?  The same comment is in
fs/btrfs/extent_io.c.  grep for 'swizzled' in fs/.  You modified the comment
in b93b016313b3ba8003c3b8bb71f569af91f19fc7 in 2018, so it's been around a
while.

David

