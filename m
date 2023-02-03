Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF38CC61DA4
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Feb 2023 21:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjBCVEb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Feb 2023 16:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbjBCVCt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Feb 2023 16:02:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87964A9D56
        for <linux-cifs@vger.kernel.org>; Fri,  3 Feb 2023 13:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675458047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aKXJEFVHJON2UjnvEtbejGTqV0qCsLQRv/6cKDxwOv0=;
        b=XzMFO1qefjp4HwJNL2lAISL6EGPutuILTUiOZ2zH8BxjSKl0PO27VBkLw2B4PaI1a1NI78
        HXi6DzpfRDJaaBJ+ZO1aE39LSEHu2j219hSSbztHzYuPvCgoUdWCL+zAey7zwv/cURHt8p
        JgJEVSu+nkam/9mO1JsffbaivWs2mco=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-9wiaw-oyMxyIbBUIK09_ZA-1; Fri, 03 Feb 2023 16:00:42 -0500
X-MC-Unique: 9wiaw-oyMxyIbBUIK09_ZA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A4C8185A7A4;
        Fri,  3 Feb 2023 21:00:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 815FB492B15;
        Fri,  3 Feb 2023 21:00:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y9sJ7Nuubw1U4M6u@gondor.apana.org.au>
References: <Y9sJ7Nuubw1U4M6u@gondor.apana.org.au> <Y9ooW52m0Afnhj7Z@gondor.apana.org.au> <312908.1675262203@warthog.procyon.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, smfrench@gmail.com, viro@zeniv.linux.org.uk,
        nspmangalore@gmail.com, rohiths.msft@gmail.com, tom@talpey.com,
        metze@samba.org, hch@infradead.org, willy@infradead.org,
        jlayton@kernel.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfrench@samba.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 05/12] cifs: Add a function to Hash the contents of an iterator
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2126749.1675458038.1@warthog.procyon.org.uk>
Date:   Fri, 03 Feb 2023 21:00:38 +0000
Message-ID: <2126750.1675458038@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Were you also deleting shash code in another patch that wasn't
> cc'ed to me?

No, I don't want to change it this late into the dev cycle.  I can look at it
after the merge window.

David

