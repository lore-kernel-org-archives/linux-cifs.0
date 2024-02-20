Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10306BB20
	for <linux-cifs@vger.kernel.org>; Tue, 20 Feb 2024 14:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708439178; cv=none; b=l8989HqF0+sMPLsV/V1Ja+AOMAMGK6V4uTHAu9I5PGCloBb1PFjTnpt7RMG9ILWqJsB9cGfqu/RHACOzwWFflm5V1zCVf9fywGVDLoQo94kQc2uzPwQQCkaguD2B4Hjusrg+D+yVBNoU7iv7XATexd6BYU2X8tUuguJQzcnamRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708439178; c=relaxed/simple;
	bh=mo0J0MK8kDQ7u/7TXU0aK1AhgXZtjEnG21hh3OT+g44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GuRKVyzrHWa/tu9Eh9hpnyXRE07ScWawhiOwf1TYYYsZ8rUtqQnLrh93glYux0Jfo9s1kmhu3638iGNqfMDB8jmz2okwhwPww1k6kJEFTrUwZdinaXf77Tob9SUc+5xKq/utxLckQ1NblH4qHmRdNYwhEqMidgQf1aNNfa/6/mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=Vb/1GkD+; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="Vb/1GkD+"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4127109694aso2604685e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Feb 2024 06:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1708439174; x=1709043974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wtzBkAUMTYaH7FYNxIrVrmZdGGnTJtxK5qi7phDx8s=;
        b=Vb/1GkD+cm/jvQU7dhIwi/+SLhltWfqIN1uv/r9/tsMcuHD1tqtXSRe4LaHmzpg+8O
         jRVFK21wAw+QBalK8YOEUlzp3iC9+gwregIG6jnXySniwE+GYT2hc0mZ+PtheQWY2KZI
         2TAdj6EBXdEldkByXJriWJvbXQsP75rpgqpEVTk5dY7Cbqj7zLz1P+FKG8QFYPVdAN4u
         o3DktOkEZI0uT3ap+fFslYnewjg6oZk5IC1P7gzIkMO+jShsvETRsfmkzE7SH+totMAC
         xuvRzUxrMT/o6KBqAD+5UNfzJ0KJ/7TWcdeh0r2Xj6wGbuc7qcK2vMlka+Enq9GxGPeM
         vEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708439174; x=1709043974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8wtzBkAUMTYaH7FYNxIrVrmZdGGnTJtxK5qi7phDx8s=;
        b=EBRyP214vqRt4lCJKbjlJaXzV+yQcFiKx2KXSgel43xtUl7Vc0dTJyhv8l/yxcM7ua
         HGgK4atZj0r8LhsbPey4Z8sAJ684wD4Dp3WvkP6VVO0gfgvNVvSLFzz9ozSCd3e2+Tlp
         Ftl/5Yjc48wq4gRzc3pjp8B+kkqubrZvkHiw/lO2CGrbNk/pSSKEAmk90dFZootB1rsT
         wLv3kqQ3OpYdUWP8l1It7WM+btQCeLQYhC75HunUPLAK8lQzWFO9s1NwG4lBpc9PsRDc
         ceT/TBonNOcKjwHTcRcNTwcL+s+csvyzNi0zHAE/EYjEeHAZYfNKopAI8WqGSCWvmcQy
         2VRw==
X-Gm-Message-State: AOJu0Yx2N6ye2amL08nhxfeHZXIFyDqET+jNfehf/aqo8jzklSBfv7VI
	A0sDUY1DzX3lf6xFMinIK0Zy3GgsVm4PT56QQEnxULkr0aEtbM/WGtqtZu5snA//B7NHb40/8IJ
	S
X-Google-Smtp-Source: AGHT+IGCVDM5qS4BkhVXLcIZEM5j0lh3TMRNe7ttV2Ax7VW2O8mPyJIkacq5wiIpk3G5t3KNuRLc/g==
X-Received: by 2002:a05:600c:46d0:b0:410:3ffb:87dc with SMTP id q16-20020a05600c46d000b004103ffb87dcmr10644623wmo.35.1708439173878;
        Tue, 20 Feb 2024 06:26:13 -0800 (PST)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id f8-20020a05600c4e8800b0040f0219c371sm15028432wmq.19.2024.02.20.06.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 06:26:13 -0800 (PST)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org
Cc: Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH 2/2] ksmbd: retrieve number of blocks using vfs_getattr in set_file_allocation_info
Date: Tue, 20 Feb 2024 15:26:01 +0100
Message-Id: <20240220142601.3624584-2-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240220142601.3624584-1-mmakassikis@freebox.fr>
References: <20240220142601.3624584-1-mmakassikis@freebox.fr>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use vfs_getattr() as inode->i_blocks may be 0 on some filesystems (XFS
for example).

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1a594753f606..f4de2198b71b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5812,15 +5812,21 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 
 	loff_t alloc_blks;
 	struct inode *inode;
+	struct kstat stat;
 	int rc;
 
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
 		return -EACCES;
 
+	rc = vfs_getattr(&path, &stat, STATX_BASIC_STATS | STATX_BTIME,
+			 AT_STATX_SYNC_AS_STAT);
+	if (rc)
+		return rc;
+
 	alloc_blks = (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> 9;
 	inode = file_inode(fp->filp);
 
-	if (alloc_blks > inode->i_blocks) {
+	if (alloc_blks > stat.blocks) {
 		smb_break_all_levII_oplock(work, fp, 1);
 		rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
 				   alloc_blks * 512);
@@ -5828,7 +5834,7 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
-	} else if (alloc_blks < inode->i_blocks) {
+	} else if (alloc_blks < stat.blocks) {
 		loff_t size;
 
 		/*
-- 
2.34.1

