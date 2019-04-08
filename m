Return-Path: <SRS0=JvIj=SK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD8DC282DD
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 02:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7176E20883
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Apr 2019 02:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDHCSY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Apr 2019 22:18:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57516 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbfDHCSX (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 7 Apr 2019 22:18:23 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 36A07A87ADF7DD11B64D;
        Mon,  8 Apr 2019 10:18:21 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.408.0; Mon, 8 Apr 2019 10:18:12 +0800
From:   ZhangXiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <sfrench@samba.org>,
        <samba-technical@lists.samba.org>, <zhangxiaoxu5@huawei.com>
Subject: [PATCH v3 2/2] cifs: Fix use-after-free in SMB2_read
Date:   Mon, 8 Apr 2019 10:22:34 +0800
Message-ID: <1554690154-34236-3-git-send-email-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1554690154-34236-1-git-send-email-zhangxiaoxu5@huawei.com>
References: <1554690154-34236-1-git-send-email-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is a KASAN use-after-free:
BUG: KASAN: use-after-free in SMB2_read+0x1136/0x1190
Read of size 8 at addr ffff8880b4e45e50 by task ln/1009

Should not release the 'req' because it will use in the trace.

Fixes: eccb4422cf97(smb3: Add ftrace tracepoints for improved SMB3 debugging)

cc: stable@vger.kernel.org (v4.18+)
Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index fca5b0a..b8f7262 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3451,8 +3451,6 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	rqst.rq_nvec = 1;
 
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
-	cifs_small_buf_release(req);
-
 	rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
 
 	if (rc) {
@@ -3474,6 +3472,8 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 				    io_parms->tcon->tid, ses->Suid,
 				    io_parms->offset, io_parms->length);
 
+	cifs_small_buf_release(req);
+
 	*nbytes = le32_to_cpu(rsp->DataLength);
 	if ((*nbytes > CIFS_MAX_MSGSIZE) ||
 	    (*nbytes > io_parms->length)) {
-- 
2.7.4

