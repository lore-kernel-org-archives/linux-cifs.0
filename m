Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8FDEFA3745
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Oct 2022 20:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiJXUJ4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Oct 2022 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234171AbiJXUJS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Oct 2022 16:09:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157A7103277;
        Mon, 24 Oct 2022 11:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=t88HgXTbzmjHLT6COIk3741WWVMXPUmvIrRNiuKC4AE=; b=LnylF4Zv7dpC69bHMENehsDezr
        thzTk84VhFK1oAieU5V+ugnop85fmRL7HotMPBKYW8HL4HL+BGXWrX7EoaMGbHz0J9hWID74p6gJr
        P4tr03uE8PAbKBbZrRO3/aquY4rKTef8phCC/I7y3iWh1WKYRHwd+wChMlPcrZtOIMYLglwpGhRHV
        mUPRQIM8Wgn9IG4n6K4702UQxHx065UBc9y0OremQ8xcwqjwpxe4aj1tBhrKeMdhLiZJufIOcpo0u
        ALJqRN6E2Kh7AO3Bs3NYIYfFT0cayWXhKNAlV7y5GdCXXdLqvwlpo2ehxiySqMiMFLC2OsN28vJmg
        NAJOe4yQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1omynr-001zPy-Ez; Mon, 24 Oct 2022 14:51:47 +0000
Date:   Mon, 24 Oct 2022 07:51:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, willy@infradead.org,
        dchinner@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        torvalds@linux-foundation.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to convert I/O iterators to iterators, sglists and RDMA lists
Message-ID: <Y1amg72OOJeqMVAl@infradead.org>
References: <Y01VjOE2RrLVA2T6@infradead.org>
 <1762414.1665761217@warthog.procyon.org.uk>
 <1415915.1666274636@warthog.procyon.org.uk>
 <Y1ISWla50g5gHax6@iweiny-desk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1ISWla50g5gHax6@iweiny-desk3>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Oct 20, 2022 at 08:30:34PM -0700, Ira Weiny wrote:
> > Do you have a link to that discussion?  I don't see anything obvious on
> > fsdevel including Ira.
> 
> I think Christoph meant to say John Hubbard.

Oops, sorry for my bad memory, both of you doing important tree-wide
MM rework at the same time go me really confused.

> 
> > 
> > I do see a discussion involving iov_iter_pin_pages, but I don't see Ira
> > involved in that.
> 
> This one?
> 
> https://lore.kernel.org/all/20220831041843.973026-5-jhubbard@nvidia.com/
> 
> I've been casually reading it but not directly involved.

Yes!
