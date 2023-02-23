Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B13C636D7
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Feb 2023 08:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjBWIRE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Feb 2023 03:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbjBWIRB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Feb 2023 03:17:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21D74DE11
        for <linux-cifs@vger.kernel.org>; Thu, 23 Feb 2023 00:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677140149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X3ikqoEsv3r0MxS807H4Mv08SZa5kDqPLyNECnlbwYE=;
        b=CU6Z5+zFcbalFS2dX5FeliL/C6Kb/Q4AwX5yrwPq6Pw8nV1MYMhd5BYtO5qAku2wR3g5pC
        qyttKQarwPRtWxm1Npp1GJTrEHv8Lw2PxkpRtKZg85PpSPE2BFtWYr5kv7uBFwLG8JcAv1
        s1ne7vrTPAlhRKpmLAXh49bDqP2eE+s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-JGOh3xiMO9emvn2N0KPR9g-1; Thu, 23 Feb 2023 03:15:45 -0500
X-MC-Unique: JGOh3xiMO9emvn2N0KPR9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1009F802C18;
        Thu, 23 Feb 2023 08:15:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C251F1121314;
        Thu, 23 Feb 2023 08:15:43 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: [PATCH 1/2] cifs: Add some missing xas_retry() calls
Date:   Thu, 23 Feb 2023 08:15:38 +0000
Message-Id: <20230223081539.970487-2-dhowells@redhat.com>
In-Reply-To: <20230223081539.970487-1-dhowells@redhat.com>
References: <20230223081539.970487-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The xas_for_each loops added into fs/cifs/file.c need to go round again if
indicated by xas_retry().

Fixes: 5f0955c98375 ("cifs: Add some helper functions")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Tom Talpey <tom@talpey.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
---
 fs/cifs/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0e602173ac76..5c60f4044b65 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -52,6 +52,8 @@ static void cifs_undirty_folios(struct inode *inode, loff_t start, unsigned int
 
 	end = (start + len - 1) / PAGE_SIZE;
 	xas_for_each_marked(&xas, folio, end, PAGECACHE_TAG_DIRTY) {
+		if (xas_retry(&xas, folio))
+			continue;
 		xas_pause(&xas);
 		rcu_read_unlock();
 		folio_lock(folio);
@@ -81,6 +83,8 @@ void cifs_pages_written_back(struct inode *inode, loff_t start, unsigned int len
 
 	end = (start + len - 1) / PAGE_SIZE;
 	xas_for_each(&xas, folio, end) {
+		if (xas_retry(&xas, folio))
+			continue;
 		if (!folio_test_writeback(folio)) {
 			WARN_ONCE(1, "bad %x @%llx page %lx %lx\n",
 				  len, start, folio_index(folio), end);
@@ -112,6 +116,8 @@ void cifs_pages_write_failed(struct inode *inode, loff_t start, unsigned int len
 
 	end = (start + len - 1) / PAGE_SIZE;
 	xas_for_each(&xas, folio, end) {
+		if (xas_retry(&xas, folio))
+			continue;
 		if (!folio_test_writeback(folio)) {
 			WARN_ONCE(1, "bad %x @%llx page %lx %lx\n",
 				  len, start, folio_index(folio), end);

