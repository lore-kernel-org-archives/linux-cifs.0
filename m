Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F72C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Dec 2021 14:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbhL2OPG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Dec 2021 09:15:06 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:43561 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240165AbhL2OPG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Dec 2021 09:15:06 -0500
Received: by mail-pj1-f47.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so20049927pjw.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Dec 2021 06:15:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tC5lvHndYuwvIwdteYCb2Dn5pmmwb+ST8/R9rP/9B+Q=;
        b=mh3NnuNAlV5tiOoRzH9JGDwmI0buKXM/DBRAbhlmkt6iUd7G4XWK60kRa/8Bw+xV//
         POxgWF84iuSsuQwYPgxa2wByNV+LtwhCNMX5i3MZdsi/2ZQiZiXyurJh2QrsnPY+UCUe
         ttCloRKfXtplJapxPjJRfAtUiuEIYEQX3ol9IbeGa6nUvGe30GMuFaB23whhlQspxw9R
         ayxAmGhkS6ub/tV7vZoWScAQ+cKXp0SkXj9dK9HifaEctKDV1fV9GFzR8jXaiJrN+Ml0
         pLd/2dWnqWZHJpdLfCLo/VOAgkaCVg5K/3UXP0N0oLXs35nz0NcIs93jSClgDa7Wk25Y
         vekQ==
X-Gm-Message-State: AOAM532OakqZZ2Bwv9RLknRiYlgcXvq3zj/BX4saJP7j+uFW/fHJwGA0
        5DIM2+cYBsW+q92i2S4XeDjTp6S28q4=
X-Google-Smtp-Source: ABdhPJwCy7T61LC5l32C4tPNYUMuVKxqqtlpS/XXfCI5B2DsKJ5MkQqzTgBUruCA5mz7BYOumZwxcA==
X-Received: by 2002:a17:902:ec87:b0:149:4910:e4dd with SMTP id x7-20020a170902ec8700b001494910e4ddmr27137043plg.36.1640787305535;
        Wed, 29 Dec 2021 06:15:05 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s9sm15822287pfw.174.2021.12.29.06.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:15:05 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH 1/4] ksmbd: register ksmbd ib client with ib_register_client()
Date:   Wed, 29 Dec 2021 23:14:54 +0900
Message-Id: <20211229141457.11636-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

Register ksmbd ib client with ib_register_client() to find the rdma capable
network adapter. If ops.get_netdev(Chelsio NICs) is NULL, ksmbd will find
it using ib_device_get_by_netdev in old way.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 107 ++++++++++++++++++++++++++++++++++----
 fs/ksmbd/transport_rdma.h |   2 +-
 2 files changed, 98 insertions(+), 11 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 7e57cbb0bb35..339fa4f025f7 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -79,6 +79,14 @@ static int smb_direct_max_read_write_size = 1024 * 1024;
 
 static int smb_direct_max_outstanding_rw_ops = 8;
 
+static LIST_HEAD(smb_direct_device_list);
+static DEFINE_RWLOCK(smb_direct_device_lock);
+
+struct smb_direct_device {
+	struct ib_device	*ib_dev;
+	struct list_head	list;
+};
+
 static struct smb_direct_listener {
 	struct rdma_cm_id	*cm_id;
 } smb_direct_listener;
@@ -2007,12 +2015,61 @@ static int smb_direct_listen(int port)
 	return ret;
 }
 
