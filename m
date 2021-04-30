Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294E8C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 12:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F7D61419
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 12:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhD3MBK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Apr 2021 08:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhD3MBK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 30 Apr 2021 08:01:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A64FC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 05:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rf7AKe+guyWc2D4m/U5jQ2orwxJx47sXXNiIx4Esizc=; b=YslA8YO6P5XQEH1OKZ8HDebj+Z
        ng15uXF2hJXWnEpatNI5kuUV/Z54So8R6MKxivRGdoOZYFF0MTgOD6kY1AJ9Xp/V6FLBLw4Wm3+Yz
        OeIMr9uO9wOtKrWO2EWgVypQ4pk2O4UtnsCBN6F6bsmfQmZPwjFfCkNAPSmZTuvYSGP5xWmI9pVg3
        /rnPbsGmQULhncM0BUy2JfAClTt32Tsp9X5+lWfsMnXYYUHwIYk/+NoF0+lrwZ+yqrIGNhDaRT+CF
        XiQl+IIvhOnjuihCAiENLQS6yDmJBPryCLQ8HQZMxY/LjsGswkpmglaCo3F+DVTJlTxvJ2m1szf4d
        UPm64ChQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lcRoC-00AyMU-Lo; Fri, 30 Apr 2021 11:59:54 +0000
Date:   Fri, 30 Apr 2021 12:59:48 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] smb3: add rasize mount parameter to improve performance
 of readahead
Message-ID: <20210430115948.GL1847222@casper.infradead.org>
References: <CAH2r5mvfMfgGimkmC9nQxvOMt=2E7S1=dA33MJaszy5NHE2zxQ@mail.gmail.com>
 <20210425020946.GG235567@casper.infradead.org>
 <CAH2r5mui+DSj0RzgcGy+EVeg7VXEwd9fanAPNdBS+NSSiv9+Ug@mail.gmail.com>
 <CAH2r5msv6PtzSMVv1uVY983rKzdLvfL06T5OeTiU8eLyoMjL_A@mail.gmail.com>
 <CANT5p=qVq5mD2jfvt1Ym24hQF9M-aj1v1GT2q+_41p1OTESTKw@mail.gmail.com>
 <20210426115457.GJ235567@casper.infradead.org>
 <CANT5p=rHgmLdHJm_y3CCpb=KoEbnJApce2wx4hORY2CwHP2NbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANT5p=rHgmLdHJm_y3CCpb=KoEbnJApce2wx4hORY2CwHP2NbQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 30, 2021 at 04:19:27PM +0530, Shyam Prasad N wrote:
> Although ideally, I feel that we (cifs.ko) should be able to read in
> larger granular "chunks" even for small reads, in expectation that
> surrounding offsets will be read soon.

Why?  How is CIFS special and different from every other filesystem that
means you know what the access pattern of userspace is going to be better
than the generic VFS?

There are definitely shortcomings in the readahead code that should
be addressed, but in almost no circumstances is "read bigger chunks"
the right answer.
