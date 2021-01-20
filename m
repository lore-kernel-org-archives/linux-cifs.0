Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02DFC4321A
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Jan 2021 19:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 982CF2343F
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Jan 2021 19:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbhATTbj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:31:39 -0500
Received: from m12-11.163.com ([220.181.12.11]:51071 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392601AbhATTbJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 20 Jan 2021 14:31:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=GmQ5zC/lEW66W3IS68
        5jZUzW87/1eJkoTS7pTL5H5Os=; b=Ljzw3oaHF4qAVxFLY/iNgOTILD8OOsIllD
        c5J6uTHBh7HcyESErZgLthrvFDUuFawIq1zn1i2/2hHnmOiyqv3EjUaR6bkDvdnW
        vLTMhU0ls9W+swEVF7QZ3snGL2sngIzqnUttITfNF7RFHHPJwjzngvE63GST/N/v
        XT8m8HDuY=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp7 (Coremail) with SMTP id C8CowAAnZ2tAEwhgVz7qJg--.9638S4;
        Wed, 20 Jan 2021 19:25:57 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilovsky@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] cifs: put tlink before return
Date:   Wed, 20 Jan 2021 03:25:51 -0800
Message-Id: <20210120112551.60092-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8CowAAnZ2tAEwhgVz7qJg--.9638S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw4DtF1UCw4fKF43KFW3ZFb_yoW3Gwc_G3
        yDJr95Cr4xuryrJwsxWr4avFn5Cw4rKFyayrs7tFs8K345XFnxGrs7t3WrJFW8ZwsrZr90
        krs5GFWayr1xujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5MOJ5UUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBZwYgclet1gmpLAAAsT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Put tlink before returning error code.

Fixes: 8ceb98437946 ("CIFS: Move rename to ops struct")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 fs/cifs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a83b3a8ffaac..9c31b6178638 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2020,8 +2020,10 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-	if (!server->ops->rename)
+	if (!server->ops->rename) {
+		cifs_put_tlink(tlink);
 		return -ENOSYS;
+	}
 
 	/* try path-based rename first */
 	rc = server->ops->rename(xid, tcon, from_path, to_path, cifs_sb);
-- 
2.17.1

