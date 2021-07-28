Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE19C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jul 2021 06:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F0460C41
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jul 2021 06:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhG1Gil (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jul 2021 02:38:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231484AbhG1Gik (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 28 Jul 2021 02:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627454318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1r+djktkYu+P8ua4Y/PJ8oIzTtj6bD8/onVR6BibYB8=;
        b=JwYKPXTvBpCkilX3vvgVuyK7WEPPsjmwJsSqrxHOcP7+Rp7IZolNaLnp2+zpGIElq64n7t
        HquOblSK7A0TVhtRFtm1CUKadnTHcxSC4H8vsHgpobVwETJ0j7GLNT0lkYs1CsDwagN/gF
        6oda3EgIa9yX3M2N1PaUA6QA/f95owI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-FkJMOH9wPVWmqUnbHsc6OA-1; Wed, 28 Jul 2021 02:38:37 -0400
X-MC-Unique: FkJMOH9wPVWmqUnbHsc6OA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BFAB1853030;
        Wed, 28 Jul 2021 06:38:36 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-204.bne.redhat.com [10.64.54.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C331C17B58;
        Wed, 28 Jul 2021 06:38:35 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: add missing parsing of backupuid
Date:   Wed, 28 Jul 2021 16:38:29 +1000
Message-Id: <20210728063829.15099-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We lost parsing of backupuid in the switch to new mount API.
Add it back.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 9a59d7ff9a11..eed59bc1d913 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -925,6 +925,13 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->cred_uid = uid;
 		ctx->cruid_specified = true;
 		break;
+	case Opt_backupuid:
+		uid = make_kuid(current_user_ns(), result.uint_32);
+		if (!uid_valid(uid))
+			goto cifs_parse_mount_err;
+		ctx->backupuid = uid;
+		ctx->backupuid_specified = true;
+		break;
 	case Opt_backupgid:
 		gid = make_kgid(current_user_ns(), result.uint_32);
 		if (!gid_valid(gid))
-- 
2.30.2

