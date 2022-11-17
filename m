Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A18C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Nov 2022 14:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiKQOzo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Nov 2022 09:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbiKQOzk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Nov 2022 09:55:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D91D1C422
        for <linux-cifs@vger.kernel.org>; Thu, 17 Nov 2022 06:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668696884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9lCfrN2ZrVC3HhD8dAZKIdUEJSs195bbqf/UyReD6xk=;
        b=AfWj4BoieaJEZeM1nO4e4W/ymNMp00jY7CDystgOwOQYpxx033iL3qmp8nuiJjgMYldVWV
        /BEFlSN6PNu161Y3TvAIQefPWgNNODa92KX1wNr6KFoiYoEKAlP5EihMfKhd216jbqwuqH
        uPJk82Wis7/pmTSAZ8suz4umlPjFTmU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-50OXq3sqNMC63084Kb6QkQ-1; Thu, 17 Nov 2022 09:54:41 -0500
X-MC-Unique: 50OXq3sqNMC63084Kb6QkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42EE7862FEC;
        Thu, 17 Nov 2022 14:54:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B1DB2028E8F;
        Thu, 17 Nov 2022 14:54:38 +0000 (UTC)
Subject: [RFC PATCH 0/4] iov_iter: Add extraction helpers
From:   David Howells <dhowells@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-cachefs@redhat.com, Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, dhowells@redhat.com,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 17 Nov 2022 14:54:35 +0000
Message-ID: <166869687556.3723671.10061142538708346995.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Al,

Here are four patches to provide support for extracting pages from an
iov_iter, where such a thing makes sense, if you could take a look?

The first couple of patches provide iov_iter general stuff:

 (1) Move the FOLL_* flags to linux/mm_types.h so that linux/uio.h can make
     use of them.

 (2) Add a function to list-only, get or pin pages from an iterator as a
     future replacement for iov_iter_get_pages*().  Pointers to the pages
     are placed into an array (which will get allocated if not provided)
     and, depending on the iterator type and direction, the pages will have
     a ref or a pin get on them, or left untouched (on the assumption that
     the caller manages their lifetime).

     The determination is:

	UBUF/IOVEC + READ	-> pin
	UBUF/IOVEC + WRITE	-> get
	PIPE + READ		-> list-only
	BVEC/XARRAY		-> list-only
	Anything else		-> EFAULT

     It also adds a function by which the caller can determine which of
     "list only, get or pin" the extraction function will actually do to
     aid in cleaning up (returning 0, FOLL_GET or FOLL_PIN as appropriate).

Then there are a couple of patches that add stuff to netfslib that I want
to use there as well as in cifs:

 (3) Add a netfslib function to use (2) to extract pages from an ITER_IOBUF
     or ITER_UBUF iterator into an ITER_BVEC iterator.  This will get or
     pin the pages as appropriate.

 (4) Add a netfslib function to extract pages from an iterator that's of
     type ITER_UBUF/IOVEC/BVEC/KVEC/XARRAY and add them to a scatterlist.

     The function in (2) is used for a UBUF and IOVEC iterators, so those
     need cleaning up afterwards.  BVEC and XARRAY iterators are ungot and
     unpinned and may be rendered into elements that span multiple pages,
     for example if large folios are present.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-extract

David

Link: https://lore.kernel.org/r/166697254399.61150.1256557652599252121.stgit@warthog.procyon.org.uk/
---
David Howells (4):
      mm: Move FOLL_* defs to mm_types.h
      iov_iter: Add a function to extract a page list from an iterator
      netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator
      netfs: Add a function to extract an iterator into a scatterlist


 fs/netfs/Makefile        |   1 +
 fs/netfs/iterator.c      | 346 +++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h       |  74 ---------
 include/linux/mm_types.h |  73 +++++++++
 include/linux/netfs.h    |   5 +
 include/linux/uio.h      |  29 ++++
 lib/iov_iter.c           | 333 +++++++++++++++++++++++++++++++++++++
 mm/vmalloc.c             |   1 +
 8 files changed, 788 insertions(+), 74 deletions(-)
 create mode 100644 fs/netfs/iterator.c


