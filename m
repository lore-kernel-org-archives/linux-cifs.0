Return-Path: <SRS0=Gt6D=5Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AF0C43331
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Mar 2020 07:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E5720771
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Mar 2020 07:18:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="rMSDw//j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgCaHSZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Mar 2020 03:18:25 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41590 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729819AbgCaHSZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Mar 2020 03:18:25 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 74EC520B46F0; Tue, 31 Mar 2020 00:18:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 74EC520B46F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585639104;
        bh=Zh/cLcI+Ah3wcuYsIdpQ01rlvOu5+wS8MBqhfVdQiOU=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=rMSDw//jQGt+IvEV719WbBHeCl6MGjNajTHyFvacQFtTY/DT9pxa2zKdgFcSYWGZe
         n/k3RKEQjEGghDm8r4kt3bS7kywxAXjsM2h9ThIFMnHaY2GKaZRYnzf2zyXA3w3/8H
         g3Mjy6gf1Jso3yxSLm1ri6gj53hdeWhjeO1hVHCE=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH] cifs: smbd: Update receive credits before sending and deal with credits roll back on failure before sending
Date:   Tue, 31 Mar 2020 00:18:21 -0700
Message-Id: <1585639101-117035-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

Recevie credits should be updated before sending the packet, not
before a work is scheduled. Also, the value needs roll back if
something fails and cannot send.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index c7ef2d7ce0ef..bdae6d41748c 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -450,8 +450,6 @@ static void smbd_post_send_credits(struct work_struct *work)
 	info->new_credits_offered += ret;
 	spin_unlock(&info->lock_new_credits_offered);
 
-	atomic_add(ret, &info->receive_credits);
-
 	/* Check if we can post new receive and grant credits to peer */
 	check_and_send_immediate(info);
 }
@@ -840,7 +838,7 @@ static int smbd_create_header(struct smbd_connection *info,
 	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
 	if (!request) {
 		rc = -ENOMEM;
-		goto err;
+		goto err_alloc;
 	}
 
 	request->info = info;
@@ -851,6 +849,7 @@ static int smbd_create_header(struct smbd_connection *info,
 	packet->credits_granted =
 		cpu_to_le16(manage_credits_prior_sending(info));
 	info->send_immediate = false;
+	atomic_add(packet->credits_granted, &info->receive_credits);
 
 	packet->flags = 0;
 	if (manage_keep_alive_before_sending(info))
@@ -887,7 +886,7 @@ static int smbd_create_header(struct smbd_connection *info,
 	if (ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
 		mempool_free(request, info->request_mempool);
 		rc = -EIO;
-		goto err;
+		goto err_dma;
 	}
 
 	request->sge[0].length = header_length;
@@ -896,8 +895,17 @@ static int smbd_create_header(struct smbd_connection *info,
 	*request_out = request;
 	return 0;
 
-err:
+err_dma:
+	/* roll back receive credits */
+	spin_lock(&info->lock_new_credits_offered);
+	info->new_credits_offered += packet->credits_granted;
+	spin_unlock(&info->lock_new_credits_offered);
+	atomic_sub(packet->credits_granted, &info->receive_credits);
+
+err_alloc:
+	/* roll back send credits */
 	atomic_inc(&info->send_credits);
+
 	return rc;
 }
 
-- 
2.17.1

