Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CA1C6FA90
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Sep 2022 02:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiIZCiA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Sep 2022 22:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiIZCh2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Sep 2022 22:37:28 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE561EEE9
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 19:35:52 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MbRbF1FxlzlXVY;
        Mon, 26 Sep 2022 10:31:37 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 10:35:50 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>, <tom@talpey.com>, <linkinjeon@kernel.org>,
        <hyc.lee@gmail.com>
Subject: [PATCH v8 2/3] ksmbd: Fix wrong return value and message length check in smb2_ioctl()
Date:   Mon, 26 Sep 2022 11:36:30 +0800
Message-ID: <20220926033631.926637-3-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220926033631.926637-1-zhangxiaoxu5@huawei.com>
References: <20220926033631.926637-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Commit c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock
break, and move its struct to smbfs_common") use the defination
of 'struct validate_negotiate_info_req' in smbfs_common, the
array length of 'Dialects' changed from 1 to 4, but the protocol
does not require the client to send all 4. This lead the request
which satisfied with protocol and server to fail.

So just ensure the request payload has the 'DialectCount' in
smb2_ioctl(), then fsctl_validate_negotiate_info() will use it
to validate the payload length and each dialect.

Also when the {in, out}_buf_len is less than the required, should
goto out to initialize the status in the response header.

Fixes: f7db8fd03a4b ("ksmbd: add validation in smb2_ioctl")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/ksmbd/smb2pdu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 15c487aa19ad..22dc2facac8a 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7638,11 +7638,16 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
-			return -EINVAL;
+		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
+					  Dialects)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
-			return -EINVAL;
+		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		ret = fsctl_validate_negotiate_info(conn,
 			(struct validate_negotiate_info_req *)&req->Buffer[0],
-- 
2.31.1

