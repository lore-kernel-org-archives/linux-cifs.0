Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A54EC4332F
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Oct 2022 06:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiJMGsh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Oct 2022 02:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiJMGsc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Oct 2022 02:48:32 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20D1141129;
        Wed, 12 Oct 2022 23:48:29 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mp0NQ6kN5z1P7BC;
        Thu, 13 Oct 2022 14:43:50 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 13 Oct
 2022 14:48:26 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <linux-cifs@vger.kernel.org>
CC:     <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
        <yebin10@huawei.com>
Subject: [PATCH -next 2/2] smb3: fix potential wild-ptr-deref in 'smb3_free_compound_rqst'
Date:   Thu, 13 Oct 2022 15:10:35 +0800
Message-ID: <20221013071035.2890124-3-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221013071035.2890124-1-yebin10@huawei.com>
References: <20221013071035.2890124-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As 'smb3_init_transform_rq' first set 'new_rq[i].rq_npages', then
allocate page, if allocate page failed will call 'smb3_free_compound_rqst'
to free page. However, there may only allocate part of 'rq_npages' pages
which will lead to wild-ptr-deref when free pages.
To solve above issue just increase 'new_rq[i].rq_npages' after allocate
page success.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 180f0260cbc4..a1b47ce4ea15 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4467,7 +4467,6 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 			goto err_free;
 
 		nrq->rq_pages = pages;
-		nrq->rq_npages = npages;
 		nrq->rq_offset = orq->rq_offset;
 		nrq->rq_pagesz = orq->rq_pagesz;
 		nrq->rq_tailsz = orq->rq_tailsz;
@@ -4480,6 +4479,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 			pages[j] = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
 			if (!pages[j])
 				goto err_free;
+			nrq->rq_npages++;
 		}
 
 		/* copy pages form the old */
-- 
2.31.1

