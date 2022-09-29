Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFE7C04A95
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 08:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiI2IvE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 04:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbiI2Iuy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 04:50:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302EE5E326
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 01:50:52 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MdRp139SvzpVRp;
        Thu, 29 Sep 2022 16:47:53 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500022.china.huawei.com
 (7.185.36.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 29 Sep
 2022 16:50:50 +0800
From:   Zeng Heng <zengheng4@huawei.com>
To:     <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <tom@talpey.com>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <liwei391@huawei.com>, <zengheng4@huawei.com>
Subject: [PATCH -next] fs: cifs: initialize spinlock in data section
Date:   Thu, 29 Sep 2022 17:06:55 +0800
Message-ID: <20220929090655.2200986-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use DEFINE_SPINLOCK to initialize spinlock,
which saves calling spin_lock_init additionally.

There are no logic changes.

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 fs/cifs/cifsfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8042d7280dec..dda2fe6648fc 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -76,7 +76,7 @@ unsigned int sign_CIFS_PDUs = 1;
 unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Sem */
 unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
 unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
-spinlock_t GlobalMid_Lock; /* protects above & list operations on midQ entries */
+DEFINE_SPINLOCK(GlobalMid_Lock); /* protects above & list operations on midQ entries */
 
 /*
  *  Global counters, updated atomically
@@ -96,7 +96,7 @@ atomic_t total_buf_alloc_count;
 atomic_t total_small_buf_alloc_count;
 #endif/* STATS2 */
 struct list_head	cifs_tcp_ses_list;
-spinlock_t		cifs_tcp_ses_lock;
+DEFINE_SPINLOCK(cifs_tcp_ses_lock);
 static const struct super_operations cifs_super_ops;
 unsigned int CIFSMaxBufSize = CIFS_MAX_MSGSIZE;
 module_param(CIFSMaxBufSize, uint, 0444);
@@ -1615,8 +1615,6 @@ init_cifs(void)
 	GlobalCurrentXid = 0;
 	GlobalTotalActiveXid = 0;
 	GlobalMaxActiveXid = 0;
-	spin_lock_init(&cifs_tcp_ses_lock);
-	spin_lock_init(&GlobalMid_Lock);
 
 	cifs_lock_secret = get_random_u32();
 
-- 
2.25.1

