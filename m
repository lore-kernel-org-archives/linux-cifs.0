Return-Path: <SRS0=a8IY=5M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2188FC43331
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 05:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E39E120663
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 05:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="Gu6UK1Mw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgC0FJc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:09:32 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57928 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgC0FJc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Mar 2020 01:09:32 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 0036620B4737; Thu, 26 Mar 2020 22:09:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0036620B4737
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585285771;
        bh=c3ND34NUf+2yNKP0PiQr6f2Y1vNjYTmfNJSufeGHUkk=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=Gu6UK1MwiV52MPvi83ulp5crmQnPiywd4Naebw200vg6IU7k/iYLICIMuzpfAVIuU
         X1wVDMTfVtmeW7J4MGvAZ8RXvl3gC5csrtEh4EMVrAbValW82HTktq/O9y5Ip6FpBB
         NwdJ9VH9j6EdyeP6KHkH8A/GJMMl4v9xn2Jb5578=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH] cifs: Allocate encryption header through kmalloc
Date:   Thu, 26 Mar 2020 22:09:20 -0700
Message-Id: <1585285760-31731-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When encryption is used, smb2_transform_hdr is defined on the stack and is
passed to the transport. This doesn't work with RDMA as the buffer needs to
be DMA'ed.

Fix it by using kmalloc.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/transport.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index cb3ee916f527..c97570eb2c18 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -466,7 +466,7 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	      struct smb_rqst *rqst, int flags)
 {
 	struct kvec iov;
-	struct smb2_transform_hdr tr_hdr;
+	struct smb2_transform_hdr *tr_hdr;
 	struct smb_rqst cur_rqst[MAX_COMPOUND];
 	int rc;
 
@@ -476,28 +476,34 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	if (num_rqst > MAX_COMPOUND - 1)
 		return -ENOMEM;
 
-	memset(&cur_rqst[0], 0, sizeof(cur_rqst));
-	memset(&iov, 0, sizeof(iov));
-	memset(&tr_hdr, 0, sizeof(tr_hdr));
-
-	iov.iov_base = &tr_hdr;
-	iov.iov_len = sizeof(tr_hdr);
-	cur_rqst[0].rq_iov = &iov;
-	cur_rqst[0].rq_nvec = 1;
-
 	if (!server->ops->init_transform_rq) {
 		cifs_server_dbg(VFS, "Encryption requested but transform "
 				"callback is missing\n");
 		return -EIO;
 	}
 
+	tr_hdr = kmalloc(sizeof(*tr_hdr), GFP_NOFS);
+	if (!tr_hdr)
+		return -ENOMEM;
+
+	memset(&cur_rqst[0], 0, sizeof(cur_rqst));
+	memset(&iov, 0, sizeof(iov));
+	memset(tr_hdr, 0, sizeof(*tr_hdr));
+
+	iov.iov_base = tr_hdr;
+	iov.iov_len = sizeof(*tr_hdr);
+	cur_rqst[0].rq_iov = &iov;
+	cur_rqst[0].rq_nvec = 1;
+
 	rc = server->ops->init_transform_rq(server, num_rqst + 1,
 					    &cur_rqst[0], rqst);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = __smb_send_rqst(server, num_rqst + 1, &cur_rqst[0]);
 	smb3_free_compound_rqst(num_rqst, &cur_rqst[1]);
+out:
+	kfree(tr_hdr);
 	return rc;
 }
 
-- 
2.17.1

