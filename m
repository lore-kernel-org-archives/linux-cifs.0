Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6EAC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Dec 2021 14:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbhL2OPI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Dec 2021 09:15:08 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:33546 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhL2OPI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Dec 2021 09:15:08 -0500
Received: by mail-pj1-f41.google.com with SMTP id g11-20020a17090a7d0b00b001b2c12c7273so37917pjl.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Dec 2021 06:15:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IbCQ9ZB8P7hM04U4HfuIm7QmPMxuv5y7Zm1gAGXuI0E=;
        b=ioSw/+qzIhQ0ycppkf9jgWOHWRWXyPRYfqqlUZasyhtSRiadg7xWCHTZ7Vdbdbs3g3
         bRATGrG5TD4KIepC1FY/zDb8zhPndhYEIDKDZEneA3bgWEgy6hh3r/kL9CDJaFZ0W+/G
         EmzTYZILxVDDNN1PS+HI8ytI5/zEZGDYumzBwwOhAG+3gqEO/ekMl1A2aAeXk9cN0o8a
         V6/Dcm3zTbU3+8OTyn9SgU5iXZwezVkPTOLTzcnxXtV3OxgvQRNZrDEaqyYQAXXNQdSl
         jkHb5JNHiCbFy0kTz6hc4Lg32bmNwE8YLWi6LegKtkzOI77VTFrE3aLSeO91j56XDL4r
         V5zQ==
X-Gm-Message-State: AOAM531ZnQOhR/REA6gw0lQDSWmycp7rQrdSMH/64W7ZvgyUPDZkhqwc
        82CXSriJx/9WNTvEtPJnNp9W6wYKbpM=
X-Google-Smtp-Source: ABdhPJyUeOh77yWizTvMdFBCnQ8bWHM20tzEO3PjoKc+5lRqpHQb78PXbX+Of+pTDgQPy24zqrQCLw==
X-Received: by 2002:a17:902:c60b:b0:149:2afe:489f with SMTP id r11-20020a170902c60b00b001492afe489fmr26157924plr.104.1640787307732;
        Wed, 29 Dec 2021 06:15:07 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s9sm15822287pfw.174.2021.12.29.06.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:15:07 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/4] ksmbd: set 445 port to smbdirect port by default
Date:   Wed, 29 Dec 2021 23:14:55 +0900
Message-Id: <20211229141457.11636-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229141457.11636-1-linkinjeon@kernel.org>
References: <20211229141457.11636-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When SMB Direct is used with iWARP, Windows use 5445 port for smb direct
port, 445 port for SMB. This patch check ib_device using ib_client to
know if NICs type is iWARP or Infiniband.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 15 ++++++++++++---
 fs/ksmbd/transport_rdma.h |  2 --
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 339fa4f025f7..f89b64e27836 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -34,7 +34,8 @@
 #include "smbstatus.h"
 #include "transport_rdma.h"
 
-#define SMB_DIRECT_PORT	5445
+#define SMB_DIRECT_PORT_IWARP		5445
+#define SMB_DIRECT_PORT_INFINIBAND	445
 
 #define SMB_DIRECT_VERSION_LE		cpu_to_le16(0x0100)
 
@@ -60,6 +61,10 @@
  * as defined in [MS-SMBD] 3.1.1.1
  * Those may change after a SMB_DIRECT negotiation
  */
+
+/* Set 445 port to SMB Direct port by default */
+static int smb_direct_port = SMB_DIRECT_PORT_INFINIBAND;
+
 /* The local peer's maximum number of credits to grant to the peer */
 static int smb_direct_receive_credit_max = 255;
 
@@ -1942,7 +1947,7 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
 
 	KSMBD_TRANS(t)->handler = kthread_run(ksmbd_conn_handler_loop,
 					      KSMBD_TRANS(t)->conn, "ksmbd:r%u",
-					      SMB_DIRECT_PORT);
+					      smb_direct_port);
 	if (IS_ERR(KSMBD_TRANS(t)->handler)) {
 		int ret = PTR_ERR(KSMBD_TRANS(t)->handler);
 
@@ -2019,6 +2024,10 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
 {
 	struct smb_direct_device *smb_dev;
 
+	/* Set 5445 port if device type is iWARP(No IB) */
+	if (ib_dev->node_type != RDMA_NODE_IB_CA)
+		smb_direct_port = SMB_DIRECT_PORT_IWARP;
+
 	if (!ib_dev->ops.get_netdev ||
 	    !rdma_frwr_is_supported(&ib_dev->attrs))
 		return 0;
@@ -2080,7 +2089,7 @@ int ksmbd_rdma_init(void)
 	if (!smb_direct_wq)
 		return -ENOMEM;
 
-	ret = smb_direct_listen(SMB_DIRECT_PORT);
+	ret = smb_direct_listen(smb_direct_port);
 	if (ret) {
 		destroy_workqueue(smb_direct_wq);
 		smb_direct_wq = NULL;
diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
index ab9250a7cb86..5567d93a6f96 100644
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -7,8 +7,6 @@
 #ifndef __KSMBD_TRANSPORT_RDMA_H__
 #define __KSMBD_TRANSPORT_RDMA_H__
 
-#define SMB_DIRECT_PORT	5445
-
 /* SMB DIRECT negotiation request packet [MS-SMBD] 2.2.1 */
 struct smb_direct_negotiate_req {
 	__le16 min_version;
-- 
2.25.1

