Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59ACBC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 26 May 2022 23:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbiEZX0Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 May 2022 19:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238521AbiEZX0P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 May 2022 19:26:15 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D68849925;
        Thu, 26 May 2022 16:26:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VEUGXJR_1653607568;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VEUGXJR_1653607568)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 27 May 2022 07:26:08 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] cifs: Remove duplicated include in cifssmb.c
Date:   Fri, 27 May 2022 07:26:06 +0800
Message-Id: <20220526232606.64174-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix following includecheck warning:
./fs/cifs/cifssmb.c: cifsfs.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/cifs/cifssmb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e3457356ec11..193009f1421b 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -28,7 +28,6 @@
 #include "cifsglob.h"
 #include "cifsacl.h"
 #include "cifsproto.h"
-#include "cifsfs.h"
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
 #include "smb2proto.h"
-- 
2.20.1.7.g153144c

