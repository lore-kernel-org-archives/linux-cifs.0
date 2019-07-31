Return-Path: <SRS0=3qap=V4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E05C433FF
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 09:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5095320693
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 09:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfGaJF2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Jul 2019 05:05:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35630 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfGaJF2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Jul 2019 05:05:28 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hskY2-0003Hf-Qu; Wed, 31 Jul 2019 09:05:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: remove redundant assignment to variable rc
Date:   Wed, 31 Jul 2019 10:05:26 +0100
Message-Id: <20190731090526.27245-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable rc is being initialized with a value that is never read
and rc is being re-assigned a little later on. The assignment is
redundant and hence can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ee5d74988a9f..a653c429e8dc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3617,7 +3617,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	  unsigned int *nbytes, char **buf, int *buf_type)
 {
 	struct smb_rqst rqst;
-	int resp_buftype, rc = -EACCES;
+	int resp_buftype, rc;
 	struct smb2_read_plain_req *req = NULL;
 	struct smb2_read_rsp *rsp = NULL;
 	struct kvec iov[1];
-- 
2.20.1

