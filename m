Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D79C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Nov 2022 06:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiKKGHb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Nov 2022 01:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKGHa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Nov 2022 01:07:30 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BCF5E9E5
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 22:07:28 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7pBl0dvbzmV6l;
        Fri, 11 Nov 2022 14:07:11 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 14:07:26 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <palcantara@suse.de>
Subject: [PATCH v2] cifs: Fix connections leak when tlink setup failed
Date:   Fri, 11 Nov 2022 15:12:12 +0800
Message-ID: <20221111071212.132722-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If the tlink setup failed, lost to put the connections, then
the module refcnt leak since the cifsd kthread not exit.

Also leak the fscache info, and for next mount with fsc, it will
print the follow errors:
  CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)

Let's check the result of tlink setup, and do some cleanup.

Fixes: 56c762eb9bee ("cifs: Refactor out cifs_mount()")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
v2: goto error rather than only put connections.

 fs/cifs/connect.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1cc47dd3b4d6..9db9527c61cf 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3855,9 +3855,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
 
 out:
-	free_xid(mnt_ctx.xid);
 	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
-	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
+
+	free_xid(mnt_ctx.xid);
+	return rc;
 
 error:
 	dfs_cache_put_refsrv_sessions(&mnt_ctx.mount_id);
@@ -3884,8 +3888,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 			goto error;
 	}
 
+	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	if (rc)
+		goto error;
+
 	free_xid(mnt_ctx.xid);
-	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
+	return rc;
 
 error:
 	mount_put_conns(&mnt_ctx);
-- 
2.31.1

