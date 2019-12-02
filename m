Return-Path: <SRS0=UnI2=ZY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FA1C432C0
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Dec 2019 18:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C902F217D9
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Dec 2019 18:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfLBS7p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 Dec 2019 13:59:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47991 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbfLBS7o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 2 Dec 2019 13:59:44 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ibqv8-0002H8-KB; Mon, 02 Dec 2019 18:59:42 +0000
From:   Colin King <colin.king@canonical.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: remove redundant assignment to pointer pneg_ctxt
Date:   Mon,  2 Dec 2019 18:59:42 +0000
Message-Id: <20191202185942.81854-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer pneg_ctxt is being initialized with a value that is never
read and it is being updated later with a new value.  The assignment
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ed77f94dbf1d..be0de8a63e57 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -554,7 +554,7 @@ static void
 assemble_neg_contexts(struct smb2_negotiate_req *req,
 		      struct TCP_Server_Info *server, unsigned int *total_len)
 {
-	char *pneg_ctxt = (char *)req;
+	char *pneg_ctxt;
 	unsigned int ctxt_len;
 
 	if (*total_len > 200) {
-- 
2.24.0

