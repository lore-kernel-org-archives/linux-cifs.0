Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AAA38888E
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 21:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784755167; cv=none; b=NgXL+I75a1wEsuE+mnGtGQis/klKy5briquEKJOSlAhPeaYej+JXUqxe4F8f6qNFIv58BxJ1PHRtFko6+1d3yM1BLQrPSSYXkspLZgpA1nFPetksqv+XtC3GKOedDJyukCuBlWXZJXZkabtMRA8py7HnHlaG3I2uM/iJwqPXSN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784755167; c=relaxed/simple;
	bh=ITzolcpIMBuzUOPvnVF4ZBfqeKqYJQMCDmsuVt5zkH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qk9OhXeIcPQSBec0VyAUhD6iXi0/siOq3ye2Bud9VMjYE5yc8ovXJxU4Xac9MYtLFvxYn87GhpB6mUCJAE63dO+yObkgH82PDDZ4UQk/4laWydTskVGjrWoFQOohsiq8uz2tehyNs+Xd6jSbiGCFS6/H0+fxzlJsJcuAb+AwGSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OsC9mumT; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsC9mumT"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5276d598b96so14491981cf.3
        for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 14:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784755165; x=1785359965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TdcUSi1b3fYRxK7MI3OBkktNKaCV6JTuFcRzmXe076w=;
        b=OsC9mumTV54CGpc7mU4ubDrR7s9FOwAxwTN3bwFCLm1IOMQVgwEqzz7dT/YnmNs7q6
         vktnxSjLKB71Cyp4lzysL3LaBxAVqB5D9uyu/moZcuN5K6dK1Ww18/L106yBmNAS9su5
         FZrSVRkPsu1QS5qQXdLnfi4wS9IiDKeZfaL2GigEpfG9orn8DPnVw3k52gRbpHMhfm/e
         xy1wqzI+Gmem41YVODrbJ/8OoctbsgbR39W4iUbmjHAzPYB38g7wkrVgBG3E0XdzS0d0
         mPINlp2iwaKul+K1G7bTd+JPdtVB9Wt6Km5B2XJ+O0d3xpWI6WjxyeBFSsaDOxEufASF
         3hAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784755165; x=1785359965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TdcUSi1b3fYRxK7MI3OBkktNKaCV6JTuFcRzmXe076w=;
        b=kd3ceWrLaSHFKTUIH5FopDUbRAUgdACivDJczLz0QoPYhrS5qe2pYfWeKw3aNts8Vh
         EvhFA8/zLLNRDRP/591O0y9KhLiMRFQWx406uIx1Eev77BbQfclWehOm6EweCLG9Tkq2
         7+eTRHOK1h6MDZTbuq/LypEl0kRaj+7Vm6AwXhWHQL6UThF4oH2Z9ykTqRLz6S6jO42j
         /oqbY25af6+MrF4Yj7cedGDn2wMOaiFBnf1Uo/mYzTrcrX0/6RVIiP+7w4isqfEAKv5Z
         NqVTZUmdc6aF8HbxPwHWcn7c725bZH57nnG4KcWDtIpIcfBgpxTsC60yxbj0jj0z7Heu
         sXmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp9+I2VJYxEOPdIShvroAyP6rYpMYVrdz0pAdh9MehKfjvLDULf8nQG4U9g+z0PcZEi51BMF0yIJYk7@vger.kernel.org
X-Gm-Message-State: AOJu0YweHJItSR6myL2bhm9c1xCzPp4MNukA04X4ueGPS07o1fEvMDbb
	RP3RvOT/6Fe492FikVTOW3SfJpgDIo9m+24xAowyN1qRpRPRK8CbliKJ
X-Gm-Gg: AR+sD120EKM58bRY1zH/i9MyB7NS3gy8l0WGu8m2WQKPH7E3hd4k3lP27SSiqigPZuG
	ZtL6GC0oB0Cx5aUDWwJcavWWzz9qMZvrYa0K5PazWfoyQzFdbJSSPO/ATBAQ+OHLY0Qvf2BsOiL
	Fion9JuwALZkoI8yTPelBxBHzGTf0Ej9OdFpywc01Wy7SfObJ3YFoaDEN0W10Tczd4OxlX/ih+Q
	YNOOoQrSQs6yKE+0E73vkZvjjom/9jIe6krpdyZRfk5IhbObsSsfG0TxH0oRoSunP7e8ZCK5Rh+
	Ewthc7zaZUgZaB791UFFZmrq7th6w79QlXsfnl8staZNHtmj56hyzMmyZsbmJCM0FwVsyicUZEd
	RQPK4JauLQDEpBDCe1WWYDjTO8k3JXHM+h81ANJEX+xTOJSr+OKWLg1DR2SQ0DBM29FQ39gFm0u
	x+RA==
X-Received: by 2002:a05:622a:5145:b0:51a:8c9c:7f41 with SMTP id d75a77b69052e-5283df50a2fmr2223291cf.68.1784755165368;
        Wed, 22 Jul 2026 14:19:25 -0700 (PDT)
Received: from FredPC.lan ([2600:382:311b:26:6a8f:2e2e:9fb1:8d6d])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d2e7662bsm22663001cf.18.2026.07.22.14.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:19:24 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb: client: use GFP_KERNEL for registry allocation
Date: Wed, 22 Jul 2026 14:18:44 -0700
Message-ID: <20260722211844.123697-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

Currently, cifs_get_swn_reg() allocates new registry entries using
GFP_ATOMIC. Since we lock a mutex here, this is clearly not an atomic
context. Use GFP_KERNEL instead.

Also, fix a minor grammatical error in the comment above the function.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/cifs_swn.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 9951817d0d7f..fe10719e627e 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -425,7 +425,7 @@ static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
 
 /*
  * Get a registration for the tcon's server and share name, allocating a new one if it does not
- * exists
+ * exist.
  */
 static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 {
@@ -443,7 +443,7 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 		goto unlock;
 	}
 
-	reg = kmalloc_obj(struct cifs_swn_reg, GFP_ATOMIC);
+	reg = kmalloc_obj(struct cifs_swn_reg, GFP_KERNEL);
 	if (reg == NULL) {
 		ret = -ENOMEM;
 		goto fail_unlock;
@@ -451,7 +451,7 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 
 	kref_init(&reg->ref_count);
 
-	reg->id = idr_alloc(&cifs_swnreg_idr, reg, 1, 0, GFP_ATOMIC);
+	reg->id = idr_alloc(&cifs_swnreg_idr, reg, 1, 0, GFP_KERNEL);
 	if (reg->id < 0) {
 		cifs_dbg(FYI, "%s: failed to allocate registration id\n", __func__);
 		ret = reg->id;
-- 
2.53.0

