Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1E4C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Oct 2021 12:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 825B760EBB
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Oct 2021 12:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbhJKMQY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 08:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbhJKMQX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Oct 2021 08:16:23 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9487C061570
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 05:14:23 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k23-20020a17090a591700b001976d2db364so13316956pji.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 05:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CX+u+L0X7T6ynmX3V3xF6RZtr261ahDcU71E36By+HA=;
        b=feWgGp2uzM79+qYTUQA2bvCv3G8M0PwhE7IzC/7PIABwk4nCA2MJZmosSn6MkAAQxD
         u5MvbGkqOkytUDt59eaE3O+DU5KRz4DR54FS+aIo7YbNG5dJof12JOxk3DTChGisa0Yi
         x/etctViwatSVmWqQFc61Symgb5JfH3Bwb1+l2KQIk6E/ionELAYXwABk+MeLICtixSM
         NVQ675de32Eu/uPLiwk7knZjH/zSv3WwjNzOc10VePuVmJyPGYGBS9LqZ4FDdZDmdhjF
         EpnrVu1fKLYmAw/qaM9QW73O4EcR3fJgvezxXE9GnNeOZotcNy22pTTDnq8bPtxp0wB2
         Z+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CX+u+L0X7T6ynmX3V3xF6RZtr261ahDcU71E36By+HA=;
        b=creCxaZdHQQb7CvXD+eUCWjxrifq/cy/WJ8a5ZKoYSXHfGCfRJeeqjVaQRnE1sIOCo
         I4kYByVliHnpzkXZWMxPgq0bO/QqrwvDqCyO2ZbtQPi9zTCsThVfaae8P2pBTV2m9fwh
         5a9Ci2fE0/WtvnPRmes3H5HbAl61G/9V5YPyn+VoPnfdQVHOA4gjlqq6b2qoFb5ZOlcv
         xTZQjRT0zhtYCTt6UMKkk42uMO/3XlmrMgbQHxjSMOep8yAcfEOZde74Pa0exM6hAjSS
         o0NsPiJtP2rEvBuBAGLs4A7/Q8YdpEbbY8r7gO+pxAJp74X5wgpKvKZeoPAV+fLGKyST
         KA1Q==
X-Gm-Message-State: AOAM532jCLE7tjU/D1FLpCJGvtpKjGgMuITUhXQLKAyZqhNLzUmHbeeA
        aRVKWyFApUOjhmDyyKT2DSdfzkvbz4URfu2u
X-Google-Smtp-Source: ABdhPJwVHVmTLG1TtoPQun1l+B1dtdq8n2beqNR3wbZnW+okyo478tbsHzvnUTgZhv0IkFaUI9SgrA==
X-Received: by 2002:a17:902:650c:b0:13d:baac:1da5 with SMTP id b12-20020a170902650c00b0013dbaac1da5mr24463964plk.20.1633954461776;
        Mon, 11 Oct 2021 05:14:21 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id x17sm7026486pfa.209.2021.10.11.05.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 05:14:21 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Ralph Boehme <slow@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: add buffer validation for smb direct
Date:   Mon, 11 Oct 2021 21:14:04 +0900
Message-Id: <20211011121404.26392-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add buffer validation for smb direct.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 3a7fa23ba850..18f50e06ad15 100644
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
@@ -556,9 +560,18 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	case SMB_DIRECT_MSG_DATA_TRANSFER: {
 		struct smb_direct_data_transfer *data_transfer =
 			(struct smb_direct_data_transfer *)recvmsg->packet;
-		int data_length = le32_to_cpu(data_transfer->data_length);
+		int data_length;
 		int avail_recvmsg_count, receive_credits;
 
+		if (wc->byte_len < offsetof(struct smb_direct_data_transfer, padding) ||
+		    (le32_to_cpu(data_transfer->data_length) > 0 &&
+		     wc->byte_len < sizeof(struct smb_direct_data_transfer) +
+		     le32_to_cpu(data_transfer->data_length))) {
+			put_empty_recvmsg(t, recvmsg);
+			return;
+		}
+
+		data_length = le32_to_cpu(data_transfer->data_length);
 		if (data_length) {
 			if (t->full_packet_received)
 				recvmsg->first_segment = true;
-- 
2.25.1

