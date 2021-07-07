Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC28C07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 23:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4776D61CBB
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 23:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhGGX1L (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 19:27:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230029AbhGGX1K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 19:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625700269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5DuKYHAHgeJzMmeFtOGLn5DxzT7ywUUyrGCzOQ1b1GA=;
        b=IR/UKiF0ZtJsyXxZgZBwYGIY6W6q5U4oc8ZSlVkNBX+v0JOCyZMxShep0ch7iAB/n1N30D
        v3gw6dfWjAgG9dMfC2T0yyhHrdvAJrbdOHiVphbw/YjghB4XpO+K2rjntV5BNrMvEDrs0x
        r543Qc9/pMppkwO4FLy+rYDej9PdoBM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-_b_ijXvtNny_yXMZpiV7og-1; Wed, 07 Jul 2021 19:24:28 -0400
X-MC-Unique: _b_ijXvtNny_yXMZpiV7og-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20151800C78;
        Wed,  7 Jul 2021 23:24:27 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-39.bne.redhat.com [10.64.54.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 780E45D6A8;
        Wed,  7 Jul 2021 23:24:26 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: use helpers when parsing uid/gid mount options and validate them
Date:   Thu,  8 Jul 2021 09:24:16 +1000
Message-Id: <20210707232416.2694911-2-lsahlber@redhat.com>
In-Reply-To: <20210707232416.2694911-1-lsahlber@redhat.com>
References: <20210707232416.2694911-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use the nice helpers to initialize and the uid/gid/cred_uid when passed as mount arguments.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 24 +++++++++++++++++++-----
 fs/cifs/fs_context.h |  1 +
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 92d4ab029c91..553adfbcc22a 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -322,7 +322,6 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	new_ctx->UNC = NULL;
 	new_ctx->source = NULL;
 	new_ctx->iocharset = NULL;
-
 	/*
 	 * Make sure to stay in sync with smb3_cleanup_fs_context_contents()
 	 */
@@ -792,6 +791,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	kuid_t uid;
+	kgid_t gid;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -904,18 +905,31 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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

