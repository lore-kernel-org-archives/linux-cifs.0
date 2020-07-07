Return-Path: <SRS0=GU4v=AS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B79BC433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 11:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF9320702
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 11:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGGLRl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jul 2020 07:17:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51284 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726540AbgGGLRl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 7 Jul 2020 07:17:41 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5F551B6698650814C70B;
        Tue,  7 Jul 2020 19:17:40 +0800 (CST)
Received: from kernelci-master.huawei.com (10.175.101.6) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 7 Jul 2020 19:17:32 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>, Steve French <sfrench@samba.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>
Subject: [PATCH -next] cifs: remove unused variable 'server'
Date:   Tue, 7 Jul 2020 19:27:41 +0800
Message-ID: <20200707112741.9496-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix build warning by removing unused variable 'server':

fs/cifs/inode.c:1089:26: warning:
 variable server set but not used [-Wunused-but-set-variable]
 1089 |  struct TCP_Server_Info *server;
      |                          ^~~~~~

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 fs/cifs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index ce95801e9b66..3989d08396ac 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1086,7 +1086,6 @@ smb311_posix_get_inode_info(struct inode **inode,
 		    struct super_block *sb, unsigned int xid)
 {
 	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	bool adjust_tz = false;
@@ -1100,7 +1099,6 @@ smb311_posix_get_inode_info(struct inode **inode,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
-	server = tcon->ses->server;
 
 	/*
 	 * 1. Fetch file metadata

