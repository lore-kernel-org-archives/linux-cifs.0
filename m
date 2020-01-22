Return-Path: <SRS0=MBFb=3L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92073C2D0DB
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 10:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 705D124683
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 10:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAVKZg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:25:36 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:57018 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728931AbgAVKZg (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Jan 2020 05:25:36 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3F12412C5CBA7696B902;
        Wed, 22 Jan 2020 18:25:33 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 22 Jan 2020 18:25:25 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <sfrench@samba.org>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH -next] cifs: use PTR_ERR_OR_ZERO() to simplify code
Date:   Wed, 22 Jan 2020 18:20:30 +0800
Message-ID: <20200122102030.95853-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PTR_ERR_OR_ZERO contains if(IS_ERR(...)) + PTR_ERR, just use
PTR_ERR_OR_ZERO directly.

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 fs/cifs/dfs_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 751c2fc..43c1b43 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -662,7 +662,7 @@ static int __dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	if (noreq) {
 		up_read(&htable_rw_lock);
-		return IS_ERR(ce) ? PTR_ERR(ce) : 0;
+		return PTR_ERR_OR_ZERO(ce);
 	}
 
 	if (!IS_ERR(ce)) {
-- 
2.7.4

