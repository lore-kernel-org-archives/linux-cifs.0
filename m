Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EC2C433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Oct 2022 06:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJVGcL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Oct 2022 02:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiJVGcK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Oct 2022 02:32:10 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3922BABE3
        for <linux-cifs@vger.kernel.org>; Fri, 21 Oct 2022 23:32:07 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MvWb8672Gz15M0B;
        Sat, 22 Oct 2022 14:27:16 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 22 Oct 2022 14:32:03 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <longli@microsoft.com>
Subject: [PATCH 1/2] cifs: Fix pages leak when writedata alloc failed in cifs_write_from_iter()
Date:   Sat, 22 Oct 2022 15:35:20 +0800
Message-ID: <20221022073521.1660841-2-zhangxiaoxu5@huawei.com>
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

There is a kmemleak when writedata alloc failed:

  unreferenced object 0xffff888175ae4000 (size 4096):
    comm "dd", pid 19419, jiffies 4296028749 (age 739.396s)
    hex dump (first 32 bytes):
      80 02 b0 04 00 ea ff ff c0 02 b0 04 00 ea ff ff  ................
      80 22 4c 04 00 ea ff ff c0 22 4c 04 00 ea ff ff  ."L......"L.....
    backtrace:
      [<0000000072fdbb86>] __kmalloc_node+0x50/0x150
      [<0000000039faf56f>] __iov_iter_get_pages_alloc+0x605/0xdd0
      [<00000000f862a9d4>] iov_iter_get_pages_alloc2+0x3b/0x80
      [<000000008f226067>] cifs_write_from_iter+0x2ae/0xe40
      [<000000001f78f2f1>] __cifs_writev+0x337/0x5c0
      [<00000000257fcef5>] vfs_write+0x503/0x690
      [<000000008778a238>] ksys_write+0xb9/0x150
      [<00000000ed82047c>] do_syscall_64+0x35/0x80
      [<000000003365551d>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

__iov_iter_get_pages_alloc+0x605/0xdd0 is:
  want_pages_array at lib/iov_iter.c:1304
  (inlined by) __iov_iter_get_pages_alloc at lib/iov_iter.c:1457

If writedata allocate failed, the pages and pagevec should be cleanup.

Fixes: 8c5f9c1ab7cb ("CIFS: Add support for direct I/O write")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5b3b308e115c..87be0223a57a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3299,6 +3299,9 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 					     cifs_uncached_writev_complete);
 			if (!wdata) {
 				rc = -ENOMEM;
+				for (i = 0; i < nr_pages; i++)
+					put_page(pagevec[i]);
+				kvfree(pagevec);
 				add_credits_and_wake_if(server, credits, 0);
 				break;
 			}
-- 
2.31.1

