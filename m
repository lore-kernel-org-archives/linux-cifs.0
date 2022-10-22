Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D617C04A95
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Oct 2022 06:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJVGcN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Oct 2022 02:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiJVGcK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Oct 2022 02:32:10 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0FC2B733A
        for <linux-cifs@vger.kernel.org>; Fri, 21 Oct 2022 23:32:07 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MvWb870vCzmV7S;
        Sat, 22 Oct 2022 14:27:16 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 22 Oct 2022 14:32:04 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <longli@microsoft.com>
Subject: [PATCH 2/2] cifs: Fix pages array leak when writedata alloc failed in cifs_writedata_alloc()
Date:   Sat, 22 Oct 2022 15:35:21 +0800
Message-ID: <20221022073521.1660841-3-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221022073521.1660841-1-zhangxiaoxu5@huawei.com>
References: <20221022073521.1660841-1-zhangxiaoxu5@huawei.com>
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

There is a memory leak when writedata alloc failed:

  unreferenced object 0xffff888192364000 (size 8192):
    comm "sync", pid 22839, jiffies 4297313967 (age 60.230s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<0000000027de0814>] __kmalloc+0x4d/0x150
      [<00000000b21e81ab>] cifs_writepages+0x35f/0x14a0
      [<0000000076f7d20e>] do_writepages+0x10a/0x360
      [<00000000d6a36edc>] filemap_fdatawrite_wbc+0x95/0xc0
      [<000000005751a323>] __filemap_fdatawrite_range+0xa7/0xe0
      [<0000000088afb0ca>] file_write_and_wait_range+0x66/0xb0
      [<0000000063dbc443>] cifs_strict_fsync+0x80/0x5f0
      [<00000000c4624754>] __x64_sys_fsync+0x40/0x70
      [<000000002c0dc744>] do_syscall_64+0x35/0x80
      [<0000000052f46bee>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

cifs_writepages+0x35f/0x14a0 is:
  kmalloc_array at include/linux/slab.h:628
  (inlined by) kcalloc at include/linux/slab.h:659
  (inlined by) cifs_writedata_alloc at fs/cifs/file.c:2438
  (inlined by) wdata_alloc_and_fillpages at fs/cifs/file.c:2527
  (inlined by) cifs_writepages at fs/cifs/file.c:2705

If writedata alloc failed in cifs_writedata_alloc(), the pages array
should be freed.

Fixes: 8e7360f67e75 ("CIFS: Add support for direct pages in wdata")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 87be0223a57a..cd9698209930 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2434,12 +2434,16 @@ cifs_writev_complete(struct work_struct *work)
 struct cifs_writedata *
 cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
 {
+	struct cifs_writedata *writedata = NULL;
 	struct page **pages =
 		kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
-	if (pages)
-		return cifs_writedata_direct_alloc(pages, complete);
+	if (pages) {
+		writedata = cifs_writedata_direct_alloc(pages, complete);
+		if (!writedata)
+			kvfree(pages);
+	}
 
-	return NULL;
+	return writedata;
 }
 
 struct cifs_writedata *
-- 
2.31.1

