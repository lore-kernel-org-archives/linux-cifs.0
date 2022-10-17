Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AF5C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 13:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiJQNmQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 09:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJQNmP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 09:42:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83AB2ED71
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 06:42:13 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MrdMt57MCz1P7Br;
        Mon, 17 Oct 2022 21:37:30 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 21:42:11 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <aaptel@suse.com>
Subject: [PATCH 1/5] cifs: Fix xid leak in cifs_create()
Date:   Mon, 17 Oct 2022 22:45:21 +0800
Message-ID: <20221017144525.414313-2-zhangxiaoxu5@huawei.com>
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

If the cifs already shutdown, we should free the xid before return,
otherwise, the xid will be leaked.

Fixes: 087f757b0129 ("cifs: add shutdown support")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index a5c73c2af3a2..8b1c37158556 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -543,8 +543,10 @@ int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
 		 inode, direntry, direntry);
 
-	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
-		return -EIO;
+	if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb)))) {
+		rc = -EIO;
+		goto out_free_xid;
+	}
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	rc = PTR_ERR(tlink);
-- 
2.31.1

