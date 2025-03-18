Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1101EB5FB
	for <linux-cifs@vger.kernel.org>; Tue, 18 Mar 2025 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742301550; cv=none; b=GvPyci5sRW4qerofL5/GbNT1TyUaIPpGNscWHpmPrpUnH86SNZiOQ2OFNMmB7TaX8ByIjFVoEuaYs3O2r2GQLleW12mXhBWC58UhF1d7RUovY+joxzVN7R0HP27j4oTt5w46XyIgh1zC8hGI4EBQFzZcx81HENJDgjCu+TWSUOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742301550; c=relaxed/simple;
	bh=Gni/hKt5lciXvNIj7D4VVPKydaax3uss3boRxJ/zf3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f8amGBtNDGC00/M5BBxSHI07NZy/VSSpTZg+7AQhdnq5wPI/1QuMuBYOltRBxn0Jc0mD+9eqUryoaGUzUaukRajc5OYYSiZZF5MreZOvR77vICuoqxfnOGOn7C/76YXogXU9R3oP3NUu+ByDm7tvFriZIb+5yLGVzVv43J+dITw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3014ae35534so4084231a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Mar 2025 05:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742301544; x=1742906344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oR6QSPLvl59TRhxtq4yNj2/Mtu/ImuGqKKpmoVE6sAQ=;
        b=BtHcUj8moOKeBGQQWAd1rRPcTbGkROpuIbvQD0hn3fk4BUCGsaIxXpER0DOM8ocE36
         TA9m5Yl67ouZIHdnhxWyinRd9weBCLrwxmKpPMG4I9I+hCzvRqLnEcgrrjNw8qboP08S
         M3n1rTfE+TVb13LnMfv8DJeldL31rc93YifLGHmbSLydDF4iX53G84BGoqCl1vA8lYoO
         iiBWRe8so7+5K+B8fJqRmVRPQ55G+SIGu+fHHWlCd+YYQwZn4+U5KGlx8ShZYGv3rriZ
         IUoqwfrrTEuRJnOR4Um9IhkQbYLsqD7bGxlPdlx/CDkWX2bB/qZJXeJcVghxrZKovEoQ
         +1Qw==
X-Gm-Message-State: AOJu0Yxe0aPdh2arzWJofWzHxrEmyEYOfluHsxFDjbUDHLDXb77KrBHq
	4eVfASpd0IZuLOw3MH59VbAdvpABWUhID2pWn/P4gl8Yl0MmJ06H/ZL5kw==
X-Gm-Gg: ASbGncuNH3h1aWX5XezFDXa3OWNGz2+0AEa94F7f6irMFLQYzKhJZTSvlardtGhv2vh
	xObtpporHcDqmjhU/W0lHqhxYqCH2eeZD52lcKQHeGZEyRVAUl6W47Fn4TVfRdg2JL6Xo74kIQr
	w8McQjK3f044na5WPShKzAsxHNOFJVtxOb55/t/RSYArwnMldgn6OA6lcOkCqQE4WhIvKKB3MAG
	+JVtcU+3CDg2ryuY1aLZQF+WwUfV9XCqR2PoRhxkvL3o4Qb3QA7H6WcVM50RpgS//yJQr38oIBH
	yLjjkVEp2MKuTFrk22rxIHW5tFuu/wBQdVdttIbrnfW63Vzs3JZkZcSNcgU=
X-Google-Smtp-Source: AGHT+IHiilynJbHODHmOU0QqfzinEO2GdrCaNqULPU2J9dZDN9P2vGrw7REWyBmbD/Nx5fAWDl0Gfg==
X-Received: by 2002:a17:90b:3b86:b0:2ff:52e1:c4b4 with SMTP id 98e67ed59e1d1-301a5bb0a9cmr2832273a91.32.1742301544515;
        Tue, 18 Mar 2025 05:39:04 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301539ed069sm8096279a91.17.2025.03.18.05.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 05:39:04 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Kangjing Huang <huangkangjing@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH] Revert "ksmbd: fix missing RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"
Date: Tue, 18 Mar 2025 21:38:26 +0900
Message-Id: <20250318123826.5406-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit ecce70cf17d91c3dd87a0c4ea00b2d1387729701.

Revert the GUID trick code causing the layering violation.
I will try to allow the users to turn RDMA-capable on/off via sysfs later

Cc: Kangjing Huang <huangkangjing@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 40 +++++++++-------------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 1b9f3aee8b4b..9837a41641ce 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2142,7 +2142,8 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
 	if (ib_dev->node_type != RDMA_NODE_IB_CA)
 		smb_direct_port = SMB_DIRECT_PORT_IWARP;
 
-	if (!rdma_frwr_is_supported(&ib_dev->attrs))
+	if (!ib_dev->ops.get_netdev ||
+	    !rdma_frwr_is_supported(&ib_dev->attrs))
 		return 0;
 
 	smb_dev = kzalloc(sizeof(*smb_dev), KSMBD_DEFAULT_GFP);
@@ -2242,38 +2243,17 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
 			struct net_device *ndev;
 
-			if (smb_dev->ib_dev->ops.get_netdev) {
-				ndev = smb_dev->ib_dev->ops.get_netdev(
-					smb_dev->ib_dev, i + 1);
-				if (!ndev)
-					continue;
+			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
+							       i + 1);
+			if (!ndev)
+				continue;
 
-				if (ndev == netdev) {
-					dev_put(ndev);
-					rdma_capable = true;
-					goto out;
-				}
+			if (ndev == netdev) {
 				dev_put(ndev);
-			/* if ib_dev does not implement ops.get_netdev
-			 * check for matching infiniband GUID in hw_addr
-			 */
-			} else if (netdev->type == ARPHRD_INFINIBAND) {
-				struct netdev_hw_addr *ha;
-				union ib_gid gid;
-				u32 port_num;
-				int ret;
-
-				netdev_hw_addr_list_for_each(
-					ha, &netdev->dev_addrs) {
-					memcpy(&gid, ha->addr + 4, sizeof(gid));
-					ret = ib_find_gid(smb_dev->ib_dev, &gid,
-							  &port_num, NULL);
-					if (!ret) {
-						rdma_capable = true;
-						goto out;
-					}
-				}
+				rdma_capable = true;
+				goto out;
 			}
+			dev_put(ndev);
 		}
 	}
 out:
-- 
2.25.1

