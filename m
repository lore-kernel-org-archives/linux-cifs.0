Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1530C4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Dec 2022 10:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiLVKsS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Dec 2022 05:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbiLVKsR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Dec 2022 05:48:17 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0208E25EB7
        for <linux-cifs@vger.kernel.org>; Thu, 22 Dec 2022 02:48:16 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id y16so1233351wrm.2
        for <linux-cifs@vger.kernel.org>; Thu, 22 Dec 2022 02:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9bVt/QDTeT3eLxZxhkn7PsFUBEZi6VhoNSxlR8G3p5Q=;
        b=2pN6X+NIjT/yBbE7uYF0O6CE5sDW+1BnZAAmNtwvnkPgbAoheiTntcS1urqYadzaNR
         5n6dlXsNzQ5zo2yAlPg83tJ6iNAfCTiPvdEhPDbHd3vRqVDLwnBR+dEwJ0f88yCwbgzE
         NYt5xSmD3I0Bm0r6PYtcFw6c6JJxQR6v+OW0v0lk137H56wNeLo24bmKVsFbB/Zq4oAT
         w8OdCZdY09xMnBKkgP4Xz7dzu/NpZiLZzCMc2GLHyL3AECu7uqmi/TPB+/+xT7A0Zu+5
         dixXFHeMwsqINUwQin3tOJo9fWXfR0jvXSmD4roIbWO6FpBZrL6E2t4iGB/kh9mImj6d
         cCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9bVt/QDTeT3eLxZxhkn7PsFUBEZi6VhoNSxlR8G3p5Q=;
        b=seum/Fqb1/D5wNyfh4tgQLPxmz54XV8w45PT91t5XpjPKIrYvQu/HeE/CcR/N8BJG0
         FRSowG7xuWm9zK2XQLorlqsPAMRBUBHTafLKr5rdVGKrmK2pT1IfnYbG/I13T7fag2Tu
         rCvEXR0+iFaKJNKuZvO3QkYwYL+dWZFbpfkf7AqwK21O5KR9RMwmmrqcxIaDdwW6aXzr
         pyJ8N7givebeSX90uV7blPo+n3ajgia44ZcFQNz9w/DJxuaq8Xi0RGTT4ZOL+vA+twUb
         W3x2lPQ7LT4HyEB+umQ1GNhghBhlDDDp3n0tyv1snbVRx+VXgdRwnHdMFWZ7Zo99dbe8
         RArg==
X-Gm-Message-State: AFqh2krCVExT2k4zlQiRqIIbI9kPfh+zR/UqJ+tdU64ezVKLP7aSXOLG
        yWk3dqgPGx3V1+aBfYCMnnqApyqE104t98PY
X-Google-Smtp-Source: AMrXdXuPvFiymDj6gWejzviVT++fVxOh8y46cMtAHo//D4RrDk6PSi/vrY0ME0rzyvW921oVQACGwg==
X-Received: by 2002:adf:ef89:0:b0:26f:63ec:eb78 with SMTP id d9-20020adfef89000000b0026f63eceb78mr1423792wro.23.1671706094381;
        Thu, 22 Dec 2022 02:48:14 -0800 (PST)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id o6-20020adfa106000000b002423620d356sm207846wro.35.2022.12.22.02.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 02:48:14 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: send proper error response in smb2_tree_connect()
Date:   Thu, 22 Dec 2022 11:47:02 +0100
Message-Id: <20221222104701.717586-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently, smb2_tree_connect doesn't send an error response packet on
error.

This causes libsmb2 to skip the specific error code and fail with the
following:
 smb2_service failed with : Failed to parse fixed part of command
 payload. Unexpected size of Error reply. Expected 9, got 8

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/ksmbd/smb2pdu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 14d7f3599c63..bd2ff9ffa965 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1882,12 +1882,14 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (IS_ERR(treename)) {
 		pr_err("treename is NULL\n");
 		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
+		smb2_set_err_rsp(work);
 		goto out_err1;
 	}
 
 	name = ksmbd_extract_sharename(conn->um, treename);
 	if (IS_ERR(name)) {
 		status.ret = KSMBD_TREE_CONN_STATUS_ERROR;
+		smb2_set_err_rsp(work);
 		goto out_err1;
 	}
 
@@ -1895,10 +1897,12 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		    name, treename);
 
 	status = ksmbd_tree_conn_connect(conn, sess, name);
-	if (status.ret == KSMBD_TREE_CONN_STATUS_OK)
+	if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
 		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
-	else
+	} else {
+		smb2_set_err_rsp(work);
 		goto out_err1;
+	}
 
 	share = status.tree_conn->share_conf;
 	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
@@ -1928,13 +1932,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	if (conn->posix_ext_supported)
 		status.tree_conn->posix_extensions = true;
 
-out_err1:
 	rsp->StructureSize = cpu_to_le16(16);
+	inc_rfc1001_len(work->response_buf, 16);
+out_err1:
 	rsp->Capabilities = 0;
 	rsp->Reserved = 0;
 	/* default manual caching */
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
-	inc_rfc1001_len(work->response_buf, 16);
 
 	if (!IS_ERR(treename))
 		kfree(treename);
-- 
2.25.1

