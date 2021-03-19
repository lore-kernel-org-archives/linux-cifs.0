Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60FEC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 13:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA8764ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 13:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhCSNN1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 09:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhCSNNX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 09:13:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A526EC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 06:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O09gjiMYcKXKGVhcuToSa8Vl/p69KZaxo38YQDebpLE=; b=ktAVyMZdj8rrES9i0gdm9UVVHQ
        hUwxmp3Lceo8KKCVZRn8lu+3QdooLgccGtHJmu8OdDFQsVkylSsgkSewkRo3dNojegsl0dQOBy4Jz
        tT75wF5epnbCExx1JrH+OY+6EcmRmhBsBroLJ//f+SvAWbMFH3Dq1tj5B2XKWH9TmOqh0yHl4wTzN
        wOLRcevWD8bkKMSqeQ6lfkUolPvNuKT9tejjxuJmyUkKuXtwEc/migbQZa4sYhXtfW4Jmo1cKV8uX
        aXesW4zGQ3xa3RvHohXhO0/9Lar9mW6l97V47Ap273LhPMJFxzY/eS3MQJVZEzRJVkq7I8Bi2s7ky
        7/7pnEJA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lNEvY-004R8G-Tx; Fri, 19 Mar 2021 13:12:36 +0000
Date:   Fri, 19 Mar 2021 13:12:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     namjae.jeon@samsung.com, linux-cifs@vger.kernel.org
Subject: Re: [bug report] cifsd: introduce SMB3 kernel server
Message-ID: <20210319131232.GA1057389@infradead.org>
References: <YFNRsYSWw77UMxw1@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFNRsYSWw77UMxw1@mwanda>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 18, 2021 at 04:12:17PM +0300, Dan Carpenter wrote:
> [ The fs/cifsd/ directory needs to be added to the MAINTAINERS file
>   so this stuff goes through linux-cifs@vger.kernel.org ]

Err, how did this hit linux-next?  I've never even seen the code posted
to a mailing list.
