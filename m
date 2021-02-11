Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3186AC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 06:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0798B64E3C
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 06:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhBKGH4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Feb 2021 01:07:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhBKGH4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Feb 2021 01:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613023587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=asbVJogg9+5ydnhkzvggexuJvEs5fx1Amr0p8eSV1Ss=;
        b=VEVX4UwXrR9RdLBg7T1qDNWErKNyAKJz0jBErdPuX6+7RMZoXdivA6bEgKLP0qfeKm2ONk
        sdS7JdwVG3BKVdBlcAoP8j7nPPxJj1pNu6GUBeXIOHbparB3Ly+OhUL3yNSlsyqqcVGuFX
        SygV8nEkBFoKzThY23h/EJ/QwTVMzgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-ZvfKduqYNji9_7SCKoSbTQ-1; Thu, 11 Feb 2021 01:06:24 -0500
X-MC-Unique: ZvfKduqYNji9_7SCKoSbTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6317801962;
        Thu, 11 Feb 2021 06:06:23 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C9E75C1BD;
        Thu, 11 Feb 2021 06:06:22 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: In the new mount api we get the full devname as source=
Date:   Thu, 11 Feb 2021 16:06:16 +1000
Message-Id: <20210211060616.21672-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

so we no longer need to handle or parse the UNC= and prefixpath=
options that mount.cifs are generating.

This also fixes a bug in the mount command option where the devname
would be truncated into just //server/share because we were looking
at the truncated UNC value and not the full path.

I.e.  in the mount command output the devive //server/share/path
would show up as just //server/share

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c     |  2 +-
 fs/cifs/fs_context.c | 16 +++++++++++++++-
 fs/cifs/fs_context.h |  1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e46da536ed33..ab883e84e116 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -469,7 +469,7 @@ cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
 static int cifs_show_devname(struct seq_file *m, struct dentry *root)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
-	char *devname = kstrdup(cifs_sb->ctx->UNC, GFP_KERNEL);
+	char *devname = kstrdup(cifs_sb->ctx->source, GFP_KERNEL);
 
 	if (devname == NULL)
 		seq_puts(m, "none");
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 1b1c56e52395..12a5da0230b5 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -148,7 +148,6 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 
 	/* Mount options which take string value */
 	fsparam_string("source", Opt_source),
-	fsparam_string("unc", Opt_source),
 	fsparam_string("user", Opt_user),
 	fsparam_string("username", Opt_user),
 	fsparam_string("pass", Opt_pass),
@@ -178,6 +177,11 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag_no("auto", Opt_ignore),
 	fsparam_string("cred", Opt_ignore),
 	fsparam_string("credentials", Opt_ignore),
+	/*
+	 * UNC and prefixpath is now extracted from Opt_source
+	 * in the new mount API so we can just ignore them going forward.
+	 */
+	fsparam_string("unc", Opt_ignore),
 	fsparam_string("prefixpath", Opt_ignore),
 	{}
 };
@@ -313,6 +317,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	new_ctx->password = NULL;
 	new_ctx->domainname = NULL;
 	new_ctx->UNC = NULL;
+	new_ctx->source = NULL;
 	new_ctx->iocharset = NULL;
 
 	/*
@@ -323,6 +328,7 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	DUP_CTX_STR(username);
 	DUP_CTX_STR(password);
 	DUP_CTX_STR(UNC);
+	DUP_CTX_STR(source);
 	DUP_CTX_STR(domainname);
 	DUP_CTX_STR(nodename);
 	DUP_CTX_STR(iocharset);
@@ -732,6 +738,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	 * just use what we already have in cifs_sb->ctx.
 	 */
 	STEAL_STRING(cifs_sb, ctx, UNC);
+	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
 	STEAL_STRING(cifs_sb, ctx, password);
 	STEAL_STRING(cifs_sb, ctx, domainname);
@@ -974,6 +981,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			cifs_dbg(VFS, "Unknown error parsing devname\n");
 			goto cifs_parse_mount_err;
 		}
+		ctx->source = kstrdup(param->string, GFP_KERNEL);
+		if (ctx->source == NULL) {
+			cifs_dbg(VFS, "OOM when copying UNC string\n");
+			goto cifs_parse_mount_err;
+		}
 		fc->source = kstrdup(param->string, GFP_KERNEL);
 		if (fc->source == NULL) {
 			cifs_dbg(VFS, "OOM when copying UNC string\n");
@@ -1396,6 +1408,8 @@ smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx)
 	ctx->password = NULL;
 	kfree(ctx->UNC);
 	ctx->UNC = NULL;
+	kfree(ctx->source);
+	ctx->source = NULL;
 	kfree(ctx->domainname);
 	ctx->domainname = NULL;
 	kfree(ctx->nodename);
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 3358b33abcd0..1c44a460e2c0 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -159,6 +159,7 @@ struct smb3_fs_context {
 	char *username;
 	char *password;
 	char *domainname;
+	char *source;
 	char *UNC;
 	char *nodename;
 	char *iocharset;  /* local code page for mapping to and from Unicode */
-- 
2.13.6

