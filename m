Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3783C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Jul 2022 19:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiGRTGe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Jul 2022 15:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiGRTGd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Jul 2022 15:06:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9BFBE08
        for <linux-cifs@vger.kernel.org>; Mon, 18 Jul 2022 12:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=p+HX9aajxVcaNvEeI6Gc+rKWQxR6HXnM3LZoycxRr64=; b=FRKP9eRUCCfVg+y1H+762v4USU
        Ad01JmGSeK5uj3akyxMpOW6TRQJF0ahwLi+4vbrQVb42ECBrleDg1qxjSWd35j0K4MeoFOX7JEb5D
        7Wxl5QeF7L3m2ppz241J/EIKuQMWm4Ur8tyhjaIySeXaeyR7U1JkV+tgWwjaV0UwjlW6IfYO5uzIo
        hRZ7cxPtqOiZRdixlSO3VFJ76nF8mfU8wudmOdmewzrEf+J+TIwICVtix0eM5QRq4RglZwJB6bl6d
        U5icgFmJFPzMI2skdDQ16HP7TDKqxOQGJP33OfbeI0ihBCfiS5PIOodnTEFo2Pwl0LKbG54Ban61z
        PcjD8m8A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDW4b-00CxFn-Gz; Mon, 18 Jul 2022 19:06:29 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] cifs: Fix memory leak when using fscache
Date:   Mon, 18 Jul 2022 20:06:24 +0100
Message-Id: <20220718190624.3087569-1-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If we hit the 'index == next_cached' case, we leak a refcount on the
struct page.  Fix this by using readahead_folio() which takes care of
the refcount for you.

Fixes: 0174ee9947bd ("cifs: Implement cache I/O by accessing the cache directly")
Cc: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/cifs/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e64cda7a7610..6985710e14c2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4459,10 +4459,10 @@ static void cifs_readahead(struct readahead_control *ractl)
 				 * TODO: Send a whole batch of pages to be read
 				 * by the cache.
 				 */
-				page = readahead_page(ractl);
-				last_batch_size = 1 << thp_order(page);
+				struct folio *folio = readahead_folio(ractl);
+				last_batch_size = folio_nr_pages(folio);
 				if (cifs_readpage_from_fscache(ractl->mapping->host,
-							       page) < 0) {
+							       &folio->page) < 0) {
 					/*
 					 * TODO: Deal with cache read failure
 					 * here, but for the moment, delegate
@@ -4470,7 +4470,7 @@ static void cifs_readahead(struct readahead_control *ractl)
 					 */
 					caching = false;
 				}
-				unlock_page(page);
+				folio_unlock(folio);
 				next_cached++;
 				cache_nr_pages--;
 				if (cache_nr_pages == 0)
-- 
2.35.1

