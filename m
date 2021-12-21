Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2775C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Dec 2021 09:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbhLUJHb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Dec 2021 04:07:31 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:47737 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236118AbhLUJHa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Dec 2021 04:07:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V.JqOAz_1640077647;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V.JqOAz_1640077647)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 21 Dec 2021 17:07:27 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sfrench@samba.org, hyc.lee@gmail.com,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next 4/4] ksmbd: Fix smb2_get_name() kernel-doc comment
Date:   Tue, 21 Dec 2021 17:07:14 +0800
Message-Id: <20211221090714.122543-4-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20211221090714.122543-1-yang.lee@linux.alibaba.com>
References: <20211221090714.122543-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove some warnings found by running scripts/kernel-doc,
which is caused by using 'make W=1'.
fs/ksmbd/smb2pdu.c:623: warning: Function parameter or member
'local_nls' not described in 'smb2_get_name'
fs/ksmbd/smb2pdu.c:623: warning: Excess function parameter 'nls_table'
description in 'smb2_get_name'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1bb413537239..005668b75876 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -613,7 +613,7 @@ static void destroy_previous_session(struct ksmbd_user *user, u64 id)
  * @share:	ksmbd_share_config pointer
  * @src:	source buffer
  * @maxlen:	maxlen of source string
- * @nls_table:	nls_table pointer
+ * @local_nls:	nls_table pointer
  *
  * Return:      matching converted filename on success, otherwise error ptr
  */
-- 
2.20.1.7.g153144c

