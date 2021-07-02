Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFF5C11F68
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 17:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB230613F1
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 17:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhGBRUC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Jul 2021 13:20:02 -0400
Received: from mx.cjr.nz ([51.158.111.142]:3086 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhGBRUC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 2 Jul 2021 13:20:02 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9633580288;
        Fri,  2 Jul 2021 17:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1625246249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1imDVVXKBWvrIEmDCputtaAiExtdMK9+/58QrU3+YPE=;
        b=cwrHIDSFCIL6bmon3KkclNRCH7gu4/zNSLGCQ2AE3wQDNSbqDSxoEyofL09sG1zEKCSK6a
        bZphZKVQnG9mX26CgBEqIBpyaPNYctmKko4yOCX2QvOdO1dj1H8N/h+fHVma62lVVak8Qe
        0BdDi5iNYoa1dPd+4bHd09QDmRGyw9ABP/viMebWcnBgdmDl0seY/dhkFPeI98Rfr9Spq2
        v6eRv+aPJz9K1BfgZu5NZ4P1xrWGKi1qe5hxpVSqVe9cRxvK/iwYDXBmAkqNPbctQkI6/d
        kvBLmh/fGsFFNBunVxNAQVKF1BOwLb3UKkbmTNmc+Nvrp07zSfcyMe9CFI9lMA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: include regular shares to the list of unshared tcp servers
Date:   Fri,  2 Jul 2021 14:17:10 -0300
Message-Id: <20210702171710.406-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We need to make regular shares to also not share tcp servers because
we might have both regular and dfs mounts connecting to same server.

Fixes: f3c852b0b0fc ("cifs: do not share tcp servers with dfs mounts")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 944fb92f50c7..d9471575935f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3382,6 +3382,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	char *oldmnt = NULL;
 	bool ref_server = false;
 
+	/*
+	 * Do not share tcp servers when CONFIG_CIFS_DFS_UPCALL option is enabled to properly handle
+	 * reconnect of regular and dfs shares when they were connected to same server.
+	 */
+	ctx->nosharesock = true;
+
 	rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses, &tcon);
 	/*
 	 * If called with 'nodfs' mount option, then skip DFS resolving.  Otherwise unconditionally
@@ -3403,8 +3409,6 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			goto error;
 	}
 
-	ctx->nosharesock = true;
-
 	/* Get path of DFS root */
 	ref_path = build_unc_path_to_root(ctx, cifs_sb, false);
 	if (IS_ERR(ref_path)) {
-- 
2.32.0

