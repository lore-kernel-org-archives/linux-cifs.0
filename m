Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE40EE4996
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Aug 2023 08:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbjHUI3M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Aug 2023 04:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjHUI3M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Aug 2023 04:29:12 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EDCA6;
        Mon, 21 Aug 2023 01:29:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VqDjToh_1692606544;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VqDjToh_1692606544)
          by smtp.aliyun-inc.com;
          Mon, 21 Aug 2023 16:29:05 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     linkinjeon@kernel.org, sfrench@samba.org
Cc:     senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] ksmbd: Fix one kernel-doc comment
Date:   Mon, 21 Aug 2023 16:29:03 +0800
Message-Id: <20230821082903.26423-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix one kernel-doc comment to silence the warning:
fs/smb/server/smb2pdu.c:4160: warning: Excess function parameter 'infoclass_size' description in 'buffer_check_err'

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/smb/server/smb2pdu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a7325fe3319b..f4f2d51b56b5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4150,7 +4150,6 @@ int smb2_query_dir(struct ksmbd_work *work)
  * @reqOutputBufferLength:	max buffer length expected in command response
  * @rsp:		query info response buffer contains output buffer length
  * @rsp_org:		base response buffer pointer in case of chained response
- * @infoclass_size:	query info class response buffer size
  *
  * Return:	0 on success, otherwise error
  */
-- 
2.20.1.7.g153144c

