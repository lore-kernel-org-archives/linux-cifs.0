Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535B1C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jan 2022 15:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiAXPqm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:46:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232311AbiAXPql (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Jan 2022 10:46:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643039201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6JRBgxN5xSjJQjY6/iYe9P1WOkpOHtJ14rtPge21su4=;
        b=Hm60kQOvho7XFNuTzKV7fdpnXESsTmXWa1b2BC/mMyBL6dtSgt4d4zZwmZC+BFlcunVmcT
        8vjiXhHMmf4ANOJoyW/9lDxDHBgJowNO1FPs+i3vcZ25xxMnGL+YcZs3sSvUroxYDBHxxk
        gNLCBApE9c5QeX5M4kfPfNW/QgpLQno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-ZQSJins3P1OR6_v698MwvA-1; Mon, 24 Jan 2022 10:46:35 -0500
X-MC-Unique: ZQSJins3P1OR6_v698MwvA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E42B8519E0;
        Mon, 24 Jan 2022 15:46:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCC59794B2;
        Mon, 24 Jan 2022 15:46:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Ye7GtNRgxkT9S6sG@casper.infradead.org>
References: <Ye7GtNRgxkT9S6sG@casper.infradead.org> <Ye61jfhL7K9Ethxz@casper.infradead.org> <164303051132.2163193.10493291874899600548.stgit@warthog.procyon.org.uk> <2255918.1643037281@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, smfrench@gmail.com, nspmangalore@gmail.com,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com
Subject: Re: [RFC PATCH] cifs: Transition from ->readpages() to ->readahead()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2270963.1643039187.1@warthog.procyon.org.uk>
Date:   Mon, 24 Jan 2022 15:46:27 +0000
Message-ID: <2270964.1643039187@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> > Would it be possible to make readahead_count() do:
> > 
> > 	return rac->_nr_pages - rac->_batch_count;
> > 
> > maybe?
> 
> Yes, I think that would make sense.  Do we also need to change
> readhead_length()?  It seems to me that it's only ever called once at
> initialisation, so it should be possible to keep the two in sync.
> Can you write & test such a patch?  I'll support it going upstream
> (either by taking it myself or giving you a R-b to take it through your
> tree).

It seems I also have a problem with readahead_index() needing compensation
too.  I'm guessing that's more of a problem, however, as I think that's
expected to refer to the beginning of the current batch.

David

