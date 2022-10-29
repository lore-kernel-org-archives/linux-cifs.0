Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817EAC433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Oct 2022 07:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJ2Hzq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Oct 2022 03:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiJ2Hzn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 Oct 2022 03:55:43 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DB46DAEC
        for <linux-cifs@vger.kernel.org>; Sat, 29 Oct 2022 00:55:38 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mzs681ZDdz15M23;
        Sat, 29 Oct 2022 15:50:40 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 15:55:36 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>, <tom@talpey.com>
Subject: [PATCH v2 3/7] cifs: Remove the redundant null pointer check in SMB2_sess_setup()
Date:   Sat, 29 Oct 2022 17:00:07 +0800
Message-ID: <20221029090011.79367-4-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221029090011.79367-1-zhangxiaoxu5@huawei.com>
References: <20221029090011.79367-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The cifs_setup_session() is the only caller of .sess_setup(),
and it's already ensure the server and sess not null, so remove
the redundant nullptr check.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/sess.c    | 5 -----
 fs/cifs/smb2pdu.c | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index e08c5f547afb..40e4dd42cc2b 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1822,11 +1822,6 @@ int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	int rc = 0;
 	struct sess_data *sess_data;
 
-	if (ses == NULL) {
-		WARN(1, "%s: ses == NULL!", __func__);
-		return -EINVAL;
-	}
-
 	sess_data = kzalloc(sizeof(struct sess_data), GFP_KERNEL);
 	if (!sess_data)
 		return -ENOMEM;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 3a0c34e43a9d..5cda7f029b60 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1676,11 +1676,6 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 
 	cifs_dbg(FYI, "Session Setup\n");
 
-	if (!server) {
-		WARN(1, "%s: server is NULL!\n", __func__);
-		return -EIO;
-	}
-
 	sess_data = kzalloc(sizeof(struct SMB2_sess_data), GFP_KERNEL);
 	if (!sess_data)
 		return -ENOMEM;
-- 
2.31.1

