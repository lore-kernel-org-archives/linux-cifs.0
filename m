Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398F7C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jan 2022 14:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbiAXOUD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jan 2022 09:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbiAXOUD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jan 2022 09:20:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22711C06173B
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jan 2022 06:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FyUvH9okx3QW3BeHHjRYOG14mog6x9sWF/iX1pzpMLc=; b=qNVkHi1Q2Xh/DoGB6Ny1OjxYAu
        Vi0wMbp43VYL6gTa+4vMoA2eFFHa85XvdyoE+Rcv/RzH9NjaehXONnt0iGhdt3W4kBDxNAxcC9C1K
        sMpLf543OIqpGEgDKepXx9+1CLphIPHcpKWf9wNHucSfROV3C0J1faY4gYKDUFNxZ4YdldhZXd+Zi
        mwY3jChgvq++AFw+f5orgGZ6EALU58yY5QPIXN38ohJ0t2geVlOhwOoxsP9Vq7DxEWWBD4EQdgZBf
        5t+B0wzV44NB1/G/Mj2xG5ju8yAWAxHUue9Vr1lUpsuZQiTOnm8KYAGAiXJsYjhzvgCdi+87H2u73
        Rarnb0Tw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nC0CL-000kY5-Fu; Mon, 24 Jan 2022 14:19:57 +0000
Date:   Mon, 24 Jan 2022 14:19:57 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     smfrench@gmail.com, nspmangalore@gmail.com,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com
Subject: Re: [RFC PATCH] cifs: Transition from ->readpages() to ->readahead()
Message-ID: <Ye61jfhL7K9Ethxz@casper.infradead.org>
References: <164303051132.2163193.10493291874899600548.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164303051132.2163193.10493291874899600548.stgit@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 24, 2022 at 01:21:51PM +0000, David Howells wrote:
> Transition the cifs filesystem from using the old ->readpages() method to
> using the new ->readahead() method.
> 
> For the moment, this removes any invocation of fscache to read data from
> the local cache, leaving that to another patch.
> 
> Questions for Willy:
>  - Can we get a function to return the number of pages in a readahead
>    batch?
> 
>  - Can we get a function to commit a readahead batch?  Currently, this is
>    done when we call __readahead_batch(), but that means ractl->_nr_pages
>    isn't up to date at the point we need it to be.  However, we want to
>    check to see if the ractl is empty, then get server credits and only
>    *then* call __readahead_batch() as we don't know how big a batch we're
>    allowed till we have the credits.

If you insist on using the primitives in a way that nobody else uses
them, you're going to find they don't work.  What's wrong with the
way that FUSE uses them in fuse_readahead()?

