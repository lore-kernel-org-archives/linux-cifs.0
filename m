Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF0EC433E2
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 15:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D526620795
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 15:12:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hL1cKoF+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgIQPMg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbgIQPL0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Sep 2020 11:11:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28ABC06178B;
        Thu, 17 Sep 2020 08:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=MTLlKe719mgAVscm2w1Ql0nN7cIRPfZQnUskn6+25OA=; b=hL1cKoF+6/UAQwKZIfKnU0NZqr
        5yu8M7+7C5AX6w2ZPJR/qCXtNh7fJv27Z77Vzg8+rgPWUUAccXm6tDAc3RAjURPkde7Zqjc5//Z0p
        46Fkcm7nzOM2P9Av5IqEb5DBysNZXaLpSIFI0VmfJzpsEzy4k1mlNLIFBwXItEIIMuEfqHOhCFmD6
        N9w4+E/bGdCcr5t/UEf/772f/WOi+W3pu/0ob1SVwmgYAGtuCpTkHyVzp2Eii+eUkpm7Y2RVYO8Jh
        weQ8jbJAdSxLrmFKCtZL5WTufs7vOcOru0MJvs/IwIS8jD/oQYRu/fi5yOyFxJl0fkYD/uFdDqAe/
        Mdqo87Jg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIvYi-0001Pa-Tk; Thu, 17 Sep 2020 15:10:52 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-um@lists.infradead.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 04/13] ceph: Tell the VFS that readpage was synchronous
Date:   Thu, 17 Sep 2020 16:10:41 +0100
Message-Id: <20200917151050.5363-5-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200917151050.5363-1-willy@infradead.org>
References: <20200917151050.5363-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The ceph readpage implementation was already synchronous, so use
AOP_UPDATED_PAGE to avoid cycling the page lock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ceph/addr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6ea761c84494..b2bf8bf7a312 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -291,10 +291,11 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 static int ceph_readpage(struct file *filp, struct page *page)
 {
 	int r = ceph_do_readpage(filp, page);
-	if (r != -EINPROGRESS)
-		unlock_page(page);
-	else
-		r = 0;
+	if (r == -EINPROGRESS)
+		return 0;
+	if (r == 0)
+		return AOP_UPDATED_PAGE;
+	unlock_page(page);
 	return r;
 }
 
-- 
2.28.0

