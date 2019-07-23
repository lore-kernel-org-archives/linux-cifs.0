Return-Path: <SRS0=4+wV=VU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B26C7618B
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jul 2019 15:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 892A3218F0
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jul 2019 15:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388274AbfGWPOU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Jul 2019 11:14:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56722 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbfGWPOU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Jul 2019 11:14:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hpwPn-0007iA-Lq; Tue, 23 Jul 2019 15:09:19 +0000
From:   Colin King <colin.king@canonical.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: cifs: cifsssmb: remove redundant assignment to variable ret
Date:   Tue, 23 Jul 2019 16:09:19 +0100
Message-Id: <20190723150919.15929-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being initialized however this is never read
and later it is being reassigned to a new value. The initialization
is redundant and hence can be removed.

Addresses-Coverity: ("Unused Value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e2f95965065d..4bc21e7fd6b4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1405,7 +1405,7 @@ int
 CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 	  FILE_ALL_INFO *buf)
 {
-	int rc = -EACCES;
+	int rc;
 	OPEN_REQ *req = NULL;
 	OPEN_RSP *rsp = NULL;
 	int bytes_returned;
-- 
2.20.1

