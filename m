Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DA0C636CD
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Feb 2023 14:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjBAOh7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Feb 2023 09:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjBAOhz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Feb 2023 09:37:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE50069526
        for <linux-cifs@vger.kernel.org>; Wed,  1 Feb 2023 06:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675262210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8/dpDM/3REEz3eyiAc+dJjDInqTxFwwyfLND3C6oXCQ=;
        b=AoecflevKedTs40TpZDQwdPHoW02u0/QN3OJDO+H0Zm+J0KRtt8zvPrDBuYn94ly+jhOKh
        y5H7TsIjNxAQA7QJIDWZN8y4F/+KivfV0lHc8S8c2nszn8mvo/ncYHGEYhwi/AjDjkyrYw
        cNPHJbw7M0WzJfbhU3hQaLtYooU7SAs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-20SeWIIfNo2jUTyP7mdrOw-1; Wed, 01 Feb 2023 09:36:46 -0500
X-MC-Unique: 20SeWIIfNo2jUTyP7mdrOw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3223C1C08793;
        Wed,  1 Feb 2023 14:36:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44A41492B05;
        Wed,  1 Feb 2023 14:36:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y9ooW52m0Afnhj7Z@gondor.apana.org.au>
References: <Y9ooW52m0Afnhj7Z@gondor.apana.org.au>
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
Content-ID: <312907.1675262203.1@warthog.procyon.org.uk>
Date:   Wed, 01 Feb 2023 14:36:43 +0000
Message-ID: <312908.1675262203@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > Add a function to push the contents of a BVEC-, KVEC- or XARRAY-type
> > iterator into a symmetric hash algorithm.
> 
> There is no such thing as a symmetric hash.  You're using shash
> which stands for synchronous hash.

Sorry, you're right.

> In any case, as I said in the previous review this is abusing the
> shash API.  Please use ahash instead.

It's already abusing the shash API, this doesn't change that, except where it
gets the data from.

I can have a go at conversion to ahash, but that will have to be a separate
patch set as it isn't trivial.  The problem is that the current code just
assumes it can push bits into the hash as it gets them - this is not possible
with ahash.

David

