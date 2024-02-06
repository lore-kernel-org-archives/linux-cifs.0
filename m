Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4AC132C04
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 15:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707231658; cv=none; b=WkSODRDmfLOkUB9s/UD/wznYUz57C8JS1KIuQOz9EArRmas1flVUSPSf8l5ISozUR1jtqdaU2rQuPVgY58VIPVtcH72/k1mvbo+bzpSVeRcKRF9Z1jd7TxFYHCzpSr+g3MvewZd0VLDuKn+hhPrclUt60TjsM9hsQMkchla0vbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707231658; c=relaxed/simple;
	bh=VOjw6zdt6ysdHKlrSLJ9ybf1leA1AU4wrH8jwM5LvO8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=C82i2jrQO4Vr6tNzBzjE8+BOmL4UJZtpWi02ch92COoGaZiRo73g+kxMZ6nM/Xb5GKOmkobrt124W3HcA3zvj1VsReCRT8cIpykD3kNJGL4qvuXiGLine9dxRaJZ6a/XkypoP89oE1h7JVLYhFf8QS25/X/OVAqDZCH8Stf4fVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bJRCBhVZ; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bJRCBhVZ"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5d3912c9a83so4351217a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 06 Feb 2024 07:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707231656; x=1707836456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4qak/bMFK3ZZUXX1iYJGjyJFzWMe99xsH3fWn58J3h0=;
        b=bJRCBhVZfIS4Cu8+X0gbhEOCkKESXHyvHGvIC9Eb2u4kKqmR9BpdFHzrm/1c0bo1NM
         +syK8gGpt1HU9/eilJSqylVKQXUIeXGwRA0JOvZEFMPzgdwOFoqnT/f1N1XNs9U/srJZ
         psdZvQyBMWAx2JE02EZ/5Kp897XpImnNi0ohA4kSRBEe/ChzczYhn4NTgWPEQqPG6BGi
         tyi4MBiE/bbMjyljc5AWIuzWoiQTO/xFg5LHVKMKA6XPI26X1VMm1RDn4xFfnEF26nzx
         rEwDkvByq31xSothB3aQ60ZuplkVOZy0xwd8oKcXEZhFQxwMkjhHZbOm0C7c9WlYQw69
         vPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707231656; x=1707836456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4qak/bMFK3ZZUXX1iYJGjyJFzWMe99xsH3fWn58J3h0=;
        b=oy3pSP9BvFysEQuMF2C5CuuEY8kq2lfmqfFFu5eXfufq74qN18Kqyd3Mnsg+G16i+q
         ADVuZVVG4MuNmlTtz0N52aFh6/r0kuSzok6CEwX1b1oLr/rDa1QwwUX7C5lqj4YEITAG
         S9Y7sz9btrDocPN3Bvg/4KdnMkTPTEO2KYKhKAg7f2P8v2akdX/2HMRNmDpj2s8NH8jQ
         YWQSFicg0xNcumt6H7egIr5a2Sh8Cz3ki9kkquGpROcBIFyG7yPYmubmidP1roq/eynh
         j1cPid9LIFq6HUYk+R6GQNffOZQ+Gam8ht9TvJEp3T+S8xICFcdqvVvosEKLOtMjtWhQ
         VGVA==
X-Gm-Message-State: AOJu0YwEgKDs9aiOkclQPK9mg2koe/RgN8KOmF16TyaAXLc5eLgVHR7j
	JlQaCQtzkMljKPaoc0qHX0MrgH7XQ+jUIA0SuunrLk7oucD9fTlXJDVq1bTh
X-Google-Smtp-Source: AGHT+IEMk6L7RSFPmYV6vRvoJN9WHEo9jHdyStsg1H1cP9zS2JhoIBWYiISpRtPkxyU4qTnSvxk3bQ==
X-Received: by 2002:a17:902:e548:b0:1d8:fafa:f923 with SMTP id n8-20020a170902e54800b001d8fafaf923mr2430617plf.10.1707231655587;
        Tue, 06 Feb 2024 07:00:55 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCV7y6BmilRdA5kFta4ACDq4B5TAbbuaof6Y608Qo29exPLagEB6fpCpDtehGj8v6dnRKtuOuvoQi3iXwO5G9I8SSMt00YnGi0ZAcVzH9DZ/4eQJalW4DM9VjYLvj2nUGZXj75nNQhzxwRYuPXxlgWUBJJIpbxwgpntaqf9DLw==
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id mp7-20020a170902fd0700b001d8f81ecebesm1963075plb.192.2024.02.06.07.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 07:00:55 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/2] cifs: change tcon status when need_reconnect is set on it
Date: Tue,  6 Feb 2024 15:00:46 +0000
Message-Id: <20240206150047.29046-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When a tcon is marked for need_reconnect, the intention
is to have it reconnected.

This change adjusts tcon->status in cifs_tree_connect
when need_reconnect is set. Also, this change has a minor
correction in resetting need_reconnect on success. It makes
sure that it is done with tc_lock held.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 5 +++++
 fs/smb/client/dfs.c     | 7 ++++++-
 fs/smb/client/file.c    | 3 +++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index c5cf88de32b7..28cacdd90bbf 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4230,6 +4230,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+
+	/* if tcon is marked for needing reconnect, update state */
+	if (tcon->need_reconnect)
+		tcon->status = TID_NEED_TCON;
+
 	if (tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index a8a1d386da65..449c59830039 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -565,6 +565,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+
+	/* if tcon is marked for needing reconnect, update state */
+	if (tcon->need_reconnect)
+		tcon->status = TID_NEED_TCON;
+
 	if (tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
@@ -625,8 +630,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		spin_lock(&tcon->tc_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_GOOD;
-		spin_unlock(&tcon->tc_lock);
 		tcon->need_reconnect = false;
+		spin_unlock(&tcon->tc_lock);
 	}
 
 	return rc;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 6e53657154d6..d068e2a962de 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -175,6 +175,9 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+	if (tcon->need_reconnect)
+		tcon->status = TID_NEED_RECON;
+
 	if (tcon->status != TID_NEED_RECON) {
 		spin_unlock(&tcon->tc_lock);
 		return;
-- 
2.34.1

