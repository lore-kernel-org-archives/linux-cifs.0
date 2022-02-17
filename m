Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705C4C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Feb 2022 00:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiBQArq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Feb 2022 19:47:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiBQArq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Feb 2022 19:47:46 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FC7E3C47;
        Wed, 16 Feb 2022 16:47:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4f6k5b_1645058848;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V4f6k5b_1645058848)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 17 Feb 2022 08:47:29 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] cifs: clean up an inconsistent indenting
Date:   Thu, 17 Feb 2022 08:47:26 +0800
Message-Id: <20220217004726.103512-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Eliminate the follow smatch warning:
fs/cifs/sess.c:129 cifs_try_adding_channels() warn: inconsistent
indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/cifs/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 764b2131b9a4..a4c80a4dd14d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -126,7 +126,7 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	int tries = 0;
 	struct cifs_server_iface *ifaces = NULL;
 	size_t iface_count;
-dump_stack();
+	dump_stack();
 	if (ses->server->dialect < SMB30_PROT_ID) {
 		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
 		return 0;
-- 
2.20.1.7.g153144c

