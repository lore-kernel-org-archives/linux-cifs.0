Return-Path: <SRS0=/7KZ=2P=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982F2C2D0D0
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Dec 2019 03:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 790482063A
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Dec 2019 03:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfLYDXL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Dec 2019 22:23:11 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbfLYDXK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Dec 2019 22:23:10 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 57B48A10080D804759C0;
        Wed, 25 Dec 2019 11:23:08 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Wed, 25 Dec 2019
 11:23:01 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH 1/2] fs/cifs/smb2ops.c: use true,false for bool variable
Date:   Wed, 25 Dec 2019 11:30:20 +0800
Message-ID: <1577244621-117474-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577244621-117474-1-git-send-email-zhengbin13@huawei.com>
References: <1577244621-117474-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes coccicheck warning:

fs/cifs/smb2ops.c:807:2-36: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6250370..2c50022 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -804,7 +804,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 				sizeof(struct smb2_file_all_info),
 				&rsp_iov[1], sizeof(struct smb2_file_all_info),
 				(char *)&tcon->crfid.file_all_info))
-		tcon->crfid.file_all_info_is_valid = 1;
+		tcon->crfid.file_all_info_is_valid = true;

 oshr_exit:
 	mutex_unlock(&tcon->crfid.fid_mutex);
--
2.7.4

