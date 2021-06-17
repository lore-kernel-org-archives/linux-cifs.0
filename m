Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A5CC48BE5
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 13:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF89613BF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 13:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhFQNPl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 09:15:41 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7474 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhFQNPj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Jun 2021 09:15:39 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5MqY3RW1zZj6j;
        Thu, 17 Jun 2021 21:10:33 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 21:13:29 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 17 Jun
 2021 21:13:29 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <libaokun1@huawei.com>, Namjae Jeon <namjae.jeon@samsung.com>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
CC:     <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] cifsd: convert list_for_each to entry variant in smb_common.c
Date:   Thu, 17 Jun 2021 21:22:28 +0800
Message-ID: <20210617132228.689945-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

convert list_for_each() to list_for_each_entry() where
applicable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/cifsd/smb_common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/cifsd/smb_common.c b/fs/cifsd/smb_common.c
index 039030968b50..d74b2ce08187 100644
--- a/fs/cifsd/smb_common.c
+++ b/fs/cifsd/smb_common.c
@@ -481,15 +481,13 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 {
 	int rc = 0;
 	struct ksmbd_file *prev_fp;
-	struct list_head *cur;
 
 	/*
 	 * Lookup fp in master fp list, and check desired access and
 	 * shared mode between previous open and current open.
 	 */
 	read_lock(&curr_fp->f_ci->m_lock);
-	list_for_each(cur, &curr_fp->f_ci->m_fp_list) {
-		prev_fp = list_entry(cur, struct ksmbd_file, node);
+	list_for_each_entry(prev_fp, &curr_fp->f_ci->m_fp_list, node) {
 		if (file_inode(filp) != FP_INODE(prev_fp))
 			continue;
 

