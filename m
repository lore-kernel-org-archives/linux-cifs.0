Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91470C48BC2
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 22:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF3460041
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 22:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFWWCk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 18:02:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229759AbhFWWCk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Jun 2021 18:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624485621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=st93nk7bExRhIYWWqHd5DNGrLxEMhY9zER7Q1FDXsBU=;
        b=N6Xsscd8CbRE07JPOCQOG9ad+K8uhpYzSuC5IM57B60sryPDeLCQc4IlTn8j6b83z/GYsD
        zs0IGm2vEVRcK9mIl4jj03ODWnOPv89grg/5E0l2m7p/uGbqes4D7LOs8w8Dx705i9rEW3
        s5asAHNxaZHd+WGe9qS9G5g9+vETepw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-1QV0W8JSOomw20eq-NuRng-1; Wed, 23 Jun 2021 18:00:20 -0400
X-MC-Unique: 1QV0W8JSOomw20eq-NuRng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4007E1926DA1;
        Wed, 23 Jun 2021 22:00:19 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-47.bne.redhat.com [10.64.54.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ED3B60871;
        Wed, 23 Jun 2021 22:00:18 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: set the cred_uid/linux_uid/linux_gid when duplicating contexts
Date:   Thu, 24 Jun 2021 08:00:11 +1000
Message-Id: <20210623220011.2074922-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use the nice helpers to initialize and the uid/gid/cred_uid when passed as mount
arguments.
Also, when we duplicate a context, for example in multiuser,cruid=xxx we need to
re-set these uid/gids to the current user or else we may get a crash.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 27 ++++++++++++++++++++++-----
 fs/cifs/fs_context.h |  1 +
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 92d4ab029c91..39bebe298387 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -322,7 +322,9 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	new_ctx->UNC = NULL;
 	new_ctx->source = NULL;
 	new_ctx->iocharset = NULL;
-
+	new_ctx->linux_uid = current_fsuid();
+	new_ctx->cred_uid = current_fsuid();
+	new_ctx->linux_gid = current_fsgid();
 	/*
 	 * Make sure to stay in sync with smb3_cleanup_fs_context_contents()
 	 */
@@ -792,6 +794,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	kuid_t uid;
+	kgid_t gid;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -904,18 +908,31 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		break;
 	case Opt_uid:
-		ctx->linux_uid.val = result.uint_32;
+		uid = make_kuid(current_user_ns(), result.uint_32);
+		if (!uid_valid(uid))
+			goto cifs_parse_mount_err;
+		ctx->linux_uid = uid;
 		ctx->uid_specified = true;
 		break;
 	case Opt_cruid:
-		ctx->cred_uid.val = result.uint_32;
+		uid = make_kuid(current_user_ns(), result.uint_32);
+		if (!uid_valid(uid))
+			goto cifs_parse_mount_err;
+		ctx->cred_uid = uid;
+		ctx->cruid_specified = true;
 		break;
 	case Opt_backupgid:
-		ctx->backupgid.val = result.uint_32;
+		gid = make_kgid(current_user_ns(), result.uint_32);
+		if (!gid_valid(gid))
+			goto cifs_parse_mount_err;
+		ctx->backupgid = gid;
 		ctx->backupgid_specified = true;
 		break;
 	case Opt_gid:
-		ctx->linux_gid.val = result.uint_32;
+		gid = make_kgid(current_user_ns(), result.uint_32);
+		if (!gid_valid(gid))
+			goto cifs_parse_mount_err;
+		ctx->linux_gid = gid;
 		ctx->gid_specified = true;
 		break;
 	case Opt_port:
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 2a71c8e411ac..b6243972edf3 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -155,6 +155,7 @@ enum cifs_param {
 
 struct smb3_fs_context {
 	bool uid_specified;
+	bool cruid_specified;
 	bool gid_specified;
 	bool sloppy;
 	bool got_ip;
-- 
2.30.2

