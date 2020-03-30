Return-Path: <SRS0=Ex6Q=5P=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BADC2D0E5
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Mar 2020 18:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FD5420780
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Mar 2020 18:04:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="OJ2fuHRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgC3SET (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Mar 2020 14:04:19 -0400
Received: from linux.microsoft.com ([13.77.154.182]:42362 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgC3SES (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Mar 2020 14:04:18 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 6B38020B46F0; Mon, 30 Mar 2020 11:04:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6B38020B46F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585591457;
        bh=f6uuZ8AQmEmQPNxvCDcaE9ajAQMzpT8US7URBUmbX+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=OJ2fuHRDWI1KPvCxE2Rjw286mDUXEhZI+eImjVbM2bUtOENhxgueC+bFCcAF3CaVC
         5HjEOZo7M5UdrYfaxfntwnfeeQTekV4fLCxlMFWxKLaqx1JSB2d6pLS1udk5QncUSi
         QBNr6NXbXfer42QDESpKDpRZgx4CXIfiJ0mxn6fc=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 2/2] cifs: smbd: Check send queue size before posting a send
Date:   Mon, 30 Mar 2020 11:04:07 -0700
Message-Id: <1585591447-11741-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585591447-11741-1-git-send-email-longli@linuxonhyperv.com>
References: <1585591447-11741-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

Sometimes the remote peer may return more send credits than the send queue
depth. If all the send credits are used to post senasd, we may overflow the
send queue.

Fix this by checking the send queue size before posting a send.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 11 ++++++++++-
 fs/cifs/smbdirect.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 79d8dcbd0034..c7ef2d7ce0ef 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -287,6 +287,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (atomic_dec_and_test(&request->info->send_pending))
 		wake_up(&request->info->wait_send_pending);
 
+	wake_up(&request->info->wait_post_send);
 
 	mempool_free(request, request->info->request_mempool);
 }
@@ -939,7 +940,14 @@ static int smbd_post_send(struct smbd_connection *info,
 	send_wr.opcode = IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
-	atomic_inc(&info->send_pending);
+wait_sq:
+	wait_event(info->wait_post_send,
+		atomic_read(&info->send_pending) < info->send_credit_target);
+	if (unlikely(atomic_inc_return(&info->send_pending) >
+				info->send_credit_target)) {
+		atomic_dec(&info->send_pending);
+		goto wait_sq;
+	}
 
 	rc = ib_post_send(info->id->qp, &send_wr, NULL);
 	if (rc) {
@@ -1733,6 +1741,7 @@ static struct smbd_connection *_smbd_get_connection(
 	init_waitqueue_head(&info->wait_send_pending);
 	atomic_set(&info->send_pending, 0);
 
+	init_waitqueue_head(&info->wait_post_send);
 
 	INIT_WORK(&info->disconnect_work, smbd_disconnect_rdma_work);
 	INIT_WORK(&info->post_send_credits_work, smbd_post_send_credits);
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index f70c7119a456..07c8f5638c39 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -114,6 +114,7 @@ struct smbd_connection {
 	/* Activity accoutning */
 	atomic_t send_pending;
 	wait_queue_head_t wait_send_pending;
+	wait_queue_head_t wait_post_send;
 
 	/* Receive queue */
 	struct list_head receive_queue;
-- 
2.17.1

