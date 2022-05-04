Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27F2C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 13:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350350AbiEDNKt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 09:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241311AbiEDNKe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 09:10:34 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D78E403F8;
        Wed,  4 May 2022 06:06:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VCC0O7J_1651669595;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VCC0O7J_1651669595)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 04 May 2022 21:06:36 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] cifs: Return true/false (not 1/0) from bool functions
Date:   Wed,  4 May 2022 21:06:34 +0800
Message-Id: <20220504130634.101239-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Return boolean values ("true" or "false") instead of 1 or 0 from bool
functions. This fixes the following warnings from coccicheck:

./fs/cifs/file.c:4764:9-10: WARNING: return of 0/1 in function
cifs_release_folio() with return type bool

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/cifs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 580a847aa8b5..a9123cefd84f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4761,7 +4761,7 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 static bool cifs_release_folio(struct folio *folio, gfp_t gfp)
 {
 	if (folio_test_private(folio))
-		return 0;
+		return false;
 	if (folio_test_fscache(folio)) {
 		if (current_is_kswapd() || !(gfp & __GFP_FS))
 			return false;
-- 
2.20.1.7.g153144c

