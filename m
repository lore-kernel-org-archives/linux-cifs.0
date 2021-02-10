Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084D0C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 01:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA7F264E74
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 01:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhBJB6D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 20:58:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235145AbhBJB53 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 20:57:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612922160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=1A5fOkY6g3TMqmwFnBV/fhpaWeXQbx5NqpEVSOscNUw=;
        b=Zoner/jp/3Wa8cnLvBFsWalmPXUikdYXkYu5v1/zhCypEK9iGL4KGRD7rHDRmRHDEWwE7t
        7cVrv8tKoecOapvlWP/pJkvURrHWxgFA/S0iBdiiIZsis/IB1xPET7RtabBZAUeH23pmA8
        zj5G2ZLnh1hJVuv3oHe/mA8DeGj/OmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-Az2cKEsPMXWl7xL_t3PpEw-1; Tue, 09 Feb 2021 20:55:56 -0500
X-MC-Unique: Az2cKEsPMXWl7xL_t3PpEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BE4980196E;
        Wed, 10 Feb 2021 01:55:55 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B41C5100164C;
        Wed, 10 Feb 2021 01:55:54 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: do not disable noperm if multiuser mount option is not provided
Date:   Wed, 10 Feb 2021 11:55:47 +1000
Message-Id: <20210210015547.30833-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 5111aadfdb6b..1b1c56e52395 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1533,8 +1533,8 @@ void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
 		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
 					    CIFS_MOUNT_NO_PERM);
 	else
-		cifs_sb->mnt_cifs_flags &= ~(CIFS_MOUNT_MULTIUSER |
-					     CIFS_MOUNT_NO_PERM);
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MULTIUSER;
+
 
 	if (ctx->strict_io)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
-- 
2.13.6

