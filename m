Return-Path: <SRS0=iW/V=74=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35655C433DF
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Jun 2020 22:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F36B0207D3
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Jun 2020 22:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592260555;
	bh=eTCB2EW6RLvV2Ig6ZGQCIIQyJWs+h/bOXkyK93wZCEs=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=XcAiZDMFt9BVB2/gOpXVSFRzG2M87UMxgvfWFGWI87vmb19A03WHIuW9WtT8+pqka
	 b0OeANEZhg/A6EGbcYyiZmZY+N19O2drZetfqbs3l9EZk/skRCSWLLhZKP5GkXb/4n
	 qC+CunaQYsw66C3IOMVON0hqJDSN+60jE2Hzn924=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgFOWfy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Jun 2020 18:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFOWfy (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 15 Jun 2020 18:35:54 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 328402071A;
        Mon, 15 Jun 2020 22:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592260553;
        bh=eTCB2EW6RLvV2Ig6ZGQCIIQyJWs+h/bOXkyK93wZCEs=;
        h=Date:From:To:Cc:Subject:From;
        b=2nsSQhEoykRtd2Dk7GGmt826DRiFh1FIGpadTjWGwRD62mpsmGMf+M0Wf73pKi0+a
         /jtRnFn0psed2Dixgfi6+TK+Fny4jcSx99o0IiRb1v9YpI9OVbyYJ+jTiRNnYfBmP0
         8mCZhW0wPaHXe3DOYyXkt5E0N9HrsFWbt1RfmEjY=
Date:   Mon, 15 Jun 2020 17:41:12 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] cifs: misc: Use array_size() in if-statement controlling
 expression
Message-ID: <20200615224112.GA12307@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use array_size() instead of the open-coded version in the controlling
expression of the if statement.

Also, while there, use the preferred form for passing a size of a struct.
The alternative form where struct name is spelled out hurts readability
and introduces an opportunity for a bug when the pointer variable type is
changed but the corresponding sizeof that is passed as argument is not.

This issue was found with the help of Coccinelle and, audited and fixed
manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/cifs/misc.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 56791a692c8b..e44d049142d0 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -844,28 +844,26 @@ setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw)
 	struct bio_vec *bv = NULL;
 
 	if (iov_iter_is_kvec(iter)) {
-		memcpy(&ctx->iter, iter, sizeof(struct iov_iter));
+		memcpy(&ctx->iter, iter, sizeof(*iter));
 		ctx->len = count;
 		iov_iter_advance(iter, count);
 		return 0;
 	}
 
-	if (max_pages * sizeof(struct bio_vec) <= CIFS_AIO_KMALLOC_LIMIT)
-		bv = kmalloc_array(max_pages, sizeof(struct bio_vec),
-				   GFP_KERNEL);
+	if (array_size(max_pages, sizeof(*bv)) <= CIFS_AIO_KMALLOC_LIMIT)
+		bv = kmalloc_array(max_pages, sizeof(*bv), GFP_KERNEL);
 
 	if (!bv) {
-		bv = vmalloc(array_size(max_pages, sizeof(struct bio_vec)));
+		bv = vmalloc(array_size(max_pages, sizeof(*bv)));
 		if (!bv)
 			return -ENOMEM;
 	}
 
-	if (max_pages * sizeof(struct page *) <= CIFS_AIO_KMALLOC_LIMIT)
-		pages = kmalloc_array(max_pages, sizeof(struct page *),
-				      GFP_KERNEL);
+	if (array_size(max_pages, sizeof(*pages)) <= CIFS_AIO_KMALLOC_LIMIT)
+		pages = kmalloc_array(max_pages, sizeof(*pages), GFP_KERNEL);
 
 	if (!pages) {
-		pages = vmalloc(array_size(max_pages, sizeof(struct page *)));
+		pages = vmalloc(array_size(max_pages, sizeof(*pages)));
 		if (!pages) {
 			kvfree(bv);
 			return -ENOMEM;
-- 
2.27.0

