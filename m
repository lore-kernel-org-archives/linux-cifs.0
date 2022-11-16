Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DE8C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Nov 2022 13:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiKPNTJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Nov 2022 08:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiKPNTI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Nov 2022 08:19:08 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECA920F73
        for <linux-cifs@vger.kernel.org>; Wed, 16 Nov 2022 05:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=q/E3BqKCCjoCcCCbz9UnkL+Bsv6hDhREGM9RbKHDxDY=; b=QaL6DBkAN1mZckqOyGSH+rEmb8
        uXsgxRsBSjEtyiC4ViKlRTlUgzuaPyqrJZ9spW5vE1VnjxGI5jMA4mg1BdKXFOP6Zj1TdG9VpJO9h
        bnZr7gWddbIUzz6d+JPTLOzUhiBlJSIxqZA4Yr60qtXiWjnD2FPGaQTdCQUYJWVcPR2IUJxXI0gXe
        UdKj2y8jj9Rty1uybE5NsZWCXAgJxgKsBeKTOUuxvf1VmWyy0CfdxAFVufDxF/oivdzqLW0+uX0Md
        LLSOs4vgPGF8IELH7P6tx4Jo/R/jop3pMhVLvN2BAGMZZERIbv2K9gLcUvvHUZwade5yz4+XZepi4
        +wpZ2jKw==;
Received: from [2001:4bb8:191:2606:427:bb47:a3d:e0b8] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovIJN-003ndw-2P; Wed, 16 Nov 2022 13:18:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Steve French <sfrench@samba.org>
Cc:     Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH 1/3] cifs: wire up >migrate_folio
Date:   Wed, 16 Nov 2022 14:18:33 +0100
Message-Id: <20221116131835.2192188-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116131835.2192188-1-hch@lst.de>
References: <20221116131835.2192188-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

CIFS does not use page private data that needs migration, so it can just
wire up filemap_migrate_folio.  This prepares for removing ->writepage,
which is used as a fallback if no migrate_folio method is set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/cifs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index cd96982099309..6be924caed393 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -5240,10 +5240,10 @@ const struct address_space_operations cifs_addr_ops = {
 	.direct_IO = cifs_direct_io,
 	.invalidate_folio = cifs_invalidate_folio,
 	.launder_folio = cifs_launder_folio,
+	.migrate_folio = filemap_migrate_folio,
 	/*
-	 * TODO: investigate and if useful we could add an cifs_migratePage
-	 * helper (under an CONFIG_MIGRATION) in the future, and also
-	 * investigate and add an is_dirty_writeback helper if needed
+	 * TODO: investigate and if useful we could add an is_dirty_writeback
+	 * helper if needed
 	 */
 	.swap_activate = cifs_swap_activate,
 	.swap_deactivate = cifs_swap_deactivate,
@@ -5264,4 +5264,5 @@ const struct address_space_operations cifs_addr_ops_smallbuf = {
 	.release_folio = cifs_release_folio,
 	.invalidate_folio = cifs_invalidate_folio,
 	.launder_folio = cifs_launder_folio,
+	.migrate_folio = filemap_migrate_folio,
 };
-- 
2.30.2

