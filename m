Return-Path: <SRS0=m+wU=UE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D24C28CC5
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jun 2019 21:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 812DB2075B
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jun 2019 21:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfFEVOM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jun 2019 17:14:12 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:45451 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFEVOM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jun 2019 17:14:12 -0400
Received: from orion.localdomain ([77.2.1.21]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MMp08-1hICqU2EL6-00Ijls; Wed, 05 Jun 2019 23:14:10 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [PATCH] fs: cifs: drop unneeded likely() call around IS_ERR()
Date:   Wed,  5 Jun 2019 23:14:09 +0200
Message-Id: <1559769249-22011-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:qkVUq1ddLyADe4tmyATA1skl2fayfUJ70B3v6uWiplTRnUk/fQe
 YLua2/cyRO1xn/l5xQ3kPnw6k862E/uBTZ+J8O+2soe8KvxPOAl7LMkW/ko439On/cli+Gn
 eyX2WJMch+5rurK9eMHCK5WjxQk/vfcZBfql+BlR4FYb0oUdtnCFmqnyQ1Y6UCLEARrgYY4
 d54jCDL8ux0MFpMJA1KWQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bZqIPo62mx4=:BxMCWN3lSz9NydUk7ItuDF
 naR2fsU5d1IsuB7DG0eO5GmtUbUbHy2otvDYTrK5W46m3hKgvEpUTV7vVSTAgXecB/f9omY/Z
 HCojY+e4xM/zmR9veGM6PMHFDS1LRXZHZcZh/7AteRcq6ZgWcoLe4ZYHnINosnfwbfNXyLyFh
 tN7K2+PDH7j0M2DWwMlX1ywptk3/65eosTeXNo7b9DCZH5k/n8gZDOS9+BmkwceEBi2ZyyD+G
 66QebDvIRufmeoAtULpPQ1gr3Ti90ZN9YwDpQe22AmZ3hVEqQSgv437bkwgRyJMfqu/PUHugb
 ljgMBRB1+StnYM13TMDucAg4sJwBmfbFwCm9YGRIxNgWhGXm/Vc+77aq3uJ4E2lkllVtxVxhd
 nUppaBDcQhgSf/UufEGUPuOUSMtAOanUauX49qSaSz/wEPKfdl1UpwVVGYfhyxowG5wmkWGlx
 cEkXrPu9w/mP3jl6yTqognKtzmetb5xWAVD8gRZGWdaAo/fUeKWMfWai/gqzSCOvTdZwMjPPo
 EnSY2DfBC8+5sRWD1oH/LP01KNWwE1wS3AripvvDN87XeknlfoJ0MkSCPjcPg5jfZVEDR0qgU
 Eek5yBVdJC/O6fuLVMjL7W+p600lWyp1pgmW0X3/PzvU8QqfFopRv0IPqPUDy9WuMTnRfIua6
 7mCjh3sNVLsXDlx1i26LgJ2KYR9NUM+titGWMWq9UrGRqH+Z5wCpXf0/bTprmznQCKXXArl0F
 ZXpqqROuxKsgODal0E5W/42/LR3ooktwsYy3AA==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

IS_ERR() already calls unlikely(), so this extra unlikely() call
around IS_ERR() is not needed.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 fs/cifs/dfs_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index e3e1c13..1692c0c 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -492,7 +492,7 @@ static struct dfs_cache_entry *__find_cache_entry(unsigned int hash,
 #ifdef CONFIG_CIFS_DEBUG2
 			char *name = get_tgt_name(ce);
 
-			if (unlikely(IS_ERR(name))) {
+			if (IS_ERR(name)) {
 				rcu_read_unlock();
 				return ERR_CAST(name);
 			}
-- 
1.9.1

