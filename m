Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C94C432C3
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 08:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D327820855
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 08:19:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lC5lI1lU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUIT2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 03:19:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46552 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUIT2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 03:19:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hXw37FrGNB84pQ89vy8I3mbiciTtc26TeImaENU4Gtw=; b=lC5lI1lUcfP2vbRCTxfD7Oadd
        CzZlzFxxaZZOQv1GK79NOoKLRzHjc2HTtxiQo160vcHg+qmPJhBQSawQ6JfMWahCchGlXaxxqRoEj
        FHXLsLbqfq5yP4hKZyKCUTBnFsEnYHk3x6YNUqqGEe6EiERdyPQ5CUHhetrbmXdxJgQrgT97WOQCf
        KW7y1uYf1B38kK5/Erh+9c023MD/hET5/dxAF3x2ArhWsWF7huwAVPBhG2uMX7/Nk9AK93lS3/TVP
        0Dh7g1BNri26nsJlrwyrkWuMSzuNA4K4VBY4iIn+8L4FeNOHDCn7GuBQgfN3AYV4QjEzIm/SGXYRK
        HxAcG3Rcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXhgR-00055b-7m; Thu, 21 Nov 2019 08:19:23 +0000
Date:   Thu, 21 Nov 2019 00:19:23 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cifs: Don't use iov_iter::type directly
Message-ID: <20191121081923.GA19366@infradead.org>
References: <157432403818.17624.9300948341879954830.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157432403818.17624.9300948341879954830.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Nov 21, 2019 at 08:13:58AM +0000, David Howells wrote:
> Don't use iov_iter::type directly, but rather use the new accessor
> functions that have been added.  This allows the .type field to be split
> and rearranged without the need to update the filesystems.

I'd rather get rid of the accessor and access the fields directly, as
that is much easier to follow.
