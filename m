Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE77DC7EE2C
	for <linux-cifs@archiver.kernel.org>; Tue, 30 May 2023 14:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbjE3OTf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 May 2023 10:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbjE3OTA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 May 2023 10:19:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E539F1
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 07:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685456249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8XAsj4uxJsU5nzHkgzshZ8+UJL6y54h/fBUZHPzhfR8=;
        b=e2yeO2q6XAptKku9CYwvPXXug6z0McoeUJAdUiTqKPp+fU0oc4S1JdjCczAkRYHMxp2naV
        9+foIw3Zt/kCLOInt4I8R9+8tPgT7eTk5OSovs4fNYIdWKYxF4t0tMBJ7Jbl6vbUsLHQE0
        IY8fPuMXrBuwQ79Jj8P6S3psWRvN8R4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-uIi8tBz6PMukM1ed44bcvg-1; Tue, 30 May 2023 10:17:26 -0400
X-MC-Unique: uIi8tBz6PMukM1ed44bcvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 239E9803D78;
        Tue, 30 May 2023 14:17:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 230E640CFD46;
        Tue, 30 May 2023 14:17:08 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
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
        Simon Horman <simon.horman@corigine.com>,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH net-next v2 03/10] Wrap lines at 80
Date:   Tue, 30 May 2023 15:16:27 +0100
Message-ID: <20230530141635.136968-4-dhowells@redhat.com>
In-Reply-To: <20230530141635.136968-1-dhowells@redhat.com>
References: <20230530141635.136968-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Wrap a line at 80 to stop checkpatch complaining.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: Simon Horman <simon.horman@corigine.com>
cc: linux-crypto@vger.kernel.org
cc: linux-cachefs@redhat.com
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: netdev@vger.kernel.org
---
 fs/netfs/iterator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index f41a37bca1e8..9f09dc30ceb6 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -119,7 +119,8 @@ static ssize_t extract_user_to_sg(struct iov_iter *iter,
 	size_t len, off;
 
 	/* We decant the page list into the tail of the scatterlist */
-	pages = (void *)sgtable->sgl + array_size(sg_max, sizeof(struct scatterlist));
+	pages = (void *)sgtable->sgl +
+		array_size(sg_max, sizeof(struct scatterlist));
 	pages -= sg_max;
 
 	do {

