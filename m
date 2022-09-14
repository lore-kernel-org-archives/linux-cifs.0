Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFA9C6FA8B
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 01:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiINBQ6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 21:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiINBQ4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 21:16:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653DA61D40
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 18:16:55 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MS2Q02636zlVk4;
        Wed, 14 Sep 2022 09:12:56 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 09:16:53 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>, <tom@talpey.com>, <linkinjeon@kernel.org>,
        <hyc.lee@gmail.com>
Subject: [PATCH v6 3/5] ksmbd: Fix FSCTL_VALIDATE_NEGOTIATE_INFO message length check in smb2_ioctl()
Date:   Wed, 14 Sep 2022 10:17:39 +0800
Message-ID: <20220914021741.2672982-4-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
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

The structure size includes 4 dialect slots, but the protocol does not
require the client to send all 4. So this allows the negotiation to not
fail.

Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and move its struct to smbfs_common")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: <stable@vger.kernel.org>
---
 fs/ksmbd/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b56d7688ccf1..09ae601e64f9 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7640,7 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len < sizeof(struct validate_negotiate_info_req)) {
+		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
+					  Dialects)) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.31.1

