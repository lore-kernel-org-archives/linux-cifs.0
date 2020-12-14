Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C974C4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7C7522583
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438796AbgLNGme (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:42:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45409 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438787AbgLNGme (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 01:42:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607928068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=ch/jhKjSqYX7AO2lNuKAFGOqKMWHiYGbkt6KpTwgo8w=;
        b=dknaR4YSn0N50Oj3nkLodrEGVB/T8AEMC2SqY+Os17tVXVNQRMsujUj0zWKRFtuUU8zGF4
        13mNvBogGuzhToxshf9E2ISTQYtFjrTMThNGdMRtg0adHQAXnEmFoq5RlxcUEVqGpZaeG1
        IJafjh+2C3bvS8JhDVIMfIXUZfWbwME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-uMzRInynPd-TcBc0tWn55Q-1; Mon, 14 Dec 2020 01:41:04 -0500
X-MC-Unique: uMzRInynPd-TcBc0tWn55Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB667A0CA0;
        Mon, 14 Dec 2020 06:41:03 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9E9A28557;
        Mon, 14 Dec 2020 06:41:02 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 09/12] cifs: remove ctx argument from cifs_setup_cifs_sb
Date:   Mon, 14 Dec 2020 16:40:24 +1000
Message-Id: <20201214064027.2885-9-lsahlber@redhat.com>
In-Reply-To: <20201214064027.2885-1-lsahlber@redhat.com>
References: <20201214064027.2885-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c    | 2 +-
 fs/cifs/cifsproto.h | 3 +--
 fs/cifs/connect.c   | 7 ++++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 229e5cbcaf18..4c385eeecc05 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -810,7 +810,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 		goto out;
 	}
 
-	rc = cifs_setup_cifs_sb(cifs_sb->ctx, cifs_sb);
+	rc = cifs_setup_cifs_sb(cifs_sb);
 	if (rc) {
 		root = ERR_PTR(rc);
 		goto out;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 313d252bbbe9..bd1c9b038568 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -234,8 +234,7 @@ extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
 					struct page *page,
 					unsigned int page_offset,
 					unsigned int to_read);
-extern int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
-			       struct cifs_sb_info *cifs_sb);
+extern int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb);
 extern int cifs_match_super(struct super_block *, void *);
 extern int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx);
 extern void cifs_umount(struct cifs_sb_info *);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 926a8b310366..606f36322c60 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2687,16 +2687,17 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 	}
 }
 
-int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
-			struct cifs_sb_info *cifs_sb)
+int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 {
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+
 	INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tlinks);
 
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
 
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
-		 cifs_sb->ctx->file_mode, cifs_sb->ctx->dir_mode);
+		 ctx->file_mode, ctx->dir_mode);
 
 	/* this is needed for ASCII cp to Unicode converts */
 	if (ctx->iocharset == NULL) {
-- 
2.13.6

