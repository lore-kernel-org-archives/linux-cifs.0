Return-Path: <SRS0=gUrR=WZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53DDC3A5A1
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 00:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90FA02073F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Aug 2019 00:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfH2AAJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Aug 2019 20:00:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58253 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfH2AAJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Aug 2019 20:00:09 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i37rD-00059z-4t; Thu, 29 Aug 2019 00:00:07 +0000
From:   Colin King <colin.king@canonical.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][cifs-next] cifs: ensure variable rc is initialized at the after_open label
Date:   Thu, 29 Aug 2019 01:00:06 +0100
Message-Id: <20190829000006.24187-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A previous fix added a jump to after_open which now leaves variable
rc in a uninitialized state. A couple of the cases in the following
switch statement do not set variable rc, hence the error check on rc
at the end of the switch statement is reading a garbage value in rc
for those specific cases. Fix this by initializing rc to zero before
the switch statement.

Fixes: 955a9c5b39379 ("cifs: create a helper to find a writeable handle by path name")
Addresses-Coverity: ("Uninitialized scalar variable")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/smb2inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 70342bcd89b4..939fc7b2234c 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -116,6 +116,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_set_next_command(tcon, &rqst[num_rqst]);
  after_open:
 	num_rqst++;
+	rc = 0;
 
 	/* Operation */
 	switch (command) {
-- 
2.20.1

