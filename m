Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B364C4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Nov 2022 13:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiKPNTI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Nov 2022 08:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbiKPNTH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Nov 2022 08:19:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5694021835
        for <linux-cifs@vger.kernel.org>; Wed, 16 Nov 2022 05:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Y0gJTkmVbdT+zvUmbKtXS4N5nKYSYLQ/A8m5DQX+czk=; b=qT5dZgbSnbEprtT3NlzhcnXQIH
        fPFLEH0nGF2xV8I28F6bvR2wLUu9WG101aIzfZychSkdLmJo/T8JFaGVDJbEYIeF2ydDbdDmCeeZS
        5r47EgWK8bbdKbRnxvbpPGZko9WB2iKk+GBk12sPozQwHONFUdZKOwW1I7EoCeF6HS7BfXU5dwvO0
        D25mw9alZtwsFSt6epf8pfizT5GzkHELsOqU2019CWegI+S4tmTG5AdbQWn5ZL0bfLKO0hrL9GU4b
        dvrG2rd8EtProdUd7vr2cnYGzcKttOkF+bVs7TuIorBuD4+XDKTDn5roAbOIUuDzacl9DK8W0bjkX
        n17kkyWA==;
Received: from [2001:4bb8:191:2606:427:bb47:a3d:e0b8] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovIJT-003nfb-Ak; Wed, 16 Nov 2022 13:18:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Steve French <sfrench@samba.org>
Cc:     Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH 3/3] cifs: remove ->writepage
Date:   Wed, 16 Nov 2022 14:18:35 +0100
Message-Id: <20221116131835.2192188-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116131835.2192188-1-hch@lst.de>
References: <20221116131835.2192188-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

->writepage is a very inefficient method to write back data, and only
used through write_cache_pages or a a fallback when no ->migrate_folio
method is present.  Now that cifs implements ->migrate_folio and
doesn't call generic_writepages, the writepage method can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/cifs/file.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ec14e38411a13..6701257541ab2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2868,13 +2868,6 @@ cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
 	return rc;
 }
 
-static int cifs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	int rc = cifs_writepage_locked(page, wbc);
-	unlock_page(page);
-	return rc;
-}
-
 static int cifs_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
@@ -5247,7 +5240,6 @@ static bool cifs_dirty_folio(struct address_space *mapping, struct folio *folio)
 const struct address_space_operations cifs_addr_ops = {
 	.read_folio = cifs_read_folio,
 	.readahead = cifs_readahead,
-	.writepage = cifs_writepage,
 	.writepages = cifs_writepages,
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
@@ -5272,7 +5264,6 @@ const struct address_space_operations cifs_addr_ops = {
  */
 const struct address_space_operations cifs_addr_ops_smallbuf = {
 	.read_folio = cifs_read_folio,
-	.writepage = cifs_writepage,
 	.writepages = cifs_writepages,
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
-- 
2.30.2

