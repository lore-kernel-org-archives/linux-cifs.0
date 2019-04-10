Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6DDC10F11
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 19:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B823520830
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 19:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfDJTiE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbfDJTiE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Apr 2019 15:38:04 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B7F2A3078DA4;
        Wed, 10 Apr 2019 19:38:03 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.20.6.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3775608A7;
        Wed, 10 Apr 2019 19:38:02 +0000 (UTC)
From:   jglisse@redhat.com
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] cifs: fix page reference leak with readv/writev
Date:   Wed, 10 Apr 2019 15:37:47 -0400
Message-Id: <20190410193747.25302-1-jglisse@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 10 Apr 2019 19:38:03 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

CIFS can leak pages reference gotten through GUP (get_user_pages*()
through iov_iter_get_pages()). This happen if cifs_send_async_read()
or cifs_write_from_iter() calls fail from within __cifs_readv() and
__cifs_writev() respectively. This patch move page unreference to
cifs_aio_ctx_release() which will happens on all code paths this is
all simpler to follow for correctness.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stable <stable@vger.kernel.org>
---
 fs/cifs/file.c | 15 +--------------
 fs/cifs/misc.c | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 89006e044973..a756a4d3f70f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2858,7 +2858,6 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
 	struct dentry *dentry = ctx->cfile->dentry;
-	unsigned int i;
 	int rc;
 
 	tcon = tlink_tcon(ctx->cfile->tlink);
@@ -2922,10 +2921,6 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 		kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 	}
 
-	if (!ctx->direct_io)
-		for (i = 0; i < ctx->npages; i++)
-			put_page(ctx->bv[i].bv_page);
-
 	cifs_stats_bytes_written(tcon, ctx->total_len);
 	set_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(dentry->d_inode)->flags);
 
@@ -3563,7 +3558,6 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 	struct iov_iter *to = &ctx->iter;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
-	unsigned int i;
 	int rc;
 
 	tcon = tlink_tcon(ctx->cfile->tlink);
@@ -3647,15 +3641,8 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 		kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 	}
 
-	if (!ctx->direct_io) {
-		for (i = 0; i < ctx->npages; i++) {
-			if (ctx->should_dirty)
-				set_page_dirty(ctx->bv[i].bv_page);
-			put_page(ctx->bv[i].bv_page);
-		}
-
+	if (!ctx->direct_io)
 		ctx->total_len = ctx->len - iov_iter_count(to);
-	}
 
 	/* mask nodata case */
 	if (rc == -ENODATA)
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index bee203055b30..9bc0d17a9d77 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -768,6 +768,11 @@ cifs_aio_ctx_alloc(void)
 {
 	struct cifs_aio_ctx *ctx;
 
+	/*
+	 * Must use kzalloc to initialize ctx->bv to NULL and ctx->direct_io
+	 * to false so that we know when we have to unreference pages within
+	 * cifs_aio_ctx_release()
+	 */
 	ctx = kzalloc(sizeof(struct cifs_aio_ctx), GFP_KERNEL);
 	if (!ctx)
 		return NULL;
@@ -786,7 +791,23 @@ cifs_aio_ctx_release(struct kref *refcount)
 					struct cifs_aio_ctx, refcount);
 
 	cifsFileInfo_put(ctx->cfile);
-	kvfree(ctx->bv);
+
+	/*
+	 * ctx->bv is only set if setup_aio_ctx_iter() was call successfuly
+	 * which means that iov_iter_get_pages() was a success and thus that
+	 * we have taken reference on pages.
+	 */
+	if (ctx->bv) {
+		unsigned i;
+
+		for (i = 0; i < ctx->npages; i++) {
+			if (ctx->should_dirty)
+				set_page_dirty(ctx->bv[i].bv_page);
+			put_page(ctx->bv[i].bv_page);
+		}
+		kvfree(ctx->bv);
+	}
+
 	kfree(ctx);
 }
 
-- 
2.20.1

