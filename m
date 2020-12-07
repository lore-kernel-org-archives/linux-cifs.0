Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC930C433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C594D23A21
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgLGXjT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:39:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727370AbgLGXjT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:39:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=plkJFxlJHSpUXfVNQN0EcVFxOrctZ4/c9klaComvATs=;
        b=K+LolvkFIvzXPcEdp24h6S9wZpd9hccoTPRuXmv+NxOvFmv065Qz9HkYnHRj2eyILyH/qz
        XqNrbOMh1vmpYCCBhc5a14/+609dHSsgfv10SGyfY01LwzRw2u6q89edBFLQeqajlYSG2G
        K1518IhtZjmUA88vKobFlQlzWk0gmtM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-DDzODqSSOUySsF2KlsTluA-1; Mon, 07 Dec 2020 18:37:51 -0500
X-MC-Unique: DDzODqSSOUySsF2KlsTluA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C0A9809DCC;
        Mon,  7 Dec 2020 23:37:50 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 685AF5C1A1;
        Mon,  7 Dec 2020 23:37:49 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 10/21] cifs: remove actimeo from cifs_sb
Date:   Tue,  8 Dec 2020 09:36:35 +1000
Message-Id: <20201207233646.29823-10-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_fs_sb.h | 1 -
 fs/cifs/cifsfs.c     | 2 +-
 fs/cifs/connect.c    | 3 +--
 fs/cifs/inode.c      | 4 ++--
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 3f4f1487f714..69d26313d350 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -65,7 +65,6 @@ struct cifs_sb_info {
 	unsigned int bsize;
 	unsigned int rsize;
 	unsigned int wsize;
-	unsigned long actimeo; /* attribute cache timeout (jiffies) */
 	atomic_t active;
 	unsigned int mnt_cifs_flags;
 	struct delayed_work prune_tlinks;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4ea8c3c3bce1..e432de7c6ca1 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -629,7 +629,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	if (tcon->handle_timeout)
 		seq_printf(s, ",handletimeout=%u", tcon->handle_timeout);
 	/* convert actimeo and display it in seconds */
-	seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
+	seq_printf(s, ",actimeo=%lu", cifs_sb->ctx->actimeo / HZ);
 
 	if (tcon->ses->chan_max > 1)
 		seq_printf(s, ",multichannel,max_channels=%zu",
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 96c5b66d4b44..47e2fe8c19a2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2236,7 +2236,7 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 	if (strcmp(old->local_nls->charset, new->local_nls->charset))
 		return 0;
 
-	if (old->actimeo != new->actimeo)
+	if (old->ctx->actimeo != new->ctx->actimeo)
 		return 0;
 
 	return 1;
@@ -2682,7 +2682,6 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 cifs_sb->ctx->file_mode, cifs_sb->ctx->dir_mode);
 
-	cifs_sb->actimeo = ctx->actimeo;
 	cifs_sb->local_nls = ctx->local_nls;
 
 	if (ctx->nodfs)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index e8a7110db2a6..fb07e0828958 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2165,11 +2165,11 @@ cifs_inode_needs_reval(struct inode *inode)
 	if (!lookupCacheEnabled)
 		return true;
 
-	if (!cifs_sb->actimeo)
+	if (!cifs_sb->ctx->actimeo)
 		return true;
 
 	if (!time_in_range(jiffies, cifs_i->time,
-				cifs_i->time + cifs_sb->actimeo))
+				cifs_i->time + cifs_sb->ctx->actimeo))
 		return true;
 
 	/* hardlinked files w/ noserverino get "special" treatment */
-- 
2.13.6

