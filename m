Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C180CC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9484823A21
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgLGXjD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:39:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgLGXjD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:39:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=52pUvsZGPh9hINSmyQlRL6ZKHbLvX3R+daXa5jmtDdA=;
        b=cK3pyHhFweP8styx1ESd5UXJRBpUBwyDc3R2DJ/0xNuNjCOMzz522RQThjDDAzPhmt4uTY
        iZnp3kAF5RtGzbQbN7xVZ7Xwl3JNgBkQRtuc0QxtQmtcpkbeyWA0xqHiEJMuka8CPJr2Kw
        IyGuYvL0mBm9pn91UyhU3Vs/qXJKqAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-CkmRQjElMrigdCz_DTcfQg-1; Mon, 07 Dec 2020 18:37:35 -0500
X-MC-Unique: CkmRQjElMrigdCz_DTcfQg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 473F95236;
        Mon,  7 Dec 2020 23:37:34 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55A22620DE;
        Mon,  7 Dec 2020 23:37:33 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 04/21] cifs: move cifs_parse_devname to fs_context.c
Date:   Tue,  8 Dec 2020 09:36:29 +1000
Message-Id: <20201207233646.29823-4-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsproto.h  |  1 +
 fs/cifs/connect.c    | 59 ++--------------------------------------------------
 fs/cifs/fs_context.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 57 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 13ce85af1204..aa66a6b9aaf5 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -89,6 +89,7 @@ extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
+extern int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
 extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
 extern int cifs_call_async(struct TCP_Server_Info *server,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 17e9e95d54e5..c447ace656ed 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1256,61 +1256,6 @@ static int get_option_gid(substring_t args[], kgid_t *result)
 	return 0;
 }
 
-/*
- * Parse a devname into substrings and populate the vol->UNC and vol->prepath
- * fields with the result. Returns 0 on success and an error otherwise.
- */
-static int
-cifs_parse_devname(const char *devname, struct smb3_fs_context *ctx)
-{
-	char *pos;
-	const char *delims = "/\\";
-	size_t len;
-
-	if (unlikely(!devname || !*devname)) {
-		cifs_dbg(VFS, "Device name not specified\n");
-		return -EINVAL;
-	}
-
-	/* make sure we have a valid UNC double delimiter prefix */
-	len = strspn(devname, delims);
-	if (len != 2)
-		return -EINVAL;
-
-	/* find delimiter between host and sharename */
-	pos = strpbrk(devname + 2, delims);
-	if (!pos)
-		return -EINVAL;
-
-	/* skip past delimiter */
-	++pos;
-
-	/* now go until next delimiter or end of string */
-	len = strcspn(pos, delims);
-
-	/* move "pos" up to delimiter or NULL */
-	pos += len;
-	ctx->UNC = kstrndup(devname, pos - devname, GFP_KERNEL);
-	if (!ctx->UNC)
-		return -ENOMEM;
-
-	convert_delimiter(ctx->UNC, '\\');
-
-	/* skip any delimiter */
-	if (*pos == '/' || *pos == '\\')
-		pos++;
-
-	/* If pos is NULL then no prepath */
-	if (!*pos)
-		return 0;
-
-	ctx->prepath = kstrdup(pos, GFP_KERNEL);
-	if (!ctx->prepath)
-		return -ENOMEM;
-
-	return 0;
-}
-
 static int
 cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 struct smb3_fs_context *ctx, bool is_smb3)
@@ -1414,7 +1359,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
-	switch (cifs_parse_devname(devname, ctx)) {
+	switch (smb3_parse_devname(devname, ctx)) {
 	case 0:
 		break;
 	case -ENOMEM:
@@ -4534,7 +4479,7 @@ static int check_dfs_prepath(struct cifs_sb_info *cifs_sb, struct smb3_fs_contex
 			struct smb3_fs_context v = {NULL};
 			/* if @path contains a tree name, skip it in the prefix path */
 			if (added_treename) {
-				rc = cifs_parse_devname(path, &v);
+				rc = smb3_parse_devname(path, &v);
 				if (rc)
 					break;
 				rc = -EREMOTE;
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 301201903b45..3b15f9a882b2 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -260,3 +260,59 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 
 	return rc;
 }
+
+/*
+ * Parse a devname into substrings and populate the ctx->UNC and ctx->prepath
+ * fields with the result. Returns 0 on success and an error otherwise.
+ */
+int
+smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
+{
+	char *pos;
+	const char *delims = "/\\";
+	size_t len;
+
+	if (unlikely(!devname || !*devname)) {
+		cifs_dbg(VFS, "Device name not specified\n");
+		return -EINVAL;
+	}
+
+	/* make sure we have a valid UNC double delimiter prefix */
+	len = strspn(devname, delims);
+	if (len != 2)
+		return -EINVAL;
+
+	/* find delimiter between host and sharename */
+	pos = strpbrk(devname + 2, delims);
+	if (!pos)
+		return -EINVAL;
+
+	/* skip past delimiter */
+	++pos;
+
+	/* now go until next delimiter or end of string */
+	len = strcspn(pos, delims);
+
+	/* move "pos" up to delimiter or NULL */
+	pos += len;
+	ctx->UNC = kstrndup(devname, pos - devname, GFP_KERNEL);
+	if (!ctx->UNC)
+		return -ENOMEM;
+
+	convert_delimiter(ctx->UNC, '\\');
+
+	/* skip any delimiter */
+	if (*pos == '/' || *pos == '\\')
+		pos++;
+
+	/* If pos is NULL then no prepath */
+	if (!*pos)
+		return 0;
+
+	ctx->prepath = kstrdup(pos, GFP_KERNEL);
+	if (!ctx->prepath)
+		return -ENOMEM;
+
+	return 0;
+}
+
-- 
2.13.6

