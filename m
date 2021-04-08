Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227A3C433B4
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 08:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D30B361158
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 08:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhDHIbW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:31:22 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:48643 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229539AbhDHIbV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 04:31:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UUspqwm_1617870663;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UUspqwm_1617870663)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 08 Apr 2021 16:31:09 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] cifs: Remove useless variable
Date:   Thu,  8 Apr 2021 16:31:02 +0800
Message-Id: <1617870662-78127-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix the following gcc warning:

fs/cifs/cifsacl.c:1097:8: warning: variable ‘nmode’ set but not used
[-Wunused-but-set-variable].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/cifs/cifsacl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index d178cf8..fdb258a 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1094,11 +1094,9 @@ static int set_chmod_dacl(struct cifs_acl *pdacl, struct cifs_acl *pndacl,
 	struct cifs_ace *pnntace = NULL;
 	char *nacl_base = NULL;
 	u32 num_aces = 0;
-	__u64 nmode;
 	bool new_aces_set = false;
 
 	/* Assuming that pndacl and pnmode are never NULL */
-	nmode = *pnmode;
 	nacl_base = (char *)pndacl;
 	nsize = sizeof(struct cifs_acl);
 
-- 
1.8.3.1

