Return-Path: <SRS0=Y4Lp=XS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D8DC3A5A6
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 06:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57EDE2196E
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 06:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393357AbfIWG7h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Sep 2019 02:59:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2707 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393326AbfIWG7g (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Sep 2019 02:59:36 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6EFC1AF3732FF94A9824
        for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2019 14:59:33 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 23 Sep 2019
 14:59:24 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] fs/cifs/smb2pdu.c: Make SMB2_notify_init static
Date:   Mon, 23 Sep 2019 15:06:18 +0800
Message-ID: <1569222378-22693-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix sparse warnings:

fs/cifs/smb2pdu.c:3200:1: warning: symbol 'SMB2_notify_init' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8bcb278..5e87872 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3200,7 +3200,7 @@ SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
  * See MS-SMB2 2.2.35 and 2.2.36
  */

-int
+static int
 SMB2_notify_init(const unsigned int xid, struct smb_rqst *rqst,
 		struct cifs_tcon *tcon, u64 persistent_fid, u64 volatile_fid,
 		u32 completion_filter, bool watch_tree)
--
2.7.4

