Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D96DC43460
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 13:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B0E60BD3
	for <linux-cifs@archiver.kernel.org>; Thu, 20 May 2021 13:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240075AbhETNen (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 May 2021 09:34:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4562 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbhETNeV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 May 2021 09:34:21 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fm9b73BJVzqTnk;
        Thu, 20 May 2021 21:30:11 +0800 (CST)
Received: from dggeml759-chm.china.huawei.com (10.1.199.138) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 21:32:58 +0800
Received: from localhost.localdomain (10.175.102.38) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 21:32:57 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Namjae Jeon <namjae.jeon@samsung.com>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
CC:     <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] cifsd: fix build error without CONFIG_OID_REGISTRY
Date:   Thu, 20 May 2021 13:42:11 +0000
Message-ID: <20210520134211.1667806-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix build error when CONFIG_OID_REGISTRY is not set:

mips-linux-gnu-ld: fs/cifsd/asn1.o: in function `gssapi_this_mech':
asn1.c:(.text+0xaa0): undefined reference to `sprint_oid'
mips-linux-gnu-ld: fs/cifsd/asn1.o: in function `neg_token_init_mech_type':
asn1.c:(.text+0xbec): undefined reference to `sprint_oid'

Fixes: fad4161b5cd0 ("cifsd: decoding gss token using lib/asn1_decoder.c")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 fs/cifsd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifsd/Kconfig b/fs/cifsd/Kconfig
index 5316b1035fbe..e6448b04f46e 100644
--- a/fs/cifsd/Kconfig
+++ b/fs/cifsd/Kconfig
@@ -18,6 +18,7 @@ config SMB_SERVER
 	select CRYPTO_CCM
 	select CRYPTO_GCM
 	select ASN1
+	select OID_REGISTRY
 	default n
 	help
 	  Choose Y here if you want to allow SMB3 compliant clients

