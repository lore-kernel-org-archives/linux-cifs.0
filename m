Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CCAC07E9C
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Jul 2021 12:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 042526044F
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Jul 2021 12:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhGFMhZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Jul 2021 08:37:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56609 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241050AbhGFMHr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Jul 2021 08:07:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1m0jp0-0007eU-7T; Tue, 06 Jul 2021 12:05:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ksmbd: Fix read on the uninitialized pointer sess
Date:   Tue,  6 Jul 2021 13:05:01 +0100
Message-Id: <20210706120501.28776-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a error handling case that passes control to label out_err
without pointer sess being assigned a value. The unassigned pointer
may be any garbage value and so the test of rc < 0 && sess maybe
true leading to sess being passed to the call to ksmbd_session_destroy.
Fix this by setting sess to NULL in this corner case.

Addresses-Coverity: ("Uninitialized pointer read")
Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ksmbd/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index dda90812feef..ad976dbbb0b6 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1615,6 +1615,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	} else if ((conn->dialect < SMB30_PROT_ID ||
 		    server_conf.flags & KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL) &&
 		   (req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
+		sess = NULL;
 		rc = -EACCES;
 		goto out_err;
 	} else {
-- 
2.31.1

