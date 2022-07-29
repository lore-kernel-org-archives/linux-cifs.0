Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E17C00144
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jul 2022 07:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbiG2HnE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Jul 2022 03:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiG2HnD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Jul 2022 03:43:03 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C498630F45;
        Fri, 29 Jul 2022 00:43:02 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LvKGN2xPCz9t0j;
        Fri, 29 Jul 2022 15:41:48 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Jul 2022 15:42:50 +0800
Received: from huawei.com (10.175.113.25) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 29 Jul
 2022 15:42:49 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-cifs@vger.kernel.org>
CC:     <sprasad@microsoft.com>, <stfrench@microsoft.com>
Subject: [PATCH -next] cifs: fix wrong unlock before return from cifs_tree_connect()
Date:   Fri, 29 Jul 2022 15:49:35 +0800
Message-ID: <20220729074935.115072-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It should unlock 'tcon->tc_lock' before return from cifs_tree_connect().

Fixes: fe67bd563ec2 ("cifs: avoid use of global locks for high contention data")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 931d4b6fafc8..1362210f3ece 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4583,7 +4583,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	if (tcon->ses->ses_status != SES_GOOD ||
 	    (tcon->status != TID_NEW &&
 	    tcon->status != TID_NEED_TCON)) {
-		spin_unlock(&tcon->ses->ses_lock);
+		spin_unlock(&tcon->tc_lock);
 		return 0;
 	}
 	tcon->status = TID_IN_TCON;
-- 
2.25.1

