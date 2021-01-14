Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB4F8C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 09:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5317A23A01
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 09:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbhANJKS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Jan 2021 04:10:18 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:16744 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbhANJKS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Jan 2021 04:10:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ULhBOL9_1610615362;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULhBOL9_1610615362)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Jan 2021 17:09:26 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] fs/cifs: Assign boolean values to a bool variable
Date:   Thu, 14 Jan 2021 17:09:20 +0800
Message-Id: <1610615360-70523-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix the following coccicheck warnings:

./fs/cifs/connect.c:3386:2-21: WARNING: Assignment of 0/1 to
bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b9df855..8fbb5ea 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2195,7 +2195,7 @@ static int match_tcon(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	if (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
 		tcon->nohandlecache = ctx->nohandlecache;
 	else
-		tcon->nohandlecache = 1;
+		tcon->nohandlecache = true;
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
-- 
1.8.3.1

