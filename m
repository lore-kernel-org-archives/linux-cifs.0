Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC765C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Jan 2022 17:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236809AbiAaRy5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:54:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230440AbiAaRy5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 31 Jan 2022 12:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643651696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4VOyZm9lpQO744a2uQCixeDSL5Uo6s7F22zRoD6ixdk=;
        b=IxxaXqfcobEuHW7favsjUowftpTFE7yLUbPkanWugiBX0tOsuD+BpqYk/KTW0qHRt/rL1P
        yzX9lK2JVk5JkBbxb93rJh1n3kiCdaU2bcTE52oh3QgaMx6Xbnl/eDvgQAytPoJd1IEJqq
        Nugbjosp1/W4yRkkZXEPx5F66I4OydI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-jbvl_FeBP-i935CIBvD2JQ-1; Mon, 31 Jan 2022 12:54:55 -0500
X-MC-Unique: jbvl_FeBP-i935CIBvD2JQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBB4218B6143;
        Mon, 31 Jan 2022 17:54:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 120467CD6E;
        Mon, 31 Jan 2022 17:54:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/2] cifs: Fix the readahead conversion to manage the batch
 when reading from cache
From:   David Howells <dhowells@redhat.com>
To:     smfrench@gmail.com
Cc:     Rohith Surabattula <rohiths.msft@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        dhowells@redhat.com
Date:   Mon, 31 Jan 2022 17:54:43 +0000
Message-ID: <164365168321.2045659.15295459927789942552.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix the readahead conversion to correctly manage the last batch skipping
when reading from cache.  This involves a readahead batch of one page or
one folio, so set the batch size according to the number of constituent
pages (should be 1 for a filesystem that doesn't do multipage folios yet).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <smfrench@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
---

 fs/cifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1b41b6f2a04b..e7af802dcfa6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4446,7 +4446,7 @@ static void cifs_readahead(struct readahead_control *ractl)
 				 * by the cache.
 				 */
 				page = readahead_page(ractl);
-				BUG_ON(!page);
+				last_batch_size = 1 << thp_order(page);
 				if (cifs_readpage_from_fscache(ractl->mapping->host,
 							       page) < 0) {
 					/*


