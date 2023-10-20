Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596D2C001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Oct 2023 13:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377137AbjJTNC0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377017AbjJTNCZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Oct 2023 09:02:25 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF2FD52
        for <linux-cifs@vger.kernel.org>; Fri, 20 Oct 2023 06:02:24 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-7781b176131so43498685a.1
        for <linux-cifs@vger.kernel.org>; Fri, 20 Oct 2023 06:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697806943; x=1698411743; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqr/IfBPbWeTzXE4nfTrstYhZrHavbloeFU7CwdNtnE=;
        b=GhPjHXs6cA4wJGszigvVFsVvcYPTBKGk6DBlQbHZicGPguXDwbhoPTZLLoj637fCKG
         E15oGaLZRmFE5OeBMD6JOiwPQhI+Jnhy+8bxJ8ulGJVl/2xN5Qox51YAew6gU6N+tstV
         hQAJQ3Aumzrfdy/ldzgyxDCGv9hH8wz49u3h462IQdYv9Qai+MiJZB8fJta+/EJdppUl
         35ePuyuABKixh2DTeZnyRjWeypNMKSkphG/0+W3H/Smw21fGREXippY8CvVfCfNjez4O
         saShamqP3FxXqHfNjYHIuk+YhD4LQx28hCSl4Xaq/NzOLfmnrEPy2MsvXTmPtAj3hGpB
         oYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697806943; x=1698411743;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uqr/IfBPbWeTzXE4nfTrstYhZrHavbloeFU7CwdNtnE=;
        b=l7XVgXLrx/Eq5dpkRtjMsUakdsA4TDDX0M/Iwp77dP5ga0kdWgo0qctMZHyaUFBH9W
         IsmoPSimMJe1FtWIGQGidrU1VTY75MkR0xWiPugMdQJgfO13uhTL8OuWrFLlCF8UjlLz
         Qythz1gl9dpKD4QDZIuUltbf+otj5Q9e3XV2H67WR00exMct6Z16/xFBXAduX1fE9ebD
         2AKLJCHEaEptneq0AJaC0awvZTvPn9fLXyV5zHDV5WAXEPkXq1oGUKAl7lcqfM/H3a8i
         hqtyOv57TY2wSbuMKIQ6ycWgy8FP6U4wG/Mr69/uj8wxRfIcGfk6Cy2jdrPrNT1AvKO5
         SqHg==
X-Gm-Message-State: AOJu0Yw4dDj0dhAztXbrCx1hmaMtdoHqYHEjpBnHeA+Sh6cqUhSm40p7
        8Kcxas61ZDiBOn3Ns7KOVpQcvYFEmd27G5enUg==
X-Google-Smtp-Source: AGHT+IHKPVj3QxakaMi+O8AVdXtlnIHn6eJxpQG+nALRIV20QucnPW47OOxiq6ZyidJpwkNdqwD5rw==
X-Received: by 2002:a05:620a:3189:b0:778:8fa5:41b7 with SMTP id bi9-20020a05620a318900b007788fa541b7mr1953308qkb.53.1697806943216;
        Fri, 20 Oct 2023 06:02:23 -0700 (PDT)
Received: from ?IPV6:2607:fea8:1da0:b84::e1c? ([2607:fea8:1da0:b84::e1c])
        by smtp.gmail.com with ESMTPSA id d1-20020a05620a240100b0076e1e2d6496sm582790qkn.104.2023.10.20.06.02.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 06:02:22 -0700 (PDT)
Message-ID: <6d41a4df-e0ab-47e5-a476-f5b6620bfe8d@gmail.com>
Date:   Fri, 20 Oct 2023 09:02:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        huangkangjing@gmail.com
From:   "Kangjing \"Chaser\" Huang" <huangkangjing@gmail.com>
Subject: [PATCH v2] ksmbd: fix missing RDMA-capable flag for IPoIB device in
 ksmbd_rdma_capable_netdev()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

v2 -> v1:
* Add more detailed description to comment
---
  fs/smb/server/transport_rdma.c | 39 +++++++++++++++++++++++++---------
  1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 3b269e1f523a..a623e29b2760 100644
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
+			 * check for matching infiniband GUID in hw_addr */
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

