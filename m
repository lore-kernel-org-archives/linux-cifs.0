Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E24ECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 17:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiJ1RGQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 13:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiJ1REp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 13:04:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26A07654B
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 10:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666976529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/IYuohmEO1F/L2EkVBn4KSHqgkaps/PV3lH1XEHBh2w=;
        b=NPotqG0ztOhlLyXcsWlf3vndeeFUiNzKfZ+PUbZvsKwICDUZeQUvTvZFwC7WgKF2am9B0R
        uS+zl1zZ5D64iOcsmtnAvrZMif8CH5pM5U0skqoHb48o1sbKOir652xVTiR+HlgKUnjNEh
        rcZ8HFcf697c5SEVQcjjl4o/BbAcymg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-cCmbhtwaMMW9r-ymwGBz8Q-1; Fri, 28 Oct 2022 13:02:06 -0400
X-MC-Unique: cCmbhtwaMMW9r-ymwGBz8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5E602A5957D;
        Fri, 28 Oct 2022 17:02:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3777640C6EC3;
        Fri, 28 Oct 2022 17:02:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wibPKfv7mpReMj5PjKBQi4OsAQ8uwW_7=6VCVnaM-p_Dw@mail.gmail.com>
References: <CAHk-=wibPKfv7mpReMj5PjKBQi4OsAQ8uwW_7=6VCVnaM-p_Dw@mail.gmail.com> <Y1btOP0tyPtcYajo@ZenIV> <20221028023352.3532080-1-viro@zeniv.linux.org.uk> <20221028023352.3532080-12-viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, willy@infradead.org,
        dchinner@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ira Weiny <ira.weiny@intel.com>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/12] use less confusing names for iov_iter direction initializers
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <65440.1666976522.1@warthog.procyon.org.uk>
Date:   Fri, 28 Oct 2022 18:02:02 +0100
Message-ID: <65441.1666976522@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Honestly, I think the *real* fix would be a type-based one. Don't do
> 
>         iov_iter_kvec(&iter, ITER_DEST, ...
> 
> at all, but instead have two different kinds of 'struct iov_iter': one
> as a destination (iov_iter_dst), and one as a source (iov_iter_src),

Or maybe something along the lines of iov_iter_into_kvec() and
iov_iter_from_kvec()?

Also, would it make sense to disallow asking the iterator for its direction
entirely and only use it for internal sanity checking?  In many of the places
it is looked at, the information is also available in another form (the
IOCB_WRITE flag, for example).

David

