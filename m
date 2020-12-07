Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181D7C433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5AB923998
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgLGXkR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:40:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLGXkR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=qELXV7G+b5XhiS8cyqS9gCiwaxzmXy+3EklF9SWC/d0=;
        b=edMQg/7NJtufqtHEkP/OR/7vtlQSS0IHwnaHKyjv3V66xfznqOPPFvAZV98yR57jLnU0U5
        SB4JdbzLYam3WbHyCloPZV7bZ4E/0+ws8ugAgi6RP8kBRSFM5MdwC+QYWa8laB3rxVQCrw
        Ops+/xYFMBTAGT/2U5niv7ROdqlQ+q8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-OSDfzITVPm6S2DzzmnRkqQ-1; Mon, 07 Dec 2020 18:38:49 -0500
X-MC-Unique: OSDfzITVPm6S2DzzmnRkqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36A3D192D786;
        Mon,  7 Dec 2020 23:38:48 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 453055D6AB;
        Mon,  7 Dec 2020 23:38:46 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 19/21] cifs: remove ctx argument from cifs_setup_cifs_sb
Date:   Tue,  8 Dec 2020 09:36:44 +1000
Message-Id: <20201207233646.29823-19-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index 57c61a2bcf73..e98233a16974 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -802,7 +802,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 		goto out;
 	}
 
-	rc = cifs_setup_cifs_sb(cifs_sb->ctx, cifs_sb);
+	rc = cifs_setup_cifs_sb(cifs_sb);
 	if (rc) {
 		root = ERR_PTR(rc);
 		goto out;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 2b5401e1ce20..8e3db6d7112e 100644
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
index 22b5f3544947..3775f049e3ba 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2658,16 +2658,17 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
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

