Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8053C3526A
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 19:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0ABA22208
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 19:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ab937xav"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgIQPNe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbgIQPLm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Sep 2020 11:11:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE7FC0612F2;
        Thu, 17 Sep 2020 08:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=7bp7tBDREj0/quRwoGKFhcM4IA6X+ak+6znUWRbIy7w=; b=Ab937xavvtVmodPI2thUSGdAlk
        XIba4t3pVWHQS6GXPdgChNV++4m2pWszb+TrwGgDuHl9lLSuinZjp2hFDRXec+62BpUjm82laGwbh
        JN/W0bXPQaaE0Q5jmTXDfMNCxo+N33xx38Z5TH1Ekmq6LWsMu3AaAKlJNv2F36kXaJ1bzo4y69HPF
        L+XH8pTHAvL0tRdG4imOcEeu6JMtw6zPlA/0bm/X/VAPExraituJ0c+ceD9lLq4MB6OiwXHjnFLZM
        JeoXS++sD/pEEDMkBpD7WdUDOHe1HIUOdAEJpCDDg19BRjFTtuPDBSOja8O+dcKYbSjRiBIs5WHms
        Nj8/IOiw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIvYl-0001Qv-Jz; Thu, 17 Sep 2020 15:10:55 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-um@lists.infradead.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 13/13] vboxsf: Tell the VFS that readpage was synchronous
Date:   Thu, 17 Sep 2020 16:10:50 +0100
Message-Id: <20200917151050.5363-14-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200917151050.5363-1-willy@infradead.org>
References: <20200917151050.5363-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The vboxsf inline data readpage implementation was already synchronous,
so use AOP_UPDATED_PAGE to avoid cycling the page lock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/vboxsf/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/vboxsf/file.c b/fs/vboxsf/file.c
index c4ab5996d97a..c2a144e5cb5a 100644
--- a/fs/vboxsf/file.c
+++ b/fs/vboxsf/file.c
@@ -228,6 +228,8 @@ static int vboxsf_readpage(struct file *file, struct page *page)
 	}
 
 	kunmap(page);
+	if (!err)
+		return AOP_UPDATED_PAGE;
 	unlock_page(page);
 	return err;
 }
-- 
2.28.0

