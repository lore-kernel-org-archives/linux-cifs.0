Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24CEC43219
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Nov 2022 13:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiKPNTJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Nov 2022 08:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbiKPNTI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Nov 2022 08:19:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2FA2126B
        for <linux-cifs@vger.kernel.org>; Wed, 16 Nov 2022 05:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=u/oShJ302tmkGGvj0bjrcFQrXXwSX1/0HQi74xz16ks=; b=CsJttR4OYIVHr1DKyiIuJ2eBcC
        q7/VW5H3rN3iFmBQCuQlv0U0m/5/LutkdWfR5VseO92fXCT0R0oC7ZDMfTJGxh2RsoxwHo+mk6e3c
        vAarjyS7Br6mJBMxhLdGSgw8c8nJJw4d3ZCFOra74XL++TkJMlSGfI/wZwwOI96w1jvu/nHo5N8V3
        g2CqF2GL0512Joai0mhps7p19cm+aAHBjEzUJJUv0F0aFm975kn7zY/HSaZvPUjSMSwTXQPsXi4/K
        K+HYB+esGRk4pOgTVumOm8NAmQtauCE0CCZaZeXx6U8IIRjXpI0ABQ7KXAYOH3JhVX/w9SHXuduO0
        yjeSp8FA==;
Received: from [2001:4bb8:191:2606:427:bb47:a3d:e0b8] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovIJQ-003nek-8Q; Wed, 16 Nov 2022 13:18:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Steve French <sfrench@samba.org>
Cc:     Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH 2/3] cifs: stop using generic_writepages
Date:   Wed, 16 Nov 2022 14:18:34 +0100
Message-Id: <20221116131835.2192188-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116131835.2192188-1-hch@lst.de>
References: <20221116131835.2192188-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

generic_writepages is just a wrapper that calls ->writepages on a range,
and thus in the way of eventually removing ->writepage.  Switch cifs
to just open code it in preparation of removing ->writepage.

[note: I suspect just integrating the small wsize case with the rest
 of the writeback code might be a better idea here, but that needs
 someone more familiar with the code]

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/cifs/file.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6be924caed393..ec14e38411a13 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2646,6 +2646,21 @@ wdata_send_pages(struct cifs_writedata *wdata, unsigned int nr_pages,
 	return rc;
 }
 
+static int
+cifs_writepage_locked(struct page *page, struct writeback_control *wbc);
+
+static int cifs_write_one_page(struct page *page, struct writeback_control *wbc,
+		void *data)
+{
+	struct address_space *mapping = data;
+	int ret;
+
+	ret = cifs_writepage_locked(page, wbc);
+	unlock_page(page);
+	mapping_set_error(mapping, ret);
+	return ret;
+}
+
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
@@ -2662,10 +2677,11 @@ static int cifs_writepages(struct address_space *mapping,
 
 	/*
 	 * If wsize is smaller than the page cache size, default to writing
-	 * one page at a time via cifs_writepage
+	 * one page at a time.
 	 */
 	if (cifs_sb->ctx->wsize < PAGE_SIZE)
-		return generic_writepages(mapping, wbc);
+		return write_cache_pages(mapping, wbc, cifs_write_one_page,
+				mapping);
 
 	xid = get_xid();
 	if (wbc->range_cyclic) {
-- 
2.30.2

