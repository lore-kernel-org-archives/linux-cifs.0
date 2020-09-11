Return-Path: <SRS0=T1K2=CU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9FDC2BC11
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Sep 2020 03:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BCA52078D
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Sep 2020 03:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgIKD65 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Sep 2020 23:58:57 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59474 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725283AbgIKD64 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 10 Sep 2020 23:58:56 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 60F004CED601D85B6576;
        Fri, 11 Sep 2020 11:58:54 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Sep 2020
 11:58:46 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 4/5] cifs: fix comparison to bool warning in connect.c
Date:   Fri, 11 Sep 2020 12:05:38 +0800
Message-ID: <20200911040539.113307-5-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200911040539.113307-1-zhengbin13@huawei.com>
References: <20200911040539.113307-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes coccicheck warning:

fs/cifs/connect.c:2478:5-16: WARNING: Comparison to bool
fs/cifs/connect.c:3560:10-35: WARNING: Comparison to bool
fs/cifs/connect.c:4297:6-21: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 fs/cifs/connect.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a5731dd6e656..4d2651b9f019 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2475,7 +2475,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	else if (override_gid == 1)
 		pr_notice("ignoring forcegid mount option specified with no gid= option\n");

-	if (got_version == false)
+	if (!got_version)
 		pr_warn_once("No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1) specify vers=1.0 on mount.\n");

 	kfree(mountdata_copy);
@@ -3557,7 +3557,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		}
 	} else if ((tcon->capabilities & SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY)
 	     && (ses->server->capabilities & SMB2_GLOBAL_CAP_PERSISTENT_HANDLES)
-	     && (volume_info->nopersistent == false)) {
+	     && !volume_info->nopersistent) {
 		cifs_dbg(FYI, "enabling persistent handles\n");
 		tcon->use_persistent = true;
 	} else if (volume_info->resilient) {
@@ -4294,7 +4294,7 @@ static int mount_get_conns(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,

 	*nses = ses;

-	if ((vol->persistent == true) && (!(ses->server->capabilities &
+	if (vol->persistent && (!(ses->server->capabilities &
 					    SMB2_GLOBAL_CAP_PERSISTENT_HANDLES))) {
 		cifs_server_dbg(VFS, "persistent handles not supported by server\n");
 		return -EOPNOTSUPP;
--
2.26.0.106.g9fadedd

