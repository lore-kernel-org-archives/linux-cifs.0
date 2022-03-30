Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041B9C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 09:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiC3JUh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Mar 2022 05:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244721AbiC3JUg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Mar 2022 05:20:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832972AC78
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 02:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kiJwS8g43JUnp0tgVkYvBdc5AiC7KfzXv0Hu4C/5cQ0=; b=ZX0+CIX4R6UvUaIRWlJvHV9nGl
        jzQNeapGpurQg4iP9BJvkgXUSNLeEwCFR0lDjH1V6WuAmNZOvOtvP+qaTYDMsU9uLJ9dahQhAceuW
        XOuZZ8HYjpCe6/fh/ZffqczZwRxuzoJF+S/04lBp2zTVgSoeD8p4OU4CslDYCeQkK05Xz3CH9R2Si
        Nl/uehrHgS4woPIlAbLBNnGajvqoIMNWgTQRhue3W1Xz39+Xb+SYo2aw5J/iEhONB2ruS/1hBa2TC
        4gITm7HJtR4dxjFpUjs0RCCV/FqecS3pTG0cF6JVp8JuWY8YKHARJ4W2ORIhuvqvTONJdq+F78XwI
        OoEFsJhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZUTa-00ExpS-7H; Wed, 30 Mar 2022 09:18:50 +0000
Date:   Wed, 30 Mar 2022 02:18:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [GIT PULL] ksmbd server fixes
Message-ID: <YkQgeur8Gw/0klbp@infradead.org>
References: <CAH2r5mvmUjSpb0hPjMguq8aFKi11JUDMN5JADFqxw5xhNDELCA@mail.gmail.com>
 <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
 <CAHk-=wg8CFSfu8bSs1ggiX6gW0Qx_MdZAbxC6bWHi-GQRyErAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg8CFSfu8bSs1ggiX6gW0Qx_MdZAbxC6bWHi-GQRyErAw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 29, 2022 at 07:23:19PM -0700, Linus Torvalds wrote:
> Hmm. The cachefiles and ecryptfs code seems to have a fair amount of
> this pattern.

Which is expected as those (plus nfsd) really are the major consumers
of doing the full set of file system namespace operations from kernel
space.
