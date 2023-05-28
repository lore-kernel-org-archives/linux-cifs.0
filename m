Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398DBC77B7E
	for <linux-cifs@archiver.kernel.org>; Sun, 28 May 2023 08:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjE1Iet (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 May 2023 04:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjE1Ies (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 28 May 2023 04:34:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFCEDF
        for <linux-cifs@vger.kernel.org>; Sun, 28 May 2023 01:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685262846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kwxNaHisEq+hSYVrnROXXvszOL5x+627ymiwxF2+pCM=;
        b=YwrZYVyhfBQVw8sJKvdXARpKNMQlWxknfItdIULLofgAsImDv72eVuU6zIgbKcqvz+E7Rh
        gZL851lsJeK/R2cPf70B0ip7zq1X1Y9+F0dLu3kBuM6dHqUG+Ta8kWSpBrzH8XxiDHiGFd
        wePPbXSwvdvItti8cJN6lF66QD3RIpI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-6Ul53yeCPrWlx62V8qraXA-1; Sun, 28 May 2023 04:34:01 -0400
X-MC-Unique: 6Ul53yeCPrWlx62V8qraXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2BC9101A52C;
        Sun, 28 May 2023 08:34:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3DE740CFD45;
        Sun, 28 May 2023 08:33:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZHH1nqZWOGzxlidT@corigine.com>
References: <ZHH1nqZWOGzxlidT@corigine.com> <20230526143104.882842-1-dhowells@redhat.com> <20230526143104.882842-2-dhowells@redhat.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH net-next 1/8] Move netfs_extract_iter_to_sg() to lib/scatterlist.c
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <992933.1685262837.1@warthog.procyon.org.uk>
Date:   Sun, 28 May 2023 09:33:57 +0100
Message-ID: <992934.1685262837@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If it comes to a respin, I'll stick in an extra patch to fix the spellings -
and if not, I'll submit the patch separately.  It shouldn't be changed in with
the movement of code to give git analysis a better chance of tracking the
movement.

David

