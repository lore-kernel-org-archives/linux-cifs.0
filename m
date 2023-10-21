Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926EAC0032E
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Oct 2023 07:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjJUHmX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Oct 2023 03:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjJUHmW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 Oct 2023 03:42:22 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA806D70
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 00:42:20 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-66d09b6d007so11472226d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 00:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697874140; x=1698478940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jmmaZAzaLOmtXGk7S4psyAS16yA14QyEkiFSwJwm14U=;
        b=Rs57AIW+AZEq0souPToNI4IN94urS29J2H2aLW+UVM3J6p4wMsuKsfIAwlYYQXAdsF
         W4F/LskYJB7bRhVb0B/XPcIi6wMoiKBrU7h2hkfLNmkB6isV96EsdtMBq8YBjcqnGDL+
         RYWGa1o26JyIV21TQYcGwvlVWjP1wPqR0HD5hGm/5WHc1hVX3kT6PGN2mfLWzGRLflxw
         TqV1d5+t9AJgMZaqVmVGmNUkcbCFRQjQ8RbMYeske74TTlEtckOwt6cFX1KUZU6TRrwz
         /qb0lfGKMmPi6Qddg6AGJUB/8wQa5jVzaweZfL4wo5sM+HGKAqbC4ZrIEScLzifkZVWa
         9LTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697874140; x=1698478940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jmmaZAzaLOmtXGk7S4psyAS16yA14QyEkiFSwJwm14U=;
        b=CcZJqISta8qs+ks0uEMlK5ek5ZukRX0ywyuw6qkyjGHrQPG3+KNlrdvKechChzSC8Y
         oIiT9PKAReKh4rFbHRhxINzW5pfAQQYv0zsOQ5mr2+nyUVuE4Si6ic6stYSjETcIEBP1
         UQSsKTK7MI0SFKfWkKSHUWTcytf0zGBA3464IjJ+4gqaBDF28RebxMrmbfKULeauppvY
         qay5FRFZwujg5V7/gSxEZqC6nbXJWxcHGkLupMbesI0RUliQeOw4LzVGRUJ50eOJk7kk
         KpQ/0WzHBi/swILM+HRTBIJnUErenwNk4qxCRqf74H4sT9d3HusD+LNHMGqcYSlxWgB2
         vpYQ==
X-Gm-Message-State: AOJu0Yw93d/BnUFozD9wxv9K4oVGokHPOn+iemdjascBAAVxOHK9qZXD
        uoJ+yTFaC9+Vc0VqtVnsc+f5bTbGWT2iHk0H1Q==
X-Google-Smtp-Source: AGHT+IGhaaQ8JkK20KZMm6crRESAZPDrYE/NrGnAAT7W1lSibjZWZs0ZRgw5/h0FiOTT3buspCjKHg==
X-Received: by 2002:a05:6214:2465:b0:66d:1217:18fd with SMTP id im5-20020a056214246500b0066d121718fdmr4844712qvb.26.1697874139749;
        Sat, 21 Oct 2023 00:42:19 -0700 (PDT)
Received: from hkj-desktop ([2607:fea8:1da0:b84::e1c])
        by smtp.gmail.com with ESMTPSA id n18-20020a0cec52000000b0065afd35c762sm1313309qvq.91.2023.10.21.00.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Oct 2023 00:42:19 -0700 (PDT)
Received: by hkj-desktop (sSMTP sendmail emulation); Sat, 21 Oct 2023 03:42:17 -0400
From:   Kangjing Huang <huangkangjing@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com, tom@talpey.com,
        Kangjing Huang <huangkangjing@gmail.com>
Subject: [PATCH v3] ksmbd: fix missing RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()
Date:   Sat, 21 Oct 2023 03:42:07 -0400
Message-ID: <20231021074207.1066986-1-huangkangjing@gmail.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Physical ib_device does not have an underlying net_device, thus its
association with IPoIB net_device cannot be retrieved via
ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
ib_device port GUID from the lower 16 bytes of the hardware addresses on
IPoIB net_device and match its underlying ib_device using ib_find_gid()

Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Tom Talpey <tom@talpey.com>

v3 -> v2:
* Fix comment formatting warning
v2 -> v1:
* Add more detailed description to comment
---
 fs/smb/server/transport_rdma.c | 40 +++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 3b269e1f523a..c5629a68c8b7 100644
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
@@ -2241,17 +2240,38 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
 			struct net_device *ndev;
 
-			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
-							       i + 1);
-			if (!ndev)
-				continue;
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
+			/* if ib_dev does not implement ops.get_netdev
+			 * check for matching infiniband GUID in hw_addr
+			 */
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
2.42.0

