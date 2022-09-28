Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88ADFC07E9D
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 02:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiI1C2A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Sep 2022 22:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiI1C16 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Sep 2022 22:27:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2085F6F60
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 19:27:56 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4McgJW5BFTzHtd3;
        Wed, 28 Sep 2022 10:23:07 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 10:27:55 +0800
Received: from localhost.localdomain (10.175.127.227) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 10:27:54 +0800
From:   Luo Meng <luomeng12@huawei.com>
To:     <sfrench@samba.org>, <stable@kernel.org>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <lsahlber@redhat.com>, <luomeng12@huawei.com>
Subject: [PATCH 4.19] Revert "cifs: fix double free race when mount fails in cifs_get_root()"
Date:   Wed, 28 Sep 2022 10:49:55 +0800
Message-ID: <20220928024955.3001504-1-luomeng12@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This reverts commit 2fe0e281f7ad0a62259649764228227dd6b2561d.

Commit 2fe0e281f7ad (cifs: fix double free race when mount fails
in cifs_get_root()) fixes a double. However there is no such
issue on 4.19 because it will return after cifs_cleanup_volume_info().

Since merge this patch, cifs_cleanup_volume_info() is skipped, leading
to a memory leak.

Signed-off-by: Luo Meng <luomeng12@huawei.com>
---
 fs/cifs/cifsfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 52b1524b40cd..7dce6d1fa50b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -779,7 +779,6 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 
 out_super:
 	deactivate_locked_super(sb);
-	return root;
 out:
 	cifs_cleanup_volume_info(volume_info);
 	return root;
-- 
2.31.1

