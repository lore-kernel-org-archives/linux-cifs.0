Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1480C433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Nov 2022 18:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiKDSsd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Nov 2022 14:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiKDSs3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Nov 2022 14:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489845987E
        for <linux-cifs@vger.kernel.org>; Fri,  4 Nov 2022 11:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667587649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJfsTHY6tba7ZQacb0L0SXoAUwbrxp/Y0LpbDnploq0=;
        b=QT6ws+6PrQPsTD0SWAEDD6kDaI9aVQCDGIOOBES7vECJWZfvv1I3aw4MYwxOlKgZCzMpk/
        TuttC1+yThqt7KEWCWB4quCgmolCgYnlxL7rrCISD2WuKCqJxVIsVylFtr7x/zBICzQKhl
        db3GiZytDth6sv3mN9vXX9UhfM2tpIA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-zAFmLBlFNrCWx9rm7prL4w-1; Fri, 04 Nov 2022 14:47:27 -0400
X-MC-Unique: zAFmLBlFNrCWx9rm7prL4w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73AEC185A78F;
        Fri,  4 Nov 2022 18:47:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD547400EA89;
        Fri,  4 Nov 2022 18:47:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <67142.1666978314@warthog.procyon.org.uk>
References: <67142.1666978314@warthog.procyon.org.uk> <Y1btOP0tyPtcYajo@ZenIV> <Y01VjOE2RrLVA2T6@infradead.org> <1762414.1665761217@warthog.procyon.org.uk> <1415915.1666274636@warthog.procyon.org.uk> <Y1an1NFcowiSS9ms@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
        willy@infradead.org, dchinner@redhat.com,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ira Weiny <ira.weiny@intel.com>, torvalds@linux-foundation.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jlayton@redhat.com
Subject: Re: How to convert I/O iterators to iterators, sglists and RDMA lists
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1014263.1667587643.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 04 Nov 2022 18:47:23 +0000
Message-ID: <1014264.1667587643@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > What protects pages involved in ITER_XARRAY iterator created by
> > afs_read_dir()?  Note that we are not guaranteed inode_lock() on
> > the directory in question...
> =

> Yeah - that needs fixing.  The size of the data can change, but I don't =
update
> the iterator.

Actually, no.  The iterator is the output buffer for afs_fetch_data().  If=
 the
buffer turned out to be too small we drop the validate_lock and go round a=
nd
try again.

req->actual_len and req->file_size are updated by afs_fetch_data() from th=
e
RPC reply.  req->len tells the RPC delivery code how big the buffer is (wh=
ich
we don't have to fill if there's less data available than we have buffer
space).

David

