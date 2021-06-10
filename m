Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADC0C47094
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Jun 2021 11:39:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EC7F613DE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Jun 2021 11:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFJLlN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:41:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5489 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJLlJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Jun 2021 07:41:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G12445559zZf6K;
        Thu, 10 Jun 2021 19:36:20 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 19:39:11 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 19:39:10 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <yangjihong1@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>
Subject: [PATCH -next] cifs: fix doc warnings in cifs_dfs_ref.c
Date:   Thu, 10 Jun 2021 19:48:17 +0800
Message-ID: <20210610114817.3524037-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add description for `cifs_compose_mount_options` to fix the W=1 warnings:

 fs/cifs/cifs_dfs_ref.c:139: warning: Function parameter or
  member 'devname' not described in 'cifs_compose_mount_options'

Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/cifs/cifs_dfs_ref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index c87c37cf2914..ec57cdb1590f 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -125,7 +125,7 @@ cifs_build_devname(char *nodename, const char *prepath)
  * @sb_mountdata:	parent/root DFS mount options (template)
  * @fullpath:		full path in UNC format
  * @ref:		optional server's referral
- *
+ * @devname:		return the built cifs device name if passed pointer not NULL
  * creates mount options for submount based on template options sb_mountdata
  * and replacing unc,ip,prefixpath options with ones we've got form ref_unc.
  *
-- 
2.31.1

