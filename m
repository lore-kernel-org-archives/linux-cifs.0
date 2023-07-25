Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F64C0015E
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jul 2023 12:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbjGYMeT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Jul 2023 08:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjGYMeS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Jul 2023 08:34:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B44173B
        for <linux-cifs@vger.kernel.org>; Tue, 25 Jul 2023 05:34:16 -0700 (PDT)
Received: from dggpemm100004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R9GbG6CpCzCrLj;
        Tue, 25 Jul 2023 20:30:50 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm100004.china.huawei.com (7.185.36.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 20:34:13 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 25 Jul
 2023 20:34:12 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-cifs@vger.kernel.org>
CC:     <linkinjeon@kernel.org>, <sfrench@samba.org>,
        <senozhatsky@chromium.org>, <tom@talpey.com>,
        <yangyingliang@huawei.com>
Subject: [PATCH -next] smb: switch to use kmemdup_nul() helper
Date:   Tue, 25 Jul 2023 20:31:47 +0800
Message-ID: <20230725123147.525642-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use kmemdup_nul() helper instead of open-coding to
simplify the code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/smb/server/asn1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/server/asn1.c b/fs/smb/server/asn1.c
index cc6384f79675..4a4b2b03ff33 100644
--- a/fs/smb/server/asn1.c
+++ b/fs/smb/server/asn1.c
@@ -214,12 +214,10 @@ static int ksmbd_neg_token_alloc(void *context, size_t hdrlen,
 {
 	struct ksmbd_conn *conn = context;
 
-	conn->mechToken = kmalloc(vlen + 1, GFP_KERNEL);
+	conn->mechToken = kmemdup_nul(value, vlen, GFP_KERNEL);
 	if (!conn->mechToken)
 		return -ENOMEM;
 
-	memcpy(conn->mechToken, value, vlen);
-	conn->mechToken[vlen] = '\0';
 	return 0;
 }
 
-- 
2.25.1

