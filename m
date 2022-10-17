Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01451C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 13:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJQNmT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 09:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJQNmQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 09:42:16 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F65F02F
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 06:42:15 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MrdMw5MTCz1P7Fd;
        Mon, 17 Oct 2022 21:37:32 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 21:42:13 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>,
        <aaptel@suse.com>
Subject: [PATCH 5/5] cifs: Fix xid leak in cifs_get_file_info_unix()
Date:   Mon, 17 Oct 2022 22:45:25 +0800
Message-ID: <20221017144525.414313-6-zhangxiaoxu5@huawei.com>
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

If stardup the symlink target failed, should free the xid,
otherwise the xid will be leaked.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7cf96e581d24..9bde08d44617 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -368,8 +368,10 @@ cifs_get_file_info_unix(struct file *filp)
 
 	if (cfile->symlink_target) {
 		fattr.cf_symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
-		if (!fattr.cf_symlink_target)
-			return -ENOMEM;
+		if (!fattr.cf_symlink_target) {
+			rc = -ENOMEM;
+			goto cifs_gfiunix_out;
+		}
 	}
 
 	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->fid.netfid, &find_data);
-- 
2.31.1

