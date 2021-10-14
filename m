Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8194C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 21:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 909E16109E
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 21:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbhJNVFO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Oct 2021 17:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbhJNVFN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Oct 2021 17:05:13 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AD4C061570
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 14:03:08 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s1so3180953plg.12
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 14:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qggdj5QoS4roiUGx8vc1yCFSq9Xcau2q6FANWnw9iz8=;
        b=k22xwgu4AI8jafK58Y7WaW3V5EVPQIrbsFlNd0Pi79CUQ2HZfn4hJw8WTnr6+IZ1/W
         7ovvzV03tZzLkTouXi6ywxOCJZ6scPNJ7NhugvSWC1gtq7nCmFnDE6aLUryuSqpJgXm0
         K2q460XFV1GF5CTwgMv9xa/0YxNDGb9/uYToMHAoXXH9l0YwEJJvMFT+eay2VBNxCnr6
         qMvmMt4YQat8R88w4HbrlXV379yAQHhHr0c602M7P2bckFtGSbCoNuDXyZccqrubukD6
         Ni5LIK+iDLcmMG7LAtV/kpyQX+lE8EphhiTOXKrnfmX3iSj2XMRFC5cY6glit8+dfW1+
         z61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qggdj5QoS4roiUGx8vc1yCFSq9Xcau2q6FANWnw9iz8=;
        b=RDMVY/uwZIbi3eKRMA9+1qYBl9OEhyZPJmwjE2i36AhbU9pQw90X3kwIwSDaAo+4vt
         Qrqlf0hpts4mgixSS4r9APA9+ny4pyRsfOBhRHxHQEDjCbi1A7nMbcfo17bCATPoMeup
         V0zep/E4Spg1uAuUN5QyYAWBS/dqPSWT3bxqSI1HatpraX+f9TTstuaOg2QHvRrLQbJT
         Si+stZHbHO26BJNN/rN3IP+Ek9TSkp99HAWoeAw/UddYyhjk106Ns94ojFlWjozYeEeA
         27uKxxnu99PTTt6gczw7FhIfXkS2NgBiIKPEhYWiUIh3qg+G5jNY9qYOl580/4d0r8/N
         ScWA==
X-Gm-Message-State: AOAM532nYyCJUNbty3UVXTwXA+nOaowItxAwddnQuYqR4Witq64hWAqi
        w0YXg3T9kINPoKRkThQCJhXfBLJyTsm1pFHp
X-Google-Smtp-Source: ABdhPJxAKgYCRaui9aWUGikGRCBHiG+TagbEbqGvVbOwLbHSDphMpUygNzI6GOIXrX4jbMiaNuNq8A==
X-Received: by 2002:a17:90b:2493:: with SMTP id nt19mr23638772pjb.78.1634245387564;
        Thu, 14 Oct 2021 14:03:07 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id a67sm3248130pfa.128.2021.10.14.14.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 14:03:07 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v2] ksmbd: add buffer validation for smb direct
Date:   Fri, 15 Oct 2021 06:02:50 +0900
Message-Id: <20211014210250.119723-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add buffer validation for smb direct.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
Changes from v1:
 - Change the data type of data_length to unsigned int.
 - To avoid integer overflow, convert the data type of data_length
   to u64 in comparision.
 - Remove duplicate le32_to_cpu() calls.

 fs/ksmbd/transport_rdma.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 3a7fa23ba850..a2fd5a4d4cd5 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -549,6 +549,10 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 	switch (recvmsg->type) {
 	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
+		if (wc->byte_len < sizeof(struct smb_direct_negotiate_req)) {
+			put_empty_recvmsg(t, recvmsg);
+			return;
+		}
 		t->negotiation_requested = true;
 		t->full_packet_received = true;
 		wake_up_interruptible(&t->wait_status);
@@ -556,10 +560,23 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
-		int data_length = le32_to_cpu(data_transfer->data_length);
+		unsigned int data_length;
 		int avail_recvmsg_count, receive_credits;
 
+		if (wc->byte_len <
+		    offsetof(struct smb_direct_data_transfer, padding)) {
+			put_empty_recvmsg(t, recvmsg);
+			return;
+		}
+
+		data_length = le32_to_cpu(data_transfer->data_length);
 		if (data_length) {
+			if (wc->byte_len < sizeof(struct smb_direct_data_transfer) +
+			    (u64)data_length) {
+				put_empty_recvmsg(t, recvmsg);
+				return;
+			}
+
 			if (t->full_packet_received)
 				recvmsg->first_segment = true;
 
@@ -568,7 +585,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			else
 				t->full_packet_received = true;
 
-			enqueue_reassembly(t, recvmsg, data_length);
+			enqueue_reassembly(t, recvmsg, (int)data_length);
 			wake_up_interruptible(&t->wait_reassembly_queue);
 
 			spin_lock(&t->receive_credit_lock);
-- 
2.25.1

