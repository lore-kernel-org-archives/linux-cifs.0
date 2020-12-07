Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A31C4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5025023998
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgLGXkK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:40:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLGXkJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:40:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=yBsQThViz/ZF1WAd+mHrx8z5bPVRP3sqMQcz5r4/67c=;
        b=R2R4qWAeG0zgBR/Hzq+1Ej0hbNRX0UOpmf8Ed+VFPL7PVyC+IyLpauxCtH8KeP1FPDJnQA
        tOYfNV6NQQluZ9LbQCkwZuGrqmKpm9iKQ5RH/EwUIB/kYPnZ1MVhuGm5Rm721MCblAI4Z/
        FskGPHDUE5wVhPj2hx+q0sbThMhen/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-ey5LdsE7PBu_Mg-99ncIyw-1; Mon, 07 Dec 2020 18:38:41 -0500
X-MC-Unique: ey5LdsE7PBu_Mg-99ncIyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5A02107ACE4;
        Mon,  7 Dec 2020 23:38:39 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F15A85C1A1;
        Mon,  7 Dec 2020 23:38:38 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 07/21] cifs: add an smb3_fs_context to cifs_sb
Date:   Tue,  8 Dec 2020 09:36:32 +1000
Message-Id: <20201207233646.29823-7-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and populate it during mount in cifs_smb3_do_mount()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_fs_sb.h |  1 +
 fs/cifs/cifsfs.c     | 60 +++++++++++++++++++++++++---------------------------
 fs/cifs/connect.c    | 13 +++++++++---
 3 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 6e7c4427369d..34d0229c0519 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -61,6 +61,7 @@ struct cifs_sb_info {
 	spinlock_t tlink_tree_lock;
 	struct tcon_link *master_tlink;
 	struct nls_table *local_nls;
+	struct smb3_fs_context *ctx;
 	unsigned int bsize;
 	unsigned int rsize;
 	unsigned int wsize;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 907c82428c42..7fe6502e1672 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -776,8 +776,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 {
 	int rc;
 	struct super_block *sb;
-	struct cifs_sb_info *cifs_sb;
-	struct smb3_fs_context *ctx;
+	struct cifs_sb_info *cifs_sb = NULL;
 	struct cifs_mnt_data mnt_data;
 	struct dentry *root;
 
@@ -790,49 +789,51 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	else
 		cifs_info("Attempting to mount %s\n", old_ctx->UNC);
 
-	ctx = kzalloc(sizeof(struct smb3_fs_context), GFP_KERNEL);
-	if (!ctx)
-		return ERR_PTR(-ENOMEM);
-	rc = smb3_fs_context_dup(ctx, old_ctx);
-	if (rc) {
-		root = ERR_PTR(rc);
+	cifs_sb = kzalloc(sizeof(struct cifs_sb_info), GFP_KERNEL);
+	if (cifs_sb == NULL) {
+		root = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
-	rc = cifs_setup_volume_info(ctx);
+	cifs_sb->ctx = kzalloc(sizeof(struct smb3_fs_context), GFP_KERNEL);
+	if (!cifs_sb->ctx) {
+		root = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	rc = smb3_fs_context_dup(cifs_sb->ctx, old_ctx);
 	if (rc) {
 		root = ERR_PTR(rc);
 		goto out;
 	}
 
-	cifs_sb = kzalloc(sizeof(struct cifs_sb_info), GFP_KERNEL);
-	if (cifs_sb == NULL) {
-		root = ERR_PTR(-ENOMEM);
-		goto out_nls;
+	rc = cifs_setup_volume_info(cifs_sb->ctx);
+	if (rc) {
+		root = ERR_PTR(rc);
+		goto out;
 	}
 
-	cifs_sb->mountdata = kstrndup(ctx->mount_options, PAGE_SIZE, GFP_KERNEL);
+	cifs_sb->mountdata = kstrndup(cifs_sb->ctx->mount_options, PAGE_SIZE, GFP_KERNEL);
 	if (cifs_sb->mountdata == NULL) {
 		root = ERR_PTR(-ENOMEM);
-		goto out_free;
+		goto out;
 	}
 
-	rc = cifs_setup_cifs_sb(ctx, cifs_sb);
+	rc = cifs_setup_cifs_sb(cifs_sb->ctx, cifs_sb);
 	if (rc) {
 		root = ERR_PTR(rc);
-		goto out_free;
+		goto out;
 	}
 
-	rc = cifs_mount(cifs_sb, ctx);
+	rc = cifs_mount(cifs_sb, cifs_sb->ctx);
 	if (rc) {
 		if (!(flags & SB_SILENT))
 			cifs_dbg(VFS, "cifs_mount failed w/return code = %d\n",
 				 rc);
 		root = ERR_PTR(rc);
-		goto out_free;
+		goto out;
 	}
 
-	mnt_data.ctx = ctx;
+	mnt_data.ctx = cifs_sb->ctx;
 	mnt_data.cifs_sb = cifs_sb;
 	mnt_data.flags = flags;
 
@@ -859,26 +860,23 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 		sb->s_flags |= SB_ACTIVE;
 	}
 
-	root = cifs_get_root(ctx, sb);
+	root = cifs_get_root(cifs_sb->ctx, sb);
 	if (IS_ERR(root))
 		goto out_super;
 
 	cifs_dbg(FYI, "dentry root is: %p\n", root);
-	goto out;
+	return root;
 
 out_super:
 	deactivate_locked_super(sb);
 out:
-	cifs_cleanup_volume_info(ctx);
+	if (cifs_sb) {
+		kfree(cifs_sb->prepath);
+		kfree(cifs_sb->mountdata);
+		cifs_cleanup_volume_info(cifs_sb->ctx);
+		kfree(cifs_sb);
+	}
 	return root;
-
-out_free:
-	kfree(cifs_sb->prepath);
-	kfree(cifs_sb->mountdata);
-	kfree(cifs_sb);
-out_nls:
-	unload_nls(ctx->local_nls);
-	goto out;
 }
 
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dd7c2058ecf6..20acd741fda2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2786,6 +2786,9 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
 void
 cifs_cleanup_volume_info_contents(struct smb3_fs_context *ctx)
 {
+	if (ctx == NULL)
+		return;
+
 	/*
 	 * Make sure this stays in sync with smb3_fs_context_dup()
 	 */
@@ -2805,6 +2808,9 @@ cifs_cleanup_volume_info_contents(struct smb3_fs_context *ctx)
 	ctx->iocharset = NULL;
 	kfree(ctx->prepath);
 	ctx->prepath = NULL;
+
+	unload_nls(ctx->local_nls);
+	ctx->local_nls = NULL;
 }
 
 void
@@ -3725,9 +3731,10 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 
 static void delayed_free(struct rcu_head *p)
 {
-	struct cifs_sb_info *sbi = container_of(p, struct cifs_sb_info, rcu);
-	unload_nls(sbi->local_nls);
-	kfree(sbi);
+	struct cifs_sb_info *cifs_sb = container_of(p, struct cifs_sb_info, rcu);
+	unload_nls(cifs_sb->local_nls);
+	cifs_cleanup_volume_info(cifs_sb->ctx);
+	kfree(cifs_sb);
 }
 
 void
-- 
2.13.6

