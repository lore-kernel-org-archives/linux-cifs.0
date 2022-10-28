Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC54FFA3740
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 11:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJ1L4v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 07:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJ1L4t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 07:56:49 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AC71D2B7D
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 04:56:49 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MzLVv4CqVz15M7K;
        Fri, 28 Oct 2022 19:51:51 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 19:56:46 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH 2/7] cifs: Use helper macro NTLMSSP_SIGNATURE in decode_ntlmssp_challenge()
Date:   Fri, 28 Oct 2022 20:11:24 +0800
Message-ID: <20221028121129.3375402-3-zhangxiaoxu5@huawei.com>
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

The siguature type NTLMSSP already defined as macro, use it.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 92e4278ec35d..e08c5f547afb 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -764,7 +764,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 		return -EINVAL;
 	}
 
-	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
+	if (memcmp(pblob->Signature, NTLMSSP_SIGNATURE, 8)) {
 		cifs_dbg(VFS, "blob signature incorrect %s\n",
 			 pblob->Signature);
 		return -EINVAL;
-- 
2.31.1

