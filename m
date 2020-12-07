Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA09C4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5CD623A21
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgLGXir (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:38:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgLGXir (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:38:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=aInGiwVW1lp8PiFrKrKtEJIDZSj21FubGo0dGlxCqPQ=;
        b=f4SHFUv7e+HneMa6kmpHwBD8NTgN8dhkRfF7SJpWu/tHvXz+vZX0mi4Z25O4gVKyg6ABKj
        BM+jYvv3TmF/OHfi6P/SzQcG5trobHJwqutQN5Hac64WRVcY2xhHuIUilmFIp7JPOGHHDd
        51G6HbmPc96iTTJ1BMUuRBCRyeXaz7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-z9vebvKuOpqMflh6Ul12mw-1; Mon, 07 Dec 2020 18:37:18 -0500
X-MC-Unique: z9vebvKuOpqMflh6Ul12mw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C506310054FF;
        Mon,  7 Dec 2020 23:37:17 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D308319C59;
        Mon,  7 Dec 2020 23:37:16 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 14/21] cifs: we do not allow changing username/password/unc/... during remount
Date:   Tue,  8 Dec 2020 09:36:39 +1000
Message-Id: <20201207233646.29823-14-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c     |  2 +-
 fs/cifs/fs_context.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/fs_context.h |  2 +-
 3 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 80117e9d35f9..13d7f4a3c836 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -490,7 +490,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 
 	if (tcon->no_lease)
 		seq_puts(s, ",nolease");
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
+	if (cifs_sb->ctx->multiuser)
 		seq_puts(s, ",multiuser");
 	else if (tcon->ses->user_name)
 		seq_show_option(s, "username", tcon->ses->user_name);
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index edfdea129fcc..542fa75b74aa 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -629,10 +629,53 @@ static int smb3_verify_reconfigure_ctx(struct smb3_fs_context *new_ctx,
 		cifs_dbg(VFS, "can not change sec during remount\n");
 		return -EINVAL;
 	}
+	if (new_ctx->multiuser != old_ctx->multiuser) {
+		cifs_dbg(VFS, "can not change multiuser during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->UNC &&
+	    (!old_ctx->UNC || strcmp(new_ctx->UNC, old_ctx->UNC))) {
+		cifs_dbg(VFS, "can not change UNC during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->username &&
+	    (!old_ctx->username || strcmp(new_ctx->username, old_ctx->username))) {
+		cifs_dbg(VFS, "can not change username during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->password &&
+	    (!old_ctx->password || strcmp(new_ctx->password, old_ctx->password))) {
+		cifs_dbg(VFS, "can not change password during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->domainname &&
+	    (!old_ctx->domainname || strcmp(new_ctx->domainname, old_ctx->domainname))) {
+		cifs_dbg(VFS, "can not change domainname during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->nodename &&
+	    (!old_ctx->nodename || strcmp(new_ctx->nodename, old_ctx->nodename))) {
+		cifs_dbg(VFS, "can not change nodename during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->iocharset &&
+	    (!old_ctx->iocharset || strcmp(new_ctx->iocharset, old_ctx->iocharset))) {
+		cifs_dbg(VFS, "can not change iocharset during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
 
+#define STEAL_STRING(cifs_sb, ctx, field)				\
+do {									\
+	if (ctx->field) {						\
+		kfree(ctx->field);					\
+		ctx->field = cifs_sb->ctx->field;			\
+		cifs_sb->ctx->field = NULL;				\
+	}								\
+} while (0)
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -645,10 +688,16 @@ static int smb3_reconfigure(struct fs_context *fc)
 		return rc;
 
 	/*
-	 * Steal the UNC from the old and to be destroyed context.
+	 * We can not change UNC/username/password/domainname/nodename/iocharset
+	 * during reconnect so ignore what we have in the new context and
+	 * just use what we already have in cifs_sb->ctx.
 	 */
-	ctx->UNC = cifs_sb->ctx->UNC;
-	cifs_sb->ctx->UNC = NULL;
+	STEAL_STRING(cifs_sb, ctx, UNC);
+	STEAL_STRING(cifs_sb, ctx, username);
+	STEAL_STRING(cifs_sb, ctx, password);
+	STEAL_STRING(cifs_sb, ctx, domainname);
+	STEAL_STRING(cifs_sb, ctx, nodename);
+	STEAL_STRING(cifs_sb, ctx, iocharset);
 
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index aa1d952fd5ce..62f5a8d98df6 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -148,7 +148,6 @@ struct smb3_fs_context {
 	bool uid_specified;
 	bool gid_specified;
 	bool sloppy;
-	char *nodename;
 	bool got_ip;
 	bool got_version;
 	bool got_rsize;
@@ -160,6 +159,7 @@ struct smb3_fs_context {
 	char *password;
 	char *domainname;
 	char *UNC;
+	char *nodename;
 	char *iocharset;  /* local code page for mapping to and from Unicode */
 	char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
 	char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
-- 
2.13.6

