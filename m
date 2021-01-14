Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5DAC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 10:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A06DE23A3B
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 10:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbhANKDW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Jan 2021 05:03:22 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:33575 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbhANKDV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Jan 2021 05:03:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0ULhsila_1610618545;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULhsila_1610618545)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Jan 2021 18:02:35 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH v2] fs/cifs: Simplify bool comparison.
Date:   Thu, 14 Jan 2021 18:02:23 +0800
Message-Id: <1610618543-110743-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix the follow warnings:

./fs/cifs/connect.c: WARNING: Comparison of 0/1 to bool variable

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>

---
Changes in v2:
  -Modified subject.

 fs/cifs/connect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b9df855..b7869a2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2628,7 +2628,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 	} else if (ctx)
 		tcon->unix_ext = 1; /* Unix Extensions supported */
 
-	if (tcon->unix_ext == 0) {
+	if (!tcon->unix_ext) {
 		cifs_dbg(FYI, "Unix extensions disabled so not set on reconnect\n");
 		return;
 	}
@@ -3740,7 +3740,7 @@ static void delayed_free(struct rcu_head *p)
 
 	if (!ses->binding) {
 		ses->capabilities = server->capabilities;
-		if (linuxExtEnabled == 0)
+		if (!linuxExtEnabled)
 			ses->capabilities &= (~server->vals->cap_unix);
 
 		if (ses->auth_key.response) {
-- 
1.8.3.1

