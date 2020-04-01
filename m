Return-Path: <SRS0=yC6j=5R=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B87C43331
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Apr 2020 03:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0BD420772
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Apr 2020 03:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="JrWlu3gM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbgDAD7f (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Mar 2020 23:59:35 -0400
Received: from linux.microsoft.com ([13.77.154.182]:60222 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731611AbgDAD7f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Mar 2020 23:59:35 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id EC35520B46F0; Tue, 31 Mar 2020 20:59:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC35520B46F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585713573;
        bh=T/m0cU/ovq63UEysw2DA0YMO0lHz/8HNpjFSpcuwBgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=JrWlu3gM2P4UUw+gd2HLm1FKUaYfQl1A/n0anMMSSkV4LG6U4wueIZyH2W3raYSf1
         ESQMWLx9c1n8K0c6wa4UQRWBvaCWoMF0ZAVzqguktvtc+IRzCqfBGaZp3C5+n5rtfS
         p5cTzj8W5uwGVnC/UFf4QgPPiVWohSgkmGBC1dPI=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 2/2] cifs: smbd: Do not schedule work to send immediate packet on every receive
Date:   Tue, 31 Mar 2020 20:59:23 -0700
Message-Id: <1585713563-4635-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1585713563-4635-1-git-send-email-longli@linuxonhyperv.com>
References: <1585713563-4635-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

Immediate packets should only be sent to peer when there are new
receive credits made available. New credits show up on freeing
receive buffer, not on receiving data.

Fix this by avoid unnenecessary work schedules.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 61 ++++++++-------------------------------------
 fs/cifs/smbdirect.h |  1 -
 2 files changed, 10 insertions(+), 52 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b961260a6336..6d94bc6525b7 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -380,27 +380,6 @@ static bool process_negotiation_response(
 	return true;
 }
 
-/*
- * Check and schedule to send an immediate packet
- * This is used to extend credtis to remote peer to keep the transport busy
- */
-static void check_and_send_immediate(struct smbd_connection *info)
-{
-	if (info->transport_status != SMBD_CONNECTED)
-		return;
-
-	info->send_immediate = true;
-
-	/*
-	 * Promptly send a packet if our peer is running low on receive
-	 * credits
-	 */
-	if (atomic_read(&info->receive_credits) <
-		info->receive_credit_target - 1)
-		queue_delayed_work(
-			info->workqueue, &info->send_immediate_work, 0);
-}
-
 static void smbd_post_send_credits(struct work_struct *work)
 {
 	int ret = 0;
@@ -450,8 +429,16 @@ static void smbd_post_send_credits(struct work_struct *work)
 	info->new_credits_offered += ret;
 	spin_unlock(&info->lock_new_credits_offered);
 
-	/* Check if we can post new receive and grant credits to peer */
-	check_and_send_immediate(info);
+	/* Promptly send an immediate packet as defined in [MS-SMBD] 3.1.1.1 */
+	info->send_immediate = true;
+	if (atomic_read(&info->receive_credits) <
+		info->receive_credit_target - 1) {
+		if (info->keep_alive_requested == KEEP_ALIVE_PENDING ||
+		    info->send_immediate) {
+			log_keep_alive(INFO, "send an empty message\n");
+			smbd_post_send_empty(info);
+		}
+	}
 }
 
 /* Called from softirq, when recv is done */
@@ -546,12 +533,6 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			info->keep_alive_requested = KEEP_ALIVE_PENDING;
 		}
 
-		/*
-		 * Check if we need to send something to remote peer to
-		 * grant more credits or respond to KEEP_ALIVE packet
-		 */
-		check_and_send_immediate(info);
-
 		return;
 
 	default:
@@ -1292,25 +1273,6 @@ static void destroy_receive_buffers(struct smbd_connection *info)
 		mempool_free(response, info->response_mempool);
 }
 
-/*
- * Check and send an immediate or keep alive packet
- * The condition to send those packets are defined in [MS-SMBD] 3.1.1.1
- * Connection.KeepaliveRequested and Connection.SendImmediate
- * The idea is to extend credits to server as soon as it becomes available
- */
-static void send_immediate_work(struct work_struct *work)
-{
-	struct smbd_connection *info = container_of(
-					work, struct smbd_connection,
-					send_immediate_work.work);
-
-	if (info->keep_alive_requested == KEEP_ALIVE_PENDING ||
-	    info->send_immediate) {
-		log_keep_alive(INFO, "send an empty message\n");
-		smbd_post_send_empty(info);
-	}
-}
-
 /* Implement idle connection timer [MS-SMBD] 3.1.6.2 */
 static void idle_connection_timer(struct work_struct *work)
 {
@@ -1365,8 +1327,6 @@ void smbd_destroy(struct TCP_Server_Info *server)
 
 	log_rdma_event(INFO, "cancelling idle timer\n");
 	cancel_delayed_work_sync(&info->idle_timer_work);
-	log_rdma_event(INFO, "cancelling send immediate work\n");
-	cancel_delayed_work_sync(&info->send_immediate_work);
 
 	log_rdma_event(INFO, "wait for all send posted to IB to finish\n");
 	wait_event(info->wait_send_pending,
@@ -1700,7 +1660,6 @@ static struct smbd_connection *_smbd_get_connection(
 
 	init_waitqueue_head(&info->wait_send_queue);
 	INIT_DELAYED_WORK(&info->idle_timer_work, idle_connection_timer);
-	INIT_DELAYED_WORK(&info->send_immediate_work, send_immediate_work);
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
 		info->keep_alive_interval*HZ);
 
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index 07c8f5638c39..a87fca82a796 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -153,7 +153,6 @@ struct smbd_connection {
 
 	struct workqueue_struct *workqueue;
 	struct delayed_work idle_timer_work;
-	struct delayed_work send_immediate_work;
 
 	/* Memory pool for preallocating buffers */
 	/* request pool for RDMA send */
-- 
2.17.1

