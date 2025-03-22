Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174AE8C1E
	for <linux-cifs@vger.kernel.org>; Sat, 22 Mar 2025 00:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742603472; cv=none; b=eJshwDSjD4PBWf55BisJME4FcZ///SD2+lqYHiSDx236IhGhqPo/WxDCc+MNuOPyxKxvIEMO22Cvrn6BwinlqzD2vJva7dFHO8GeA49IHz0DJejsA+1/90xcM4XTnyl6Fo3CX/W93lOYHQEHurrwu4GAjbWW9R6h9L/oir2TrmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742603472; c=relaxed/simple;
	bh=furaJPDy4Q1BBaQzF3hmFl4pehFxbguqXOmJG87xEs0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TsGREo+GREp7Vpiv4UbHOXcnLbHDf0fAN8x8lt53PkHjgODs/GAGIOjcK72aFmQ6p/lMEjCxtDTwcJ4wCiRfG0446R0K5VM9BBhIegVHsku3C2ywErK/D6XhFlL7bTprXUM5nrQRY6fDmSwfV6KTL2LT6PqkGMxexD+b61qOEUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-223fd89d036so50297865ad.1
        for <linux-cifs@vger.kernel.org>; Fri, 21 Mar 2025 17:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742603470; x=1743208270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9rkHMFKHtXqBpyl1PVhmbeuZXcZ8uNnZcBQCl52ThqU=;
        b=inIMyuu58fC5X9e7MI3F7u5wtpCWd3FP6a0U3SFGee0KgynymGYlvva4kRuK3hD4Wq
         RgeJPcdc2Ln86L2OUsI8Uy2mFGsmk6g2OFUsaoAD6MXusLMho4/E+nCcxxTOvbdLP2ML
         HVr4HyGauBJb1kYcLyw8rGAUjD+0MCiHriNgDHuAc78DnyDECywB/CAaclEjqnIL8tbG
         pR/RntDJod/ic6je4bjTX4ENrNMCSmXdxkHS/eHj1AQU5C79SEJpgUX3N/j3szZH6XBr
         L1Sb8CuyCE8HsHW8jwiji0awzsuuDWVAZvxEnFpoPICbVEm3Ri09DmPui3cCoisKiuPk
         tIhQ==
X-Gm-Message-State: AOJu0YwfSTjJC4/mIVdqxRYXdCffGLu9FfjnOqO+aKV1ufAxADQHlexb
	qS/AkWCTMhbSNOMI32gOsaWOaRMSFEXX1IuUZOlDEGEFPa95UayGNB3SFw==
X-Gm-Gg: ASbGncs1HzLVfTbcMtHVgewLEWHmrwnzO1ByWMesJuj2JiFjuX2WyVlWKnbNvUNkks0
	0ZIy3DRY7F4LFA/TCKcrb0ryKpjUKFrmuVQpiY4vRg9BuroCcQ6BZFMpcIVHEBQdCOer7N42MxN
	EUUK7EeSX9v1VRAB+b8PZ0gVl7HfrrBgjklYWzlc0t2vnD2RREFHvSbcT7Kqz4fLBr17hbPtckt
	AQm1BHifcfopke0Epj8azsqqm6bXUW41sELm7T7ePP6iLMwgOw6rK3E1JagQ1SJqw911O/urTOj
	P9JXX/PK2pRAqO9PZAlsNX+mSUEsCMk9roKh3F4ZUH8ZK9sd1P6wcyLMcIo=
X-Google-Smtp-Source: AGHT+IHOWx7xf4cSIV9kTiJ2XLohO9JN5ezt9NKAqUvyBjEU6XWxe5LIEdiaPqWl8iVSfiuXsR6oTg==
X-Received: by 2002:a17:903:320b:b0:224:10a2:cae7 with SMTP id d9443c01a7336-22780e42056mr95958435ad.40.1742603470074;
        Fri, 21 Mar 2025 17:31:10 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf61a68dsm6886096a91.39.2025.03.21.17.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 17:31:09 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] ksmbd: use ib_device_get_netdev() instead of calling ops.get_netdev
Date: Sat, 22 Mar 2025 09:30:54 +0900
Message-Id: <20250322003054.6500-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ULPs are not supposed to call to ops.* directly.

Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_rdma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 9837a41641ce..4998df04ab95 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2142,8 +2142,7 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
 	if (ib_dev->node_type != RDMA_NODE_IB_CA)
 		smb_direct_port = SMB_DIRECT_PORT_IWARP;
 
-	if (!ib_dev->ops.get_netdev ||
-	    !rdma_frwr_is_supported(&ib_dev->attrs))
+	if (!rdma_frwr_is_supported(&ib_dev->attrs))
 		return 0;
 
 	smb_dev = kzalloc(sizeof(*smb_dev), KSMBD_DEFAULT_GFP);
@@ -2243,8 +2242,7 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
 			struct net_device *ndev;
 
-			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
-							       i + 1);
+			ndev = ib_device_get_netdev(smb_dev->ib_dev, i + 1);
 			if (!ndev)
 				continue;
 
-- 
2.25.1

