Return-Path: <SRS0=T25Y=5S=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F7FC2BA12
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Apr 2020 20:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 600B8206E9
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Apr 2020 20:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="F3CHGz/r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388218AbgDBUmL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Apr 2020 16:42:11 -0400
Received: from linux.microsoft.com ([13.77.154.182]:34192 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgDBUmL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Apr 2020 16:42:11 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 04F1620B46F0; Thu,  2 Apr 2020 13:42:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 04F1620B46F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585860130;
        bh=T7M811vVoO8LHYy+OccoE+fza63+weNdKO1rucXW+T4=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=F3CHGz/rYb1cNT869Csn98lvD2yLrx7hJ8tKWAjWcZtzOy8+NhsYkI52KR413hW/Q
         MLYPu5KzCG6P/hwB+UFpdVxVXYTLtsvrqb8zKZNYuW2Jl1PAL7TyKWGSvB03RcKpsv
         peb8i9FKM1vutcerJsv4Y6rJzGKVNJvFpcOPqGoc=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [Patch v2] cifs: smbd: Update receive credits before sending and deal with credits roll back on failure before sending
Date:   Thu,  2 Apr 2020 13:42:06 -0700
Message-Id: <1585860126-72170-1-git-send-email-longli@linuxonhyperv.com>
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
Reported-by: kbuild test robot <lkp@intel.com>
---

change in v2: fixed sparse errors reported by kbuild test robot

 fs/cifs/smbdirect.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index c7ef2d7ce0ef..fa52bf3e0236 100644
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
@@ -822,6 +820,7 @@ static int smbd_create_header(struct smbd_connection *info,
 	struct smbd_request *request;
 	struct smbd_data_transfer *packet;
 	int header_length;
+	int new_credits;
 	int rc;
 
 	/* Wait for send credits. A SMBD packet needs one credit */
@@ -840,7 +839,7 @@ static int smbd_create_header(struct smbd_connection *info,
 	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
 	if (!request) {
 		rc = -ENOMEM;
-		goto err;
+		goto err_alloc;
 	}
 
 	request->info = info;
@@ -848,8 +847,11 @@ static int smbd_create_header(struct smbd_connection *info,
 	/* Fill in the packet header */
 	packet = smbd_request_payload(request);
 	packet->credits_requested = cpu_to_le16(info->send_credit_target);
-	packet->credits_granted =
-		cpu_to_le16(manage_credits_prior_sending(info));
+
+	new_credits = manage_credits_prior_sending(info);
+	atomic_add(new_credits, &info->receive_credits);
+	packet->credits_granted = cpu_to_le16(new_credits);
+
 	info->send_immediate = false;
 
 	packet->flags = 0;
@@ -887,7 +889,7 @@ static int smbd_create_header(struct smbd_connection *info,
 	if (ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
 		mempool_free(request, info->request_mempool);
 		rc = -EIO;
-		goto err;
+		goto err_dma;
 	}
 
 	request->sge[0].length = header_length;
@@ -896,8 +898,17 @@ static int smbd_create_header(struct smbd_connection *info,
 	*request_out = request;
 	return 0;
 
-err:
+err_dma:
+	/* roll back receive credits */
+	spin_lock(&info->lock_new_credits_offered);
+	info->new_credits_offered += new_credits;
+	spin_unlock(&info->lock_new_credits_offered);
+	atomic_sub(new_credits, &info->receive_credits);
+
+err_alloc:
+	/* roll back send credits */
 	atomic_inc(&info->send_credits);
+
 	return rc;
 }
 
-- 
2.17.1

