Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF89C433E1
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 18:39:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 587CC207D3
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 18:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="1v5FA+Jw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgESSjF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 14:39:05 -0400
Received: from mx.cjr.nz ([51.158.111.142]:15748 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgESSjE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 May 2020 14:39:04 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 73ABC80347;
        Tue, 19 May 2020 18:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1589913543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gY+iuCXUStjd0XLz/p3Ge4UFi1K9YF4diNlIyRPXBiQ=;
        b=1v5FA+JweS/5VZbOytab152yhZgtiMVhMr476dRMyHg/RDR2Ldhx5xSjqStLS2Y4mDFC2M
        66TyAWEaSyAcKhomEqcCMfN47Gy6ROuRYGkDoLqmvBiUBhMz0axbfI9vYxOSsSrrapiWeE
        o1s2ItdxwrlV6np3ZA0RFXpbnojh/Z7U/S4e5E9SXQc31SRV37g2dfmU6EXP5KTl3WsXm6
        Pw7t+EHYEfr/j5qC14KeeqcP++GmlzE6G8BqRBiI56i4ndEpqoMNJzTtp/BscX9RdKrPQp
        VtwkxMArp+IofzGhJjR89W9ZGWc+LSXawHhjZ1I8M3COk7hkYJMnMreUd6dYRw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 3/3] cifs: get rid of unused parameter in reconn_setup_dfs_targets()
Date:   Tue, 19 May 2020 15:38:29 -0300
Message-Id: <20200519183829.5512-3-pc@cjr.nz>
In-Reply-To: <20200519183829.5512-1-pc@cjr.nz>
References: <20200519183829.5512-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The target iterator parameter "it" is not used in
reconn_setup_dfs_targets(), so just remove it.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 094c939cb98e..3373c4a72cf4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -426,8 +426,7 @@ static void reconn_inval_dfs_target(struct TCP_Server_Info *server,
 }
 
 static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
-					   struct dfs_cache_tgt_list *tl,
-					   struct dfs_cache_tgt_iterator **it)
+					   struct dfs_cache_tgt_list *tl)
 {
 	if (!cifs_sb->origin_fullpath)
 		return -EOPNOTSUPP;
@@ -472,7 +471,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	} else {
 		cifs_sb = CIFS_SB(sb);
 
-		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list, &tgt_it);
+		rc = reconn_setup_dfs_targets(cifs_sb, &tgt_list);
 		if (rc && (rc != -EOPNOTSUPP)) {
 			cifs_server_dbg(VFS, "%s: no target servers for DFS failover\n",
 				 __func__);
-- 
2.26.2

