Return-Path: <SRS0=m+wU=UE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C816C28CC5
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jun 2019 14:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D6E520870
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Jun 2019 14:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfFEOQu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jun 2019 10:16:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34572 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728039AbfFEOQt (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 5 Jun 2019 10:16:49 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CE617A54197404E79077;
        Wed,  5 Jun 2019 22:16:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 5 Jun 2019 22:16:35 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        <linux-cifs@vger.kernel.org>
Subject: [PATCH] fs: cifs: Drop unlikely before IS_ERR(_OR_NULL)
Date:   Wed, 5 Jun 2019 22:24:25 +0800
Message-ID: <20190605142428.84784-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
References: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag,
so no need to do that again from its callers. Drop it.

Cc: Steve French <stfrench@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 fs/cifs/dfs_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index e3e1c13df439..1692c0c6c23a 100644
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
2.20.1

