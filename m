Return-Path: <SRS0=r70z=SI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9E4C282DC
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Apr 2019 07:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B1321855
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Apr 2019 07:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfDFHnb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Apr 2019 03:43:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38348 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbfDFHnb (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 6 Apr 2019 03:43:31 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 539C53F56B895F2877CC;
        Sat,  6 Apr 2019 15:43:28 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.408.0; Sat, 6 Apr 2019 15:43:20 +0800
From:   ZhangXiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <sfrench@samba.org>,
        <samba-technical@lists.samba.org>, <zhangxiaoxu5@huawei.com>
Subject: [PATCH v2 1/2] cifs: Fix use-after-free in SMB2_write
Date:   Sat, 6 Apr 2019 15:47:38 +0800
Message-ID: <1554536859-139778-2-git-send-email-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1554536859-139778-1-git-send-email-zhangxiaoxu5@huawei.com>
References: <1554536859-139778-1-git-send-email-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is a KASAN use-after-free:
BUG: KASAN: use-after-free in SMB2_write+0x1342/0x1580
Read of size 8 at addr ffff8880b6a8e450 by task ln/4196

Should not release the 'req' because it will use in the trace.

Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugging)

Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 21ac19f..6cf4e88 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3752,7 +3752,6 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	rc = cifs_send_recv(xid, io_parms->tcon->ses, &rqst,
 			    &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(req);
 	rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;
 
 	if (rc) {
@@ -3770,6 +3769,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 				     io_parms->offset, *nbytes);
 	}
 
+	cifs_small_buf_release(req);
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
-- 
2.7.4

