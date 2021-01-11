Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4C2C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Jan 2021 09:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC5752063A
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Jan 2021 09:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbhAKJQ3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Jan 2021 04:16:29 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58453 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727690AbhAKJQ3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 11 Jan 2021 04:16:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ULMRaiY_1610356529;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULMRaiY_1610356529)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Jan 2021 17:15:36 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] cifs: connect: style: Simplify bool comparison
Date:   Mon, 11 Jan 2021 17:15:28 +0800
Message-Id: <1610356528-48800-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix the following coccicheck warning:
./fs/cifs/connect.c:3740:6-21: WARNING: Comparison of 0/1 to bool
variable

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot<abaci@linux.alibaba.com>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b9df855..5d39129 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3740,7 +3740,7 @@ static void delayed_free(struct rcu_head *p)
 
 	if (!ses->binding) {
 		ses->capabilities = server->capabilities;
-		if (linuxExtEnabled == 0)
+		if (!linuxExtEnabled)
 			ses->capabilities &= (~server->vals->cap_unix);
 
 		if (ses->auth_key.response) {
-- 
1.8.3.1

