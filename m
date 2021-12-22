Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C65C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Dec 2021 22:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhLVWnm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Dec 2021 17:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhLVWnl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Dec 2021 17:43:41 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4FFC061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Dec 2021 14:43:41 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id a23so3263917pgm.4
        for <linux-cifs@vger.kernel.org>; Wed, 22 Dec 2021 14:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOYUsd6iLHCd+rD7aWETdKghCzhsytnkU82xT7soRwQ=;
        b=gpKKag8rHAgdBzL36ELYaFoAjHECxu8IvHfBuhTjfN8U3SmPDohx8ynokiUMbauhvr
         tSQSZHlJfAWxZkZZ0wRHU8bG4XLozFu6Psryk1xth+OUjIDjX2BkyLz8gYGSWdrbmgeD
         cHznVPS+VVlsum6TSqsCGlIyobdPIZPhQd6PHeRhA9CtSy78xHc0CXgR0uo/pa8SaWZM
         5PcUUAc4+AqCNlbgCbE34MJ49Hfo2J7OpGaT6iywaZQK2rQlB69FxJ07MFCBSwMfVETg
         zxQ5g72BktxXP/NmIlnyrzyMXFsYj+I/oNfudg1Jp4FRY/jyLWWw3SMmiVQZsLDaWz7e
         0Lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dOYUsd6iLHCd+rD7aWETdKghCzhsytnkU82xT7soRwQ=;
        b=3N4jdPd2ozP01pyLZdLGqvpM34Ih0UqEBbnljYAs/LATdisA8wrmX9rmvhoHriJ+wN
         RKzZR4KKAd4GPFOjtzSZwI2yDRGb6SMNaWGpCeqsKwY3F1Xn4C3Y8ODagbbve/hba32J
         lLpaXYR/2VnhDzeDcDDr3fJlI+d6ksnvlD6ki8MEozagRaZi2FcPH816nfn0PlfAi3t0
         EZlVgsGrhQ+9sUwMEOuNlWLKdamSqPOfdFfx4n7IO1ruyzjeb88iwrBDgjmqgwhdaFFr
         IrXIOOc+AMGMSruj1aeVi46kGdiG0cYqIjRGhtVouFpyNwKca+nAj3NwJcLDNJ7NCo9c
         eczg==
X-Gm-Message-State: AOAM533MfEDSTPiDmQ+j0vwKQjkMx3lgeOPGJHW12IjANelYmfz2PdMM
        EaHtZma6ICdNIJJi6VONoyyVXHIFmVo=
X-Google-Smtp-Source: ABdhPJwOj+BRT/Ke74J0WV+zgr5eEENV48JjT0N3njrguAbuVv7qhUu5QkNsYF0u10mJJPhRIMSKJg==
X-Received: by 2002:a63:2:: with SMTP id 2mr4380481pga.285.1640213020285;
        Wed, 22 Dec 2021 14:43:40 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id w5sm3258201pjq.16.2021.12.22.14.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 14:43:40 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: set the rdma capability of network adapter using ib_client
Date:   Thu, 23 Dec 2021 07:43:06 +0900
Message-Id: <20211222224306.198076-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set the rdma capability using ib_clien, Because
For some devices, ib_device_get_by_netdev() returns NULL.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 89 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 83 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 7e57cbb0bb35..0820c6a9d75e 100644
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
@@ -2007,12 +2015,62 @@ static int smb_direct_listen(int port)
 	return ret;
 }
 
+static int smb_direct_ib_client_add(struct ib_device *ib_dev)
+{
+	struct smb_direct_device *smb_dev;
+
+	if (!ib_dev->ops.get_netdev ||
+	    ib_dev->node_type != RDMA_NODE_IB_CA ||
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
+};
+
 int ksmbd_rdma_init(void)
 {
 	int ret;
 
 	smb_direct_listener.cm_id = NULL;
 
+	smb_direct_ib_client.add = smb_direct_ib_client_add;
+	smb_direct_ib_client.remove = smb_direct_ib_client_remove;
+	ret = ib_register_client(&smb_direct_ib_client);
+	if (ret) {
+		pr_err("failed to ib_register_client\n");
+		return ret;
+	}
+
 	/* When a client is running out of send credits, the credits are
 	 * granted by the server's sending a packet using this queue.
 	 * This avoids the situation that a clients cannot send packets
@@ -2046,20 +2104,39 @@ int ksmbd_rdma_destroy(void)
 		destroy_workqueue(smb_direct_wq);
 		smb_direct_wq = NULL;
 	}
+
+	if (smb_direct_ib_client.add)
+		ib_unregister_client(&smb_direct_ib_client);
+	smb_direct_ib_client.add = NULL;
 	return 0;
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
 	}
+out:
+	read_unlock(&smb_direct_device_lock);
 	return rdma_capable;
 }
 
-- 
2.25.1

