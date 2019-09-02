Return-Path: <SRS0=HOJ7=W5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC60CC3A59E
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Sep 2019 15:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB58B217D7
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Sep 2019 15:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731700AbfIBPLC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 Sep 2019 11:11:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42056 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbfIBPLC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 2 Sep 2019 11:11:02 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i4nyu-0000hR-7J; Mon, 02 Sep 2019 15:11:00 +0000
From:   Colin King <colin.king@canonical.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2][cifs-next] cifs: fix dereference on ses before it is null checked
Date:   Mon,  2 Sep 2019 16:10:59 +0100
Message-Id: <20190902151059.22088-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The assignment of pointer server dereferences pointer ses, however,
this dereference occurs before ses is null checked and hence we
have a potential null pointer dereference.  Fix this by only
dereferencing ses after it has been null checked.

Addresses-Coverity: ("Dereference before null check")
Fixes: 2808c6639104 ("cifs: add new debugging macro cifs_server_dbg")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifs/smb2pdu.c   | 11 ++++++++---
 fs/cifs/transport.c |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index dbc6ef50dd45..0e92983de0b7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2759,8 +2759,10 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	else
 		return -EIO;
 
+	if (!ses)
+		return -EIO;
 	server = ses->server;
-	if (!ses || !(server))
+	if (!server)
 		return -EIO;
 
 	if (smb3_encryption_required(tcon))
@@ -3058,13 +3060,16 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int resp_buftype = CIFS_NO_BUFFER;
 	struct cifs_ses *ses = tcon->ses;
-	struct TCP_Server_Info *server = ses->server;
+	struct TCP_Server_Info *server;
 	int flags = 0;
 	bool allocated = false;
 
 	cifs_dbg(FYI, "Query Info\n");
 
-	if (!ses || !(server))
+	if (!ses)
+		return -EIO;
+	server = ses->server;
+	if (!server)
 		return -EIO;
 
 	if (smb3_encryption_required(tcon))
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0d60bd2f4dca..a90bd4d75b4d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -1242,12 +1242,13 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	struct kvec iov = { .iov_base = in_buf, .iov_len = len };
 	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
-	struct TCP_Server_Info *server = ses->server;
+	struct TCP_Server_Info *server;
 
 	if (ses == NULL) {
 		cifs_dbg(VFS, "Null smb session\n");
 		return -EIO;
 	}
+	server = ses->server;
 	if (server == NULL) {
 		cifs_dbg(VFS, "Null tcp session\n");
 		return -EIO;
-- 
2.20.1