+static int smb_direct_ib_client_add(struct ib_device *ib_dev)
+{
+	struct smb_direct_device *smb_dev;
+
+	if (!ib_dev->ops.get_netdev ||
+	    !rdma_frwr_is_supported(&ib_dev->attrs))
+		return 0;
+
+	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
+	if (!smb_dev)
+		return -ENOMEM;
+	smb_dev->ib_dev = ib_dev;
+
+	write_lock(&smb_direct_device_lock);
+	list_add(&smb_dev->list, &smb_direct_device_list);
+	write_unlock(&smb_direct_device_lock);
+
+	ksmbd_debug(RDMA, "ib device added: name %s\n", ib_dev->name);
+	return 0;
+}
+
+static void smb_direct_ib_client_remove(struct ib_device *ib_dev,
+					void *client_data)
+{
+	struct smb_direct_device *smb_dev, *tmp;
+
+	write_lock(&smb_direct_device_lock);
+	list_for_each_entry_safe(smb_dev, tmp, &smb_direct_device_list, list) {
+		if (smb_dev->ib_dev == ib_dev) {
+			list_del(&smb_dev->list);
+			kfree(smb_dev);
+			break;
+		}
+	}
+	write_unlock(&smb_direct_device_lock);
+}
+
+static struct ib_client smb_direct_ib_client = {
+	.name	= "ksmbd_smb_direct_ib",
+	.add	= smb_direct_ib_client_add,
+	.remove	= smb_direct_ib_client_remove,
+};
+
 int ksmbd_rdma_init(void)
 {
 	int ret;
 
 	smb_direct_listener.cm_id = NULL;
 
+	ret = ib_register_client(&smb_direct_ib_client);
+	if (ret) {
+		pr_err("failed to ib_register_client\n");
+		return ret;
+	}
+
 	/* When a client is running out of send credits, the credits are
 	 * granted by the server's sending a packet using this queue.
 	 * This avoids the situation that a clients cannot send packets
@@ -2036,30 +2093,60 @@ int ksmbd_rdma_init(void)
 	return 0;
 }
 
-int ksmbd_rdma_destroy(void)
+void ksmbd_rdma_destroy(void)
 {
-	if (smb_direct_listener.cm_id)
-		rdma_destroy_id(smb_direct_listener.cm_id);
+	if (!smb_direct_listener.cm_id)
+		return;
+
+	ib_unregister_client(&smb_direct_ib_client);
+	rdma_destroy_id(smb_direct_listener.cm_id);
+
 	smb_direct_listener.cm_id = NULL;
 
 	if (smb_direct_wq) {
 		destroy_workqueue(smb_direct_wq);
 		smb_direct_wq = NULL;
 	}
-	return 0;
 }
 
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 {
-	struct ib_device *ibdev;
+	struct smb_direct_device *smb_dev;
+	int i;
 	bool rdma_capable = false;
 
-	ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
-	if (ibdev) {
-		if (rdma_frwr_is_supported(&ibdev->attrs))
-			rdma_capable = true;
-		ib_device_put(ibdev);
+	read_lock(&smb_direct_device_lock);
+	list_for_each_entry(smb_dev, &smb_direct_device_list, list) {
+		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
+			struct net_device *ndev;
+
+			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
+							       i + 1);
+			if (!ndev)
+				continue;
+
+			if (ndev == netdev) {
+				dev_put(ndev);
+				rdma_capable = true;
+				goto out;
+			}
+			dev_put(ndev);
+		}
+	}
+out:
+	read_unlock(&smb_direct_device_lock);
+
+	if (rdma_capable == false) {
+		struct ib_device *ibdev;
+
+		ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
+		if (ibdev) {
+			if (rdma_frwr_is_supported(&ibdev->attrs))
+				rdma_capable = true;
+			ib_device_put(ibdev);
+		}
 	}
+
 	return rdma_capable;
 }
 
diff --git a/fs/ksmbd/transport_rdma.h b/fs/ksmbd/transport_rdma.h
index 0fa8adc0776f..ab9250a7cb86 100644
--- a/fs/ksmbd/transport_rdma.h
+++ b/fs/ksmbd/transport_rdma.h
@@ -52,7 +52,7 @@ struct smb_direct_data_transfer {
 
 #ifdef CONFIG_SMB_SERVER_SMBDIRECT
 int ksmbd_rdma_init(void);
-int ksmbd_rdma_destroy(void);
+void ksmbd_rdma_destroy(void);
 bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
 #else
 static inline int ksmbd_rdma_init(void) { return 0; }
-- 
2.25.1

