Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE1CEB64DD
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Jul 2023 03:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjG2Dkm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 23:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjG2Dkk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 23:40:40 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F172723
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 20:40:39 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RCVbl0rYQzVjbn;
        Sat, 29 Jul 2023 11:38:59 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 29 Jul 2023 11:40:36 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <linkinjeon@kernel.org>, <sfrench@samba.org>
CC:     <linux-cifs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH] ksmbd: validate command request size
Date:   Sat, 29 Jul 2023 11:36:18 +0800
Message-ID: <20230729033618.3330897-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In commit 2b9b8f3b68ed ("ksmbd: validate command payload size"), except
for SMB2_OPLOCK_BREAK_HE command, the request size of other commands
is not checked, it's not expected. Fix it by add check for request
size of other commands.

Fixes: 2b9b8f3b68ed ("ksmbd: validate command payload size")
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/smb/server/smb2misc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index 33b7e6c4ceff..e881df1d10cb 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -380,13 +380,13 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 	}
 
 	if (smb2_req_struct_sizes[command] != pdu->StructureSize2) {
-		if (command == SMB2_OPLOCK_BREAK_HE &&
-		    le16_to_cpu(pdu->StructureSize2) != OP_BREAK_STRUCT_SIZE_20 &&
-		    le16_to_cpu(pdu->StructureSize2) != OP_BREAK_STRUCT_SIZE_21) {
+		if (!(command == SMB2_OPLOCK_BREAK_HE &&
+		    (le16_to_cpu(pdu->StructureSize2) == OP_BREAK_STRUCT_SIZE_20 ||
+		    le16_to_cpu(pdu->StructureSize2) == OP_BREAK_STRUCT_SIZE_21))) {
 			/* special case for SMB2.1 lease break message */
 			ksmbd_debug(SMB,
-				    "Illegal request size %d for oplock break\n",
-				    le16_to_cpu(pdu->StructureSize2));
+				"Illegal request size %u for command %d\n",
+				le16_to_cpu(pdu->StructureSize2), command);
 			return 1;
 		}
 	}
-- 
2.31.1

