Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D327E1BC5C
	for <linux-cifs@vger.kernel.org>; Mon, 27 Oct 2025 06:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761547893; cv=none; b=PM/y2sf5fq5/SZnvT18LwGapxscmCk4HSmpBpEaiT2qOfOTZccM+o09NPGPCD4YfWWqIDp8bsNcDRZkImr/hherHUFk04YllZkmREXD28c34CsTAQ0tZRbfhwVoU7nPjQ3/kl12d1XYiaxjJjmvsM4lNgl3yhDn9VWT1c+q6/Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761547893; c=relaxed/simple;
	bh=c1bT0oGXVh4/ZmbVDxRoEM4py1uhr2C6wei9wtE9eu0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eE/+Zat87zUl8ke5XgrEwqTTotdVvmBvuSAgHzmfjVoZ4D6FDa7CyxyvVCpjqMrSveiXeZpumzhA4mecO6NryldnaZH8DpP301ViAZCXXFCRyxGcZ1Xf4MLAFqnx4DxikWhv7MnRbTDzzH8lgNVDzQk0q9DY49hTGqun8hPscFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-290aaff555eso39352965ad.2
        for <linux-cifs@vger.kernel.org>; Sun, 26 Oct 2025 23:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761547891; x=1762152691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=waj34cuLia3dShfxRASOcTefmC9PDC2uOuNOB0Z8KEo=;
        b=Ftqi0iwFICqm3v5fChvt2GPIbiYA3NV5eX5YqGIoTQLytjadAsoGErc4hGgt7fjwt2
         ktgJtZ5an3tHzJ22XiPJTXtrZK0bikaXN2TEnSWEIjwjTKcsL6bvzrBhRbGAvADmQ0gF
         HsATnWz/goghDzkXgF5BZ3k+Yhs663BgaQLhGDtiaQ0JyerIYBJjAjGWEyxC8oFbEUvi
         lgD/OuYAHkI7/V6XBbi9drBlqfvrtb4FRdLOKciAge7nuMaYkI9jz1xGaggMZY1fl1pq
         QfwHaKucTL7bglH59t59GCO+hfRXThVvCb9Rgp+pMsLywX4sn5xipnQ/IJ0wSmTwWCo0
         WdIA==
X-Gm-Message-State: AOJu0Yxmjwrqe+iNWDirlHuQTmEfnyiBegAKxY50gjly4CdmZeddvVdx
	PCXKlhAG0J4AG5iAkKA+PdxRn9JXKhhD62BJR5BfWmsluGWxYNSIrRKhCoNMFw==
X-Gm-Gg: ASbGncsGnL5JOn+QJvyx/l4lIkCaHDFJBtFnjwBlg0NScZaSlSZJdLd/QPp6iKy9/FP
	F4A0GC3Sd2F5uTmocHDDDkXvLLqLeDdpxNULOvUP3PABfPC5gaS87birQuZyRSFHJmXYq7m0fZi
	Zbar9MhHrmSiICcKVWMj8dB1DBIANzy0GI5eFKpWw5dHRs6p2FaFHVIySPBh+jVihKoYqEZcG/T
	wNiIaNHyYMWilE+aDDTtLgqpTNy8DIISLnAxTpBwVlqAPjpQhRG505g1tMZYrCv/CdqAzFUFAPs
	i4Um2PhTB7n9PLgQzF1taB9/oqyLzKkJXqYlw8y4/gkGOeXw7nxxQ+eo0LAAHGNNjgO3D7vdKxK
	V63yLVkyUJppc8/KN42Izom8JhqsVoVD0fgFIIeQNpKH0/2J9QPkxPjk5I16qiyRfVORPvAx8aG
	gNsi7m2qDZL7UlqblBEbHn9d7yEQ==
X-Google-Smtp-Source: AGHT+IEuI9FATl6sAzlGukZSKJ4g1NGokGBvRB48wvy0iyCo8LoHXhHahu/fgIWnLv8Et6gSuzpzcg==
X-Received: by 2002:a17:903:244b:b0:290:9a31:26da with SMTP id d9443c01a7336-290c9d31109mr453187755ad.16.1761547890635;
        Sun, 26 Oct 2025 23:51:30 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d47ffesm71362095ad.87.2025.10.26.23.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 23:51:30 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 1/2] ksmbd: detect RDMA capable lower devices when bridge and vlan netdev is used
Date: Mon, 27 Oct 2025 15:50:52 +0900
Message-Id: <20251027065102.12104-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If user set bridge interface as actual RDMA-capable NICs are lower devices,
ksmbd can not detect as RDMA capable. This patch can detect the RDMA
capable lower devices from bridge master or VLAN. With this change, ksmbd
can accept both TCP and RDMA connections through the same bridge IP
address, allowing mixed transport operation without requiring separate
interfaces.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 7d86553fcc7c..4a8aeb1df0cc 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2606,7 +2606,7 @@ void ksmbd_rdma_destroy(void)
 	}
 }
 
-bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
+static bool ksmbd_find_rdma_capable_netdev(struct net_device *netdev)
 {
 	struct smb_direct_device *smb_dev;
 	int i;
@@ -2648,6 +2648,24 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 	return rdma_capable;
 }
 
+bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
+{
+	struct net_device *lower_dev;
+	struct list_head *iter;
+
+	if (ksmbd_find_rdma_capable_netdev(netdev))
+		return true;
+
+	/* check if netdev is bridge or VLAN */
+	if (netif_is_bridge_master(netdev) ||
+	    netdev->priv_flags & IFF_802_1Q_VLAN)
+		netdev_for_each_lower_dev(netdev, lower_dev, iter)
+			if (ksmbd_find_rdma_capable_netdev(lower_dev))
+				return true;
+
+	return false;
+}
+
 static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.prepare	= smb_direct_prepare,
 	.disconnect	= smb_direct_disconnect,
-- 
2.25.1

