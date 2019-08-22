Return-Path: <SRS0=yfix=WS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E5FC3A59D
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Aug 2019 04:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7322F2145D
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Aug 2019 04:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfHVEKm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Aug 2019 00:10:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33970 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726065AbfHVEKm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Aug 2019 00:10:42 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C943F3047CD69B62E84D;
        Thu, 22 Aug 2019 12:10:36 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 12:10:30 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <sfrench@samba.org>, <linux-cifs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] fs/cifs/cifsacl.c: remove set but not used variables 'rc'
Date:   Thu, 22 Aug 2019 12:17:01 +0800
Message-ID: <1566447421-16203-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

fs/cifs/cifsacl.c: In function sid_to_id:
fs/cifs/cifsacl.c:347:6: warning: variable rc set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 fs/cifs/cifsacl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 1d377b7..2b34337 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -344,7 +344,6 @@ static int
 sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 		struct cifs_fattr *fattr, uint sidtype)
 {
-	int rc;
 	struct key *sidkey;
 	char *sidstr;
 	const struct cred *saved_cred;
@@ -405,7 +404,6 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	saved_cred = override_creds(root_cred);
 	sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
 	if (IS_ERR(sidkey)) {
-		rc = -EINVAL;
 		cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
 			 __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
 		goto out_revert_creds;
@@ -418,7 +416,6 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	 */
 	BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
 	if (sidkey->datalen != sizeof(uid_t)) {
-		rc = -EIO;
 		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
 			 __func__, sidkey->datalen);
 		key_invalidate(sidkey);
--
2.7.4

