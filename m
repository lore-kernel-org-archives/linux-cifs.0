Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD51C33CAF
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 02:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F1682075B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 02:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731815AbgAQCWM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 21:22:12 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9646 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729941AbgAQCWM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 16 Jan 2020 21:22:12 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 23EC03111015E7FE6893;
        Fri, 17 Jan 2020 10:22:10 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 10:22:01 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <stfrench@microsoft.com>, <pc@cjr.nz>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] cifs: Fix return value in __update_cache_entry
Date:   Fri, 17 Jan 2020 10:21:56 +0800
Message-ID: <20200117022156.57844-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

copy_ref_data() may return error, it should be
returned to upstream caller.

Fixes: 03535b72873b ("cifs: Avoid doing network I/O while holding cache lock")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/cifs/dfs_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 5617efe..03cfaa1 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -593,7 +593,7 @@ static int __update_cache_entry(const char *path,
 
 	kfree(th);
 
-	return 0;
+	return rc;
 }
 
 static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
-- 
2.7.4


