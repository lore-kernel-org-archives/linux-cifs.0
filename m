Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569E1C433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Nov 2022 07:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbiKRHhk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Nov 2022 02:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241351AbiKRHhf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Nov 2022 02:37:35 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8F7898F0
        for <linux-cifs@vger.kernel.org>; Thu, 17 Nov 2022 23:37:31 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ND7sH6B9KzRpQL;
        Fri, 18 Nov 2022 15:37:07 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 15:37:29 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <longli@microsoft.com>
Subject: [PATCH 1/2] cifs: Fix lost destroy smbd connection when MR allocate failed
Date:   Fri, 18 Nov 2022 16:42:07 +0800
Message-ID: <20221118084208.3214951-2-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221118084208.3214951-1-zhangxiaoxu5@huawei.com>
References: <20221118084208.3214951-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If the MR allocate failed, the smb direct connection info is NULL,
then smbd_destroy() will directly return, then the connection info
will be leaked.

Let's set the smb direct connection info to the server before call
smbd_destroy().

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/smbdirect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 90789aaa6567..a874c2e1ae41 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1699,6 +1699,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
+	server->smbd_conn = info;
 	smbd_destroy(server);
 	return NULL;
 
-- 
2.31.1

