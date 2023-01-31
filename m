Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A31C636CC
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Jan 2023 18:31:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjAaSba (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Jan 2023 13:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjAaSav (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Jan 2023 13:30:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB53589B3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Jan 2023 10:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675189800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vs8FDvoSHno0Q4Sw3oLMb7GUY7XZQhcAIOewFeDot/o=;
        b=fQV3ttOW7f15LB0rmUUwDg5FkD2bN7oifQPTvq/GZcf+ZJ5yVv7b+qgedPcCitK3KIumXI
        bShSHkym02nPSE9P/lAOFhr+l4kzyPQtnQTuCipUIMyCu/LMTlF+eWbUIl2grQWEc/GDZk
        bnWbRr8G0pxifYishSsnF7G8R3mU09M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-SfSno0hGNAWEYq9ylek_Gg-1; Tue, 31 Jan 2023 13:29:56 -0500
X-MC-Unique: SfSno0hGNAWEYq9ylek_Gg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 254B22808D65;
        Tue, 31 Jan 2023 18:29:29 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85DD52026D4B;
        Tue, 31 Jan 2023 18:29:27 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve French <sfrench@samba.org>
Subject: [PATCH 12/12] cifs: DIO to/from KVEC-type iterators should now work
Date:   Tue, 31 Jan 2023 18:28:55 +0000
Message-Id: <20230131182855.4027499-13-dhowells@redhat.com>
In-Reply-To: <20230131182855.4027499-1-dhowells@redhat.com>
References: <20230131182855.4027499-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

DIO to/from KVEC-type iterators should now work as the iterator is passed
down to the socket in non-RDMA/non-crypto mode and in RDMA or crypto mode
care is taken to handle vmap/vmalloc correctly and not take page refs when
building a scatterlist.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Tom Talpey <tom@talpey.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
---
 fs/cifs/file.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ed84104b669d..11875224a917 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3546,16 +3546,6 @@ static ssize_t __cifs_writev(
 	struct cifs_aio_ctx *ctx;
 	int rc;
 
-	/*
-	 * iov_iter_get_pages_alloc doesn't work with ITER_KVEC.
-	 * In this case, fall back to non-direct write function.
-	 * this could be improved by getting pages directly in ITER_KVEC
-	 */
-	if (direct && iov_iter_is_kvec(from)) {
-		cifs_dbg(FYI, "use non-direct cifs_writev for kvec I/O\n");
-		direct = false;
-	}
-
 	rc = generic_write_checks(iocb, from);
 	if (rc <= 0)
 		return rc;
@@ -4089,16 +4079,6 @@ static ssize_t __cifs_readv(
 	loff_t offset = iocb->ki_pos;
 	struct cifs_aio_ctx *ctx;
 
-	/*
-	 * iov_iter_get_pages_alloc() doesn't work with ITER_KVEC,
-	 * fall back to data copy read path
-	 * this could be improved by getting pages directly in ITER_KVEC
-	 */
-	if (direct && iov_iter_is_kvec(to)) {
-		cifs_dbg(FYI, "use non-direct cifs_user_readv for kvec I/O\n");
-		direct = false;
-	}
-
 	len = iov_iter_count(to);
 	if (!len)
 		return 0;

