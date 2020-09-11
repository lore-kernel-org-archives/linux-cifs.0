Return-Path: <SRS0=T1K2=CU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E303C433E2
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Sep 2020 03:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32950221E5
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Sep 2020 03:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725300AbgIKD7T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Sep 2020 23:59:19 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59536 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbgIKD66 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 10 Sep 2020 23:58:58 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6593F7046D96FD5A979E;
        Fri, 11 Sep 2020 11:58:54 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Sep 2020
 11:58:44 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 1/5] cifs: fix comparison to bool warning in cifsacl.c
Date:   Fri, 11 Sep 2020 12:05:35 +0800
Message-ID: <20200911040539.113307-2-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200911040539.113307-1-zhengbin13@huawei.com>
References: <20200911040539.113307-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes coccicheck warning:

fs/cifs/cifsacl.c:371:6-49: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 fs/cifs/cifsacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index fcff14ef1c70..9447ff1a5b6a 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -368,7 +368,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		else
 			is_group = false;

-		if (is_well_known_sid(psid, &unix_id, is_group) == false)
+		if (!is_well_known_sid(psid, &unix_id, is_group))
 			goto try_upcall_to_get_id;

 		if (is_group) {
--
2.26.0.106.g9fadedd

