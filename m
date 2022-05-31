Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBE7C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 31 May 2022 03:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243652AbiEaDBd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 May 2022 23:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbiEaDB3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 May 2022 23:01:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3104E8D6AC
        for <linux-cifs@vger.kernel.org>; Mon, 30 May 2022 20:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653966087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sZ5fC3XPn3uT6vBKNh51H0mPJ2GlnlcoUGOH3w93omw=;
        b=LYjx8la/M+vWrDFuBuzyzdkTxwhuJGyo5c0OCZvaBw3D9dvAfYqmUyaRMXYohBcVoHqEkz
        b0uzDe8lsJf1TnxJx7Rt1eS2eU1OdT0bUlfEmKrK/2Idyz+53MAgjCHaWUdLfrE8izOrkA
        lHmu0YnWmOAG65IUQQdLecEWeMb3hnQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-1JEjklpZPCuDBz0vMNQD3g-1; Mon, 30 May 2022 23:01:25 -0400
X-MC-Unique: 1JEjklpZPCuDBz0vMNQD3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0EBA3802BAF;
        Tue, 31 May 2022 03:01:24 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-17.bne.redhat.com [10.64.52.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CE192166B26;
        Tue, 31 May 2022 03:01:23 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix potential double free during failed mount
Date:   Tue, 31 May 2022 13:01:17 +1000
Message-Id: <20220531030117.403302-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2088799

Signed-off-by: Roberto Bergantinos <rbergant@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f539a39d47f5..12c872800326 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -838,7 +838,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	      int flags, struct smb3_fs_context *old_ctx)
 {
 	int rc;
-	struct super_block *sb;
+	struct super_block *sb = NULL;
 	struct cifs_sb_info *cifs_sb = NULL;
 	struct cifs_mnt_data mnt_data;
 	struct dentry *root;
@@ -934,9 +934,11 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	return root;
 out:
 	if (cifs_sb) {
-		kfree(cifs_sb->prepath);
-		smb3_cleanup_fs_context(cifs_sb->ctx);
-		kfree(cifs_sb);
+		if (!sb || IS_ERR(sb)) {  /* otherwise kill_sb will handle */
+			kfree(cifs_sb->prepath);
+			smb3_cleanup_fs_context(cifs_sb->ctx);
+			kfree(cifs_sb);
+		}
 	}
 	return root;
 }
-- 
2.35.3

