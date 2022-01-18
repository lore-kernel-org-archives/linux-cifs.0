Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C87C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 02:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiARCRI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jan 2022 21:17:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236398AbiARCRI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 17 Jan 2022 21:17:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642472227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ok9Tsfw8z5RyOU+c8fJBBTT29ERjo9Lo2JSMK9hXSAo=;
        b=FxK188kyUmMNyC2hzzZbUsEtjHIikYdIgaaMwdtQdStZH3LEp7gG/vz4AeCr0pqYhYouGG
        SRctSEB025X7LN1Git7MTNJ1Jok2mGPn8ae0XSG/w8bdQ8geky7UWCKqHIR3I9N5BiasW2
        p9Kju+LQ29z6j4IDDaBxhrRvYMPFkPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-RbSCAs8uM0yniNLwNgjN7g-1; Mon, 17 Jan 2022 21:17:05 -0500
X-MC-Unique: RbSCAs8uM0yniNLwNgjN7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5B101923B92;
        Tue, 18 Jan 2022 02:17:04 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-105.bne.redhat.com [10.64.54.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53F425DF37;
        Tue, 18 Jan 2022 02:17:04 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: serialize all mount attempts
Date:   Tue, 18 Jan 2022 12:16:57 +1000
Message-Id: <20220118021657.2145245-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 2008434

Some servers, such as Windows2016 have a very low number of concurrent mounts that
they allow from each client.
This can be a problem if you have a more than a handful (==3 in this case)
of cifs entries in your fstab and cause a number of the mounts there to randomly fail.

Add a global mutex and use it to serialize all mount attempts.

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

