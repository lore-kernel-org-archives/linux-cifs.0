Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D39FC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jan 2022 15:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240706AbiAXPOx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:14:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240744AbiAXPOs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Jan 2022 10:14:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643037288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b32czmsHk3lhEJ6XbrXNWZ8fxyModf2w9QxuPOXZga8=;
        b=VR4VkVpGbwL0NzjRpICAF+jqF+lfieuPG0QwsMVInVGepgfCHApvkjVPkWjg0zRTh7VWQN
        4P+K2tHfosqWdqUR8zP5kvQqyY4Lcjij0mhwoVzhbf3JVaH2hYOaWtUpjd+KAAOp363LXR
        0NP8gcT/f3dbZBtUWQrVnheU60mFcJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-7eYqOQcOP-aEmr1DcwH6uw-1; Mon, 24 Jan 2022 10:14:44 -0500
X-MC-Unique: 7eYqOQcOP-aEmr1DcwH6uw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8761C18C8C0C;
        Mon, 24 Jan 2022 15:14:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3721E7D48A;
        Mon, 24 Jan 2022 15:14:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Ye61jfhL7K9Ethxz@casper.infradead.org>
References: <Ye61jfhL7K9Ethxz@casper.infradead.org> <164303051132.2163193.10493291874899600548.stgit@warthog.procyon.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     dhowells@redhat.com, smfrench@gmail.com, nspmangalore@gmail.com,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-cachefs@redhat.com
Subject: Re: [RFC PATCH] cifs: Transition from ->readpages() to ->readahead()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2255917.1643037281.1@warthog.procyon.org.uk>
Date:   Mon, 24 Jan 2022 15:14:41 +0000
Message-ID: <2255918.1643037281@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Matthew Wilcox <willy@infradead.org> wrote:

> > Questions for Willy:
> >  - Can we get a function to return the number of pages in a readahead
> >    batch?
> > 
> >  - Can we get a function to commit a readahead batch?  Currently, this is
> >    done when we call __readahead_batch(), but that means ractl->_nr_pages
> >    isn't up to date at the point we need it to be.  However, we want to
> >    check to see if the ractl is empty, then get server credits and only
> >    *then* call __readahead_batch() as we don't know how big a batch we're
> >    allowed till we have the credits.
> 
> If you insist on using the primitives in a way that nobody else uses
> them, you're going to find they don't work.  What's wrong with the
> way that FUSE uses them in fuse_readahead()?

You mean doing this?

		nr_pages = readahead_count(rac) - nr_pages;

that would seem to indicate that the readahead interface is wrong.  Why should
readahead_count() need correction?  I think I can see *why* the batching stuff
is hidden, but it seems that the comment for readahead_count() needs to
mention this if you aren't going to fix it.

Would it be possible to make readahead_count() do:

	return rac->_nr_pages - rac->_batch_count;

maybe?

David

