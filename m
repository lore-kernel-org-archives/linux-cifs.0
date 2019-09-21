Return-Path: <SRS0=rQDn=XQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132F2C49ED7
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Sep 2019 06:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D76352067B
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Sep 2019 06:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730993AbfIUGQI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Sep 2019 02:16:08 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34386 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730989AbfIUGQI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 21 Sep 2019 02:16:08 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3346F1E69AA13AFB05E9;
        Sat, 21 Sep 2019 14:16:01 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Sat, 21 Sep 2019
 14:15:52 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] fs/cifs/smb2transport.c: Make some functions static
Date:   Sat, 21 Sep 2019 14:22:46 +0800
Message-ID: <1569046966-118677-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix sparse warnings:

fs/cifs/smb2transport.c:52:1: warning: symbol 'smb3_crypto_shash_allocate' was not declared. Should it be static?
fs/cifs/smb2transport.c:101:4: warning: symbol 'smb2_find_chan_signkey' was not declared. Should it be static?
fs/cifs/smb2transport.c:121:17: warning: symbol 'smb2_find_global_smb_ses' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 fs/cifs/smb2transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 12988df..7cc8641 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -48,7 +48,7 @@ smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
 			       &server->secmech.sdeschmacsha256);
 }

-int
+static int
 smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p = &server->secmech;
@@ -98,7 +98,8 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 	return rc;
 }

-u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *server)
+static u8 *
+smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *server)
 {
 	int i;
 	struct cifs_chan *chan;
@@ -118,7 +119,7 @@ u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	return NULL;
 }

-struct cifs_ses *
+static struct cifs_ses *
 smb2_find_global_smb_ses(__u64 ses_id)
 {
 	struct TCP_Server_Info *server;
--
2.7.4

