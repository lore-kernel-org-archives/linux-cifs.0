Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C23C74A5B
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 14:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjC2OpI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 10:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjC2Oox (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 10:44:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BF37D97
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 07:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680100890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fsOLHSRSLMInNcD449MTPXsGwp1kWYvONeYqTpf/Ez4=;
        b=Ld/52s06xrrInv5iDs5iSDylgYbWZamGxMGTj1kE4X5ASXLS5se32mX3JrisigZb4PDghm
        Rxas5EPqu6wkyn104ZIVQ7jyZ+Klnudzqpy3c2dNWXkmvrn7Y24tWUynebRoZJs1IqJVN7
        BSDjjOAQNCtf74hdeyeSdceky5AKPzQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-Xdb9sur-PoeNk1trWuucgw-1; Wed, 29 Mar 2023 10:14:03 -0400
X-MC-Unique: Xdb9sur-PoeNk1trWuucgw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 080F01C06EE7;
        Wed, 29 Mar 2023 14:14:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94AC618EC6;
        Wed, 29 Mar 2023 14:13:59 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org
Subject: [RFC PATCH v2 01/48] netfs: Fix netfs_extract_iter_to_sg() for ITER_UBUF/IOVEC
Date:   Wed, 29 Mar 2023 15:13:07 +0100
Message-Id: <20230329141354.516864-2-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-1-dhowells@redhat.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix netfs_extract_iter_to_sg() for ITER_UBUF and ITER_IOVEC to set the size
of the page to the part of the page extracted, not the remaining amount of
data in the extracted page array at that point.

This doesn't yet affect anything as cifs, the only current user, only
passes in non-user-backed iterators.

Fixes: 018584697533 ("netfs: Add a function to extract an iterator into a scatterlist")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: linux-cachefs@redhat.com
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/iterator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
index e9a45dea748a..8a4c86687429 100644
--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -139,7 +139,7 @@ static ssize_t netfs_extract_user_to_sg(struct iov_iter *iter,
 			size_t seg = min_t(size_t, PAGE_SIZE - off, len);
 
 			*pages++ = NULL;
-			sg_set_page(sg, page, len, off);
+			sg_set_page(sg, page, seg, off);
 			sgtable->nents++;
 			sg++;
 			len -= seg;

