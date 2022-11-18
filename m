Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F292CC4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Nov 2022 11:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241948AbiKRLKY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Nov 2022 06:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241880AbiKRLJ6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Nov 2022 06:09:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E508C4A5
        for <linux-cifs@vger.kernel.org>; Fri, 18 Nov 2022 03:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668769743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cHMiM/ftoa6Vj8bMLtiKVsf/Er81EpC0OGtpkmmve00=;
        b=b8TQ19o4us1oqjpPJFtbaDFYbi0/4I76UkZ6xsf0maU+4BDZuswFLHDCTxgFNWYrRpqyj0
        rpS/K4JT/uAuzbZPT39jzLUvqJ6UUh1bLgVCImYG9LOoPGKkM5AxhbBmPLnOF0u1Fc0ytA
        /hITsgAealHEXQmxxDRS5kd3TPY9cA8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-n31hH0RdNS6aXTcZ2V7AGw-1; Fri, 18 Nov 2022 06:09:00 -0500
X-MC-Unique: n31hH0RdNS6aXTcZ2V7AGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C261E8001B8;
        Fri, 18 Nov 2022 11:08:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FCD9C15BA5;
        Fri, 18 Nov 2022 11:08:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <166869691313.3723671.10714823767342163891.stgit@warthog.procyon.org.uk>
References: <166869691313.3723671.10714823767342163891.stgit@warthog.procyon.org.uk> <166869687556.3723671.10061142538708346995.stgit@warthog.procyon.org.uk>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] netfs: Add a function to extract an iterator into a scatterlist
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <231976.1668769735.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 18 Nov 2022 11:08:55 +0000
Message-ID: <231977.1668769735@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I updated the patch description to mention that pinning may be used instea=
d of
getting a ref:

    netfs: Add a function to extract an iterator into a scatterlist
    =

    Provide a function for filling in a scatterlist from the list of pages
    contained in an iterator.
    =

    If the iterator is UBUF- or IOBUF-type, the pages have a ref (WRITE) o=
r a
    pin (READ) taken on them.
    =

    If the iterator is BVEC-, KVEC- or XARRAY-type, no ref is taken on the
    pages and it is left to the caller to manage their lifetime.  It canno=
t be
    assumed that a ref can be validly taken, particularly in the case of a=
 KVEC
    iterator.

David

