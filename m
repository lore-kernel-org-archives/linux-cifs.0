Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E189C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 07:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbiARHp0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jan 2022 02:45:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbiARHpZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 18 Jan 2022 02:45:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642491925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vZ8/J7pU/trjuWr5BnhLzlq4lcSec3iaw4t8ycXw8Ok=;
        b=IMleN+zCrdPTBxhKy8daKUVG/8ASq5xlS0xakx8hASNTSbCef4a+WJhxxExgthOrP+XGGF
        Fe0+C9g0DOPS4DHD6D5sdKPbMcoL1QLrZiFsq5dvF1v86nPf7brOlzo+sxPJRlsGh8QXuH
        qve1Pwmthcb2KEzl+NkUdPW+0MHeczg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-oDR_3RygM3mwbJs1Px6bRQ-1; Tue, 18 Jan 2022 02:45:21 -0500
X-MC-Unique: oDR_3RygM3mwbJs1Px6bRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6950E8143E5;
        Tue, 18 Jan 2022 07:45:20 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-105.bne.redhat.com [10.64.54.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC33B795A0;
        Tue, 18 Jan 2022 07:45:19 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: serialize all mount attempts
Date:   Tue, 18 Jan 2022 17:45:12 +1000
Message-Id: <20220118074512.2153136-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 2008434

If we try to perform multiple concurrent mounts ot the same server we might
end up in a situation where:
Thread #1                          Thread #2
    creates TCP connection
    Issues NegotiateProtocol
    ...                            Pick the TCP connection for Thread #1
                                   Issue a new NegotiateProtocol

which then leads to the the server kills off the session.
There are also other a similar race where several threads ending up
withe their own unique tcp connection that all go to the same server structure ....

The most straightforward way to fix these races with concurrent mounts are to serialize
them. I.e. only allow one mount to be in progress at a time.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index e3ed25dc6f3f..7ec35f3f0a5f 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -37,6 +37,8 @@
 #include "rfc1002pdu.h"
 #include "fs_context.h"
 
+static DEFINE_MUTEX(cifs_mount_mutex);
+
 static const match_table_t cifs_smb_version_tokens = {
 	{ Smb_1, SMB1_VERSION_STRING },
 	{ Smb_20, SMB20_VERSION_STRING},
@@ -707,10 +709,14 @@ static int smb3_get_tree_common(struct fs_context *fc)
 static int smb3_get_tree(struct fs_context *fc)
 {
 	int err = smb3_fs_context_validate(fc);
+	int ret;
 
 	if (err)
 		return err;
-	return smb3_get_tree_common(fc);
+	mutex_lock(&cifs_mount_mutex);
+	ret = smb3_get_tree_common(fc);
+	mutex_unlock(&cifs_mount_mutex);
+	return ret;
 }
 
 static void smb3_fs_context_free(struct fs_context *fc)
-- 
2.30.2

