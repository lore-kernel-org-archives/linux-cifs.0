Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C42CDB47E
	for <linux-cifs@archiver.kernel.org>; Sun, 15 Oct 2023 14:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjJOOp6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Oct 2023 10:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjJOOp6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Oct 2023 10:45:58 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D74C5
        for <linux-cifs@vger.kernel.org>; Sun, 15 Oct 2023 07:45:55 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c9e95aa02dso20550385ad.0
        for <linux-cifs@vger.kernel.org>; Sun, 15 Oct 2023 07:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697381154; x=1697985954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0MqiRZ802aB7bIXDvDpnVMpNS5vhsyYtdlDFyH6fIRw=;
        b=Tb8VdMo68Zs8IB2/5dgyvGKys6pBLpGv40se8x3PdSszLjNTczDwOllOGmRfcxB+yy
         LsaX7woPDV/iRMXnzajaCIN7K0TLUdfWZ4CgvDxU7vtILBeSre5VIS3vfrfKakAG4mAd
         vcG835Zg5Tvs7H4qrzzmCK8waaQNBbNqHxHt9KZNCbnope1rFM+BLbX3ZRewAXprZ09B
         u/4Fm7B2IPtIEui24JQY5ZvIIQcF2wVBDyDEPdlT36xaA306qyXk25K9ETq8w4dL9t3A
         wp5vMRnjUI8bPx3TjA0Y90ymPHCSiMw+Q7OoTOnjZg6sM4BrgBXFMvC7Ut0kuB1yWASy
         HI8A==
X-Gm-Message-State: AOJu0YxgzqfFMKIGb6K/yuJqc2Ae7g9154qMmYzJY2I21A0MB/I/+zDF
        CAS+/dWFR3Vs4iiZs+5NNWvXkQXo9WU=
X-Google-Smtp-Source: AGHT+IHVxCw0QE69Yn3CcjOjlf26r9H2tJ74OiinQJW52754/nK6GVgEVcADFGBKUlD+clQRWGVFaA==
X-Received: by 2002:a17:902:d486:b0:1c6:11ca:8861 with SMTP id c6-20020a170902d48600b001c611ca8861mr8386637plg.21.1697381154168;
        Sun, 15 Oct 2023 07:45:54 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id ja20-20020a170902efd400b001c1f4edfb9csm6899043plb.173.2023.10.15.07.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Oct 2023 07:45:53 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Kangjing Huang <huangkangjing@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: fix missing RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()
Date:   Sun, 15 Oct 2023 23:45:36 +0900
Message-Id: <20231015144536.9100-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Kangjing Huang <huangkangjing@gmail.com>

Physical ib_device does not have an underlying net_device, thus its
association with IPoIB net_device cannot be retrieved via
ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
ib_device port GUID from the lower 16 bytes of the hardware addresses on
IPoIB net_device and match its underlying ib_device using ib_find_gid()

Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_rdma.c | 39 +++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 3b269e1f523a..a82131f7dd83 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
 	if (ib_dev->node_type != RDMA_NODE_IB_CA)
 		smb_direct_port = SMB_DIRECT_PORT_IWARP;
 
-	if (!ib_dev->ops.get_netdev ||
-	    !rdma_frwr_is_supported(&ib_dev->attrs))
+	if (!rdma_frwr_is_supported(&ib_dev->attrs))
 		return 0;
 
 	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
@@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
 			struct net_device *ndev;
 
-			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
-							       i + 1);
-			if (!ndev)
-				continue;
+			/* RoCE and iWRAP ib_dev is backed by a netdev */
+			if (smb_dev->ib_dev->ops.get_netdev) {
+				ndev = smb_dev->ib_dev->ops.get_netdev(
+					smb_dev->ib_dev, i + 1);
+				if (!ndev)
+					continue;
 
-			if (ndev == netdev) {
+				if (ndev == netdev) {
+					dev_put(ndev);
+					rdma_capable = true;
+					goto out;
+				}
 				dev_put(ndev);
-				rdma_capable = true;
-				goto out;
+			/* match physical ib_dev with IPoIB netdev by GUID */
+			} else if (netdev->type == ARPHRD_INFINIBAND) {
+				struct netdev_hw_addr *ha;
+				union ib_gid gid;
+				u32 port_num;
+				int ret;
+
+				netdev_hw_addr_list_for_each(
+					ha, &netdev->dev_addrs) {
+					memcpy(&gid, ha->addr + 4, sizeof(gid));
+					ret = ib_find_gid(smb_dev->ib_dev, &gid,
+							  &port_num, NULL);
+					if (!ret) {
+						rdma_capable = true;
+						goto out;
+					}
+				}
 			}
-			dev_put(ndev);
 		}
 	}
 out:
-- 
2.25.1

