Return-Path: <SRS0=252I=57=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21B7C2BB55
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Apr 2020 12:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A0EE20737
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Apr 2020 12:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586952690;
	bh=k8xYy+LMBvtR9vGrgEP7ljRQZTei9c9KafyXYKHGOAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=F/q14bJgjBl2cgLyXEEJj12yhDFQKIeRmj52o/tzCLSyj4jF6J9Zu1sNr5uDyxcwL
	 WrJjQ4RzPF7jma3y2X5G3tntUHujjxIA1HJs8NfOxIxW1SXOp5x0Gys0jiYWtwqZbL
	 K1Q+eKCNFSDAHHIVGPzKphrhhkrt2CcjDuc7lOkk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409325AbgDOLqp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Apr 2020 07:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409314AbgDOLqm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 15 Apr 2020 07:46:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 307E121734;
        Wed, 15 Apr 2020 11:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951201;
        bh=k8xYy+LMBvtR9vGrgEP7ljRQZTei9c9KafyXYKHGOAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvd12+5pB72wixG2pSVhp0vumfO7LtxpG/vzGrdKPTUq0TmEWS9Liw5/rtpC/JXFs
         uSSPIFDE7I8NF5NKJDtBd9pDNISrIzoUEE2OPQBBrQvE60YwJfFIBg/AeBDNnjhsW3
         Mroi8fr8EgHz4DQ/k9HYoOLuAr0nAgJrh74R70K0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.19 16/40] cifs: Allocate encryption header through kmalloc
Date:   Wed, 15 Apr 2020 07:45:59 -0400
Message-Id: <20200415114623.14972-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114623.14972-1-sashal@kernel.org>
References: <20200415114623.14972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

[ Upstream commit 3946d0d04bb360acca72db5efe9ae8440012d9dc ]

When encryption is used, smb2_transform_hdr is defined on the stack and is
passed to the transport. This doesn't work with RDMA as the buffer needs to
be DMA'ed.

Fix it by using kmalloc.

Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/transport.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0c4df56c825ab..70412944b267d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -392,7 +392,7 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	      struct smb_rqst *rqst, int flags)
 {
 	struct kvec iov;
-	struct smb2_transform_hdr tr_hdr;
+	struct smb2_transform_hdr *tr_hdr;
 	struct smb_rqst cur_rqst[MAX_COMPOUND];
 	int rc;
 
@@ -402,28 +402,34 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
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
 		cifs_dbg(VFS, "Encryption requested but transform callback "
 			 "is missing\n");
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
2.20.1

