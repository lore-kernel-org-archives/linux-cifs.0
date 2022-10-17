Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49C2C43219
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 13:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiJQNmR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 09:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJQNmP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 09:42:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0097C4E615
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 06:42:14 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MrdPX719RzpVbK;
        Mon, 17 Oct 2022 21:38:56 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 21:42:13 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <aaptel@suse.com>
Subject: [PATCH 4/5] cifs: Fix xid leak in cifs_ses_add_channel()
Date:   Mon, 17 Oct 2022 22:45:24 +0800
Message-ID: <20221017144525.414313-5-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
References: <20221017144525.414313-1-zhangxiaoxu5@huawei.com>
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

Before return, should free the xid, otherwise, the
xid will be leaked.

Fixes: d70e9fa55884 ("cifs: try opening channels after mounting")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/sess.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 0435d1dfa9e1..92e4278ec35d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -496,6 +496,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		cifs_put_tcp_session(chan->server, 0);
 	}
 
+	free_xid(xid);
 	return rc;
 }
 
-- 
2.31.1

