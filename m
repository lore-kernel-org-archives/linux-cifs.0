Return-Path: <SRS0=R2WM=DX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A61C433E7
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 16:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DCAF20874
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 16:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T7s2jwSi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410570AbgJPQFB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Oct 2020 12:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410439AbgJPQE4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Oct 2020 12:04:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C0AC0613DA;
        Fri, 16 Oct 2020 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7u5VAtMiRg84eQRBFRLzhqfSMq0woXu9gI0XciTFBfo=; b=T7s2jwSip4yAfLX9bZLFVCvA+p
        9yK0UJMjNjfRwc4QujkMMQHnD4EpGzf8NY2Q8b1wbfWirWZmOvwuEVdYA2IgWbu3wRLcx2m3NcrJR
        pgnkENnb6D0U3t6/Jx9QCLSZFR+vCKKo5eE+oB0cPMtkELSbGoDKHuSAWBo6JcZW5ysVxdFhn9CEH
        AYa2KLvBQKERlJK1blr+zROW+iQmQ1L8zRrD3nXhRlwe1v2cS2cf+1WTivUi2wwlPQmD53sFO+DIP
        dQMivBQllAq1EF1rwL716HTgW6QpEFcRcWoW+vszPIFo2nsagHG+nay3PBx2N3VPy+mQw0ZBM1/tq
        HeVQaI6w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kTSDm-0004st-Qo; Fri, 16 Oct 2020 16:04:46 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: [PATCH v3 08/18] cifs: Tell the VFS that readpage was synchronous
Date:   Fri, 16 Oct 2020 17:04:33 +0100
Message-Id: <20201016160443.18685-9-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201016160443.18685-1-willy@infradead.org>
References: <20201016160443.18685-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The cifs readpage implementation was already synchronous, so use
AOP_UPDATED_PAGE to avoid cycling the page lock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/cifs/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index be46fab4c96d..533b151a9143 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4537,7 +4537,8 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 	/* send this page to the cache */
 	cifs_readpage_to_fscache(file_inode(file), page);
 
-	rc = 0;
+	kunmap(page);
+	return AOP_UPDATED_PAGE;
 
 io_error:
 	kunmap(page);
@@ -4677,7 +4678,10 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 		 * an error, we don't need to return it. cifs_write_end will
 		 * do a sync write instead since PG_uptodate isn't set.
 		 */
-		cifs_readpage_worker(file, page, &page_start);
+		int err = cifs_readpage_worker(file, page, &page_start);
+
+		if (err == AOP_UPDATED_PAGE)
+			goto out;
 		put_page(page);
 		oncethru = 1;
 		goto start;
-- 
2.28.0

