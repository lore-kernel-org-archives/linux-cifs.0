Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1011C2B9F4
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 06:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE4F613EC
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 06:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhFQGhe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 02:37:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11046 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhFQGhe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Jun 2021 02:37:34 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5C0F0wWWzZdyC;
        Thu, 17 Jun 2021 14:32:29 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 14:35:22 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 17 Jun
 2021 14:35:22 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <libaokun1@huawei.com>, Namjae Jeon <namjae.jeon@samsung.com>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
CC:     <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] cifsd: convert list_for_each to entry variant in vfs_cache.c
Date:   Thu, 17 Jun 2021 14:44:22 +0800
Message-ID: <20210617064422.3191764-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

convert list_for_each() to list_for_each_entry() where
applicable in vfs_cache.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/cifsd/vfs_cache.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/cifsd/vfs_cache.c b/fs/cifsd/vfs_cache.c
index 6ea09fe82814..57044b189531 100644
--- a/fs/cifsd/vfs_cache.c
+++ b/fs/cifsd/vfs_cache.c
@@ -472,15 +472,13 @@ struct ksmbd_file *ksmbd_lookup_fd_inode(struct inode *inode)
 {
 	struct ksmbd_file	*lfp;
 	struct ksmbd_inode	*ci;
-	struct list_head	*cur;
 
 	ci = ksmbd_inode_lookup_by_vfsinode(inode);
 	if (!ci)
 		return NULL;
 
 	read_lock(&ci->m_lock);
-	list_for_each(cur, &ci->m_fp_list) {
-		lfp = list_entry(cur, struct ksmbd_file, node);
+	list_for_each_entry(lfp, &ci->m_fp_list, node) {
 		if (inode == FP_INODE(lfp)) {
 			atomic_dec(&ci->m_count);
 			read_unlock(&ci->m_lock);

