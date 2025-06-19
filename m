Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB27231852
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750347383; cv=none; b=MyZWVSGr5EFLbmLFKxGRBrByvkKNCx4h3QWisx1m8yOyT02IwTDROJy3v43Y1sYz03BNPEOLwBGqZkxf2SleKd/RUTxTNml83xJAjRnKYWSa4l1yb03LtssH7r8tfQBd6qgpNDorlvDrUIuUX7oajFeiR/kXzhRGkM//eXbcwxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750347383; c=relaxed/simple;
	bh=i08G6XxFX698LTQopL3CS6LfdAPwWG6PNHnY72RvNzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AM6kuJaUs5FKMFTRVPS4OpKnSl+t5OR82wsmZ2UJ9Qvz+0CXKKd20QaAdqfowjiOcUDC6G+HLrvsUrxJ7aYsRZdfmuZD6uKA5RYRW5WOZKYnrn6gpSK8IbTu51Vq+T/v3+LVzeZyHL0O7DL8Idb7Fead9qU9f4eNYnC3NS6YENI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CcVvuC0B; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CcVvuC0B"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-747e41d5469so850595b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 08:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750347381; x=1750952181; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jArwfQnuzA3I5dcOvgPmxM9YVGZwzEZcMG9aXRb7zOs=;
        b=CcVvuC0BpJPUp8HAF/FADiWqy5mFiH6dHBR52bEtniefZaAVOr+ugvR6kddDCZjIrX
         8wb9LAaFZYYrlYLKZYjM+f9YHXHtS8SaHB/KE2PUgbeH7C4CWs9mILUx59gg2qa15re4
         e8X3umaWRTSisUtJhfrbzt2/281IJvrErf9qhm/maAR06Y2zK3m7qu2jqazDUXyzZkKE
         UAs7rrCt7dDjDHNDebyUs1tMMoHOblJmqAUySJ5/TwGNso/BIV8QRJXsTw5DddV5P8xk
         3h+7fALz86pA9ygBS8fRmCqWM2u4SYvjkwHBRLLT1IM1M/PhD4dgdsUpcdNhDbRGk0Xv
         2rrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750347381; x=1750952181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jArwfQnuzA3I5dcOvgPmxM9YVGZwzEZcMG9aXRb7zOs=;
        b=WD18v90yukkG5UB3LVU9xfefwkiNI/6QU2NDBhPuIM4MaHSq+r6B0f9TmWlSXKPffI
         uDH+C0Rnoho1eaMYmAQ/74DVry7g0qm/1DbOVKZWNInWfBX4J826Kf+cNhsi4mS0a+Md
         3UsXyFgR3tKNvhWBPfcC04evyQiScOyN/uHXWuqGJ37EKRozi+YcMtsgq8WpkcKSp4ov
         oqtC0qXS0qtvCLjfz3uAkb7P4wbQUM/XuwLWPq7B5WBOpbuXMXSR0gGisuA2mLcyG0lw
         9P3FIxHeUZ5uZv19UE3ry4AjCAZnqEyxjOZ33P6E5b6X5BiJWB66ZSkoO/HqtdI1kDL6
         Rg1g==
X-Gm-Message-State: AOJu0YzBCMd+EQmnTE8FnJ48UNmXS9kP0GiB0LYzE9C8wkJE10GU8JnF
	3IHRSBhtpz2zZBCf/gjIe6VMbzr742qF8/OPEz37qrBL7BI43yFZZvCwHLuz3QT0
X-Gm-Gg: ASbGncsDaL6amLKzqf3TWq9HK2Zly/dld0vMqlToos5jC4EN6TXCE1H6oVPKxOHRMFu
	TPK/FnvQpiCNCyeENgrq1zJ2xO06DE+tVlALiUS68/7QvN5n2tlwqhoVK6JvYqfhKv6OihnZ1VE
	5bYeBwm66/sycsRVsyZprKBbT5AHjCKwv2pZlJKh99WRMurlDKcKM1MggGuQKaj+m2zZ7jBjj75
	N09Akbr+Kzs3kLVWheaVBjfa/D8RA4OzPV+jV8kQDJwbEiSaKJrD0ZlOFILkJRr7YlhLzP70X87
	ZI7wI9dcsD27bPgNh3p9mI7afAU1hY1ujOMYMO+Uthwj53trrGKSg+iX/Xr53crEp7DidTUSJKJ
	RBMBpbRTCI/8j
X-Google-Smtp-Source: AGHT+IG2kSBkrnyhIQRQNpLOMPG4k01ujUrfzNmMQLEYzPU4jBqFeaO1FSV2iMNRIYBEiGx2uBJqRw==
X-Received: by 2002:a05:6a00:4f88:b0:747:ee09:1fd2 with SMTP id d2e1a72fcca58-7489cfcb1d3mr31198258b3a.12.1750347381086;
        Thu, 19 Jun 2025 08:36:21 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.253])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7490a46b574sm162838b3a.15.2025.06.19.08.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:36:20 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6/7] smb: Fix potential divide-by-zero issue when iface_min_speed is 0
Date: Thu, 19 Jun 2025 21:05:37 +0530
Message-ID: <20250619153538.1600500-6-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250619153538.1600500-1-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Address potential divide-by-zero issue when iface_min_speed is 0
by adding proper handling to prevent undefined behavior.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 2 +-
 fs/smb/client/sess.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 3fdf75737d43..bc56f315e2e0 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -599,7 +599,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				seq_printf(m, "\n\t%d)", ++j);
 				cifs_dump_iface(m, iface);
 
-				iface_weight = iface->speed / iface_min_speed;
+				iface_weight = iface_min_speed ? (iface->speed / iface_min_speed) : 0;
 				seq_printf(m, "\t\tWeight (cur,total): (%zu,%zu)"
 					   "\n\t\tAllocated channels: %u\n",
 					   iface->weight_fulfilled,
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index ec0db32c7d98..697170be6591 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -218,7 +218,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 				continue;
 
 			/* check if we already allocated enough channels */
-			iface_weight = iface->speed / iface_min_speed;
+			iface_weight = iface_min_speed ? (iface->speed / iface_min_speed) : 0;
 
 			if (iface->weight_fulfilled >= iface_weight)
 				continue;
@@ -387,7 +387,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		}
 
 		/* check if we already allocated enough channels */
-		iface_weight = iface->speed / iface_min_speed;
+		iface_weight = iface_min_speed ? (iface->speed / iface_min_speed) : 0;
 
 		if (iface->weight_fulfilled >= iface_weight)
 			continue;
-- 
2.43.0

