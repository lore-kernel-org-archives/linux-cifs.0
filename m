Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3382BC2BBCF
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F8DB22597
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438782AbgLNGmV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:42:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438787AbgLNGmV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 01:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607928055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=dk9WPLSfZuxNoqUUxSGx5+IDenWtY5agN6HgZSFH/kQ=;
        b=KrLnvzepCdqzgT1cZ9FkbD9TOXYd2+wbJ+EYbM3V12jW9wm+c8vdW03Ew18i+64TZrDuAH
        d+CDKyx6VzeLyg6CLyOp2+aX52g/+cGxep/GlNqN7asnIvdvQ1qAETE9JRJDiw1xTnuJm+
        b4P2ZzkMtua3TZqi++lhW6bEu78fllU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-VzuQA7JcOtGHW7mM-8yNtg-1; Mon, 14 Dec 2020 01:40:53 -0500
X-MC-Unique: VzuQA7JcOtGHW7mM-8yNtg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 603C1107ACE8;
        Mon, 14 Dec 2020 06:40:52 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E9A66E71E;
        Mon, 14 Dec 2020 06:40:51 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 03/12] cifs: add initial reconfigure support
Date:   Mon, 14 Dec 2020 16:40:18 +1000
Message-Id: <20201214064027.2885-3-lsahlber@redhat.com>
In-Reply-To: <20201214064027.2885-1-lsahlber@redhat.com>
References: <20201214064027.2885-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index e83bd4382dfa..4bab06f97727 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -620,14 +620,44 @@ static void smb3_fs_context_free(struct fs_context *fc)
 	smb3_cleanup_fs_context(ctx);
 }
 
-static int smb3_reconfigure(struct fs_context *fc)
+/*
+ * Compare the old and new proposed context during reconfigure
+ * and check if the changes are compatible.
+ */
+static int smb3_verify_reconfigure_ctx(struct smb3_fs_context *new_ctx,
+				       struct smb3_fs_context *old_ctx)
 {
-	// TODO:  struct smb3_fs_context *ctx = smb3_fc2context(fc);
+	if (new_ctx->sectype != old_ctx->sectype) {
+		cifs_dbg(VFS, "can not change sec during remount\n");
+		return -EINVAL;
+	}
 
-	/* FIXME : add actual reconfigure */
 	return 0;
 }
 
+static int smb3_reconfigure(struct fs_context *fc)
+{
+	struct smb3_fs_context *ctx = smb3_fc2context(fc);
+	struct dentry *root = fc->root;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
+	int rc;
+
+	rc = smb3_verify_reconfigure_ctx(ctx, cifs_sb->ctx);
+	if (rc)
+		return rc;
+
+	/*
+	 * Steal the UNC from the old and to be destroyed context.
+	 */
+	ctx->UNC = cifs_sb->ctx->UNC;
+	cifs_sb->ctx->UNC = NULL;
+
+	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
+	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
+
+	return rc;
+}
+
 static int smb3_fs_context_parse_param(struct fs_context *fc,
 				      struct fs_parameter *param)
 {
-- 
2.13.6

