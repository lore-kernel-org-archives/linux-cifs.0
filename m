Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF34C4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4575B23998
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgLGXk2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:40:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgLGXk1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:40:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Mc9zIymQToMUr0naBMRhP345ums+CF5bOQ6jvQIE8fI=;
        b=XEqD5nhQhUGXv1UiI7JbxyxOyKflSOIlAB+Is0QZdYRJJa0kzNzvNBmDqP5qxYAA5/bEbI
        L4vNJmCNmv6YG3Vi9nN/Yl7NGG9/9I6qUAMtd589p8BU1pWvHsGEnqHMzuq3mByZJQt0GA
        r9SI+O52E3TB4AvUipt/TFrp033nH/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-ByzPApGXOJugh1K7ORe32w-1; Mon, 07 Dec 2020 18:38:57 -0500
X-MC-Unique: ByzPApGXOJugh1K7ORe32w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F876107ACE3;
        Mon,  7 Dec 2020 23:38:56 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D08D5C1A1;
        Mon,  7 Dec 2020 23:38:55 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 11/21] cifs: move cifs_cleanup_volume_info[_content] to fs_context.c
Date:   Tue,  8 Dec 2020 09:36:36 +1000
Message-Id: <20201207233646.29823-11-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

and rename it to smb3_cleanup_fs_context[_content]

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c     |  2 +-
 fs/cifs/cifsproto.h  |  3 ---
 fs/cifs/connect.c    | 47 ++++-------------------------------------------
 fs/cifs/dfs_cache.c  |  4 ++--
 fs/cifs/fs_context.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/fs_context.h |  2 ++
 6 files changed, 51 insertions(+), 52 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e432de7c6ca1..0288632233f6 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -866,7 +866,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 out:
 	if (cifs_sb) {
 		kfree(cifs_sb->prepath);
-		cifs_cleanup_volume_info(cifs_sb->ctx);
+		smb3_cleanup_fs_context(cifs_sb->ctx);
 		kfree(cifs_sb);
 	}
 	return root;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 19ee76f3a96f..b04f7270e04a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -237,7 +237,6 @@ extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
 extern int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
 			       struct cifs_sb_info *cifs_sb);
 extern int cifs_match_super(struct super_block *, void *);
-extern void cifs_cleanup_volume_info(struct smb3_fs_context *ctx);
 extern int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx);
 extern void cifs_umount(struct cifs_sb_info *);
 extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
@@ -552,8 +551,6 @@ extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 
 extern int
 cifs_setup_volume_info(struct smb3_fs_context *ctx);
-extern void
-cifs_cleanup_volume_info_contents(struct smb3_fs_context *ctx);
 
 extern struct TCP_Server_Info *
 cifs_find_tcp_session(struct smb3_fs_context *ctx);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 47e2fe8c19a2..054cb09b8087 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2777,45 +2777,6 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
 	return 0;
 }
 
-void
-cifs_cleanup_volume_info_contents(struct smb3_fs_context *ctx)
-{
-	if (ctx == NULL)
-		return;
-
-	/*
-	 * Make sure this stays in sync with smb3_fs_context_dup()
-	 */
-	kfree(ctx->mount_options);
-	ctx->mount_options = NULL;
-	kfree(ctx->username);
-	ctx->username = NULL;
-	kfree_sensitive(ctx->password);
-	ctx->password = NULL;
-	kfree(ctx->UNC);
-	ctx->UNC = NULL;
-	kfree(ctx->domainname);
-	ctx->domainname = NULL;
-	kfree(ctx->nodename);
-	ctx->nodename = NULL;
-	kfree(ctx->iocharset);
-	ctx->iocharset = NULL;
-	kfree(ctx->prepath);
-	ctx->prepath = NULL;
-
-	unload_nls(ctx->local_nls);
-	ctx->local_nls = NULL;
-}
-
-void
-cifs_cleanup_volume_info(struct smb3_fs_context *ctx)
-{
-	if (!ctx)
-		return;
-	cifs_cleanup_volume_info_contents(ctx);
-	kfree(ctx);
-}
-
 /* Release all succeed connections */
 static inline void mount_put_conns(struct cifs_sb_info *cifs_sb,
 				   unsigned int xid,
@@ -3027,7 +2988,7 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 			rc = PTR_ERR(mdata);
 			mdata = NULL;
 		} else {
-			cifs_cleanup_volume_info_contents(ctx);
+			smb3_cleanup_fs_context_contents(ctx);
 			rc = cifs_setup_volume_info(ctx);
 		}
 		kfree(cifs_sb->ctx->mount_options);
@@ -3119,7 +3080,7 @@ static int setup_dfs_tgt_conn(const char *path, const char *full_path,
 			rc = update_vol_info(tgt_it, &fake_ctx, ctx);
 		}
 	}
