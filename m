Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3D6C43461
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 15:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50AE72078D
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 15:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a+K4f9p4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgIQPMH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727632AbgIQPL0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Sep 2020 11:11:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20969C061797;
        Thu, 17 Sep 2020 08:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=U62SUaGW7wvOzK2xtP2u7DsjwRF7PHeB8dtYgkbpx0Q=; b=a+K4f9p4caAQHaSAXoyEo9jeic
        z4rS6gVD2VceD3F5n0ghyfOLqAZbHLTwI99dJ+d8FGfT/jTf1vAo5dvv+QCapDyOhKA8JoU0dH7RD
        jl4ADHoGw3ZLskEsKuxMRE7ZcodmNtgjg/vR+S4wH8kUjdMw/iyvasBdyOEf/DOf/LzNvzfPhKY4c
        BDymXvXRBCnHXXX5DABtfF6xsFxkpO+KbwOq51fiobz400r64lHL5BJ2mnOPZvZ0GtPVfUU+QiaEX
        Qoc6ZzECgmEic+oThwXQSXLyd+mCy7ExsKIh2V7a4Z93AiINBSZZYIOO3eL3fpc8kC69q1XZ+87IC
        7NyQ+p5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIvYj-0001Pp-Cs; Thu, 17 Sep 2020 15:10:53 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-um@lists.infradead.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 06/13] cramfs: Tell the VFS that readpage was synchronous
Date:   Thu, 17 Sep 2020 16:10:43 +0100
Message-Id: <20200917151050.5363-7-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200917151050.5363-1-willy@infradead.org>
References: <20200917151050.5363-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The cramfs readpage implementation was already synchronous, so use
AOP_UPDATED_PAGE to avoid cycling the page lock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/cramfs/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 912308600d39..7a642146c074 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -916,15 +916,14 @@ static int cramfs_readpage(struct file *file, struct page *page)
 	flush_dcache_page(page);
 	kunmap(page);
 	SetPageUptodate(page);
-	unlock_page(page);
-	return 0;
+	return AOP_UPDATED_PAGE;
 
 err:
 	kunmap(page);
 	ClearPageUptodate(page);
 	SetPageError(page);
 	unlock_page(page);
-	return 0;
+	return -EIO;
 }
 
 static const struct address_space_operations cramfs_aops = {
-- 
2.28.0

