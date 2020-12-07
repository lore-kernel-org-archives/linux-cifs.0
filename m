Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C1BC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E42823998
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgLGXjw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:39:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLGXjw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:39:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=IaNO/e1RsHSAeTXR5OIDYuO7B2U8Iof604UUSNl0xr4=;
        b=TMRi2H9QY0lkFYzEqpjjUuS0UfiIdKtiw9GtSrUryMHnZp+tI0s3iWeTwSTwecFwm6fiyt
        oQ/kyuqIXWpU1el64HMBDohbeHoIxZfbXHB6Swwq075GAyReV6rSthpSAntA53p9GdDsy3
        b2byPKX3pRFVOkHd3MrXM3ljhjVxNtk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-9stgjFddNIyAGO2vgL5vnw-1; Mon, 07 Dec 2020 18:38:24 -0500
X-MC-Unique: 9stgjFddNIyAGO2vgL5vnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09D7C107ACE3;
        Mon,  7 Dec 2020 23:38:23 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1675E10016DB;
        Mon,  7 Dec 2020 23:38:21 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 02/21] cifs: rename dup_vol to smb3_fs_context_dup and move it into fs_context.c
Date:   Tue,  8 Dec 2020 09:36:27 +1000
Message-Id: <20201207233646.29823-2-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/dfs_cache.c  | 60 +---------------------------------------------------
 fs/cifs/fs_context.c | 41 +++++++++++++++++++++++++++++++++++
 fs/cifs/fs_context.h |  3 ++-
 3 files changed, 44 insertions(+), 60 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 3860241dcc03..2b77d39d7d22 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1141,64 +1141,6 @@ int dfs_cache_get_tgt_referral(const char *path,
 	return rc;
 }
 
-static int dup_vol(struct smb3_fs_context *ctx, struct smb3_fs_context *new)
-{
-	memcpy(new, ctx, sizeof(*new));
-
-	if (ctx->username) {
-		new->username = kstrndup(ctx->username, strlen(ctx->username),
-					 GFP_KERNEL);
-		if (!new->username)
-			return -ENOMEM;
-	}
-	if (ctx->password) {
-		new->password = kstrndup(ctx->password, strlen(ctx->password),
-					 GFP_KERNEL);
-		if (!new->password)
-			goto err_free_username;
-	}
-	if (ctx->UNC) {
-		cifs_dbg(FYI, "%s: ctx->UNC: %s\n", __func__, ctx->UNC);
-		new->UNC = kstrndup(ctx->UNC, strlen(ctx->UNC), GFP_KERNEL);
-		if (!new->UNC)
-			goto err_free_password;
-	}
-	if (ctx->domainname) {
-		new->domainname = kstrndup(ctx->domainname,
-					   strlen(ctx->domainname), GFP_KERNEL);
-		if (!new->domainname)
-			goto err_free_unc;
-	}
-	if (ctx->iocharset) {
-		new->iocharset = kstrndup(ctx->iocharset,
-					  strlen(ctx->iocharset), GFP_KERNEL);
-		if (!new->iocharset)
-			goto err_free_domainname;
-	}
-	if (ctx->prepath) {
-		cifs_dbg(FYI, "%s: ctx->prepath: %s\n", __func__, ctx->prepath);
-		new->prepath = kstrndup(ctx->prepath, strlen(ctx->prepath),
-					GFP_KERNEL);
-		if (!new->prepath)
-			goto err_free_iocharset;
-	}
-
-	return 0;
-
-err_free_iocharset:
-	kfree(new->iocharset);
-err_free_domainname:
-	kfree(new->domainname);
-err_free_unc:
-	kfree(new->UNC);
-err_free_password:
-	kfree_sensitive(new->password);
-err_free_username:
-	kfree(new->username);
-	kfree(new);
-	return -ENOMEM;
-}
-
 /**
  * dfs_cache_add_vol - add a cifs volume during mount() that will be handled by
  * DFS cache refresh worker.
@@ -1229,7 +1171,7 @@ int dfs_cache_add_vol(char *mntdata, struct smb3_fs_context *ctx, const char *fu
 		goto err_free_vi;
 	}
 
-	rc = dup_vol(ctx, &vi->ctx);
+	rc = smb3_fs_context_dup(&vi->ctx, ctx);
 	if (rc)
 		goto err_free_fullpath;
 
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index aa4b85bd5849..301201903b45 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -7,6 +7,7 @@
  */
 
 #include "cifsglob.h"
+#include "cifsproto.h"
 #include "cifs_debug.h"
 #include "fs_context.h"
 
@@ -219,3 +220,43 @@ cifs_parse_cache_flavor(char *value, struct smb3_fs_context *ctx)
 	}
 	return 0;
 }
+
+#define DUP_CTX_STR(field)						\
+do {									\
+	if (ctx->field) {						\
+		new_ctx->field = kstrdup(ctx->field, GFP_ATOMIC);	\
+		if (new_ctx->field == NULL) {				\
+			cifs_cleanup_volume_info_contents(new_ctx);	\
+			return -ENOMEM;					\
+		}							\
+	}								\
+} while (0)
+
+int
+smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx)
+{
+	int rc = 0;
+
+	memcpy(new_ctx, ctx, sizeof(*ctx));
+	new_ctx->prepath = NULL;
+	new_ctx->local_nls = NULL;
+	new_ctx->nodename = NULL;
+	new_ctx->username = NULL;
+	new_ctx->password = NULL;
+	new_ctx->domainname = NULL;
+	new_ctx->UNC = NULL;
+	new_ctx->iocharset = NULL;
+
+	/*
+	 * Make sure to stay in sync with cifs_cleanup_volume_info_contents()
+	 */
+	DUP_CTX_STR(prepath);
+	DUP_CTX_STR(username);
+	DUP_CTX_STR(password);
+	DUP_CTX_STR(UNC);
+	DUP_CTX_STR(domainname);
+	DUP_CTX_STR(nodename);
+	DUP_CTX_STR(iocharset);
+
+	return rc;
+}
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index f217bd600c1e..1ac5e1d202b6 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -152,6 +152,7 @@ struct smb3_fs_context {
 	bool rootfs:1; /* if it's a SMB root file system */
 };
 
-int cifs_parse_security_flavors(char *value, struct smb3_fs_context *ctx);
+extern int cifs_parse_security_flavors(char *value, struct smb3_fs_context *ctx);
+extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
 
 #endif
-- 
2.13.6

