Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA258C43217
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Oct 2022 06:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJMGsk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Oct 2022 02:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiJMGsa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Oct 2022 02:48:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE46514113B;
        Wed, 12 Oct 2022 23:48:27 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mp0NP4Q0TzmV7W;
        Thu, 13 Oct 2022 14:43:49 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 13 Oct
 2022 14:48:25 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <linux-cifs@vger.kernel.org>
CC:     <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
        <yebin10@huawei.com>
Subject: [PATCH -next 0/2] fix potential wild-ptr-deref in 'smb3_free_compound_rqst'
Date:   Thu, 13 Oct 2022 15:10:33 +0800
Message-ID: <20221013071035.2890124-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
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

Ye Bin (2):
  smb3: refactor about 'smb3_init_transform_rq'
  smb3: fix potential wild-ptr-deref in 'smb3_free_compound_rqst'

 fs/cifs/smb2ops.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

-- 
2.31.1

