Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E091C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 03:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiHXDwg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 23:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiHXDwf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 23:52:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20E548C96;
        Tue, 23 Aug 2022 20:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=heuQpO/LsqP/UJ9tZYgQN1UYU4nAKypMbMGzQhkybws=; b=EKywbzjTnQaHsqKrcAZFAKdYVa
        AnX8eqgD12noTB6D5LGPNK/i8Yr/BkQpnzCpNEXh8x0NT5eHJlTFtW94JoEZkaErt4vEPUWqRbYae
        1wRThrEYV9B90bE3yDBlFlP0rA6zvHjlKmkNZy6wGLU0PYMGiQwRwjhdDijPGUGKEG4Wo4Og7bOh9
        glilXETvkevKbdP83FTwVcDLeRmonrkiVksdgatJTJuwZsV4hARviS2o6RUF/txPBMXXRrJQ4p93u
        rR4o8xBkbya9vq+qte666tAT4pDsLXDh/AKSmDq+hAcU5QDNBOSQE2gHz86NawaOFo035dVcgFy3X
        rqRRE9qQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oQhRF-00AKSo-JK; Wed, 24 Aug 2022 03:52:21 +0000
Date:   Tue, 23 Aug 2022 20:52:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] iov_iter: Add a function to extract an iter's
 buffers to a bvec iter
Message-ID: <YwWgdekd+f3MqVmu@infradead.org>
References: <166126392703.708021.14465850073772688008.stgit@warthog.procyon.org.uk>
 <166126393409.708021.16165278011941496946.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166126393409.708021.16165278011941496946.stgit@warthog.procyon.org.uk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 23, 2022 at 03:12:14PM +0100, David Howells wrote:
> Copy cifs's setup_aio_ctx_iter() and to lib/iov_iter.c and generalise it as
> extract_iter_to_iter().  This allocates and sets up an array of bio_vecs
> for all the page fragments in an I/O iterator and sets a second supplied
> iterator to bvec-type pointing to the array.

Did you read my NACK and comments from last time?
