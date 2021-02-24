Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB51C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 04:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FD164E79
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 04:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhBXEWF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Feb 2021 23:22:05 -0500
Received: from m12-12.163.com ([220.181.12.12]:51615 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230441AbhBXEWE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 23 Feb 2021 23:22:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ma45Q
        NDYoL0iGWY2UAK6YCWBODObKTa40Y3I14Ill/k=; b=AqFC6mRKAPlZgpG4WB4IE
        B3HrxAgQAAXwzhJHVACDP4AcAxU8k3rOvB5cJB2LOiDgKeeKTZKocNRXBU5sd/sw
        FTpGuQ2EILXNFny55GO7CepUSzxF7T/y6CpfO/pKUiNqmhTalocr8P/m8cZybVZ6
        adGrtJUQaRUAR4j2IHNIz8=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp8 (Coremail) with SMTP id DMCowAD3_o61yDVgrmrbRw--.23365S2;
        Wed, 24 Feb 2021 11:32:07 +0800 (CST)
From:   dingsenjie@163.com
To:     sfrench@samba.org, samba-technical@lists.samba.org
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] fs/cifs:simplify the return expression of cifs_swn_auth_info_krb
Date:   Wed, 24 Feb 2021 11:32:02 +0800
Message-Id: <20210224033202.44052-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowAD3_o61yDVgrmrbRw--.23365S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF17Xw45WF1rKry3uw47XFb_yoW3WFX_Cr
        WkGws3ur1vkryrta4UJ3yFq34xJFy0qryfZr4kKw4DKr9xWr1rC3s8tF95Ja4UWF1DZFyx
        Wwn8uryIywn8tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8C38UUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiThdDyFUDH2dbvgAAsZ
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

simplify the return expression.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 fs/cifs/cifs_swn.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index d35f599..378531b 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -34,13 +34,7 @@ struct cifs_swn_reg {
 
 static int cifs_swn_auth_info_krb(struct cifs_tcon *tcon, struct sk_buff *skb)
 {
-	int ret;
-
-	ret = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_KRB_AUTH);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return = nla_put_flag(skb, CIFS_GENL_ATTR_SWN_KRB_AUTH);
 }
 
 static int cifs_swn_auth_info_ntlm(struct cifs_tcon *tcon, struct sk_buff *skb)
-- 
1.9.1


