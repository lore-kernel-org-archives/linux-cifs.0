Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6E6C4361B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 22:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 403F122D02
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 22:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgLOWxM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:53:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbgLOWxJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 15 Dec 2020 17:53:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608072703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=n3lK3MqnxJ7bqv7SA7DHmTIIn4oXtIvKhIk8M4vgWNM=;
        b=DZtRZUm/NK+lSy/eSpCh972ZJYj0qPEev18LMMypO/2Z0COTGbm5pYXjRNhv2psJ/JIgbM
        Oq1sTbNCUCAeJxBoZsFmC2B4YzoOvuQ4QOStvSNHpoSaVip9NiIRh5SOdY1BFTHB0nM0FO
        OODcran0niWpgjhZG0kmCPpk+QAKDyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-kNIRbHTnPTC6-GLd6FXCEA-1; Tue, 15 Dec 2020 17:51:41 -0500
X-MC-Unique: kNIRbHTnPTC6-GLd6FXCEA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42E09107ACE3;
        Tue, 15 Dec 2020 22:51:40 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEDBF60854;
        Tue, 15 Dec 2020 22:51:39 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix use after free in cifs_smb3_do_mount()
Date:   Wed, 16 Dec 2020 08:51:33 +1000
Message-Id: <20201215225133.20378-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4c385eeecc05..2c6e54fa6429 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -836,12 +836,14 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	if (IS_ERR(sb)) {
 		root = ERR_CAST(sb);
 		cifs_umount(cifs_sb);
+		cifs_sb = NULL;
 		goto out;
 	}
 
 	if (sb->s_root) {
 		cifs_dbg(FYI, "Use existing superblock\n");
 		cifs_umount(cifs_sb);
+		cifs_sb = NULL;
 	} else {
 		rc = cifs_read_super(sb);
 		if (rc) {
@@ -852,7 +854,7 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 		sb->s_flags |= SB_ACTIVE;
 	}
 
-	root = cifs_get_root(cifs_sb->ctx, sb);
+	root = cifs_get_root(cifs_sb ? cifs_sb->ctx : old_ctx, sb);
 	if (IS_ERR(root))
 		goto out_super;
 
-- 
2.13.6