-	cifs_cleanup_volume_info_contents(&fake_ctx);
+	smb3_cleanup_fs_context_contents(&fake_ctx);
 	return rc;
 }
 
@@ -3366,7 +3327,7 @@ static int check_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_contex
 					break;
 				rc = -EREMOTE;
 				npath = build_unc_path_to_root(&v, cifs_sb, true);
-				cifs_cleanup_volume_info_contents(&v);
+				smb3_cleanup_fs_context_contents(&v);
 			} else {
 				v.UNC = ctx->UNC;
 				v.prepath = path + 1;
@@ -3729,7 +3690,7 @@ static void delayed_free(struct rcu_head *p)
 {
 	struct cifs_sb_info *cifs_sb = container_of(p, struct cifs_sb_info, rcu);
 	unload_nls(cifs_sb->local_nls);
-	cifs_cleanup_volume_info(cifs_sb->ctx);
+	smb3_cleanup_fs_context(cifs_sb->ctx);
 	kfree(cifs_sb);
 }
 
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 6bccff4596bf..6ad6ba5f6ebe 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -587,7 +587,7 @@ static void __vol_release(struct vol_info *vi)
 {
 	kfree(vi->fullpath);
 	kfree(vi->mntdata);
-	cifs_cleanup_volume_info_contents(&vi->ctx);
+	smb3_cleanup_fs_context_contents(&vi->ctx);
 	kfree(vi);
 }
 
@@ -1468,7 +1468,7 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
 	ses = cifs_get_smb_ses(server, &ctx);
 
 out:
-	cifs_cleanup_volume_info_contents(&ctx);
+	smb3_cleanup_fs_context_contents(&ctx);
 	kfree(mdata);
 	kfree(rpath);
 
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 1e69fdbe76d8..8b74b87d7af7 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -288,7 +288,7 @@ do {									\
 	if (ctx->field) {						\
 		new_ctx->field = kstrdup(ctx->field, GFP_ATOMIC);	\
 		if (new_ctx->field == NULL) {				\
-			cifs_cleanup_volume_info_contents(new_ctx);	\
+			smb3_cleanup_fs_context_contents(new_ctx);	\
 			return -ENOMEM;					\
 		}							\
 	}								\
@@ -311,7 +311,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	new_ctx->iocharset = NULL;
 
 	/*
-	 * Make sure to stay in sync with cifs_cleanup_volume_info_contents()
+	 * Make sure to stay in sync with smb3_cleanup_fs_context_contents()
 	 */
 	DUP_CTX_STR(prepath);
 	DUP_CTX_STR(mount_options);
@@ -615,7 +615,7 @@ static void smb3_fs_context_free(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
 
-	cifs_cleanup_volume_info(ctx);		
+	smb3_cleanup_fs_context(ctx);
 }
 
 static int smb3_reconfigure(struct fs_context *fc)
@@ -1231,3 +1231,42 @@ int smb3_init_fs_context(struct fs_context *fc)
 	fc->ops = &smb3_fs_context_ops;
 	return 0;
 }
+
+void
+smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx)
+{
+	if (ctx == NULL)
+		return;
+
+	/*
+	 * Make sure this stays in sync with smb3_fs_context_dup()
+	 */
+	kfree(ctx->mount_options);
+	ctx->mount_options = NULL;
+	kfree(ctx->username);
+	ctx->username = NULL;
+	kfree_sensitive(ctx->password);
+	ctx->password = NULL;
+	kfree(ctx->UNC);
+	ctx->UNC = NULL;
+	kfree(ctx->domainname);
+	ctx->domainname = NULL;
+	kfree(ctx->nodename);
+	ctx->nodename = NULL;
+	kfree(ctx->iocharset);
+	ctx->iocharset = NULL;
+	kfree(ctx->prepath);
+	ctx->prepath = NULL;
+
+	unload_nls(ctx->local_nls);
+	ctx->local_nls = NULL;
+}
+
+void
+smb3_cleanup_fs_context(struct smb3_fs_context *ctx)
+{
+	if (!ctx)
+		return;
+	smb3_cleanup_fs_context_contents(ctx);
+	kfree(ctx);
+}
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 6e98ef526895..bb3fdce6d7f2 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -252,6 +252,8 @@ extern int cifs_parse_cache_flavor(char *value,
 extern int cifs_parse_security_flavors(char *value,
 				       struct smb3_fs_context *ctx);
 extern int smb3_init_fs_context(struct fs_context *fc);
+extern void smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx);
+extern void smb3_cleanup_fs_context(struct smb3_fs_context *ctx);
 
 static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *fc \
 						    )
-- 
2.13.6

