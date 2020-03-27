Return-Path: <SRS0=a8IY=5M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD64C43331
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 05:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 781E320714
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Mar 2020 05:33:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="Pw7xdQOg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgC0FdR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:33:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38140 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgC0FdQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Mar 2020 01:33:16 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 4D4D220B4737; Thu, 26 Mar 2020 22:33:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D4D220B4737
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1585287195;
        bh=p8YGRod+AoZSOG+yxhDi9CuAIYPiAdJpgka/fXNPphE=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=Pw7xdQOgpEi/d7fkjjLUDr9c3giKGLWFJXVjlaWVukxdgRRM5roPWEdwwKWq22+FU
         QwkOue/d53Gs8nZtihhHrTZmzEB0UDl7P1b0EsLiEC1vn+76G0rAKlHgrgR3/jRE27
         dqDVJgkbwrpu/fGAG6nZT93ZUIpmrhxwdtEPzQlc=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH] cifs: smbd: Check and extend sender credits in interrupt context
Date:   Thu, 26 Mar 2020 22:33:01 -0700
Message-Id: <1585287181-35333-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When a RDMA packet is received and server is extending send credits, we should
check and unblock senders immediately in IRQ context. Doing it in a worker
queue causes unnecessary delay and doesn't save much CPU on the receive path.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 38 +++++++++++++++-----------------------
 fs/cifs/smbdirect.h |  1 -
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index a6ae29b3c4e7..8da43a500686 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -459,25 +459,6 @@ static void smbd_post_send_credits(struct work_struct *work)
 	check_and_send_immediate(info);
 }
 
-static void smbd_recv_done_work(struct work_struct *work)
-{
-	struct smbd_connection *info =
-		container_of(work, struct smbd_connection, recv_done_work);
-
-	/*
-	 * We may have new send credits granted from remote peer
-	 * If any sender is blcoked on lack of credets, unblock it
-	 */
-	if (atomic_read(&info->send_credits))
-		wake_up_interruptible(&info->wait_send_queue);
-
-	/*
-	 * Check if we need to send something to remote peer to
-	 * grant more credits or respond to KEEP_ALIVE packet
-	 */
-	check_and_send_immediate(info);
-}
-
 /* Called from softirq, when recv is done */
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
@@ -546,8 +527,15 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		atomic_dec(&info->receive_credits);
 		info->receive_credit_target =
 			le16_to_cpu(data_transfer->credits_requested);
-		atomic_add(le16_to_cpu(data_transfer->credits_granted),
-			&info->send_credits);
+		if (le16_to_cpu(data_transfer->credits_granted)) {
+			atomic_add(le16_to_cpu(data_transfer->credits_granted),
+				&info->send_credits);
+			/*
+			 * We have new send credits granted from remote peer
+			 * If any sender is waiting for credits, unblock it
+			 */
+			wake_up_interruptible(&info->wait_send_queue);
+		}
 
 		log_incoming(INFO, "data flags %d data_offset %d "
 			"data_length %d remaining_data_length %d\n",
@@ -563,7 +551,12 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			info->keep_alive_requested = KEEP_ALIVE_PENDING;
 		}
 
-		queue_work(info->workqueue, &info->recv_done_work);
+		/*
+		 * Check if we need to send something to remote peer to
+		 * grant more credits or respond to KEEP_ALIVE packet
+		 */
+		check_and_send_immediate(info);
+
 		return;
 
 	default:
@@ -1762,7 +1755,6 @@ static struct smbd_connection *_smbd_get_connection(
 	atomic_set(&info->send_payload_pending, 0);
 
 	INIT_WORK(&info->disconnect_work, smbd_disconnect_rdma_work);
-	INIT_WORK(&info->recv_done_work, smbd_recv_done_work);
 	INIT_WORK(&info->post_send_credits_work, smbd_post_send_credits);
 	info->new_credits_offered = 0;
 	spin_lock_init(&info->lock_new_credits_offered);
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index 6ff880a1e186..8ede915f2b24 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -67,7 +67,6 @@ struct smbd_connection {
 	bool negotiate_done;
 
 	struct work_struct disconnect_work;
-	struct work_struct recv_done_work;
 	struct work_struct post_send_credits_work;
 
 	spinlock_t lock_new_credits_offered;
-- 
2.17.1

