Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D7AC00140
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Aug 2022 02:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiHCCVF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 22:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiHCCVE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 22:21:04 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2FD13D1F
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 19:21:01 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id 17so15286542pfy.0
        for <linux-cifs@vger.kernel.org>; Tue, 02 Aug 2022 19:21:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=rC3zQsZfWm5bW1BEJKTadmY+68a4s0T8rp+0fJrSbmI=;
        b=R3hVEgh0/IY9iAs+3JsIItKSRL9QsB2yQKxkniDUgp3rscCOYDevrLOmhw3sGyftaX
         UXYUiyvio7w8dVjPLNjbj1QbrrU8twnMyYcKp+0SGfZzadn96iPt4oxVO1DqbUvv1Mvg
         xMXGHwefPkci07wCXmfOkqRCziHTIThbhdLkDSJhBw2eO2jGDZ+6tKcNn3s9ev23RaXh
         RewcICk44LGDVVMKZ1Fi5BcZNj5axT5kYzBv2+nKwn6QqLzHuCIX/EOyLHSpsITP42gv
         GNSj5OO/n4AXGLVNlpa/t12QYl0UT0b+9u2CgbPH3Ud1e470jLDu9t/8nHEfyHRUMtlE
         W4GA==
X-Gm-Message-State: AJIora9D6rmtGM0JimEKlod2sST0PNak7aQHjvK4OqIvf2BFbcyvVhUi
        7kN9CNdVfAPEnFpBlgnRRPGGfZHN2Ds=
X-Google-Smtp-Source: AGRyM1s1v6MItuuhHRBo362ts7DY4LFu1Yudl6kEnUJ32dX00d/eZVJkVj+TXyZmK513yyLHYdOxtg==
X-Received: by 2002:a05:6a02:205:b0:41b:96dc:bb2a with SMTP id bh5-20020a056a02020500b0041b96dcbb2amr17916692pgb.116.1659493260818;
        Tue, 02 Aug 2022 19:21:00 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id w126-20020a626284000000b0052b7f0ff197sm11575321pfb.49.2022.08.02.19.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 19:21:00 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Long Li <longli@microsoft.com>
Subject: [PATCH] cifs: smbdirect: use the max_sge the hw reports
Date:   Wed,  3 Aug 2022 11:20:42 +0900
Message-Id: <20220803022042.10543-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In Soft-iWARP, smbdirect does not work in cifs client.
The hardcoding max_sge is large in cifs, but need smaller value for
soft-iWARP. Add SMBDIRECT_MIN_SGE macro as 6 and use the max_sge
the hw reports instead of hardcoding 16 sge's.

Cc: Tom Talpey <tom@talpey.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Long Li <longli@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/cifs/smbdirect.c | 15 ++++++++++-----
 fs/cifs/smbdirect.h |  3 ++-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5fbbec22bcc8..bb68702362f7 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1518,7 +1518,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 static struct smbd_connection *_smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr, int port)
 {
-	int rc;
+	int rc, max_sge;
 	struct smbd_connection *info;
 	struct rdma_conn_param conn_param;
 	struct ib_qp_init_attr qp_attr;
@@ -1562,13 +1562,13 @@ static struct smbd_connection *_smbd_get_connection(
 	info->max_receive_size = smbd_max_receive_size;
 	info->keep_alive_interval = smbd_keep_alive_interval;
 
-	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SGE) {
+	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MIN_SGE) {
 		log_rdma_event(ERR,
 			"warning: device max_send_sge = %d too small\n",
 			info->id->device->attrs.max_send_sge);
 		log_rdma_event(ERR, "Queue Pair creation may fail\n");
 	}
-	if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_SGE) {
+	if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MIN_SGE) {
 		log_rdma_event(ERR,
 			"warning: device max_recv_sge = %d too small\n",
 			info->id->device->attrs.max_recv_sge);
@@ -1593,13 +1593,18 @@ static struct smbd_connection *_smbd_get_connection(
 		goto alloc_cq_failed;
 	}
 
+	max_sge = min3(info->id->device->attrs.max_send_sge,
+		       info->id->device->attrs.max_recv_sge,
+		       SMBDIRECT_MAX_SGE);
+	max_sge = max(max_sge, SMBDIRECT_MIN_SGE);
+
 	memset(&qp_attr, 0, sizeof(qp_attr));
 	qp_attr.event_handler = smbd_qp_async_error_upcall;
 	qp_attr.qp_context = info;
 	qp_attr.cap.max_send_wr = info->send_credit_target;
 	qp_attr.cap.max_recv_wr = info->receive_credit_max;
-	qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SGE;
-	qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_SGE;
+	qp_attr.cap.max_send_sge = max_sge;
+	qp_attr.cap.max_recv_sge = max_sge;
 	qp_attr.cap.max_inline_data = 0;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_attr.qp_type = IB_QPT_RC;
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index a87fca82a796..8b81301e4d4c 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -225,7 +225,8 @@ struct smbd_buffer_descriptor_v1 {
 	__le32 length;
 } __packed;
 
-/* Default maximum number of SGEs in a RDMA send/recv */
+/* Default maximum/minimum number of SGEs in a RDMA send/recv */
+#define SMBDIRECT_MIN_SGE	6
 #define SMBDIRECT_MAX_SGE	16
 /* The context for a SMBD request */
 struct smbd_request {
-- 
2.25.1

