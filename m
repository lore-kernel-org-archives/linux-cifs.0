Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEF2C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 07:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF0F064DDA
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 07:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhBXHcS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 02:32:18 -0500
Received: from m12-16.163.com ([220.181.12.16]:38251 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231614AbhBXHcQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 24 Feb 2021 02:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=h20Pq
        31ATma62uZJGhkw13KVtW2FqmAZOmLwZDDNp5g=; b=REFuGWFVYTL2lfKGF8xo0
        3U8pBMq5sWcLunnXOwNyTJ08oCoDcF9LgDgH8SeHh/B4mIIbPFMNMat3d8Im7J2I
        3AKs2GsRC2HcNW8HTXjuyHinZDP90+bDNMw23afrs1JVXEnlUaOGkySwnSfnlN8z
        quJYrEykOBekAulmrYjk1c=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp12 (Coremail) with SMTP id EMCowACHik7F_DVgqAvUdQ--.33755S2;
        Wed, 24 Feb 2021 15:14:14 +0800 (CST)
From:   dingsenjie@163.com
To:     sfrench@samba.org, samba-technical@lists.samba.org
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH v2] fs/cifs:simplify the return expression of cifs_swn_auth_info_krb
Date:   Wed, 24 Feb 2021 15:14:10 +0800
Message-Id: <20210224071410.37968-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowACHik7F_DVgqAvUdQ--.33755S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF17Xw45WF1rKry3uw47XFb_yoW3WFg_Cr
        WkGws3ur1kCry8tayUX3yrXa4xtFy0qryfZr48Kw4DKr9xur1rC3s8tFyfJa4UWF1DZFyx
        Wwn8ury2ywn5tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0x-BtUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiHgJDyFSIs6pGgAABsV
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
index d35f599..67b3f4e 100644
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
+	return nla_put_flag(skb, CIFS_GENL_ATTR_SWN_KRB_AUTH);
 }
 
 static int cifs_swn_auth_info_ntlm(struct cifs_tcon *tcon, struct sk_buff *skb)
-- 
1.9.1


