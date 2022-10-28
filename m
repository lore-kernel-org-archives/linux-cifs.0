Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E654C38A02
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 11:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiJ1L4y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiJ1L4u (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 07:56:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C3F1D2F4D
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 04:56:50 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MzLXc4dtWzpWFR;
        Fri, 28 Oct 2022 19:53:20 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 19:56:48 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH 5/7] cifs: remove the unused xid parameter from smb_mnt_get_fsinfo
Date:   Fri, 28 Oct 2022 20:11:27 +0800
Message-ID: <20221028121129.3375402-6-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221028121129.3375402-1-zhangxiaoxu5@huawei.com>
References: <20221028121129.3375402-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The xid is unused in smb_mnt_get_fsinfo, remove it.

Fixes: 0de1f4c6f6c0 ("Add way to query server fs info for smb3")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 89d5fa887364..c25e8442068a 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -117,8 +117,7 @@ static long cifs_ioctl_copychunk(unsigned int xid, struct file *dst_file,
 	return rc;
 }
 
-static long smb_mnt_get_fsinfo(unsigned int xid, struct cifs_tcon *tcon,
-				void __user *arg)
+static long smb_mnt_get_fsinfo(struct cifs_tcon *tcon, void __user *arg)
 {
 	int rc = 0;
 	struct smb_mnt_fs_info *fsinf;
@@ -408,7 +407,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			if (pSMBFile == NULL)
 				break;
 			tcon = tlink_tcon(pSMBFile->tlink);
-			rc = smb_mnt_get_fsinfo(xid, tcon, (void __user *)arg);
+			rc = smb_mnt_get_fsinfo(tcon, (void __user *)arg);
 			break;
 		case CIFS_ENUMERATE_SNAPSHOTS:
 			if (pSMBFile == NULL)
-- 
2.31.1

